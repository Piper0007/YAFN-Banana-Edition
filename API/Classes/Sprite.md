# Sprite

## Description
A class that contains necessary information on the construction and playing of sprite sheets and sprites
## Properties
| Name : Type | Description |
|:------------|:-----------:|
| [new](#new) : function() | A function that is used to create a new sprite |
| [AddSparrowXML](#AddSparrowXML) : function() | A function that is used to add a new animation frame or set of frames from XML data |
| [Clone](#Clone) : function() | A function used to create a duplicate sprite, returns the new sprite |
| [ResetAnimation](#ResetAnimation) : function() | A function used to reset the size/position data of the sprite in case certain properties have changed |
| [PlayAnimation](#PlayAnimation) : function() | A function used to play a specified animation that was previously defined |
| [Destroy](#Destroy) : function() | A function used to remove the sprite and unload all of its data |
| [UpdateSize](#UpdateSize) : function() | A function that *only* updates the size of the sprite |
| [Update](#Update) : function() | DO NOT USE, this function is ran automatically whenever the :[PlayAnimation](#PlayAnimation)() method is used |
| GUI : [Instance](https://create.roblox.com/docs/reference/engine/datatypes/Instance) | Contains the GUI object that the sprite attaches to |
| Animations : table | Contains all of the loaded animation data |
| DefaultId : [robloxassetid](https://create.roblox.com/docs/reference/engine/datatypes/Content) | The default image id of the ImageLabel/Sprite |
| (readOnly) CurrAnimation : string | Describes the currently playing animation of the sprite |
| Alpha : number | The alpha value of the sprite (describes how opaque it is) |
| (readOnly) Factor : number | The scale factor of the sprite which describes how many times smaller or bigger it is |
| Visible : boolean | Whether or not the sprite is visible |
| FrameRate : number | Determines how quickly (in seconds) that the sprite changes frames |
| ChangeSize : boolean | Whether or not the sprite will change it's size based on the XML data |
| Size : {X: number, Y: number} | The size of the sprite (in pixels) |
| Scale : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The scale of the sprite |
| Offset : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The offset of the sprite (in pixels) |
| FrameOffset : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | The offset of the frame (changes each individual image offset in the spritesheet) |
| ClipRect : [Vector2](https://create.roblox.com/docs/en-us/reference/engine/datatypes/Vector2) | Determines the size of the individual image contained in the spritesheet |
| UseScale : boolean | Whether or not the sprite will use the scale of the ImageLabel or the scale of the XML data, default: false |
| ScaleFactors : {X: number, Y: number} | The scaling factor for both the X and Y axis |
| FlipHorizontally : boolean | Whether or not to flip the Image on the X axis |
| FlipVertically : boolean | Whether or not to flip the Image on the Y axis |
| (readOnly) AnimData : table | The raw, unfiltered data for the animations |
| (readOnly) _AnimationFinished : [Signal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | A signal used to fire a event whenever the animation finishes playing |
| AnimationFinished : [Signal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal).Event | A signal used to play functions whenever it __receives__ a signal that the animation finished playing |
| (readOnly) _AnimationLooped : [Signal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | A signal used to fire a event that the animation has looped |
| AnimationLooped : [Signal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal).Event | A signal used to play functions whenever it __receives__ a signal that the animation has looped |
| (readOnly) Finished : boolean | Describes whether or not the sprite is finished playing the animation |
| (readOnly) Timer : number | Describes the amount of time left until it changes frames |
| (readOnly) Frame : number | Describes the frame that the sprite is displaying |
| (readOnly) Clones : table | Contains a list of how many duplicate sprites exist |

# Functions 
>> This includes more detailed information on the previously mentioned functions

<a name="new"></a>
## Sprite.new()

<details>
    <summary>
    Description
    </summary>

> A function that is used to create a new sprite

</details>

<details>
<summary>Parameters</summary>

> Parameters are listed in the order that the function requires

| Name : Type | Description |
|:------------|:------------|
| guiObject : [ImageLabel](https://create.roblox.com/docs/reference/engine/classes/ImageLabel) | The gui object that the sprite will attach |
| changeSizeProperty : boolean | Whether or not the sprite will change size based on the frame data or the ImageLabel data |
| factor : number | look here to learn how to figure out the factor, [FactorGuide](https://github.com/Piper0007/YAFN-Banana-Edition/wiki/Getting-Scale-Factor) |
| useScale : boolean | Whether or not it will use the scale of "scaleFactors" or just use the default scale |
| scaleFactors : {X: number, Y: number} | Determines the scale of the ImageLabel (if you make the values the same as the width and height then the scale would be (1, 1)) |
</details>

<details>
<summary>Returns</summary>

Returns a [Sprite](#Sprite)
</details>

<a name="AddAnimation"></a>
## Sprite:AddAnimation()

<details>
    <summary>
    Description
    </summary>

> A function that is used to create a new sprite

</details>

<details>
<summary>Parameters</summary>

> Parameters are listed in the order that the function requires

| Name : Type | Description |
|:------------|:------------|
| name : string | Used to identify the name of the animation for later reference with ":[PlayAnimation](#PlayAnimation)()" |
| frames : [SpriteFrame](SpriteFrame.md)[] | (Optional) A list of SpriteFrames which would be used to define the individual frames within a sprite sheet |
| framerate : number | (Optional) The amount of times the frame will change per second |
| looped : boolean | (Optional) Whether or not the sprite will start over when it finishes |
| ImageId : [robloxassetid](https://create.roblox.com/docs/reference/engine/datatypes/Content) | (Optional) The image that the animation will use |
</details>

<details>
<summary>Returns</summary>

> Returns the animation that was created using the function

</details>

<a name="AddSparrowXML"></a>
## Sprite:AddSparrowXML()

<details>
    <summary>
    Description
    </summary>

> A function that is used to create a new animation with the use of XML data

</details>

<details>
<summary>Parameters</summary>

> Parameters are listed in the order that the function requires

| Name : Type | Description |
|:------------|:------------|
| XML : [ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) | The XML data that the sprite will use (a module script that returns the xml data as a string) |
| name : string | The name of the animation that would be used with ":[PlayAnimation](#PlayAnimation)()" |
| prefix : string | The prefix of the animation name like in "idle0000" where the numbers represent the frame and "idle" is the prefix |
| framerate : number | How many times per second the frame will change in the animation |
| looped : boolean | Whether or not the animation will loop |
| factor : number | The scale factor of the image, look here to learn how this number is found [FactorGuide](https://github.com/Piper0007/YAFN-Banana-Edition/wiki/Getting-Scale-Factor) |
</details>

<details>
<summary>Returns</summary>

> Returns the new animation that was created using the function

</details>

<a name="PlayAnimation"></a>
## Sprite:PlayAnimation()

<details>
    <summary>
    Description
    </summary>

> A function that is used to play an animation that was previously defined

</details>

<details>
<summary>Parameters</summary>

> Parameters are listed in the order that the function requires

| Name : Type | Description |
|:------------|:------------|
| name : string | The name of the animation to play |
| force : boolean | Whether or not it will play over an already playing animation |
</details>

<a name="Destroy"></a>
## Sprite:Destroy()

<details>
    <summary>
    Description
    </summary>

> A function that is used to delete itself

</details>

<a name="Clone"></a>
## Sprite:Clone()

<details>
    <summary>
    Description
    </summary>

> A function that is used to clone itself

</details>

<details>
<summary>Returns</summary>

> Returns a duplicated [Sprite](#Sprite)

</details>

<a name="ResetAnimation"></a>
## Sprite:ResetAnimation()

<details>
    <summary>
    Description
    </summary>

> A function that is used to reset the animation data

</details>

<a name="UpdateSize"></a>
## Sprite:UpdateSize()

<details>
    <summary>
    Description
    </summary>

> A function that is used to refresh the size and position data

</details>

<a name="Update"></a>
## Sprite:Update()

<details>
    <summary>
    Description
    </summary>

> __DO NOT__ use this function, it is ran automatically

</details>

<details>
<summary>Parameters</summary>

> Parameters are listed in the order that the function requires

| Name : Type | Description |
|:------------|:------------|
| dt : number | The amount of time that has elapsed since the last time [Heartbeat](https://create.roblox.com/docs/reference/engine/classes/RunService#Heartbeat) was ran |
</details>
