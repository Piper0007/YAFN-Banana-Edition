# SongIDs

<details><summary><h2>What is this?</h2></summary>

SongIDs is a module script located in “ReplicatedStorage" that defines the song's properties that go with every song (every song in the game is included in SongIDs).<br><br>
This is required when adding new songs as it requires the Instrumental sounds to be defined here.
</details>

<details><summary><h2>How should it look?</h2></summary>

Each songId follows a strict format in order for the game to find and retrieve the data for each song.<br><br>
It would look something like this:
```lua
["songName"] = {
	Instrumental = soundID;
};
```

However for the entire SongIDs script, it should look like this:
```lua
return {
    ["Example1"] = {
        Instrumental = 123456789;
    };
    
    ["Example2"] = {
        Instrumental = 234578901;
    };
}
```
</details>

<details><summary><h2>List of all variables</h2></summary>

> This is the format
````lua
[“ExampleSong”] = {
	Instrumental = 0; -- Required (if you want you can combine both the voices and instrumental into one audio file)
	Voices = 0; -- If the chart has ‘“needsVoices”: true’ then the voices would be required 
	Offset = 0; -- (Optional) Applies an offset (in milliseconds) to the chart
	EventOffset = 0; -- (Optional) Applies an offset to the events
	BFAnimations = "BF"; -- (Optional) Set Boyfriends animation
	BF2Animations = "BF"; -- (Optional) Adds a secondary Boyfriend with said animation
	DadAnimations = "Dad"; -- (Optional) Set Dads animation
	Dad2Animations = "Dad"; -- (Optional) Adds a secondary Dad with said animation
	AnimOffsets = { -- (Optional) Defines the CFrame offset for (BF, DAD, BF2, DAD2) all the CFrames do not have to be defined.
		CFrame.new(),
		CFrame.new(),
		CFrame.new(),
		CFrame.new()
	};
	NoteGroup = 'Default'; -- (Optional) Defines which notegroup to use inside of the NoteGroups folder
	NoteSkin = 'Default'; -- (Optional) Sets the noteskin for the song
	NoteSplashSkin = ''; -- (Optional) Sets the notesplash skin for the song
	Script = 'Default'; -- (Optional) Option to change the script that the song will use [Uses scripts from modcharts folder]
	defaultCamZoom = 0; -- (Optional) changes the default zoom/FOV of the camera when the song starts
	mapProps = ''; -- (Optional) Adds the map to the game using the name of the map in the ReplicatedStorage.Maps Folder
	ClockTime = 6.5; -- (Optional) Sets the time of day
	hideProps = false; -- (Optional) Tells whether or not to hide props in the map
	hideBox = false; -- (Optional) Hides all boomboxes
	PreloadSounds = { -- (Optional) Plays the sound at a very low volume so that the game forces it to load
		"rbxassetid://" -- sound id
	};
	PreloadImages = { -- (Optional) Prechaches images for the song
		"rbxassetid://" -- image id
	};
	countdownImages = { -- (Optional) you could just make it equal false for it to be nothing
		0; -- image of 3
		0; -- image of the 2
		0; -- image of the 1
		0; -- image of the go!
	};
	IntroSounds = { -- (Optional) Changes the sounds for the countdown
		"rbxassetid://"; -- Voice for 3 -- If you want there to be silence just make it blank like ""
		"rbxassetid://"; -- Voice for 2
		"rbxassetid://"; -- Voice for 1
		"rbxassetid://"; -- Voice for Go
	};
	RatingSet = { -- (Optional) Changes the images for the ratings
		sick="rbxassetid://10849280164",
		good="rbxassetid://10849281330",
		bad="rbxassetid://10849282992",
		trash="rbxassetid://10849284734"
	};
````

> This is the more in-depth explanation

| Name : Type | Description |
|:------------|:-----------:|
| Instrumental : number | (Required) defines the audio id for the instrumental of the song |
| Voices : number | defines the audio id for the voices of the song |
| Offset : number | The offset (in milliseconds) that will apply to the “song” and not the chart (what it does is change when the song starts playing, old charts will usually have a 100 millisecond delay) |
| EventOffset : number | The offset (in milliseconds) that will be applied to all events |
| BFAnimations : string | The name of the animation that will apply to the bf character |
| DadAnimations : string | THe name of the animation that will apply to the dad character |
| BF2Animations : string | The name of the animation that will apply to the second bf character (defining this value will make the second bf character spawn) |
| Dad2Animations : string | The name of the animation that will apply to the second dad character (defining this value will make the second dad character spawn) |
| AnimOffsets : [CFrame](https://create.roblox.com/docs/en-us/reference/engine/datatypes/CFrame)[] | A list of offsets that will apply to these characters in this order: “BF”, “Dad”, “BF2”, “Dad2” |
| NoteGroup : string | The name of the NoteGroup which will apply for the song.<br>Located under (ReplicatedStorage > Modules > NoteGroups) |
| NoteSkin : string | The name of the note skin which will apply for the song |
| NoteSplashSkin : string | The name of the note splash that will apply for the song |
| Script : string | The name of the “Modchart” that the song will use<br>Modcharts are located in (ReplicatedStorage > Modules > Modcharts) |
| defaultCamZoom : number | The default camera zoom that the song will use.<br>If the value is greater than 1 then it is zoomed in and if it is less than 1 it would be zoomed out |
| mapProps : string | The name of the map that will be used for the song.<br>located in (ReplicatedStorage > Modules > Maps) |
| ClockTime : number | Applies a custom time-of-day for the specific song<br>default: 6.5 |
| hideProps : boolean | Whether or not to hide the props for the map |
| hideBox : boolean | Whether or not to hide the boombox |
| PreloadSounds : string[] | A list of `robloxassetid`s that will be preloaded so that the sounds will play instantly rather than waiting to be loaded first |
| PreloadImages : string[] | A list of `robloxassetid`s that will be preloaded so that the images will show up instantly rather than having to load while the song is playing |
| countdownImages : number[] | A list of asset ids that are used to change the images that appear for “3”, “2”, “1”, “GO” that appear at the beginning of a song |
| IntroSounds : string[] | A list of `robloxassetid`s that are used to change the sounds that play for “3”, “2”, “1”, “GO” at the beginning of the song |
| RatingSet : {sick: string, good: string, bad: string, trash: string} | A table that contains a list of `robloxassetid`s that are used to change the default Rating images just for that particular song |
</details>
