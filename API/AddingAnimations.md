## Adding Animations
When making an animation for the right side of a stage it must be turned 180 degrees (by rotating the torso on the Y axis). Once the animation(s) are made they need to be put inside a New Folder located under (ReplicatedStorage -> Animations -> CharacterAnims) and named after what the animation will be called as. Under the folder, there needs to be Animation instances created named “Idle, SingLeft, SingRight, SingUp, SingDown” and change the property “AnimationId” to whatever id is for the animation(s) that were created. As a heads up, if the animation is for a character on the left side the animations “SingLeft” and “SingRight” are swapped.

Now, for adding models or rigs or just R15 characters you need to go to (ReplicatedStorage -> Characters) inside of it you will put the model inside and name it whatever. Lastly, on the folder named after the animation there needs to be a attribute added with the type "string", name "CharacterName", and the value should be the name of the model inside of the Characters folder that you want. If you made an R15 animation then the there should be another attribute added with the name "R15", type "boolean", and make sure the checkbox is checked. Also, the model needs to be R15 as well.
### Adding Animations to a Song
To add a specific animation to a song you need to go to (ReplicatedStorage -> SongIDs) and in there go to the song that you want and add this code to it:
```lua
BFAnimations = " Name Of Animation ",
DadAnimations = " Name Of Animation ",

-- Optional

BF2Animations = " Name Of Animation ", -- this is for when you want a second character standing next to the first BF
Dad2Animations = " Name Of Animation ", -- Same thing just on the other side of the stage
```
More info on [SongIDs](SongIDs.md)
