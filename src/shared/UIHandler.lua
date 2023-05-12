local UIHandler = {}
local PlrService = game:GetService("Players")
local plr = PlrService.LocalPlayer
local ScreenGui = script.Parent
local Mouse = plr:GetMouse()
-- get services
local RepS = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local HS = game:GetService("HttpService")
local TS = game:GetService("TextService")
local TwS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")
-- load Libraries
local UIB = require(game.ReplicatedStorage.Modules.UserInputBindables)
local Sprite = require(game.ReplicatedStorage.Modules.Sprite) -- needing a reference
local Window = require(script.WindowSystem)
-- get lists of sorts
local gameSettings = require(game.ReplicatedStorage.Modules.GameSettings)
local SongInfo = require(RepS.Modules.SongInfo)
local SongIdInfo = require(RepS.SongIDs)
local Icons = require(RepS.Modules.Icons)
-- create references and stuff
local defaultScreenSize = Vector2.new(1280,720)
local starterScreenSize = workspace.CurrentCamera.ViewportSize
local SSDiff = starterScreenSize / defaultScreenSize

local InfoRetriever = RepS.InfoRetriever or RS:WaitForChild("InfoRetriever")

-- low detail thing
local HDParts = {}

---
local WarningInfo = {} -- This is a cry for help. I'm not okay.
local ComaprismWarningList = {"JP","UN","LC","FL","NS","CP"}
---

local ModLibrary = {}
local DifficultyList = {
	"Easy";
	"Normal";
	"Hard";
	"Encore";
	"Hikki";
	"Harder";
	"Fair";
	"Hell";
	"Unfair";
	"Mania";
	"Multikey";
	"Old";
	"Chaos";
	"Remastered";
	"Blackout";
	"God";
	"WIP";
	"Voiid"
}
local PlayerOptionList = {
	'Duel';
	'Single';
	--'Coop';
	--'Tag-Team';
}
local PlayerOptionColor = {
	Duel = Color3.new(1, 0, 0.0156863);
	Single = Color3.new(0.0117647, 0.835294, 1);
	--Coop =  Color3.new(1, 0.552941, 0.00784314);
}

local DifficultyColor = { -- Stroke color
	Easy = Color3.new(0, 1, 0);
	Normal = Color3.new(1, 1, 0);
	Hard =Color3.new (1, 0, 0);
	Encore =Color3.new (0.478431, 0.0156863, 0.882353);
	Hikki =Color3.new (0.25098, 0.831373, 0.882353);
	Harder =Color3.new(0.67451, 0, 0);
	Hell =Color3.new(0.329412, 0, 0);
	Fair =Color3.new(0.407843, 0.407843, 0.407843);
	Unfair =Color3.new(1, 1, 1);
	Mania =Color3.new(0.333333, 0, 0.498039);
	Multikey =Color3.new(0, 1, 0);
	Old =Color3.new(0.266667, 0.266667, 0.266667);
	Chaos =Color3.new(0, 0.333333, 0);
	Remastered =Color3.new(0.827451, 0.352941, 0.0784314);
	Blackout =Color3.new(1, 1, 1);
	God =Color3.new(0.854902, 0.784314, 0);
	WIP = Color3.new(1, 0.0784314, 0.952941);
	Voiid = Color3.new(0.560784, 0, 0.745098);
}

local DifficultyColor2 = { -- Text color
	Blackout =Color3.new(0, 0, 0);
	Voiid = Color3.new(0, 0, 0);
}

local DifficultyFont = { -- changes text font
	Hikki =Enum.Font.Cartoon
}

local uncategorized = {}
local allSongs = {}
local allMods = {}
for _,v in next,RepS.Modules.Songs:GetChildren() do

	if v:IsA("ModuleScript") and not string.match(v, '.lua', string.len(v)-4) and not string.match(v, '.txt', string.len(v)-4) then
		uncategorized[v.Name] = {Hard = v}
		table.insert(allSongs,{
			SongName = v.Name;
		})
		continue
	elseif v:IsA("Folder") and v.Name ~= "Unused" then
		if #v:GetChildren() == 0 then
			warn(("Folder %s doesn't contain any songs! Skipping..."):format(v.Name))
			continue
		end
		table.insert(allMods,v.Name)
		WarningInfo[v.Name] = {
			[1] = v:GetAttribute("Jumpscares") or nil ,
			[2] =  v:GetAttribute("Unfinished") or nil ,
			[3] = v:GetAttribute("Lack") or nil,
			[4] = v:GetAttribute("Flash") or nil,
			[5] = v:GetAttribute("NoSound") or nil,
			[6] = v:GetAttribute("Copywrite") or nil,
		}

		local SongNames = {}
		for _,item in next,v:GetChildren() do	
			-- get the song modules/folders
			if item:IsA("Folder") then
				--
				local SongDifficultyList = {}
				-- if it's a folder, separate them by difficulty
				for _,Difficulty in next,DifficultyList do
					if item:FindFirstChild(Difficulty) then
						SongDifficultyList[Difficulty] = item[Difficulty]
					end
				end
				SongNames[item.Name] = SongDifficultyList
				table.insert(allSongs,{
					SongName = item.Name;
					ModName = v.Name
				})
				--[[
				for _,DiffModule in next,item:GetChildren() do
					SongDifficultyList[DiffModule.Name] = DiffModule
				end
				--]]
			elseif item:IsA("ModuleScript") and not string.match(item.Name, '.lua', string.len(item.Name)-4) and not string.match(item.Name, '.txt', string.len(item.Name)-4) then
				SongNames[item.Name] = {Hard = item} -- if the item is just a module and not a folder 
				table.insert(allSongs,{
					SongName = item.Name;
					ModName = v.Name
				})
			end
		end

		ModLibrary[v.Name] = SongNames
	end
end
if #uncategorized ~= 0 then
	ModLibrary.Uncategorized = uncategorized
end

local NamesInOrder = {}
for name,list in next, ModLibrary do
	if SongInfo[name] and SongInfo[name].Whitelist and not table.find(SongInfo[name].Whitelist,plr.UserId) then
		continue
	end
	table.insert(NamesInOrder,name)
end
--
if SongInfo.__ModOrder then
	local ModifiedList = {}
	--[[
	table.foreach(SongInfo.__ModOrder,function(Index,Name) 
		local foundPosition = table.find(NamesInOrder,Name)
		if foundPosition then
			ModifiedList[foundPosition] = Name
		else
			warn(("%s isn't listed!"):format(Name))
			nonListedMods[#nonListedMods+1] = Name
		end
	end)
	--]]
	for _,Name in next,SongInfo.__ModOrder do
		local searchIndex = table.find(NamesInOrder,Name)
		if searchIndex then -- filters the mods by removing the ones that are listed into the ModOrder list.
			ModifiedList[#ModifiedList+1] = Name
			table.remove(NamesInOrder,searchIndex)
		end
	end
	for _,Name in next,NamesInOrder do
		-- Add the non-listed ones to the bottom.
		ModifiedList[#ModifiedList+1] = Name
		warn(("%s isn't listed!"):format(Name))
	end
	NamesInOrder = ModifiedList
else
	table.sort(NamesInOrder,function(a,b)
		return a:lower()<b:lower()
	end)
end
--]]
--print(ModLibrary)
--local x,y = 1280,720
--local r = Vector2.new(x,y)*(workspace.Camera.ViewportSize / Vector2.new(x,y)).Y
--print(r,"|",workspace.Camera.ViewportSize)
--game:GetService("Selection"):Get()[1].Size = UDim2.new(0,r.X,0,r.Y)
UIHandler.ModLibrary = ModLibrary
UIHandler.SPUI_States = {
	SelectedSong = nil;
	SelectedMode = nil;
	SelectedMod = nil;
	DifficultyNum = nil;
	PlayerOptions = nil;
	PlayerOptionNum = nil;
	AvailableDiffs = nil;
	AvailablePlayers = {0,0};
	SongNum = nil;
	SongName = nil;
	Locked = false;
	Locked2 = false;
}

UIHandler.SettingsUIStates = {
	IsOpen = false;
}

--[[
function UIHandler.Update(AxisLock)
	local newSize = Vector2.new(AspectRatioX,AspectRatioY)
		*(
			workspace.CurrentCamera.ViewportSize / Vector2.new(AspectRatioX,AspectRatioY)
		)[AxisLock and (typeof(AxisLock) == "EnumItem" and AxisLock.Name) or "Y"]
	UIHandler.UI.Size = UDim2.new(0,newSize.X,0,newSize.Y)
end
--]]

-- Initialize UI

local SPEvent = Instance.new("BindableEvent")

local SMEvent = Instance.new("BindableEvent")

local MCEvent = Instance.new("BindableEvent")
--local DLCEvent = Instance.new("BindableEvent") -- Difficulty List Change Event
-- position and text is adjusted later
UIHandler.SongPlayEvent = SPEvent.Event
UIHandler.SelectModeEvent = SMEvent.Event
local TweenRepository = {}
local IdRandom = Random.new(tick())
local ModObjects = {}
local SongObjects = {}


-- Song Selection UI

-- UI Elements

local ModPick = ScreenGui.SongPickUI.ModPick
local SongPick = ScreenGui.SongPickUI.SongPick
local SongActions = ScreenGui.SongPickUI.SongPick.SongActions
local SongActions2 = ScreenGui.SongPickUI.SongPick.SongActions2
local DescPart = ScreenGui.SongPickUI.ModPick.BottomPart
local Disk = ScreenGui.SongPickUI.Disk
local Score = ScreenGui.SongPickUI.ModPick.Score
local originalPos = {
	ModPick = ModPick.Position;
	SongPick = SongPick.Position;
	Disk = Disk.Position
}
local DiskIcon = Sprite.new(Disk.Icon,true,1,true,defaultScreenSize)
local MPBack,SPBack = ModPick.BackgroundCrop.Background,SongPick.BackgroundCrop.Background
local CreditsText = Instance.new("TextLabel")
CreditsText.BackgroundTransparency = 1
CreditsText.TextStrokeTransparency = 0
CreditsText.Size = UDim2.new(1,0,1,0)
CreditsText.TextSize = 30 * SSDiff.X;
CreditsText.TextYAlignment = Enum.TextYAlignment.Top
CreditsText.TextWrapped = true
CreditsText.TextColor3 = Color3.new(1,1,1)
CreditsText.TextStrokeColor3 = Color3.new(0,0,0)
CreditsText.Font = Enum.Font.Arial
CreditsText.Text = "Made by your mom"
CreditsText.Parent = DescPart
-- visual settings lol

local NotSelectedOffset = 75 -- Must be in positive, distancing from the selected mod.

-- Create the mod buttons
do

	-- Settings i think

	local font = Enum.Font.SourceSansBold -- Mod selection font
	local fontSize = 45

	-- math stuff

	local offsetCounter = 0
	local count = 1

	for _,ModName in next,NamesInOrder do -- beacuse #table doesn't count dictionary elements, im using this instead.
		local fontSize = fontSize * SSDiff.X
		local textSize = TS:GetTextSize(ModName,fontSize,font,Vector2.new(1000,50)*SSDiff)
		if count ~= 1 then
			offsetCounter += (textSize.X/2)
		end
		local ModButton = {
			Index = table.find(NamesInOrder,ModName);
			ButtonObject = Instance.new("TextButton");
			CenterOffset = 0;
			OriginalFont = font;
			OriginalFontSize = fontSize;
			TextSize = textSize
		}
		ModButton.ButtonObject.BackgroundTransparency = 1
		ModButton.ButtonObject.Text = ModName
		ModButton.ButtonObject.TextSize = fontSize
		ModButton.ButtonObject.Font = font
		ModButton.ButtonObject.AnchorPoint = Vector2.new(0.5,0.5)
		ModButton.ButtonObject.Size = UDim2.fromOffset(textSize.X,textSize.Y)
		ModButton.ButtonObject.TextStrokeTransparency = 0
		ModButton.ButtonObject.Position = UDim2.new(0.5,offsetCounter,0.5,0)
		--ModButton.ButtonObject.TextXAlignment = Enum.TextXAlignment.Center

		ModObjects[ModName] = ModButton
		ModButton.ButtonObject.MouseButton1Click:Connect(function()
			UIHandler.MoveToMod(ModName)
		end)
		-- Customization and stuff
		if SongInfo[ModName] then
			for Index,Value in next,SongInfo[ModName] do
				if Index:sub(0,6) == "OBJPR_" then
					local success,status = pcall(function() ModButton.ButtonObject[Index:sub(7,-1)] = Value end)
					if not success then
						warn(("Attempting to change %s has error! (In %s, Info: \n%s)"):format(Index:sub(7,-1),ModName,status))
					end
				end
			end
		end
		ModButton.OriginalFont = ModButton.ButtonObject.Font
		ModButton.OriginalFontSize = ModButton.ButtonObject.TextSize
		ModButton.CenterOffset = offsetCounter
		ModButton.ButtonObject.Parent = ModPick
		offsetCounter += (textSize.X/2) + (30)
		count += 1
	end
end

-- functions to handle the UI stuff

function UIHandler.MoveToMod(ModName,silent) -- mod change
	local ModButton = ModObjects[ModName]
	if not ModButton then
		error(("%s mod doesn't exist!"):format(ModName))
	end

	local twAnimInfo = TweenInfo.new(0.2,Enum.EasingStyle.Circular,Enum.EasingDirection.Out)


	if WarningInfo[ModName] and ModButton.ButtonObject.Parent.Parent:FindFirstChild("Warnings") then
		local WarningFrame = ModButton.ButtonObject.Parent.Parent.Warnings 

		if #WarningInfo[ModName] > 0 then
			--WarningFrame.Visible = true
			TwS:Create(WarningFrame,twAnimInfo,{BackgroundTransparency = .5}):Play()
			for i,v in pairs(WarningFrame:GetChildren()) do 
				if v:IsA("TextLabel") then
					TwS:Create(v,twAnimInfo,{TextTransparency = 0,TextStrokeTransparency = 0}):Play()
				end
			end

			for i = 1,#ComaprismWarningList do 			
				if WarningInfo[ModName][i] and WarningInfo[ModName][i] == true then
					WarningFrame[ComaprismWarningList[i]].Visible = true
				else
					WarningFrame[ComaprismWarningList[i]].Visible = false
				end
			end
		else
			for i,v in pairs(WarningFrame:GetChildren()) do 
				if v:IsA("TextLabel") then
					TwS:Create(v,twAnimInfo,{TextTransparency = 1,TextStrokeTransparency = 1}):Play()
				end
			end
			TwS:Create(WarningFrame,twAnimInfo,{BackgroundTransparency = 1}):Play()	
			--WarningFrame.Visible = false
		end
	end

	for ModName,otherModButton in next,ModObjects do
		if otherModButton == ModButton then continue end -- skip the selected one
		local isBehindSel = otherModButton.CenterOffset < ModButton.CenterOffset
		local tweenAnim = TwS:Create(otherModButton.ButtonObject,twAnimInfo,{
			Position = UDim2.new(0.5,
				(otherModButton.CenterOffset - ModButton.CenterOffset) + (isBehindSel and -NotSelectedOffset or NotSelectedOffset)
				,0.5,0
			);
			TextSize = ModButton.OriginalFontSize;
		})
		tweenAnim:Play()
	end
	local bigTextSize = TS:GetTextSize(ModName,ModButton.OriginalFontSize + (10*SSDiff.X),ModButton.ButtonObject.Font,Vector2.new(1000,100)*SSDiff) + Vector2.new((NotSelectedOffset-24)/2)
	local tweenAnim = TwS:Create(ModButton.ButtonObject,twAnimInfo,{
		Position = UDim2.new(0.5,0,0.5,0);
		TextSize = ModButton.OriginalFontSize + (10*SSDiff.X);
	})
	tweenAnim:Play()

	TwS:Create(ModPick.Last,twAnimInfo,{
		Position = UDim2.new(0.5+((-bigTextSize.X/2)/ModPick.AbsoluteSize.X),0,0.5,0);
	}):Play()
	TwS:Create(ModPick.Next,twAnimInfo,{
		Position = UDim2.new(0.5+((bigTextSize.X/2)/ModPick.AbsoluteSize.X),0,0.5,0);
	}):Play()

	UIHandler.SPUI_States.SelectedMod = ModButton
	if not silent then ScreenGui.UI.Accept:Play() end
	local SongInfoTable = SongInfo[ModName]
	CreditsText.Text = SongInfoTable and SongInfoTable.Description or "[ MISSING CREDITS ]"
	TwS:Create(SPBack,twAnimInfo,{
		ImageColor3 = SongInfoTable and (SongInfoTable.BGColor or SongInfoTable.OBJPR_TextColor3) or Color3.new(0.156863, 0.156863, 0.156863),
		BackgroundColor3 = SongInfoTable and (SongInfoTable.BGColor and (SongInfoTable.BGColor2) or SongInfoTable.OBJPR_TextStrokeColor3) or Color3.new(0.105882, 0.105882, 0.105882)
	}):Play()
	--SPBack.ImageColor3 = SongInfoTable and (SongInfoTable.BGColor or SongInfoTable.OBJPR_TextColor3) or Color3.new(0.156863, 0.156863, 0.156863)
	-- Song list update

	-- clear the last list

	for Position,SongButton in next,SongObjects do
		SongButton.DiffModules = nil -- It's referenced to the ModLibrary table, just remove the reference.
		SongButton.SongButton:Destroy()
		--SongObjects[Position] = nil
	end
	table.clear(SongObjects)

	local offset = (SongInfo[ModName] and SongInfo[ModName].SongOrder) and #SongInfo[ModName].SongOrder or 0
	do
		-- Song Buttons settings lol
		local font = Enum.Font.Arial
		local fontSize = 50

		for SongName,Difficulties in next,ModLibrary[ModName] do
			-- Try to get a pre-set position from the SongOrder list
			local SongPos = SongInfo[ModName] and table.find(SongInfo[ModName].SongOrder,SongName)
			if not SongPos then offset += 1;SongPos = offset end

			-- UI Element stuff
			local fontSize = fontSize * SSDiff.X
			local textSize = TS:GetTextSize(SongName,fontSize,font,Vector2.new(1000,50)*SSDiff)

			local SongUI = Instance.new("TextButton")
			SongUI.BackgroundTransparency = 1
			SongUI.Text = SongName 
			SongUI.TextSize = fontSize
			SongUI.Font = font
			SongUI.AnchorPoint = Vector2.new(0,0.5)
			SongUI.Size = UDim2.new(0,textSize.X,0,textSize.Y)
			SongUI.TextStrokeTransparency = 0
			--SongUI.Position = UDim2.new(0.25,0,0.5,(textSize.Y+2)*(SongPos-1))
			SongUI.TextXAlignment = Enum.TextXAlignment.Left
			SongUI.TextColor3 = Color3.new(1,1,1)
			SongUI.MouseButton1Click:Connect(function()
				UIHandler.SelectSong(SongPos)
			end)

			local SongButton = {
				DiffModules = Difficulties;
				SongButton = SongUI;
				Position = SongPos;
				Name = SongName;
				TextSize = textSize;
			}
			SongUI.Parent = SongPick
			SongObjects[SongPos] = SongButton
		end
	end
	UIHandler.SelectSong(1,true)
end

local function getSortedDiff(DiffTable)
	local sorted = {}
	for _,DiffName in next,DifficultyList do
		if DiffTable[DiffName] then
			sorted[#sorted+1] = DiffName
		end
	end
	return sorted
end

function UIHandler.SelectSong(identifier:string|number,silent) -- only works for the current selected mod!
	local SongSelect
	local index
	if type(identifier) == "string" then
		for Pos,SongButton in next,SongObjects do
			if SongButton.Name == identifier then
				SongSelect = SongButton
				index = Pos
				break
			end
		end
	elseif type(identifier) == "number" then
		SongSelect = SongObjects[identifier]
		index = identifier
	end

	if not SongSelect then return end
	-- tween stuff i think
	UIHandler.SPUI_States.SongNum = index
	local twAnimInfo = TweenInfo.new(0.15,Enum.EasingStyle.Circular,Enum.EasingDirection.Out)
	for SongPos,SongButton in next,SongObjects do
		if SongButton == SongSelect then continue end
		if silent then
			SongButton.SongButton.Position = UDim2.new(0.25+(math.cos(math.pi*((SongButton.Position-SongSelect.Position)/25))-1),0,0.5,(SongButton.TextSize.Y+2)*(SongButton.Position-SongSelect.Position))
		else
			local twAnim = TwS:Create(SongButton.SongButton,twAnimInfo,{
				Position = UDim2.new(0.25+(math.cos(math.pi*((SongButton.Position-SongSelect.Position)/25))-1),0,0.5,(SongButton.TextSize.Y+2)*(SongButton.Position-SongSelect.Position));
				--TextTransparency = math.abs(((SongButton.SongButton.AbsolutePosition.Y + (SongButton.SongButton.AbsoluteSize.Y/2))-(SongPick.AbsoluteSize.Y/2))/(SongPick.AbsoluteSize.Y/2))
			})
			twAnim:Play()
		end
		--[[
		local ranTime = tick()
		local origin = SongButton.SongButton.Position
		local endPos = UDim2.new(0.25,0,0.5,(SongButton.TextSize.Y+2)*(SongButton.Position-SongSelect.Position))
		local dist = endPos - origin
		local tweenDuration = 0.15
		local tweenFunc = function()
			repeat
				local val = TwS:GetValue((tick() - ranTime) / (tweenDuration),Enum.EasingStyle.Cubic,Enum.EasingDirection.Out)
				local maththinge = (math.cos(math.pi*((SongButton.Position-SongSelect.Position)/20))-1)
				SongButton.SongButton.Position = UDim2.new(
					origin.X.Scale + (dist.X.Scale * val),
					origin.X.Offset + (dist.X.Offset * val),
					origin.Y.Scale + (dist.Y.Scale * val),
					origin.Y.Offset + (dist.Y.Offset * val)
				)
				RS.RenderStepped:Wait()
			until tick() > ranTime + tweenDuration
			SongButton.SongButton.Position = UDim2.new(0.25+(math.cos(math.pi*((SongButton.Position-SongSelect.Position)/20))-1),0,0.5,(SongButton.TextSize.Y+2)*(SongButton.Position-SongSelect.Position))
			-- final position
		end
		local thread = coroutine.create(tweenFunc)
		coroutine.resume(thread)--]]


	end
	if silent then
		SongSelect.SongButton.Position = UDim2.new(0.25,0,0.5,0)
	else
		local twAnim = TwS:Create(SongSelect.SongButton,twAnimInfo,{
			Position = UDim2.new(0.25,0,0.5,0)
		})
		twAnim:Play()
	end

	local AvDif = getSortedDiff(SongSelect.DiffModules)
	local normalDiff = table.find(AvDif,"Normal")
	local standard = table.find(PlayerOptionList,"Duel")
	UIHandler.SPUI_States.DifficultyNum = normalDiff or 1
	UIHandler.SPUI_States.AvailableDiffs = AvDif
	UIHandler.SPUI_States.PlayerOptions = PlayerOptionList
	UIHandler.SPUI_States.PlayerOptionNum = standard or 1
	UIHandler.SPUI_States.SelectedSong = SongSelect
	local songs = RepS.Modules.Songs:GetDescendants()
	local selectedSong
	for i =1, #songs do
		if songs[i].Name == SongSelect.Name then
			selectedSong = songs[i]
			if selectedSong and selectedSong:GetAttribute("Locked") == true then
				TwS:Create(SongActions.Lock,TweenInfo.new(0.4),{ImageTransparency = 0}):Play()
				UIHandler.SPUI_States.Locked = true
				print(UIHandler.SPUI_States.Locked)
			else
				TwS:Create(SongActions.Lock,TweenInfo.new(0.3),{ImageTransparency = 1}):Play()
				UIHandler.SPUI_States.Locked = false
			end
			--print(UIHandler.SPUI_States.SongName)
			--print(SongIdInfo[UIHandler.SPUI_States.SongName])
		end
	end

	UIHandler.ChangeDiff(UIHandler.SPUI_States.DifficultyNum)
	UIHandler.PlayerMode(UIHandler.SPUI_States.PlayerOptionNum)
	if not silent then ScreenGui.UI.Accept:Play() end
end

function UIHandler.ChangeDiff(x)-- x can be either a number or a string.
	if type(x) == "number" then
		-- Check if the number is within the bounds of the available difficulties.
		if x <= 0 or x > #UIHandler.SPUI_States.AvailableDiffs then
			error(("Number is out of bounds! (Current diffs: %s, got %s)"):format(tostring(#UIHandler.SPUI_States.AvailableDiffs),tostring(x)))
		end
	elseif type(x) == "string" then
		-- Check if the name exists in the difficulties.
		local index = table.find(UIHandler.SPUI_States.AvailableDiffs,x)
		if not index then
			error(("%s doesn't exist!"):format(x))
		end
		x = index
	else
		error(("Invalid argument, expected string/number (got %s)"):format(type(x)))
	end
	UIHandler.SPUI_States.DifficultyNum = x
	local name = UIHandler.SPUI_States.AvailableDiffs[UIHandler.SPUI_States.DifficultyNum]
	SongActions.DiffText.Text = name -- text
	SongActions.DiffText.TextStrokeColor3 = DifficultyColor[name] or Color3.new(1, 1, 1)
	SongActions.DiffText.TextColor3 = DifficultyColor2[name] or Color3.new(0,0,0)
	SongActions.DiffText.Font = DifficultyFont[name] or Enum.Font.Arial
	
	if x < #UIHandler.SPUI_States.AvailableDiffs then
		SongActions.Harder.Visible = true
	else
		SongActions.Harder.Visible = false
	end
	if x ~= 1 then
		SongActions.Easier.Visible = true
	else
		SongActions.Easier.Visible = false
	end

	local songData = HS:JSONDecode(require(UIHandler.SPUI_States.SelectedSong.DiffModules[name]))
	UIHandler.SPUI_States.SongName = songData.song.song
	DiskIcon.Animations = {} -- reset the animations
	DiskIcon.CurrAnimation = nil
	DiskIcon.AnimData.Looped = false
	--print(UIHandler.SPUI_States.SongName .. '-' .. name)
	local songPlayed = UIHandler.SPUI_States.SongName .. "-" .. name
	--print(gameSettings.settings.SongScores)
	local scoretext = '000000000'
	local accuracytext = '0.00%'
	for i = 1, #gameSettings.settings.SongScores do
		if gameSettings.settings.SongScores[i][1] == songPlayed then
			scoretext = tostring(gameSettings.settings.SongScores[i][2])
			accuracytext = tostring(gameSettings.settings.SongScores[i][3]) .. "%"
		end
	end
	Score.Points.Text = scoretext --gameSettings.settings.SongScores
	Score.Accuracy.Text = accuracytext
	local IconInfo = (Icons[songData.song.player2] or Icons.Face)
	if IconInfo.NormalXMLArgs then
		DiskIcon:AddSparrowXML(IconInfo.NormalXMLArgs[1],"Display",unpack(IconInfo.NormalXMLArgs,2))
		DiskIcon.Animations.Display.ImageId = IconInfo.NormalId
		for i = 1, #DiskIcon.Animations.Display.Frames do
			DiskIcon.Animations.Display.Frames[i].FrameSize = IconInfo.NormalDimensions
		end
	else
		DiskIcon:AddAnimation("Display",{{
			Size = IconInfo.NormalDimensions;
			FrameSize = IconInfo.NormalDimensions;
			Offset = IconInfo.OffsetNormal or Vector2.new();
		}},1,true,IconInfo.NormalId)
	end
	DiskIcon:PlayAnimation("Display")
	DiskIcon:ResetAnimation()
end

function UIHandler.PlayerMode(x)
	if type(x) == "number" then
		-- Check if the number is within the bounds of the available difficulties.
		if x <= 0 or x > #UIHandler.SPUI_States.PlayerOptions then
			error(("Number is out of bounds! (Current diffs: %s, got %s)"):format(tostring(#UIHandler.SPUI_States.PlayerOptions),tostring(x)))
		end
	elseif type(x) == "string" then
		-- Check if the name exists in the difficulties.
		local index = table.find(UIHandler.SPUI_States.PlayerOptions,x)
		if not index then
			error(("%s doesn't exist!"):format(x))
		end
		x = index
	else
		error(("Invalid argument, expected string/number (got %s)"):format(type(x)))
	end
	UIHandler.SPUI_States.PlayerOptionNum = x
	local name = UIHandler.SPUI_States.PlayerOptions[UIHandler.SPUI_States.PlayerOptionNum]
	SongActions2.DiffText.Text = name -- text
	SongActions2.DiffText.TextStrokeColor3 = PlayerOptionColor[name] or Color3.new(1, 1, 1)
	SongActions2.Start.TextTransparency = PlayerOptionList[UIHandler.SPUI_States.PlayerOptionNum] == UIHandler.SPUI_States.SelectedMode and 1 or 0
	if SongIdInfo[UIHandler.SPUI_States.SongName] then
		if PlayerOptionList[UIHandler.SPUI_States.PlayerOptionNum] == "Coop" then
			if SongIdInfo[UIHandler.SPUI_States.SongName].BF2Animations then
				UIHandler.SPUI_States.AvailablePlayers[1] = 1;
			else
				UIHandler.SPUI_States.AvailablePlayers[1] = 0;
			end
			if SongIdInfo[UIHandler.SPUI_States.SongName].Dad2Animations then
				UIHandler.SPUI_States.AvailablePlayers[2] = 1;
			else
				UIHandler.SPUI_States.AvailablePlayers[2] = 0;
			end
			if SongIdInfo[UIHandler.SPUI_States.SongName].BF2Animations or SongIdInfo[UIHandler.SPUI_States.SongName].Dad2Animations then
				TwS:Create(SongActions2.Lock,TweenInfo.new(0.3),{ImageTransparency = 1}):Play()
				UIHandler.SPUI_States.Locked2 = false
			else
				TwS:Create(SongActions2.Lock,TweenInfo.new(0.4),{ImageTransparency = 0}):Play()
				UIHandler.SPUI_States.Locked2 = true
			end
		else
			TwS:Create(SongActions2.Lock,TweenInfo.new(0.3),{ImageTransparency = 1}):Play()
			UIHandler.SPUI_States.Locked2 = false
		end
	end
	--SongActions2.DiffText.Font = PlayerOptionList[name] or Enum.Font.Arial
end

UIHandler.MoveToMod(NamesInOrder[1],true)

local menuUIConnection

local enterTwI = TweenInfo.new(0.3,Enum.EasingStyle.Circular,Enum.EasingDirection.Out)
local leaveTwI = TweenInfo.new(0.4,Enum.EasingStyle.Circular,Enum.EasingDirection.Out)

function UIHandler.ToggleUISongPickVisibility(state:bool)
	local funnyTweens
	if state then
		-- set their positions
		ModPick.Position = UDim2.fromScale(0.5,-0.355)
		SongPick.Position = UDim2.fromScale(0.5,1.355)
		Disk.Position = UDim2.fromScale(-0.3,1.15)

		ModPick.Visible = state
		SongPick.Visible = state
		SongActions.Visible = state
		--SongActions2.Visible = state -- this is unsused but it works
		Score.Visible = state
		Disk.Visible = state
		-- Tween?
		funnyTweens = {
			TwS:Create(ModPick,enterTwI,{
				Position = originalPos.ModPick;
			}),
			TwS:Create(SongPick,enterTwI,{
				Position = originalPos.SongPick;
			}),
			TwS:Create(Disk,enterTwI,{
				Position = originalPos.Disk;
			}),
		}
		funnyTweens[1].Completed:Connect(function(twstate)
			if twstate ~= Enum.PlaybackState.Completed then return end
			for i,v in next,funnyTweens do 
				v:Destroy()
			end
		end)
	else
		funnyTweens = {
			TwS:Create(ModPick,leaveTwI,{
				Position = UDim2.fromScale(0.5,-0.355);
			}),
			TwS:Create(SongPick,leaveTwI,{
				Position = UDim2.fromScale(0.5,1.355);
			}),
			TwS:Create(Disk,leaveTwI,{
				Position = UDim2.fromScale(-0.3,1.15);
			}),
		}
		funnyTweens[1].Completed:Connect(function(twstate)
			if twstate ~= Enum.PlaybackState.Completed then return end
			ModPick.Visible = false
			SongPick.Visible = false
			SongActions.Visible = false
			SongActions2.Visible = false
			Disk.Visible = false
			Score.Visible = false
			for i,v in next,funnyTweens do 
				v:Destroy()
			end
		end)
	end
	for i,v in next,funnyTweens do
		v:Play()
	end
	--print(UIHandler.SPUI_States.SongName .. '-' .. name)
	local songPlayed = tostring(UIHandler.SPUI_States.SongName) .. "-" .. tostring(UIHandler.SPUI_States.SelectedMod.Name)
	--print(gameSettings.settings.SongScores)
	local scoretext = '000000000'
	local accuracytext = '0.00%'
	for i = 1, #gameSettings.settings.SongScores do
		if gameSettings.settings.SongScores[i][1] == songPlayed then
			scoretext = tostring(gameSettings.settings.SongScores[i][2])
			accuracytext = tostring(gameSettings.settings.SongScores[i][3]) .. "%"
		end
	end
	Score.Points.Text = scoretext --gameSettings.settings.SongScores
	Score.Accuracy.Text = accuracytext
	UIHandler.DiskAnimSetState(state)
	if state then
		menuUIConnection = UIB.InputEvents.Pressed:Connect(function(Name,IO,gPU)
			if Name == "NextMod" then
				local currentIndex = UIHandler.SPUI_States.SelectedMod.Index
				if currentIndex + 1 == #NamesInOrder+1 then
					UIHandler.MoveToMod(NamesInOrder[1])
				else
					UIHandler.MoveToMod(NamesInOrder[currentIndex+1])
				end
			elseif Name == "LastMod" then 
				local currentIndex = UIHandler.SPUI_States.SelectedMod.Index
				if currentIndex - 1 == 0 then
					UIHandler.MoveToMod(NamesInOrder[#NamesInOrder])
				else
					UIHandler.MoveToMod(NamesInOrder[currentIndex-1])
				end
			elseif Name == "NextSong" then 
				local currentIndex = UIHandler.SPUI_States.SongNum
				if currentIndex + 1 == #SongObjects+1 then
					UIHandler.SelectSong(1)
				else
					UIHandler.SelectSong(currentIndex+1)
				end
			elseif Name == "LastSong" then
				local currentIndex = UIHandler.SPUI_States.SongNum
				if currentIndex - 1 == 0 then
					UIHandler.SelectSong(#SongObjects)
				else
					UIHandler.SelectSong(currentIndex-1)
				end
			elseif Name == "Easier" then
				if UIHandler.SPUI_States.DifficultyNum == 1 then
					UIHandler.ChangeDiff(#UIHandler.SPUI_States.AvailableDiffs)
				else
					UIHandler.ChangeDiff(UIHandler.SPUI_States.DifficultyNum -1)
				end
			elseif Name == "Harder" then
				if UIHandler.SPUI_States.DifficultyNum == #UIHandler.SPUI_States.AvailableDiffs then
					UIHandler.ChangeDiff(1)
				else
					UIHandler.ChangeDiff(UIHandler.SPUI_States.DifficultyNum + 1)
				end
			elseif Name == "StartSong" then 
				--[[
				local songSettings = {
					SpeedModifier=1;
				}--]]
				if not UIHandler.SPUI_States.Locked and not UIHandler.SPUI_States.Locked2 then
					local name = UIHandler.SPUI_States.SelectedMode
					if name~='Coop' or (name=='Coop' and SongIdInfo[UIHandler.SPUI_States.SongName].BF2Animations~=nil or SongIdInfo[UIHandler.SPUI_States.SongName].Dad2Animations~=nil) then
						local name = UIHandler.SPUI_States.AvailableDiffs[UIHandler.SPUI_States.DifficultyNum]
						SPEvent:Fire(UIHandler.SPUI_States.SelectedSong.DiffModules[name],UIHandler.SPUI_States.PlayerOptions[UIHandler.SPUI_States.PlayerOptionNum],UIHandler.SPUI_States.AvailablePlayers)
					else
						ScreenGui.Song.Cancel:Play()
					end
				else
					ScreenGui.Song.Cancel:Play()
				end
			end
		end)
	elseif menuUIConnection then
		menuUIConnection:Disconnect()
	end
end

-- Song Actions stuff
SongActions2.Start.MouseButton1Click:Connect(function()
	if not UIHandler.SPUI_States.Locked2 then
		UIHandler.SPUI_States.SelectedMode = UIHandler.SPUI_States.PlayerOptions[UIHandler.SPUI_States.PlayerOptionNum]
		SongActions2.Start.TextTransparency = PlayerOptionList[UIHandler.SPUI_States.PlayerOptionNum] == UIHandler.SPUI_States.SelectedMode and 1 or 0
		SMEvent:Fire(UIHandler.SPUI_States.PlayerOptions[UIHandler.SPUI_States.PlayerOptionNum],UIHandler.SPUI_States.AvailablePlayers)
	else
		ScreenGui.Song.Cancel:Play()
	end
end)
SongActions.Start.MouseButton1Click:Connect(function()
	--[[
	local songSettings = {
		SpeedModifier=1;
	}
	--]]
	if not UIHandler.SPUI_States.Locked and not UIHandler.SPUI_States.Locked2 then
		local name = UIHandler.SPUI_States.SelectedMode
		if name~='Coop' or (name=='Coop' and SongIdInfo[UIHandler.SPUI_States.SongName].BF2Animations~=nil or SongIdInfo[UIHandler.SPUI_States.SongName].Dad2Animations~=nil) then
			local name = UIHandler.SPUI_States.AvailableDiffs[UIHandler.SPUI_States.DifficultyNum]
			SPEvent:Fire(UIHandler.SPUI_States.SelectedSong.DiffModules[name],UIHandler.SPUI_States.PlayerOptions[UIHandler.SPUI_States.PlayerOptionNum],UIHandler.SPUI_States.AvailablePlayers)
		else
			ScreenGui.Song.Cancel:Play()
		end
	else
		ScreenGui.Song.Cancel:Play()
	end
	--ScreenGuiUI.UI.Button:Play()
end)
local EasierSprite = Sprite.new(SongActions.Easier,false,1,false)
EasierSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Idle","arrow left0",24,false)
EasierSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Press","arrow push left0",24,false)
EasierSprite:PlayAnimation("Idle")
local HarderSprite = Sprite.new(SongActions.Harder,false,1,false)
HarderSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Idle","arrow right0",24,false)
HarderSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Press","arrow push right0",24,false)
HarderSprite:PlayAnimation("Idle")
local EasierSprite2 = Sprite.new(SongActions2.Easier,false,1,false)
EasierSprite2:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Idle","arrow left0",24,false)
EasierSprite2:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Press","arrow push left0",24,false)
EasierSprite2:PlayAnimation("Idle")
local HarderSprite2 = Sprite.new(SongActions2.Harder,false,1,false)
HarderSprite2:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Idle","arrow right0",24,false)
HarderSprite2:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Press","arrow push right0",24,false)
HarderSprite2:PlayAnimation("Idle")

SongActions.Easier.MouseButton1Down:Connect(function()
	EasierSprite:PlayAnimation("Press")
end)
SongActions2.Easier.MouseButton1Down:Connect(function()
	EasierSprite2:PlayAnimation("Press")
end)
SongActions.Easier.MouseButton1Up:Connect(function()
	if UIHandler.SPUI_States.DifficultyNum == 1 then
		UIHandler.ChangeDiff(#UIHandler.SPUI_States.AvailableDiffs)
	else
		UIHandler.ChangeDiff(UIHandler.SPUI_States.DifficultyNum -1)
	end
	EasierSprite:PlayAnimation("Idle")
end)
SongActions2.Easier.MouseButton1Up:Connect(function()
	if UIHandler.SPUI_States.PlayerOptionNum == 1 then
		UIHandler.PlayerMode(#UIHandler.SPUI_States.PlayerOptions)
	else
		UIHandler.PlayerMode(UIHandler.SPUI_States.PlayerOptionNum -1)
	end
	EasierSprite2:PlayAnimation("Idle")
end)

SongActions.Harder.MouseButton1Down:Connect(function()
	HarderSprite:PlayAnimation("Press")
end)
SongActions2.Harder.MouseButton1Down:Connect(function()
	HarderSprite2:PlayAnimation("Press")
end)
SongActions.Harder.MouseButton1Up:Connect(function()
	if UIHandler.SPUI_States.DifficultyNum == #UIHandler.SPUI_States.AvailableDiffs then
		--UIHandler.SPUI_States.DifficultyNum = 1
		UIHandler.ChangeDiff(1)
	else
		UIHandler.ChangeDiff(UIHandler.SPUI_States.DifficultyNum + 1)
	end
	HarderSprite:PlayAnimation("Idle")
	--UIHandler.UpdateDifficultyUI()
end)
SongActions2.Harder.MouseButton1Up:Connect(function()
	if UIHandler.SPUI_States.PlayerOptionNum == #UIHandler.SPUI_States.PlayerOptions then
		--UIHandler.SPUI_States.DifficultyNum = 1
		UIHandler.PlayerMode(1)
	else
		UIHandler.PlayerMode(UIHandler.SPUI_States.PlayerOptionNum + 1)
	end
	HarderSprite2:PlayAnimation("Idle")
	--UIHandler.UpdateDifficultyUI()
end)
-- Mod Navigation buttons

local NextSprite = Sprite.new(ModPick.Next,false,1,false)
NextSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Idle","arrow right0",24,false)
NextSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Press","arrow push right0",24,false)
NextSprite:PlayAnimation("Idle")
local LastSprite = Sprite.new(ModPick.Last,false,1,false)
LastSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Idle","arrow left0",24,false)
LastSprite:AddSparrowXML(RepS.Modules.Assets["MFMUI.xml"],"Press","arrow push left0",24,false)
LastSprite:PlayAnimation("Idle")

ModPick.Last.MouseButton1Down:Connect(function()
	LastSprite:PlayAnimation("Press")
end)
ModPick.Last.MouseButton1Up:Connect(function()
	local currentIndex = UIHandler.SPUI_States.SelectedMod.Index
	if currentIndex - 1 == 0 then
		UIHandler.MoveToMod(NamesInOrder[#NamesInOrder])
	else
		UIHandler.MoveToMod(NamesInOrder[currentIndex-1])
	end
	LastSprite:PlayAnimation("Idle")
end)

ModPick.Next.MouseButton1Down:Connect(function()
	NextSprite:PlayAnimation("Press")
end)
ModPick.Next.MouseButton1Up:Connect(function()
	local currentIndex = UIHandler.SPUI_States.SelectedMod.Index
	if currentIndex + 1 == #NamesInOrder+1 then
		UIHandler.MoveToMod(NamesInOrder[1])
	else
		UIHandler.MoveToMod(NamesInOrder[currentIndex+1])
	end
	NextSprite:PlayAnimation("Idle")
end)

-- checkerboard pattern move thing

-- basic settings, idk
local topPatternImgSize = Vector2.new(1024,1024) -- based on the maximum roblox image size
local bottomPatternImgSize = Vector2.new(2,2)
local squareSize = Vector2.new(50,50) -- doesn't necesarily needs to be a square
local speedFactor = Vector2.new(8,7)
local offset = 0
-- end of the basic settings
local currentPos
--squareSize *= 2
MPBack.TileSize,SPBack.TileSize = UDim2.fromOffset(topPatternImgSize.X*squareSize.X,topPatternImgSize.Y*squareSize.Y),UDim2.fromOffset(bottomPatternImgSize.X*squareSize.X,bottomPatternImgSize.Y*squareSize.Y)

local function patternMove()
	--offset = offset + () 
	currentPos = Vector2.new( (tick()*speedFactor.X)%(squareSize.X*2) , (tick()*speedFactor.Y)%(squareSize.Y*2) )
	MPBack.Position = UDim2.new(0.5,(currentPos.X),0.5,currentPos.Y)
	SPBack.Position = UDim2.new(0.5,currentPos.X,0.5,currentPos.Y)
	--print(currentPos)
end

-- the ol' mighty disk
local DAState = false
function UIHandler.DiskAnimSetState(boolean)
	if boolean then
		DAState = true
		local function animPlay()
			repeat
				Disk.Rotation = (tick()*22)%360
				Disk.Reflection.Rotation = (math.sin((tick()) * math.pi)*3) - Disk.Rotation
				RS.RenderStepped:Wait()
				patternMove()
			until not DAState
		end
		coroutine.wrap(animPlay)()
	else
		DAState = false
	end
end

--					--
-- THE SEARCH! --
--					--
local searchButton = ScreenGui.SongPickUI.SearchButton
local searchFrame = ScreenGui.SongPickUI.SearchMenu

local modSearchButton,songSearchButton = script.SettingsElements.ModSearchButton,script.SettingsElements.SongSearchButton

searchFrame.SearchBar.FocusLost:Connect(function(enterPress) 
	if not enterPress then return end
	local matches:{{[string]:any}|string} = {}
	for _,v in next,allSongs do
		if string.match(v.SongName,searchFrame.SearchBar.Text) then
			table.insert(matches,v)
		end
	end
	for _,v in next,allMods do
		if string.match(v,searchFrame.SearchBar.Text) then
			table.insert(matches,v)
		end
	end
	table.sort(matches,function(a,b) 
		local rA,rB = type(a) ~= "string" and a.SongName or a,type(b) ~= "string" and b.SongName or b
		return rA < rB
	end)
	for i,v in next,matches do
		local butt
		if type(v) == "string" then
			butt = modSearchButton:Clone()
		else
			butt = songSearchButton:Clone()
			butt.SongName.Text = v.SongName
		end
		butt.ModName.Text = v.ModName or "Uncategorized"
		butt.Position = UDim2.new(0,0,0,50*(i-1))
		butt.Parent = searchFrame.results.actualResults
	end
end)

--             --
-- SETTINGS UI --
--             --

local funnySettings,containerFrame
local useFullscreenSettings = UIS.TouchEnabled or UIS.GamepadEnabled
if useFullscreenSettings then
	funnySettings = Instance.new("Frame")
	local container = Instance.new("Frame")
	funnySettings.Size = UDim2.fromScale(1,1)
	funnySettings.BorderSizePixel = 0
	funnySettings.BackgroundColor3 = Color3.fromRGB(49,49,49)
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1,0,1,-50)
	container.Position = UDim2.fromScale(0,1)
	container.AnchorPoint = Vector2.new(0,1)
	container.Name = "Contents"
	container.Parent = funnySettings
	containerFrame = container
else
	funnySettings = Window.new()
	--funnySettings.Name = "Settings"
	funnySettings.HideWhenClose = true
	funnySettings.Size = Vector2int16.new(725,450)
	funnySettings.Position = Vector2.new(20,20)

	funnySettings.Objects.Frame.BackgroundColor3 = Color3.fromRGB(49,49,49)
	funnySettings.Objects.Frame.BackgroundTransparency = 0
	funnySettings.Objects.Topbar.ImageColor3 = Color3.fromRGB(106,106,106)
	UIHandler.SettingWindow = funnySettings
	containerFrame = funnySettings.Objects.Contents
end
--funnySettings:UpdateZIndex()

local currentTabs = {}

function UIHandler.CreateTab(Name,Frame)
	if not Frame then
		Frame = Instance.new("Frame")
		Frame.BackgroundTransparency = 1
	end
	local TabHeight = 30
	local tabButton = ScreenGui.Resources.UIElements.Tab:Clone()
	local theTab = {
		Frame = Frame;
		TabButton = tabButton;
	}
	tabButton.Text.Text = Name
	local newIndex = #currentTabs+1
	local lastTab = currentTabs[#currentTabs]
	currentTabs[newIndex] = theTab
	if lastTab then 
		lastTab.TabButton.NextSelectionRight = tabButton 
		tabButton.NextSelectionLeft = lastTab.TabButton
	end
	for Index,Tab in next,currentTabs do
		Tab.TabButton.Position = UDim2.new((Index-1)/#currentTabs,0,0,0)
		Tab.TabButton.Size = UDim2.new(1/#currentTabs,0,0,TabHeight)
	end
	tabButton.MouseButton1Click:Connect(function()
		for Index,Tab in next,currentTabs do
			Tab.Frame.Parent = theTab == Tab and containerFrame or nil
		end
	end)
	Frame.AnchorPoint = Vector2.new(0,1)
	Frame.Position = UDim2.new(0,0,1,0)
	Frame.Size = UDim2.new(1,0,1,-TabHeight)
	--Frame.Parent = containerFrame
	tabButton.Visible = true
	tabButton.Parent = containerFrame
	return theTab
end

-- Moving the settings into here 

local settingButton = ScreenGui.ActualButton
local settingsTab = UIHandler.CreateTab("Settings")
local bindsTab = UIHandler.CreateTab("Keybinds")
local customTab = UIHandler.CreateTab("Customize")
--local infoTab = UIHandler.CreateTab("Info")
settingButton.NextSelectionDown = settingsTab.TabButton

local scrollCategory = Instance.new("ScrollingFrame")
scrollCategory.Size = UDim2.new(1/3,0,1,0)
scrollCategory.BackgroundTransparency = 1
scrollCategory.ScrollingDirection = Enum.ScrollingDirection.Y
scrollCategory.AutomaticCanvasSize = Enum.AutomaticSize.X
scrollCategory.VerticalScrollBarInset = Enum.ScrollBarInset.Always 
scrollCategory.Selectable = false
scrollCategory.Parent = settingsTab.Frame
local scrollSettings = Instance.new("ScrollingFrame")
scrollSettings.Size = UDim2.new(2/3,0,1,0)
scrollSettings.Position = UDim2.new(0.333333333333,0,0,0)
scrollSettings.BackgroundTransparency = 1
scrollSettings.Selectable = false
scrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y
scrollSettings.AutomaticCanvasSize = Enum.AutomaticSize.X
scrollSettings.VerticalScrollBarInset = Enum.ScrollBarInset.Always
scrollSettings.Parent = settingsTab.Frame
--[[
local infoText = Instance.new("TextLabel")
infoText.ZIndex = 4
infoText.BackgroundTransparency = 1
infoText.Size = UDim2.new(1,0,1,0)
infoText.TextScaled = true
infoText.TextColor3 = Color3.new(1, 1, 1)
infoText.TextStrokeColor3 = Color3.new(0,0,0)
infoText.BorderSizePixel = 1
infoText.TextStrokeTransparency = 0
infoText.Text = "For one, you might not recognize some of the mods and that is because I'm trying to add quality, underrated mods. By the way it is worth the time to go in and play each song(some will not be right) and if anything go out and play the actual mods because the people who make these mods are so much more talented than me and deserve so much love. If you have any suggestions, bug reports, or want to help development feel free to go visit the discord link I put in the game description."
infoText.Position = UDim2.new(0,5,0,5)
infoText.Parent = infoTab.Frame]]

local settingObjs = {}

function UIHandler.ToggleSettingsUI(bool)

end

function cloneTable(target,deep)
	local newTable = table.create(#target)
	for index,value in next,target do 
		local newIndex,newValue
		if typeof(index) == "table" and deep then
			newIndex = cloneTable(index)
		else
			newIndex = index
		end
		-- value
		if typeof(value) == "table" and deep then
			newValue = cloneTable(value)
		else
			newValue = value
		end

		newTable[newIndex] = newValue
	end
	return newTable
end

local function fireSaveSettings()
	local cloneData = cloneTable(gameSettings.settings)
	for maniaVal,Directions in next,cloneData.Keybinds do
		if type(cloneData.Keybinds[maniaVal]) ~= "table" then warn("Value isn't a table!");continue end
		for Index,KeyCodes in next,Directions do
			if type(cloneData.Keybinds[maniaVal][Index]) ~= "table" then warn("Value isn't a table!");continue end
			for Pos=1,7 do
				if KeyCodes[Pos] then
					local KeyCode = KeyCodes[Pos]
					KeyCodes[tostring(Pos)] = KeyCode
					KeyCodes[Pos] = nil										
				end
			end 
		end
	end
	InfoRetriever:InvokeServer(0x2,cloneData)
end

local open = false
settingButton.Activated:Connect(function()
	print'boop'
	if open then
		open = false
		funnySettings.Parent = nil
		fireSaveSettings()
	else
		funnySettings.Parent = ScreenGui
		open = true
	end
end)

local function getNearestVal(gettable,val,direction:bool?)
	local highestIndex = 0
	for i,v in next,gettable do
		if val < v then
			highestIndex = i
			break
		end
	end
	local valDist = gettable[highestIndex] - (gettable[highestIndex-1] or 0)
	local distFromhI = gettable[highestIndex] - val
	if direction == nil then
		return (distFromhI < valDist/2) and highestIndex or highestIndex - 1
	else
		return direction and highestIndex or highestIndex - 1
	end
end

local function cropDecimals(value,decimalCount):number
	if decimalCount < 0 then error(("value must be above 0 (got %s)"):format(tostring(decimalCount))) end
	return math.floor(value*(10^decimalCount))/(10^decimalCount)
end

-- Style settings, idk


local leftColor,rightColor = Color3.new(1, 1, 1),Color3.new()
local leftTrans,rightTrans = 0,0.8

local offColor,onColor =  Color3.new(0.14902, 0.14902, 0.14902),Color3.new(0.14902, 0.14902, 0.14902)

local verticalSize = 45 -- in pixels, vertical size for the settings items.
local CategoryYSize = 40 -- in pixels, vertical size for the category buttons.
local listItemYSize = 25 -- in pixels, same as above but for list items.

local dropDownXSize = 125
local maxItems = 10
local animDropdown = TweenInfo.new(0.3,Enum.EasingStyle.Circular,Enum.EasingDirection.Out)

local unbindedText = "---"

local categoryOrder = {
	"All";
	"Gameplay";
	"User Interface";
	"Miscellaneous";
	"Experimental";
}
local categoryButtons = {}
-- Generic settings
local maxKeybinds = 7
local editKeybind = {Enum.KeyCode.Return,Enum.KeyCode.ButtonA}
local eraseKeybind = {Enum.KeyCode.Backspace,Enum.KeyCode.ButtonB}
local consoleKeybinds = {
	nextTab = {Enum.KeyCode.ButtonR1};
	lastTab = {Enum.KeyCode.ButtonL1};
	openSettings = {Enum.KeyCode.ButtonY};
}

-- end

local currentSettings = {
	All = {}
}
local settingsObjects = {}
UIHandler.settingsObjects = settingsObjects
local unlistedSettings = {}
local hasInitialized = false
function UIHandler.SwitchSettingCategory(Name)
	if not currentSettings[Name] then error(("%s category is not registered"):format(Name)) end
	for _,settingObject in next,currentSettings.All do
		settingObject.Object.Parent = nil
		-- Empty the selection stuff
		settingObject.Object.Selectable = false
		settingObject.Object.NextSelectionDown = nil
		settingObject.Object.NextSelectionUp = nil
	end
	for Index,settingObject in next,currentSettings[Name] do
		settingObject.Object.Position = UDim2.new(0,0,0,verticalSize*(Index-1))
		local nextObj,lastObj = currentSettings[Name][Index+1],currentSettings[Name][Index-1]
		settingObject.Object.Selectable = true
		settingObject.Object.NextSelectionDown = nextObj and nextObj.Object or nil
		settingObject.Object.NextSelectionUp = lastObj and lastObj.Object or nil
		settingObject.Object.Parent = scrollSettings
	end
	scrollSettings.CanvasSize = UDim2.new(1,0,0,verticalSize*#currentSettings[Name])
end


local NoteXmls = {
	RepS.Modules.Assets["Note4K.xml"];
	RepS.Modules.Assets["Note6K.xml"];
	RepS.Modules.Assets["Note9K.xml"];
	RepS.Modules.Assets["Note9K.xml"];
	RepS.Modules.Assets["Note9K.xml"];
	RepS.Modules.Assets["Note9K.xml"];
}-- this is dumb

local function getNoteskinObjects(mania,name) -- If the noteskin is not valid, it will return the original noteskin instead.
	local m = {4,6,8,5,7,8}
	local maniaFolder = RepS.Modules.Assets:FindFirstChild("noteSkins" .. m[mania] .. "K")
	if maniaFolder == nil then return end
	local Img = maniaFolder:FindFirstChild(name) or maniaFolder.Original
	local xml = Img:FindFirstChild("XML") or Img:FindFirstChild("XMLRef") or NoteXmls[mania]
	if xml:IsA("ObjectValue") then
		xml = xml.Value
	end
	return Img,xml
end

local maniaUITable = {}

function UIHandler.SetGameBind(maniaVal,DirectionVal,index,keyCode)
	print(maniaVal,DirectionVal,index,keyCode)
	gameSettings.settings.Keybinds[maniaVal][DirectionVal][index] = ((typeof(keyCode) == "EnumItem" and keyCode.EnumType == Enum.KeyCode) or keyCode == nil) and keyCode or nil
	maniaUITable[maniaVal][DirectionVal][index].Text = keyCode and keyCode.Name or unbindedText
end

function UIHandler.InitializeSettings()
	if hasInitialized then return end
	hasInitialized = true
	-- insert the unlisted rulers to the __ORDER list.
	for Name,SettingRule in next,gameSettings.settingsRules do
		if table.find(gameSettings.settingsRules.__ORDER,Name) then continue end
		warn(("%s is not listed in __ORDER table"):format(Name))
		gameSettings.settingsRules.__ORDER[#gameSettings.settingsRules.__ORDER+1] = Name
	end
	-- Process the order list

	for Index,Name in next,gameSettings.settingsRules.__ORDER do
		local settingRule = gameSettings.settingsRules[Name]
		if not settingRule then warn(("%s isn't found, skipping"):format(Name));continue end
		local valueType = settingRule.Type
		local value = gameSettings.settings[Name]
		if value == nil then warn(("%s is not a setting, skipping"):format(Name));continue end
		local settingInputObject = script.SettingsElements:FindFirstChild(valueType)
		if not settingInputObject then  warn(("%s value type invalid, skipping"):format(Name));continue end
		local roundVal = type(settingRule.DecimalRounding) ~= "number" and 2 or settingRule.DecimalRounding
		settingInputObject = settingInputObject:Clone()
		settingInputObject.Text.Text = settingRule.DisplayName
		settingInputObject.Size = UDim2.new(1,0,0,verticalSize)
		settingInputObject.Visible = true
		-- create an event
		local valChangeEvent = Instance.new("BindableEvent")
		-- im not even gonna bother adding another module to support custom classes again on this one
		local settingObject = {
			Object = settingInputObject;
			ValueChanged = valChangeEvent.Event;
			Standalone = false;
		}
		local lastSelectedSetting
		-- Do something with their objects respective by their type
		if valueType == "number" then
			-- Add an updating function.
			local function updateValue(newValue,roundCount)
				if roundCount and type(roundCount) == "number" then
					newValue = cropDecimals(newValue,roundCount) -- Round the value, idk
				end
				if type(newValue) ~= "number" then -- If no value given, use the same value and just update the UI.
					newValue = gameSettings.settings[Name]
				end
				gameSettings.settings[Name] = newValue
				valChangeEvent:Fire(newValue)

				local valMul = (newValue - settingRule.Min)/(settingRule.Max-settingRule.Min)
				settingInputObject.Input.Value.Text = cropDecimals(newValue,2) .. settingRule.Measure
				settingInputObject.Input.Bar.Dragger.Position = UDim2.fromScale(valMul,0.5)
				if valMul == 0 then
					settingInputObject.Input.Bar.BackgroundGradient.Color = ColorSequence.new(rightColor)
					settingInputObject.Input.Bar.BackgroundGradient.Transparency = NumberSequence.new(rightTrans)
				elseif valMul == 1 then
					settingInputObject.Input.Bar.BackgroundGradient.Color = ColorSequence.new(leftColor)
					settingInputObject.Input.Bar.BackgroundGradient.Transparency = NumberSequence.new(leftTrans)
				else
					settingInputObject.Input.Bar.BackgroundGradient.Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0,leftColor);
						ColorSequenceKeypoint.new(valMul,leftColor);
						ColorSequenceKeypoint.new(valMul + 0.0001,rightColor);
						ColorSequenceKeypoint.new(1,rightColor);
					}
					settingInputObject.Input.Bar.BackgroundGradient.Transparency = NumberSequence.new{
						NumberSequenceKeypoint.new(0,leftTrans);
						NumberSequenceKeypoint.new(valMul,leftTrans);
						NumberSequenceKeypoint.new(valMul + 0.0001,rightTrans);
						NumberSequenceKeypoint.new(1,rightTrans);
					}
				end
			end
			-- Implement the functionality

			-- Console Interaction
			if UIS.GamepadEnabled then
				local inputListener
				settingInputObject.SelectionGained:Connect(function()
					print("Selected " .. Name)
					lastSelectedSetting = settingInputObject
					inputListener = UIS.InputBegan:Connect(function(io)
						-- some action should go here
						if io.KeyCode == Enum.KeyCode.ButtonA then
							settingInputObject.Input.Value:CaptureFocus()
						end
					end)
				end)
				settingInputObject.SelectionLost:Connect(function()
					if inputListener then inputListener = inputListener:Disconnect() end
				end)
			end
			-- Changes via the TextBox
			settingInputObject.Input.Value.Focused:Connect(function()
				settingInputObject.Input.Value.Text = gameSettings.settings[Name]
				settingInputObject.Input.Value.PlaceholderText = cropDecimals(gameSettings.settings[Name],2)
			end)
			settingInputObject.Input.Value.FocusLost:Connect(function(enterPress)
				local newValue = tonumber(settingInputObject.Input.Value.Text)
				if enterPress and newValue then
					updateValue(newValue)
				else
					settingInputObject.Input.Value.Text = cropDecimals(gameSettings.settings[Name],2) .. settingRule.Measure
				end
			end)
			-- Changes via the bar
			local isDown
			local fingerInput
			settingInputObject.Input.Bar.InputBegan:Connect(function(io)
				if (io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch) and io.UserInputState == Enum.UserInputState.Begin then
					--print("Work!")
					if UIS.TouchEnabled and io.UserInputType == Enum.UserInputType.Touch then
						fingerInput = io
						if settingInputObject.Parent and settingInputObject.Parent:IsA("ScrollingFrame") then
							settingInputObject.Parent.ScrollingEnabled = false
						end
					end
					isDown = RS.RenderStepped:Connect(function()
						local dist = (io.UserInputType == Enum.UserInputType.Touch and io.Position.X or Mouse.X) - settingInputObject.Input.Bar.AbsolutePosition.X
						local valMul = dist/settingInputObject.Input.Bar.AbsoluteSize.X
						local newPos
						if dist < 0 or dist > settingInputObject.Input.Bar.AbsoluteSize.X then
							if dist < 0 then
								newPos = UDim2.new()
								valMul = 0
							else
								newPos = UDim2.new(1,0,0,0)
								valMul = 1
							end
						else
							newPos = UDim2.new(dist/settingInputObject.Input.Bar.AbsoluteSize.X)
						end
						updateValue(((settingRule.Max - settingRule.Min) * valMul) + settingRule.Min,roundVal)
					end)
				end
			end)
			if UIS.MouseEnabled then
				UIS.InputEnded:Connect(function(io)
					if io.UserInputType == Enum.UserInputType.MouseButton1 and io.UserInputState == Enum.UserInputState.End then
						--print("Ended!")
						if isDown then isDown:Disconnect() end
						isDown = false
					end
				end)
			end
			if UIS.TouchEnabled then
				UIS.TouchEnded:Connect(function(io)
					if fingerInput and fingerInput ~= io then
						return
					end
					fingerInput = nil
					if settingInputObject.Parent and settingInputObject.Parent:IsA("ScrollingFrame") then
						settingInputObject.Parent.ScrollingEnabled = true
					end
					if isDown then isDown:Disconnect() end
					isDown = false
				end)
			end
			--
			updateValue() -- Update the UI
			settingObject.SetValue = updateValue
		elseif valueType == "bool" then
			settingInputObject.Input.Toggle.BackgroundColor3 = value and onColor or offColor
			settingInputObject.Input.Toggle.ImageTransparency = value and 0 or 1
			-- Implement the functionality
			if UIS.GamepadEnabled then
				local inputListener
				settingInputObject.SelectionGained:Connect(function()
					lastSelectedSetting = settingInputObject
					inputListener = UIS.InputBegan:Connect(function(io)
						if io.KeyCode == Enum.KeyCode.ButtonA then
							gameSettings.settings[Name] = not gameSettings.settings[Name]
							valChangeEvent:Fire(gameSettings.settings[Name])
							settingInputObject.Input.Toggle.BackgroundColor3 = gameSettings.settings[Name] and onColor or offColor
							settingInputObject.Input.Toggle.ImageTransparency = gameSettings.settings[Name] and 0 or 1
						end
					end)
				end)
				settingInputObject.SelectionLost:Connect(function()
					if inputListener then inputListener = inputListener:Disconnect() end
				end)
			end
			settingInputObject.Input.Toggle.Activated:Connect(function()
				gameSettings.settings[Name] = not gameSettings.settings[Name]
				valChangeEvent:Fire(gameSettings.settings[Name])
				settingInputObject.Input.Toggle.BackgroundColor3 = gameSettings.settings[Name] and onColor or offColor
				settingInputObject.Input.Toggle.ImageTransparency = gameSettings.settings[Name] and 0 or 1
				-- some sort of animation should play here.

			end)
			settingObject.SetValue = function(val)
				gameSettings.settings[Name] = not not val
				valChangeEvent:Fire(gameSettings.settings[Name])
				settingInputObject.Input.Toggle.BackgroundColor3 = gameSettings.settings[Name] and onColor or offColor
				settingInputObject.Input.Toggle.ImageTransparency = gameSettings.settings[Name] and 0 or 1

			end
		elseif valueType == "list" then
			-- Implement the functionality
			local contents = settingRule.Contents
			local function updateValue(newValue:number|string)
				local item
				if type(newValue) == "number" then
					item = contents[newValue]
				elseif type(newValue) == "string" then
					local itemIsValid = not not table.find(contents,newValue)
					if itemIsValid then
						item = newValue
					end
				end
				if not item then error(("Item is invalid! (got %s)"):format(tostring(item))) end
				gameSettings.settings[Name] = item
				valChangeEvent:Fire(item)
				settingInputObject.Input.ItemSelect.Text = gameSettings.settings[Name]
			end
			-- Create the dropdown thing
			local menuFrame
			if useFullscreenSettings then
				menuFrame = script.SettingsElements.DDFullscreen:Clone()
			else
				menuFrame = script.SettingsElements.DDContainer:Clone()
			end
			local menu = menuFrame.Dropdown
			-- console thing
			local toggle
			if UIS.GamepadEnabled then
				local inputListener
				settingInputObject.SelectionGained:Connect(function()
					lastSelectedSetting = settingInputObject
					inputListener = UIS.InputBegan:Connect(function(io)
						if io.KeyCode == Enum.KeyCode.ButtonA then
							toggle(true)
						end
					end)
				end)
				settingInputObject.SelectionLost:Connect(function()
					if inputListener then inputListener = inputListener:Disconnect() end
				end)
			end
			local itemButtons = {}
			do
				local itemIndex = {}
				for Index,ItemName in next,contents do
					local itemButton = script.SettingsElements.Button:Clone()
					itemButton.Text = ItemName
					itemButton.Size = UDim2.new(1,0,0,listItemYSize)
					itemButton.Position = UDim2.new(0,0,0,listItemYSize*(Index-1))
					itemButton.Parent = menu
					itemButton.Activated:Connect(function(io)
						print(io.UserInputType)
						menuFrame.Parent = nil
						updateValue(ItemName)
						if toggle then toggle(false) end
					end)
					itemButtons[ItemName] = itemButton
					itemIndex[#itemIndex+1] = itemButton
				end
				for Index,Button in next,itemIndex do
					Button.NextSelectionUp = itemButtons[Index-1]
					Button.NextSelectionDown = itemButtons[Index+1]
				end
			end
			if useFullscreenSettings then function toggle(bool)
					local button = itemButtons[gameSettings.settings[Name]]
					local size,position,anchor = funnySettings.Contents.Size,funnySettings.Contents.Position,funnySettings.Contents.AnchorPoint
					funnySettings.Contents.Visible = not bool
					menuFrame.Size = size
					menuFrame.Position = position
					menuFrame.AnchorPoint = anchor
					menuFrame.Parent = bool and funnySettings or nil
					if UIS.GamepadEnabled then
						GS.SelectedObject = bool and button or lastSelectedSetting
					end
				end end

			local YSize = #contents>maxItems and 7 or #contents
			menu.CanvasSize = UDim2.new(1,0,0,listItemYSize*#contents)

			settingInputObject.Input.ItemSelect.Activated:Connect(function()
				local funnyPos = settingInputObject.Input.ItemSelect.AbsolutePosition + Vector2.new(0,settingInputObject.Input.ItemSelect.AbsoluteSize.Y)
				if useFullscreenSettings then
					toggle(true)
					-- show the fullscreen dropdown
					return
				else
					menuFrame.Position = UDim2.fromOffset(funnyPos.X,funnyPos.Y)
					menuFrame.Size = UDim2.fromOffset(settingInputObject.Input.ItemSelect.AbsoluteSize.X,5)
					menuFrame.Parent = ScreenGui
				end
				TwS:Create(menuFrame,animDropdown,{
					Size = UDim2.fromOffset(settingInputObject.Input.ItemSelect.AbsoluteSize.X,listItemYSize*YSize)
				}):Play()
				local mouseCon 
				mouseCon = UIS.InputBegan:Connect(function(IO,gPU)
					if IO.UserInputType == Enum.UserInputType.MouseButton1 or IO.UserInputType == Enum.UserInputType.Touch then
						local pos = Vector2.new(IO.Position.X,IO.Position.Y)
						local TL,BR = settingInputObject.Input.ItemSelect.AbsolutePosition,settingInputObject.Input.ItemSelect.AbsolutePosition+settingInputObject.Input.ItemSelect.AbsoluteSize
						if (pos.X < TL.X or pos.X > BR.X) or (pos.Y < TL.Y or pos.Y > BR.Y) then
							mouseCon = mouseCon:Disconnect()
							spawn(function()
								wait(.1)
								menuFrame.Parent = nil
							end)
						end
					end
				end)
			end)
			updateValue(table.find(contents,value) or 1)
			settingObject.SetValue = updateValue
		else
			settingInputObject:Destroy()
			warn(("%s is an invalid UIElement!"):format(valueType))
			continue
		end
		if settingRule.Standalone then
			-- add them into a list that will be accessed later
			unlistedSettings[#unlistedSettings+1] = settingObject
			settingInputObject.Name = settingRule.DisplayName
			settingInputObject:SetAttribute("updateManiaVal",settingRule.maniaVal)
			settingInputObject:SetAttribute("updateChar",settingRule.updateUIName == "Character")
			settingInputObject:SetAttribute("updateIcon",settingRule.updateUIName == "Icon")
			settingObject.Standalone = true
		else
			currentSettings.All[#currentSettings.All+1] = settingObject
			if settingRule.Category then
				for _,CategoryName in next,settingRule.Category do
					if currentSettings[CategoryName] then
						currentSettings[CategoryName][#currentSettings[CategoryName]+1] = settingObject
					else
						currentSettings[CategoryName] = {settingObject}
						--print(("new setting (%s)"):format(CategoryName))
					end
				end
			end 
			settingInputObject.Parent = scrollSettings
		end
		settingsObjects[Name] = settingObject
	end
	-- Get the category buttons.
	local nonIndexCount = 0
	for CategoryName in next,currentSettings do
		local CategoryButton = script.SettingsElements.Category:Clone()
		local index = table.find(categoryOrder,CategoryName)
		CategoryButton.Text.Text = CategoryName
		CategoryButton.Size = UDim2.new(1,0,0,CategoryYSize)
		if index then
			CategoryButton.Position = UDim2.fromOffset(0,CategoryYSize*(index-1))
		else
			nonIndexCount += 1
			index = #categoryOrder+nonIndexCount
			CategoryButton.Position = UDim2.fromOffset(0,CategoryYSize*(index))
		end
		CategoryButton.Activated:Connect(function()
			UIHandler.SwitchSettingCategory(CategoryName)
		end)
		CategoryButton.Visible = true
		CategoryButton.Parent = scrollCategory
		print(index)
		categoryButtons[index] = CategoryButton
	end
	-- console stuff
	for Index,obj in next,categoryButtons do
		print(Index,type(Index))
		obj.NextSelectionDown = categoryButtons[Index+1]
		obj.NextSelectionUp = categoryButtons[Index-1]
	end
	-- set all the selectable settings to redirect to the first category when pressed left.
	for _,obj in next,currentSettings.All do
		obj.NextSelectionLeft = categoryButtons[1]
	end
	scrollSettings.CanvasSize = UDim2.new(1,0,0,CategoryYSize*(#categoryOrder+nonIndexCount))

	UIHandler.SwitchSettingCategory("All")

	--||
	--|| Keybinds
	--||

	local maniaButton = script.SettingsElements.Button:Clone()
	local maniaDDFrame = script.SettingsElements.DDContainer:Clone()
	local maniaScroll = maniaDDFrame.Dropdown
	local maniaContents = {}
	local arrowSprites = {
		'purple0';
		'blue0';
		'green0';
		'red0';
		"white0";
		"yellow0";
		"violet0";
		"black0";
		"dark0";
	}
	local maniaStuff = {
		{1,2,3,4}; -- 1
		{1,3,4,6,2,9}; -- 2
		{1,2,3,4,5,6,7,8,9}; -- 3
		{1,2,5,3,4}; -- 4
		{1,3,4,5,6,2,9}; -- 5
		{1,2,3,4,6,7,8,9}; -- 6
	}
	local XML,Img = RepS.Modules.Assets["Note9K.xml"],RepS.Modules.Assets.noteSkins9K.Original
	local currentBubble,lock
	-- create the binds stuff automatically
	for ManiaVal,Buttons in next,gameSettings.settings.Keybinds do -- Mania part
		local dirTable = {}
		local keybindsFrame = Instance.new("ScrollingFrame")
		keybindsFrame.Size = UDim2.new(1,0,1,-40)
		keybindsFrame.Position = UDim2.new(0,0,0,40)
		keybindsFrame.Name = #Buttons .. " Key"
		keybindsFrame.BackgroundTransparency = 1
		keybindsFrame.Selectable = false
		keybindsFrame.CanvasSize = UDim2.new(1,0,0,50*#Buttons)
		keybindsFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
		keybindsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		keybindsFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
		keybindsFrame.ZIndex = 3

		for DirectionNum,Keycodes in next,Buttons do -- Directions part
			local keybindsTable = {} 
			local spriteContainer = Instance.new("Frame")
			spriteContainer.Size = UDim2.new(1/(maxKeybinds+1),0,0,50)
			spriteContainer.Position = UDim2.new(0,0,0,50*(DirectionNum-1))
			spriteContainer.BackgroundTransparency = 0.75
			spriteContainer.ZIndex = 3
			local noteSprite = Sprite.new(Img:Clone(),false,2)
			noteSprite:AddSparrowXML(XML,"display",arrowSprites[maniaStuff[ManiaVal][DirectionNum]],60,false)
			noteSprite.Scale = Vector2.new(0.25,0.25)
			noteSprite.GUI.Position = UDim2.new(0.5,0,0.5,0)
			noteSprite.GUI.Parent = spriteContainer
			noteSprite.GUI.ZIndex = 4
			spriteContainer.Parent = keybindsFrame
			noteSprite:PlayAnimation"display"
			for Index=1,maxKeybinds do -- KeyCodes part
				local keybind = Keycodes[Index]
				local keyButton = Instance.new("TextButton")
				local stupidBorders = Instance.new("UIStroke")
				keyButton.Size = UDim2.new(1/(maxKeybinds+1),0,0,50)
				keyButton.Position = UDim2.new(1/(maxKeybinds+1)*Index,0,0,50*(DirectionNum-1))
				keyButton.Text = keybind and keybind.Name or unbindedText
				keyButton.Font = Enum.Font.SourceSansBold
				keyButton.TextColor3 = Color3.new(1,1,1)
				keyButton.TextScaled = true
				keyButton.TextStrokeColor3 = Color3.new()
				keyButton.BorderSizePixel = 1
				keyButton.BorderMode = Enum.BorderMode.Inset
				keyButton.AutoButtonColor = false
				keyButton.BackgroundTransparency = 0.8
				keyButton.ZIndex = 3 
				stupidBorders.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				stupidBorders.Thickness = 1.75
				stupidBorders.Parent = keyButton
				local startTick
				keyButton.Activated:Connect(function(IO)
					if lock then return end
					local confirmText = script.SettingsElements.BindConfirm:Clone()
					local GPIndex = 1
					if IO.UserInputType == Enum.UserInputType.Gamepad1 then
						GPIndex = 2
					end
					local theText = ("[%s] to edit\n[%s] to erase"):format(editKeybind[GPIndex].Name,eraseKeybind[GPIndex].Name)
					local textBounds = TS:GetTextSize(theText,confirmText.TextSize,confirmText.Font,Vector2.new(500,500))
					currentBubble = confirmText
					startTick = tick()
					confirmText.Size = UDim2.fromOffset(5,textBounds.Y+5)
					local centerPos = keyButton.AbsolutePosition + (keyButton.AbsoluteSize/2)
					confirmText.Position = UDim2.fromOffset(5+centerPos.X+keyButton.AbsoluteSize.X/2,centerPos.Y+36) -- IgnoreGuiInset no work, bruh!!!
					confirmText.Visible = true
					confirmText.Text = theText
					confirmText.ZIndex = 3
					confirmText.Parent = ScreenGui
					TwS:Create(confirmText,animDropdown,{
						Size = UDim2.fromOffset(textBounds.X+5,textBounds.Y+5)
					}):Play()
					local editDown,eraseDown = false,false
					repeat
						RS.RenderStepped:Wait()
						if IO.UserInputType == Enum.UserInputType.Gamepad1 then
							for _,KC in next,editKeybind do
								if not editDown then editDown = UIS:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,KC) end
							end
							for _,KC in next,eraseKeybind do
								if not eraseDown then eraseDown = UIS:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,KC) end
							end
						else
							for _,KC in next,editKeybind do
								if not editDown then editDown = UIS:IsKeyDown(KC) end
							end
							for _,KC in next,eraseKeybind do
								if not eraseDown then eraseDown = UIS:IsKeyDown(KC) end
							end
						end
						local centerPos = keyButton.AbsolutePosition + (keyButton.AbsoluteSize/2)
						confirmText.Position = UDim2.fromOffset(5+centerPos.X+keyButton.AbsoluteSize.X/2,centerPos.Y+36)
					until tick() > startTick + 10 or currentBubble ~= confirmText or (editDown or eraseDown)
					confirmText:Destroy()
					if currentBubble == confirmText then
						if editDown then
							keybindsFrame.Visible = false
							maniaButton.Visible = false
							local waitInputUI = script.SettingsElements.ScreenLabel:Clone()
							waitInputUI.Text = "Waiting for input..."
							waitInputUI.Visible = true
							waitInputUI.ZIndex = 4
							waitInputUI.Parent = bindsTab.Frame
							lock = true
							local InputKey
							repeat
								InputKey = UIS.InputBegan:Wait()
								print(InputKey.KeyCode,InputKey.KeyCode.Value)
							until InputKey.KeyCode and not UIS:GetFocusedTextBox()
							gameSettings.settings.Keybinds[ManiaVal][DirectionNum][Index] = InputKey.KeyCode
							keyButton.Text = InputKey.KeyCode.Name
							waitInputUI:Destroy()
							lock = false
							keybindsFrame.Visible = true
							maniaButton.Visible = true
						elseif eraseDown then
							gameSettings.settings.Keybinds[ManiaVal][DirectionNum][Index] = nil
							keyButton.Text = unbindedText
						end
						currentBubble = nil 
					end
				end)
				keyButton.Parent = keybindsFrame
				keybindsTable[Index] = keyButton
			end
			dirTable[DirectionNum] = keybindsTable
		end
		maniaContents[ManiaVal] = keybindsFrame
		maniaUITable[ManiaVal] = dirTable
	end
	-- the funny extra binds
	local extraBindsOrder = {
		"Dodge";
		"NextMod";
		"LastMod";
		"NextSong";
		"LastSong";
		"Easier";
		"Harder";
		"StartSong";
		"QuitSpot";
	}
	local extrabindsFrame = Instance.new("ScrollingFrame")
	extrabindsFrame.Size = UDim2.new(1,0,1,-40)
	extrabindsFrame.Position = UDim2.new(0,0,0,40)
	extrabindsFrame.Name = "Extra"
	extrabindsFrame.BackgroundTransparency = 1
	--keybindsFrame.BackgroundColor3 = Color3.fromHSV(IdRandom:NextNumber(0,1),1,1)
	extrabindsFrame.CanvasSize = UDim2.new(1,0,0,50*#gameSettings.settings.MenuControls)
	extrabindsFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
	extrabindsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	extrabindsFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
	extrabindsFrame.ZIndex = 3
	for BindName,Keycodes in next,gameSettings.settings.MenuControls do
		local bindText = Instance.new("TextLabel")
		bindText.Size = UDim2.new(1/(3),0,0,50)
		bindText.Position = UDim2.new(0,0,0,50*(table.find(extraBindsOrder,BindName)-1))
		bindText.BackgroundTransparency = 0.75
		bindText.Font = Enum.Font.SourceSansBold
		bindText.TextColor3 = Color3.new(1,1,1)
		bindText.TextScaled = true
		bindText.Text = BindName
		bindText.ZIndex = 3
		local stupidBorders = Instance.new("UIStroke")
		stupidBorders.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		stupidBorders.Thickness = 1.75
		stupidBorders.Parent = bindText
		for Index=1,2 do
			local keybind = Keycodes[Index]
			local keyButton = Instance.new("TextButton")
			local stupidBorders = Instance.new("UIStroke")
			keyButton.Size = UDim2.new(1/(3),0,0,50)
			keyButton.Position = UDim2.new(1/(3)*Index,0,0,50*(table.find(extraBindsOrder,BindName)-1))
			keyButton.Text = keybind and keybind.Name or unbindedText
			keyButton.Font = Enum.Font.SourceSansBold
			keyButton.TextColor3 = Color3.new(1,1,1)
			keyButton.TextScaled = true
			keyButton.TextStrokeColor3 = Color3.new()
			keyButton.BorderSizePixel = 1
			keyButton.BorderMode = Enum.BorderMode.Inset
			keyButton.AutoButtonColor = false
			keyButton.BackgroundTransparency = 0.8
			keyButton.ZIndex = 3 
			stupidBorders.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			stupidBorders.Thickness = 1.75
			stupidBorders.Parent = keyButton
			local startTick
			keyButton.Activated:Connect(function(IO)
				if lock then return end
				local confirmText = script.SettingsElements.BindConfirm:Clone()
				local GPIndex = 1
				if IO.UserInputType == Enum.UserInputType.Gamepad1 then
					GPIndex = 2
				end
				local theText = ("[%s] to edit\n[%s] to erase"):format(editKeybind[GPIndex].Name,eraseKeybind[GPIndex].Name)
				local textBounds = TS:GetTextSize(theText,confirmText.TextSize,confirmText.Font,Vector2.new(500,500))
				currentBubble = confirmText
				startTick = tick()
				confirmText.Size = UDim2.fromOffset(5,textBounds.Y+5)
				local centerPos = keyButton.AbsolutePosition + (keyButton.AbsoluteSize/2)
				confirmText.Position = UDim2.fromOffset(5+centerPos.X+keyButton.AbsoluteSize.X/2,centerPos.Y+36) -- IgnoreGuiInset no work, bruh!!!
				confirmText.Visible = true
				confirmText.Text = theText
				confirmText.ZIndex = 3
				confirmText.Parent = ScreenGui
				TwS:Create(confirmText,animDropdown,{
					Size = UDim2.fromOffset(textBounds.X+5,textBounds.Y+5)
				}):Play()
				local editDown,eraseDown = false,false
				repeat
					RS.RenderStepped:Wait()
					if IO.UserInputType == Enum.UserInputType.Gamepad1 then
						for _,KC in next,editKeybind do
							if not editDown then editDown = UIS:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,KC) end
						end
						for _,KC in next,eraseKeybind do
							if not eraseDown then eraseDown = UIS:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,KC) end
						end
					else
						for _,KC in next,editKeybind do
							if not editDown then editDown = UIS:IsKeyDown(KC) end
						end
						for _,KC in next,eraseKeybind do
							if not eraseDown then eraseDown = UIS:IsKeyDown(KC) end
						end
					end
					local centerPos = keyButton.AbsolutePosition + (keyButton.AbsoluteSize/2)
					confirmText.Position = UDim2.fromOffset(5+centerPos.X+keyButton.AbsoluteSize.X/2,centerPos.Y+36)
				until tick() > startTick + 10 or currentBubble ~= confirmText or (editDown or eraseDown)
				confirmText:Destroy()
				if currentBubble == confirmText then
					if editDown then
						extrabindsFrame.Visible = false
						maniaButton.Visible = false
						local waitInputUI = script.SettingsElements.ScreenLabel:Clone()
						waitInputUI.Text = "Waiting for input..."
						waitInputUI.Visible = true
						waitInputUI.ZIndex = 4
						waitInputUI.Parent = bindsTab.Frame
						lock = true
						local InputKey
						repeat
							InputKey = UIS.InputBegan:Wait()
							print(InputKey.KeyCode,InputKey.KeyCode.Value)
						until InputKey.KeyCode and not UIS:GetFocusedTextBox()
						gameSettings.settings.MenuControls[BindName][Index] = InputKey.KeyCode
						keyButton.Text = InputKey.KeyCode.Name
						waitInputUI:Destroy()
						lock = false
						extrabindsFrame.Visible = true
						maniaButton.Visible = true
					elseif eraseDown then
						gameSettings.settings.MenuControls[BindName][Index] = nil
						keyButton.Text = unbindedText
					end
					currentBubble = nil 
				end
			end)
			keyButton.Parent = extrabindsFrame
		end
		bindText.Parent = extrabindsFrame
	end
	extrabindsFrame.CanvasSize = UDim2.new(1,0,0,50*#extraBindsOrder)
	local menuOrder = {1,4,2,5,6,3}

	-- keybinds mania button thing
	local maniaButtons = {}

	maniaDDFrame.ZIndex = 5
	maniaButton.Size = UDim2.new(1,-10,0,30)
	maniaButton.Text = "[ Click to select binds ]"
	maniaButton.Position = UDim2.new(0,5,0,5)
	maniaButton.Parent = bindsTab.Frame
	maniaButton.Activated:Connect(function(io)
		--if io.UserInputType == Enum.UserInputType.MouseButton1 then
		currentBubble = nil
		maniaDDFrame.Size = UDim2.fromOffset(maniaButton.AbsoluteSize.X,5)
		local funnyPos = maniaButton.AbsolutePosition + Vector2.new(0,maniaButton.AbsoluteSize.Y)
		maniaDDFrame.Position = UDim2.fromOffset(funnyPos.X,funnyPos.Y)
		maniaDDFrame.Parent = ScreenGui
		TwS:Create(maniaDDFrame,animDropdown,{
			Size = UDim2.fromOffset(maniaButton.AbsoluteSize.X,listItemYSize*#maniaContents)
		}):Play()
		local mouseCon 
		mouseCon = UIS.InputBegan:Connect(function(IO,gPU)
			if IO.UserInputType == Enum.UserInputType.MouseButton1 then
				local pos = Vector2.new(IO.Position.X,IO.Position.Y)
				local TL,BR = maniaDDFrame.AbsolutePosition,maniaDDFrame.AbsolutePosition+maniaDDFrame.AbsoluteSize
				if (pos.X < TL.X or pos.X > BR.X) or (pos.Y < TL.Y or pos.Y > BR.Y) then
					maniaDDFrame.Parent = nil
					mouseCon = mouseCon:Disconnect()
				end
			end
		end)
		if UIS.GamepadEnabled then
			GS.SelectedObject = maniaButtons[1]
		end
			--[[
		elseif io.UserInputType == Enum.UserInputType.Touch then
			print("done something lol")
		end--]]
	end)


	-- create the buttons
	for Index,ManiaUI in next,maniaContents do
		local thebutton = script.SettingsElements.Button:Clone()
		thebutton.Text = ManiaUI.Name
		thebutton.Position = UDim2.new(0,0,0,listItemYSize*(table.find(menuOrder,Index)-1))
		thebutton.Size = UDim2.new(1,0,0,listItemYSize)
		thebutton.ZIndex = 6
		thebutton.Parent = maniaScroll
		thebutton.Activated:Connect(function()
			if UIS.GamepadEnabled then
				GS.SelectedObject = maniaButton
			end
			for _,MUI in next,maniaContents do
				MUI.Parent = nil
			end
			maniaDDFrame.Parent = nil
			extrabindsFrame.Parent = nil
			maniaButton.Text = ManiaUI.Name
			ManiaUI.Parent = bindsTab.Frame
		end)
		maniaButtons[table.find(menuOrder,Index)] = thebutton
	end

	do-- the button for the extra binds
		local thebutton = script.SettingsElements.Button:Clone()
		thebutton.Text = extrabindsFrame.Name
		thebutton.Position = UDim2.new(0,0,0,listItemYSize*(#menuOrder))
		thebutton.Size = UDim2.new(1,0,0,listItemYSize)
		thebutton.ZIndex = 6
		thebutton.Parent = maniaScroll
		thebutton.Activated:Connect(function()
			if UIS.GamepadEnabled then
				GS.SelectedObject = maniaButton
			end
			if lock then return end
			for _,MUI in next,maniaContents do
				MUI.Parent = nil
			end
			maniaDDFrame.Parent = nil
			maniaButton.Text = extrabindsFrame.Name
			extrabindsFrame.Parent = bindsTab.Frame
		end)
		maniaButtons[#maniaButtons+1] = thebutton
	end
	-- Console navigation
	for Index,Button in next,maniaButtons do
		Button.NextSelectionUp = maniaButtons[Index-1]
		Button.NextSelectionDown = maniaButtons[Index+1]
	end
	-- extra settings button
	maniaScroll.CanvasSize = UDim2.new(1,0,0,listItemYSize*(#maniaContents+1))

	-- the last part of generic stuff

	local maniaRepStuff = {
		{1,2,3,4};
		{1,3,4,1,2,4};
		{1,2,3,4,5,1,2,3,4};
		{1,2,5,3,4};
		{1,3,4,5,1,2,4};
		{1,2,3,4,1,2,3,4};
	}
	local repName = { -- arrow .. [NAME HERE]
		"LEFT";
		"DOWN";
		"UP";
		"RIGHT";
		"SPACE";
	}
	local arrowColor = {
		'left';
		'down';
		'up';
		'right';
		"white";
		"yel";
		"violet";
		"black";
		"dark";
	}

	-- uhh, the funny customization tab?????????????????????

	local tabOpen = false
	local thePreview = script.SettingsElements.PreviewThing:Clone()
	--thePreview.Size = UDim2.fromScale(0.5,1)
	--thePreview.Position = UDim2.fromScale(0.5,0)
	thePreview.Parent = customTab.Frame

	local customScroll = Instance.new("ScrollingFrame")
	customScroll.CanvasSize = UDim2.new(1,0,0,verticalSize*#unlistedSettings)
	customScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
	customScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
	customScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	customScroll.Selectable = false
	customScroll.BackgroundTransparency = 1
	customScroll.Parent = customTab.Frame

	local receptorSprites = {}
	local noteSprites = {}
	local function showArrows(mania,noteskinName)
		if not tabOpen then return end
		local spriteOrder = maniaStuff[mania]
		--if mania == "stop" or not spriteOrder then return end
		-- clean any existing sprites
		local demoSkin,demoXML
		for _,v in next,receptorSprites do
			if v then v:Destroy() end
		end
		for _,v in next,noteSprites do
			if v then v:Destroy() end
		end
		if mania == "stop" then
			receptorSprites,noteSprites = nil,nil
			return
		else
			demoSkin,demoXML = getNoteskinObjects(mania,noteskinName)
		end 
		receptorSprites = {}
		noteSprites = {}
		-- generate new receptors and note sprites
		local scale = thePreview.AbsoluteSize.X/shared.noteScaleRatio.X
		for i,v in next,maniaRepStuff[mania] do
			local repSpr = Sprite.new(demoSkin:Clone(),false,2)
			repSpr:AddSparrowXML(demoXML,"idle","arrow" .. repName[maniaRepStuff[mania][i]],24,false)
			print(repName[maniaRepStuff[mania][i]])
			repSpr:AddSparrowXML(demoXML,"confirm",arrowColor[maniaStuff[mania][i]] .. " confirm0",24,false)
			print(arrowColor[maniaStuff[mania][i]],maniaStuff[mania][i],maniaStuff[mania])
			repSpr:AddSparrowXML(demoXML,"press",arrowColor[maniaStuff[mania][i]] .. " press0",24,false)
			repSpr.Scale = Vector2.new(scale,scale)* 0.5
			receptorSprites[i] = repSpr

			local noteSprite = Sprite.new(demoSkin:Clone(),false,2)
			noteSprite:AddSparrowXML(demoXML,"display",arrowSprites[maniaStuff[mania][i]],24,true)
			noteSprite.Scale = Vector2.new(scale,scale) * 0.5
			noteSprites[i] = noteSprite
			repSpr:PlayAnimation("idle")
		end
		-- display
		for i,repSpr in next,receptorSprites do
			repSpr.GUI.Parent = thePreview
			repSpr.GUI.Position = UDim2.fromScale((1/(#receptorSprites+1)) * i,0.1)
			spawn(function()
				wait(.25*i)
				local setRS = receptorSprites
				local c = 0
				repeat
					if c > 2 then c = 0 end
					if c == 0 then
						repSpr:PlayAnimation("confirm")
					elseif c == 1 then
						repSpr:PlayAnimation("press")
					elseif c == 2 then
						repSpr:PlayAnimation("idle")
					end
					c += 1
					wait(1.2)
				until receptorSprites ~= setR
			end)
		end
		for i,noteSpr in next,noteSprites do
			noteSpr.GUI.Parent = thePreview
			noteSpr.GUI.Position = UDim2.fromScale((1/(#receptorSprites+1)) * i,0.25)
			noteSpr:PlayAnimation("display")
		end

	end

	-- the character
	local currChar
	local animOrder = {
		'Idle',
		'SingLeft';
		'SingDown';
		'SingUp';
		'SingRight';
	}
	local function displayAnimation(name)
		if not tabOpen then return end
		local animation = RepS.Animations.CharacterAnims:FindFirstChild(name) or RepS.Animations.CharacterAnims.BF
		if not animation then return end
		if currChar then currChar:Destroy();thePreview.Character:ClearAllChildren() end
		local characterName = animation:GetAttribute("CharacterName")
		local characterModel = (characterName and RepS.Characters:FindFirstChild(characterName) or RepS.Characters.opponent):Clone()
		local animator = characterModel:FindFirstChild("Animator",true)
		characterModel:SetPrimaryPartCFrame(CFrame.new())
		thePreview.Character.PrimaryPart = characterModel.PrimaryPart
		for _,v in next,characterModel:GetChildren() do
			v.Parent = thePreview.Character
		end

		local currentAnimations = {}
		for _,v in next,animation:GetChildren() do
			if v:IsA("Animation") then currentAnimations[v.Name] = animator:LoadAnimation(v) end
		end
		currChar = characterModel
		local c = 0
		spawn(function()
			repeat
				if c == 5 + (#animOrder-1) then c = 0 end
				if c == 0 then
					currentAnimations["Idle"]:Play(0,1,1)
					--print("Idle play!")
				elseif c >= 5 then
					currentAnimations[animOrder[c-3]]:Play(0,1,1)
					--print(animOrder[c-3] .. " play!")
				end
				wait(0.65)
				c += 1
			until currChar ~= characterModel
		end)
		--]=]
	end
	local normalIcon = Sprite.new(Instance.new("ImageLabel"),true,nil,true)
	local deadIcon = Sprite.new(Instance.new("ImageLabel"),true,nil,true)
	local winningIcon = Sprite.new(Instance.new("ImageLabel"),true,nil,true)
	normalIcon.GUI.BackgroundTransparency,deadIcon.GUI.BackgroundTransparency,winningIcon.GUI.BackgroundTransparency = 1,1,1
	normalIcon.GUI.AnchorPoint,deadIcon.GUI.AnchorPoint,winningIcon.GUI.AnchorPoint = Vector2.new(0.5,1),Vector2.new(0.5,1),Vector2.new(0.5,1)
	normalIcon.Scale,deadIcon.Scale,winningIcon.Scale = Vector2.new(4/9,4/9),Vector2.new(4/9,4/9),Vector2.new(4/9,4/9)
	normalIcon.GUI.Parent = thePreview
	local function displayIcon(name)
		local IconInfo = Icons[name] or Icons.Face
		if not IconInfo then return end
		normalIcon.Animations = {} -- reset the animations
		normalIcon.CurrAnimation = nil
		normalIcon.AnimData.Looped = false
		if IconInfo.NormalXMLArgs then
			normalIcon:AddSparrowXML(IconInfo.NormalXMLArgs[1],"Display",unpack(IconInfo.NormalXMLArgs,2)).ImageId = IconInfo.NormalId
			for i = 1, #normalIcon.Animations.Display.Frames do
				normalIcon.Animations.Display.Frames[i].FrameSize = IconInfo.NormalDimensions
			end
		else
			normalIcon:AddAnimation("Display",{{
				Size = IconInfo.NormalDimensions;
				FrameSize = IconInfo.NormalDimensions;
				Offset = IconInfo.OffsetNormal or Vector2.new();
			}},1,true,IconInfo.NormalId)
		end
		normalIcon:PlayAnimation("Display")
		normalIcon:ResetAnimation()
		-- dead icon thing
		if IconInfo.DeadId then
			deadIcon.Animations = {} -- reset the animations
			deadIcon.CurrAnimation = nil
			deadIcon.AnimData.Looped = false
			if IconInfo.DeadXMLArgs then
				deadIcon:AddSparrowXML(IconInfo.DeadXMLArgs[1],"Display",unpack(IconInfo.DeadXMLArgs,2)).ImageId = IconInfo.DeadId
				for i = 1, #deadIcon.Animations.Display.Frames do
					deadIcon.Animations.Display.Frames[i].FrameSize = IconInfo.NormalDimensions
				end
			else
				deadIcon:AddAnimation("Display",{{
					Size = IconInfo.DeadDimensions;
					FrameSize = IconInfo.DeadDimensions;
					Offset = IconInfo.OffsetDead or Vector2.new();
				}},1,true,IconInfo.DeadId)
			end
			deadIcon:PlayAnimation("Display")
			deadIcon:ResetAnimation()
			-- dead icon thing
			if IconInfo.WinningId then
				winningIcon.Animations = {} -- reset the animations
				winningIcon.CurrAnimation = nil
				winningIcon.AnimData.Looped = false
				if IconInfo.WinnningXMLArgs then
					winningIcon:AddSparrowXML(IconInfo.WinningXMLArgs[1],"Display",unpack(IconInfo.WinningXMLArgs,2)).ImageId = IconInfo.WinningId
					for i = 1, #winningIcon.Animations.Display.Frames do
						winningIcon.Animations.Display.Frames[i].FrameSize = IconInfo.WinningDimensions
					end
				else
					winningIcon:AddAnimation("Display",{{
						Size = IconInfo.WinningDimensions;
						FrameSize = IconInfo.WinningDimensions;
						Offset = IconInfo.OffsetWinning or Vector2.new();
					}},1,true,IconInfo.WinningId)
				end
				winningIcon:PlayAnimation("Display")
				winningIcon:ResetAnimation()
			end
			if IconInfo.WinningId then
				deadIcon.GUI.Parent = thePreview
				deadIcon.GUI.Position = UDim2.fromScale(0.2,0.95)
				winningIcon.GUI.Parent = thePreview
				winningIcon.GUI.Position = UDim2.fromScale(0.8,0.95)
				normalIcon.GUI.Position = UDim2.fromScale(0.5,0.95)
			else
				winningIcon.GUI.Parent = nil
				deadIcon.GUI.Parent = thePreview
				deadIcon.GUI.Position = UDim2.fromScale(1/3,0.95)
				normalIcon.GUI.Position = UDim2.fromScale(2/3,0.95)
			end
		else
			winningIcon.GUI.Parent = nil
			deadIcon.GUI.Parent = nil
			normalIcon.GUI.Position = UDim2.fromScale(0.5,0.95)
		end
	end
	local cameraPreview
	local spinStart = tick()
	local stupidCamera = Instance.new("Camera")
	stupidCamera.Parent = thePreview
	thePreview.CurrentCamera = stupidCamera
	local function startPreview()
		wait()
		customScroll.Size = UDim2.fromScale(0.66666666,1)
		showArrows(1,gameSettings.settings.NoteSkin_4K) -- show 4K
		displayIcon(gameSettings.settings.CustomIcon)
		if cameraPreview then cameraPreview:Disconnect()cameraPreview = nil end
		cameraPreview = RS.RenderStepped:Connect(function() -- spin
			thePreview.CurrentCamera.CFrame = CFrame.fromEulerAnglesXYZ(0,(tick() - spinStart)/7,0) * CFrame.new(0,0,7.5)
		end)
		displayAnimation(gameSettings.settings.ForcePlayerAnim)
	end
	local function stopPreview()
		if currChar then currChar:Destroy() end
		thePreview.Character:ClearAllChildren()
		currChar = nil
		if cameraPreview then cameraPreview:Disconnect();cameraPreview = nil end
	end

	for Index,settingObj in next,unlistedSettings do
		local Obj = settingObj.Object
		local nextObj,lastObj = unlistedSettings[Index+1],unlistedSettings[Index-1]
		Obj.Selectable = true
		Obj.NextSelectionDown = nextObj and nextObj.Object or nil
		Obj.NextSelectionUp = lastObj and lastObj.Object or nil
		Obj.Position = UDim2.new(0,0,0,verticalSize*(Index-1))
		Obj.Parent = customScroll
		local updateFunc
		if Obj:GetAttribute("updateManiaVal") then
			local d = Obj:GetAttribute("updateManiaVal")
			updateFunc = function(newVal)
				showArrows(d,newVal)
			end
		elseif Obj:GetAttribute("updateIcon") then
			updateFunc = displayIcon
		elseif Obj:GetAttribute("updateChar") then
			updateFunc = displayAnimation
		end
		if updateFunc then settingObj.ValueChanged:Connect(updateFunc) end
	end
	customTab.TabButton.Activated:Connect(function()
		tabOpen = true
		startPreview()
	end)
	local function stopPreviewEvent()
		if customTab.Frame.Parent == nil then
			tabOpen = false
			stopPreview()
		end
	end
	customTab.Frame:GetPropertyChangedSignal("Parent"):Connect(stopPreviewEvent)
	if useFullscreenSettings then

	else
		funnySettings.Closing:Connect(stopPreview)
		funnySettings.Opening:Connect(function()
			if tabOpen then
				startPreview()
			end
		end)
		-- Display something at least
	end
	currentTabs[1].Frame.Parent = containerFrame
end 

if useFullscreenSettings then

else
	funnySettings.Closing:Connect(function()
		open = false
		fireSaveSettings()
		--InfoRetriever:InvokeServer(0x2,gameSettings.settings)
	end)
end

return UIHandler