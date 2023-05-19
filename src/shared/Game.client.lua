-- https://github.com/ninjamuffin99/Funkin

-- game code used to be here
local coreCall 
local ResetDisableThread = coroutine.create(function(MaxAttempts)
	local MAX_RETRIES = MaxAttempts or 8

	local StarterGui = game:GetService('StarterGui')
	local RunService = game:GetService('RunService')

	function coreCall(method, ...)
		local result = {}
		for retries = 1, MAX_RETRIES do
			result = {pcall(StarterGui[method], StarterGui, ...)}
			if result[1] then
				break
			end
			RunService.Stepped:Wait()
		end
		return unpack(result)
	end


	assert(coreCall('SetCore', 'ResetButtonCallback', false))
	-- Copypasted from a devforum post
end)
coroutine.resume(ResetDisableThread,15)


if(shared.effects)then
	for _,v in next, shared.effects do
		v:destroy()
	end
end
shared.effects={}

local RS = game:GetService("ReplicatedStorage")
local	 RunS = game:GetService("RunService")
local TS = game:GetService("TextService")
local UIS = game:GetService("UserInputService")
local HS = game:GetService("HttpService")

local GameHandler = require(script.Parent.GameHandler)
local UIHandler = require(script.Parent.UIHandler)
local UserInputBindables = require(RS.Modules.UserInputBindables)
shared.handler = GameHandler;

--UIHandler.ProximityPromptUI.onLoad()

local PositioningParts = GameHandler.PositioningParts
local instrSound = script.Parent.Song.Instrumental
local vocalSound = script.Parent.Song.Voices
local UI = script.Parent
local remote = RS.MultiplayerHandler or RS:FindFirstChild("MultiplayerHandler")
local InfoRetriever = RS.InfoRetriever or RS:WaitForChild("InfoRetriever")
local GameplayStage = workspace:FindFirstChild("StageRoom")
local plr = game:GetService("Players").LocalPlayer

local Settings = {
	SpeedModifier = 1
}

local function SpotAction()
	if GameHandler.PositioningParts.PlayAs == nil then
		return
	end
	remote:FireServer(0x4,GameHandler.PositioningParts.Spot,GameHandler.PositioningParts.PlayAs)
end

--[[
	THE UI  |  THE UI  |  THE UI  |  THE UI  |  THE UI  |  THE UI  |  THE UI  |  THE UI
--]]

local LeaveButton = UI.LeaveSpotButton

OwnerWait = UI.OwnerWait
function getEventHandler(compRemote)
	return function(msgType,...)
		if msgType == "OppIcon" then
			local icon = ...
			--GameHandler.OppChangeSetting("OppIcon",icon)
			compRemote:FireServer(0x6,false,icon)
		elseif msgType == "NoteHit" then
			local strumTime,pos,isSussy,nType,dir=...
			compRemote:FireServer(0x3,strumTime,pos,isSussy,nType,dir)
		elseif msgType == "NoteMiss" then
			local score = ...
			compRemote:FireServer(0x3,score,false)
		elseif msgType == "GhostTap" then
			compRemote:FireServer(0x5)
		elseif msgType == "Death" then
			if(shared.effects)then
				for _,v in next, shared.effects do
					v:destroy()
				end
			end
			shared.effects={}
			compRemote:FireServer(0x4)
			GameHandler.endSong()
		end
	end
end

local function OWDisplayUpdate(textDisplay)
	OwnerWait.Text = textDisplay .. ("\nS:%s, LN:%s, UN:%s, IL:%s"):format(tostring(GameHandler.LoadingStatus.SectionCount),GameHandler.LoadingStatus.LoadedNotes,GameHandler.LoadingStatus.DataNotes,GameHandler.LoadingStatus.PreloadedImages)
	-- S = Section Count
	-- LN = Loaded Notes
	-- UN = Unloaded Notes / Notes To Load count
	-- IL = Images Loaded
end 

local function InitializeGame(Module, PlayerMode, plrs)
	GameHandler.PositioningParts.isOpponentAvailable = InfoRetriever:InvokeServer(0x0,GameHandler.PositioningParts.Spot)
	local bf, dad, bf2, dad2 = InfoRetriever:InvokeServer(0x3,GameHandler.PositioningParts.Spot)
	GameHandler.PositioningParts.isPlayer = {bf, dad, bf2, dad2}
	--GameHandler.PositioningParts.isPlayer
	for Name,Value in next,Module:GetAttributes() do
		if Settings[Name] == nil then continue end
		Settings[Name] = Value
	end
	--[[
	if altPlayer and PlayerMode == "Single" then
		UserInputBindables.ClearBinds("QuitSpot")
		LeaveButton.Visible = false
		UIHandler.ToggleSettingsUI(true)
		UIHandler.ToggleUISongPickVisibility(false)
		OwnerWait.Visible = false
		PositioningParts.Left = nil
		PositioningParts.Left2 = nil
		PositioningParts.Right = nil
		PositioningParts.AccuracyRate = nil
		PositioningParts.Camera = nil
		PositioningParts.PlayAs = nil
		PositioningParts.Spot = nil
		instrSound.Playing = false
		vocalSound.Playing = false
		if extSpotSounds then
			for _,extSpotSound in next,extSpotSounds do
				extSpotSound.Volume = 1
			end
		end
		GameHandler.endSong()
		plr.Character.HumanoidRootPart.Anchored = false
	end
	local Prompt = GameHandler.PositioningParts[GameHandler.PositioningParts.PlayAs and "Right" or "Left"].Prompt
	Prompt.Enabled = false
	local PromptUI = UIHandler.ProximityPromptUI.GetUIFromPrompt(Prompt)
	--]]
	if game:GetService("RunService"):IsStudio() then -- then
		local updateThread = function()
			repeat
				OWDisplayUpdate("Loading chart...")
				RunS.RenderStepped:Wait()
			until GameHandler.LoadingStatus.DoneLoading
		end
		coroutine.wrap(updateThread)()
		GameHandler.genSong(Module, Settings) -- Call the function without protection, makes debugging eaiser.
	else -- Run a failsafe when the function gets an error.
		OwnerWait.Text = "Loading chart..."
		local success ,errorInfo = pcall(GameHandler.genSong,Module, Settings, plrs)
		if not success then
			warn(("Song did not load! %s"):format(errorInfo))
			if GameHandler.PlayerObjects.BF then GameHandler.PlayerObjects.BF:Destroy() end
			if GameHandler.PlayerObjects.Dad then GameHandler.PlayerObjects.Dad:Destroy() end
			if GameHandler.PlayerObjects.BF2 then GameHandler.PlayerObjects.BF2:Destroy() end
			if GameHandler.PlayerObjects.Dad2 then GameHandler.PlayerObjects.Dad2:Destroy() end
			remote:FireServer(0x0,GameHandler.PositioningParts.Spot)
			OwnerWait.Visible = false
			return
		end
	end
	local compRemote = GameHandler.PositioningParts.Spot:WaitForChild("GameRoundRemote",60)
	local compFunction = GameHandler.PositioningParts.Spot:WaitForChild("InfoRetriever",60)
	if compRemote == nil or compFunction == nil then
		warn("Spot didn't properly load!")
		remote:FireServer(0x0,GameHandler.PositioningParts.Spot)
		OwnerWait.Visible = false
		return
	end
	OwnerWait.Text = "Loading song..."
	local waitTimer = 0
	repeat
		wait(1)
		waitTimer += 1
		if waitTimer == 35 then
			warn("Taking too long, enabling leave button.")
		end
	until instrSound.IsLoaded or waitTimer >= 35
	if waitTimer >= 35 then
		OwnerWait.Visible = false
		GameHandler.endSong()
		if GameHandler.PositioningParts.Spot then
			remote:FireServer(0x0,GameHandler.PositioningParts.Spot)
		end
		return
	end
	if PositioningParts.PlayAs == nil then
		OwnerWait.Visible = false
		return
	end
	extSpotSounds = extSpotSounds or compFunction:InvokeServer(0x1) -- get external spot sounds
	--compRemote:FireServer(0x5,PlayerMode)
	print("Got compRemote!")
	for _,extSpotSound in next,extSpotSounds do
		extSpotSound.Volume = 0
	end
	--
	OwnerWait.Text = "Waiting for opponent..."
	repeat
		compRemote:FireServer(0x0)
		local isReadyToPlay = compRemote.OnClientEvent:Wait()
	until isReadyToPlay == 0x0  or PositioningParts.PlayAs == nil
	if PositioningParts.PlayAs == nil then
		OwnerWait.Visible = false
		return
	end
	if not (GameHandler.PositioningParts.isOpponentAvailable or bf2 or dad2)then
		LeaveButton.Visible = true
	else
		LeaveButton.Visible = false
	end
	OwnerWait.Visible = false
	local CRCon = compRemote.OnClientEvent:Connect(function(msgType,...)
		if msgType == 0x1 then
			local strum,timeDiff = ...
			if strum == false then

			end
			if timeDiff == nil then
				GameHandler.OpponentMissNote(...)
				print("opponent missed" )
			else
				GameHandler.handleHit(...)
			end
		end
		if msgType == 0x5 then
			GameHandler.GhostTap()
		end
	end)
	local GpECon = GameHandler.GameplayEvent:Connect(getEventHandler(compRemote))
	UIHandler.ToggleSettingsUI(false)
	GameHandler.startCountdown()
	ESECon = GameHandler.endSongEvent:Connect(function()
		LeaveButton.Visible = false
		compRemote:FireServer(0x2)
		UIHandler.ToggleSettingsUI(true)
		CRCon:Disconnect()
		GpECon:Disconnect()

		for _,extSpotSound in next,extSpotSounds do
			extSpotSound.Volume = 1
		end
	end)
end

UIHandler.SelectModeEvent:Connect(function(mode, av)
	local b = av[1]+av[2]
	print('Selected '..tostring(mode)..' Players available: '..tostring(b))
	remote:FireServer(0x5,PositioningParts.Spot, mode, av)
	--local compRemote = PositioningParts.Spot:WaitForChild("GameRoundRemote",60)
	--compRemote:FireServer(0x5, mode, av)
end)

UIHandler.SongPlayEvent:Connect(function(Module, Mode, av)
	remote:FireServer(0x1,(Module),PositioningParts.Spot, Settings) -- send song loading signal
	for Name,_ in next,GameHandler.settings.MenuControls do
		if Name == "QuitSpot" then continue end
		UserInputBindables.ClearBinds(Name)
	end
	
	UIHandler.ToggleUISongPickVisibility(false)
	OwnerWait.Visible = true
	LeaveButton.Visible = false
	
	InitializeGame(Module, Mode, nil)
end)
GameHandler.endSongEvent:Connect(function()
	for Name,Binds in next,GameHandler.settings.MenuControls do
		if Name == "QuitSpot" then continue end
		for _,Keycode in next,Binds do
			UserInputBindables.AddBind(Name,Keycode)
		end
	end
end)

for Name,Binds in next,GameHandler.settings.MenuControls do
	if Name == "QuitSpot" then continue end
	for _,Keycode in next,Binds do
		UserInputBindables.AddBind(Name,Keycode)
	end
end

remote.OnClientEvent:Connect(function(signalType,...)
	if signalType == 0x0 then -- InitSpot, AKA join
		LeaveButton.Visible = true
		local GPIndex = UIS.GamepadEnabled and 2 or 1
		for _,key in next,GameHandler.settings.MenuControls.QuitSpot do
			UserInputBindables.AddBind("QuitSpot",key)
			LeaveButton.Text = ("Leave (%s)"):format(GameHandler.settings.MenuControls.QuitSpot[GPIndex].Name)
		end
		local Spot,isBF,isOwner,sP= ...
		if isOwner then 
			UIHandler.ToggleUISongPickVisibility(true)
		else
			OwnerWait.Text = "Opponent picking a song..."
			OwnerWait.Visible = true
		end
		UIHandler.ToggleSettingsUI(false)
		if ESECon then ESECon:Disconnect() end
		local BF = Spot:FindFirstChild("Boyfriend")
		local BF2 = Spot:FindFirstChild("Boyfriend2")
		local Dad = Spot:FindFirstChild("Dad")
		local Dad2 = Spot:FindFirstChild("Dad2")
		local CamPart = Spot:FindFirstChild("CameraOrigin")
		local ARO = Spot:FindFirstChild("AccuracyRateOrigin")
		local GF = Spot:FindFirstChild("Girlfriend") -- (unused)
		
		
		if GameHandler.PositioningParts.CameraPlayer == true then
			PositioningParts.Left = GameHandler.PositioningParts.e
			PositioningParts.Left2 = GameHandler.PositioningParts.w
			PositioningParts.Right = GameHandler.PositioningParts.f
			PositioningParts.Right2 = GameHandler.PositioningParts.t
		else
			PositioningParts.Left = BF
			PositioningParts.Left2 = BF2
			PositioningParts.Right = Dad
			PositioningParts.Right2 = Dad2
		end
		
		
		PositioningParts.AccuracyRate = ARO
		PositioningParts.Camera = CamPart
		PositioningParts.Spot = Spot
		if tostring(sP) == 'Dad2' then
			PositioningParts.PlayAs = 1
		elseif tostring(sP) == "Boyfriend2" then
			PositioningParts.PlayAs = 2
		else
			if isBF then
				PositioningParts.PlayAs = true
			else
				PositioningParts.PlayAs = false
			end
		end
		
		-- Spot Non-owner stuff.
		
		if isOwner then
			return
		end
		local Settings = {SpeedModifier=1}
		local val,songToPlay,compRemote
		repeat
			val,songToPlay = remote.OnClientEvent:Wait()
		until val == 0x2  or PositioningParts.PlayAs == nil
		-- Game Round Init.
		
		if PositioningParts.PlayAs == nil then
			return
		end
		LeaveButton.Visible = false
		--remote:FireServer(0x1,songToPlay,PositioningParts.Spot)
		InitializeGame(songToPlay,sP,PositioningParts.PlayAs)	
	elseif signalType == 0x1 then -- leave
		UserInputBindables.ClearBinds("QuitSpot")
		LeaveButton.Visible = false
		UIHandler.ToggleSettingsUI(true)
		UIHandler.ToggleUISongPickVisibility(false)
		OwnerWait.Visible = false
		PositioningParts.Left = nil
		PositioningParts.Left2 = nil
		PositioningParts.Right = nil
		PositioningParts.AccuracyRate = nil
		PositioningParts.Camera = nil
		PositioningParts.PlayAs = nil
		PositioningParts.Spot = nil
		instrSound.Playing = false
		vocalSound.Playing = false
		if extSpotSounds then
			for _,extSpotSound in next,extSpotSounds do
				extSpotSound.Volume = 1
			end
		end
		GameHandler.endSong()
		plr.Character.HumanoidRootPart.Anchored = false
	elseif signalType == 0x3 then -- ownership transfer / force song selection UI [UNUSED]
		UIHandler.ToggleUISongPickVisibility(true)
	end
end)

UIHandler.ToggleUISongPickVisibility(false)

-- Leave Button thing

LeaveButton.MouseButton1Down:Connect(SpotAction)


local isLeaving = false
local quitTick = 0
local quitTime = 1
local quitTimer=0;
UserInputBindables.InputEvents.Began:Connect(function(BindName,IO,gpE)
	if BindName == "QuitSpot" and LeaveButton.Visible then
		isLeaving = true
		quitTick = tick()
		print("Quit Start!")
		RunS:BindToRenderStep("QuittingSpot",Enum.RenderPriority.Last.Value,function(delta)
			quitTimer+=delta;
			if quitTimer > quitTime then
				quitTimer=0;
				LeaveButton.UIGradient.Enabled=false;
				LeaveButton.UIGradient.Offset = Vector2.new(-1,0)
				RunS:UnbindFromRenderStep("QuittingSpot")
				isLeaving = false
				print("Quitted!")
				SpotAction()
			end
		end)
	end
end)
UserInputBindables.InputEvents.Ended:Connect(function(BindName,IO,gpE)
	if BindName == "QuitSpot" then
		if isLeaving then
			LeaveButton.UIGradient.Enabled=false;
			LeaveButton.UIGradient.Offset = Vector2.new(-1,0)
			isLeaving = false
			RunS:UnbindFromRenderStep("QuittingSpot")
			print("Quit Cancel!")
		end
	end
end)

RunS.RenderStepped:connect(function(elapsed)
	if(not isLeaving)then
		quitTimer-=elapsed;
	end
	if(quitTimer<0)then quitTimer=0 end
	
	if(quitTimer>0)then
		LeaveButton.UIGradient.Enabled=true;
		LeaveButton.UIGradient.Offset = Vector2.new(-1+((quitTimer/quitTime)*2),0)
	else
		LeaveButton.UIGradient.Enabled=false;
		LeaveButton.UIGradient.Offset = Vector2.new(-1,0)
	end
end)

-- Attempt to get saved settings.

local maxBinds = 7

local function toboolean(value)
	if type(value) == "string" then
		if value:lower() == "true" then
			return true
		elseif value:lower() == "false" then
			return false
		end
	elseif type(value) == "number" then
		if value == 1 then
			return true
		else
			return false
		end
	end
end
UIHandler.InitializeSettings()
if UIHandler.SettingWindow then UIHandler.SettingWindow.Name = "Settings (Waiting for server...)"end
repeat wait() until plr:GetAttribute("SettingsReady")
lastSettings = plr:GetAttribute("Settings")

if lastSettings then
	local getSettings = HS:JSONDecode(lastSettings)
	for Name,Value in next, getSettings do
		local originalValue = GameHandler.settings[Name]
		if originalValue ~= nil and type(originalValue) ~= "table" and type(originalValue) == type(Value) then
			GameHandler.settings[Name] = Value
			print(("Set %s with %s!"):format(Name,tostring(Value)))
		elseif type(originalValue) == "boolean" and type(Value) == "string" then
			GameHandler.settings[Name] = toboolean(Value)
			print(("Set %s with %s!"):format(Name,tostring(Value)))
		elseif type(originalValue) == "table" then
			if Name == "Keybinds" then
				
				for Mania,DirectionKeybinds in next,Value do
					for Direction,Keycodes in next,DirectionKeybinds do
						--[=
						for i=1,maxBinds do
							if type(Keycodes[tostring(i)]) ~= "string" then continue end
							local isValueValid,Keycode = pcall(function() return Enum.KeyCode[Keycodes[tostring(i)]] end)
							if isValueValid then
								UIHandler.SetGameBind(Mania,Direction,i,Keycode)
								--originalValue[Mania][Direction][i] = Keycode
								
							end
						end--]=]
					end
				end
			end
		elseif originalValue == nil then
			warn("Non-existent setting, got " .. Name)
		end
	end
	print("Got Settings.")
	pcall(function()
		script.Parent.Parent.PreLoad.PreLoadAnims.Disabled =  false
	end)
end -- else use the default settings from the game.

-- Settings Stuff goes down here!
wait()
for OptionName,SettingsInfo in pairs(GameHandler.settingsRules) do
	if OptionName == "__ORDER" then continue end
	if GameHandler.settings[OptionName] == nil then
		print(OptionName .. " doesn't exist! Skipping..")
		continue
	end
	UIHandler.settingsObjects[OptionName].SetValue(GameHandler.settings[OptionName])
end
if UIHandler.SettingWindow then UIHandler.SettingWindow.Name = "Settings"end
--UIHandler.SettingWindow.Name = "Settings"
--UIHandler.ShowSettingsFromCategory("All")

-- keybind menu stuff

--[[

local BindsTabObject = UIHandler.CreateTab("Preferences")
local keyManiaList = {
	"4-Key";"6-Key";"9-Key","5-Key","7-Key","8-Key"
}
local keybindManiaList = {
	{"Left","Down","Up","Right"};
	{"Left","Down","Right","Left2","Up","Right2"};
	{"Left","Down","Up","Right","Space","Left2","Down2","Up2","Right2"};
	{"Left","Down","Space","Up","Right"};
	{"Left","Down","Right","Space","Left2","Up2","Right2"};
	{"Left","Down","Up","Right","Left2","Down2","Up2","Right2"};
}
local keybindButtonHeight = 30

local keyManiaButton = Instance.new("TextButton")
keyManiaButton.Size = UDim2.new(1,0,0,50)
keyManiaButton.Text = "4-Key"
keyManiaButton.TextSize = 25
keyManiaButton.TextColor3 = Color3.new(1,1,1)
keyManiaButton.TextStrokeColor3 = Color3.new()
keyManiaButton.TextStrokeTransparency = 0
keyManiaButton.BackgroundTransparency = 0.75
keyManiaButton.Parent = BindsTabObject.FrameUI

local Instructions = Instance.new("TextLabel")
Instructions.Text = "- Click + Shift to clear a bind.\n- Click on the same bind you're editing to cancel the bind change.\n- Click on \"4-key\" for more mappable keybinds."
local function templateBind()
	local bindName = Instance.new("TextLabel")
	bindName.Size = UDim2.new(0,100,0,keybindButtonHeight)
	--bindName.Font = Enum.Font.SourceSans
	bindName.TextSize = 25
	bindName.TextColor3 = Color3.new(1,1,1)
	bindName.TextStrokeColor3 = Color3.new()
	bindName.TextStrokeTransparency = 0
	bindName.TextXAlignment = Enum.TextXAlignment.Left
	bindName.BackgroundTransparency = 1
	
	local bindPositioner = Instance.new("Frame")
	bindPositioner.BackgroundTransparency = 1
	bindPositioner.Name = "Positioner"
	bindPositioner.Parent = bindName
	
	local bindButton = Instance.new("TextButton")
	bindButton.Name = "BindButton"
	bindButton.BackgroundTransparency = 1
	bindButton.Position = UDim2.new(1,0,0,0)
	bindButton.Size = UDim2.new(0,100,1,0)
	bindButton.TextSize = 25
	bindButton.TextColor3 = Color3.new(1,1,1)
	bindButton.TextStrokeColor3 = Color3.new()
	bindButton.AutoButtonColor = false
	bindButton.TextStrokeTransparency = 0
	bindButton.Parent = bindName
	return bindName
end

local maniaUIElements = {}
local currentBindingButton = nil

for maniaMode,Keybinds  in next,GameHandler.settings.Keybinds do
	local maniaKeyCodeUIs = {}
	
	for DirNum,Keycodes in next,Keybinds do
		local binds = templateBind()
		binds.Text = keybindManiaList[maniaMode][DirNum]
		binds.Position = UDim2.new(0,0,0,60 + (35 * (DirNum-1)))
		binds.Positioner.Position = UDim2.new(0,binds.AbsoluteSize.X,0,binds.AbsolutePosition.Y)
		local bindButton = binds.BindButton
		
		local countKey = 0
		table.foreach(Keycodes,function(index,Keycode) 
			local currentBindButton = bindButton:Clone()
			
			currentBindButton.Position = UDim2.new((1/maxBinds)*(index-1),0,0,0)
			currentBindButton.Size = UDim2.new((1/maxBinds),0,1,0)
			currentBindButton.Text = Keycode.Name
			currentBindButton.TextStrokeTransparency = 0.6
			currentBindButton.TextScaled = true
			currentBindButton.Parent = binds.Positioner
			
			currentBindButton.MouseEnter:Connect(function()
				currentBindButton.BackgroundTransparency = 0.4
				currentBindButton.TextStrokeTransparency = 0
				currentBindButton.ZIndex = 5;
			end)
			-- Mouse Hover Stuff
			currentBindButton.MouseLeave:Connect(function()
				currentBindButton.BackgroundTransparency = 1
				currentBindButton.TextStrokeTransparency = 0.6
				currentBindButton.ZIndex = 1;
			end)
			
			currentBindButton.MouseButton1Click:Connect(function() -- Changing Keybind function
				if not currentBindingButton then
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then -- SHIFT/ALT ACTION
						Keycodes[index] = nil
						currentBindButton.Text = "---"
						return
					end
					-- MAIN ACTION
					currentBindingButton = currentBindButton
					currentBindButton.Text = "..."
					local io
					repeat
						io = UIS.InputBegan:Wait()
						print(io.KeyCode)
					until io.KeyCode ~= Enum.KeyCode.Unknown or not currentBindingButton
					if not currentBindingButton then
						currentBindButton.Text = Keycodes[index].Name
						return
					end
					Keycodes[index] = io.KeyCode
					currentBindButton.Text = io.KeyCode.Name
					currentBindingButton = nil
				elseif currentBindingButton == currentBindButton then -- ALT2 ACTION (pressing the same button while changing a key)
					currentBindingButton = nil
					currentBindButton.Text = Keycodes[index].Name
				end
			end)
			countKey = index
		end)
		if countKey < maxBinds then
			for index=countKey+1,maxBinds do
				local currentBindButton = bindButton:Clone()
				currentBindButton.Position = UDim2.new((1/maxBinds)*(index-1),0,0,0)
				currentBindButton.Size = UDim2.new((1/maxBinds),0,1,0)
				currentBindButton.Text = "---"
				currentBindButton.TextStrokeTransparency = 0.6
				currentBindButton.TextScaled = true
				currentBindButton.Parent = binds.Positioner

				currentBindButton.MouseEnter:Connect(function()
					currentBindButton.BackgroundTransparency = 0.4
					currentBindButton.TextStrokeTransparency = 0
					currentBindButton.ZIndex = 5;
				end)
				currentBindButton.MouseLeave:Connect(function()
					currentBindButton.BackgroundTransparency = 1
					currentBindButton.TextStrokeTransparency = 0.6
					currentBindButton.ZIndex = 1;
				end)
				currentBindButton.MouseButton1Click:Connect(function() -- Changing Keybind function
					if not currentBindingButton then
						if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then -- SHIFT/ALT ACTION
							Keycodes[index] = nil
							currentBindButton.Text = "---"
							return
						end
						-- MAIN ACTION
						currentBindingButton = currentBindButton
						currentBindButton.Text = "..."
						local io
						repeat
							io = UIS.InputBegan:Wait()
							print(io.KeyCode)
						until io.KeyCode ~= Enum.KeyCode.Unknown or not currentBindingButton
						if not currentBindingButton then
							currentBindButton.Text = Keycodes[index].Name
							return
						end
						Keycodes[index] = io.KeyCode
						currentBindButton.Text = io.KeyCode.Name
						currentBindingButton = nil
					elseif currentBindingButton == currentBindButton then -- ALT2 ACTION (pressing the same button while changing a key)
						currentBindingButton = nil
						currentBindButton.Text = Keycodes[index].Name
					end
				end)
			end
		end
		binds.Positioner.Size = UDim2.new(0,BindsTabObject.FrameUI.AbsoluteSize.X - 100 ,0,30)
		maniaKeyCodeUIs[#maniaKeyCodeUIs+1] = binds
		bindButton:Destroy()
		binds.Visible = false
		binds.Parent = BindsTabObject.FrameUI
	end
	maniaUIElements[maniaMode] = maniaKeyCodeUIs
end

Instructions.Position = UDim2.new(0,0,0,375)
Instructions.Size = UDim2.new(1,0,1,-375)
Instructions.BackgroundTransparency = 1
Instructions.TextXAlignment = Enum.TextXAlignment.Left
Instructions.TextYAlignment = Enum.TextYAlignment.Top
Instructions.TextSize = 25
Instructions.TextColor3 = Color3.new(1,1,1)
Instructions.TextStrokeColor3 = Color3.new()
Instructions.TextStrokeTransparency = 0

BindsTabObject.FrameUI.CanvasSize = UDim2.new(1,-1,0,375 + 60 + 80)

Instructions.Parent = BindsTabObject.FrameUI

table.foreach(maniaUIElements[1],function(_,obj) obj.Visible = true end)
local keyModeCount = 1
keyManiaButton.MouseButton1Click:Connect(function()
	keyModeCount += 1
	if not maniaUIElements[keyModeCount] then
		keyModeCount = 1
	end
	for n,currManiaUI in next,maniaUIElements do 
		if n == keyModeCount then
			table.foreach(currManiaUI,function(_,obj) obj.Visible = true end)
		else
			table.foreach(currManiaUI,function(_,obj) obj.Visible = false end)
		end
	end
	keyManiaButton.Text = keyManiaList[keyModeCount]
end)
--]]