local remoteFunction = game.ReplicatedStorage.Modules.Character.Character
local Animations = {}
-- {PlayerName = {}}

-- This is very optimized and the server events should run pretty smoothly
remoteFunction.OnServerEvent:Connect(function(plr, msg, ...)
	--print(string.format("%s sent %s signal", plr.Name, msg))
	if msg == "Animate" then -- Animate the character
		--print("Animating Server Rig")
		local name, speed, holding = ...
		local animator = workspace:FindFirstChild("ServerRig-"..plr.Name)
		if animator then
			local anima = animator.Humanoid.Animator
			for _,track in pairs(Animations[plr.Name]) do
				if track then
					track.TimePosition=0
					if track.Name == name then
						if not holding then
							track:AdjustSpeed(1)
						else
							track:AdjustSpeed(0.25)
						end
						track:AdjustWeight(0)
						track:Play(0,1,speed)
					elseif track.Name ~= "idle" then
						track:Stop(.05)
					end
				end
			end
		end
	elseif msg == "AddAnimation" then -- Add animation?
		--print("Added Animation To Server Track")
		local id, name, looped, priority = ...
		local animator = workspace:FindFirstChild("ServerRig-"..plr.Name)
		if animator then
			local anima
			if not animator.Humanoid:FindFirstChild("Animator") then
				anima = Instance.new("Animator")
				anima.Parent = animator.Humanoid
			else
				anima = animator.Humanoid.Animator
			end

			local animation = Instance.new("Animation")
			animation.AnimationId = id
			animation.Name = name
			local track = anima:LoadAnimation(animation)
			track.Priority = priority or Enum.AnimationPriority.Action
			track.Looped = looped or false
			track.Stopped:Connect(function()
				if(track.TimePosition==track.Length)then
					track:AdjustSpeed(0)
					track:Play(0,0,0)
					track.TimePosition = 0
				end
			end)
			animation.Parent = anima
			if not Animations[plr.Name] then
				Animations[plr.Name] = {}
			end
			Animations[plr.Name][name] = track
		end
	elseif msg == "RemoveRig" then
		local rig = workspace:FindFirstChild("ServerRig-" ..  plr.Name)
		if rig then
			rig:Destroy()
		end
	elseif msg == "RemoveAnimations" then
		if Animations ~= nil and Animations[plr.Name] ~= nil then
			for _,track in pairs(Animations[plr.Name]) do
				track:Stop(0)
			end
		end
		Animations[plr.Name] = {};
	elseif msg == "CreateCharacter" then -- Add the character to the workspace and position it as x position
		local charData, position, opp = ...
		--print("Created Character" .. tostring(plr.Name))

		if charData then
			local character = charData.RigFile:Clone()
			if charData.Description then -- Apply the player's description/cosmetics
				local description = plr.Character.Humanoid:GetAppliedDescription()
				for _, clothing in pairs(character:GetChildren()) do
					if clothing:IsA("ShirtGraphic") or clothing:IsA("Accessory") or clothing:IsA("Pants") or clothing:IsA("Clothing") or clothing:IsA("BodyColors") then
						clothing:Destroy()
					end
				end

				task.spawn(function()
					local suc,err = pcall(function()
						local waitTime = 0
						repeat
							waitTime += task.wait()
						until waitTime > 10 or description ~= nil
						character.Humanoid:ApplyDescription(description);
					end)

					if not suc then 
						warn("(ERROR) Unable to load description -> ",err)
					end
				end)
			end
			character:PivotTo(position) -- Move it to said position
			if character.Humanoid:FindFirstChild("Animator") then
				character.Humanoid.Animator:ClearAllChildren()
			end
			--char:PivotTo(position)
			local CharacterName = "ServerRig-" .. plr.Name
			character.Name = CharacterName
			character.PrimaryPart.Anchored = true -- Anchor it so they don't get pushed around like a some nerd
			character.Humanoid.DisplayName = ""; -- So it doesn't say "ServerRig-"
			if (workspace:FindFirstChild(plr.Name)) then -- Only spawns the character if it is located in workspace
				character.Parent = workspace

				-- Send a signal to the client that the character was added (meaning the player should delete it)
				remoteFunction:FireClient(plr, "Remove", CharacterName)
				if opp then
					remoteFunction:FireClient(opp, "Remove", CharacterName) -- Send a signal to remove the rig as well
				end
			end
		end
	elseif msg == "HidePlayer" then -- Hide the real player
		local char, hide = ...
		--print("Hide Player: " .. tostring(hide))
		if not char then
			char = plr.Character
		end
		if hide == true then
			print("HIDE TRUE")
			char:SetAttribute("OldPos", char:GetPivot())
			-- Make the character invisible for everyone
			char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			char.HumanoidRootPart.Anchored = true
			char:PivotTo(CFrame.new(-22653.719, 3881.049, 6206.163)) -- Subtract position by this value
		else
			print('HIDE FALSE')
			-- Make the character visible for everyone (and delete the rig from the song)
			char:PivotTo(char:GetAttribute("OldPos")) -- Pivot back to og pos

			local serverRig = workspace:FindFirstChild("ServerRig-" .. plr.Name)
			if serverRig then
				serverRig:Destroy() -- Destroy the song rig
			end

			table.remove(Animations, table.find(Animations, plr.Name))
			
			--char.HumanoidRootPart.Anchored = false
			char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(plr) -- Since the rigs will stay if a player leaves then
	local serverRig = workspace:WaitForChild("ServerRig-" .. plr.Name, 3) -- Now it waits for it
	if serverRig then
		serverRig:Destroy() -- Destroy the song rig
		warn("Destroying A Rig Cause Somebody Left Midsong")
	end

	-- Check for every player if there is a rig attached
	for _,part in pairs(workspace:GetChildren()) do
		-- Holy, so much string stuff
		if string.sub(part.Name, 1, 10) == 'ServerRig-' then
			local person = game.Players:FindFirstChild(string.sub(part.Name, 11, string.len(part.Name)))
			if not person then
				part:Destroy() -- Destroy the song rig
				warn("Destroying A Rig Cause Nobody Owns It")
			end
		end
	end
end)
