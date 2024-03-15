 local settingsRules = { -- limits certain values to an extent
	__ORDER = {
		--		"";
		"distractions";
		"Modcharts";
		"DeathEnabled";
		"ChillMode";
		--"LowDetail";
		"customSize";
		"ShowHitOffset";
		"MiddleScroll";
		"Downscroll";
		"Debug";
		"HitSound";
		"noteSplashes";
		"IconColors";
		"PreloadAssets";
		"HideUI";
		"hideOppArrows";
		"hideOppRatings";
		"hideOppCombo";
		"CameraZooms";
		--"HideHealthBar"; --???
		--"ArrowColors4K";
		"PlaybackSpeed";
		"BackgroundTrans";
		"ratingSize";
		--"CustomScoreFormat";
		"CustomSpeed";
		"ForceSpeed";
		"SongVolume";
		"HideProps";
		--"MissVolume";
		"ChartOffset";
		"maniaAutoSize";
		--"diamondNoteSpacebarTouch";
		--"HitSoundId";
		"TimeBar";
		--"ClassicNotes";
		--"Fun";
		-- standalone part
		"CustomIcon";
		"ForcePlayerAnim";
		"NoteSkin_4K";
		"NoteSkin_5K";
		"NoteSkin_6K";
		"NoteSkin_7K";
		"NoteSkin_8K";
		"NoteSkin_9K";
	};
	--[[
	settingName = {
		Type = "number","bool","list";
		DisplayName = "This is my setting!";
		Category = {"Category1","Category2"};
		StandAlone = boolean; -- This will toggle whenever this will be automatically shown in the setting tab.
		
		-- Number type values:
		DivideEach = 1;
		DivideBy = 4; -- these two values might get deprecated.
		DecimalRounding = 1; -- Optional
		Min = -1;
		Max = 1;
		
		-- List type values:
		Contents = {"Item1","Item2"};
		-- Bool type doesn't need any extra values.
	}
	--]]
	--[[
	ArrowColors4K = {
		Type = "string";
		DiplayName = "4K Tile Color(HEX)";
		Measure = "x";
		Category = {"Miscellaneous"};
		Min = 000;
		Max = 255255255;
	};
	]]--
	ChillMode = {
		Type = "bool";
		DisplayName = "Botplay";
		Category = {"Gameplay"};
	};
	Modcharts = {
		Type = "bool";
		DisplayName = "Enable Modcharts";
		Category = {"Gameplay"};
	};
	CameraZooms = {
		Type = "bool";
		DisplayName = "Enable Camera Zoom";
		Category = {"User Interface"};
	};
	IconColors = {
		Type = "bool";
		DisplayName = "Match Healthbar Color To Icon";
		Category = {"User Interface"};
	};
	noteSplashes = {
		Type = "bool";
		DisplayName = "Enable Note Splashes";
		Category = {"User Interface", "Notes"};
	};
	hideOppArrows = {
		Type = "bool";
		DisplayName = "Hide Opponent Arrows";
		Category = {"User Interface", "Notes"};
	};
	hideOppRatings = {
		Type = "bool";
		DisplayName = "Hide Opponent Ratings";
		Category = {"User Interface", "Ratings"};
	};
	hideOppCombo = {
		Type = "bool";
		DisplayName = "Hide Opponent Combo";
		Category = {"User Interface", "Ratings"};
	};
	--[[
	ClassicNotes = {
		Type = "bool";
		DisplayName = "Classic Death Notes";
		Category = {"Experimental", "Notes"};
	};
	--]]
	--[[
	Fun = {
		Type = "number";
		DisplayName = "Funny Meter";
		Measure = "%";
		Category = {"Miscellaneous"};
		DecimalRounding = 1;-- 0.12345 -> 0.1
		Min = 0;
		Max = 100;
	};
	--]]
	TimeBar = {
		Type = "bool";
		DisplayName = "Display time left in song";
		Category = {"User Interface"};
	};
	--[[
	preloadDeathNotes = {
		Type = "bool";
		DisplayName = "Preload Death Notes";
		Category = {"Experimental", "Preloading", "Notes"};
	};
	--]]
	HideUI = {
		Type = "bool";
		DisplayName = "Hide UI";
		Category = {"User Interface"};
	};
	HideProps = {
		Type = "bool";
		DisplayName = "Hide Props";
		Category = {"Miscellaneous"};
	};
	--[[
	PreloadAudio = {
		Type = "bool";
		DisplayName = "Preload Audio";
		Category = {"Miscellaneous", "Preloading"};
	};
	--]]
	PreloadAssets = {
		Type = "bool";
		DisplayName = "Preload Misc. Assets";
		Category = {"Miscellaneous", "Preloading"};
	};
	customSize = {
		Type = "number";
		DisplayName = "Game UI Size";
		Measure = "x";
		Category = {"User Interface","Gameplay"};
		DecimalRounding = 2;-- 0.12345 -> 0.12
		DivideEach = 1;
		Min = 0.75;
		Max = 1
	};
	BackgroundTrans = {
		Type = "number";
		DisplayName = "Background Transparency";
		Measure = "%";
		Category = {"User Interface","Gameplay"};
		DecimalRounding = 1;-- 0.12345 -> 0.1
		Min = 0;
		Max = 100;
	};
	CustomSpeed = {
		Type = "number";
		DisplayName = "Scroll Speed";
		Measure = "x";
		Category = {"Gameplay"};
		DivideEach = 1;
		Min = 0.25;
		Max = 5;
	};
	Debug = {
		Type = "bool";
		DisplayName = "Debug";
		Category = {"Miscellaneous"}
	};
	ChartOffset = {
		Type = "number";
		DisplayName = "Chart Offset";
		Measure = "ms";
		DecimalRounding = 0; -- 0.1234 -> 0
		Category = {"Gameplay"};
		Min = -1000;
		Max = 1000;
	};
	SongVolume = {
		Type = "number";
		DisplayName = "Song Volume";
		Category = {"Gameplay"};
		DecimalRounding = 0; -- 0.1234 -> 0
		Measure = "%";
		DivideBy = 4;
		Min = 0;
		Max = 200
	};
	--[[
	MissVolume = {  
		Type = "number";
		DisplayName = "Misses Volume";
		Measure = "%";
		Min = 0;
		Max = 200
	};--]]
	ratingSize = {
		Type = "number";
		DisplayName = "Rating Size";
		Category = {"User Interface", "Ratings"};
		Measure = "x";
		DecimalRounding = 2; -- 0.1234 -> 0.12
		Min=0;
		Max = 1.25;
	};
	--[[
	HitSoundId = {
		Type = "assetIds";
		DisplayName = "Hit sound ID";
		Category = {"Gameplay"};
	};]]
	--[[
	OpponentTransparency = {
		Type = "number";
		DisplayName = "Opponents Transparency";
		Measure = "%";
		Min = 0;
		Max = 1;
	};--]]
	distractions = {
		Type = "bool";
		DisplayName = "Jumpscares & Flashing Lights";
		Category = {"Gameplay", "Miscellaneous"};
	};
	ForceSpeed = {
		Type = "bool";
		DisplayName = "Force Speed";
		Category = {"Notes"};
	};
	MiddleScroll = {
		Type = "bool";
		DisplayName = "Middle Scroll";
		Category = {"User Interface","Notes"};
	};
	HitSound = {
		Type = "bool";
		DisplayName = "Hit Sounds";
		Category = {"Gameplay", "Miscellaneous"};
	};
	ShowHitOffset = {
		Type = "bool";
		DisplayName = "Show Accuracy in MS";
		Category = {"Miscellaneous"};
	};
	DeathEnabled = {
		Type = "bool";
		DisplayName = "Die at 0 HP";
		Category = {"Gameplay"};
	};
	Downscroll = {
		Type = "bool";
		DisplayName = "Down Scroll";
		Category = {"Gameplay", "Notes"};
	};
	maniaAutoSize = {
		Type = "bool";
		DisplayName = "Automatic Mania Size";
		Category = {"Miscellaneous","User Interface"};
	};
	PlaybackSpeed = {
		Type = "number";
		DisplayName = "Playback Rate";
		Category = {"Gameplay"};
		Measure = "x";
		Min = 0.1;
		Max = 2;
	};
	--CustomScoreFormat = {
	--	Type = "list";
	--	Standalone = true;
	--	DisplayName = "Custom Score Format";
	--	Category = {"Personalization"};
	--	Contents = {
	--		"Psych Engine";
	--	}
	--};
	NoteSkin_4K = {
		Type = "list";
		Standalone = true;
		maniaVal = 1;
		DisplayName = "4-Key Noteskin";
		Category = {"Personalization"};
		Contents = {
			"Default";
			"Original";
			"Circles";
			"Pixel";
		};
	};
	NoteSkin_5K = {
		Type = "list";
		Standalone = true;
		maniaVal = 4;
		DisplayName = "5-Key Noteskin";
		Category = {"Personalization"};
		Contents = {
			"Default";
			"Original";
			"SonicRing";
		};

	};
	NoteSkin_6K = {
		Type = "list";
		Standalone = true;
		maniaVal = 2;
		DisplayName = "6-Key Noteskin";
		Category = {"Personalization"};
		Contents = {
			"Default";
			"Original";
		};
	};
	NoteSkin_7K = {
		Type = "list";
		Standalone = true;
		maniaVal = 5;
		DisplayName = "7-Key Noteskin";
		Category = {"Personalization"};
		Contents = {
			"Default";
			"Original";
		};
	};
	NoteSkin_8K = {
		Type = "list";
		Standalone = true;
		maniaVal = 6;
		DisplayName = "8-Key Noteskin";
		Category = {"Personalization"};
		Contents = {
			"Default";
			"Original";
		};
	};
	NoteSkin_9K = {
		Type = "list";
		Standalone = true;
		maniaVal = 3;
		DisplayName = "9-Key Noteskin";
		Category = {"Personalization"};
		Contents = {
			"Default";
			"Original";
		};
	};
	--[[
	MicSkin = {
		Type = "list",
		Standalone = true;
		DisplayName = "Microphone Skin";
		Category = {"Personalization"};
		Contents = {
			"Default"
		}
	};--]]
	--[[
	diamondNoteSpacebarTouch = {
		Type = "bool";
		DisplayName = "Set White tile as Spacebar layout";
		Category = {"User Interface"};
	};
	--]]
	ForcePlayerAnim = {
		Type = "list";
		Standalone = true;
		updateUIName = "Character";
		DisplayName = "Character Animation";
		Category = {"Personalization"};
		Contents = {
			"Default";
			-- Automatically filled!
		};
	};
	CustomIcon = {
		Type = "list";
		Standalone = true;
		updateUIName = "Icon";
		DisplayName = "Icon";
		Category = {"Gameplay","User Interface","Personalization"};
		Contents = {
			-- Automatically filled!
		};
	};
}
local DirAmmo = {
	[0] = 4;
	[1] = 6;
	[2] = 9;
	[3] = 5;
	[4] = 7;
	[5] = 8;
}
local iconWhitelist = {} 
local whitelistStuff = {}
local RS = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local RunS = game:GetService("RunService")
local plr = game:GetService("Players").LocalPlayer
local Icons = require(RS.Modules.Icons)
local assetIds = {}
local assetNames = {}

-- ["Name"] = {number:userId,string:RoleName}

local function filterTableWithWhitelist(tableContents,whitelistContents,serverWhitelistName)
	if RunS:IsServer() then
		whitelistStuff[serverWhitelistName] = whitelistContents
	else
		for Name,Data in next,whitelistContents do
			local isAllowed = false
			local ran,role
			repeat
				ran,role = pcall(plr.GetRoleInGroup,plr,game.CreatorId)
			until ran 
			if not ran then
				warn("GetRoleInGroup couldn't get role, using Guest instead.\n" .. role) 
				role = "Guest" 
			end
			-- Process thru the data
			for _,value in next,Data do
				if type(value) == "string" then -- assume it's the group role
					isAllowed = role == value and not isAllowed
				elseif type(value) == "number" then
					isAllowed = plr.UserId == value and not isAllowed
				end
			end
			-- do something once it's been checked
			if not isAllowed then
				local index = table.find(tableContents,Name)
				if index then
					table.remove(tableContents,index)
				end
			end
		end
	end
end

-- icons sjfasklghjsakgaskgjdskhgshg

do
	local iconContents = {} -- This table is going to be automatically filled.
	for Name,_ in next,Icons do
		iconContents[#iconContents+1] = Name
	end
	table.sort(iconContents)
	table.insert(iconContents,1,"Default")
	-- do the thing
	local whitelist = {}
	filterTableWithWhitelist(iconContents,whitelist,"Icons")
	settingsRules.CustomIcon.Contents = iconContents
	--[[
	for Name,AssetInfo in next,Icons do
		if RunS:IsClient() and iconWhitelist[Name] and not table.find(iconWhitelist[Name],plr.UserId) then
			continue
		end
		local index = table.find(iconOrder,Name)
		if index then
			settingsRules.CustomIcon.Contents[index] = Name
		end
		-- the preload thinge
		local preloadInstAlive = Instance.new("Decal")
		preloadInstAlive.Texture = AssetInfo.NormalId
		assetIds[#assetIds+1] = preloadInstAlive
		assetNames["ICON_" .. Name] = AssetInfo.NormalId
		if AssetInfo.DeadId then
			local preloadInstAlive = Instance.new("Decal")
			preloadInstAlive.Texture = AssetInfo.DeadId
			assetIds[#assetIds+1] = preloadInstAlive
			assetNames["DEADICON_" .. Name] = AssetInfo.DeadId
		end
	end
	--]]
end

-- Animations??

do
	table.sort(settingsRules.ForcePlayerAnim.Contents)
	-- i forgot that the animations are automatically added
	local contents = settingsRules.ForcePlayerAnim.Contents
	local sortedanims = RS.Animations.CharacterAnims:GetChildren()
	
	table.sort(sortedanims,function(a,b)
		return a.Name:upper() < b.Name:upper()
	end)
	
	for _,Folder in next,sortedanims do
		local SD,SL,SU,SR,Idle = Folder:FindFirstChild("SingDown"),Folder:FindFirstChild("SingLeft"),Folder:FindFirstChild("SingUp"),Folder:FindFirstChild("SingRight"),Folder:FindFirstChild("Idle")
		if SD and SL and SU and SR and Idle then
			contents[#contents+1] = Folder.Name
		else
			warn(Folder.Name.." doesn't meet the requirements")
		end
	end
	-- ok do the thing
	local whitelist = {}
	filterTableWithWhitelist(contents,whitelist,"Animations")
end

-- Noteskins stuff

do
	local _4KnoteskinsWL = { -- breh
		["Shine"] = {
			"Owner";
			"Administration";
			"Coding and Co-Development";
			"Contributors";
			"Modmaker";
		};
	}
	filterTableWithWhitelist(settingsRules.NoteSkin_4K.Contents,_4KnoteskinsWL,"NoteSkins4K")
end

-- preload bs

local function assetLoadFunc(Id,didLoad)
	if not didLoad then
		warn(("Asset %s (%s) failed to load."):format(tostring(table.find(assetNames, Id)), Id))
	end
end

local preload = coroutine.wrap(function()
	ContentProvider:PreloadAsync(assetIds,assetLoadFunc)
end)
preload()

-- [settingName] = boolean (See In game UI) (Listing a setting below will be replicated to other players!)
local publicSettings = {
	["Downscroll"] = true,
	["customSpeed"] = true,
	["CustomIcon"] = true;
	["ForceSpeed"] = true,
	["DeathEnabled"] = true,
	--["CustomScoreFormat"] = true,
	["NoteSkin_4K"] = true,
	["NoteSkin_5K"] = true,
	["NoteSkin_6K"] = true,
	["NoteSkin_7K"] = true,
	["NoteSkin_8K"] = true,
	["NoteSkin_9K"] = true,
}


local settings = { -- default settings! (ANYTHING SETTING NOT DEFINED HERE WILL BE REMOVED ONCE THE PLAYER LEAVES)
	customSize = 1; -- size multiplier for the gameplay UI, default 1
	distractions = true;
	Modcharts = true;
	TimeBar = false;
	--ClassicNotes=false;
	--ReceptorSpacing = 0; -- Spacing for the receptors.
	BackgroundTrans = 100;
	HideProps = false;
	ChartOffset = 0;
	ratingSize = 1;
	IconColors = true;
	PreloadAssets = true;
	--PreloadAudio = true;
	noteSplashes = false;
	CameraZooms = true;
	Downscroll = false;
	MiddleScroll = false;
	hideOppArrows = false;
	hideOppRatings = false;
	hideOppCombo = false;
	--ArrowColors4K = 255255255;
	ChillMode = false;
	Debug = false;
	LowDetail = false;
	maniaAutoSize = true; -- automatically use a preset size for certain mania modes.
	ForceSpeed = false;
	--HitSoundId = 7145816573;
	--CustomScoreFormat = "Psych Engine";
	NoteSkin_4K = "Default";
	--preloadDeathNotes = true;
	--Fun = 0;
	HideUI = false;
	PlaybackSpeed = 1; -- song pitch
	NoteSkin_5K = "Default";
	NoteSkin_6K = "Default";
	NoteSkin_7K = "Default";
	NoteSkin_8K = "Default";
	NoteSkin_9K = "Default";
	--diamondNoteSpacebarTouch = true;
	ForcePlayerAnim = "Default"; -- Player's Animations.
	CustomIcon = "Default";
	CustomSpeed = 1; -- multiplier if ForceSpeed isn't enabled, default 1
	DeathEnabled = true;
	HitSound=false;
	OpponentTransparency = 0; -- Transparency for the opponent character.
	SongVolume = 100; -- This affects both voices and instrumentals!
	ShowHitOffset = false;
	Keybinds = {
		[1] = {
			[1]={Enum.KeyCode.D,Enum.KeyCode.Left,Enum.KeyCode.DPadLeft};
			[2]={Enum.KeyCode.F,Enum.KeyCode.Down,Enum.KeyCode.DPadDown};
			[3]={Enum.KeyCode.J,Enum.KeyCode.Up,Enum.KeyCode.DPadUp};
			[4]={Enum.KeyCode.K,Enum.KeyCode.Right,Enum.KeyCode.DPadRight};
		};
		[2] = {
			[1]={Enum.KeyCode.S,Enum.KeyCode.Z,Enum.KeyCode.One};
			[2]={Enum.KeyCode.D,Enum.KeyCode.X,Enum.KeyCode.Two};
			[3]={Enum.KeyCode.F,Enum.KeyCode.C,Enum.KeyCode.Three};
			[4]={Enum.KeyCode.J,Enum.KeyCode.B,Enum.KeyCode.Eight};
			[5]={Enum.KeyCode.K,Enum.KeyCode.N,Enum.KeyCode.Nine};
			[6]={Enum.KeyCode.L,Enum.KeyCode.M,Enum.KeyCode.Zero};
		};
		[3] = {
			[1]={Enum.KeyCode.A,Enum.KeyCode.One};
			[2]={Enum.KeyCode.S,Enum.KeyCode.Two};
			[3]={Enum.KeyCode.D,Enum.KeyCode.Three};
			[4]={Enum.KeyCode.F,Enum.KeyCode.Four};
			[5]={Enum.KeyCode.Space};
			[6]={Enum.KeyCode.H,Enum.KeyCode.Seven};
			[7]={Enum.KeyCode.J,Enum.KeyCode.Eight};
			[8]={Enum.KeyCode.K,Enum.KeyCode.Nine};
			[9]={Enum.KeyCode.L,Enum.KeyCode.Zero};
		};
		[4] = {
			[1]={Enum.KeyCode.D,Enum.KeyCode.Left,Enum.KeyCode.DPadLeft};
			[2]={Enum.KeyCode.F,Enum.KeyCode.Down,Enum.KeyCode.DPadDown};
			[3]={Enum.KeyCode.Space,Enum.KeyCode.ButtonR1};
			[4]={Enum.KeyCode.J,Enum.KeyCode.Up,Enum.KeyCode.DPadUp};
			[5]={Enum.KeyCode.K,Enum.KeyCode.Right,Enum.KeyCode.DPadRight};
		};
		[5] = {
			[1]={Enum.KeyCode.S,Enum.KeyCode.Z,Enum.KeyCode.One};
			[2]={Enum.KeyCode.D,Enum.KeyCode.X,Enum.KeyCode.Two};
			[3]={Enum.KeyCode.F,Enum.KeyCode.C,Enum.KeyCode.Three};
			[4]={Enum.KeyCode.Space};
			[5]={Enum.KeyCode.J,Enum.KeyCode.B,Enum.KeyCode.Eight};
			[6]={Enum.KeyCode.K,Enum.KeyCode.N,Enum.KeyCode.Nine};
			[7]={Enum.KeyCode.L,Enum.KeyCode.M,Enum.KeyCode.Zero};
		};
		[6] = {
			[1]={Enum.KeyCode.A,Enum.KeyCode.One};
			[2]={Enum.KeyCode.S,Enum.KeyCode.Two};
			[3]={Enum.KeyCode.D,Enum.KeyCode.Three};
			[4]={Enum.KeyCode.F,Enum.KeyCode.Four};
			[5]={Enum.KeyCode.H,Enum.KeyCode.Seven};
			[6]={Enum.KeyCode.J,Enum.KeyCode.Eight};
			[7]={Enum.KeyCode.K,Enum.KeyCode.Nine};
			[8]={Enum.KeyCode.L,Enum.KeyCode.Zero};
		};
	};
	
	SongData = { -- Song score and accuracy saving
		["Tutorial"] = { -- Song Name
			["Normal"] = { -- Difficulty
				"000000000", -- Score
				"0.00" -- Accuracy
			};
		};
	};
	
	-- anything below this line is unused!
	MissVolume = 100; -- unused
	TileColors = { -- innaccessible
		[1] = {
			[1]=0xC24B99; --left
			[2]=0x00FFFF; --down
			[3]=0x12FA05; --up
			[4]=0xF9393F; --right
		};
		[2] = {
			[1]=0xC24B99; -- left
			[2]=0x12FA05; -- down
			[3]=0xF9393F; -- right
			[4]=0xFFFF00; -- left2
			[5]=0x00FFFF; -- up
			[6]=0x0033FF; -- right2
		};
		[3] = {
			[1]=0xC24B99; --left
			[2]=0x00FFFF; --down
			[3]=0x12FA05; --up
			[4]=0xF9393F; --right
			[5]=0xCCCCCC; --center
			[6]=0xFFFF00; --left2
			[7]=0x8B4AFF; --down2
			[8]=0x666666; --up2
			[9]=0x0033FF; --right2
		};
		[4] = {
			[1]=0xC24B99; --left
			[2]=0x00FFFF; --down
			[3]=0xCCCCCC; --center
			[4]=0x12FA05; --up
			[5]=0xF9393F; --right
		};
		[5] = {
			[1]=0xC24B99; -- left
			[2]=0x12FA05; -- down
			[3]=0xF9393F; -- right
			[4]=0xCCCCCC; --center
			[5]=0xFFFF00; -- left2
			[6]=0x00FFFF; -- up
			[7]=0x0033FF; -- right2
		};
		[6] = {
			[1]=0xC24B99; --left
			[2]=0x00FFFF; --down
			[3]=0x12FA05; --up
			[4]=0xF9393F; --right
			[5]=0xFFFF00; --left2
			[6]=0x8B4AFF; --down2
			[7]=0x666666; --up2
			[8]=0x0033FF; --right2
		};
	};
	MenuControls = { -- innacessible
		["Dodge"] = {Enum.KeyCode.Space,Enum.KeyCode.ButtonR2};
		["NextMod"] = {Enum.KeyCode.D,Enum.KeyCode.Right,Enum.KeyCode.DPadRight};
		["LastMod"] = {Enum.KeyCode.A,Enum.KeyCode.Left,Enum.KeyCode.DPadLeft};
		["NextSong"] = {Enum.KeyCode.S,Enum.KeyCode.Down,Enum.KeyCode.DPadDown};
		["LastSong"] = {Enum.KeyCode.W,Enum.KeyCode.Up,Enum.KeyCode.DPadUp};
		["Easier"] = {Enum.KeyCode.Q,Enum.KeyCode.ButtonL1};
		["Harder"] = {Enum.KeyCode.R,Enum.KeyCode.ButtonR1};
		["StartSong"] = {Enum.KeyCode.Return,Enum.KeyCode.ButtonA};
		["QuitSpot"] = {Enum.KeyCode.E,Enum.KeyCode.ButtonStart};
	};
}
local realSettingOrder = {}
for Index,OrderName in next,settingsRules.__ORDER do
	if settings[OrderName] == nil then
		warn(("%s Setting isn't listed as an setting, removing!"):format(OrderName))
		settingsRules.__ORDER[Index] = nil
	else
		realSettingOrder[#realSettingOrder+1] = OrderName
	end
end
settingsRules.__ORDER = realSettingOrder
return RunS:IsServer() and {settings=settings,settingsRules=settingsRules,publicSettings=publicSettings,whitelists=whitelistStuff} or {settings=settings,defaultSettings=table.clone(settings),settingsRules=settingsRules}
