# Modcharts

<details>
	
<summary>
Modchart Variables (and Functions)
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

### plrStats : [PlayerStats](#PlayerStatsClass)
``A table that includes the player's stats``

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

<details>
<summary>gameHandler : Array</summary>

## Description
Contains all the functions that affect the game
## Properties
| Name : Type | Description |
|-------------|-------------|
| changeIcon : function(name: string, side: boolean (false=dad, true=bf) | Changes the icon for the selected side |
| changeAnimation : function(name: string, player: Object, speed: number, looped: boolean, force, boolean) | Changes player's animation but doesn't change appearance |
| flash : function(hex: string, speed: number, int: number (intial transparency) | Utilizes a frame that covers the size of the screen to tween its transparency to from the initial value to 1 (which is completely transparent). |
| processEvent : function(event : string, value1 : any, value2 : any, ...) | Runs an event through a processer that goes through all the known events and sends a signal to the EventTrigger if it is not already defined. For a list of all the events go to [Events](Events.md) |
| setProperty : function(varName : string, value : any) | A function used to change the values of specific variables (that can't be accessed otherwise)<br> Options for "varName":<br>'defaultCamZoom', 'camGame.zoom', 'camZooming', 'songLength'|
| getSongName : function(SongData: ModuleScript) | returns the name of the song from a modulescript (the chart data basically) |
| closeScript : function(name : string) | Used to disable modcharts from running during a song (the name will be something like "modchart.lua") |
| receptChangeSkin : function(Receptor : integer, NoteSkinLabel : ImageLabel, XML : ModuleScript) | Changes the skin of the receptors |
| ChangeNoteSkin : function(noteSkinName : string, boolSide : boolean (false=dad, true=bf), force : boolean, mania : integer) | Changes the note skin (as well as the receptors) |
| Kill : function | This just kills the player (make sure to check if the player has death enabled in settings before using it) |
| settings : Array | Contains a list of all the player's settings |
| PlayerObjects : [Character](#CharacterClass)[] | Contains a list of characters playing the song ("BF", "Dad", "BF2", "Dad2") |
| PositioningParts : Array | Contains a list of all the parts needed for setting up and handling the stage<br><br>Left: Instance<br>Right: Instance<br>Left2: Instance<br>Right2: Instance<br>Camera: Instance<br>isPlayer: Player[]<br>Spot: Instance (it's the boombox)|
| PlayerStats : [PlayerStats](#PlayerStatsClass) | Contains a list of all the player's stats |
</details>

</details>

<details>
<summary>Modchart Functions</summary>
	
### Return Functions are vital for modcharts to work and are called at specific times.
	
- "preInit = function(gameUI : Frame, module : table)"
	
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
	
- "Update = function(deltaTime : number)"
	
```
Runs whenever a frame is rendered
```
	
- "StepHit = function(curStep : integer)"
	
```
Runs when a step is hit
```
	
- "BeatHit = function(curBeat : integer)"
	
```
Runs when a beat is hit
```
	
- "sectionChange = function(currentSection : [Section](#SectionClass))"

```
Runs when a section changes
```
	
- "EventTrigger = function(name : string, value1 : any, value2 : any, ...)"
	
```
Runs when an event is played, even when an event is called from a modchart.
```
	
</details>

<details>
<summary>gameHandler.processEvent()</summary>
	
```LiveScript
/*
|| MORE IN DEPTH IN THE EVENTS API ||

This function will be used whenever you want to process an event.
Any time "processEvent()" is used the "EventTrigger()" event is played inside the modchart.
*/
```

  - "set camera zoom"
	
```LiveScript
value1 : Number
	# Sets the cameraZoom to value1
value2 : Number
	# Sets the hudZoom to value2
```
	
  - "tween camera zoom"
	
```LiveScript
value1 : Number
	# Target camera zoom
value2 : Number
	# Length of the tween
value3 : EasingStyle
	# Sets the style of the tween
value4 : EasingDirection
	# Sets the type of tween. (In, Out, InOut)
```
	
  - "add camera zoom"
	
```LiveScript
# This event only plays when the "CameraZooms" settings is true and hudZoom is less than 1.4.
	value1 : Number
		# Changes the hudZoom by this number
	value2 : Number
		# Changes the cameraZoom by this number
```
	
  - "camera follow pos"
	
```LiveScript
# Changes the camera offset to the defined position.
	value1 : Number
		# The x value of the offset
	value2 : Number
		# The y value of the offset
```
	
  - "set cam speed"
	
```LiveScript
# Cam Speed controls how fast the camera moves from position to position.
	value1 : Number
		# Sets the camSpeed to this value
```
  - "camera flash"  
```LiveScript
# This event only plays when the "distractions" setting is true
	value1 : Number
		# Controls the speed of the flash
	value2 : string # Hex value
		# Controls the color of the flash
```
	
  - "screen shake"
	
```LiveScript
This event shakes the screen but can also shake the UI
	value1 : Number | String # ("10, 0.1")
		/*
		When it is a number it controls the duration of the screen shake.
        	When it is a string separated by a comma the first number controls the
        	duration of the UI shake and the second controls the intensity.
		*/
	value2 : Number | String # ("10, 0.1")
		/*
		When it is a number, it controls the intensity of the screen shake.
        	When it is string separated by a comma, the first number controls the duration of the UI shake and the second number controls the intensity.
		*/
```
	
  - "hey!"
	
```LiveScript
# Plays the "hey" animation for either boyfriend, girlfriend, or dad however, only boyfriend works at the moment.
	value1 : String
		# Name of the character to dance.
```
	
  - "lane modifier"  
	
```LiveScript
# Changes the scroll speed of a arrows in a specific lane.
	value1 : Number
		# The value is the lane. Usually there are 8 lanes
	value2 : Number
		# The value is the speed the scroll speed changes to
```
	
  - "change scroll speed"

```LiveScript
# This event only plays when the setting "ForceSpeed" is false.
	value1 : Number
		# The speed the scroll speed will change to. (Speed Multiplier that is not actuall scroll speed)
	value2 : Number
		# How quick in seconds that the scroll speed will change to it's new value.
```

</details>

<details>
<summary>Classes</summary>

---
<details>
<summary name="CharacterClass">Character</summary>

## Description
A class that contains all the necessary info to animate a player model.
## Properties
| Name : Type | Description |
|-------------|-------------|
| BeatDancer : boolean | Beat dancers are characters that have 2 different idle animations that play back and forth |
| Obj : Instance | The actual rig of the character, which includes all the parts to the model. (This gets changed everytime the rig is changed) |
| EventHandler : LocalScript | Just the animator script of the player (do not ever change this value) |
| IsPlayer : boolean | A value that determines if the character is controlled by a player or not |
| Name : string | It is just the name of player who the animation is parent under. Could be used for modcharts |
| Animator : Instance | Do not change this value |
| (readOnly) StartCFrame : CFrame | This is just for the starting CFrame of the character, but changing it after the character is made does nothing |
| Animations : Array | A table that contains all of the animations that the Character has loaded |
| Microphone : nil | DEPRECATED |
| (readOnly) CurrPlaying : string | The name of the currently playing animation |
| (readOnly) Holding : boolean | Whether or not the animation is continuously playing |
| (readOnly) HoldTimer : number | How long the animation will play for |
| (readOnly) AnimPlaying : boolean | Whether or not there is an animation playing currently |
| (readOnly) AnimName : string | The name of the animation set |

</details>

<details>
<summary name="SectionClass">Section</summary>

## Description
A class that stores specific information about a section. Such as if the camera focuses on BF or Dad, the notes, the length, and the type of section.
## Properties
| Name : Type | Description |
|-------------|-------------|
| mustHitSection : boolean | Value is true if the section is focused on BF and false if it is focused on Dad. |
| typeOfSection : number | Determines the amount of beats per section, Default: 4 |
| lengthInSteps : number | Determines the length in steps that section is, Default: 16 |
| sectionNotes : Note[] | Includes a list of notes for the current section |
</details>

</details>

<details>
<summary name="PlayerStatsClass">PlayerStats</summary>

## Description
A class that includes the stats of the player (score, health, etc.)
## Properties
| Name : Type | Description |
|-------------|-------------|
| Health : number | The current health of the player, default: 1 |
| DrainRate : number | The speed in seconds that health will drain |
| MaxHealth : number | The maximum health of the player, default: 2 |
| Score : number | The score of the player |
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
