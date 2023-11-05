# What is this?

This is a module script that you can find in (ReplicatedStorage -> Modules -> ModchartHelper)
What this is for essenstially is to help you visually see your options when creating modcharts.


# Okay, But How Do I Use It?

Well it is quite simple to use really, all you need to do is go to whatever modchart that you are working on.
Then at the top or anywhere really, you "require" the module like this:
```lua
local helper = require(game.ReplicatedStorage.Modules.ModchartHelper)

return {
	preStart = function()
		-- Here you would type in 'helper.' and it will list off what you can do
		-- And once you have made your modchart you can remove the modchart helper from your modchart
	end,
}
```

Whenever you type in "helper" followed by a "." you will see this:

https://github.com/Piper0007/YAFN-Banana-Edition/assets/110263550/b8343528-060b-4bad-a32e-ce4e4aee5374

Anyways, I hope this helps people out. Especially people who are new to modcharting, which really need it.
