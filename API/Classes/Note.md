# Note

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
| PrevNote : [Note](Note.md)/nil | The note that came before (used for sustain notes) |
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
