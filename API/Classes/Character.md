# Character

## Description
A class that contains all the necessary info to animate a player model.
## Properties
| Name : Type | Description |
|-------------|-------------|
| BeatDancer : boolean | Beat dancers are characters that have 2 different idle animations that play back and forth |
| Obj : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | The actual rig of the character, which includes all the parts to the model. (This gets changed every time the rig is changed) |
| EventHandler : [LocalScript](https://create.roblox.com/docs/en-us/reference/engine/classes/LocalScript) | Just the animator script of the player (do not ever change this value) |
| IsPlayer : boolean | A value that determines if the character is controlled by a player or not |
| Name : string | It is just the name of the player who the animation is parent under. Could be used for modcharts |
| Animator : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | Do not change this value |
| (readOnly) StartCFrame : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame) | This is just for the starting CFrame of the character, but changing it after the character is made does nothing |
| Animations : Array | A table that contains all of the animations that the Character has loaded |
| Microphone : nil | DEPRECATED |
| (readOnly) CurrPlaying : string | The name of the currently playing animation |
| (readOnly) Holding : boolean | Whether or not the animation is continuously playing |
| (readOnly) HoldTimer : number | How long the animation will play for |
| (readOnly) AnimPlaying : boolean | Whether or not there is an animation playing currently |
| (readOnly) AnimName : string | The name of the animation set |
