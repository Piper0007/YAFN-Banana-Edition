# API Guide
This document will explain how to properly use the documentation written in [Modchart](Modchart.md). Although I am writing these in a way that would be the easiest to understand, I want to make sure everyone understands without any issue.

## Reading Lists
In other documents I include lists that look like this:
| Name : Type | Description |
|-------------|-------------|
| flipMode : boolean | A boolean which tells if it's playing Dad side |

First off, where it says “Name : Type” it describes the name of the property and after the colon describes the data type of the property. So for the first property “flipMode” it has a data type named “boolean” which means it is either `true` or `false`. If the type is a link and if you go to that link, there will be a list of properties in either this format or in Roblox's format. Now, if the property itself has a link, then it is most likely a function because functions require a lot of explanation because they could have many parameters and varying return values.<br><br>
Okay, it is probably important to describe how certain properties will be written in modcharts. So... let's take a look at the “playerObjects” modchart variable, which contains a list of `Character`s:
| Name : Type | Description |
|-------------|-------------|
| Dad : [Character](Classes/Character.md) | Lists dad's character |

Now, if you were to open up the [Character](Classes/Character.md) link there would be a list of properties there as well. And to be specific, the “Dad” property contains all of the properties of `Character` and “Dad” is a property of “playerObjects”.

## Example
So if I were to write this in a modchart; to write a statement that makes the character play a animation, I would write:
```lua
playerObjects.Dad:PlayAnimation(“idle”, true)
```

Understandably, this could still be confusing so I will include a video tutorial here<br>
![VideoLink](insert-link-here)
