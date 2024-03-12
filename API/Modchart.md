# Modcharts

<details>
<summary><h2>Modchart Variables (and Functions)</h2></summary>

<details>
<summary>Standard Modchart Variables</summary>

| Name : Type | Description |
|-------------|-------------|
| flipMode : boolean | A boolean which tells if it's playing Dad side |
| p1 : [Character](#CharacterClass) | The opponent character |
| p2 : [Character](#CharacterClass) | The player character |
| dad : [Character](#CharacterClass) | The character on the left side of the stage (Dad) |
| bf : [Character](#CharacterClass) | The character on the right side of the stage (Bf) |
| dad2 : [Character](#CharacterClass) | The second character on the left side of the stage (Dad2) |
| bf2 : [Character](#CharacterClass) | The second character on the right side of the stage |
| (readOnly) defaultcamzoom : number | Changes the FOV of the camera by 70. Default is 1 |
| playerNoteOffsets : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | Contains 'Vector2' values, which tells the Receptor offset |
| opponentNoteOffsets : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | Contains 'Vector2' values, which tells the Receptor offset |
| playSound : function(soundId : [robloxassetid](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Content), volume : number) | A function which plays sounds<br>Default volume is 2 |
| leftStrums : [Receptor](#ReceptorClass)[] | Contains the receptors from the left side |
| rightStrums : [Receptor](#ReceptorClass)[] | Contains the receptors from the right side |
| dadStrums : [Receptor](#ReceptorClass)[] | Contains the opponent receptors | playerStrums : [Receptor](#ReceptorClass)[] | Contains the player receptors |
| allReceptors : [Receptor](#ReceptorClass)[] | Contains Dad and BF receptors, typically there are 8 |
| noteLanes : [Note](#NoteClass)[] | An array that contains lanes with your current rendering notes. (can be BF or Dad, only one of them)<br>I.E susNotesLanes[1][2]<br>Should access the first lane of notes and the second rendering note. |
| susNoteLanes : [Note](#NoteClass)[] | An array that contains lanes with your current rendering hold notes. (can be BF or Dad, only one of them)<br>I.E susNotesLanes[1][2]<br>Should access the first lane of hold notes and the second rendering note. |
| noteGroup : string | A string which tells what noteGroup is the song currently using |
| mapProps : [Model](https://create.roblox.com/docs/en-us/reference/engine/classes/Model) | Returns the Model of the map, if it exists |
| (readOnly) initialSpeed : number | The speed of the scroll speed. This is like normal FNF but it's 0.45 times less |
| gameUI : [ScreenGui](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui) | Game user interface<br>If you want to add sprites to the UI, its recommended to add them via gameUI.realGameUI.Notes |
| notes : [Note](#NoteClass)[] | A list of all the notes that are currently being rendered |
| unspawnedNotes : [Note](#NoteClass)[] | A list that contains all unspawned notes which are ordered by strumTime |
| plrStats : [PlayerStats](#PlayerStatsClass) | A table that includes the player's stats |
</details>

<details>
<summary>Standard Modchart Functions</summary>

| Name : Type | Description |
|-------------|-------------|
| HideNotes : function(hideNotes: boolean, side: string, hideReceptors: boolean, speed: number) | A function that that just makes it a bit easier to hide the notes/receptors |
| MoveCamera : function(position: [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame)) | A function that simplifies the process of getting the camera from point A to point B |
| addSprite : function(name: string, image: string, parent: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)) | A function that returns a new ImageLabel that acts as an overlay for your screen<br>(By default, the image will be set to not visible so please remember to set it to visible) |
| addAnimatedSprite : function(image: [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel), visible: boolean, parent: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)) | A function that returns a Sprite that autocalibrates it's size based on 2 given inputs.<br>To explain, the ImageLabel you provide must have 2 attributes.<br>(SpriteSize) must be a Vector2 value and set the two values to the width and height of the frame (or the frameSize)<br>(SpriteSheetSize) must be a Vector 2 value that is set to the size of the entire speet sheet's image<br><br>With that, the function is able to produce the accurate size needed for the sprite to fit in it's frame.<br>(When scaling your image label, make sure the size is changed before turning it into a animated sprite)<br>(Also when changing the scale only use the Scale and not the offset) |
</details>
	
<details>
<summary>playerObjects : Character[]</summary>

## Description
A list that contains the Characters that are on the stage
## Properties
| Name : Type | Description |
|-------------|-------------|
| Dad : [Character](#CharacterClass) | Lists dad's character |
| BF : [Character](#CharacterClass) | Lists bf's character |
| Dad2 : [Character](#CharacterClass) | Lists the second dad's character, sometimes nil |
| BF2 : [Character](#CharacterClass) | Lists the second bf's character, sometimes nil |
</details>
	
<details>
<summary>camControls : Array</summary>

## Description
Handles the camera behaviour
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
<summary>internalSettings : Array</summary>

## Description
A list of game settings that change various behaviours
## Properties
| Name : Type | Description |
|-------------|-------------|
| autoSize : number | Only used to determine sprites size at start up.<br>Its not recommended to edit this value |
| notesRotateWithReceptors : boolean | This sets the notes to copy the receptors rotation |
| notesShareTransparencyWithReceptors : boolean | This sets the notes to copy the receptors transparency. (Alpha variable for clarification) |
| OpponentNoteDrain : number | Whether or not the opponent would drain the player's health, if given value is greater than 0.<br>By default it does nothing |
| useDuoSkins : boolean | Determines if the engine should use separate Note skins for each side.<br>Not recommended to edit, although its only used once at start up. |
| useBPMSyncing : boolean | Determines if the engine would BPM to sync the song.<br>This is added beacuse certain modcharts breaks if this is used.<br>I dont know why either. |
| currentNoteSkinChange : table / nil | This variable is used to change the note skin as soon they spawn.<br>Must contain a XML, ImageLabel and a boolean in order to work.<br>Not recommended to edit. |
| showOnlyStrums : boolean | Unused, what it does is hides the notes but not the receptors |
| NoteSpawnTransparency : number | Determines the transparency of notes that spawn |
| minHealth : number | This variable determins the minimum health that health drain will go to before stopping, used in conjunction with "plrStats.DrainRate" |
</details>

<details>
<summary>gameHandler : Array</summary>

## Description
Contains all the functions/variables that affect the game
## Properties
| Name : Type | Description |
|-------------|-------------|
| changeIcon : function(name: string, side: boolean (false=dad, true=bf) | Changes the icon for the selected side |
| changeAnimation : function(name: string, player: [Character](#CharacterClass), speed: number, looped: boolean, force: boolean) | Changes player's animation but doesn't change appearance |
| flash : function(hex: string, speed: number, int: number (intial transparency) | Utilizes a frame that covers the size of the screen to tween its transparency to from the initial value to 1 (which is completely transparent). |
| processEvent : function(event : string, value1 : any, value2 : any, ...) | Runs an event through a processer that goes through all the known events and sends a signal to the EventTrigger if it is not already defined. For a list of all the events go to [Events](Events.md) |
| setProperty : function(varName : string, value : any) | A function used to change the values of specific variables (that can't be accessed otherwise)<br> Options for "varName":<br>'defaultCamZoom', 'camGame.zoom', 'camZooming', 'songLength'|
| getSongName : function(SongData: [ModuleScript](https://create.roblox.com/docs/en-us/reference/engine/classes/ModuleScript)) | returns the name of the song from a modulescript (the chart data basically) |
| closeScript : function(name : string) | Used to disable modcharts from running during a song (the name will be something like "modchart.lua") |
| receptChangeSkin : function(Receptor : integer, NoteSkinLabel : [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel), XML : [ModuleScript](https://create.roblox.com/docs/en-us/reference/engine/classes/ModuleScript)) | Changes the skin of the receptors |
| ChangeNoteSkin : function(noteSkinName : string, boolSide : boolean (false=dad, true=bf), force : boolean, mania : integer) | Changes the note skin (as well as the receptors) |
| Kill : function() | This just kills the player (make sure to check if the player has death enabled in settings before using it) |
| settings : Array | Contains a list of all the player's settings |
| PlayerObjects : [Character](#CharacterClass)[] | Contains a list of characters playing the song ("BF", "Dad", "BF2", "Dad2") |
| PositioningParts : Array | Contains a list of all the parts needed for setting up and handling the stage<br><br>Left: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Right: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Left2: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Right2: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Camera: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>isPlayer: [Player](https://create.roblox.com/docs/en-us/reference/engine/classes/Player)[]<br>Spot: Instance (it's the boombox)|
| PlayerStats : [PlayerStats](#PlayerStatsClass) | Contains a list of all the player's stats |
</details>

</details>

---

<details>
<summary><h2>Returned Modchart Functions</h2></summary>

#### Return Functions are vital for modcharts to work and are called at specific times.
	
- preInit = function(gameUI : [ScreenGui](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui), module : table)
	
```
This function is played before the song has started loadin
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
	
- P1NoteHit = function(noteType : string, noteData : integer, note : [Note](#NoteClass))
	
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
	
- sectionChange = function(currentSection : [Section](#SectionClass))

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
<summary><h2>Classes</h2></summary>

<br>
<details name="CharacterClass">
<summary>Character</summary>

## Description
A class that contains all the necessary info to animate a player model.
## Properties
| Name : Type | Description |
|-------------|-------------|
| BeatDancer : boolean | Beat dancers are characters that have 2 different idle animations that play back and forth |
| Obj : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | The actual rig of the character, which includes all the parts to the model. (This gets changed everytime the rig is changed) |
| EventHandler : [LocalScript](https://create.roblox.com/docs/en-us/reference/engine/classes/LocalScript) | Just the animator script of the player (do not ever change this value) |
| IsPlayer : boolean | A value that determines if the character is controlled by a player or not |
| Name : string | It is just the name of player who the animation is parent under. Could be used for modcharts |
| Animator : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | Do not change this value |
| (readOnly) StartCFrame : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame) | This is just for the starting CFrame of the character, but changing it after the character is made does nothing |
| Animations : Array | A table that contains all of the animations that the Character has loaded |
| Microphone : nil | DEPRECATED |
| (readOnly) CurrPlaying : string | The name of the currently playing animation |
| (readOnly) Holding : boolean | Whether or not the animation is continuously playing |
| (readOnly) HoldTimer : number | How long the animation will play for |
| (readOnly) AnimPlaying : boolean | Whether or not there is an animation playing currently |
| (readOnly) AnimName : string | The name of the animation set |

</details>

<details name="SectionClass">
<summary>Section</summary>

## Description
A class that stores specific information about a section. Such as if the camera focuses on BF or Dad, the notes, the length, and the type of section.
## Properties
| Name : Type | Description |
|-------------|-------------|
| mustHitSection : boolean | Value is true if the section is focused on BF and false if it is focused on Dad |
| typeOfSection : number | Determines the amount of beats per section, Default: 4 |
| lengthInSteps : number | Determines the length in steps that section is, Default: 16 |
| sectionNotes : [Note](#NoteClass)[] | Includes a list of notes for the current section |
</details>

<details name="PlayerStatsClass">
<summary>PlayerStats</summary>

## Description
A class that includes the stats of the player (score, health, etc.)
## Properties
| Name : Type | Description |
|-------------|-------------|
| Health : number | The current health of the player, default: 1 |
| DrainRate : number | The speed in seconds that health will drain |
| MaxHealth : number | The maximum health of the player, default: 2 |
| Score : number | The score of the player |
</details>

<details name="ReceptorClass">
<summary>Receptor</summary>

## Description
A class that contains the properties of a receptor (they are the arrows that align with the notes)
## Properties
| Name : Type | Description |
|-------------|-------------|
| Alpha : number | The alpha value of the receptor |
| X : number | The X position of the receptor |
| Y : number | The Y position of the receptor |
| DefaultX : number | The starting X position of the receptor |
| DefaultY : number | The starting Y position of the receptor |
| AnchorPoint : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The anchor position of the receptor |
| CanBePressed : boolean | Whether or not the receptor can be used/pressed |
| Index : number | the index of the receptor in the list of all the receptors |
| GetPosition : function() | Returns a Vector2 value with the X and Y position of the receptor |
| SetPosition : function(x : number, y : number) | Sets the position of the Receptor, if x or y value is nil then it will go to the default position |
| SetX : function(x : number) | Sets the X position of the Receptor |
| SetY : function(y : number) | Sets the Y position of the Receptor |
| TweenPosition : function(x : number, y : number, speed : number, easingStyle : [EasingStyle](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingStyle), easingDirection : [EasingDirection](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingDirection)) | Tweens the receptor's position to the new position |
| TweenX : function(x : number, speed : number, easingStyle : [EasingStyle](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingStyle), easingDirection : [EasingDirection](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingDirection)) | Only tweens the X position of the receptor |
| TweenY : function(y : number, speed : number, easingStyle : [EasingStyle](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingStyle), easingDirection : [EasingDirection](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingDirection)) | Only tweens the Y position of the receptor |
| TweenAlpha : function(endValue : number, speed : number, style : [EasingStyle](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingStyle), direction : [EasingDirection](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingDirection)) | Tweens the alpha of the receptor |
</details>

<details name="NoteClass">
<summary>Note</summary>

## Description
A class that contains the properties for notes to function
## Properties
| Name : Type | Description |
|-------------|-------------|
| StrumTime : number | The strum time that the note is at |
| shouldPress : boolean | Whether or not the player should press the note |
| MustPress : number | Whether or not the note is on the right or left side |
| NoteData : number | The value dictates the note's receptor lane |
| (readOnly) TooLate: boolean | Whether or not it is too late to hit the note (meaning it went past the receptor and the player will get a miss) |
| noAnimation: boolean | if true, whenever the note is pressed, the character will not play an animation |
| scrollDirection : string | The direction that the note will go in<br>Options: "Up", "Down", "Left", "Right" |
| CanBeHit : boolean | Whether or not the player can hit the note |
| (readOnly) GoodHit : boolean | Whether or not the player got a good hit on the note |
| PrevNote : [Note](#NoteClass)/nil | The note that came before (used for sustain notes) |
| SustainLength : number | The length of the sustain (if the note is a sustain note) |
| (readOnly) IsSustain: boolean/nil | Whether or not the note is a sustain note (value is nil if it is not) |
| (readOnly) IsSusEnd : boolean | Whether or not the note is the end of a sustain note |
| X : number | The X position of the note |
| Y : number | The Y position of the note |
| Offset : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The offset of the note |
| Scale : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The scale of the note |
| Size : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The size of the note |
| Score : number | The score that the note will give |
| NoteObject : [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel) | The GUI object that the note is set to |
| Sink : number | It changes the Size on the Y position, I am not entirely sure though |
| Mana : number | This variable is never used |
| (readOnly) NoteGroup : string | Lists whatever NoteGroup the note is using |
| ReceptorX : number | Changes the position of the note on the X axis |
| Type : string | Used in NoteGroups and would apply whatever note type the string is, the types are defined in the the "Note" ModuleScript in ReplicatedStorage > Modules |
| manualXOffset : number | DEPRECATED |
| HealthLoss: number | Determines how much heath the player will lose when the note is missed, if value is changed the note becomes a note that you have to hit to receive damage, which overrides the shouldPress property |
| Transparency : number | The current transparency of the note |
| DefaultTransparency : number | The starting transparency of the note |
| InitialPos : number | The intial position of the note which is determined by the strum time and not the actual position it currently is |
| HoldParent: boolean | Value is true if the note is a sustain (but it is not a sustain end) |
| RawData : table | The chart data of the note that is not processed |
| Hitbox: number | How large the hitbox for the note is, recommended to just to *= method to change how large or small the hitbox is rather than setting it to a specific value |
| HPGain : number | Determines how much health is gained when the note is hit, and is a shouldPress |
| GainOnSustains : boolean | Whether or not the player gains health while holding a sustain note, default: false |
| Classic : boolean | DEPRECATED |
| ScrollMultiplier : number | How fast or slow the note will move based on the scroll speed, default: 1 |
</details>

</details>

---

<details>
<summary><h2>Examples</h2></summary>
<br>

Example showcasing running and handling events
```lua
--!nolint UnknownGlobal
--!nolint UninitializedLocal
--local Conductor = require(game.ReplicatedStorage.Modules.Conductor) -- This doesn't need to be defined unless you need to know the stepCrochet or BPM and what not
--local timer = 0; -- If this is unused then get rid of it
return {
	-- This function is played after the countdown
	Start = function()
		gameHandler.processEvent("change scroll speed", 1.15, 2)
		-- Changes the scroll speed to 1.15x the song's scroll speed over the course of 2 seconds
	end,
	
	-- This function is played whenever an event is processed
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
