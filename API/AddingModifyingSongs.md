## Adding/Modifying Songs
If you want to add songs to the game then there are a couple of places that you need to go in Roblox Studio.
### Adding the Chart
First off, to add the chart to the game, you create a New Folder and name it after the class or “Mod” that the songs falls under; the folder is then placed in (ReplicatedStorage -> Modules -> Songs). Within the folder you need to add a New Folder named after the specific song (the name of the song must stay the same wherever it is referenced). Inside of the folder you will need to make a new Module Script instance and name it after whatever difficulty you choose (e.g. "Easy", "Normal", and "Hard"). Next, inside of the Module Script you need to write "return [==[   ]==]" and in between the space you paste the chart for the song (supported chart types are "Psych Engine" and "Kade Engine"). Finally, inside the chart data you need to find the line that says ‘ “song”: ‘ (the shortcut to find text is Ctrl + F) and the song will be set to a value which will be the name of the song, I suggest changing it to the same name for the song.
#### Adding Custom Difficulties
To add custom difficulties you need to go (StarterGui -> GameUI -> UIHandler) and around the top of the script you need to find where it says this:
```lua
local DifficultyList = {
	"Easy",
	"Normal",
	"Hard",
	-- Add whatever difficulty name you want in this list
};

-- defines the stroke color of the difficulty
local DifficultyColor = {
	Easy = Color3.new(0, 1, 0); -- This color is green
	Normal = Color3.new(1, 1, 0); -- This color is orange
	Hard = Color3.new(1, 0, 0); -- This color is red
	-- If you have a difficulty with a special name you would use " ['Diff Name'] " instead
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
#### Locking Songs
To make a song “Locked” means that you are preventing anybody (including the owner of the game) from playing the song, while still being able to view it in the list of songs. To do this you need to go to your specific song’s folder found under (ReplicatedStorage > Songs) and then click on the song’s folder, for example, “Tutorial”. Once you have clicked on the folder you should scroll down in the properties view tab to the bottom where it says add attribute; that is where you add an attribute with the type “boolean” and name it “Locked”. Finally you can check and uncheck the checkbox to make the song locked and unlocked.
#### Adding Warning to Songs
Adding warnings to songs requires you to going to the song you want in (ReplicatedStorage > Songs) and for the specific song, you click on the folder and add a boolean attribute named either “JP”, “UN”, “LC”, “FL”, “NS”, “CP”. Now each of these names will display their own warning (so you can have more than one warning per song):
JP: “This song contains jumpscares”
UN: “This song is unfinished or unoptimized”
LC: “This song contains a lack of mobile/console support”
FL: “This song contains flashing lights”
NS: “This song contains no sound”
CP: “This song is copyrighted”
If you would like to change how the warnings are displayed or add new warnings, or even change the system entirely (this was made by the original YAFN team, not by me) you can find the script that handles it under (StarterGui > GameUI > UIHandler)

### Adding the Song (+metadata)
The script that handles applying properties to the songs is a Module Script named SongIDs and is located in ReplicatedStorage. Inside the script each song is given a table that includes all of the info/metadata the song will use. Additionally the script follows this format:
```lua
return {
	[ [song name goes here] ] = {
		Instrumental = [insert number of the id], -- Do not forget to add a semicolon or a comma at the end of each line (within the list) this is just basic coding stuff but some people need to be explained this
		Voices = [insert number of the id],
	} -- also at the end of each curly bracket must be a comma as well because it is within a list as well
}
```
Here’s a working example just in case the formatting was a bit confusing
```lua
return {
	["Tutorial"] = {
		Instrumental = 12578295484,
		Voices = 12578299885
	},
}
```
There are more things you can do in SongIDs but here is a link that explains it in more detail [SongIDs](SongIDs.md). When importing the ids for the songs make sure that there isn’t a red flag next to it meaning that it was moderated and denied.
### Adding Modcharts/Events
When adding a modchart, there are 2 ways to add it to a song. First method (old method) involves you going to (ReplicatedStorage -> Modules -> Modcharts) and you just simply add a Module Script and name it after the song you want to apply it to. Second method involves you going under the song’s folder which is where you put the difficulty for the song. Under the song’s folder you add a Module Script and name it whatever but at the end of the name you must include “.lua”, e.g. “SuperCoolThingy.lua”. Here is some info about [Modcharts](Modchart.md).

Next, for adding events you go to where the song’s folder is located (I mean the folder that has the song’s name not the one named “Songs”) and make a Module Script under it named “events”. Inside the script you do basically the same thing as for adding the chart just without the need of changing the song name. Now remember, custom events exist in most “Mods” and will most likely not be supported by the engine (doesn’t mean it never will or can be). If you want to make it work you must make a modchart that handles it (involves the “EventTrigger” function) or you change how the engine works which is not recommended. More about [Events](Events.md).
