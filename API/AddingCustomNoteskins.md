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
	['Tutorial'] = {
		Instrumental = 12578295484,
		Voices = 12578299885,
		NoteSkin = "Default",
		NoteSplashSkin = "noteSplashes"
	}
}
```
### Adding Note skins/splashes into Settings
If you want to add a certain note skin into settings you go to (ReplicatedStorage -> Modules -> Settings) and inside the script you want to find where it says:

![Image](https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/ca686df9-b3eb-4c18-86fd-e15502f1cfa9)
And inside of the list you will add or remove whatever note skins you like.
