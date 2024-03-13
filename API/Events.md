# Events

<details>

<summary><h2>Defined Events</h2></summary>

These events when processed would work without any extra work on your end.<br>
In a modchart, you would just do:
```lua
gameHandler.processEvent(eventName, value1, value2)
```
(just replace the variables with the actual values)

| "eventName" | Description | Values |
|-----------------|-------------|--------|
| "set camera zoom" | sets the camera's zoom to value1 and sets the hud's zoom to value2 | value1 : number<br>value2 : number |
| "tween camera zoom" | the target camera zoom is set to value1<br>length of the tween is set to value2<br>value3 is the [EasingStyle](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingStyle) but is not required<br>value4 is the [EasingDirection](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingDirection) but is not required either<br>A tween is returned in case somebody wants to do something with it inside a modchart | value1 : number<br>value2 : number<br>value3 : [EasingStyle](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingStyle)<br>value4 : [EasingDirection](https://create.roblox.com/docs/en-us/reference/engine/enums/EasingDirection) |
| "add camera zoom" | This event is ignored until "CameraZooms" setting is not enabled<br>hudZoom value is added by value1 or 0.03<br>camZoom is added by value2 or 0.015  | value1 : number<br>value2 : number |
| "camera follow pos" | Changes the properties of "camControls.camOffset"<br>x position is set to value1<br>y position is set to value2<br>z position is ignored | value1 : number<br>value2 : number |
| "set cam speed" | The camera's speed is set to value1<br>camSpeed determines how fast the camera moves, default: 1 | value1 : number |
| "camera flash" | Only functions if the distractions setting is enabled<br>value1 determines how fast the camera flashes<br>value2 controls the color by being a hex code. Something like "#FF0000" | value1 : number<br>value2 : string/nil |
| "screen shake" | There are two different ways that you can use this event:<br>Either value1 controls the duration and value2 controls the intensity<br>Or, value1 contains 2 numbers and is a string separated by a comma like '0.05, 0.1' and controls the duration and intensity of the screen shake<br>And value2 is the same as value1 but it controls the UI shake | value1 : number/string<br>value2 : number/string |
| "hey!" | Plays the "hey" animation for a character<br>value1 determines which character plays the animation by being their name, ("BF", "Dad") | value1 : string |
| "lane modifier" | Changes the lane's note speed<br>value1 determines which lane is being changed<br>value2 controls the scroll speed (multiplier) | value1 : integer<br>value2 : number |
| "change scroll speed" | Only functions when "ForceSpeed" setting is enabled<br>Changes the scroll speed of all the notes<br>value1 represents the speed of the scrolling (it is a multiplier)<br>value2 represents the duration or speed that the scroll will change at (it if is less than or equal to 0 it will happen instantly) | value1 : number<br> value2 : number |
</details>

<details>
<summary><h2>How to add Events</h2></summary>

Events will automatically apply when the events for the song is inside the module script that contains notes.<br>
However, if you want to import the events file you should make a module script named "events" inside the individual song folder.<br>
Reminder, all of this will be located in "ReplicatedStorage > Modules > Songs".

![SongInfo](https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/8f7e16bb-7a35-4c2e-b6bd-cce2a2da53c4)
</details>
