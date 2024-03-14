# SpriteFrame

## Description
This class contains properties used to apply properties to frames inside sprite sheets
## Properties
| Name : Type | Description |
|:------------|:-----------:|
| FrameSize : {X: number, Y: number} | Changes the size of the individual frame |
| Size : {X: number, Y: number} | Changes the scale of the image |
| frameOffset : [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Changes the offset of the individual frame |
| Offset : [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Changes the image’s offset |
## Examples

> Example showcasing defining a SpriteFrame with all of it’s properties (all properties are not required)
```lua
local frame = {
	FrameSize = {1600, 900}, -- The size of the frame is 1600 by 900 which is the resolution of a 900p image
	Size = {1280, 720}, -- The size is the width and the height of the sprite
	frameOffset = Vector2.new(5, 5), -- The frame will be viewed 5 pixels up and 5 pixels right
	Offset = Vector2.new(0, 0) -- Frame will not have a global offset
}
```
