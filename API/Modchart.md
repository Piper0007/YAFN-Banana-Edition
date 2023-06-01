# Modcharts

<details>
	
<summary>Modchart Variables</summary>
	
### flipMode : boolean
	
```
A bool which tells if it's playing Dad side.
```
	
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
	
### playerObjects : table/Dictionary
	
```LiveScript
    || CONTENTS ||
    Dad : Object
    BF : Object
    Dad2 : Object
    BF2 : Object
```
	
### defaultcamzoom : number
	
```Changes the FOV of the camera by 70. Default is 1.```
	
### playerNoteOffsets : table/Array
	
```Contains 'Vector2' values, which tells the Receptor offset.```
	
### opponentNoteOffsets : table/Array
	
```Contains 'Vector2' values, which tells the Receptor offset.```
	
### playSound : function (soundId : id, volume : number) (default volume is 2)
	
```A function which plays sounds```
	
### leftStrums : table/Array
	
```Contains the receptors from the left side.```
	
### rightStrums : table/Array
	
```Contains the receptors from the right side.```
	
### dadStrums : table/Array
	
```Contains the opponent receptors.```
	
### playerStrums : table/Array
	
```Contains the player receptors.```
	
### allReceptors : table/Array
	
```Contains Dad and BF receptors.```
	
### _.GUI : table/Array
	
```LiveScript
    || CONTENTS ||
    Rotation : number
		 variable that dictates the rotation of the receptor(s)
```
	
### camControls : table/Dictionary
	
```LiveScript
    Handles the camera behaviour.
		|| CONTENTS ||		
		  zoom : number
				Sets the game UI/camera zoom, depending by BehaviourType.
				This value is useless if BehaviourType is set to "Separate".
			BehaviourType : string (All,HUD,Camera,Separate)
				Changes how the zoom should work.
			hudZoom : number
				Sets the game UI zoom.
				Only effective if BehaviourType is set to "Separate".
			camZoom : number
				Sets the camera zoom.
				Only effective if BehaviourType is set to "Separate".
			camOffset : CFrame
				Camera offset.
			StayOnCenter : boolean
				Forces the camera to stay in center of the spot.
			DisableLerp : boolean
				Toggles whenever the zoom should slowly tween back to their original value.
				Useful if you want to make a consistent zoom mechanic.
```
	
### internalSettings : table/Dictionary
	
```LiveScript
    Settings where you can toggle certain behaviours.
		|| CONTENTS ||
			autoSize : number
				Only used to determine sprites size at start up.
				Its not recommended to edit this value.
			notesRotateWithReceptors : boolean
				This sets the notes to copy the receptors rotation.
			notesShareTransparencyWithReceptors : boolean
				This sets the notes to copy the receptors transparency. (Alpha variable for clarification)
			OpponentNoteDrain : number
				This toggles whenever the NPC should drain the players health, if given value is a number.
				By default its set to False, which does nothing.
			useDuoSkins : boolean
				Determines if the engine should use separate Note skins for each side.
				Not recommended to edit, although its only used once at start up.
			useBPMSyncing : booleans
				Toggles if the engine should use the BPM syncing.
				This is added beacuse certain modcharts breaks if this is used.
				We dont know why as well.
			currentNoteSkinChange : table|nil
				This variable is used to change the note skin as soon they spawn.
				Contains the XML, ImageLabel and a boolean in order to work.
				Not recommended to edit.
			showOnlyStrums : boolean
				Unused.
			NoteSpawnTransparency : number
				This variable is used to change the notes transparency as soon they spawn.
				Must range from 0 to 1.
			minHealth : number
				This variable determins the minimum health that health drain will go to before stopping
```
	
### gameUI : Instance/ScreenGui
	
```LiveScript
    Game user interface.
    If you want to add sprites to the UI, its recommended to add them via gameUI.realGameUI.Notes
```
### gameHandler : table/Dictionary
	
```The engine module.```
	
### notes : table/Array
	
```A list of all the notes that are currently being rendered.```
	
### unspawnedNotes : table/Array
	
```LiveScript
	An array which contains unspawned notes.
	Its ordered by strumTime.
```
### noteLanes : table/Array
	
```LiveScript
	An array that contains lanes with your current rendering notes. (can be BF or Dad, only one of them)
	I.E susNotesLanes[1][2]
		Should access the first lane of notes and the second rendering note.
```
### susNoteLanes : table/Array
	
```LiveScript
	An array that contains lanes with your current rendering hold notes. (can be BF or Dad, only one of them)
	I.E susNotesLanes[1][2]
		Should access the first lane of hold notes and the second rendering note.
```
### noteGroup : string
	
``A string which tells what noteGroup is the song currently using.``
	
### mapProps : string
	
``Should return the object for the map but prob won't work.``
	
### initialSpeed : number
	
``The speed of the scroll speed. This is like normal FNF but it's 0.45 times less``
	
### gameHandler : table/Directory
	
```LiveScript
	Contains all the functions that affect the game
		|| CONTENTS || 
		changeIcon(name : string, side : boolean (false=dad, true=bf)) : function
      			Changes the icon for the selected side.
		changeAnimation(name : , player : object, speed, looped : boolean, force : boolean) : function
			Changes player's animation but doesn't change appearance.
		flash(hex, speed : number, int : initial transparency) : function
			Utilizes a frame that covers the size of the screen to tween its transparency to from the initial value to 1
      			(which is completely transparent).
		processEvent(event : string, value1 : float, value2 : float, ...)
			Runs an event through a processer that goes through all the known events and sends a signal to the 
      			EventTrigger if it is not already defined.
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
local Conductor = require(game.ReplicatedStorage.Modules.Conductor)
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
