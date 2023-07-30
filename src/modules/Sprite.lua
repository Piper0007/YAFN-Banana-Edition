local Image = {}
Image.__index=Image
Image.Images={}
local XML = require(script.Parent.XML)
local Signal = require(script.Parent.Signal)

function AddPosV2(gui,v2)
	gui.Position = UDim2.new(
		gui.Position.X.Scale,
		gui.Position.X.Offset+v2.X,
		gui.Position.Y.Scale,
		gui.Position.Y.Offset+v2.Y
	)	
end

function Image.new(guiObject,changeSizeProperty,factor,useScale,scaleFactors)
	local AnimationFinishedSignal=Signal();
	local AnimationLoopedSignal=Signal();
	local Img={
		GUI=guiObject;
		Animations={};
		DefaultId = nil;
		CurrAnimation='';
		Timer=0;
		Frame=1;
		Alpha=1;
		Factor=factor or 1;
		Clones={};
		Visible=true;
		FrameRate=60;
		ChangeSize=changeSizeProperty or true;
		Size={X=0,Y=0};
		Scale=Vector2.new(1,1);
		Offset=Vector2.new();
		FrameOffset=Vector2.new();
		ClipRect=Vector2.new();
		Finished=false;
		UseScale=useScale or false;
		ScaleFactors=scaleFactors or nil;
		FlipHorizontally=false;
		FlipVertically=false;
		AnimData={};
		_AnimationFinished=AnimationFinishedSignal;
		AnimationFinished=AnimationFinishedSignal.Event;
		_AnimationLooped=AnimationLoopedSignal;
		AnimationLooped=AnimationLoopedSignal.Event;
	}
	setmetatable(Img,Image)
	Img:AddAnimation("default",{{
		Size=guiObject.ImageRectSize;
		Offset=guiObject.ImageRectOffset;
	}})
	Img:PlayAnimation("default")
	table.insert(Image.Images,Img)

	return Img
end

function Image:AddAnimation(name,frames,framerate,looped,ImageId)
	self.Animations[name]={
		Frames=frames or {};
		Looped=looped;
		FrameRate=framerate or 30;
		ImageId = ImageId or self.GUI.Image;
	}
	return self.Animations[name]
end
local warnDebounce = {}
local dataCache = {}
function Image:AddSparrowXML(xmlData,name,prefix,framerate,looped,factor)
	local factor = factor or self.Factor
	local data = dataCache[xmlData] or XML.parse(require(xmlData),true)
	--print(dataCache[xmlData.Name] and "Found cache" or "No cache.")
	if dataCache[xmlData] == nil then
		dataCache[xmlData] = data
	end
	local frames = {}
	for _,v in next, data.children[1].children do
		if(v.tag=='SubTexture' and v.attrs.name:sub(1,#prefix)==prefix)then
			local props = v.attrs
			local offset = Vector2.new(
				tonumber(props.x)/factor,
				tonumber(props.y)/factor
			)
			local size = Vector2.new(
				tonumber(props.width)/factor,
				tonumber(props.height)/factor
			)
			local frameSize = Vector2.new(
				tonumber(props.width),
				tonumber(props.height)
			);
			local frameOffset
			if (props.frameX and props.frameY) and (props.frameWidth and props.frameHeight) then
				frameOffset = Vector2.new(
					(tonumber(props.frameX) or 0)/(factor/3) + (tonumber(props.frameWidth)/factor)
					, -- i honestly don't know how did this work
					(tonumber(props.frameY) or 0)/(factor/3) + (tonumber(props.frameHeight)/factor)
				)
			else
				frameOffset = Vector2.new()	
			end
			table.insert(frames,{
				Offset=offset,
				Size=size,
				FrameSize=frameSize,
				frameOffset=frameOffset
			})
		end
	end
	if #frames == 0 and not table.find(warnDebounce,name) then
		--warn(("%s is empty! (prefix:\"%s\")"):format(name,prefix))
		warnDebounce[#warnDebounce + 1] = name
	end--]]
	return self:AddAnimation(name,frames,framerate,looped)
end

function Image:Clone()
	-- this clones copies everythin!
	local a=table.clone(self)
	a.GUI=self.GUI:Clone()
	a.GUI.Parent=self.GUI.Parent
	table.insert(self.Clones,a)
	return a
end

function Image:ResetAnimation()
	self.Finished=false
	self.Frame=1;
	self.Timer=0;
	local frame= self.AnimData.Frames[1]
	self.GUI.ImageRectSize=frame.Size * Vector2.new(self.FlipHorizontally and -1 or 1,self.FlipVertically and -1 or 1)
	self.GUI.ImageRectOffset=frame.Offset + Vector2.new(self.FlipHorizontally and frame.Size.X or 0,self.FlipVertically and frame.Size.Y or 0)
	--self:UpdateOffset()
	self.FrameOffset = (frame.frameOffset and (frame.frameOffset * self.Scale) or Vector2.new())
	self.Offset = frame.Offset
	if(frame.FrameSize)then
		self.Size = {
			X=frame.FrameSize.X;
			Y=frame.FrameSize.Y;
		}
		self:UpdateSize()
	end
end

function Image:PlayAnimation(name,force)
	if(not self.Animations[name])then warn(name .. " is not a valid animation"); return end
	if self.Animations[name].ImageId and self.Animations[name].ImageId ~= self.GUI.Image then
		self.GUI.Image = self.Animations[name].ImageId
	end
	if((self.CurrAnimation~=name or force) and self.Animations[name])then
		self.AnimData=self.Animations[name]
		self.FrameRate=self.Animations[name].FrameRate
		self.CurrAnimation=name
		self:ResetAnimation()
	end
end

function Image:Destroy()
	self.Destroyed=true;
	for i = #Image.Images,1,-1 do
		if(Image.Images[i]==self)then
			table.remove(Image.Images,i)
			break
		end
	end
	for _,clones in self.Clones do
		pcall(game.Destroy,clones.GUI)
		for i,v in next, clones do clones[i]=nil end
	end
	pcall(game.Destroy,self.GUI)
	for i,v in next, self do self[i]=nil end
end

function Image:UpdateSize()
	if(self.ChangeSize)then
		if(self.GUI and self.GUI.Parent)then
			local frame = self.AnimData.Frames[self.Frame]
			if(self.UseScale)then
				self.GUI.Size = UDim2.new((frame.FrameSize.X*self.Scale.X)/(self.ScaleFactors or self.GUI.Parent.AbsoluteSize).X,0,(frame.FrameSize.Y*self.Scale.Y)/(self.ScaleFactors or self.GUI.Parent.AbsoluteSize).Y,0)
			else
				self.GUI.Size = UDim2.new(0,frame.FrameSize.X*self.Scale.X,0,frame.FrameSize.Y*self.Scale.Y)
			end
		end
	end
end

function Image:Update(dt)
	if(not self.Finished)then
		self.Timer += dt
		while self.Timer>1/self.FrameRate do
			self.Timer-=1/self.FrameRate
			self.Frame+=1
			if(self.Frame>=#self.AnimData.Frames)then
				if(self.AnimData.Looped)then
					self._AnimationLooped:Fire(self.CurrAnimation)
					self.Frame=1
				else
					self.Frame=#self.AnimData.Frames
					self._AnimationFinished:Fire(self.CurrAnimation)
					self.Finished=true
				end
			end
			local frame = self.AnimData.Frames[self.Frame]
			if(frame.FrameSize)then
				self.Size = {
					X=frame.FrameSize.X;
					Y=frame.FrameSize.Y;
				}
				if(self.ChangeSize)then
					self:UpdateSize()
				end
			end
			self.FrameOffset = ((frame.frameOffset or Vector2.new()) * self.Scale)
			self.GUI.ImageRectSize=frame.Size * Vector2.new(self.FlipHorizontally and -1 or 1,self.FlipVertically and -1 or 1)
			self.GUI.ImageRectOffset=frame.Offset + Vector2.new(self.FlipHorizontally and frame.Size.X or 0,self.FlipVertically and frame.Size.Y or 0)
		end
		for _,clone in pairs(self.Clones) do
			clone.FrameOffset = self.FrameOffset
			clone.GUI.ImageRectSize=self.GUI.ImageRectSize
			clone.GUI.ImageRectOffset=self.GUI.ImageRectOffset
			clone.GUI.ScaleType = self.GUI.ScaleType -- this is bc yafn uses crop instead of stretch which is why changing sprite size looks ugly
		end
	end
	if(self.Visible)then
		self.GUI.ImageTransparency=1-self.Alpha;
	else
		self.GUI.ImageTransparency=1;
	end
end

game:GetService("RunService").Heartbeat:Connect(function(dt)
	for i,v in next,Image.Images do
		if(v.GUI.Parent and v.GUI and not v.Destroyed)then
			v:Update(dt)
		end
	end
end)

return Image