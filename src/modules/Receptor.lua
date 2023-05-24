local SpriteClass = require(game.ReplicatedStorage.Modules.Sprite);
local Receptor = setmetatable({},SpriteClass)
Receptor.__index=Receptor;
local cam = workspace.CurrentCamera
local defaultScreenSize = Vector2.new(1280,720)
local TS = game:GetService("TweenService")

function Receptor.new(...)
	local sprite = SpriteClass.new(...);
	sprite.Alpha = 1;
	sprite.X = 0;
	sprite.Y = 0;
	sprite.DefaultX=0;
	sprite.DefaultY=0;
	sprite.AnchorPoint = Vector2.new(.5,0)
	sprite.CanBePressed = true;
	sprite.Index = 0;
	return setmetatable(sprite,Receptor)
end


function Receptor:GetPosition()
	return Vector2.new(self.X,self.Y)
end

function Receptor:SetPosition(x,y)
	if type(x) ~= "number" then
		x = self.DefaultX
		--warn("X Value is invalid! using default")
	end
	if type(y) ~= "number" then
		y = self.DefaultY
		--warn("Y Value is invalid! using default")
	end
	self.X = x;
	self.Y = y;
	self.GUI.Position =UDim2.new(
		(x * (shared.autoSize * shared.handler.settings.customSize))/shared.noteScaleRatio.X,0,
		y/defaultScreenSize.Y, 0--(shared.handler.settings.Downscroll and -self.GUI.AbsoluteSize.Y/2 or self.GUI.AbsoluteSize.Y)
	)
end
function Receptor:TweenPosition(x,y,speed,easingStyle,easingDirection)
	if type(x) ~= "number" then
		x = self.DefaultX
		--warn("X Value is invalid! using default")
	end
	if type(y) ~= "number" then
		y = self.DefaultY
		--warn("Y Value is invalid! using default")
	end
	self.X = x;
	self.Y = y;
	self.GUI:TweenPosition(UDim2.new(
		(x * (shared.autoSize * shared.handler.settings.customSize))/shared.noteScaleRatio.X,0,
		y/defaultScreenSize.Y, 0),easingDirection,easingStyle,speed)
end

function Receptor:SetX(x)
	if type(x) ~= "number" then
		x = self.DefaultX
		--warn("X Value is invalid! using default")
	end
	self.X = x;
	self.GUI.Position =UDim2.new(
		(x * (shared.autoSize * shared.handler.settings.customSize))/shared.noteScaleRatio.X,0,
		self.Y/defaultScreenSize.Y, 0--(shared.handler.settings.Downscroll and -self.GUI.AbsoluteSize.Y/2 or self.GUI.AbsoluteSize.Y)
	)
end
function Receptor:SetY(y)
	if type(y) ~= "number" then
		y = self.DefaultY
		--warn("X Value is invalid! using default")
	end
	self.Y = y;
	self.GUI.Position =UDim2.new(
		(self.X * (shared.autoSize * shared.handler.settings.customSize))/shared.noteScaleRatio.X,0,
		y/defaultScreenSize.Y, 0--(shared.handler.settings.Downscroll and -self.GUI.AbsoluteSize.Y/2 or self.GUI.AbsoluteSize.Y)
	)
end

function Receptor:TweenX(x,speed,easingStyle,easingDirection)
	if type(x) ~= "number" then
		x = self.DefaultX
		--warn("X Value is invalid! using default")
	end
	self.X = x;
	self.GUI:TweenPosition(UDim2.new(
		(x * (shared.autoSize * shared.handler.settings.customSize))/shared.noteScaleRatio.X,0,
		self.Y/defaultScreenSize.Y, 0),easingDirection,easingStyle,speed)
end

function Receptor:TweenY(y,speed,easingStyle,easingDirection)
	if type(y) ~= "number" then
		y = self.DefaultY
		--warn("Y Value is invalid! using default")
	end
	self.Y = y;
	self.GUI:TweenPosition(UDim2.new(
		(self.X * (shared.autoSize * shared.handler.settings.customSize))/shared.noteScaleRatio.X,0,
		y/defaultScreenSize.Y, 0),easingDirection,easingStyle,speed)
end

function Receptor:TweenAlpha(endvalue,speed,style,direction)
	endvalue=math.abs(endvalue-1)
	if style == nil then
		style = "Linear"
	end
	if direction == nil then
		direction = "InOut"
	end
	local TweenInformation = TweenInfo.new(speed or 0.1, Enum.EasingStyle[style], Enum.EasingDirection[direction])
	local Tween = TS:Create(self.GUI, TweenInformation, {ImageTransparency = endvalue})
	Tween:Play()
	Tween.Completed:Connect(function()
		self.Alpha = endvalue+1
	end)
end

-- Maybe a TweenSize???

return Receptor;