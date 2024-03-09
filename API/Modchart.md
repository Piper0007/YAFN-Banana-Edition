# Modcharts

<details>
	
<summary>
Modchart Variables
</summary>
	
### flipMode : Boolean	
``
A bool which tells if it's playing Dad side.
``
	
### p1 : Character
```The opponent character.```
	
### p2 : Character
```The player character.```
	
### dad : Character
```Dad Character.```
	
### dad2 : Character
```Secondary Dad character.```
	
### bf : Character
```BF character.```
	
### bf2 : Character
```Secondary BF character.```
	
### playerObjects : Table/Dictionary
```LiveScript
    || CONTENTS ||
    Dad : Object
    BF : Object
    Dad2 : Object
    BF2 : Object
```
	
### (readOnly) defaultcamzoom : Number
```Changes the FOV of the camera by 70. Default is 1.```
	
### playerNoteOffsets : Table/Array
```Contains 'Vector2' values, which tells the Receptor offset.```
	
### opponentNoteOffsets : Table/Array
```Contains 'Vector2' values, which tells the Receptor offset.```
	
### playSound : Function (soundId : robloxAssetID, volume : Number) (default volume is 2)
```A function which plays sounds```
	
### leftStrums : Table/Array
```Contains the receptors from the left side.```
	
### rightStrums : Table/Array	
```Contains the receptors from the right side.```
	
### dadStrums : Table/Array	
```Contains the opponent receptors.```
	
### playerStrums : Table/Array
```Contains the player receptors.```
	
### allReceptors : Table/Array	
```Contains Dad and BF receptors.```
	
### .GUI : Table/Array
``Basically contains everything you can do with a imageLabel``
```LiveScript
	|| CONTENTS ||
	Rotation : Number /* variable that dictates the rotation of the receptor(s) */
```
	
### camControls : Table/Dictionary
``
Handles the camera behaviour
``
```LiveScript
	|| CONTENTS ||		
	zoom : Number
		/*
		Sets the game UI/camera zoom, depending by BehaviourType.
		This value is useless if BehaviourType is set to "Separate".
		*/
	BehaviourType : String (All,HUD,Camera,Separate)
		/*
		Changes how the zoom should work.
		Behaviour type is not used with the new system
		*/
	hudZoom : Number
		/*
		Sets the game UI zoom.
		Only effective if BehaviourType is set to "Separate".
		*/
	camZoom : Number
		/*
		Sets the camera zoom.
		Only effective if BehaviourType is set to "Separate".
		*/
	camOffset : CFrame
	StayOnCenter : Boolean
		/* Forces the camera to stay in center of the spot. */
	DisableLerp : Boolean
		/*
		Toggles whenever the zoom should slowly tween back to their original value.
		Useful if you want to make a consistent zoom mechanic.
		*/
```
	
### internalSettings : Table/Dictionary
``Settings where you can toggle certain behaviours.``
```LiveScript
|| CONTENTS ||
	autoSize : Number
		/*
		Only used to determine sprites size at start up.
		Its not recommended to edit this value.
		*/
	notesRotateWithReceptors : Boolean
		/* This sets the notes to copy the receptors rotation. */
	notesShareTransparencyWithReceptors : Boolean
		/* This sets the notes to copy the receptors transparency. (Alpha variable for clarification) */
	OpponentNoteDrain : Number
		/*
		This toggles whenever the NPC should drain the players health, if given value is a number.
		By default its set to False, which does nothing.
		*/
	useDuoSkins : Boolean
		/*
		Determines if the engine should use separate Note skins for each side.
		Not recommended to edit, although its only used once at start up.
		*/
	useBPMSyncing : Boolean
		/*
		Toggles if the engine should use the BPM syncing.
		This is added beacuse certain modcharts breaks if this is used.
		We dont know why as well.
		*/
	currentNoteSkinChange : Table | nil
		/*
		This variable is used to change the note skin as soon they spawn.
		Contains the XML, ImageLabel and a boolean in order to work.
		Not recommended to edit.
		*/
	showOnlyStrums : Boolean
		/* Unused. */
	NoteSpawnTransparency : Number
		/*
		This variable is used to change the notes transparency as soon they spawn.
		Must range from 0 to 1.
		*/
	minHealth : Number
		/* This variable determins the minimum health that health drain will go to before stopping */
```
	
### gameUI : Instance/ScreenGui
``
Game user interface.
If you want to add sprites to the UI, its recommended to add them via gameUI.realGameUI.Notes
``
	
### notes : Table/Array
``A list of all the notes that are currently being rendered.``
	
### unspawnedNotes : Table/Array
``
An array which contains unspawned notes.
Its ordered by strumTime.
``
### noteLanes : Table/Array
``
An array that contains lanes with your current rendering notes. (can be BF or Dad, only one of them)
I.E susNotesLanes[1][2]
	Should access the first lane of notes and the second rendering note.
``
### susNoteLanes : Table/Array
``
An array that contains lanes with your current rendering hold notes. (can be BF or Dad, only one of them)
I.E susNotesLanes[1][2]
	Should access the first lane of hold notes and the second rendering note.
``
### noteGroup : String
``A string which tells what noteGroup is the song currently using.``
	
### mapProps : String
``Should return the object for the map but prob won't work.``
	
### initialSpeed : Number	
``The speed of the scroll speed. This is like normal FNF but it's 0.45 times less``

### plrStats : Table/Array
``A table that includes the player's stats``
```LiveScript
|| CONTENTS ||
	Health : Number /* Default: 1, health of the player */
	DrainRate : Number /* Default: 0, health drained in seconds. */
	MaxHealth : Number /* Default: 2, the maximum health of the player */
	Score : Number /* Default: 0, the score of the player */
```

### HideNotes : Function (hideNotes: Boolean, side: String, hideReceptors: Boolean, speed: Number)
```A function that that just makes it a bit easier to hide the notes/receptors```

### MoveCamera : Function (position: CFrame)
```A function that simplifies the process of getting the camera from point A to point B```

### addSprite : Function (tag: String, image: String, parent: Instance)
```
A function that returns a new ImageLabel that acts as an overlay for your screen
(By default, the image will be set to not visible so please remember to set it to visible)
```

### addAnimatedSprite : Function (image: ImageLabel, visible: Boolean, parent: Instance)
```
A function that returns a Sprite that autocalibrates it's size based on 2 given inputs.
To explain, the ImageLabel you provide must have 2 attributes.
(SpriteSize) must be a Vector2 value and set the two values to the width and height of the frame (or the frameSize)
(SpriteSheetSize) must be a Vector 2 value that is set to the size of the entire speet sheet's image

With that, the function is able to produce the accurate size needed for the sprite to fit in it's frame.
(When scaling your image label, make sure the size is changed before turning it into a animated sprite)
(Also when changing the scale only use the Scale and not the offset)
```
	
### gameHandler : table/Directory
``Contains all the functions that affect the game``
```LiveScript
|| CONTENTS ||
	/* Functions */
	changeIcon(name: String, side: Boolean (false=dad, true=bf)) : Function
      		/* Changes the icon for the selected side. */
	changeAnimation(name: String, player: Object, speed: Number, looped: Boolean, force: Boolean) : Function
		/* Changes player's animation but doesn't change appearance. */
	flash(hex: String, speed: Number, int: Number (initial transparency) ) : function
		/*
		Utilizes a frame that covers the size of the screen to tween its transparency to from the initial value to 1
      		(which is completely transparent).
		*/
	processEvent(event : string, value1 : float, value2 : float, ...)
		/*
		Runs an event through a processer that goes through all the known events and sends a signal to the 
      		EventTrigger if it is not already defined.
		For a list of all the events go to the Events API
		*/
	setProperty(varName : String, value : Any)
		value /* the value to set the property to */
		varName /* The name of the variable, list of options \/ */
		|| OPTIONS ||
		'camControls' /* list (do not use setProperty() for this) */
		'defaultCamZoom' /* number, default: 1 */
		'camGame.zoom' /* number */
		'camZooming' /* boolean */
		'songLength' /* This changes the length of the TimeBar, it does not change the actual length of the song */
		*/
	getSongName(SongData: ModuleScript) /* returns the name of the song from a moduleScript */
	closeScript(name: String) /* Used to prevent the modchart from being used any more in a song (the name will be something like "modchart.lua") */
	receptChangeSkin(Receptor: Integer, NSLabel: ImageLabel, XML: ModuleScript) /* changes the receptors
	ChangeNoteSkin(noteSkinName: String, boolSide: Boolean (false=dad, true=bf), force: Boolean, mania: Integer) /* Changes the note skin */
	Kill() /* This just kills the player, nothing special really (check if the player has death enabled before using this) */

	/* Lists/Variables
	settings: /* Contains a list of all the player's settings */
	PlayerObjects: /* Contains a list of the players' objects (dad, bf) */
	PositioningParts: /* Contains a list of all the parts to the stage */
		Left: Instance /*  Dad */
		Right: Instance /* Boyfriend */
		Left2: Instance /* Second BF */
		Right2: Instance /* Second Dad */
		Camera: Instance
		isPlayer: Player[] /* bf, dad, bf2, dad2 */
		AccuracyRate: String /* the funny messages */
		PlayAs: Boolean /* none, left or right */
		isOpponentAvailable: Player? /* If it has a value then there is a opponent on the stage */
		Spot: Instance /* It's the boombox */
		/*BFIcon: IconSprite DEPRECATED
		/*DadIcon: IconSprite DEPRECATED
		CameraPlayer: Boolean
	PlayerStats: /* Contains a list of all the player's stats */
		Health: Number /* Default: 1 */
		DrainRate: Number /* Default: 0, health drained in seconds. */
		MaxHealth: Number /* Default: 2 */
		Score: Number /* Default: 0 */
```
	
</details>

<details>
	<summary>Modchart Functions</summary>
	
	
### Functions are vital for modcharts to work and are called at specific times.
	
- "preInit = function(gameUI : frame, module : table)"
	
```
This function is played before the song has started loadin
```
	
- "init = function()"
	
```
This function is played when the song is loading
```
	
- "preStart = function()"
	
```
Runs when the countdown starts
```
	
- "Start = function()"
	
```
Runs when the song starts
```
	
- "P1NoteHit = function(noteType : string, noteData : number, note : table)"
	
```
Runs when the player hits a note
```
	
- "P2NoteHit = function(noteType : string, noteData : number)"
	
```
Runs when the opponent hits a note, this includes other players
```
	
- "Update = function(deltaTime)"
	
```
Runs whenever a frame is rendered
```
	
- "StepHit = function(curStep)"
	
```
Runs when a step is hit
```
	
- "BeatHit = function(curBeat)"
	
```
Runs when a beat is hit
```
	
- "sectionChange = function(currentSection : table)"

```
Runs when a section changes
	"currentSection" is a table that includes,
		mustHitSection : boolean,
		typeOfSection : number,
		lengthInSteps : number,
		sectionNotes : table
```
	
- "EventTrigger = function(name : string, value1 : float, value2 : float, ...)"
	
```
Runs when an event is played, even when an event is called from a modchart.
```
	
</details>

<details>
<summary>gameHandler.processEvent()</summary>
	
```LiveScript
|| MORE IN DEPTH IN THE EVENTS API ||

This function will be used whenever you want to process an event.
Any time "processEvent()" is used the "EventTrigger()" event is played inside the modchart.
```

  - "set camera zoom"
	
```LiveScript
value1 : number
	Sets the cameraZoom to value1
value2 : number
	Sets the hudZoom to value2
```
	
  - "tween camera zoom"
	
```LiveScript
value1 : number
	Target camera zoom
value2 : number
	Length of the tween
value3 : EasingStyle
	Sets the style of the tween
value4 : EasingDirection
	Sets the type of tween. (In, Out, InOut)
```
	
  - "add camera zoom"
	
```LiveScript
This event only plays when the "CameraZooms" settings is true and
hudZoom is less than 1.4.
	value1 : number
		Changes the hudZoom by this number
	value2 : number
		Changes the cameraZoom by this number
```
	
  - "camera follow pos"
	
```LiveScript
Changes the camera offset to the defined position.
	value1 : number
		The x value of the offset
	value2 : number
		The y value of the offset
```
	
  - "set cam speed"
	
```LiveScript
Cam Speed controls how fast the camera moves from position to position.
	value1 : number
		Sets the camSpeed to this value
```
  - "camera flash"  
```LiveScript
This event only plays when the "distractions" setting is true
	value1 : number
		Controls the speed of the flash
	value2 : hex
		Controls the color of the flash
```
	
  - "screen shake"
	
```LiveScript
This event shakes the screen but can also shake the UI
	value1 : number / string ("10, 0.1")
		When it is a number it controls the duration of the screen shake
        	When it is a string separated by a comma the first number controls the
        	duration of the UI shake and the second controls the intensity.
	value2 : number / string ("10, 0.1")
		When a number it controls the intensity of the screen shake
        	When a string separated by a comma the first number controls the 
        	duration of the UI shake and the second controls the intensity.
```
	
  - "hey!"
	
```LiveScript
Plays the "hey" animation for either boyfriend, girlfriend, or dad
however, only boyfriend works at the moment.
	value1 : string
		Name of the character to dance.
```
	
  - "lane modifier"  
	
```LiveScript
Changes the scroll speed of a arrows in a specific lane.
	value1 : number
		The value is the lane. Usually there are 8 lanes
	value2 : number
		The value is the speed the scroll speed changes to
```
	
  - "change scroll speed"

```LiveScript
This event only plays when the setting "ForceSpeed" is false.
	value1 : number
		The speed the scroll speed will change to. (Speed Multiplier that is not actuall scroll speed)
	value2 : number
		How quick in seconds that the scroll speed will change to it's new value.
```

</details>

<details>
	
<summary>Examples</summary>

```lua
--!nolint UnknownGlobal
--!nolint UninitializedLocal
--local Conductor = require(game.ReplicatedStorage.Modules.Conductor) -- This doesn't need to be defined unless you need to know the stepCrochet or BPM and what not
--local timer = 0; -- If this is unused then get rid of it.
return {
	-- This function is played after the countdown.
	Start = function()
		gameHandler.processEvent("change scroll speed", 1.15, 2)
		-- Changes the scroll speed to 1.15x the song's scroll speed over the course of 2 seconds.
	end,
	
	-- This function played whenever an event is processed
	EventTrigger = function(name, value1, value2, ...)
		if name == "mycustomevent" then -- The name is always in lowercase
			-- Lets just say that value1 is the x and value2 is the y.
			for i = 1, #allReceptors do -- Iterates through all of the receptors, usually there are 8.
				allReceptors[i]:SetPosition(value1 + (i * 10), value2) -- Sets the x and y values of the receptor.
			end
		end
	end,
}
```
	
</details>
