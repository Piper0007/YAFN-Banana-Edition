# Note

> Definition method
```lua
local Note = require(game.ReplicatedStorage.Modules.Note)
```

## Description
A class that contains the properties for notes to function<br>
The class also contains all of the properties of a [Sprite](Sprite.md)
## Properties
| Name : Type | Description |
|-------------|-------------|
| [new](#new) : function | A function used to construct a new ``Note`` (for people who make modcharts, this info is probably not needed) |
| [SetPosition](#SetPosition) : function | A function used to set the X and Y position of a singular note |
| [QueueReceptorSparrowXML](#QueueReceptorSparrowXML) : function | A function used to change specific notes to have specific textures (this is done automatically by ``GameHandler`` so do not use this) |
| Destroy: function | A function used to destroy a ``Note`` |
| [ApplyImageRect](#ApplyImageRect) : function | A function used to change the frame data of a singular note |
| FixSize : function | A function used to update the size data for a note |
| [PlayAnimation](#PlayAnimation) : function | A function used to play a animation for a note, [Sprite](Sprite.md) |
| [AddSparrowXML](#AddSparrowXML) : function | A function used to add XML data for a note, [Sprite](Sprite.md) |
| [ChangeSkin](#ChangeSkin) : function | A function used for changing the note skin of a ``Note`` |
| Update : function | __DO NOT USE__ A function used for updating the position, size, transparency, image, hitbox, and collision of the notes (``GameHandler`` does this automatically) |
| StrumTime : number | The strum time that the note is at |
| shouldPress : boolean | Whether or not the player should press the note |
| MustPress : number | Whether or not the note is on the right or left side |
| NoteData : number | The value dictates the note's receptor lane |
| (readOnly) TooLate: boolean | Whether or not it is too late to hit the note (meaning it went past the receptor and the player will get a miss) |
| noAnimation: boolean | if true, whenever the note is pressed, the character will not play an animation |
| scrollDirection : string | The direction that the note will go in<br>Options: "Up", "Down", "Left", "Right" |
| CanBeHit : boolean | Whether or not the player can hit the note |
| (readOnly) GoodHit : boolean | Whether or not the player got a good hit on the note |
| PrevNote : ``Note`` | Lists the previous note (used for sustain notes, otherwise returns ``nil``) |
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
| Type : string | Used in NoteGroups and would apply whatever note type the string is, the types are defined in the the "Note" ModuleScript in (ReplicatedStorage > Modules) |
| manualXOffset : number | DEPRECATED |
| HealthLoss: number | Determines how much health the player will lose when the note is missed, if value is changed the note becomes a note that you have to hit to receive damage, which overrides the shouldPress property |
| Transparency : number | The current transparency of the note |
| DefaultTransparency : number | The starting transparency of the note |
| InitialPos : number | The initial position of the note which is determined by the strum time and not the actual position it currently is |
| HoldParent: boolean | Value is true if the note is a sustain (but it is not a sustain end) |
| RawData : table | The chart data of the note that is not processed |
| Hitbox: number | How large the hitbox for the note is, recommended to just to *= method to change how large or small the hitbox is rather than setting it to a specific value |
| HPGain : number | Determines how much health is gained when the note is hit, and is a shouldPress |
| GainOnSustains : boolean | Whether or not the player gains health while holding a sustain note, default: false |
| Classic : boolean | DEPRECATED |
| ScrollMultiplier : number | How fast or slow the note will move based on the scroll speed, default: 1 |

# Functions
> Here is where all the previously mentioned functions will be explain in more depth (any functions not listed don't have any parameters)

<a name="new"></a>
## Note.new
<details><summary>Description</summary>

A function used to construct a new ``Note``
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| XMLModule : [ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) | The ``XML`` data that the note will use to play its animations |
| Object : [ImageLabel](https://create.roblox.com/docs/en-us/reference/engine/classes/ImageLabel) | The ``ImageLabel`` that the note will attach to |
| strumTime : number | The strum time of the note |
| rawData : table | The unchanged chart data that the note will use |
| mania : number | Describes which mania value the note will apply to |
| noteGroup : string | Describes which note group will be applied to the note |
| noteData : number | Describes which lane the note is in |
| previousNote : ``Note`` | The note that comes before the new one (if it is the first note or not a sustain note, then it is ``nil``) |
</details>

<a name="SetPosition"></a>
## Note:SetPosition
<details><summary>Description</summary>

A function used to set the X and Y position of a singular note
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| positionX : number | The X position to set the note to |
| positionY : number | The Y position to set the note to |
</details>

<a name="QueueReceptorSparrowXML"></a>
## Note:QueueReceptorSparrowXML
<details><summary>Description</summary>

A function used to change specific notes to have specific textures (this is done automatically by ``GameHandler`` so do not use this)
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| ImageId : [robloxassetid](https://create.roblox.com/docs/reference/engine/datatypes/Content) | The ``ImageID`` that the note will appear as |
| ... : any[] | The parameters may continue which describe [Sprite:AddSparrowXML](Sprite.md#AddSparrowXML) |
</details>

<a name="ApplyImageRect"></a>
## Note:ApplyImageRect
<details><summary>Description</summary>

A function used to change the frame data of a singular note
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| data : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2)[] | The first ``Vector2`` value changes the ``ImageRectSize`` property and the second changes the ``ImageRectOffset`` property |
</details>

<a name="PlayAnimation"></a>
## Note:PlayAnimation
<details><summary>Description</summary>

A function used to play a animation for a note, [Sprite](Sprite.md)
</details>
<details><summary>Parameters</summary>

> Follows the parameters of [Sprite:PlayAnimation](Sprite.md#PlayAnimation)

</details>

<a name="AddSparrowXML"></a>
## Note:AddSparrowXML
<details><summary>Description</summary>

A function used to add XML data for a note, [Sprite](Sprite.md)
</details>
<details><summary>Parameters</summary>

> Follows the parameters of [Sprite:AddSparrowXML](Sprite.md#AddSparrowXML)

</details>

<a name="ChangeSkin"></a>
## Note:ChangeSkin
<details><summary>Description</summary>

A function used for changing the note skin of a ``Note``
</details>
<details><summary>Parameters</summary>

> Listed in the same order that the parameters are defined

| Name : Type | Description |
|:------------|:-----------:|
| XMLModule : [ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) | The XML data that the note will use |
| TextureId : [robloxassetid](https://create.roblox.com/docs/reference/engine/datatypes/Content) | The image that the note will use |
</details>
