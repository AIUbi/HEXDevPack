//Author [HEX]0x00

CreateClientConVar( "wire_expression2_soundurl_enable", "1", true, false )  
CreateClientConVar( "wire_expression2_soundurl_blacklist", "SteamID,", false, false )

local clp, rnd, ts, char = math.Clamp, math.Round, tostring, string.char
local wire_expression2_gates = wire_expression2_gates or {}
local wire_expression2_owner = LocalPlayer():EntIndex()
local fft_bitrate_type = {[1] = 128, [2] = 256, [3] = 512, [4] = 1024, [5] = 2048}

--Pack fft table to string

local function wire_expression2_soundurl_fft_pack(tbl, bitrate)
	
	local str = ""
	
	for _ = 1, fft_bitrate_type[bitrate] do

		str = str..char(clp(rnd((tbl[_] or 0)*255), 0, 255))
		
	end

	return str
	
end

--Pack & Send fft to server

local function wire_expression2_soundurl_fft_send(send_table)
	
	local fft_table = {}
	
	if not send_table.station then return end
	
	send_table.station:FFT(fft_table, send_table.fft_bitrate_type-1)
	
	net.Start("wire_expression2_soundurl_server_packet")
	
		net.WriteUInt(send_table.expression2_id, 32)
		net.WriteUInt(send_table.channel_id, 32)
		net.WriteUInt(send_table.fft_bitrate_type, 32)
		
		net.WriteString(wire_expression2_soundurl_fft_pack(fft_table, send_table.fft_bitrate_type))
		
		if send_table.fft_attrib_mode then 
			
			net.WriteString(send_table.station:GetFileName().." "..ts(send_table.station:GetLength()).." "..ts(send_table.station:GetTime()))
			
		end
		
	net.SendToServer()

end

--Check the owner expression2's for sending fft to server ###SEND TO SERVER###

local function wire_expression2_soundurl_fft_check()
	
	local stations = {}
	
	for _, o in pairs(wire_expression2_gates) do
		
		if o.owner_id and o.owner_id == wire_expression2_owner then table.insert(stations, o) end
		
		for _, o in pairs(o) do
			
			if type(o) == "table" and o.station and o.parent_ent_id > 0 then 
				
				local user = ents.GetByIndex(o.parent_ent_id)
				
				if IsValid(user) then
				
					o.station:SetPos(user:GetPos())
				
				end
				
			end
			
		end
		
	end
	
	for _, o in pairs(stations) do
		
		for _, o in pairs(o) do
				
			if type(o) == "table" then
					
				if o.fft_table_mode == 1 and IsValid(o.station) then wire_expression2_soundurl_fft_send(o) end
					
			end
				
		end
				
	end

end

--Check blacklist on blocked users

local function wire_expression2_soundurl_blacklist_check(owner_steamid)
	
	for _, o in pairs(string.Explode(GetConVarString("wire_expression2_soundurl_blacklist")," ", false)) do
	
		if owner_steamid == o then return true end
		
	end
	
	return false
	
end

--Safely stop and clear the streams if expression2 removed

local function wire_expression2_soundurl_call_on_remove(expression2_id)
		
	if wire_expression2_gates[expression2_id] then
		
		for _, o in pairs(wire_expression2_gates[expression2_id]) do	
			
			if type(o) == "table" and o.station then o.station:Stop() end
			
		end
		
		wire_expression2_gates[expression2_id] = nil
	
	end
	
end

--Stop all sound streams on all expression2's

local function wire_expression2_soundurl_stop_all()
	
	for _, o in pairs(wire_expression2_gates) do
		
		wire_expression2_soundurl_call_on_remove(_)
				
	end	
	
end

--Create new cell in table

local function wire_expression2_soundurl_create_cell(expression2_id, channel_id, owner_id)
	
	wire_expression2_gates[expression2_id].owner_id = owner_id
	
	wire_expression2_gates[expression2_id][channel_id] = 
	{
		fft_table_mode = false, 
		fft_attrib_mode = false,
		fft_bitrate_type = 1, 
		station = nil,
		expression2_id = expression2_id,
		channel_id = channel_id,
		parent_ent_id = 0,
	}
	
end

--For create new soundurl

local function wire_expression2_soundurl_play(url, vector, expression2_id, owner_id, channel_id, volume, noplay)
	
	if #(url or "") == 0 then return end
		
	sound.PlayURL(url, "3d", function(station)

		if not IsValid(station) or not wire_expression2_gates[expression2_id] or not wire_expression2_gates[expression2_id][channel_id] then return end
		
		if noplay == 0 then station:Play() 
		else station:Pause() end
		
		station:SetVolume(volume or 0)
		station:SetPos(vector)
		
		wire_expression2_gates[expression2_id][channel_id] = 
			{
				fft_table_mode = wire_expression2_gates[expression2_id][channel_id].fft_table_mode or false, 
				fft_attrib_mode = wire_expression2_gates[expression2_id][channel_id].fft_attrib_mode or false,
				fft_bitrate_type = wire_expression2_gates[expression2_id][channel_id].fft_bitrate_type or 1, 
				station = station,
				expression2_id = wire_expression2_gates[expression2_id][channel_id].expression2_id,
				channel_id = wire_expression2_gates[expression2_id][channel_id].channel_id,	
				parent_ent_id = wire_expression2_gates[expression2_id][channel_id].parent_ent_id or wire_expression2_gates[expression2_id][channel_id].expression2_id			
			}
		
	end)
	
end

--For read user message and do something useful or not do lol:D

local function wire_expression2_soundurl_recv_packet()

	if GetConVarNumber("wire_expression2_soundurl_enable") == 0 then return end
	
	local command = net.ReadUInt(32)
	local expression2_id = net.ReadUInt(32)
	local channel_id = net.ReadUInt(32)	
	local owner_id = net.ReadUInt(32)
	
	if wire_expression2_soundurl_blacklist_check(Entity(owner_id):SteamID()) then return end
	
	if not wire_expression2_gates[expression2_id] then wire_expression2_gates[expression2_id] = {} end
	if not wire_expression2_gates[expression2_id][channel_id] then wire_expression2_soundurl_create_cell(expression2_id, channel_id, owner_id) end
	
	if command == 0 then //Play
		
		if wire_expression2_gates[expression2_id][channel_id].station then wire_expression2_gates[expression2_id][channel_id].station:Stop() end
		
		wire_expression2_soundurl_play(net.ReadString(), net.ReadVector(), expression2_id, owner_id, channel_id, clp(net.ReadFloat(), 0, 1), net.ReadUInt(1))
		
	elseif wire_expression2_gates[expression2_id][channel_id] and IsValid(wire_expression2_gates[expression2_id][channel_id].station) then
	
		if command == 1 then //Pause
			
			wire_expression2_gates[expression2_id][channel_id].station:Pause()
			
		elseif command == 2 then //Play
			
			wire_expression2_gates[expression2_id][channel_id].station:Play()
			
		elseif command == 3 then //Stop
			
			wire_expression2_gates[expression2_id][channel_id].station:Stop()
			wire_expression2_gates[expression2_id][channel_id] = nil
			
		elseif command == 4 then //Volume
			
			wire_expression2_gates[expression2_id][channel_id].station:SetVolume(clp(net.ReadFloat(), 0, 1))
			
		elseif command == 5 then //Postion set
			
			wire_expression2_gates[expression2_id][channel_id].station:SetPos(net.ReadVector())
			
		end
		
	else
		
		if command == 6 then //soundEnableFFT(1)
			
			wire_expression2_gates[expression2_id][channel_id].fft_table_mode = net.ReadBit()
			
		elseif command == 7 then //soundEnableFFTAttribs(1)
			
			wire_expression2_gates[expression2_id][channel_id].fft_attrib_mode = net.ReadBit()	
			
		elseif command == 8 then //Stop all
			
			wire_expression2_soundurl_stop_all()			
			
		elseif command == 9 then
			
			wire_expression2_gates[expression2_id][channel_id].parent_ent_id = net.ReadUInt(32)
			
		elseif command == 10 then
			
			wire_expression2_gates[expression2_id][channel_id].fft_bitrate_type = clp(net.ReadUInt(32), 1, 5)
			
		end
		
	end
	
end

concommand.Add("wire_expression2_soundurl_stop_all", wire_expression2_soundurl_stop_all)

hook.Add("EntityRemoved", "wire_expression2_soundurl_call_on_remove", function(entity)
	
	if entity:GetClass() == "gmod_wire_expression2" then 
			
			wire_expression2_soundurl_call_on_remove(entity:EntIndex())
			
	end
	
end)

net.Receive("wire_expression2_soundurl_client_packet", wire_expression2_soundurl_recv_packet)

timer.Create("wire_expression2_soundurl_check_and_send", 0.025, 0, wire_expression2_soundurl_fft_check)