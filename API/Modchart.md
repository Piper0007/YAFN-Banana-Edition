# Modcharts

> If any of this is confusing to read, go here first, [API Guide](API-Guide.md)

<details><summary><h2>Modchart Variables and Functions</h2></summary>

> Modchart variables can only be referenced inside of a returned modchart function (which are defined after this section)

<details><summary>Standard Modchart Variables</summary>

| Name : Type | Description |
|-------------|-------------|
| flipMode : boolean | A boolean which tells if it's playing Dad side |
| p1 : [Character](Classes/Character.md) | The opponent character |
| p2 : [Character](Classes/Character.md) | The player character |
| dad : [Character](Classes/Character.md) | The character on the left side of the stage (Dad) |
| bf : [Character](Classes/Character.md) | The character on the right side of the stage (Bf) |
| dad2 : [Character](Classes/Character.md) | The second character on the left side of the stage (Dad2) |
| bf2 : [Character](Classes/Character.md) | The second character on the right side of the stage |
| (readOnly) defaultcamzoom : number | Determines the FOV of the camera<br>Default is 1 |
| playerNoteOffsets : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | Contains 'Vector2' values, which describes the Receptor offset |
| opponentNoteOffsets : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | Contains 'Vector2' values, which describes the Receptor offset |
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
| gameHandler : [GameHandler](Classes/GameHandler.md) | A class that includes functions and variables that control the game |
| [internalSettings](#internalSettings) : table | A table that contains variables that change how the game functions in various ways |
| [playerObjects](#playerObjects) : [Character](Classes/Character.md){} | A table that contains `Character`s that are included in the song |
| [camControls](#camControls) : table | A table that contains variables that change how the functions and controls |
</details>

<details><summary>Standard Modchart Functions</summary>

| Name : Type | Description |
|-------------|-------------|
| [HideNotes](#HideNotes) : function | A function that simplifies the process of hiding notes/receptors |
| [MoveCamera](#MoveCamera) : function | A function that simplifies the process of getting the camera from point A to point B, instantly |
| [addSprite](#addSprite) : function | A function that is used to make a new image that overlays the screen<br>(by default, the image’s visible property will be set to `false`) |
| [addAnimatedSprite](#addAnimatedSprite) : function | A function that returns a Sprite that auto calibrates its size |
</details>
	
## Extra Stuff
> Everything here is previously mentioned but explained in more detail

<a name="playerObjects"></a><details><summary>playerObjects : Character{}</summary>

## Description
A list that contains the Characters that are on the stage
## Properties
| Name : Type | Description |
|-------------|-------------|
| Dad : [Character](Classes/Character.md) | Lists dad's character |
| BF : [Character](Classes/Character.md) | Lists bf's character |
| Dad2 : [Character](Classes/Character.md) | Lists the second dad's character, sometimes nil |
| BF2 : [Character](Classes/Character.md) | Lists the second bf's character, sometimes nil |
</details>

<a name="camControls"></a><details><summary>camControls : table</summary>

## Description
Handles the camera behavior
## Properties
| Name : Type | Description |
|-------------|-------------|
| zoom : number | Sets the game’s UI and camera zoom, depending on `camControls.BehaviourType`.<br>This value does nothing if BehaviourType is set to "Separate". |
| BehaviourType : string | Changes how the zooming is handled. The value is set to "Separate" by default.<br>Options are "All", "HUD", "Camera", and "Separate". |
| hudZoom : number | Sets the game's UI zoom.<br>Only works if BehaviourType is set to "Separate" |
| camZoom : number | Sets the camera zoom.<br>Only works if BehaviourType is set to "Separate". |
| camOffset : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame) | Offsets the camera to the specific CFrame value |
| StayOnCenter : boolean | When true, forces the camera to stay in the center of the spot (stays at the camera origin) |
| DisableLerp : boolean | When false, the camera will move instantly between where it is and where it is going to go |
</details>

<a name="internalSettings"></a><details><summary>internalSettings : table</summary>

## Description
A list of game settings that change various behaviors 
## Properties
| Name : Type | Description |
|-------------|-------------|
| autoSize : number | Only used to determine note’s sprite size at startup.<br>Its not recommended to change this value |
| notesRotateWithReceptors : boolean | This determines whether or not notes will copy the receptor’s rotation |
| notesShareTransparencyWithReceptors : boolean | This determines whether or not the notes will copy the receptor's transparency. (Alpha property for clarification) |
| OpponentNoteDrain : number | Whether or not the opponent would drain the player's health (if given value is greater than 0).<br>By default it does nothing |
| useDuoSkins : boolean | Determines if the engine should use separate Note skins for each side.<br>Requires a bit of programming knowledge to use (can only be changed at startup). |
| useBPMSyncing : boolean | Determines if the engine would use BPM (beats per minute) to sync the song.<br>This is not commonly used because certain modcharts break if this is used. |
| currentNoteSkinChange : table / nil | This variable is used to change the note skin as soon they spawn.<br>Must contain a XML, ImageLabel and a boolean in order to work.<br>Not recommended to edit. |
| showOnlyStrums : boolean | Unused, what it does is hides the notes but not the receptors |
| NoteSpawnTransparency : number | Determines the transparency of notes that spawn |
| minHealth : number | This property determines the minimum health that will drain before stopping, used in conjunction with `plrStats.DrainRate` |
</details>

<a name="HideNotes"></a><details><summary>HideNotes : function</summary>

## Description
A function that is used to hide the notes and or receptors for either the player, the opponent, or both
## Parameters
> Listed in the order that the parameters are required in

| Name : Type | Description |
|:------------|:-----------:|
| hideNotes : boolean | Whether or not to hide the notes (if false then it will unhide the notes, making them reappear) |
| side : string | Determines which side will be affected.<br><br>Options are "left", "right", or "both" |
| hideReceptors : boolean | Whether or not to hide the receptors as well |
| speed : number | Determines how fast the transition will last for (how fast the tween plays) |
## Example
> Inside a modchart

```lua
HideNotes(true, flipMode and "left" or "right", true, 5)
```
Hides the notes and receptors for the opponent's side which takes 5 seconds to do
</details>

<a name="MoveCamera"></a><details><summary>MoveCamera : function</summary>

## Description
A function that moves the camera to the specified position (moves the camera instantly, not smoothly)
## Parameters
> Listed in the order that the parameters are required in

| Name : Type | Description |
|:------------|:-----------:|
| position : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame) | The position that the camera will move to |
</details>

<a name="addSprite"></a><details><summary>addSprite : function</summary>

## Description
A function that returns a new ImageLabel that acts as an overlay for the screen<br>
(By default, the image will be set to not visible so please remember to set it to visible)
## Parameters
> Listed in the order that the parameters are required in

| Name : Type | Description |
|:------------|:-----------:|
| name : string | The name that the new sprite will be named |
| image : string | The `robloxassetid` of the image in string form |
| parent : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | The instance that the new sprite will be parented under |
## Return
> [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel)

Returns a `ImageLabel`
</details>

<a name="addAnimatedSprite"></a><details><summary>addAnimatedSprite : function</summary>

## Description
A function that returns a Sprite that auto calibrates its size based on 2 given inputs.<br>To explain, the ImageLabel you provide must have 2 attributes.<br>(SpriteSize) must be a `Vector2` value and set the two values to the width and height of the frame (or the frameSize)<br>(SpriteSheetSize) must be a `Vector2` value that is set to the size of the entire spritesheet's image<br><br>With that, the function is able to produce the accurate size needed for the sprite to fit in its frame.<br>(When scaling your image label, make sure the size is changed before turning it into a animated sprite)<br>(Also, when changing the scale, only use the Scale and not the offset)
## Parameters
> Listed in the order that the parameters are required in

| Name : Type | Description |
|:------------|:-----------:|
| image : [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel) | The `ImageLabel` that the new sprite will become (`ImageLabel` must have the attributes that are described in the description) |
| visible : boolean | Whether or not the new sprite will be visible as soon as it is made<br>default: false |
| parent : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | The parent `Instance` that the new sprite will attach to |
## Return
> [Sprite](Classes/Sprite.md)

Returns a `Sprite`
</details>

</details>

---

<details><summary><h2>Returned Modchart Functions</h2></summary>

> Returned Functions are vital for modcharts to work and are called at specific times and conditions

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

- P1NoteHit = function(noteType : string, noteData : number, note : [Note](Classes/Note.md))
```
Runs when the player hits a note
```

- P2NoteHit = function(noteType : string, noteData : number)
```
Runs when the opponent hits a note, this includes other players
```

- Update = function(deltaTime : number)
```
Runs whenever a frame is rendered
```

- StepHit = function(curStep : number)
```
Runs when a step is hit
```

- BeatHit = function(curBeat : number)
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

<details><summary><h2>Examples</h2></summary>

> Example showcasing how to run and handle events

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
