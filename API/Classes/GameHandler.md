# GameHandler

> Definition method (GameHandler is already defined within modcharts)
```lua
local GameHandler = require(game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui').GameUI.GameHandler)
```

## Description
Contains all the functions/variables that affect the gameplay
## Properties
| Name : Type | Description |
|:------------|:-----------:|
| [changeIcon](#changeIcon) : function | Changes the icon for the selected side |
| [changeAnimation](#changeAnimation) : function | Changes the player's animation and appearance (depending on the animation type) |
| [flash](#flash) : function | Flashes the screen at the specified speed, color, and starting transparency (this function is used with the “camera flash” event) |
| [processEvent](#processEvent) : function | Runs an event through a processor that goes through all the known events and sends a signal to the EventTrigger if it is not already defined. For a list of all the events go to [Events](https://github.com/Piper0007/YAFN-Banana-Edition/blob/main/API/Events.md#defined-events) |
| [setProperty](#setProperty) : function | A function used to change the values of specific variables (that can't be accessed otherwise)<br> Options for "varName":<br>'defaultCamZoom', 'camGame.zoom', 'camZooming', 'songLength'|
| [getSongName](#getSongName) : function | returns the name of the song from a modulescript (the chart data basically) |
| [closeScript](#closeScript) : function | Used to disable modcharts from running during a song (the name will be something like "modchart.lua") |
| [receptChangeSkin](#receptChangeSkin) : function | Changes the skin of the receptors |
| [ChangeNoteSkin](#ChangeNoteSkin) : function | Changes the note skin (as well as the receptors) |
| Kill : function | This just kills the player (make sure to check if the player has death enabled in settings before using it) |
| settings : table | Contains a list of all the player's settings |
| PlayerObjects : [Character](Character.md){} | Contains a list of characters playing the song ("BF", "Dad", "BF2", "Dad2") |
| PositioningParts : table | Contains a list of all the parts needed for setting up and handling the stage<br><br>Left: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Right: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Left2: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Right2: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>Camera: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)<br>isPlayer: [Player](https://create.roblox.com/docs/en-us/reference/engine/classes/Player)[]<br>Spot: [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) (it's the boombox)|
| PlayerStats : [PlayerStats](PlayerStats.md) | Contains a list of all the player's stats |
</details>

# Functions
> Here is where functions would be described in more detail

<a name="changeIcon"></a>
## changeIcon
<details><summary>Description</summary>

Changes the icon for the selected side
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| name : string | The name of the icon, referenced from the ``Icons`` ModuleScript |
| side : boolean | Determines which side that the icon applies to, (false = "left side", true = "right side") |
</details>

<a name="changeAnimation"></a>
## changeAnimation
<details><summary>Description</summary>

Changes the player's animation and appearance (depending on the animation type)
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| name : string | The name of the animation |
| player : [Character](Character.md) | Determines which ``Character`` will be changed |
</details>

<a name="flash"></a>
## flash
<details><summary>Description</summary>

Flashes the screen at the specified speed, color, and starting transparency (this function is used with the “camera flash” event)
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| hexCode : string | The hex code that determines the color of the flash (example: "#FF0000") |
| speed : number | Determines how long the flash will last |
| initialTransparency : number | The transparency that the flash starts with |
</details>

<a name="processEvent"></a>
## processEvent
<details><summary>Description</summary>

Runs an event through a processor that goes through all the known events and sends a signal to the EventTrigger if it is not already defined. For a list of all the events go to [Events](https://github.com/Piper0007/YAFN-Banana-Edition/blob/main/API/Events.md)
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| eventName : string | The name of the event to be played, [list of events](https://github.com/Piper0007/YAFN-Banana-Edition/blob/main/API/Events.md#defined-events) |
| value1 : any | value1 can be anything, it's based on whatever event it is for |
| value2 : any | value2 can be anything, it's based on whatever event it is for |
| ... : any | It continues to a value3 and possibly a value4 (do not actually write "..." when using the function, it represents that more values can defined after) |
</details>
<details><summary>Returns</summary>

> Only returns under certain conditions

</details>

<a name="setProperty"></a>
## setProperty
<details><summary>Description</summary>

A function used to change the values of specific variables (that can't be accessed otherwise)<br>
Options for "variableName":<br>
| Name : Value | Description |
|:-------------|:-----------:|
| defaultCamZoom : number | (Default: 1) changes the FOV of the camera based on a multiplier |
| camZooming : boolean | Determines whether or not the camera will zoom in or out (but does not prevent zooming) |
| songLength : number | (Default: -1) Determines the "fake" length of the song, in seconds (it only affects the timebar) |
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| variableName : string | The name of the variable to change (options are described in the description) |
| value : any | The value to set the variable to |
</details>

<a name="getSongName"></a>
## getSongName
<details><summary>Description</summary>

A function used to get the name of the song that is currently playing
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| SongData : [ModuleScript](https://create.roblox.com/docs/en-us/reference/engine/classes/ModuleScript) | The "chart" or "SongData" that the function will return the name of |
</details>
<details><summary>Return : string</summary>

returns the name of the song from a ModuleScript (which is the chart data)
</details>

<a name="closeScript"></a>
## closeScript
<details><summary>Description</summary>

Used to disable modcharts from running during a song (the name will be something like "modchart.lua")
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| name : string | The name of the script to stop (example: "modchart.lua") |
</details>

<a name="receptChangeSkin"></a>
## receptChangeSkin
<details><summary>Description</summary>

Changes the skin of the receptors
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| Receptor : number | The index or lane number for the receptor to change |
| NoteSkinLabel : [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel) | The ``ImageLabel`` that the noteskin will use |
| XML : [ModuleScript](https://create.roblox.com/docs/en-us/reference/engine/classes/ModuleScript) | The XML data that the receptor will use |
</details>

<a name="ChangeNoteSkin"></a>
## ChangeNoteSkin
<details><summary>Description</summary>

Changes the note skin (as well as the receptors)
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| noteSkinName : string | The name of ``NoteSkin`` that the notes will use |
| boolSide : boolean | Whether or not the noteskin would apply to the left or right side (false = "left side", true = "right side") |
| force : boolean | Whether or not to force the selected mania |
| mania : number | (Experimental) The mania value to turn the notes to (force needs to be true in order to work) |
</details>
