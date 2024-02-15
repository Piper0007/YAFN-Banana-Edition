### Adding Normal, Dead, and Winning Icons
You first need to go to (ReplicatedStorage -> Modules -> Icons) and inside of the script you will find a list of icons that list as such:
```lua
return {
	['BF'] = {
		NormalId = "", -- This should be the image id of either the entire icon set or just the one icon
		NormalDimensions = Vector2.new(150, 150); -- The standard size of a icon is 150x150 pixels
		DeadId = "",
		OffsetDead = Vector2.new(150, 0); -- the offset of the dead image (use only when the icons are in a set)
		DeadDimensions = Vector2.new(150, 150);

		-- Winning icons are rare but you may need them
		WinningId = "",
		OffsetWinning = Vector2.new(300, 0);
		WinningDimensions = Vector2.new(150, 150);

		-- For changing the color of the healthbar (its optional though)
		IconColor = Color3.new();

		-- If you have a pixelated icon and the image size is really small you might want to enable this
		IsPixelated = true;
	},
}

```
Once you have your icon, you apply it to a song by going to the chart and setting the value for player1 (left side) to the name of the icon or player2 (right side) to it instead.
For example:
```json
{
	"player1": "Dad",
	"player2": "BF"
}
```
