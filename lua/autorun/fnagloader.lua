--if (FNAGLoader!=nil) then return end
-- I don't blame you for being cool and rewriting functions or something to make file search cooler but there's got to be an easier way. Wiremod team, please fix.
-- For all intents and purposes, this loader shall be public domain.
-- I haven't written a lick of Lua since 2015 so please forgive my poor code.

if (!file.Exists("advdupe2/fnag", "DATA")) then
	file.CreateDir("advdupe2/fnag")
end

function FNAGLoader()
	return true;
end

FNAGLoader_modifieds = {}

if CLIENT then

local function FNAGLoader_sanitise()
	local ply = LocalPlayer()
	local pName = ply:Name()
	local pID = ply:SteamID()
	local count = 0
	local files = 0
	for k, _ in pairs(FNAGLoader_modifieds) do
		local f = file.Open(k,"rb","DATA")
		local ok, tbl, info = AdvDupe2.Decode(f:Read(f:Size()))
		if ok == true then
			files = files + 1
			for kk, v in pairs(tbl.Entities) do
				if v.code_author != nil then
					v.code_author.name = pName
					v.code_author.SteamID = pID
					count = count + 1
				end
			end
		end
		AdvDupe2.Encode( tbl, info, function(data)
			AdvDupe2.SendToClient(ply, data, 0)
		end)
	end
	print("FNAGLoader sanitised "..files.." files with "..count.." entries")
end

hook.Add("InitPostEntity","FNAGLoader_sanitise",FNAGLoader_sanitise)
	
end
	

local files, dir = file.Find("data/advdupe2/fnag/*","LUA")
for k, v in pairs(files) do
	local i = string.find(v,"_",1,true)
	local sbstr = string.sub(v,1,i)
	--print("FNAG "..sbstr.." loaded")

	local found = file.Find("advdupe2/fnag/"..sbstr.."*","DATA")
	--print("FNAG Loader looked in advdupe2/fnag/"..sbstr.."* and found: "..table.ToString(found))
	if(!table.IsEmpty(found)) then
		local other = found[1]
		--print("FNAG Loader found "..other)
		local otherversion = {string.match(other,"(%d+)_(%d+)_(%d+)",i+1)}
		local version = {string.match(v,"(%d+)_(%d+)_(%d+)", i+1)}
		local replace = false

		for kk, vv in ipairs(version) do
			if(tonumber(vv) > tonumber(otherversion[kk])) then
				replace = true
				break
			end
		end

		if(replace == true) then
			file.Delete("advdupe2/fnag/"..other)
			local f = file.Open("data/advdupe2/fnag/"..v,"rb", "LUA")
			local subv = string.Split(v,".")[1]
			local ff = file.Open("advdupe2/fnag/"..subv..".txt","wb", "DATA")
			ff:Write(f:Read())
			ff:Close()
			f:Close()
			--FNAGLoader_sanitise("advdupe2/fnag/"..subv..".txt")
			FNAGLoader_modifieds["advdupe2/fnag/"..subv..".txt"] = true
			print("FNAG Loader added/updated "..v)
		end
	else
		local f = file.Open("data/advdupe2/fnag/"..v,"rb", "LUA")
		local subv = string.Split(v,".")[1]
		local ff = file.Open("advdupe2/fnag/"..subv..".txt","wb", "DATA")
		ff:Write(f:Read()) --This is hecka sus for large files
		ff:Close()
		f:Close()
		--FNAGLoader_sanitise("advdupe2/fnag/"..subv..".txt")
		FNAGLoader_modifieds["advdupe2/fnag/"..subv..".txt"] = true
		--print("FNAG Loader writing "..subv..".txt, new")
		print("FNAG Loader added/updated "..v)
	end
end
--print("FNAG Loader finished successfully, I hope.")
	