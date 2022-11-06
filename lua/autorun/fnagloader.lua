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
		end
	else
		local f = file.Open("data/advdupe2/fnag/"..v,"rb", "LUA")
		local subv = string.Split(v,".")[1]
		local ff = file.Open("advdupe2/fnag/"..subv..".txt","wb", "DATA")
		ff:Write(f:Read()) --This is hecka sus for large files
		ff:Close()
		f:Close()
		--print("FNAG Loader writing "..subv..".txt, new")
	end
	--print("FNAG Loader processed "..v)
end
--print("FNAG Loader finished successfully, I hope.")
	