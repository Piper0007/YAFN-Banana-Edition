local Character = {}
local Updater = require(script.Parent.Updater)
local Switch = require(script.Parent.Switch)
local Sprite = require(script.Parent.Sprite)
local Conductor = require(script.Parent.Conductor)
Character.__index=Character

function Character.new(char,cf,isPlayer,animTable,animName,MicrophoneName, speedModifier)	
	if(char=='bf-christmas')then char='bf'end
	if(char=='bf-car')then char='bf'end
	if(char=='mom-car')then char='mom'end
	if(char=='monster-christmas')then char='monster'end
	local obj
	local AnimatorScript
	if isPlayer then
		obj = isPlayer.Character
		AnimatorScript = isPlayer.Character:FindFirstChild("Animate",10)
	else
		obj = (game.ReplicatedStorage.Characters:FindFirstChild(char) or game.ReplicatedStorage.Characters.opponent):Clone()
		obj.Parent=game.ReplicatedStorage
	end
	local charObj={
		BeatDancer=false;
		Obj=obj;
		EventHandler = obj:FindFirstChild("AnimationHandler",true);
		IsPlayer=isPlayer;
		Name=obj.Name;
		Animator=obj:FindFirstChild("Animator",true);
		MicPositions = animTable.MicPositioning;
		Animations={};
		Microphone=nil;
		CurrPlaying='';
		Holding=false;
		HoldTimer=0;
		AnimPlaying=false;
		AnimName = animName;
		AnimatorScript = AnimatorScript;
	}
	char = charObj.Obj.Name;
	setmetatable(charObj,Character)
	if(animTable.DanceLeft and animTable.DanceRight)then
		charObj.BeatDancer=true;
		charObj:AddAnimation("danceLeft",animTable["DanceLeft"],speedModifier,true,Enum.AnimationPriority.Idle)
		charObj:AddAnimation("danceRight",animTable["DanceRight"],speedModifier,true,Enum.AnimationPriority.Idle)
	else
		charObj:AddAnimation("idle",animTable["Idle"],speedModifier,true,Enum.AnimationPriority.Idle)
	end
	charObj:AddAnimation("singDOWN",animTable["SingDown"],speedModifier,false,Enum.AnimationPriority.Movement)
	charObj:AddAnimation("singLEFT",animTable["SingLeft"],speedModifier,false,Enum.AnimationPriority.Movement)
	charObj:AddAnimation("singRIGHT",animTable["SingRight"],speedModifier,false,Enum.AnimationPriority.Movement)
	charObj:AddAnimation("singUP",animTable["SingUp"],speedModifier,false,Enum.AnimationPriority.Movement)

	for name,id in next, animTable do
		if((typeof(id)=='number' or tonumber(id)) and not charObj:AnimLoaded(id))then
			charObj:AddAnimation(string.lower(name),id,speedModifier,false,Enum.AnimationPriority.Movement)
		end
	end
	obj:SetPrimaryPartCFrame(cf * animTable.Offset)
	if isPlayer then obj.HumanoidRootPart.CFrame = cf * animTable.Offset end
	if animTable.MicPositioning ~= nil then
		local Mic = game:GetService("ReplicatedStorage").Assets.Microphones:FindFirstChild(MicrophoneName or "Default") or game:GetService("ReplicatedStorage").Assets.Microphones.Default
		Mic = Mic:Clone()
		local micWeld = Instance.new("Weld")
		if typeof(animTable.MicPositioning) == "Instance" then
			micWeld.Part0 = animTable.MicPositioning
		elseif typeof(animTable.MicPositioning) == "boolean" then
			micWeld.C0 = CFrame.new(0, -1, -0.4) * CFrame.fromEulerAnglesXYZ(0,math.rad(0),0)
			print(obj.Humanoid.RigType)
			if obj.Humanoid.RigType == Enum.HumanoidRigType.R15 then
				micWeld.Part0 = animTable.MicPositioning and obj["RightLowerArm"] or obj["LeftLowerArm"]
			else
				micWeld.Part0 = animTable.MicPositioning and obj["Right Arm"] or obj["Left Arm"]
			end
		else
			micWeld.C0 = CFrame.new(0, -1, -0.4) * CFrame.fromEulerAnglesXYZ(0,math.rad(0),0)
			if obj:FindFirstChild('Right Arm') then micWeld.Part0 = obj["Right Arm"] end
		end
		micWeld.Part1 = Mic.Handle
		micWeld.Name = "HandleWeld"
		micWeld.Parent = Mic
		Mic.Parent = obj
		charObj.Microphone = Mic
	end

	Updater:Add(charObj)
	charObj:PlayAnimation("idle")
	return charObj
end

function Character:flipDir()
	local right = self.Animations.singLEFT
	self.Animations.singLEFT=self.Animations.singRIGHT
	self.Animations.singRIGHT=right
end

function Character:MoveMic(value:bool|BasePart|number)
	if not self.Microphone then return end
	if type(value) == "boolean" then
		-- true = right, false = left
		self.Microphone.HandleWeld.Part0 = value and self.Obj["Right Arm"] or self.Obj["Left Arm"]
		self.Microphone.Handle.Transparency = 0
	elseif type(value) == "number" then
		if value == 1 then
			self.Microphone.Handle.Transparency = 1
		else
			self.Microphone.Handle.Transparency = 0
		end
	elseif typeof(value) == "Instance" and value:IsA("BasePart") then
		self.Microphone.HandleWeld.Part0 = value
		self.Microphone.Handle.Transparency = 0
	end
end

function Character:Dance(...)
	local args={...}
	if(self.BeatDancer)then
		self.Danced=not self.Danced
		self:PlayAnimation(self.Danced and 'danceLeft' or 'danceRight',unpack(args))
	else
		self:PlayAnimation("idle",unpack(args))
	end
end

function Character:Destroy()
	if self.Microphone then self.Microphone = self.Microphone:Destroy() end
	for _,Track in next,self.Animator:GetPlayingAnimationTracks() do
		Track:Stop(0)
	end
	if self.IsPlayer then
		self:ToggleAnimatorScript(true)
		self.Obj = nil
		return 
	end
	Updater:Destroy(self)
	self.Obj:Destroy()
end

function Character:AddAnimation(name,id,speed,looped,priority,StoppedFunc)
	local anim = Instance.new("Animation")
	if typeof(id) == "string" then
		if string.find(id,"rbxassetid") or string.len(id) > 30 then
			anim.AnimationId= (id)
		else 
			anim.AnimationId= ('rbxassetid://' .. id)
		end 
	else 
		anim.AnimationId= ('rbxassetid://' .. id)
	end
	--warn(anim.AnimationId)
	print(name, id)
	local track = self.Animator:LoadAnimation(anim)
	track.Name=name;
	track.Looped=looped or false
	track.Priority=priority or track.Priority
	track:SetAttribute("Speed",speed or 1)
	track:SetAttribute("Playing",false)
	track:SetAttribute("Priority",track.Priority.Value)
	self.Animations[name]=track;
	track.Stopped:Connect(function()
		track:SetAttribute("Playing",false)
		if(track.TimePosition==track.Length)then
			track:AdjustSpeed(0)
			track:Play(0,0,0)
			track.TimePosition = 0
		end
	end)
	return track
end

function Character:IsSinging()
	for n,v in next, self.Animations do
		if(n:sub(1,4):lower()=='sing' and v:GetAttribute("Playing"))then
			return true
		end
	end
	return false
end

function Character:GetCurrentSingAnim()
	for n,v in next, self.Animations do
		if(n:sub(1,4):lower()=='sing' and v:GetAttribute("Playing"))then
			return v
		end
	end
	return nil
end

function Character:Update(elapsed)
	if(not self.IsPlayer)then
		if(self:IsSinging())then
			self.HoldTimer+=elapsed
		end
		local dadVar = 4;
		if(self.HoldTimer>=Conductor.stepCrochet*dadVar*.001)then
			self:Dance()
			self.HoldTimer=0;
		end
	end
	local singAnim = self:GetCurrentSingAnim();
	if(self.Holding and singAnim)then
		singAnim.TimePosition=0;
		singAnim:AdjustSpeed(0)
	elseif(not singAnim)then
		self.Holding=false;
		if type(self.MicPositions) == "table" then
			self:MoveMic(self.MicPositions['idle'])
		end
	end
	if(not self.Holding and singAnim and singAnim:GetAttribute("Playing"))then
		singAnim:AdjustSpeed(1)
	end
end


function Character:PlayAnimation(name,force)
	local track = self.Animations[name]
	if(track)then
		if(track:GetAttribute("Playing") and not force)then return end

		track.TimePosition=0
		if(not self.Holding)then
			track:AdjustSpeed(1)
		end
		track:AdjustWeight(0)
		for n,v in next, self.Animations do
			if n == "idle" then continue end
			v.TimePosition=0
			if(n~=name)then
				v:Stop(.05)
			end
		end
		track:SetAttribute("Playing",true)
		track:Play(0,1,track:GetAttribute"Speed")
		if type(self.MicPositions) == "table" then
			self:MoveMic(self.MicPositions[name])
		end
	end
end

function Character:ToggleAnimatorScript(bool:boolean)
	if self.AnimatorScript and self.AnimatorScript:IsA("LocalScript") then
		self.AnimatorScript.Disabled = not bool
	end
end

function Character:GetAnimationTrack(name)
	return self.Animations[name]
end

function Character:AnimLoaded(id)
	for _,v in next, self.Animations do
		if(v.Animation.AnimationId=='rbxassetid://'..id)then
			return true;
		end
	end
	return false;
end

return Character