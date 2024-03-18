# Character
> Definition method

```lua
local Character = require(game.ReplicatedStorage.Modules.Character)
```

## Special Thanks (Credits)
I (Piper0007) did not entirely write this script on my own. What I did was take the original Character script from the YAFN engine and combined it with Minz's script that was made for a different engine. I am specifically crediting Minz because without their script I wouldn't have been able to make this *improved* Character script.

## Description
A class that contains all the necessary info to animate a player model<br><br>
Additionally, the name of the `animation` is mentioned many times throughout this document and to clarify, it refers to the folders located under (ReplicatedStorage > Animations > CharacterAnims) or (ReplicatedStorage > Animations > SongsAnim).
## Properties
| Name : Type | Description |
|-------------|-------------|
| [new](#new) : function | A function that creates a new ``Character`` |
| [SetCF](#SetCF) : function | (Function is redundant) A function that is used to change the position of a character.<br>Use `Character.Obj:PivotTo()` instead |
| [PreloadAnim](#PreloadAnim) : function | (Animations are not actually preloaded) just preloads the Rig |
| [ChangeAnim](#ChangeAnim) : function | A function used to change the animation (and character, potentially) of a `Character` |
| [PreloadRig](#PreloadRig) : function | Preloads the Rig/Model of a `Character` so that the loading times are quicker |
| [LoadRig](#LoadRig) : function | Applies the Rig onto a `Character` (if Rig is not preloaded then it is loaded) |
| [flipDir](#flipDir) : function | A function that swaps the "singRIGHT" and "singLEFT" animations with each other |
| [MoveMic](#MoveMic) : function | (DEPRECATED) A function that swaps the microphone from one hand to the other |
| [Dance](#Dance) : function | A function that plays either the idle animation or the beat dancer idle animations (depending on if the character is a beat dancer) |
| Destroy : function | A function that is used to destroy itself |
| [AddAnimation](#AddAnimation) : function | A function that is used to add a new animation |
| IsSinging : function | Returns true or false depending on if the Character is playing an animation |
| [GetCurrentSingAnim](#GetCurrentSingAnim) : function | Returns the currently playing animation as a string |
| Update : function | __DO NOT USE__, a function that handles the holding animation and updates character data |
| [PlayAnimation](#PlayAnimation) : function | A function that is used to play a previously defined animation |
| [ToggleAnimatorScript](#ToggleAnimatorScript) : function | __DO NOT USE__, a function that is used to disable the default Roblox animator script that spawns with every new character |
| GetAnimationTrack : function | Returns the [Animation](https://create.roblox.com/docs/reference/engine/classes/Animation) track that is given |
| [AnimLoaded](#AnimLoaded) : function | Returns true or false whether or not the provided animation id is already loaded |
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

# Functions

<a name="new"></a>
## Character.new
<details><summary>Description</summary>

A function that creates a new ``Character``
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| charName : string | This would be the name of the animation like "Dad" (not the name of the character |
| cf : [CFrame](https://create.roblox.com/docs/reference/engine/datatypes/CFrame) | The ``CFrame`` value for which the new ``Character`` will spawn |
| isPlayer : [Player](https://create.roblox.com/docs/reference/engine/classes/Player) | The ``Player`` that the character will spawn as (if no real player will control it then this value can be ``nil``) |
| animTable : table | |
| animName : string | |
| speedModifier : number | |
| humanoidDescription : [HumanoidDescription](https://create.roblox.com/docs/reference/engine/classes/HumanoidDescription) | |
| otherPlayer : [Player](https://create.roblox.com/docs/reference/engine/classes/Player) | |
</details>

<a name="SetCF"></a>
## Character:SetCF
<details><summary>Description</summary>

(Function is redundant) A function that is used to change the position of a character.<br>Use `Character.Obj:PivotTo(CFrame)` instead
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| cf : [CFrame](https://create.roblox.com/docs/reference/engine/datatypes/CFrame) | The position to set the character to |
</details>

<a name="PreloadAnim"></a>
## Character:PreloadAnim
<details><summary>Description</summary>

Just preloads the Rig (may be changed to preload animations as well in the future)
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| anim : string | The name of the animation to preload |
| speed : number | The speed of that the animation will be, default: 1 |
</details>

<a name="ChangeAnim"></a>
## Character:ChangeAnim
<details><summary>Description</summary>

A function used to change the animation (and character, potentially) of a `Character`
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| anim : string | The name of the animation |
| speed : number | The speed that the animation will play at, default: 1 |
</details>

<a name="PreloadRig"></a>
## Character:PreloadRig
<details><summary>Description</summary>

Preloads the Rig/Model of a `Character` so that the loading times are quicker.<br><br>
What it actually does is create the Rig and parent it under a WorldModel contained in `ServerStorage`.
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| animData : [Instance](https://create.roblox.com/docs/reference/engine/datatypes/Instance) | The actual instance (the folder) that contains the animations |
</details>

<a name="LoadRig"></a>
## Character:LoadRig
<details><summary>Description</summary>

Applies the Rig onto the `Character` (if the Rig is not preloaded then it is loaded)
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| anim : [Instance](https://create.roblox.com/docs/reference/engine/datatypes/Instance) | The folder of the animation to load |
</details>

<a name="flipDir"></a>
## Character:flipDir
<details><summary>Description</summary>

A function that swaps the "singRIGHT" and "singLEFT" animations with each other<br><br>
This is done automatically with "Dad" animations
</details>

<a name="Dance"></a>
## Character:Dance
<details><summary>Description</summary>

A function that plays either the idle animation or the beat dancer idle animations (depending on if the character is a beat dancer)<br><br>
This is done automatically by `GameHandler`
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| id : number/string | The animation id for the animation to play |
| speed : number | The speed that the animation will play at, default: 1 |
| looped : boolean | Whether or not the animation will continuously play |
| priority : [AnimationPriority](https://create.roblox.com/docs/reference/engine/enums/AnimationPriority) | (Optional) The priority of the track |
| preload : boolean | Whether or not the animation will not apply immediately, default: false |
</details>

<a name="AddAnimation"></a>
## Character:AddAnimation
<details><summary>Description</summary>

A function that is used to add a new animation
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| name : string | The name of the animation to add<br><br>Set of default animation names: "idle", "singDOWN", "singLEFT", "singRIGHT", "singUP" |
| id : number/string | The animation id for the animation to play |
| speed : number | The speed that the animation will play at, default: 1 |
| looped : boolean | Whether or not the animation will continuously play |
| priority : [AnimationPriority](https://create.roblox.com/docs/reference/engine/enums/AnimationPriority) | (Optional) The priority of the track |
| preload : boolean | (Optional) Whether or not the animation will not apply immediately, default: false |
</details>

<a name="GetCurrentSingAnim"></a>
## Character:GetCurrentSingAnim
<details><summary>Description</summary>

Returns the currently playing animation as a string
</details>
<details><summary>Return</summary>

> [AnimationTrack](https://create.roblox.com/docs/reference/engine/classes/AnimationTrack)<br>

Returns the animation track that is playing
</details>

<a name="PlayAnimation"></a>
## Character:PlayAnimation
<details><summary>Description</summary>

A function that is used to play a previously defined animation
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| name : string | The name of the animation to play |
| force : boolean | Whether or not the animation will play over a currently playing animation |
| looped : boolean | Whether or not the animation will continuously play |
</details>

<a name="AnimLoaded"></a>
## Character:AnimLoaded
<details><summary>Description</summary>

A function used to determine whether or not a specific animation is loaded for the `Character`
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| id : string | The content id (the string of numbers after "rbxassetid://") of the animation |
</details>
<details><summary>Return</summary>

> boolean

Returns `true` or `false` depending on if the animation is loaded for the `Character`
</details>

<a name="ToggleAnimatorScript"></a>
## Character:ToggleAnimatorScript
<details><summary>Description</summary>

__DO NOT USE__, a function that is used to disable the default Roblox animator script that spawns with every new character
</details>
<details><summary>Parameters</summary>

> All parameters are listed in the order that they are defined

| Name : Type | Description |
|:------------|:-----------:|
| bool : boolean | Whether or not to disable the script |
</details>
