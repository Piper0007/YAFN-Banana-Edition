# SongInfo

<details>
<summary><h2>What is it?</h2></summary>

Song Info is a module script inside of modules that you would use to change the appearance of the mod selection UI.

This is where you would add the credits for the mod.

There is also a background you can change and it could have a variety of designs. (Custom made as well)
![image_2023-08-22_155521980](https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/24346082-93d2-4e12-99fe-1495803f5f04)

You can also change the font, transparency, text size, text stroke color, text color, and everything else that can be changed about a text label. 
</details>

<details>
<summary><h2>How to use it</h2></summary>

You will find this module inside of (ReplicatedStorage > Modules > SongInfo).

The first thing you could change is "Mod Order"[^1] which arranges all the mods in a specific order. However, this is not required and auto sorts.

Next, each mod listed will have a specific format that it follows, and it should look like this:
![image_2023-08-22_160237343](https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/fb6ac533-ed8e-46f1-962e-0e7d569c6760)

Where it says "Vs. FNAF 2" is the name of the mod.
On the same line of "Description" is where you would add the list of people who made the mod.

SongOrder is the order in which the songs will be displayed.

If you add an item that starts with "OBJPR_" and add any property (of a Text Label) after the underscore, it would apply that for the GUI Object.
Example:
```lua
["OBJPR_Font"] = Enum.Font.Arial;
```
This would change the font of the mod text.<br>

Another one to note is "BGImage" which stands for Background Image.<br>

If you want to make your custom Background Images you need to make an image that is (45, 45) pixels and should look similar to a texture image just like this:

![Circles](https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/8f3a2c7a-2bae-4cf8-b613-ffccf9a43638)

I added more functionality for the backgrounds stuff and added a customizations folder that you can find in (StarterGui > GameUI > SongPickUI > ModBackgrounds)<br>
You can access them in songInfo by adding something called "BGType" and setting it to the name of the background.

[^1]: "Mod Order" is a list at the top of SongInfo that specifies how all the mods will be ordered (from top to bottom)
</details>
