# Modcharts

<details>
<summary><h2>Modchart Variables (and Functions)</h2></summary>

<details>
<summary>Standard Modchart Variables</summary>

| Name : Type | Description |
|-------------|-------------|
| flipMode : boolean | A boolean which tells if it's playing Dad side |
| p1 : [Character](Classes/Character.md) | The opponent character |
| p2 : [Character](Classes/Character.md) | The player character |
| dad : [Character](Classes/Character.md) | The character on the left side of the stage (Dad) |
| bf : [Character](Classes/Character.md) | The character on the right side of the stage (Bf) |
| dad2 : [Character](Classes/Character.md) | The second character on the left side of the stage (Dad2) |
| bf2 : [Character](Classes/Character.md) | The second character on the right side of the stage |
| (readOnly) defaultcamzoom : number | Changes the FOV of the camera by 70. Default is 1 |
| playerNoteOffsets : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | Contains 'Vector2' values, which tells the Receptor offset |
| opponentNoteOffsets : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | Contains 'Vector2' values, which tells the Receptor offset |
| playSound : function(soundId : [robloxassetid](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Content), volume : number) | A function which plays sounds<br>Default volume is 2 |
| leftStrums : [Receptor](Classes/Receptor.md)[] | Contains the receptors from the left side |
| rightStrums : [Receptor](Classes/Receptor.md)[] | Contains the receptors from the right side |
| dadStrums : [Receptor](Classes/Receptor.md)[] | Contains the opponent receptors | playerStrums : [Receptor](Classes/Receptor.md)[] | Contains the player receptors |
| allReceptors : [Receptor](Classes/Receptor.md)[] | Contains Dad and BF receptors, typically there are 8 |
| noteLanes : [Note](Classes/Note.md)[] | An array that contains lanes with your current rendering notes. (can be BF or Dad, only one of them)<br>I.E susNotesLanes[1][2]<br>Should access the first lane of notes and the second rendering note. |
| susNoteLanes : [Note](Classes/Note.md)[] | An array that contains lanes with your current rendering holds notes. (can be BF or Dad, only one of them)<br>I.E susNotesLanes[1][2]<br>Should access the first lane of hold notes and the second rendering note. |
| noteGroup : string | A string which tells what noteGroup is the song currently using |
| mapProps : [Model](https://create.roblox.com/docs/en-us/reference/engine/classes/Model) | Returns the Model of the map, if it exists |
| (readOnly) initialSpeed : number | The starting speed of the scroll speed. This is like normal FNF but it's 0.45x slower |
| gameUI : [ScreenGui](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui) | Game user interface<br>If you want to add sprites to the UI, it's recommended to add them via gameUI.realGameUI.Notes |
| notes : [Note](Classes/Note.md)[] | A list of all the notes that are currently being rendered |
| unspawnedNotes : [Note](Classes/Note.md)[] | A list that contains all unspawned notes which are ordered by strumTime |
| plrStats : [PlayerStats](Classes/PlayerStats.md) | A table that includes the player's stats |
</details>

<details>
<summary>Standard Modchart Functions</summary>

| Name : Type | Description |
|-------------|-------------|
| HideNotes : function(hideNotes: boolean, side: string, hideReceptors: boolean, speed: number) | A function that that just makes it a bit easier to hide the notes/receptors |
| MoveCamera : function(position: [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame)) | A function that simplifies the process of getting the camera from point A to point B |
| addSprite : function(name: string, image: string, parent: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)) | A function that returns a new ImageLabel that acts as an overlay for your screen<br>(By default, the image will be set to not visible so please remember to set it to visible) |
| addAnimatedSprite : function(image: [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel), visible: boolean, parent: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)) | A function that returns a Sprite that auto calibrates its size based on 2 given inputs.<br>To explain, the ImageLabel you provide must have 2 attributes.<br>(SpriteSize) must be a Vector2 value and set the two values to the width and height of the frame (or the frameSize)<br>(SpriteSheetSize) must be a Vector 2 value that is set to the size of the entire spritesheet's image<br><br>With that, the function is able to produce the accurate size needed for the sprite to fit in its frame.<br>(When scaling your image label, make sure the size is changed before turning it into a animated sprite)<br>(Also when changing the scale only use the Scale and not the offset) |
</details>
	
<details>
<summary>playerObjects : Character{}</summary>

## Description
A list that contains the Characters that are on the stage
## Properties
| Name : Type | Description |
|-------------|-------------|
| Dad : [Character](Classes/Character.md) | Lists dad's character |
| BF : [Character](Classes/Character.md) | Lists bf's character |
| Dad2 : [Character](Classes/Character.md) | Lists the second dad's character, sometimes nil |
| BF2 : [Character](Classes/Classes/.md) | Lists the second bf's character, sometimes nil |
</details>

<details>
<summary>camControls : table</summary>

## Description
Handles the camera behavior
## Properties
| Name : Type | Description |
|-------------|-------------|
| zoom : number | Sets the game UI/camera zoom, depending by BehaviourType.<br>This value is useless if BehaviourType is set to "Separate". |
| BehaviourType : string | Changes how the zooming is handled. The value is set to "Separate" by default.<br>Options are "All", "HUD", "Camera", and "Separate". |
| hudZoom : number | Sets the game's UI zoom.<br>Only works if BehaviourType is set to "Separate" |
| camZoom : number | Sets the camera zoom.<br>Only works if BehaviourType is set to "Separate". |
| camOffset : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame) | Offsets the camera to the specific CFrame value |
| StayOnCenter : boolean | When true, forces the camera to stay in the center of the spot (stays at the camera origin) |
| DisableLerp : boolean | When false, the camera will move instantly between where it is and where it is going to go |
</details>

<details>
<summary>internalSettings : table</summary>

## Description
A list of game settings that change various behaviors 
## Properties
| Name : Type | Description |
|-------------|-------------|
| autoSize : number | Only used to determine sprites size at start up.<br>Its not recommended to edit this value |
| notesRotateWithReceptors : boolean | This sets the notes to copy the receptors rotation |
| notesShareTransparencyWithReceptors : boolean | This sets the notes to copy the receptor's transparency. (Alpha variable for clarification) |
| OpponentNoteDrain : number | Whether or not the opponent would drain the player's health, if given value is greater than 0.<br>By default it does nothing |
| useDuoSkins : boolean | Determines if the engine should use separate Note skins for each side.<br>Not recommended to edit, although it's only used once at start up. |
| useBPMSyncing : boolean | Determines if the engine would BPM to sync the song.<br>This is added because certain modcharts break if this is used.<br>I don't know why either. |
| currentNoteSkinChange : table / nil | This variable is used to change the note skin as soon they spawn.<br>Must contain a XML, ImageLabel and a boolean in order to work.<br>Not recommended to edit. |
| showOnlyStrums : boolean | Unused, what it does is hides the notes but not the receptors |
| NoteSpawnTransparency : number | Determines the transparency of notes that spawn |
| minHealth : number | This variable determines the minimum health that health drain will go to before stopping, used in conjunction with "plrStats.DrainRate" |
</details>

<details>
<summary>gameHandler : table</summary>

## Description
Contains all the functions/variables that affect the game
## Properties
| Name : Type | Description |
|-------------|-------------|
| changeIcon : function(name: string, side: boolean (false=dad, true=bf) | Changes the icon for the selected side |
| changeAnimation : function(name: string, player: [Character](Classes/Character.md), speed: number, looped: boolean, force: boolean) | Changes player's animation but doesn't change appearance |
| flash : function(hex: string, speed: number, initialTransparency: number | Flashes the screen at the specified speed, color, and starting transparency (this function is used with the “camera flash” event |
| processEvent : function(event : string, value1 : any, value2 : any, ...) | Runs an event through a processor that goes through all the known events and sends a signal to the EventTrigger if it is not already defined. For a list of all the events go to [Events](Events.md) |
| setProperty : function(varName : string, value : any) | A function used to change the values of specific variables (that can't be accessed otherwise)<br> Options for "varName":<br>'defaultCamZoom', 'camGame.zoom', 'camZooming', 'songLength'|
| getSongName : function(SongData: [ModuleScript](https://create.roblox.com/docs/en-us/reference/engine/classes/ModuleScript)) | returns the name of the song from a modulescript (the chart data basically) |
| closeScript : function(name : string) | Used to disable modcharts from running during a song (the name will be something like "modchart.lua") |
| receptChangeSkin : function(Receptor : integer, NoteSkinLabel : [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel), XML : [ModuleScript](https://create.roblox.com/docs/en-us/reference/engine/classes/ModuleScript)) | Changes the skin of the receptors |
| ChangeNoteSkin : function(noteSkinName : string, boolSide : boolean (false=dad, true=bf), force : boolean, mania : integer) | Changes the note skin (as well as the receptors) |
| Kill : function() | This just kills the player (make sure to check if the player has death enabled in settings before using it) |
| settings : table | Contains a list of all the player's settings |
| PlayerObjects : [Character](Classes/Character.md){} | Contains a list of characters playing the song ("BF", "Dad", "BF2", "Dad2") |
| PositioningParts : table | Contains a list of all the parts needed for setting up and handling the stage<br><br>Left: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Right: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Left2: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Right2: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Camera: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>isPlayer: [Player](https://create.roblox.com/docs/en-us/reference/engine/classes/Player)[]<br>Spot: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) (it's the boombox)|
| PlayerStats : [PlayerStats](Classes/PlayerStats.md) | Contains a list of all the player's stats |
</details>

</details>

---

<details>
<summary><h2>Returned Modchart Functions</h2></summary>

#### Return Functions are vital for modcharts to work and are called at specific times.
	
- preInit = function(gameUI : [ScreenGui](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui), module : table)
	
```
This function is played before the song has started loading
```
	
- init = function()
	
```
This function is played when the song is loading
```
	
- preStart = function()
	
```
Runs when the countdown starts
```
	
- Start = function()
	
```
Runs when the song starts
```
	
- P1NoteHit = function(noteType : string, noteData : integer, note : [Note](Classes/Note.md))
	
```
Runs when the player hits a note
```
	
- P2NoteHit = function(noteType : string, noteData : integer)
	
```
Runs when the opponent hits a note, this includes other players
```
	
- Update = function(deltaTime : number)
	
```
Runs whenever a frame is rendered
```
	
- StepHit = function(curStep : integer)
	
```
Runs when a step is hit
```
	
- BeatHit = function(curBeat : integer)
	
```
Runs when a beat is hit
```
	
- sectionChange = function(currentSection : [Section](Classes/Section.md))

```
Runs when a section changes
```
	
- EventTrigger = function(name : string, value1 : any, value2 : any, ...)
	
```
Runs when an event is played, even when an event is called from a modchart.
```
	
</details>

---

<details>
<summary><h2>Examples</h2></summary>
<br>

Example showcasing how to run and handle events
```lua
--!nolint UnknownGlobal
--!nolint UninitializedLocal
--local Conductor = require(game.ReplicatedStorage.Modules.Conductor) -- This doesn't need to be defined unless you need to know the stepCrochet or BPM and whatnot
--local timer = 0; -- If this is unused then get rid of it
return {
	-- This function is played after the countdown
	Start = function()
		gameHandler.processEvent("change scroll speed", 1.15, 2)
		-- Changes the scroll speed to 1.15x the song's scroll speed over the course of 2 seconds
	end,
	
	-- This function is played whenever an event is processed (even when the modchart processes an event itself, so avoid making a feedback loop)
	EventTrigger = function(name, value1, value2)
		if name == "mycustomevent" then -- The name is always in lowercase
			-- Lets just say that value1 is the x and value2 is the y
			-- Because value1 and value2 are usually strings, you must set them to number values (in this instance at least)
			value1 = tonumber(value1)
			value2 = tonumber(value2)
			
			for i = 1, #allReceptors do -- Iterates through all of the receptors, usually there are 8
				allReceptors[i]:SetPosition(value1 + (i * 10), value2) -- Sets the x and y values of the receptor
			end
		end
	end,
}
```
</details>
