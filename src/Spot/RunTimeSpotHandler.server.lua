---!strict
local Event = script.Parent.Event
local BindFunc = script.Parent.Function
local HS = game:GetService("HttpService")
local scoreutils = require(game.ReplicatedStorage.Modules.ScoreUtils)
local plrs = game:GetService("Players")
local SpotSpecifier = require(game:GetService("ServerScriptService").SpotSpecifier)
local SongIds = require(game.ReplicatedStorage.SongIDs)
local SongInfo = require(game.ReplicatedStorage.Modules.SongInfo)
--do local hi,exploiters = "!","lol" end

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

function getMedian(data:{number})
	local c = 0
	for _,v in next,data do
		c += v
	end
	return c/#data
end

local POIs = {}
local SpotSounds = {}

for _,POIModel in next,script.Parent:GetChildren() do
	if not POIModel:IsA("Model") then
		continue
	end
	-- CopyPasta from old script!
	local BF:any,CO,Dad:any,ARO = POIModel:FindFirstChild("Boyfriend"), POIModel:FindFirstChild("CameraOrigin"),
		POIModel:FindFirstChild("Dad"),POIModel:FindFirstChild("AccuracyRateOrigin")
		
	local GF:any = POIModel:FindFirstChild("Girlfriend")
	local statsModel = POIModel:FindFirstChildOfClass("Model")
	local SpotUIStats:any, SpotUIDad:any, SpotUIBF:any, StatsGUI:any, PlayerIconGUI:any
	local SpotRoundStats = {
		DadScore = 0;
		BFScore = 0;
		BFAccuracy = 100;
		DadAccuracy = 100;
	}
	if statsModel then
		SpotUIStats = statsModel:FindFirstChild("Stats")
		SpotUIDad = statsModel:FindFirstChild("DadScreen")
		SpotUIBF = statsModel:FindFirstChild("BFScreen")
		--SpotUIDad2 = statsModel:FindFirstChild("DadScreen2")
		--SpotUIBF2 = statsModel:FindFirstChild("BFScreen2")
		-- i'm not bothering to add a failsafe rn
		StatsGUI = {
			PlayerVS = SpotUIStats.GUI:FindFirstChild("PlayerVs");
			Score = SpotUIStats.GUI:FindFirstChild("Score");
			SongName = SpotUIStats.GUI:FindFirstChild("SongName");
		}
		PlayerIconGUI = {
			Dad = SpotUIDad.GUI:FindFirstChild("ImageLabel");
			BF = SpotUIBF.GUI:FindFirstChild("ImageLabel");
			--Dad2 = SpotUIDad2.GUI:FindFirstChild("ImageLabel");
			--BF2 = SpotUIBF2.GUI:FindFirstChild("ImageLabel")
		}
	end
	if not (BF and CO and Dad and ARO) then
		warn(("Spot doesn't met the requirements! (%s)"):format(POIModel:GetFullName()))
		continue
	end
	

	local SpotSound = Instance.new("Sound")
	local SpotVocals = Instance.new("Sound")
	SpotSound.Name = "RoundSong"
	SpotSound.Volume = 1
	SpotSound.RollOffMaxDistance = 30
	SpotSound.RollOffMinDistance = 12
	SpotSound.RollOffMode = Enum.RollOffMode.Inverse
	SpotSound.Parent = ARO
	SpotSound:SetAttribute("BPM",0);

	SpotVocals.Name = "RoundVocals"
	SpotVocals.Volume = 1
	SpotVocals.RollOffMaxDistance = 30
	SpotVocals.RollOffMinDistance = 12
	SpotVocals.RollOffMode = Enum.RollOffMode.Inverse
	SpotVocals.Parent = ARO
	SpotSounds[#SpotSounds+1] = SpotSound
	SpotSounds[#SpotSounds+1] = SpotVocals
	
	-- end
	
	local SpotEvent = Instance.new("BindableEvent")
	SpotEvent.Name = "Event"
	SpotEvent.Parent = POIModel
	
	local SpotFunction = Instance.new("BindableFunction")
	SpotFunction.Name = "Function"
	SpotFunction.Parent = POIModel
	
	local POI:PointOfInterest = {
		BFSpot = SpotSpecifier.AddSpot(BF);
		BFSpot2 = SpotSpecifier.AddSpot(POIModel:FindFirstChild("Boyfriend2"));
		DadSpot2 = SpotSpecifier.AddSpot(POIModel:FindFirstChild("Dad2"));
		DadSpot = SpotSpecifier.AddSpot(Dad);
		GFSpot = GF and SpotSpecifier.AddSpot(GF) or nil;
		OptionalStuff = {StatsGUI = StatsGUI,PlayerIconGUI = PlayerIconGUI};
		IsPlaying = false;
		IsSolo = false;
		Coop = false;
		Model = POIModel;
		Event = SpotEvent.Event;
	}
	POIs[#POIs + 1] = POI
	
	-- Spot stuff
	local BFtakenFunction2 = function(plr:any)
		local char = plr.Character
		local HRP = char:FindFirstChild("HumanoidRootPart")

		HRP.Anchored = true
		HRP.CFrame = POI.BFSpot2.Part.CFrame

		Event:Fire("SpotJoin",POI.Model,POI.BFSpot2.Part,plr,POI.Ownership == plr)
	end
	local DadtakenFunction2 = function(plr:any)
		local char = plr.Character
		local HRP = char:FindFirstChild("HumanoidRootPart")

		HRP.Anchored = true
		HRP.CFrame = POI.DadSpot2.Part.CFrame
		Event:Fire("SpotJoin",POI.Model,POI.DadSpot2.Part,plr,POI.Ownership == plr)
	end
	local BFtakenFunction = function(plr:any)
		local char = plr.Character
		local HRP = char:FindFirstChild("HumanoidRootPart")

		HRP.Anchored = true
		HRP.CFrame = POI.BFSpot.Part.CFrame
		
		if POI.Ownership == nil then
			POI.Ownership = plr
		elseif POI.Ownership and (POI.Ownership ~= POI.BFSpot.Owner and POI.Ownership ~= POI.DadSpot.Owner) then -- give ownership if neither spots doesn't have the actual owner.
			POI.Ownership = plr
		end
		

		Event:Fire("SpotJoin",POI.Model,POI.BFSpot.Part,plr,POI.Ownership == plr)
	end
	
	local DadtakenFunction = function(plr:any)
		local char = plr.Character
		local HRP = char:FindFirstChild("HumanoidRootPart")
		
		if POI.Ownership == nil then
			POI.Ownership = plr
		elseif POI.Ownership and (POI.Ownership ~= POI.BFSpot.Owner and POI.Ownership ~= POI.DadSpot.Owner) then -- give ownership if neither spots doesn't have the actual owner.
			POI.Ownership = plr
		end
		
		HRP.Anchored = true
		HRP.CFrame = POI.DadSpot.Part.CFrame
		Event:Fire("SpotJoin",POI.Model,POI.DadSpot.Part,plr,POI.Ownership == plr)
	end
	POI.BFSpot.Taken:Connect(BFtakenFunction)
	POI.DadSpot.Taken:Connect(DadtakenFunction)
	POI.BFSpot2.Taken:Connect(BFtakenFunction2)
	POI.DadSpot2.Taken:Connect(DadtakenFunction2)
	POI.BFSpot2.PP.Enabled = false
	POI.DadSpot2.PP.Enabled = false
	
	
	local leaveFunction = function(plr:Player)
		print("work!")
		local char = plr.Character
		local HRP = char:FindFirstChild("HumanoidRootPart")
		HRP.Anchored = false
		if POI.Ownership == plr or (POI.IsPlaying and not POI.IsSolo) then
			POI.Ownership = nil
			if POI.DadSpot.Owner and POI.DadSpot.Owner ~= plr then POI.DadSpot:Kick() end
			if POI.BFSpot.Owner and POI.BFSpot.Owner ~= plr then POI.BFSpot:Kick() end
			if POI.DadSpot2.Owner and POI.DadSpot2.Owner ~= plr then POI.DadSpot2:Kick() end
			if POI.BFSpot2.Owner and POI.BFSpot2.Owner ~= plr then POI.BFSpot2:Kick() end
			SpotSound:Stop()
			SpotVocals:Stop()
			POI.IsPlaying = false
			POI.BFSpot.PP.Enabled = true
			POI.DadSpot.PP.Enabled = true
			POI.BFSpot2.PP.Enabled = false
			POI.DadSpot2.PP.Enabled = false
		end
		if plr == POI.BFSpot.Owner then
			Event:Fire("SpotLeave",POI.Model,POI.BFSpot.Part,POI.BFSpot.Owner)
		elseif plr == POI.DadSpot.Owner then
			Event:Fire("SpotLeave",POI.Model,POI.DadSpot.Part,POI.DadSpot.Owner)
		elseif plr == POI.BFSpot2.Owner then
				Event:Fire("SpotLeave",POI.Model,POI.BFSpot2.Part,POI.BFSpot2.Owner)
		elseif plr == POI.DadSpot2.Owner then
				Event:Fire("SpotLeave",POI.Model,POI.DadSpot2.Part,POI.DadSpot2.Owner)
		end
	end
	
	POI.BFSpot.Leave:Connect(leaveFunction)
	POI.BFSpot2.Leave:Connect(leaveFunction)
	POI.DadSpot.Leave:Connect(leaveFunction)
	POI.DadSpot2.Leave:Connect(leaveFunction)
	
	SpotEvent.Event:Connect(function(msgType,...)
		if msgType == "BFTrigger" then
			POI.BFSpot:Kick()
		elseif msgType == "DadTrigger" then
			POI.DadSpot:Kick()
		elseif msgType == "BFTrigger2" then
			POI.BFSpot2:Kick()
		elseif msgType == "DadTrigger2" then
			POI.DadSpot2:Kick()
		elseif msgType == "AbruptEnd" then
			POI.DadSpot:Kick()
			POI.BFSpot:Kick()
			POI.DadSpot2:Kick()
			POI.BFSpot2:Kick()
			POI.DadSpot2.PP.Enabled = false
			POI.BFSpot2.PP.Enabled = false
			SpotSound:Stop()
			SpotVocals:Stop()
			Event:Fire("GameEnd")
			print("Spot gone wrong, reseting everything.")
		elseif msgType == "SlotAdd" then
			local mode,av = ...
			if mode == "Coop" then
				if av[1] == 1 then
					POI.BFSpot2.PP.Enabled = true
				end
				if av[2] == 1 then
					POI.DadSpot2.PP.Enabled = true
				end
			elseif mode == "Single" then
				if POI.DadSpot.Owner and POI.BFSpot.Owner then
					
				elseif POI.DadSpot.Owner then
					POI.BFSpot.PP.Enabled = false
				else
					POI.DadSpot.PP.Enabled = false
				end
			elseif mode == "Duel" then
				if POI.DadSpot.Owner and POI.BFSpot.Owner then
				elseif POI.DadSpot.Owner then POI.BFSpot.PP.Enabled = true
				else POI.DadSpot.PP.Enabled = true end
			end
			
		end
	end)
	
	-- GF Spot
	
	if POI.GFSpot then
		POI.GFSpot.PP.MaxActivationDistance = 7
		local GFAnimTrack
		local GFCon
		SpotSound:GetAttributeChangedSignal("BPM"):connect(function()
			if(GFAnimTrack)then
				local speed = SpotSound:GetAttribute("BPM")==0 and 1 or GFAnimTrack.Length/(60/SpotSound:GetAttribute("BPM"))/2
				GFAnimTrack:AdjustSpeed(speed~=math.huge and speed or 1);
			end
		end)
		POI.GFSpot.PromptVisibleWhenTaken = true
		POI.GFSpot.Taken:Connect(function(plr)
			local HRP = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			local AnimController = hum:FindFirstChildOfClass("Animator")
			local AnimScript = plr.Character:FindFirstChild("Animate")
			HRP.CFrame = GF.CFrame * CFrame.new(0,1.5,0)
			HRP.Anchored = true
			--POI.GFSpot.PP.ActionText = "Stop"
			if AnimScript then AnimScript.Disabled = true end
			GFAnimTrack = AnimController:LoadAnimation(game:GetService"ReplicatedStorage".Animations.GF)
			GFAnimTrack.Priority = Enum.AnimationPriority.Action
			GFAnimTrack.Looped = true
			local speed = SpotSound:GetAttribute("BPM")==0 and 1 or GFAnimTrack.Length/(60/SpotSound:GetAttribute("BPM"))/2
			GFAnimTrack:AdjustSpeed(speed~=math.huge and speed or 1);
			GFAnimTrack:Play()
		end)
		POI.GFSpot.Leave:Connect(function(plr)
			local HRP = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			local AnimScript = plr.Character:FindFirstChild("Animate")
			HRP.Anchored = false
			hum.Sit = false
			if GFAnimTrack then
				GFAnimTrack:Stop()
				GFAnimTrack = nil
			end
			--POI.GFSpot.PP.ActionText = "Vibe"

			if AnimScript then AnimScript.Disabled = false end
		end)
		POI.GFSpot.TextInfo = {
			Available = "Vibe";
			Taken = "Stop";
		}
		POI.GFSpot.PP.ActionText = "Vibe"
	end
	
	-- Gameplay stuff
	
	local compRemote
	local compFunction
	local NameCache = {}
	-- COPYPASTE from old script BLOCK!!!
	SpotFunction.OnInvoke = function(msgType,...)
		print("SpotFunction | ", msgType, ...)

		if msgType == "GetPlayersFromSpot" then
			local theSpot = ...
			if theSpot == POI.Model then
				return POI.BFSpot.Owner, POI.DadSpot.Owner, POI.BFSpot2.Owner, POI.DadSpot2.Owner	
			end
			wait(2)
		elseif msgType == "QueueInstancesRemoval" then
			local boolSide,instancesTable,RemoveScale = ...
			if type(instancesTable) ~= "table" or type(boolSide) ~= "boolean" then return end
			local eventCon
			if boolSide then
				eventCon = POI.BFSpot.Leave:Connect(function()
					for _,Inst in next,instancesTable do
						pcall(function()
							Inst:Destroy()
						end)
					end
					if RemoveScale then
						local pm = RemoveScale
						ResizeLimb(pm:FindFirstChild("Left Leg"),pm:FindFirstChild("Left Hip",true),1)
						ResizeLimb(pm:FindFirstChild("Right Leg"),pm:FindFirstChild("Right Hip",true),1)
						ResizeLimb(pm:FindFirstChild("Left Arm"),pm:FindFirstChild("Left Shoulder",true),1)
						ResizeLimb(pm:FindFirstChild("Right Arm"),pm:FindFirstChild("Right Shoulder",true),1)
					end
					eventCon:Disconnect()
				end)
			else
				eventCon = POI.DadSpot.Leave:Connect(function()
					for _,Inst in next,instancesTable do
						pcall(function()
							Inst:Destroy()
						end)
					end
					if RemoveScale then
						local pm = RemoveScale
						ResizeLimb(pm:FindFirstChild("Left Leg"),pm:FindFirstChild("Left Hip",true),1)
						ResizeLimb(pm:FindFirstChild("Right Leg"),pm:FindFirstChild("Right Hip",true),1)
						ResizeLimb(pm:FindFirstChild("Left Arm"),pm:FindFirstChild("Left Shoulder",true),1)
						ResizeLimb(pm:FindFirstChild("Right Arm"),pm:FindFirstChild("Right Shoulder",true),1)
					end
					eventCon:Disconnect()
				end)
			end
		elseif msgType == "GetSpotOwnership" then
			return POI.Ownership
		elseif msgType == "InitializeCompRemote" then -- Starts the current spot gameplay.
			local msgSpot,whoStart,songModule,songDisplay,mode,songSettings = ...
			--print(...)
			POI.Model:SetAttribute("randomSeed",math.random(-0xFFFFFFFF,0xFFFFFFFF))
			local ModuleData = HS:JSONDecode(require(songModule))
			if SongInfo[ModuleData.song.song] and SongInfo[ModuleData.song.song].Whitelist and not table.find(SongInfo[ModuleData.song.song].Whitelist,whoStart.UserId) then
				-- do nothing, or something
				return
			end 
			if NameCache[songModule:GetFullName()] then
				songDisplay = NameCache[songModule:GetFullName()]
			else
				if not ModuleData.song.song then
					songDisplay = songModule.Name
					NameCache[songModule:GetFullName()] = songModule.Name
				else
					songDisplay = ModuleData.song.song
					NameCache[songModule:GetFullName()] = ModuleData.song.song
				end
			end
			if SongIds[songDisplay].PlaybackSpeed then
				SpotSound.PlaybackSpeed = SongIds[songDisplay].PlaybackSpeed * songSettings.SpeedModifier
				SpotVocals.PlaybackSpeed = SongIds[songDisplay].PlaybackSpeed * songSettings.SpeedModifier
			end
			if msgSpot ~= POI.Model or whoStart ~= POI.Ownership then -- verify if it's the player who sent the signal
				print("fail")
				return
			end
			POI.IsPlaying = true

			POI.BFSpot.PP.Enabled = false
			POI.DadSpot.PP.Enabled = false
			POI.DadSpot2.PP.Enabled = false
			POI.BFSpot2.PP.Enabled = false
			if --[[isStatsAvailable]] POI.OptionalStuff.PlayerIconGUI and POI.OptionalStuff.StatsGUI then
				POI.OptionalStuff.StatsGUI.SongName.Text = songDisplay or (songModule.Name .. "_FAILSAFE")
				POI.OptionalStuff.StatsGUI.PlayerVS.Text = ("%s VS %s"):format(POI.DadSpot.Owner and POI.DadSpot.Owner.DisplayName or "None",POI.BFSpot.Owner and POI.BFSpot.Owner.DisplayName or "None")
				POI.OptionalStuff.StatsGUI.Score.Text = "000000000 | 000000000"
				PlayerIconGUI.BF.Image = POI.BFSpot.Owner and plrs:GetUserThumbnailAsync(POI.BFSpot.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054"
				PlayerIconGUI.Dad.Image = POI.DadSpot.Owner and plrs:GetUserThumbnailAsync(POI.DadSpot.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054" 
				SpotRoundStats.BFScore = 0
				SpotRoundStats.DadScore = 0
				SpotRoundStats.BFAccuracy = 100
				SpotRoundStats.DadAccuracy = 100
				--[[if POI.BFSpot2.Owner then
					PlayerIconGUI.BF2.Image = POI.BFSpot2.Owner and plrs:GetUserThumbnailAsync(POI.BFSpot2.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054"
				end
				if POI.DadSpot2.Owner then
					PlayerIconGUI.Dad2.Image = POI.DadSpot2.Owner and plrs:GetUserThumbnailAsync(POI.DadSpot2.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054" 
				end]]
			end



			if (POI.DadSpot.Owner and POI.BFSpot.Owner) or POI.BFSpot2.Owner or POI.DadSpot2.Owner then
				POI.IsSolo = false
			else
				POI.IsSolo = true
			end
			SpotSound:Stop()
			SpotVocals:Stop()
			if compRemote then compRemote:Destroy() end
			if compFunction then compFunction:Destroy() end
			compRemote = Instance.new("RemoteEvent")
			compRemote.Name = "GameRoundRemote"
			compRemote.Parent = POI.Model
			compFunction = Instance.new("RemoteFunction")
			compFunction.Name = "InfoRetriever"
			compFunction.Parent = POI.Model

			compFunction.OnServerInvoke = function(plr,infoType)
				if infoType == 0x0 then -- Get Opponent player
					if POI.BFSpot2.Owner == plr then
						if POI.DadSpot2.Owner ~= nil then
							print('BF2 - Dad')
							return POI.DadSpot.Owner
						else
							print('BF2 - BF')
							return POI.BFSpot.Owner
						end
					elseif POI.DadSpot2.Owner == plr then
						if POI.BFSpot.Owner ~= nil then
							print('Dad2 - BF')
							return POI.BFSpot.Owner
						else
							print('Dad2 - Dad')
							return POI.DadSpot.Owner
						end
					elseif POI.BFSpot.Owner == plr then
						print('Dad')
						return POI.DadSpot.Owner
					elseif POI.DadSpot.Owner == plr then
						print('BF')
						return POI.BFSpot.Owner
					end
					return plr
				elseif infoType == 0x1 then -- return SpotSounds
					return SpotSounds
				elseif infoType == 0x2 then
					return mode
				end
			end
			local displayMode = 0
			local function updateDisplay()
				local scD
				local scB
				if displayMode == 1 then -- Accuracy
					local scLenD = tostring(SpotRoundStats.DadAccuracy)
					local scLenB = tostring(SpotRoundStats.BFAccuracy)
					if SpotRoundStats.BFAccuracy > SpotRoundStats.DadAccuracy then
						scD = '<font color="#FF0000">' .. string.sub(scLenD,1,8) .. "%</font>"
						scB = string.sub(scLenB,1,8) .. "%"
					else
						scD = string.sub(scLenD,1,8) .. "%"
						scB = '<font color="#FF0000">' .. string.sub(scLenB,1,8) .. "%</font>"
					end
				else
					local scLenD = tostring(math.abs(SpotRoundStats.DadScore))
					local scLenB = tostring(math.abs(SpotRoundStats.BFScore))
					if SpotRoundStats.DadScore < 0 then
						scD = '<font color="#FF0000">-' .. string.sub("00000000",#scLenD +1) .. scLenD .. "</font>"
					else
						scD = string.sub("000000000",#scLenD +1) .. scLenD
					end
					if SpotRoundStats.BFScore < 0 then
						scB = '<font color="#FF0000">-' .. string.sub("00000000",#scLenB +1) .. scLenB .. "</font>"
					else
						scB = string.sub("000000000",#scLenB +1) .. scLenB
					end
				end
				StatsGUI.Score.Text = ("%s | %s"):format(scD,scB)
			end
			local displayChangeThread = coroutine.wrap(function()
				repeat
					if displayMode >= 1 then
						displayMode = 0
					else
						displayMode += 1
					end 
					updateDisplay()
					task.wait(10)
				until not POI.IsPlaying
				displayMode = 1
				updateDisplay()
			end)
			local thread_Round = function()
				local BFOwnerReady, DadOwnerReady = POI.BFSpot.Owner == nil,POI.DadSpot.Owner == nil
				local BFOSongReady, DadOSongReady = POI.BFSpot.Owner == nil,POI.DadSpot.Owner == nil
				local BFSongOver, DadSongOver = POI.BFSpot.Owner == nil,POI.DadSpot.Owner == nil
				local bfAcc,dadAcc = 0,0
				local bfCount,dadCount = 0,0
				compRemote.OnServerEvent:Connect(function(plr,msg,...) -- COMPERTITION REMOTE
					--print("compRemote | ", plr, msg, ...)
					if msg == 0x0 then
						if POI.BFSpot.Owner == plr then
							BFOwnerReady = true
						end
						if POI.DadSpot.Owner == plr then
							DadOwnerReady = true
						end
					elseif msg == 0x1 then
						if POI.BFSpot.Owner == plr then
							BFOSongReady = true
						end
						if POI.DadSpot.Owner == plr then
							DadOSongReady = true
						end
					elseif msg == 0x2 then
						if POI.BFSpot.Owner == plr then
							BFSongOver = true
						end
						if POI.DadSpot.Owner == plr then
							DadSongOver = true
						end
					elseif msg == 0x3 then
						local strum,songPos,isSus,nType,dir = ...
						local diff=nil
						local score = 0
						local baseScore = 0;
						if plr == POI.DadSpot.Owner then
							baseScore = SpotRoundStats.DadScore
						elseif plr == POI.BFSpot.Owner then
							baseScore = SpotRoundStats.BFScore
						elseif plr == POI.DadSpot2.Owner then
							baseScore = SpotRoundStats.DadScore
						elseif plr == POI.BFSpot2.Owner then
							baseScore = SpotRoundStats.BFScore
						end
						if(songPos==false)then
							score = strum
							strum = 0;
							songPos = 0;
						else
							diff = strum-songPos
							local acc 
							if(not isSus)then
								score = baseScore + scoreutils:GetScore(scoreutils:GetRating(diff)); 
								acc = scoreutils:GetAccuracy(scoreutils:GetRating(diff))
							else
								score=baseScore
								acc = 1
							end
							if plr == POI.DadSpot.Owner then
								dadAcc += acc
							elseif plr == POI.DadSpot2.Owner then
								dadAcc += acc
							elseif plr == POI.BFSpot.Owner then
								bfAcc += acc
							elseif plr == POI.BFSpot2.Owner then
								bfAcc += acc
							end
						end
						if plr == POI.DadSpot.Owner then
							dadCount += 1
						elseif plr == POI.DadSpot2.Owner then
							dadCount += 1
						elseif plr == POI.BFSpot.Owner then
							bfCount += 1
						elseif plr == POI.BFSpot2.Owner then
							bfCount += 1
						end
						
						
						-- TODO: VERIFY THE HIT!!


						if plr == POI.DadSpot.Owner and POI.BFSpot.Owner then
							compRemote:FireClient(POI.BFSpot.Owner,0x1,strum,diff,nType,dir,isSus)
						end
						if plr == POI.DadSpot.Owner then
							SpotRoundStats.DadScore = score 
							SpotRoundStats.DadAccuracy = (dadAcc/dadCount)*100
						end
						if plr == POI.BFSpot.Owner and POI.DadSpot.Owner then
							compRemote:FireClient(POI.DadSpot.Owner,0x1,strum,diff,nType,dir,isSus)
						end	
						if plr == POI.BFSpot.Owner then
							SpotRoundStats.BFScore = score
							SpotRoundStats.BFAccuracy = (bfAcc/bfCount)*100
						end
						if plr == POI.DadSpot2.Owner and POI.BFSpot.Owner then
							compRemote:FireClient(POI.BFSpot.Owner,0x1,strum,diff,nType,dir,isSus)
						end
						if plr == POI.DadSpot2.Owner then
							SpotRoundStats.DadScore = score 
							SpotRoundStats.DadAccuracy = (dadAcc/dadCount)*100
						end
						if plr == POI.BFSpot2.Owner and POI.DadSpot.Owner then
							compRemote:FireClient(POI.DadSpot.Owner,0x1,strum,diff,nType,dir,isSus)
						end	
						if plr == POI.BFSpot2.Owner then
							SpotRoundStats.BFScore = score
							SpotRoundStats.BFAccuracy = (bfAcc/bfCount)*100
						end
						updateDisplay()
						return
					elseif msg == 0x4 then -- someone has been murdered!
						if POI.DadSpot.Owner then
							local HRP = POI.DadSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
							if HRP then HRP.Anchored = false end
							Event:Fire("SpotLeave",POI.Model,POI.DadSpot.Part,POI.DadSpot.Owner)
						end
						if POI.BFSpot.Owner then
							local HRP = POI.BFSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
							if HRP then HRP.Anchored = false end
							Event:Fire("SpotLeave",POI.Model,POI.BFSpot.Part,POI.BFSpot.Owner)
						end
						if POI.DadSpot2.Owner then
							local HRP = POI.DadSpot2.Owner.Character:FindFirstChild("HumanoidRootPart")
							if HRP then HRP.Anchored = false end
							Event:Fire("SpotLeave",POI.Model,POI.DadSpot2.Part,POI.DadSpot2.Owner)
						end
						if POI.BFSpot2.Owner then
							local HRP = POI.BFSpot2.Owner.Character:FindFirstChild("HumanoidRootPart")
							if HRP then HRP.Anchored = false end
							Event:Fire("SpotLeave",POI.Model,POI.BFSpot2.Part,POI.BFSpot2.Owner)
						end
						POI.DadSpot2:Kick()
						POI.BFSpot2:Kick()
						POI.BFSpot:Kick()
						POI.DadSpot:Kick()
						POI.DadSpot2.PP.Enabled = false
						POI.BFSpot2.PP.Enabled = false

						local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
						local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
						local boom = Instance.new("Explosion")
						boom.DestroyJointRadiusPercent = 0
						boom.Position = hrp.Position
						local death = Instance.new("Sound")
						death.SoundId = "rbxassetid://6878469634"
						death.Volume = 1
						death.Parent = hrp
						death:Play()
						humanoid.Health = -1
						boom.Parent = workspace

						SpotSound:Stop()
						SpotVocals:Stop()
						wait(1)
						Event:Fire("GameEnd")
						compRemote:Destroy()
						compFunction:Destroy()
						return
					elseif msg == 0x5 then
						local mode,av = ...
						print(mode)
						if mode == "Coop" then
							if av[1] == 1 then
								POI.BFSpot2.PP.Enabled = true
							end
							if av[2] == 1 then
								POI.DadSpot2.PP.Enabled = true
							end
						elseif mode == "Single" then
							if POI.DadSpot.Owner and POI.DadSpot.Owner ~= plr then POI.DadSpot:Kick() end
							if POI.BFSpot.Owner and POI.BFSpot.Owner ~= plr then POI.BFSpot:Kick() end
							return
						else
							warn("Mode cannot be identified!")
						end
						return
					end

					if BFSongOver and DadSongOver then -- Song Over
						print("compRemote Deleted!")
						if POI.DadSpot.Owner then
							local HRP = POI.DadSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
							if HRP then HRP.Anchored = false end
						end
						if POI.BFSpot.Owner then
							local HRP = POI.BFSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
							if HRP then HRP.Anchored = false end
						end
						POI.IsPlaying = false
						POI.BFSpot:Kick()
						POI.DadSpot:Kick()
						POI.BFSpot2:Kick()
						POI.DadSpot2:Kick()
						compRemote:Destroy()
						compFunction:Destroy()
						Event:Fire("GameEnd")
						SpotSound:Stop()
						SpotVocals:Stop()
					end
				end)
				local count = 0
				repeat
					count += 1
					print("wait..")
					wait(1)
				until (count >= 30) or (BFOwnerReady and DadOwnerReady) or (POI.BFSpot.Owner == nil and POI.DadSpot.Owner == nil)
				if not (BFOwnerReady and DadOwnerReady) then
					SpotEvent:Fire("AbruptEnd")
					print("Spot reset, failsafe activated.")
					return
				end
				print("SpotHandler | song start!")
				--[[
				if IsSolo then
					print("SpotHandler | Enabled quit button")
					--if BFOwner then BFProxProm.ActionText = "Quit";BFProxProm.Enabled = true else BFProxProm.Enabled = false end
					--if DadOwner then DadProxProm.ActionText = "Quit";DadProxProm.Enabled = true else DadProxProm.Enabled = false end
					DadProxProm.Enabled = false
					BFProxProm.Enabled = false
				end--]]
				if POI.BFSpot.Owner then compRemote:FireClient(POI.BFSpot.Owner,0x0,mode) end
				if POI.DadSpot.Owner then compRemote:FireClient(POI.DadSpot.Owner,0x0,mode) end
				if POI.BFSpot2.Owner then compRemote:FireClient(POI.BFSpot2.Owner,0x0,mode) end
				if POI.DadSpot2.Owner then compRemote:FireClient(POI.DadSpot2.Owner,0x0,mode) end
				wait(2)
				SpotSound:Play()
				SpotVocals:Play()
			end
			thread_Round = coroutine.create(thread_Round)
			coroutine.resume(thread_Round)
			displayChangeThread()
			return compRemote
		end
	end
	-- end
end

script.Parent.ChildAdded:Connect(function(POIModel)
	for i,v in pairs(script.Parent:GetChildren()) do 
		if v == POIModel then
			warn("Runtime Stage "..v.Name)
			if not POIModel:IsA("Model") then
				continue
			end
			-- CopyPasta from old script!
			local BF:any,CO,Dad:any,ARO = POIModel:FindFirstChild("Boyfriend"), POIModel:FindFirstChild("CameraOrigin"),
				POIModel:FindFirstChild("Dad"),POIModel:FindFirstChild("AccuracyRateOrigin")

			local GF:any = POIModel:FindFirstChild("Girlfriend")
			local statsModel = POIModel:FindFirstChildOfClass("Model")
			local SpotUIStats:any, SpotUIDad:any, SpotUIBF:any, StatsGUI:any, PlayerIconGUI:any, SpotUIDad2:any, SpotUIBF2:any
			local SpotRoundStats = {
				DadScore = 0;
				BFScore = 0;
			}
			if statsModel then
				SpotUIStats = statsModel:FindFirstChild("Stats")
				SpotUIDad = statsModel:FindFirstChild("DadScreen")
				SpotUIBF = statsModel:FindFirstChild("BFScreen")
				--SpotUIDad2 = statsModel:FindFirstChild("DadScreen2")
				--SpotUIBF2 = statsModel:FindFirstChild("BFScreen2")
				-- i'm not bothering to add a failsafe rn
				StatsGUI = {
					PlayerVS = SpotUIStats.GUI:FindFirstChild("PlayerVs");
					Score = SpotUIStats.GUI:FindFirstChild("Score");
					SongName = SpotUIStats.GUI:FindFirstChild("SongName");
				}
				PlayerIconGUI = {
					Dad = SpotUIDad.GUI:FindFirstChild("ImageLabel");
					BF = SpotUIBF.GUI:FindFirstChild("ImageLabel");
					--Dad2 = SpotUIDad2.GUI:FindFirstChild("ImageLabel");
					--BF2 = SpotUIBF2.GUI:FindFirstChild("ImageLabel")
				}
			end
			if not (BF and CO and Dad and ARO) then
				warn(("Spot doesn't met the requirements! (%s)"):format(POIModel:GetFullName()))
				continue
			end


			local SpotSound = Instance.new("Sound")
			local SpotVocals = Instance.new("Sound")
			SpotSound.Name = "RoundSong"
			SpotSound.Volume = 1
			SpotSound.RollOffMaxDistance = 30
			SpotSound.RollOffMinDistance = 12
			SpotSound.RollOffMode = Enum.RollOffMode.Inverse
			SpotSound.Parent = ARO
			SpotSound:SetAttribute("BPM",0);

			SpotVocals.Name = "RoundVocals"
			SpotVocals.Volume = 1
			SpotVocals.RollOffMaxDistance = 30
			SpotVocals.RollOffMinDistance = 12
			SpotVocals.RollOffMode = Enum.RollOffMode.Inverse
			SpotVocals.Parent = ARO
			SpotSounds[#SpotSounds+1] = SpotSound
			SpotSounds[#SpotSounds+1] = SpotVocals

			-- end

			local SpotEvent = Instance.new("BindableEvent")
			SpotEvent.Name = "Event"
			SpotEvent.Parent = POIModel

			local SpotFunction = Instance.new("BindableFunction")
			SpotFunction.Name = "Function"
			SpotFunction.Parent = POIModel

			local POI:PointOfInterest = {
				BFSpot = SpotSpecifier.AddSpot(BF);
				BFSpot2 = SpotSpecifier.AddSpot(POIModel:FindFirstChild("Boyfriend2"));
				DadSpot2 = SpotSpecifier.AddSpot(POIModel:FindFirstChild("Dad2"));
				DadSpot = SpotSpecifier.AddSpot(Dad);
				GFSpot = GF and SpotSpecifier.AddSpot(GF) or nil;
				OptionalStuff = {StatsGUI = StatsGUI,PlayerIconGUI = PlayerIconGUI};
				IsPlaying = false;
				IsSolo = false;
				Coop = false;
				Model = POIModel;
				Event = SpotEvent.Event;
			}
			POIs[#POIs + 1] = POI

			-- Spot stuff
			local BFtakenFunction = function(plr:any)
				local char = plr.Character
				local HRP = char:FindFirstChild("HumanoidRootPart")

				HRP.Anchored = true
				HRP.CFrame = POI.BFSpot.Part.CFrame

				if POI.Ownership == nil then
					POI.Ownership = plr
				elseif POI.Ownership and (POI.Ownership ~= POI.BFSpot.Owner and POI.Ownership ~= POI.DadSpot.Owner) then -- give ownership if neither spots doesn't have the actual owner.
					POI.Ownership = plr
				end


				Event:Fire("SpotJoin",POI.Model,POI.BFSpot.Part,plr,POI.Ownership == plr)
			end
			
			local DadtakenFunction2 = function(plr:any)
				local char = plr.Character
				local HRP = char:FindFirstChild("HumanoidRootPart")

				HRP.Anchored = true
				HRP.CFrame = POI.DadSpot2.Part.CFrame
				Event:Fire("SpotJoin",POI.Model,POI.DadSpot2.Part,plr,POI.Ownership == plr)
			end
			local BFtakenFunction2 = function(plr:any)
				local char = plr.Character
				local HRP = char:FindFirstChild("HumanoidRootPart")

				HRP.Anchored = true
				HRP.CFrame = POI.BFSpot2.Part.CFrame

				Event:Fire("SpotJoin",POI.Model,POI.BFSpot2.Part,plr,POI.Ownership == plr)
			end

			local DadtakenFunction = function(plr:any)
				local char = plr.Character
				local HRP = char:FindFirstChild("HumanoidRootPart")

				if POI.Ownership == nil then
					POI.Ownership = plr
				elseif POI.Ownership and (POI.Ownership ~= POI.BFSpot.Owner and POI.Ownership ~= POI.DadSpot.Owner) then -- give ownership if neither spots doesn't have the actual owner.
					POI.Ownership = plr
				end

				HRP.Anchored = true
				HRP.CFrame = POI.DadSpot.Part.CFrame
				Event:Fire("SpotJoin",POI.Model,POI.DadSpot.Part,plr,POI.Ownership == plr)
			end
			POI.BFSpot.Taken:Connect(BFtakenFunction)
			POI.DadSpot.Taken:Connect(DadtakenFunction)
			POI.BFSpot2.Taken:Connect(BFtakenFunction2)
			POI.DadSpot2.Taken:Connect(DadtakenFunction2)
			POI.BFSpot2.PP.Enabled = false
			POI.DadSpot2.PP.Enabled = false


			local leaveFunction = function(plr:Player)
				print("work!")
				local char = plr.Character
				local HRP = char:FindFirstChild("HumanoidRootPart")
				HRP.Anchored = false
				if POI.Ownership == plr or (POI.IsPlaying and not POI.IsSolo) then
					POI.Ownership = nil
					if POI.DadSpot.Owner and POI.DadSpot.Owner ~= plr then POI.DadSpot:Kick() end
					if POI.BFSpot.Owner and POI.BFSpot.Owner ~= plr then POI.BFSpot:Kick() end
					if POI.DadSpot2.Owner and POI.DadSpot2.Owner ~= plr then POI.DadSpot2:Kick() end
					if POI.BFSpot2.Owner and POI.BFSpot2.Owner ~= plr then POI.BFSpot2:Kick() end
					SpotSound:Stop()
					SpotVocals:Stop()
					POI.IsPlaying = false
					POI.BFSpot.PP.Enabled = true
					POI.DadSpot.PP.Enabled = true
					POI.BFSpot2.PP.Enabled = false
					POI.DadSpot2.PP.Enabled = false
				end
				if plr == POI.BFSpot.Owner then
					Event:Fire("SpotLeave",POI.Model,POI.BFSpot.Part,POI.BFSpot.Owner)
				elseif plr == POI.DadSpot.Owner then
					Event:Fire("SpotLeave",POI.Model,POI.DadSpot.Part,POI.DadSpot.Owner)
				elseif plr == POI.BFSpot2.Owner then
					Event:Fire("SpotLeave",POI.Model,POI.BFSpot2.Part,POI.BFSpot2.Owner)
				elseif plr == POI.DadSpot2.Owner then
					Event:Fire("SpotLeave",POI.Model,POI.DadSpot2.Part,POI.DadSpot2.Owner)
				end
			end

			POI.BFSpot.Leave:Connect(leaveFunction)
			POI.BFSpot2.Leave:Connect(leaveFunction)
			POI.DadSpot.Leave:Connect(leaveFunction)
			POI.DadSpot2.Leave:Connect(leaveFunction)

			SpotEvent.Event:Connect(function(msgType,...)
				if msgType == "BFTrigger" then
					POI.BFSpot:Kick()
				elseif msgType == "DadTrigger" then
					POI.DadSpot:Kick()
				elseif msgType == "BFTrigger2" then
					POI.BFSpot2:Kick()
				elseif msgType == "DadTrigger2" then
					POI.DadSpot2:Kick()
				elseif msgType == "AbruptEnd" then
					POI.DadSpot:Kick()
					POI.BFSpot:Kick()
					SpotSound:Stop()
					SpotVocals:Stop()
					Event:Fire("GameEnd")
					print("Spot gone wrong, reseting everything.")
				elseif msgType == "SlotAdd" then
					local mode,av = ...
					if mode == "Coop" then
						if av[1] == 1 then
							POI.BFSpot2.PP.Enabled = true
						end
						if av[2] == 1 then
							POI.DadSpot2.PP.Enabled = true
						end
					elseif mode == "Single" then
						if POI.DadSpot.Owner and POI.BFSpot.Owner then

						elseif POI.DadSpot.Owner then
							POI.BFSpot.PP.Enabled = false
						else
							POI.DadSpot.PP.Enabled = false
						end
					elseif mode == "Duel" then
						if POI.DadSpot.Owner and POI.BFSpot.Owner then
						elseif POI.DadSpot.Owner then POI.BFSpot.PP.Enabled = true
						else POI.DadSpot.PP.Enabled = true end
					end
				end
			end)

			-- GF Spot

			if POI.GFSpot then
				POI.GFSpot.PP.MaxActivationDistance = 7
				local GFAnimTrack
				local GFCon
				SpotSound:GetAttributeChangedSignal("BPM"):connect(function()
					if(GFAnimTrack)then
						local speed = SpotSound:GetAttribute("BPM")==0 and 1 or GFAnimTrack.Length/(60/SpotSound:GetAttribute("BPM"))/2
						GFAnimTrack:AdjustSpeed(speed~=math.huge and speed or 1);
					end
				end)
				POI.GFSpot.PromptVisibleWhenTaken = true
				POI.GFSpot.Taken:Connect(function(plr)
					local HRP = plr.Character:FindFirstChild("HumanoidRootPart")
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					local AnimController = hum:FindFirstChildOfClass("Animator")
					local AnimScript = plr.Character:FindFirstChild("Animate")
					HRP.CFrame = GF.CFrame * CFrame.new(0,1.5,0)
					HRP.Anchored = true
					--POI.GFSpot.PP.ActionText = "Stop"
					if AnimScript then AnimScript.Disabled = true end
					GFAnimTrack = AnimController:LoadAnimation(game:GetService"ReplicatedStorage".Animations.GF)
					GFAnimTrack.Priority = Enum.AnimationPriority.Action
					GFAnimTrack.Looped = true
					local speed = SpotSound:GetAttribute("BPM")==0 and 1 or GFAnimTrack.Length/(60/SpotSound:GetAttribute("BPM"))/2
					GFAnimTrack:AdjustSpeed(speed~=math.huge and speed or 1);
					GFAnimTrack:Play()
				end)
				POI.GFSpot.Leave:Connect(function(plr)
					local HRP = plr.Character:FindFirstChild("HumanoidRootPart")
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					local AnimScript = plr.Character:FindFirstChild("Animate")
					HRP.Anchored = false
					hum.Sit = false
					if GFAnimTrack then
						GFAnimTrack:Stop()
						GFAnimTrack = nil
					end
					--POI.GFSpot.PP.ActionText = "Vibe"

					if AnimScript then AnimScript.Disabled = false end
				end)
				POI.GFSpot.TextInfo = {
					Available = "Vibe";
					Taken = "Stop";
				}
				POI.GFSpot.PP.ActionText = "Vibe"
			end

			-- Gameplay stuff

			local compRemote
			local compFunction
			local NameCache = {}
			-- COPYPASTE from old script BLOCK!!!
			SpotFunction.OnInvoke = function(msgType,...)
				print("SpotFunction | ", msgType, ...)

				if msgType == "GetPlayersFromSpot" then
					local theSpot = ...
					if theSpot == POI.Model then
						return POI.BFSpot.Owner, POI.DadSpot.Owner, POI.BFSpot2.Owner, POI.DadSpot2.Owner
					end
					wait(2)
				elseif msgType == "QueueInstancesRemoval" then
					local boolSide,instancesTable = ...
					if type(instancesTable) ~= "table" or type(boolSide) ~= "boolean" then return end
					local eventCon
					if boolSide then
						eventCon = POI.BFSpot.Leave:Connect(function()
							for _,Inst in next,instancesTable do
								pcall(function()
									Inst:Destroy()
								end)
							end
							eventCon:Disconnect()
						end)
					else
						eventCon = POI.DadSpot.Leave:Connect(function()
							for _,Inst in next,instancesTable do
								pcall(function()
									Inst:Destroy()
								end)
							end
							eventCon:Disconnect()
						end)
					end
				elseif msgType == "GetSpotOwnership" then
					return POI.Ownership
				elseif msgType == "InitializeCompRemote" then -- Starts the current spot gameplay.
					local msgSpot,whoStart,songModule,songDisplay,mode,songSettings = ...
					--print(...)
					POI.Model:SetAttribute("randomSeed",math.random(-0xFFFFFFFF,0xFFFFFFFF))
					local ModuleData = HS:JSONDecode(require(songModule))
					if SongInfo[ModuleData.song.song] and SongInfo[ModuleData.song.song].Whitelist and not table.find(SongInfo[ModuleData.song.song].Whitelist,whoStart.UserId) then
						-- do nothing, or something
						return
					end 
					if NameCache[songModule:GetFullName()] then
						songDisplay = NameCache[songModule:GetFullName()]
					else
						if not ModuleData.song.song then
							songDisplay = songModule.Name
							NameCache[songModule:GetFullName()] = songModule.Name
						else
							songDisplay = ModuleData.song.song
							NameCache[songModule:GetFullName()] = ModuleData.song.song
						end
					end
					if SongIds[songDisplay].PlaybackSpeed then
						SpotSound.PlaybackSpeed = SongIds[songDisplay].PlaybackSpeed * songSettings.SpeedModifier
						SpotVocals.PlaybackSpeed = SongIds[songDisplay].PlaybackSpeed * songSettings.SpeedModifier
					end
					if msgSpot ~= POI.Model or whoStart ~= POI.Ownership then -- verify if it's the player who sent the signal
						print("fail")
						return
					end
					POI.IsPlaying = true

					POI.BFSpot.PP.Enabled = false
					POI.DadSpot.PP.Enabled = false
					POI.DadSpot2.PP.Enabled = false
					POI.BFSpot2.PP.Enabled = false
					if --[[isStatsAvailable]] POI.OptionalStuff.PlayerIconGUI and POI.OptionalStuff.StatsGUI then
						POI.OptionalStuff.StatsGUI.SongName.Text = songDisplay or (songModule.Name .. "_FAILSAFE")
						local text1 = POI.DadSpot.Owner and POI.DadSpot.Owner.DisplayName or "None"
						local text2 = POI.BFSpot.Owner and POI.BFSpot.Owner.DisplayName or "None"
						POI.OptionalStuff.StatsGUI.PlayerVS.Text = ("%s VS %s"):format(text1 .. POI.DadSpot2.Owner and " & " .. POI.DadSpot2.Owner.DisplayName or "",text2 .. POI.BFSpot2.Owner and " & " .. POI.BFSpot2.Owner.DisplayName or "")
						POI.OptionalStuff.StatsGUI.Score.Text = "000000000 | 000000000"
						PlayerIconGUI.BF.Image = POI.BFSpot.Owner and plrs:GetUserThumbnailAsync(POI.BFSpot.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054"
						PlayerIconGUI.Dad.Image = POI.DadSpot.Owner and plrs:GetUserThumbnailAsync(POI.DadSpot.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054"
						--[[if POI.BFSpot2.Owner then
							PlayerIconGUI.BF2.Image = POI.BFSpot2.Owner and plrs:GetUserThumbnailAsync(POI.BFSpot2.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054"
						end
						if POI.DadSpot2.Owner then
							PlayerIconGUI.Dad2.Image = POI.DadSpot2.Owner and plrs:GetUserThumbnailAsync(POI.DadSpot2.Owner.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) or "rbxassetid://53252054" 
						end]]
						SpotRoundStats.BFScore = 0
						SpotRoundStats.DadScore = 0
						SpotRoundStats.BFAccuracy = 100
						SpotRoundStats.DadAccuracy = 100
					end



					if (POI.DadSpot.Owner and POI.BFSpot.Owner) or POI.BFSpot2.Owner or POI.DadSpot2.Owner then
						POI.IsSolo = false
					else
						POI.IsSolo = true
					end
					SpotSound:Stop()
					SpotVocals:Stop()
					if compRemote then compRemote:Destroy() end
					if compFunction then compFunction:Destroy() end
					compRemote = Instance.new("RemoteEvent")
					compRemote.Name = "GameRoundRemote"
					compRemote.Parent = POI.Model
					compFunction = Instance.new("RemoteFunction")
					compFunction.Name = "InfoRetriever"
					compFunction.Parent = POI.Model

					compFunction.OnServerInvoke = function(plr,infoType)
						if infoType == 0x0 then -- Get Opponent player
								if POI.BFSpot2.Owner == plr then
									if POI.DadSpot2.Owner ~= nil then
										print('BF2 - Dad')
										return POI.DadSpot.Owner
									else
										print('BF2 - BF')
										return POI.BFSpot.Owner
									end
								elseif POI.DadSpot2.Owner == plr then
									if POI.BFSpot.Owner ~= nil then
										print('Dad2 - BF')
										return POI.BFSpot.Owner
									else
										print('Dad2 - Dad')
										return POI.DadSpot.Owner
									end
								elseif POI.BFSpot.Owner == plr then
									print('Dad')
									return POI.DadSpot.Owner
								elseif POI.DadSpot.Owner == plr then
									print('BF')
									return POI.BFSpot.Owner
								end
							return plr
						elseif infoType == 0x1 then -- return SpotSounds
							return SpotSounds
						end
					end

					local thread_Round = function()
						local BFOwnerReady, DadOwnerReady = POI.BFSpot.Owner == nil,POI.DadSpot.Owner == nil
						local BFOSongReady, DadOSongReady = POI.BFSpot.Owner == nil,POI.DadSpot.Owner == nil
						local BFSongOver, DadSongOver = POI.BFSpot.Owner == nil,POI.DadSpot.Owner == nil

						compRemote.OnServerEvent:Connect(function(plr,msg,...) -- COMPERTITION REMOTE
							--print("compRemote | ", plr, msg, ...)
							if msg == 0x0 then
								if POI.BFSpot.Owner == plr then
									BFOwnerReady = true
								end
								if POI.DadSpot.Owner == plr then
									DadOwnerReady = true
								end
							elseif msg == 0x1 then
								if POI.BFSpot.Owner == plr then
									BFOSongReady = true
								end
								if POI.DadSpot.Owner == plr then
									DadOSongReady = true
								end
							elseif msg == 0x2 then
								if POI.BFSpot.Owner == plr then
									BFSongOver = true
								end
								if POI.DadSpot.Owner == plr then
									DadSongOver = true
								end
							elseif msg == 0x3 then
								local strum,songPos,isSus,nType,dir = ...
								local diff=nil
								local score = 0
								local baseScore = 0;
								if plr == POI.DadSpot.Owner then
									baseScore = SpotRoundStats.DadScore
								elseif plr == POI.BFSpot.Owner then
									baseScore = SpotRoundStats.BFScore
								end
								if(songPos==false)then
									score = strum
									strum = 0;
									songPos = 0;
								else
									diff = strum-songPos
									if(not isSus)then
										score = baseScore + scoreutils:GetScore(scoreutils:GetRating(diff)); 
									else
										score=baseScore
									end
								end

								-- TODO: VERIFY THE HIT!!


								if plr == POI.DadSpot.Owner and POI.BFSpot.Owner then
									compRemote:FireClient(POI.BFSpot.Owner,0x1,strum,diff,nType,dir,isSus)
								end
								if plr == POI.DadSpot.Owner then
									SpotRoundStats.DadScore = score
								end
								if plr == POI.BFSpot.Owner and POI.DadSpot.Owner then
									compRemote:FireClient(POI.DadSpot.Owner,0x1,strum,diff,nType,dir,isSus)
								end	
								if plr == POI.BFSpot.Owner then
									SpotRoundStats.BFScore = score
								end
								local scLenD = tostring(math.abs(SpotRoundStats.DadScore))
								local scLenB = tostring(math.abs(SpotRoundStats.BFScore))
								local scD 
								local scB
								if SpotRoundStats.DadScore < 0 then
									scD = '<font color="#FF0000">-' .. string.sub("00000000",#scLenD +1) .. scLenD .. "</font>"
								else
									scD = string.sub("000000000",#scLenD +1) .. scLenD
								end
								if SpotRoundStats.BFScore < 0 then
									scB = '<font color="#FF0000">-' .. string.sub("00000000",#scLenB +1) .. scLenB .. "</font>"
								else
									scB = string.sub("000000000",#scLenB +1) .. scLenB
								end
								StatsGUI.Score.Text = ("%s | %s"):format(scD,scB)
								return


							elseif msg == 0x4 then -- someone has been murdered!
								if POI.DadSpot.Owner then
									local HRP = POI.DadSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
									if HRP then HRP.Anchored = false end
									Event:Fire("SpotLeave",POI.Model,POI.DadSpot.Part,POI.DadSpot.Owner)
								end
								if POI.BFSpot.Owner then
									local HRP = POI.BFSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
									if HRP then HRP.Anchored = false end
									Event:Fire("SpotLeave",POI.Model,POI.BFSpot.Part,POI.BFSpot.Owner)
								end
								POI.BFSpot:Kick()
								POI.DadSpot:Kick()

								local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
								local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
								local boom = Instance.new("Explosion")
								boom.DestroyJointRadiusPercent = 0
								boom.Position = hrp.Position
								local death = Instance.new("Sound")
								death.SoundId = "rbxassetid://6878469634"
								death.Volume = 1
								death.Parent = hrp
								death:Play()
								humanoid.Health = -1
								boom.Parent = workspace

								SpotSound:Stop()
								SpotVocals:Stop()
								wait(1)
								Event:Fire("GameEnd")
								compRemote:Destroy()
								compFunction:Destroy()
								return
							elseif msg == 0x5 then
								mode = ...
								print(mode)
								if mode == "Coop" then
									SpotSpecifier.AddSpot(POIModel:FindFirstChild("Boyfriend2"))
									SpotSpecifier.AddSpot(POIModel:FindFirstChild("Dad2"))
								elseif mode == "Single" then

								else
									warn("Mode cannot be identified!")
								end
								return
							end

							if BFSongOver and DadSongOver then -- Song Over
								print("compRemote Deleted!")
								if POI.DadSpot.Owner then
									local HRP = POI.DadSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
									if HRP then HRP.Anchored = false end
								end
								if POI.BFSpot.Owner then
									local HRP = POI.BFSpot.Owner.Character:FindFirstChild("HumanoidRootPart")
									if HRP then HRP.Anchored = false end
								end
								POI.IsPlaying = false
								POI.BFSpot:Kick()
								POI.DadSpot:Kick()
								compRemote:Destroy()
								compFunction:Destroy()
								Event:Fire("GameEnd")
								SpotSound:Stop()
								SpotVocals:Stop()
							end
						end)
						local count = 0
						repeat
							count += 1
							print("wait..")

							wait(1)
						until (count >= 30) or (BFOwnerReady and DadOwnerReady) or (POI.BFSpot.Owner == nil and POI.DadSpot.Owner == nil)
						if not (BFOwnerReady and DadOwnerReady) then
							SpotEvent:Fire("AbruptEnd")
							print("Spot reset, failsafe activated.")
							return
						end
						print("SpotHandler | song start!")
				--[[
				if IsSolo then
					print("SpotHandler | Enabled quit button")
					--if BFOwner then BFProxProm.ActionText = "Quit";BFProxProm.Enabled = true else BFProxProm.Enabled = false end
					--if DadOwner then DadProxProm.ActionText = "Quit";DadProxProm.Enabled = true else DadProxProm.Enabled = false end
					DadProxProm.Enabled = false
					BFProxProm.Enabled = false
				end--]]
						if POI.BFSpot.Owner then compRemote:FireClient(POI.BFSpot.Owner,0x0) end
						if POI.DadSpot.Owner then compRemote:FireClient(POI.DadSpot.Owner,0x0) end
						wait(2)
						SpotSound:Play()
						SpotVocals:Play()
					end
					thread_Round = coroutine.create(thread_Round)
					coroutine.resume(thread_Round)

					return compRemote
				end
			end
		end
	end
end)

-- COPY PASTA!
BindFunc.OnInvoke = function(msgType,...)
	print("SpotHandler | ",msgType,...)
	if msgType == "GetSpotRemotes" then
		local indicatedSpot = ...
		if indicatedSpot:IsDescendantOf(script.Parent) then
			print("Gave remotes for spot " .. indicatedSpot:GetFullName())
			return indicatedSpot:FindFirstChild("Function"),indicatedSpot:FindFirstChild("Event")
		end
		return
	end
end