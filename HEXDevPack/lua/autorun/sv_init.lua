if SERVER then
	
	local Files, Folders = file.Find("entities/gmod_wire_expression2/core/custom/*","LUA")
	
	for _, o in pairs(Files) do
		
		local t = string.Left(o,2)
		
		if t == "cl" then
			
			AddCSLuaFile("entities/gmod_wire_expression2/core/custom/"..o)
			
		elseif t == "sv" then
			
			include("entities/gmod_wire_expression2/core/custom/"..o)
			
		end
		
	end
	
else
	
	local Files, Folders = file.Find("entities/gmod_wire_expression2/core/custom/*","LUA")
	
	for _, o in pairs(Files) do
		
		include("entities/gmod_wire_expression2/core/custom/"..o)
		
	end
	
end