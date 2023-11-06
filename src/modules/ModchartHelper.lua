-- The idea is to define modchart variables in this script so that people could require this module script to view the variables available for modcharts

-- So to use it you would require this ModuleScript and put a dot after it and it would list the variables that you can use with modcharts

-- Example:
--[[
local helper = require(game.ReplicatedStorage.Modules.ModchartHelper)

return {
	preStart = function()
		-- Here you would type in 'helper.' and it will list off what you can do
		-- And once you have made your modchart you can remove the modchart helper from your modchart
	end,
}
--]]

-- Get the sprite script so that we can get the sprite type
local Sprite = require(game.ReplicatedStorage.Modules.Sprite)

return {
	--[[**
    	A function that makes an animated sprite
    	
    	@param image This is the Image Label that must include 2 attributes named "SpriteSheetSize" and "SpriteSize"
    		Both of these attributes should be Vector2 values and set the "SpriteSheetSize" to the size of the spritesheet
    		The "SpriteSize" should be set to the size of each image included in the spritesheet, if the dimensions are 
    			different for each one just go with the largest size
    			
    	@param visible A boolean value that determines whether or not the sprite will be visible as soon as it spawns (Optional)
    	
    	@param parent The desired parent that you would want it to be parented under (Optional)
    	
    	@returns This returns the animatedsprite from which you could add and play animations to your choosing
	**--]]
	addAnimatedSprite = function(image:ImageLabel, visible:boolean, parent:Instance)end,
	--[[**
    	A function that makes an Image Label
    	
    	@param tag This just applies to the name of the Image Label
    			
    	@param image This is just the imageId that will apply to the Image Label
    	
    	@param parent The desired parent that you would want it to be parented under (Optional)
    	
    	@returns This returns the sprite which will not be visible so you have to set it to be
	**--]]
	addSprite = function(tag:string, image:string, parent:Instance)end,
	--BringStageNear = function(DEPRECATED)end, -- This shouldn't be used
	
	--- Moves the camera given the position
	MoveCamera = function(position:CFrame)end,
	HideNotes = function(hide:boolean, side:string, hideReceptors:boolean, speed:number)end,
	playSound = function(soundId:number|string, volume:number)end,
	
	-- These functions can be replaced within the modchart to your liking
	--[[ -- Not added yet
	gameFunctions = {
		IconBeat = function(BeatLength:number) end, -- This is played every beat
		IconBeatAlt = function(BeatLength:number) end, -- This is played on every other beat
		HealthBar = function(GUI:GuiLabel, BfIcon:Sprite.Sprite, DadIcon:Sprite.Sprite, scale:number, normalHP:number, center:number) end, -- This is played every time the health bar updates
	},
	--]]
	
	-- This is a very long list, so I will only include stuff that people would actually use (which is still a lot)
	gameHandler = {
		--tween = function(object, goal, length:number, style:Enum.EasingStyle, dir:Enum.EasingDirection, repeats:number, reverse:boolean, delay:number) end, -- This makes a tween and at the end of the song stops it for you
		setProperty = function(name:string, value:any) end, -- This sets properties for things that are not lists (becuase they have to be a list for the value to be changed)
		settings = {}, -- yeah, just the settings found in "GameSettings" cause it would be pointless for me to write it all down
		changeIcon = function(name:string, side:boolean) end,
		flash = function(hex:string, speed:number, initialTransparency:number) end, -- Not recommended to use this, use the camera flash event instead
		processEvent = function(eventName:string, value1:any, value2:any, ...) end, -- This will process events given the proper name
		playCutscene = function(name:string) end, -- This plays the cutscene which is defined in the cutscene script
		closeScript = function(nameOfScript:string) end, -- This will remove the script from the GameHandler and will no longer play any more functions from the script
		ChangeNoteSkin = function(name:string, boolSide:boolean, force:boolean, mania:number) end, -- boolSize (false -> dad arrows, true -> bf arrows)
		--hideTheMap = function(bool:boolean) end, -- If true then it will hide the base map, if false then it will add the base map
	},
	
	--[[**
    	A boolean value that will be true if the player is BF and false if the player is Dad.	
    	
	**--]]
	flipMode = true,
	camControls = {
		zoom=0;
		BehaviourType = "All"; -- This is DEPRECATED
		hudZoom = 0;
		camZoom = 0;
		camOffset = CFrame.new(); -- The offset at which the camera's position is changed by (camera shake uses this)
		targetCam=CFrame.new(); -- The target position that the camera is trying to get to
		--directionOffset=Vector3.new();
		StayOnCenter = false; -- If true then the camera will not pan left to right to look at bf and dad
		DisableLerp = false; -- If true then the camera will snap into place
		noBump = false; -- if true then the camera will not zoom in on the beat
	},
	plrStats = {
		Health = 1;
		DrainRate = 0; -- The amount of health that is drained per second (0.03 recommended)
		MaxHealth = 2;
		Score = 0;
	},
	ratings = {
		marvelous=0;
		sick=0;
		good=0;
		bad=0;
		trash=0;
		miss=0;
	},
	internalSettings = {
		autoSize = 1; -- Basically a variable to handle the UI size, although it's only used once, so it's not recommended to change this value.
		notesRotateWithReceptors = false; -- Receptors will share their rotation with the notes.
		notesShareTransparencyWithReceptors = false; -- Notes will share the same transparency as the receptors transparency.
		OpponentNoteDrain = false; -- What it says, it can be a number to enable it.
		useDuoSkins = false;
		notesResizeWithReceptors = false;
		useBPMSyncing = false; -- Due to compatibility issues with certain modcharts, this will be used, i don't understand why neither.
		currentNoteSkinChange = nil;
		showOnlyStrums = false;
		NoteSpawnTransparency = 0;
		MoveSplashes = false;
	},
}
