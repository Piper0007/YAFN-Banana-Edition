local Character = {}
local Updater = require(script.Parent.Updater)
local Sprite = require(script.Parent.Sprite)
local Conductor = require(script.Parent.Conductor)
Character.__index=Character

function Character.new(char,cf,isPlayer,animTable,animName, speedModifier, humanoidDescription, otherPlayer)	
	if not animTable then
		animTable = {}
		animTable.MicPositioning = nil
		animTable.Offset = CFrame.new()
	end
	local obj
	local AnimatorScript
	if isPlayer then -- is player is something that defines if there is a player controlling it
		obj = isPlayer.Character
		AnimatorScript = isPlayer.Character:FindFirstChild("Animate",10)
	else
		obj = (game.ReplicatedStorage.Characters:FindFirstChild(char) or game.ReplicatedStorage.Characters.opponent):Clone()
		--obj.Parent=game.ReplicatedStorage
	end
	local charObj={ -- Defines a list of properties that is assigned to the character
		BeatDancer=false; -- Beat dancers are characters that have 2 different idle animations that play back and forth
		Obj=obj; -- The actual rig of the character, which includes all the parts to the model. (This gets changed everytime the rig is changed)
		EventHandler = obj:FindFirstChild("AnimationHandler",true);
		IsPlayer=isPlayer; -- A value that determines if the character is controlled by a player or not
		Name=obj.Name; -- It is just the name of player who the animation is parent under. could be used for modcharts I guess.
		Animator=obj:FindFirstChild("Animator",true);
		--MicPositions = animTable.MicPositioning;
		StartCFrame = cf;
		Animations={}; -- A list that contains all the animation tracks on the character
		Microphone=nil; -- The microphone
		CurrPlaying=''; -- The currently playing animation
		Holding=false; -- Whether or not the animation is being held
		HoldTimer=0; -- Used for non player character which determines how the character will animate when holding a animation
		AnimPlaying=false; -- set to true if the character is playing a animation and false if not
		AnimName = animName; -- The name of the animation
		AnimatorScript = AnimatorScript; -- Animator script which includes the script that handles walking animations for the player's character
		Description=humanoidDescription; -- This is the cosmetics and stuff
		LoadedAnims={}; -- Stores all of the preloaded animations in this table
		Flipped=false; -- Determines if the character's left and right animations are swapped
		LoadedRigs={}; -- A list that will contain rigs that were preloaded
		Speed=speedModifier;
		Opponent=otherPlayer or nil; -- Opponent is the other player on the stage
		Remote=nil; -- This is for sending signals to the server that something happened
		Connections={}; -- A list of connected functions that should get disconnected as soon as the character is destroyed
	}
	char = charObj.Obj.Name;
	setmetatable(charObj,Character)
	if isPlayer then --  and isPlayer == game.Players.LocalPlayer
		charObj.Remote=script.Character -- The server script that handles the server stuff is located under ServerScriptService.AnimatorHandler
		--if isPlayer == game.Players.LocalPlayer then
		charObj.Remote:FireServer("HidePlayer", isPlayer.Character, true) -- Send a signal to the server to hide the player
		--end
		
		local con = script.Character.OnClientEvent:Connect(function(msg, ...)
			if msg == "Remove" then -- Signal from the server to remove specified character from workspace
				local name = ...
				local realChar = workspace:WaitForChild(name, 5) -- wait for the child
				if realChar then
					realChar.Parent = game.ServerStorage -- Don't destroy so that animations will load
				else
					warn("Server Rig Not Found")
				end
			end
		end)
		table.insert(charObj.Connections, con)
	end
	obj:SetPrimaryPartCFrame(cf * animTable.Offset)
	if isPlayer then obj.HumanoidRootPart.CFrame = cf * animTable.Offset end
	--charObj:ToggleAnimatorScript(false) -- This is already handled by gameHandler
	charObj:ChangeAnim(animName, 1)

	Updater:Add(charObj) -- Adds the character to a module script that runs functions on a loop (based on rendered frames)
	return charObj
end

function Character:SetCF(cf) -- This was a counter measure for modcharts that used this, but just use :PivotTo() instead
	self.Obj:PivotTo(cf) -- -_-
end

function Character:PreloadAnim(anim, speed)
	-- Pssst here's a secret. It doesn't preload animations just the rig
	local rigChar = game.ReplicatedStorage.Animations.SongsAnim:FindFirstChild(anim) or game.ReplicatedStorage.Animations.CharacterAnims:FindFirstChild(anim)
	if rigChar then
		self:PreloadRig(rigChar)
	end
end

function Character:ChangeAnim(animation, speed)
	if not animation then return end

	if self.CustomRig then -- Send a signal to the server to remove the player's rig
		self.CustomRig.Parent = game.ServerStorage:FindFirstChild("RigStorage") 
		if self.Remote and self.IsPlayer == game.Players.LocalPlayer then
			self.Remote:FireServer("RemoveRig")
		end
	end
	local animationData = game:GetService("ReplicatedStorage").Animations.CharacterAnims:FindFirstChild(animation) or game:GetService("ReplicatedStorage").Animations.SongsAnim:FindFirstChild(animation)
	if animationData then
		self.currentAnim=animation
		self:LoadRig(animationData)
	end

	for _,Track in next,self.Animator:GetPlayingAnimationTracks() do
		Track:Stop(0)
	end
	for _,track in pairs(self.Animations) do
		track:SetAttribute("Playing",false)
		track:Stop(0)
	end

	if self.Remote and self.IsPlayer == game.Players.LocalPlayer then
		self.Remote:FireServer("RemoveAnimations") -- Send a signal to the server to remove all animations
	end

	-- Change the animation
	local Animation = game.ReplicatedStorage.Animations.CharacterAnims:FindFirstChild(animation) or game.ReplicatedStorage.Animations.SongsAnim:FindFirstChild(animation)
	local needsProps = Animation:GetAttribute("CharacterName")
	local props
	local micName

	if needsProps and game.ReplicatedStorage.Characters[needsProps] then
		props = needsProps
	end

	self.AnimName = Animation.Name

	local animTable = {
		Offset = CFrame.new();
		MicPositioning = {};-- Can be an object as well.
	}

	for _,AnimObj in next,Animation:GetChildren() do
		if AnimObj:IsA("CFrameValue") and AnimObj.Name == "BFOffset" then
			animTable.Offset = AnimObj.Value
		elseif AnimObj:IsA("Folder") and AnimObj.Name == "MicPositioning" then
			for _,Obj in next,AnimObj:GetChildren() do
				animTable.MicPositioning[Obj.Name] = Obj.Value
			end
		elseif AnimObj:IsA("ObjectValue") or AnimObj:IsA('BoolValue') and AnimObj.Name == "MicPositioning" then
			animTable.MicPositioning = AnimObj.Value
		elseif AnimObj:IsA('StringValue') and AnimObj.Name == "Microphone" then
			micName = AnimObj.Value
		elseif AnimObj:IsA("Animation") then
			animTable[AnimObj.Name] = string.sub(AnimObj.AnimationId,14)
		end
	end

	--if self.IsPlayer then
	--	self.MicPositions = animTable.MicPositioning
	--end
	self.Animations = {}; 

	if(animTable.DanceLeft and animTable.DanceRight)then
		self.BeatDancer=true;
		self:AddAnimation("danceLeft",animTable["DanceLeft"],speed,true,Enum.AnimationPriority.Idle)
		self:AddAnimation("danceRight",animTable["DanceRight"],speed,true,Enum.AnimationPriority.Idle)
	else
		self:AddAnimation("idle",animTable["Idle"],speed,true,Enum.AnimationPriority.Idle)
	end
	self:AddAnimation("singDOWN",animTable["SingDown"],speed,false,Enum.AnimationPriority.Movement)
	self:AddAnimation("singLEFT",animTable["SingLeft"],speed,false,Enum.AnimationPriority.Movement)
	self:AddAnimation("singRIGHT",animTable["SingRight"],speed,false,Enum.AnimationPriority.Movement)
	self:AddAnimation("singUP",animTable["SingUp"],speed,false,Enum.AnimationPriority.Movement)

	for name,id in next, animTable do
		if((typeof(id)=='number' or tonumber(id)) and not self:AnimLoaded(id))then
			self:AddAnimation(string.lower(name),id,speed,false,Enum.AnimationPriority.Movement)
		end
	end

	self:PlayAnimation("idle")
end

function Character:PreloadRig(animData)
	if not animData then warn("No Animation Found") return end

	local isR15=animData:GetAttribute("R15")

	-- Get the character from the Character list inside of ReplicatedStorage
	local rigName=animData:GetAttribute("CharacterName")~="" and animData:GetAttribute("CharacterName");
	local rigFile=game:GetService("ReplicatedStorage").Characters:FindFirstChild(rigName or "")
	if not rigName and isR15 then
		rigName="R15Awesome";
		rigFile=game.ReplicatedStorage.Characters.DefaultR15;
	end

	if not rigFile then warn("No Rig Found") return end

	-- Checks if the rig is already preloaded
	if self.LoadedRigs[rigName] then return self.LoadedRigs[rigName] end;
	if rigFile then
		-- Rig Storage is where the preloaded rigs will be stored
		local rigStorage = game:GetService("ServerStorage"):FindFirstChild("RigStorage")
		if not rigStorage then -- Make the rig storage if it doens't exist
			local worldModel = Instance.new("WorldModel")
			worldModel.Name = "RigStorage"
			worldModel.Parent = game.ServerStorage
			rigStorage = worldModel
		end

		local preloadedData={}
		preloadedData.Description=false
		preloadedData.RigFile = rigFile
		preloadedData.isRig = rigName~="R15Awesome";
		preloadedData.isR15 = isR15;
		preloadedData.Hidden=false

		if animData:GetAttribute("Hide") then
			preloadedData.Hidden=true
		end

		local char=rigFile:Clone()
		char.Parent=rigStorage
		char.Name=rigName

		preloadedData.Rig=char

		-- check missing data
		preloadedData.Humanoid=char:FindFirstChild("Humanoid")
		if not preloadedData.Humanoid then -- Make a humanoid for the rig
			local hum=Instance.new("Humanoid").Parent
			hum.Parent=char
			preloadedData.Humanoid=hum
		end
		preloadedData.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		preloadedData.Animator=preloadedData.Humanoid:FindFirstChild("Animator")
		if not preloadedData.Animator then -- Make an animator for the rig
			local animator=Instance.new("Animator")
			animator.Parent=preloadedData.Humanoid
			preloadedData.Animator=animator
		end

		if self.Description then -- Applies the accessories to the character model
			if isR15 and (char:GetAttribute("Description") or animData:GetAttribute("Description")) or true then
				preloadedData.Description = true

				for _, clothing in pairs(preloadedData.Rig:GetChildren()) do
					if clothing:IsA("ShirtGraphic") or clothing:IsA("Accessory") or clothing:IsA("Pants") or clothing:IsA("Clothing") or clothing:IsA("BodyColors") or (clothing:IsA("CharacterMesh") and clothing.Name == "CharacterMesh") then
						clothing:Destroy()
					end
				end

				local trackedData={};

				local getInstance = function(char,data)
					if data==nil then return end
					local block = char
					for i=1,#data do
						local storedBlock = data[i]
						if not block:FindFirstChild(storedBlock) then break end
						block = block:FindFirstChild(storedBlock)
					end
					return block
				end

				local getrealName = function(char,block)
					if block == nil or block.Parent==nil then return nil end
					local tab = {}
					local newParent = block
					table.insert(tab,1,block.Name)
					newParent = block.Parent
					if newParent ~= char then
						table.insert(tab,1,newParent.Name)
						repeat
							if newParent.Parent ~= char then
								newParent = newParent.Parent
								table.insert(tab,1,newParent.Name)
							end
						until newParent.Parent == char
					end
					return tab
				end

				local dataParse={ -- how to parse data
					["Motor6D"] = function(motor:Motor6D,charModel:Model,dataTable)
						local motorClone=motor:Clone();

						local data={
							P0=getrealName(charModel,motor.Part0);
							P1=getrealName(charModel,motor.Part1);
							Parent=getrealName(charModel,motor.Parent);
							Connections={}; -- connections related
							Clone=motorClone;
						}

						table.insert(data.Connections,motor.Destroying:Connect(function() --he's dead! replace!
							dataTable[motor]=nil; --clear
							dataTable[motorClone]=data; -- replace
							data.Clone=nil; -- remove clone (avoid cleaning)
						end))

						return data;
					end,
				} 
				local dataLoad={  -- how to load data
					["Motor6D"] = function(motor:Motor6D,charModel:Model,data)
						motor.Parent=getInstance(charModel,data.Parent);
						motor.Part0=getInstance(charModel,data.P0)
						motor.Part1=getInstance(charModel,data.P1)

						if data.Clone then
							data.Clone:Destroy();
						end

						for _,clear:RBXScriptConnection in (data.Connections or {}) do
							pcall(function() clear:Disconnect(); end)
						end
					end,
				}

				-- Add Attachments that do not exist

				local attachType = script.R6
				if isR15 then attachType = script.R15 end
				for _,inst in pairs(attachType:GetChildren()) do
					for _,attachment in pairs(inst:GetChildren()) do
						if char:FindFirstChild(inst.Name) then
							if not char[inst.Name]:FindFirstChild(attachment.Name) then
								-- warn('Attachment '..attachment.Name..' Not Found')
								local newThing = attachment:Clone()
								newThing.Parent = char[inst.Name];
							end
						end
					end
				end

				task.spawn(function()
					local suc,err = pcall(function()
						for _,part:Instance in char:GetDescendants() do
							-- better way than just lots of if motor6d then elseif weld then
							local parseFunc=dataParse[part.ClassName]
							if parseFunc then
								trackedData[part]=parseFunc(part,char,trackedData);
							end
						end

						preloadedData.Humanoid:ApplyDescription(self.Description);

						for instance,data in trackedData do
							local loadFunc=dataLoad[instance.ClassName]
							if loadFunc then
								local suc,err = pcall(function()
									loadFunc(instance,char,data);
								end)
								if not suc then 
									-- This always be making warnings when it is working
									--warn("(CHARACTER) Loading Instances Error! ->",err)
								end
							end
						end
						table.clear(trackedData); -- clear references
					end)

					if not suc then 
						warn(err)
					end
				end)
			end
		end

		--print("| Preloaded Rig: " .. tostring(rigName))
		self.LoadedRigs[rigName]=preloadedData
		return preloadedData
	end
end

function Character:LoadRig(anim)
	local rig
	local rigChar = anim:GetAttribute("CharacterName") or anim:GetAttribute("R15") and "R15Awesome"
	if self.LoadedRigs[rigChar] then
		rig = self.LoadedRigs[rigChar]
	end
	if not rig then
		rig = self:PreloadRig(anim)
	end
	if rig then
		rig.Rig.PrimaryPart.Anchored=true;
		for i,v in pairs(rig.Rig:GetDescendants()) do
			if v:IsA("Highlight") then
				v.Enabled = true
			end
		end

		rig.Rig.Name="PlayerRig"

		rig.Rig:PivotTo(self.Obj.HumanoidRootPart.CFrame)

		self.Obj=rig.Rig
		self.Animator = rig.Rig.Humanoid:FindFirstChild("Animator")

		if self.Remote then -- Server Stuff
			self.Remote:FireServer("CreateCharacter", rig, self.StartCFrame, self.Opponent) -- Send a signal to the server to hide the player
		end

		rig.Rig.Parent=workspace
		self.CustomRig=rig.Rig
		self.Animator=rig.Rig.Humanoid.Animator
	end
end

function Character:flipDir()
	self.Flipped = not self.Flipped
end

function Character:MoveMic(value:boolean|BasePart|number)
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

function Character:AddAnimation(name,id,speed,looped,priority,preload)
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
	local track = self.Animator:LoadAnimation(anim)
	track.Name=name;
	track.Looped=looped or false
	track.Priority=priority or track.Priority
	track:SetAttribute("Speed",(speed or 1)*self.Speed)
	track:SetAttribute("Playing",false)
	track:SetAttribute("Priority",track.Priority.Value)
	if not preload then
		self.Animations[name]=track;
	end
	track.Stopped:Connect(function()
		track:SetAttribute("Playing",false)
		if(track.TimePosition==track.Length)then
			track:AdjustSpeed(0)
			track:Play(0,0,0)
			track.TimePosition = 0
		end
	end)
	if self.Remote and self.IsPlayer == game.Players.LocalPlayer then -- Send a signal to the server to load the animation
		self.Remote:FireServer("AddAnimation", anim.AnimationId, name, looped, track.Priority)
	end
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
		--singAnim:AdjustSpeed(0.25) -- Make it slow
		singAnim:SetAttribute("Playing", false)
	elseif(not singAnim) then
		self.Holding=false;
		--if type(self.MicPositions) == "table" then
		--	self:MoveMic(self.MicPositions['idle'])
		--end
	end
	if(not self.Holding and singAnim and singAnim:GetAttribute("Playing"))then
		singAnim:AdjustSpeed(1)
	end
end


function Character:PlayAnimation(name,force,looped)
	if self.Flipped then
		if name=="singRIGHT" then name="singLEFT" elseif name=="singLEFT" then name="singRIGHT" end
	end
	local track = self.Animations[name]
	if(track)then
		-- Returns if there is a already playing animation and it is not forced
		if(track:GetAttribute("Playing") and not force)then return end

		track.TimePosition=0
		if(not self.Holding)then
			track:AdjustSpeed(1)
		end
		if looped then
			track.Looped = looped or false
		end
		track:AdjustWeight(0)
		for n,v in next, self.Animations do
			if n == "idle" or n.Looped==true then continue end
			v.TimePosition=0
			if(n~=name)then
				v:Stop(.05)
			end
		end
		track:SetAttribute("Playing",true)
		local speed = track:GetAttribute"Speed"
		if self.Remote and self.IsPlayer == game.Players.LocalPlayer then
			self.Remote:FireServer("Animate", name, speed, self.Holding, looped) -- Send a signal to the server to animate the server sided character
		end
		track:Play(0,1,speed)
		--if type(self.MicPositions) == "table" then
		--	self:MoveMic(self.MicPositions[name])
		--end
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

function Character:ToggleAnimatorScript(bool:boolean)
	if self.AnimatorScript and self.AnimatorScript:IsA("LocalScript") then
		self.AnimatorScript.Disabled = not bool
	end
end

function Character:Destroy()
	if self.Microphone then self.Microphone = self.Microphone:Destroy() end
	for _,rig in pairs(self.LoadedRigs) do
		if rig.Rig then -- Destroy existing rigs
			rig.Rig:Destroy()
		end
	end
	if self.IsPlayer then
		if self.Remote and self.IsPlayer == game.Players.LocalPlayer then -- Send a signal to the server to destroy the server rig and make the real character visible
			self.Remote:FireServer("HidePlayer", self.IsPlayer.Character, false)
		end
		for _,connection in pairs(self.Connections) do
			if connection then connection:Disconnect() end -- Disconnect functions to release memory
		end
		--self.Animator.Parent = self.IsPlayer.Character.Humanoid
		self:ToggleAnimatorScript(true)
		self.Obj:Destroy()
		return 
	end
	Updater:Destroy(self)
	self.Obj:Destroy()
end

return Character
