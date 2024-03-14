# Character

## Description
A class that contains all the necessary info to animate a player model.
## Properties
| Name : Type | Description |
|-------------|-------------|
| new : function() | A function that creates a new [Character](#Character) |
| flipDir : function() | A function that swaps the "singRIGHT" and "singLEFT" animations with each other |
| MoveMic : function() | (DEPRECATED) A function that swaps the microphone from one hand to the other |
| Dance : function() | A function that plays either the idle animation or the beat dancer idle animations (depending on if the character is a beat dancer) |
| Destroy : function() | A function that is used to destroy itself |
| AddAnimation : function() | A function that is used to add a new animation |
| IsSinging : function() | Returns true or false depending on if the Character is playing an animation |
| GetCurrentSingAnim : function() | Returns the currently playing animation as a string |
| Update : function() | __DO NOT USE__, a function that handles the holding animation and updates character data |
| PlayAnimation : function() | A function that is used to play a previously defined animation |
| ToggleAnimatorScript : function() | __DO NOT USE__, a function that is used to disable the default Roblox animator script that spawns with every new character |
| GetAnimationTrack : function() | Returns the [Animation](https://create.roblox.com/docs/reference/engine/classes/Animation) track that is given |
| AnimLoaded : function() | Returns true or false whether or not the provided animation id is already loaded |
| BeatDancer : boolean | Beat dancers are characters that have 2 different idle animations that play back and forth |
| Obj : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | The actual rig of the character, which includes all the parts to the model. (This gets changed every time the rig is changed) |
| EventHandler : [LocalScript](https://create.roblox.com/docs/en-us/reference/engine/classes/LocalScript) | Just the animator script of the player (do not ever change this value) |
| IsPlayer : boolean | A value that determines if the character is controlled by a player or not |
| Name : string | It is just the name of the player who the animation is parent under. Could be used for modcharts |
| Animator : [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance) | Do not change this value |
| (readOnly) StartCFrame : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame) | This is just for the starting CFrame of the character, but changing it after the character is made does nothing |
| Animations : table | A table that contains all of the animations that the Character has loaded |
| Microphone : nil | DEPRECATED |
| (readOnly) CurrPlaying : string | The name of the currently playing animation |
| (readOnly) Holding : boolean | Whether or not the animation is continuously playing |
| (readOnly) HoldTimer : number | How long the animation will play for |
| (readOnly) AnimPlaying : boolean | Whether or not there is an animation playing currently |
| (readOnly) AnimName : string | The name of the animation set |
