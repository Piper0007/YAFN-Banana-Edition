local velLibrary = {}

function AddPosV2(ud2,v2)
	return UDim2.new(
		ud2.X.Scale,
		ud2.X.Offset+v2.X,
		ud2.Y.Scale,
		ud2.Y.Offset+v2.Y
	)	
end

function velLibrary.ComputeVelocity(velocity,acceleration,drag,max,elapsed)
	if(acceleration~=0)then
		velocity+=acceleration*elapsed
	elseif(drag~=0)then
		local drag = drag*elapsed;
		if(velocity-drag>0)then
			velocity-=drag
		elseif(velocity+drag<0)then
			velocity+=drag
		else
			velocity=0
		end
	end
	if(max~=0 and velocity~=0)then
		velocity=math.clamp(velocity,-max,max)
	end
	return velocity
end

function velLibrary:UpdateMotion(gui,elapsed)
	local velocity = gui:GetAttribute("Velocity") or Vector2.new(0,0)
	local maxVelocity = gui:GetAttribute("MaxVelocity") or Vector2.new(0,0)
	local acceleration = gui:GetAttribute("Acceleration") or Vector2.new(0,0)
	local drag = gui:GetAttribute("Drag") or 0
	local drag = typeof(drag)=='Vector2' and drag or typeof(drag)=='number' and Vector2.new(drag,drag) or Vector2.new(0,0)
	
	local offset = gui:GetAttribute("Offset") or Vector2.new()
	local origin = gui:GetAttribute("Origin")
	
	if(origin==nil)then
		origin=gui.Position
		gui:SetAttribute("Origin",origin)
	end
	local velDelta = Vector2.new(
		.5*(self.ComputeVelocity(velocity.x,acceleration.x,drag.x,maxVelocity.x,elapsed)-velocity.x),
		.5*(self.ComputeVelocity(velocity.y,acceleration.y,drag.y,maxVelocity.y,elapsed)-velocity.y)
	)
	
	velocity+=velDelta;
	local delta = velocity*elapsed
	velocity+=velDelta
	
	gui:SetAttribute("Velocity",velocity)
	gui:SetAttribute("Offset",offset+delta)
	gui.Position=AddPosV2(origin,offset+delta)
end

return velLibrary
