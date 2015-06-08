util.AddNetworkString("wire_expression2_soundurl_client_packet")
util.AddNetworkString("wire_expression2_soundurl_server_packet")

local clp, rnd = math.Clamp, math.Round
local byte, get_char, ts = string.byte, string.GetChar, tostring
local wire_expression2_fft_tables = {}
local fft_bitrate_type = {[1] = 128, [2] = 256, [3] = 512, [4] = 1024, [5] = 2048}

--Unpacking fft string to table

local function wire_expression2_soundurl_fft_unpack(str, bitrate)
	
	local tbl = {}
	
	for _ = 1, fft_bitrate_type[bitrate] do
				
		tbl[_] = (1/255)*(byte(str[_]) or 0)
		
	end
	
	return tbl
	
end

--Send to clients sound info

local function wire_expression2_soundurl_sender(command, expression2_id, channel_id, owner_id, fft_mode, url, pos, volume, noplay)
	
	net.Start("wire_expression2_soundurl_client_packet")
		
		net.WriteUInt(command, 32)
		net.WriteUInt(expression2_id, 32)
		net.WriteUInt(channel_id, 32)
		net.WriteUInt(owner_id, 32)
		
		if command == 0 then //Play info
			
			net.WriteString(url)
			net.WriteVector(pos)
			net.WriteFloat(volume)
			net.WriteUInt(noplay, 1)
			
		elseif command == 4 then //Volume info
			
			net.WriteFloat(volume)
			
		elseif command == 5 then //Position info
		
			net.WriteVector(pos)
			
		elseif command == 6 or command == 7 then //FFT Enable 6 - only fft table 7 fft table with attributes
			
			net.WriteBit(fft_mode)
			net.Send(player.GetByID(owner_id))
			return
		
		elseif command == 9 then //Parent to entity
			
			net.WriteUInt(fft_mode, 32) //use one variable for two parameters
			
		elseif command == 10 then //Set FFT Bitrate
			
			net.WriteUInt(fft_mode, 32)
			
		end
		
	net.Broadcast()
	
end

--Receive from clients fft table and attributes

local function wire_expression2_soundurl_receiver(len, ply)
	
	local expression2_id = net.ReadUInt(32)
	local channel_id = net.ReadUInt(32)
	local owner_id = ply:EntIndex()
	local fft_bitrate = net.ReadUInt(32) or 0
	local fft_table = wire_expression2_soundurl_fft_unpack(net.ReadString(), fft_bitrate)
	local fft_attrib = string.Explode(" ", net.ReadString(), false) //Name, length, curtime, looped	
	
	wire_expression2_fft_tables[ts(owner_id)..":"..ts(channel_id)] =
	{
		channel_fft = fft_table or {},
		channel_attribs = 
		{
			[1] = fft_attrib[1] or "", //Link url
			[2] = fft_attrib[2] and tonumber(fft_attrib[2]) or 0, //Curent time
			[3] = fft_attrib[3] and tonumber(fft_attrib[3]) or 0, //Total length
			[4] = fft_bitrate_type[fft_bitrate] or 1, //Bitrate 1 = 128 2 = 256 3 = 512 4 = 1024 5 = 2048 
		}
	}
	
end


__e2setcost(10)

e2function void soundSetFFT(channel_id, number)
	
	wire_expression2_soundurl_sender(6, self.entity:EntIndex(), channel_id, self.player:EntIndex(), number)

end

e2function void soundSetFFTAttribs(channel_id, number)
	
	wire_expression2_soundurl_sender(7, self.entity:EntIndex(), channel_id, self.player:EntIndex(), number)

end

e2function void soundSetFFTBitrate(channel_id, bitrate)
	
	wire_expression2_soundurl_sender(10, self.entity:EntIndex(), channel_id, self.player:EntIndex(), bitrate)
	
end

e2function array soundGetFFT(channel_id)

	if not wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)] then return {} end
	
	return (wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)].channel_fft or {})

end

e2function string soundGetName(channel_id)
	
	if not wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)] then return "" end
	
	return (wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)].channel_attribs[1] or "")

end

e2function number soundGetTime(channel_id)
	
	if not wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)] then return 0 end
	
	return (wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)].channel_attribs[2] or 0)

end

e2function number soundGetLength(channel_id)

	if not wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)] then return 0 end

	return (wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)].channel_attribs[3] or 0)

end

e2function void soundParentTo(channel_id, entity entity)

	wire_expression2_soundurl_sender(9, self.entity:EntIndex(), channel_id, self.player:EntIndex(), entity:EntIndex())

end

__e2setcost(30)

e2function array soundGetAttribs(channel_id)

	if not wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)] then return {} end

	return wire_expression2_fft_tables[ts(self.player:EntIndex())..":"..ts(channel_id)].channel_attribs

end

__e2setcost(10)

e2function void soundLoadURL(channel_id, string url)

	wire_expression2_soundurl_sender(0, self.entity:EntIndex(), channel_id, self.player:EntIndex(), false, url, self.entity:GetPos(), 1, 0)
	soundParentTo(channel_id, self.entity:EntIndex())
	
end

e2function void soundLoadURL(channel_id, string url, volume, noplay)

	wire_expression2_soundurl_sender(0, self.entity:EntIndex(), channel_id, self.player:EntIndex(), false, url, self.entity:GetPos(), volume, noplay)
	soundParentTo(channel_id, self.entity:EntIndex())
	
end

e2function void soundLoadURL(channel_id, string url, vector pos, volume, noplay)

	wire_expression2_soundurl_sender(0, self.entity:EntIndex(), channel_id, self.player:EntIndex(), false, url, pos, volume, noplay)
	
end

e2function void soundPauseURL(channel_id)

	wire_expression2_soundurl_sender(1, self.entity:EntIndex(), channel_id, self.player:EntIndex())
	
end

e2function void soundPlayURL(channel_id)

	wire_expression2_soundurl_sender(2, self.entity:EntIndex(), channel_id, self.player:EntIndex())
	
end

e2function void soundStopURL(channel_id)

	wire_expression2_soundurl_sender(3, self.entity:EntIndex(), channel_id, self.player:EntIndex())
	
end

e2function void soundVolumeURL(channel_id, volume)

	wire_expression2_soundurl_sender(4, self.entity:EntIndex(), channel_id, self.player:EntIndex(), false, nil, nil, volume)
	
end

e2function void soundPositionURL(channel_id, vector pos)

	wire_expression2_soundurl_sender(5, self.entity:EntIndex(), channel_id, self.player:EntIndex(), false, nil, pos)
	
end

__e2setcost(50)

e2function void soundStopAll()

	wire_expression2_soundurl_sender(8, self.entity:EntIndex(), 0, self.player:EntIndex())
	
end

net.Receive("wire_expression2_soundurl_server_packet", wire_expression2_soundurl_receiver)