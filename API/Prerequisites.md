# Prerequisites
When first launching the engine on Roblox Studio, you need to go into “Game Settings” and enable API services as well as force the character to be R6. Also the saving system will not work until the game is published, so you can publish it as a private game or however you like. Lastly, I highly recommend that you open the view tab and open the Output Log (it displays important info that lets you know if something is broken or not).

Because Roblox is just amazing, most of or even all the sounds in the game may not load. This is because Roblox pushed out an update that revised the way that you can upload audio to solve the copyright issue. So, for each game you make you must upload new audio files for that game specifically. For now though, you will have to just upload your own audio files. [How to Upload Audio Files](https://en.help.roblox.com/hc/en-us/articles/203314070-Audio-Files).
## Adding Animations
When making an animation for the right side of a stage it must be turned 180 degrees (by rotating the torso on the Y axis). Once the animation(s) are made they need to be put inside a New Folder located under (ReplicatedStorage -> Animations -> CharacterAnims) and named after what the animation will be called as. Under the folder, there needs to be Animation instances created named “Idle, SingLeft, SingRight, SingUp, SingDown” and change the property “AnimationId” to whatever id is for the animation(s) that were created. As a heads up, if the animation is for a character on the left side the animations “SingLeft” and “SingRight” are swapped.

Now, for adding models or rigs or just R15 characters you need to go to (ReplicatedStorage -> Characters) inside of it you will put the model inside and name it whatever. Lastly, on the folder named after the animation there needs to be a attribute added with the type "string", name "CharacterName", and the value should be the name of the model inside of the Characters folder that you want. If you made an R15 animation then the there should be another attribute added with the name "R15", type "boolean", and make sure the checkbox is checked. Also, the model needs to be R15 as well.
## Adding/Modifying Songs
If you want to add songs to the game then there are a couple of places that you need to go in Roblox Studio.
### Adding the Chart
First off, to add the chart to the game, you create a New Folder and name it after the class or “Mod” that the songs falls under; the folder is then placed in (ReplicatedStorage -> Modules -> Songs). Within the folder you need to add a New Folder named after the specific song (the name of the song must stay the same wherever it is referenced). Inside of the folder you will need to make a new Module Script instance and name it after whatever difficulty you choose (e.g. “Easy”, “Normal”, and “Hard”). Next, inside of the Module Script you need to write “return [==[   ]==]” and in between the space you paste the chart for the song (supported chart types are “Psych Engine” and “Kade Engine”). Finally, inside the chart data you need to find the line that says ‘ “song”: ‘ (the shortcut to find text is Ctrl + F) and the song will be set to a value which will be the name of the song, I suggest changing it to the same name for the song.
#### Adding Custom Difficulties
To add custom difficulties you need to go (StarterGui -> GameUI -> UIHandler) and around the top of the script you need to find where it says this:
```lua
local DifficultyList = {
	“Easy”,
	“Normal”,
	“Hard”,
	-- Add whatever difficulty name you want in this list
};

-- defines the stroke color of the difficulty
local DifficultyColor = {
	Easy = Color3.new(0, 1, 0); -- This color is green
	Normal = Color3.new(1, 1, 0); -- This color is orange
	Hard = Color3.new(1, 0, 0); -- This color is red
	-- If you have a difficulty with a special name you would use “ [‘Diff Name’] “ instead
};

-- defines the text color of the difficulty
local DifficultyColor2 = {
	Hard = Color3.new(0, 0, 0); -- This color is black
	-- leave it blank if you want the stroke color to be default
};

-- defines the text’s font
local DifficultyFont = {
	Hard = Enum.Font.Cartoon;
	-- leave it blank if you want the font to be default
}
```
Once you have added the difficulty then you would be able to set any song to the difficulty.

### Adding the Song (+metadata)
The script that handles applying properties to the songs is a Module Script named SongIDs and is located in ReplicatedStorage. Inside the script each song is given a table that includes all of the info/metadata the song will use. Additionally the script follows this format:
```lua
return {
	[ [song name goes here] ] = {
		Instrumental = [ insert number of the id ], -- Do not forget to add a semicolon or a comma at the end of each line (within the list) this is just basic coding stuff but some people need to be explained this
		Voices = [ insert number of the id ],
	} -- also at the end of each curly bracket must be a comma as well because it is within a list as well
}
```
Here’s a working example just in case the formatting was a bit confusing
```lua
return {
	[“Tutorial”] = {
		Instrumental = 12578295484,
		Voices = 12578299885
	},
}
```
There are more things you can do in SongIDs but here is a link that explains it in more detail [SongIDs](SongIDs.md). When importing the ids for the songs make sure that there isn’t a red flag next to it meaning that it was moderated and denied.
### Adding Modcharts/Events
When adding a modchart, there are 2 ways to add it to a song. First method (old method) involves you going to (ReplicatedStorage -> Modules -> Modcharts) and you just simply add a Module Script and name it after the song you want to apply it to. Second method involves you going under the song’s folder which is where you put the difficulty for the song. Under the song’s folder you add a Module Script and name it whatever but at the end of the name you must include “.lua”, e.g. “SuperCoolThingy.lua”. Here is some info about [Modcharts](Modchart.md).

Next, for adding events you go to where the song’s folder is located (I mean the folder that has the song’s name not the one named “Songs”) and make a Module Script under it named “events”. Inside the script you do basically the same thing as for adding the chart just without the need of changing the song name. Now remember, custom events exist in most “Mods” and will most likely not be supported by the engine (doesn’t mean it never will or can be). If you want to make it work you must make a modchart that handles it (involves the “EventTrigger” function) or you change how the engine works which is not recommended. More about [Events](Events.md).
## Adding Custom Noteskins/Notesplashes [Add to API]
First off, you must upload the noteskin or notesplash you want to Roblox Studio, it must be in spritesheet form. After that, you go to (ReplicatedStorage -> Modules -> Images -> Assets -> noteSkins_K) and duplicate the Image Label named “Original”. Next, you rename the Image Label to whatever you want the noteskin to be called and change the property called “Image” to the image id of the note skin/splash you uploaded. Now, there will be a Module Script under the noteskin named “XML” and inside of it you will include the xml data for said noteskin. This is sort of the format you would want to follow:
```lua
return [[==[   ]==]]
```
Now I will mention that a lot of xml files are different from one another and a lot of times they will use different names which will cause the engine to crash and burn. I will include the list of valid names here [XML data in depth](no link yet). Last thing, note splashes are the same story. Just put the note splash images under the same folder and name make the start of the name “noteSplashes” followed by whatever name, or put it under whatever Noteskin you want the note splashes to go with.
### Assigning Noteskins/splashes
To assign them you need to go to (ReplicatedStorage -> SongIDs) and within that script you go to the part of the list for the song you want and add this:
```lua
return {
	[‘Tutorial’] = {
		Instrumental = 12578295484,
		Voices = 12578299885,
		NoteSkin = “Default”,
		NoteSplashSkin = “noteSplashes”
	}
}
```
### Adding Note skins/splashes into Settings
If you want to add a certain note skin into settings you go to (ReplicatedStorage -> Modules -> Settings) and inside the script you want to find where it says:

![Image](https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/ca686df9-b3eb-4c18-86fd-e15502f1cfa9)
And inside of the list you will add or remove whatever note skins you like.
