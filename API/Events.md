# Events

<details>

<summary>
Defined Events
</summary>

These events when processed would work without any extra work on your end

### set camera zoom
```LiveScript
camera zoom sets to value 1 (camera zoom doesnt do anything anymore because it is redundant)
camera hudZoom is set to value 2
```

### tween camera zoom
```LiveScript
target camera zoom is set to value 1.
legnth of the tween is value 2.
value 3 is not needed but changes the tweens EasingStyle (Enum.EasingStyle)
value 4 is not needed either but changes the EasingDirection (Enum.EasingDirection)
The tween is also returned so that it could be changed inside of the modchart
```

### add camera zoom
```LiveScript
This event is ignored when CameraZooms setting is set to false
hudZoom is added by value 1 or 0.03
camZoom is added by value 2 or 0.015
```

### camera follow pos
```LiveScript
camControls.camOffset is set to (value 1, value 2, 0)
x value is set to value 1
y value is set to value 2
z value is ignored because FNF is 2D and is not needed
```

### set cam speed
```LiveScript
sets the camera speed to value 1
camSpeed changes how fast the camera moves
```

### camera flash
```LiveScript
This is ignored if distractions are disabled
value 1 controls how fast the flash flashes
value 2 is a string value that should be a hex code. Something like "#FFFFFF"
```

### screen shake
```LiveScript
This event can be interperted in two different ways.
Either value 1 controls duration and value 2 controls the intensity
Or value 1 is a string value separated by a comma like '0.05, 0.1' and controls the duration and intensity of the sceen shake
And value 2 is a string value separated by a comma like '0.05, 0.1' and controls the duration and intensity of the UI shake
```

### hey!
```LiveScript
Currently it only plays Boyfriends animation named "hey" when value 1 is either "boyfriend", "bf", or "0"
Value 1 is the name of the character that dances
```

### lane modifier
```LiveScript
Change the arrows speed in a specific lane of notes
value 1 is the lane in which the arrows will change speeds
value 2 is the new speed that the arrows will go in. This speed value is a multiplier not a scroll speed value
```

### change scroll speed
```LiveScript
This is ignored when ForceSpeed is true
This event changes the scroll speed of all the notes
Value 1 is the new speed at which the scroll will be (it is a multiplier not an exact scroll speed value)
Value 2 is the duration or speed at which the scroll changes speed (if it is less than or equal to 0 it will happen instantly)
```
</details>


