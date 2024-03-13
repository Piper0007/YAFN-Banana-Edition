# SongIDs

<details>
<summary><h2>What is this?</h2></summary>

SongIDs is a module script located in "ReplicatedStorage" that defines the song variables that go with every song.<br>
This is required when adding new songs as it requires the Instrumental sounds to be defined here.
</details>

<details>
<summary><h2>How should it look?</h2></summary>

Each songId follows a strict format in order for the game to find and retrieve the data for each song.<br><br>
It would look something like this:
```lua
	["songName"] = {
		Instrumental = soundID;
	};
```
</details>

<details>
<summary><h2>List of all variables</h2></summary>
  
````lua
["songName"] = {
	Instrumental = 0; -- Required (if you want you can combine both the voices and instrumental into one audio file)
	Voices = 0; -- If the chart has ‘“needsVoices”: true’ then the voices would be required 
	Offset = 0; -- (Optional) Applies an offset (in milliseconds) to the chart
	EventOffset = 0; -- (Optional) Applies an offset to the events
	BFAnimations = _; -- (Optional) Set Boyfriends animation
	BF2Animations = _; -- (Optional) Adds a secondary Boyfriend with said animation
	DadAnimations = _; -- (Optional) Set Dads animation
	Dad2Animations = _; -- (Optional) Adds a secondary Dad with said animation
	AnimOffsets = { -- (Optional) Defines the CFrame offset for (BF, DAD, BF2, DAD2) all the CFrames do not have to be defined.
		CFrame.new(),
		CFrame.new(),
		CFrame.new(),
		CFrame.new()
	};
	NoteGroup = ''; -- (Optional) Defines which notegroup to use inside of the NoteGroups folder
	NoteSkin = ''; -- (Optional) Sets the noteskin for the song
	NoteSplashSkin = ''; -- (Optional) Sets the notesplash skin for the song
	Script = ''; -- (Optional) Option to change the script that the song will use [Uses scripts from modcharts folder]
	defaultCamZoom = 0; -- (Optional) changes the default zoom/FOV of the camera when the song starts
	mapProps = ''; -- (Optional) Adds the map to the game using the name of the map in the ReplicatedStorage.Maps Folder
	ClockTime = 0; -- (Optional) Sets the time of day
	hideProps = boolean; -- (Optional) Tells whether or not to hide props in the map
	hideBox = boolean; -- (Optional) Hides all boomboxes
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
};
````
</details>

