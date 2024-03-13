# Receptor

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
