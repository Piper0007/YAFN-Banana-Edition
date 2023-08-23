local PS = workspace.PerformingSpots or workspace:WaitForChild("PerformingSpots")
local SpotHandler = PS.Event
local RS =  game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local Plrs = game:GetService("Players")
local Remote = RS.MultiplayerHandler or RS:WaitForChild("MultiplayerHandler")
local wasteOfTime = require(script.Parent.JCoder)
local DS = game:GetService("DataStoreService")
local TS = 	game:GetService("TestService")

function GetDefaultSongSettings()
	return {
		SpeedModifier=1;
	}
end



local songSettings = {}
local useOld = false
local FuncRemote = RS.InfoRetriever or RS:WaitForChild("InfoRetriever")
local BindFunc = PS.Function or PS:WaitForChild("Function")
local SongIDs = require(RS.SongIDs)
local GameSettings = require(RS.Modules.GameSettings)
local defaultSettings = GameSettings.settings
local publicSettings = GameSettings.publicSettings
local ModLibrary = {_FALLBACK = {}}
local FullNameSongTable = {}
local DifficultyList = {
	"Easy";
	"Normal";
	"Hard";
	"Harder"; -- slendy tubes
	"Very Hard"; -- QT
	"Old"; -- Matt old charts or old charts in general ig
	"ALT"; -- mid fight masses and the funny charting
	"Unfair"; -- hehe cookie
	"Glitch"; -- omeger
	"Pain"; -- Sandboxin'
	"AltEasy";
	"AltNormal";
	"AltHard";
	"Flip";
	"Canon"; -- shaggy?
	--"Sandplanet"; -- recharts
	"Checkmate"; -- Dishonor
	"bob"; -- h
	"Mania"; -- 4K rechart
	"5 Key";
	"7 Key";
	"9 Key";
}
local plrSettingsCache = {}

for _,v in next,RS.Modules.Songs:GetChildren() do

	if v:IsA("ModuleScript") then
		ModLibrary._FALLBACK[v.Name] = {Hard = v}
		continue
	elseif v:IsA("Folder") and v.Name ~= "Unused" then
		if #v:GetChildren() == 0 then
			warn(("Folder %s doesn't contain any songs! Skipping..."):format(v.Name))
			continue
		end
		local SongNames = {}
		for _,item in next,v:GetChildren() do	
			-- get the song modules/folders
			if item:IsA("Folder") then
				--
				local SongDifficultyList = {}
				-- if it's a folder, separate them by difficulty
				for _,Difficulty in next,DifficultyList do
					local itemFind = item:FindFirstChild(Difficulty)
					if itemFind and itemFind:IsA("ModuleScript") then
						SongDifficultyList[Difficulty] = itemFind
					end
				end
				SongNames[item.Name] = SongDifficultyList
				--[[
				for _,DiffModule in next,item:GetChildren() do
					SongDifficultyList[DiffModule.Name] = DiffModule
				end
				--]]
			elseif item:IsA("ModuleScript") then
				SongNames[item.Name] = {Hard = item} -- if the item is just a module and not a folder 
			end
		end

		ModLibrary[v.Name] = SongNames
	end
end

--[[
for _,Obj in pairs(RS.Modules.Songs:GetDescendants()) do
	if not Obj:IsA("ModuleScript") then
		continue
	end
	local Data = HS:JSONDecode(require(Obj))
	if Data and Data.song.song and SongIDs[Data.song.song] and not songs[Data.song.song] then
		songs[Data.song.song] = {
			Module = Obj;
			SongId = SongIDs[Data.song.song]
		}
	else
		warn(("%s Module has data issues!"):format(Obj:GetFullName()))
	end
end
--]]
local inputTest = 1e+16
local wtf = wasteOfTime.EncodeNumber(inputTest)
--print("EncodedOutput:",#wtf,wtf:byte(1,-1))
--print(wasteOfTime.DecodeNumber(wtf))

local function funnySH(signalType,...)
	if signalType == "SpotJoin" then
		local Spot,SpotPart,plr,isOwner = ...
		print("Join")
		--print(signalType,Spot,SpotHandler,plr)
		Remote:FireClient(plr,0x0,Spot,SpotPart.Name == "Boyfriend",isOwner,SpotPart) -- 0x0 = "InitSpot"
	elseif signalType == "SpotLeave" then
		print("Leave")
		local Spot,SpotPart,plr = ...
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			plr.Character.HumanoidRootPart.Anchored = false
		end
		Remote:FireClient(plr,0x1) -- 0x1 = "LeaveSpot"
	end
end

SpotHandler.Event:Connect(funnySH)
--newSpotHandler.Event:Connect(funnySH)
local function parentDeadLock(inst) -- Self-destroys when the parent is changed.
	if inst.Parent == nil then return end
	local parent = inst.Parent
	local signal signal = inst:GetPropertyChangedSignal("Parent"):Connect(function()
		if parent ~= inst.Parent then inst:Destroy();signal:Disconnect() end
	end)
end

local RefsForScaling = {}

local Defaults = {
	["Right Leg"] = {
		C1 = CFrame.new( 0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
		Size = Vector3.new(1,2,1)
	},
	["Left Leg"] = {
		C1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		Size = Vector3.new(1,2,1)
	},
	["Right Arm"] = {
		C1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
		Size = Vector3.new(1,2,1)
	},
	["Left Arm"] = {
		C1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		Size = Vector3.new(1,2,1)
	}
}

for i,v in pairs(Defaults) do 
	RefsForScaling[#RefsForScaling+1] = i
end


function ResizeLimb(p,j,s) 
	print(p,j,s)
	if p and j and s and Defaults[p.Name] then
		if s > .99 then
			local Newsize = Defaults[p.Name].Size * Vector3.new(1,s,1)
			local OffV = s 
			if OffV > .99 and OffV < 2 then		
				OffV = OffV + (OffV - 2)				
			end
			OffV = OffV/2
			local NewOff = Defaults[p.Name].C1 * CFrame.new(0,OffV,0)

			p.Size = Newsize
			j.C1 = NewOff
		else 
			local Newsize = Defaults[p.Name].Size * Vector3.new(1,s,1)
			local OffV = s 
			OffV = OffV + (OffV - 2)		
			OffV = OffV/2
			local NewOff = Defaults[p.Name].C1 * CFrame.new(0,OffV,0)

			p.Size = Newsize
			j.C1 = NewOff
		end
	end
end




function replaceWelds2(pm,m)
	--  SCALE FIRST DIPSHIT
	local ResetScale = m:GetAttribute("LimbScale")

	if ResetScale then
		ResetScale = pm
		local Scale = string.split( m:GetAttribute("LimbScale"),",")
		for i,v in pairs(Scale) do 
			if tonumber(v) then
				if i == 1 then
					ResizeLimb(pm:FindFirstChild("Left Leg"),pm:FindFirstChild("Left Hip",true),tonumber(v))
				elseif i == 2 then
					ResizeLimb(pm:FindFirstChild("Right Leg"),pm:FindFirstChild("Right Hip",true),tonumber(v))
				elseif i == 3 then
					ResizeLimb(pm:FindFirstChild("Left Arm"),pm:FindFirstChild("Left Shoulder",true),tonumber(v))
				else 
					ResizeLimb(pm:FindFirstChild("Right Arm"),pm:FindFirstChild("Right Shoulder",true),tonumber(v))
				end
			end
		end
	end
	---


	local HumanoidParts = {}
	for i,v in pairs(pm:GetChildren())  do
		if v:IsA("Part") then
			HumanoidParts[v.Name] = v
		end
	end


	local NM = m
	local InstancestoClear = {}
	local InstancesToCheck = {}

	for i,v in pairs(NM:GetDescendants()) do 
		if v:IsA("JointInstance") then 
			if v.Part0 and HumanoidParts[v.Part0.Name] then
				v.Part0 = HumanoidParts[v.Part0.Name]
			end

			if v.Part1 and  HumanoidParts[v.Part1.Name] then
				v.Part1 = HumanoidParts[v.Part1.Name]
			end
		end

	end

	for i,v in pairs(NM:GetChildren()) do 
		if  HumanoidParts[v.Name] then
			local P = pm[v.Name]
			for i,x in pairs(v:GetChildren()) do 
				if not (x:IsA("Decal")) then
					if not (x:IsA("SpecialMesh") and x.MeshType == Enum.MeshType.Head) then
						InstancestoClear[#InstancestoClear+1] = x
						x.Parent = P					
					end
				end
			end
		else 
			if not (v:IsA("Humanoid") or v:IsA("Accoutrement") or v:IsA("Clothing") or v:IsA("Attachment")  or v:IsA("BodyColors") or v:IsA("CharacterMesh") ) then
				InstancestoClear[#InstancestoClear+1] = v 
				v.Parent = pm					
			end
		end
	end

	--	warn(InstancestoClear)

	NM:Destroy()
	--	parentDeadLock(FM)
	return InstancestoClear,ResetScale
end

local function replaceWelds(playerModel,model)
	model:SetPrimaryPartCFrame(playerModel.HumanoidRootPart.CFrame)
	local HumanoidParts = {}
	for _,ModelInst in next,playerModel:GetChildren() do
		if ModelInst:IsA("Part") then
			HumanoidParts[ModelInst.Name] = ModelInst
		end-- Get the player's parts
	end
	local propParts = {}
	local modelProps = model:GetChildren()
	for _,ModelInst in next,modelProps do
		if ModelInst:IsA("Part") and HumanoidParts[ModelInst.Name] then
			propParts[ModelInst] = ModelInst.Name
		end-- Get the character parts
	end
	local modelWelds = {}
	for _,ModelInst in next,model:GetDescendants() do -- Get every weld in the model 
		if ModelInst:IsA("JointInstance") then
			modelWelds[#modelWelds+1] = ModelInst 
		end
	end
	local humanoidWelds = {}
	for Name,Inst:JointInstance in next,modelWelds do
		-- Compare the weld Part0/Part1 parts
		if Inst.Part0 then
			local familiarPart = propParts[Inst.Part0]
			local similarPart = HumanoidParts[familiarPart]
			print(familiarPart,similarPart)
			if familiarPart and similarPart then
				if Inst:IsDescendantOf(Inst.Part0) then
					humanoidWelds[similarPart] = Inst
				end
				Inst.Part0 = similarPart
			end
		end
		if Inst.Part1 then
			local familiarPart = propParts[Inst.Part1]
			local similarPart = HumanoidParts[familiarPart]
			if familiarPart and similarPart then
				if Inst:IsDescendantOf(Inst.Part1) then
					humanoidWelds[similarPart] = Inst
				end
				Inst.Part1 = similarPart
			end
		end

	end

	-- Reparent the other parts to the player model.
	local reparentedInstances = {}
	for Parent,weld in next,humanoidWelds do
		weld.Parent = Parent
		parentDeadLock(weld)
		reparentedInstances[#reparentedInstances+1] = weld
	end
	for _,ModelInst in next,modelProps do
		if HumanoidParts[ModelInst.Name] then continue end -- skip the part
		if ModelInst:IsA("Humanoid") or ModelInst:IsA("Accoutrement") or ModelInst:IsA("Clothing")  or ModelInst:IsA("BodyColors") then continue end

		ModelInst.Parent = playerModel
		parentDeadLock(ModelInst)
		reparentedInstances[#reparentedInstances+1] = ModelInst
	end
	return reparentedInstances,false
end

local cooldownList = {}

local playbackSpeed = 1

Remote.OnServerEvent:Connect(function(plr,signalType,...)
	if signalType == 0x0 then -- abrupt gameplay end
		local theSpot = ...
		local _,SpotEvent = BindFunc:Invoke("GetSpotRemotes",theSpot)
		if SpotEvent then SpotEvent:Fire("AbruptEnd",plr) end
	elseif signalType == 0x5 then
		local Spot,mode,av = ...
		local SpotBindFunc,SpotEvent = BindFunc:Invoke("GetSpotRemotes",Spot)
		local slot = SpotEvent:Fire("SlotAdd",mode,av)
	elseif signalType == 0x1 then -- Prepare the gameplay round!
		local songModule, Spot, songSettings = ...
		local SpotBindFunc,SpotEvent = BindFunc:Invoke("GetSpotRemotes",Spot)
		local BF, Dad, BF2, Dad2 = SpotBindFunc:Invoke("GetPlayersFromSpot",Spot)
		local BFRI,DadRI, BFRI2, DadRI2
		if not (BF == plr or Dad == plr) then
			print("sussy " .. plr.Name)
			return
		end

		local compRemote = SpotBindFunc:Invoke("InitializeCompRemote",Spot, plr, songModule, songModule, songSettings)
		print(Spot:GetAttribute("randomSeed"))
		if compRemote == nil then
			SpotEvent:Fire("AbruptEnd",plr)
			print("oops")
			return
		end
		--print("remote | ", compRemote, SpotBindFunc, SpotEvent)

		-- Check if their animations does contain any props to insert into.
		local chartData = HS:JSONDecode(require(songModule))
		local SelSoundIds = SongIDs[chartData.song.song]

		if BF and BF.Character then 
			local animationName = plrSettingsCache[BF.UserId].ForcePlayerAnim
			local AnimationFolder = RS.Animations.CharacterAnims:FindFirstChild(animationName ~= "Default" and animationName or (SelSoundIds.BFAnimations or "")) or RS.Animations.CharacterAnims.BF
			local AFAnimRef = AnimationFolder:GetAttribute("CharacterName")
			local character = AFAnimRef and RS.Characters:FindFirstChild(AFAnimRef) or nil
			local BSCALE = false

			if character then
				BFRI,BSCALE = replaceWelds2(BF.Character,character:Clone())
			end--]]
			SpotBindFunc:Invoke("QueueInstancesRemoval",true,BFRI,BSCALE)
		end
		if BF2 and BF2.Character then 
			local animationName = plrSettingsCache[BF2.UserId].ForcePlayerAnim
			local AnimationFolder = RS.Animations.CharacterAnims:FindFirstChild(animationName ~= "Default" and animationName or (SelSoundIds.BFAnimations2 or "")) or RS.Animations.CharacterAnims.BF
			local AFAnimRef = AnimationFolder:GetAttribute("CharacterName")
			local character = AFAnimRef and RS.Characters:FindFirstChild(AFAnimRef) or nil
			local BSCALE = false
			if character then
				BFRI2,BSCALE = replaceWelds2(BF2.Character,character:Clone())
			end--]]
			SpotBindFunc:Invoke("QueueInstancesRemoval",true,BFRI2,BSCALE)
		end
		if Dad and Dad.Character then 
			local animationName = plrSettingsCache[Dad.UserId].ForcePlayerAnim
			local AnimationFolder = RS.Animations.CharacterAnims:FindFirstChild(animationName ~= "Default" and animationName or (SelSoundIds.DadAnimations or "")) or RS.Animations.CharacterAnims.Dad
			local AFAnimRef = AnimationFolder:GetAttribute("CharacterName")
			local character = AFAnimRef and RS.Characters:FindFirstChild(AFAnimRef) or nil
			local DSCALE = false
			if character then
				DadRI,DSCALE = replaceWelds2(Dad.Character,character:Clone())
			end--]]
			SpotBindFunc:Invoke("QueueInstancesRemoval",false,DadRI,DSCALE)
		end
		if Dad2 and Dad2.Character then 
			local animationName = plrSettingsCache[Dad2.UserId].ForcePlayerAnim
			local AnimationFolder = RS.Animations.CharacterAnims:FindFirstChild(animationName ~= "Default" and animationName or (SelSoundIds.DadAnimations2 or "")) or RS.Animations.CharacterAnims.Dad
			local AFAnimRef = AnimationFolder:GetAttribute("CharacterName")
			local character = AFAnimRef and RS.Characters:FindFirstChild(AFAnimRef) or nil
			local DSCALE = false
			if character then
				DadRI2,DSCALE = replaceWelds2(Dad2.Character,character:Clone())
			end--]]
			SpotBindFunc:Invoke("QueueInstancesRemoval",false,DadRI2,DSCALE)
		end

		-- end

		if BF then Remote:FireClient(BF,0x2,songModule,songSettings[plr]) end
		if Dad then Remote:FireClient(Dad,0x2,songModule,songSettings[plr]) end
		if BF2 then Remote:FireClient(BF2,0x2,songModule,songSettings[plr],'BF2') end
		if Dad2 then Remote:FireClient(Dad2,0x2,songModule,songSettings[plr],'Dad2') end

		local SpotSound = Spot.AccuracyRateOrigin:WaitForChild("RoundSong",5)
		local SpotVocals = Spot.AccuracyRateOrigin:WaitForChild("RoundVocals",5)
		if not SpotSound then
			return
		end



		--print("External sound unavailable at the moment!")
		--local directNames = string.split(songModule:GetFullName(),".")
		SpotSound:SetAttribute("BPM",chartData.song.bpm);
		if SelSoundIds then
			SpotSound.SoundId = "rbxassetid://" .. SelSoundIds.Instrumental
			if SelSoundIds.Voices then
				SpotVocals.SoundId = "rbxassetid://" .. SelSoundIds.Voices
			else
				SpotVocals.SoundId = "rbxassetid://0"
			end
			--print("done applying sound id")
		else
			warn("Something went wrong! got " .. tostring(SelSoundIds))
		end
		--]]
	elseif signalType == 0x4 then -- event
		local Spot,isBF = ...
		if isBF == 1 then
			Spot.Event:Fire("DadTrigger2",plr)
		elseif isBF == 2 then
			Spot.Event:Fire("BFTrigger2",plr)
		else
			Spot.Event:Fire(isBF and "BFTrigger" or "DadTrigger",plr)
		end
	elseif signalType == 0x6 then
		print(...)
		playbackSpeed = ...
	end
end)

local function filterSettings(settingsTable)
	local settingsToReplicate = {};
	for Name,Value in next,settingsTable do
		if publicSettings[Name] ~= nil then
			settingsToReplicate[Name] = Value
		end
	end
	return settingsToReplicate
end

FuncRemote.OnServerInvoke = function(plr,msgType,...)
	if msgType == 0x0 then -- get opponent from spot, if the player is using the spot.
		local spot = ...
		local SpotBindFunc,SpotEvent = BindFunc:Invoke("GetSpotRemotes",spot)
		local BF, Dad, BF2, Dad2 = SpotBindFunc:Invoke("GetPlayersFromSpot",spot)

		if BF2 == plr then
			return Dad
		elseif Dad2 == plr then
			return BF
		elseif BF == plr then
			return Dad
		elseif Dad == plr then
			return BF
		end


		-- 0x1 used to be here, occupied when loading the settings.
	elseif msgType == 0x2 then -- Save Settings
		local clientSettings = ...

		local cacheSettings = plrSettingsCache[plr.UserId]

		if not cacheSettings then error"Wrong Data." end

		for SettingName, Value in next, clientSettings do
			if type(Value) == "table" then
				if SettingName == "Keybinds" then
					-- something, idk
				end
				if SettingName == "SongData" then
					-- Marker
					cacheSettings[SettingName] = Value
				end
				cacheSettings[SettingName] = Value
				continue
			end

			if defaultSettings[SettingName] == nil then
				warn("Setting doesn't exist, skipping...")
				continue
			end

			if cacheSettings[SettingName] ~= Value then
				print(("Changing %s with %s (old:%s)"):format(SettingName,tostring(Value),tostring(cacheSettings[SettingName])))
				cacheSettings[SettingName] = Value
			end
		end

		print("Finshed changing settings.",clientSettings)
		plr:SetAttribute("SharedSettings",HS:JSONEncode(filterSettings(plrSettingsCache[plr.UserId])))
		--[[
		local clientKeyBinds = clientSettings.Keybinds
		for Mania,Directions in next,clientKeyBinds do
			
			for Direction, Keycodes in next,Directions do
				
				table.foreach(Keycodes,function(Index,Keycode)
					if typeof(Keycode) == "EnumItem" then
						Keycodes[Index] = Keycode.Name
						print(Keycode.Name)
					end
				end)
			end
		end
		clientSettings = HS:JSONEncode(clientSettings)
		
		local plrDataStore = DS:GetDataStore("PersonalInfo","PLR_" .. tostring(plr.UserId))
		local failsafeCount = 0
		repeat
			local success,info = pcall(plrDataStore.SetAsync,plrDataStore,"SettingsData",clientSettings)
			if not success then print(info) end
			failsafeCount += 1
		until success or failsafeCount >= 10
		print(failsafeCount >= 10 and "Settings couldn't be saved!" or "Saved Settings!")
		--]]
	elseif msgType == 0x3 then -- return players on spot
		local Spot = ...
		local SpotBindFunc,SpotEvent = BindFunc:Invoke("GetSpotRemotes",Spot)
		return SpotBindFunc:Invoke("GetPlayersFromSpot",Spot)

	elseif msgType == 0x4 then -- return playbackSpeed
		return playbackSpeed
	end
end

--local userHash = DS:GetDataStore()

Plrs.PlayerAdded:Connect(function(p)
	songSettings[p]=GetDefaultSongSettings();
	p.Chatted:Connect(function(msg,rep)
		if rep then return end
		if msg == "!updateAvatar" then-- https://cdn.discordapp.com/attachments/788626958208598021/869005817406443530/unknown.png
			if cooldownList[p.UserId] and cooldownList[p.UserId] > tick() then
				return
			end
			cooldownList[p.UserId] = tick() + 30
			p:ClearCharacterAppearance()
			local latestAppearance = Plrs:GetCharacterAppearanceAsync(p.UserId)
			for i,v in next,latestAppearance:GetChildren() do
			--[[
			if v:IsA("Accessory") then v.Parent = plr.Character;continue end
			if v:IsA("Clothing") then v.Parent = plr.Character;continue end
			if v:IsA("Accessory") then v.Parent = plr.Character;continue end
			--]]
				v.Parent = p.Character
			end
		end
	end)
	p:SetAttribute("SettingsReady",false)
	-- save load
	local plrDataStore;
	local succ = pcall(function()
		plrDataStore = DS:GetDataStore("PersonalInfo","PLR_" .. tostring(p.UserId))
	end)
	local success,info
	if(succ)then
		local failsafeCount = 0
		repeat
			success,info = pcall(plrDataStore.GetAsync,plrDataStore,"SettingsData")
			if not success then print(info) end
			failsafeCount += 1
		until success or failsafeCount >= 10
		if failsafeCount < 10 and not success then
			TS:Error(("Unable to load the player data for %s, using defaults."):format(p.Name))
			info = false
		end
	else
		info=false;
	end
	--[=[
	if failsafeCount < 10 and not success then
		info = "Error:Couldn't obtain the settings."
	elseif info == nil then
		info = false -- (uses default if any of these two are returned.)
	end--]=]
	p:SetAttribute("Settings",info)
	wait()
	p:SetAttribute("SettingsReady",true)
	local didDecode,decodeSettings = pcall(HS.JSONDecode,HS,info)
	plrSettingsCache[p.UserId] = didDecode and decodeSettings or defaultSettings
	if not didDecode then
		TS:Error("Data couldn't be JSONDecoded!")
	end
	p:SetAttribute("SharedSettings",HS:JSONEncode(filterSettings(plrSettingsCache[p.UserId])))
	wait(30)
	p:SetAttribute("Settings",nil)
end)

Plrs.PlayerRemoving:Connect(function(plr)
	local clientSettings = plrSettingsCache[plr.UserId]
	if clientSettings[1] then
		table.remove(clientSettings, 1)
	end
	local clientKeyBinds = clientSettings.Keybinds
	if clientKeyBinds then
		for Mania,Directions in next,clientKeyBinds do
			for Direction, Keycodes in next,Directions do
				table.foreach(Keycodes,function(Index,Keycode)
					if typeof(Keycode) == "EnumItem" then
						Keycodes[tostring(Index)] = Keycode.Name
					elseif type(Keycode) == "string" then
						Keycodes[tostring(Index)] = Keycode
					end
				end) -- oops
			end
		end
	end
	print("Saved settings.",clientSettings)
	clientSettings = HS:JSONEncode(clientSettings)
	local plrDataStore = DS:GetDataStore("PersonalInfo","PLR_" .. tostring(plr.UserId))
	local failsafeCount = 0
	repeat
		local success,info = pcall(plrDataStore.SetAsync,plrDataStore,"SettingsData",clientSettings)
		if not success then print(info) end
		failsafeCount += 1
	until success or failsafeCount >= 10
	print(failsafeCount >= 10 and "Settings couldn't be saved!" or "Saved Settings!")
end)