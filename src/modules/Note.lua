local repS = game.ReplicatedStorage
local GameSettings = require(repS.Modules.GameSettings)

type TwoDCoordinates = {
	X:number,
	Y:number,
}

export type Note = {
	StrumTime: number,
	shouldPress: boolean,
	MustPress: number,
	NoteData: number,
	TooLate: boolean,
	noAnimation: boolean,
	scrollDirection: string,
	CanBeHit: boolean,
	GoodHit: boolean,
	PrevNote: Note|nil,
	SustainLength: number,
	IsSustain: boolean|nil,	
	IsSusEnd: boolean,
	X: number,
	Y: number,
	Offset: TwoDCoordinates,
	Scale: TwoDCoordinates,
	Size: TwoDCoordinates,
	Score: number,
	NoteObject: ImageLabel,
	Sink: number,
	Mana: number,
	NoteGroup: string,
	ReceptorX: number,
	Type: string,
	manualXOffset: number,
	HealthLoss: number,
	Transparency: number,
	InitialPos: number,
	HoldParent: boolean,
	RawData: table,
	Hitbox: number,
	HPGain: number,
	GainOnSustains: bool,
	Classic: boolean,
	ScrollMultiplier: number,
}
local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local Conductor = require(script.Parent.Conductor)
local Sprite = require(script.Parent.Sprite)
local noteGroups = script.Parent.NoteGroups

local NoteClass = {}
NoteClass.__index=NoteClass

function NoteClass:SetPosition(rawX,rawY)
	local X,Y = self.Size.X*self.Scale.X,self.Size.Y*self.Scale.Y
	self.X = rawX
	self.Y = rawY
end

NoteClass.specialNoteAnimQueue = {}

function NoteClass:QueueReceptorSparrowXML(ImageId,...)
	if self.Type == "None" then return end
	NoteClass.specialNoteAnimQueue[self.Type] = {ImageId,...}
end

function NoteClass:Update()
	if(self.Destroyed)then return end
	self.Animation:UpdateSize();
	--[
	if shared.internalSettings.notesShareTransparencyWithReceptors then
		self.Animation.Alpha = 1- (self.DefaultTransparency + ((1-self.DefaultTransparency) * (1-self.ReceptorTarget.Alpha)))
	else--]]
		self.Animation.Alpha = 1- (self.DefaultTransparency + ((1-self.DefaultTransparency) * self.Transparency))
	end
	self.Size=self.Animation.Size
	local X,Y = self.Size.X*self.Scale.X,self.Size.Y*self.Scale.Y
		--self.NoteObject.Position=UDim2.new(0,(self.X+self.Offset.X)*self.Animation.Scale.X,(50+self.Y+self.Offset.Y+(Y/2)+self.Sink)/Conductor.screenSize.Y,0)+UDim2.new(0,self.Animation.FrameOffset.X,0,self.Animation.FrameOffset.Y)
	
	self.NoteObject.Size=UDim2.new((X * self.Animation.Scale.X)/self.Animation.ScaleFactors.X,0,((Y-self.Sink) * self.Animation.Scale.Y)/self.Animation.ScaleFactors.Y,0)
	if(self.NoteObject.Parent)then
		self.NoteObject.Position = UDim2.new((((self.X+self.Offset.X)-self.Animation.FrameOffset.X)/shared.noteScaleRatio.X)+self.ReceptorX,0,((self.Y+self.Offset.Y+self.Sink)-self.Animation.FrameOffset.Y)/(Conductor.screenSize.Y),0)
		if shared.internalSettings.notesRotateWithReceptors and (not self.IsSustain) then
			self.NoteObject.Rotation = self.ReceptorTarget.GUI.Rotation--shared.Receptors[self.RawData[2]+1].GUI.Rotation
		end
	end
	if(self.MustPress)then
		if(self.StrumTime<Conductor.SongPos-Conductor.safeZoneOffset and not self.GoodHit)then
			self.TooLate=true
		end
		if(not self.TooLate)then
			if(self.IsSustain) then
				self.CanBeHit = (self.StrumTime > Conductor.SongPos - 80 and self.StrumTime < Conductor.SongPos + 80)
			else
				self.CanBeHit = (self.StrumTime > Conductor.SongPos - self.Hitbox and self.StrumTime < Conductor.SongPos + self.Hitbox)
			end
		else
			self.CanBeHit=false
		end
	else
		self.CanBeHit=false
		if(self.StrumTime<=Conductor.SongPos)then
			self.GoodHit=true
		end
	end
	
	if(self.TooLate and self.NoteObject.ImageTransparency<(.6 * (1 - self.NoteObject.ImageTransparency)))then
		self.NoteObject.ImageTransparency=.6 * (1 - self.NoteObject.ImageTransparency)
	end
end

function NoteClass:Destroy()
	self.Animation:Destroy()
	self.NoteObject:Destroy()
	setmetatable(self,{})
	self=nil;
end

function NoteClass:ApplyImageRect(data)
	self.NoteObject.ImageRectSize=data[1]
	self.NoteObject.ImageRectOffset=data[2]
end

function NoteClass:FixSize()
	self.Size.X=self.NoteObject.ImageRectSize.X
	self.Size.Y=self.NoteObject.ImageRectSize.Y
end

local BlackDirectionalNames={
	'blackLeft';
	'blackDown';
	'blackUp';
	'blackRight';
}
local haloManiaDirs = {
	[0] = {
		'purpleScroll';
		'blueScroll';
		'greenScroll';
		'redScroll';
	};
	{ -- 1
		'purpleScroll';
		'greenScroll';
		'redScroll';
		'purpleScroll';
		'blueScroll';
		'redScroll';
	};
	{ -- 2
		'purpleScroll';
		'blueScroll';
		'greenScroll';
		'redScroll';
		'greenScroll';
		'purpleScroll';
		'blueScroll';
		'greenScroll';
		'redScroll';
	};
	{ -- 3
		'purpleScroll';
		'blueScroll';
		'blueScroll';
		'greenScroll';
		'redScroll';
	};
	{ -- 3
		'purpleScroll';
		'greenScroll';
		'redScroll';
		'blueScroll';
		'purpleScroll';
		'blueScroll';
		'redScroll';
	};
	{ -- 4
		'purpleScroll';
		'blueScroll';
		'greenScroll';
		'redScroll';
		'purpleScroll';
		'blueScroll';
		'greenScroll';
		'redScroll';
	};
}

local maniaListThingy = {
	[0] = { 
		DirNames = {
			'purpleScroll';
			'blueScroll';
			'greenScroll';
			'redScroll';
		};
		SusNames = { -- funny
			'purplehold';
			'bluehold';
			'greenhold';
			'redhold';
		}
	};
	{ -- 1
		DirNames = {
			"purpleScroll";
			"greenScroll";
			"redScroll";
			"yellowScroll";
			"blueScroll";
			"darkScroll";
		};
		SusNames = { 
			"purplehold";
			"greenhold";
			"redhold";
			"yellowhold";
			"bluehold";
			"darkhold";
		}
	};
	{ -- 2
		DirNames = {
			'purpleScroll';
			'blueScroll';
			'greenScroll';
			'redScroll';
			"whiteScroll";
			"yellowScroll";
			"violetScroll";
			"blackScroll";
			"darkScroll";
		};
		SusNames = { 
			'purplehold';
			'bluehold';
			'greenhold';
			'redhold';
			"whitehold";
			"yellowhold";
			"violethold";
			"blackhold";
			"darkhold";
		}
	};
	{ -- 3
		DirNames = {
			'purpleScroll';
			'blueScroll';
			"whiteScroll";
			'greenScroll';
			'redScroll';
		};
		SusNames = { 
			'purplehold';
			'bluehold';
			"whitehold";
			'greenhold';
			'redhold';
		}
	};
	{ -- 4
		DirNames = {
			"purpleScroll";
			"greenScroll";
			"redScroll";
			"whiteScroll";
			"yellowScroll";
			"blueScroll";
			"darkScroll";
		};
		SusNames = { 
			"purplehold";
			"greenhold";
			"redhold";
			"whitehold";
			"yellowhold";
			"bluehold";
			"darkhold";
		}
	};
	{ -- 5
		DirNames = {
			'purpleScroll';
			'blueScroll';
			'greenScroll';
			'redScroll';
			"yellowScroll";
			"violetScroll";
			"blackScroll";
			"darkScroll";
		};
		SusNames = { 
			'purplehold';
			'bluehold';
			'greenhold';
			'redhold';
			"yellowhold";
			"violethold";
			"blackhold";
			"darkhold";
		}
	};
}

function NoteClass:PlayAnimation(...)
	return self.Animation:PlayAnimation(...)
end

function NoteClass:AddSparrowXML(...)
	return self.Animation:AddSparrowXML(...)
end

function NoteClass:ChangeSkin(XMLModule,TextureId)
	if self.Type ~= "None" then
		warn(("Attempt to change a special note."))
	else
		self.Animation.GUI.Image = TextureId
		self.Animation.Animations = {}
		self:AddSparrowXML(XMLModule,'greenScroll', 'green0',24);
		self:AddSparrowXML(XMLModule,'redScroll', 'red0',24);
		self:AddSparrowXML(XMLModule,'blueScroll', 'blue0',24);
		self:AddSparrowXML(XMLModule,'purpleScroll', 'purple0',24);
		self:AddSparrowXML(XMLModule,'yellowScroll', 'yellow0',24);
		self:AddSparrowXML(XMLModule,'darkScroll', 'dark0',24);
		self:AddSparrowXML(XMLModule,'blackScroll', 'black0',24);
		self:AddSparrowXML(XMLModule,'whiteScroll', 'white0',24);
		self:AddSparrowXML(XMLModule,'violetScroll', 'violet0',24);

		self:AddSparrowXML(XMLModule,'purpleholdend', 'pruple end hold',24);
		self:AddSparrowXML(XMLModule,'greenholdend', 'green hold end',24);
		self:AddSparrowXML(XMLModule,'redholdend', 'red hold end',24);
		self:AddSparrowXML(XMLModule,'blueholdend', 'blue hold end',24);
		self:AddSparrowXML(XMLModule,'yellowholdend', 'yellow hold end',24);
		self:AddSparrowXML(XMLModule,'darkholdend', 'dark hold end',24);
		self:AddSparrowXML(XMLModule,'blackholdend', 'black hold end',24);
		self:AddSparrowXML(XMLModule,'whiteholdend', 'white hold end',24);
		self:AddSparrowXML(XMLModule,'violetholdend', 'violet hold end',24);

		self:AddSparrowXML(XMLModule,'purplehold', 'purple hold piece',24);
		self:AddSparrowXML(XMLModule,'greenhold', 'green hold piece',24);
		self:AddSparrowXML(XMLModule,'redhold', 'red hold piece',24);
		self:AddSparrowXML(XMLModule,'bluehold', 'blue hold piece',24);
		self:AddSparrowXML(XMLModule,'yellowhold', 'yellow hold piece',24);
		self:AddSparrowXML(XMLModule,'darkhold', 'dark hold piece',24);
		self:AddSparrowXML(XMLModule,'blackhold', 'black hold piece',24);
		self:AddSparrowXML(XMLModule,'whitehold', 'white hold piece',24);
		self:AddSparrowXML(XMLModule,'violethold', 'violet hold piece',24);

		self:PlayAnimation(self.Animation.CurrAnimation,true)
	end
	--[[
	self:PlayAnimation( (self.Mania == 1 and DIrectionalShaggyP2Names or (self.Mania == 2 and DirectionalShaggyP3Names or DirectionalNames))[self.NoteData+1],true )
	if(self.IsSustain and self.PrevNote) then
		self:PlayAnimation((self.Mania == 1 and SustainShaggyP2Animations or (self.Mania == 2 and SustainShaggyP3Animations or SustainAnimations))[self.NoteData+1] .. 'end',true)
		self:FixSize()
		if(self.PrevNote.IsSustain)then
			self.PrevNote:PlayAnimation((self.Mania == 1 and SustainShaggyP2Animations or (self.Mania == 2 and SustainShaggyP3Animations or SustainAnimations))[self.NoteData+1],true)
			self.PrevNote.NoteObject.ScaleType=Enum.ScaleType.Tile
			--self.PrevNote.Scale.Y=Conductor.stepCrochet/100*self.PrevNote.Scale.Y*1.5*(shared.getSpeed(self.StrumTime));
			self.PrevNote:FixSize()
		end
	end--]]
end

function NoteClass.new(XMLModule:ModuleScript, Object:ImageLabel ,strumTime:number, rawData:table, mania:number, group:string, noteData:number, prevNote:Note?, sustainNote:boolean?, noteType:string?)
	local epicNote:Note = {
		StrumTime=strumTime;
		MustPress=0;
		NoteData=noteData;
		TooLate=false;
		GoodHit=false;
		CanBeHit=false;
		manualXOffset=0;
		noAnimation=false;
		shouldPress=true;
		scrollDirection="None";
		Offset={
			X=0;
			Y=0;
		};
		Score=1;
		Scale={
			X=.7;
			Y=.7;
		},
		Size={
			X=100,
			Y=100,
		};
		Hitbox = Conductor.safeZoneOffset;
		IsSusEnd=false;
		HoldParent=false;
		PrevNote=prevNote or nil;
		SustainLength=0;
		IsSustain=sustainNote or false;
		X=0;
		Y=2000;
		NoteObject=Object:Clone();
		HealthLoss=0;
		Sink=0;
		Mania=mania;
		NoteGroup=group;
		Type=noteType or 'None';
		Transparency=0;
		DefaultTransparency=0;
		MissPunish=true;
		--CanHurt = 0;
		CanSustain=true;
		RawData = rawData;
		bro = 0;
		dType = 0;
		HPGain = 0.04;
		GainOnSustains=true;
		Classic=GameSettings.settings.ClassicNotes;
		ScrollMultiplier = 1;
	}
	local noteGroupData = noteGroups:FindFirstChild(group) or noteGroups.Default
	if(noteGroupData)then
		require(noteGroupData)(epicNote)
	end
	epicNote.NoteData = (epicNote.NoteData%shared.DirAmmo[epicNote.Mania])
	noteData = epicNote.NoteData
	if epicNote.Type == "Ring" then -- Sonic.exe
		local xmlFile = game.ReplicatedStorage.Modules.Assets.noteSkins5K.SonicRing.XML
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.noteSkins5K.SonicRing.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,2,true)
		epicNote.MissPunish = false
		epicNote.noAnimation = true
		epicNote.shouldPress = true
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(xmlFile,'whiteScroll', 'white0',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'FireNote' then -- tricky
		epicNote.CanSustain = false
		epicNote.MissPunish = true
		epicNote.shouldPress = false
		epicNote.Hitbox *= .5;
		epicNote.HealthLoss = 0.66666666;
		local DeathNoteXml = game.ReplicatedStorage.Modules.Assets["ALL_deathnotes.xml"]["NOTE_fire.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes.NOTE_fire.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,4,true)
		epicNote.Animation.GUI.AnchorPoint = Vector2.new()
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(DeathNoteXml,'greenScroll', 'green fire000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'redScroll', 'red fire000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'blueScroll', 'blue fire000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'purpleScroll', 'purple fire000',24,true);
		epicNote.Offset.X -= 14;
		epicNote.Offset.Y -= 8;
		epicNote:PlayAnimation(haloManiaDirs[epicNote.Mania][noteData+1],true)
	elseif epicNote.Type == 'HurtNote' then -- Psych Engine
		epicNote.CanSustain = true
		epicNote.MissPunish = true
		epicNote.shouldPress = false
		epicNote.Hitbox *= .5;
		epicNote.HealthLoss = 0.66666666;
		local DeathNoteXml = game.ReplicatedStorage.Modules.Assets.MiscXML["HurtNotes.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes["HurtNotes"].Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(DeathNoteXml,'greenScroll', 'green0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'greenholdend', 'green hold end0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'greenhold', 'green hold piece0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'redScroll', 'red0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'redholdend', 'red hold end0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'redhold', 'red hold piece0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'blueScroll', 'blue0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'blueholdend', 'blue hold end0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'bluehold', 'blue hold piece0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'purpleScroll', 'purple0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'purpleholdend', 'pruple end hold0000',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'purplehold', 'purple hold piece0000',24,true);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'Bullet' then -- accelerant
		local liveNoteXml = game.ReplicatedStorage.Modules.Assets.MiscXML["Bullet.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes["Bullet"].Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		epicNote.MissPunish = true
		epicNote.CanSustain = true
		epicNote.shouldPress = true
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'green0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'red0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'blue0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'purple0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purplehold', 'purple hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'bluehold', 'blue hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenhold', 'green hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redhold', 'red hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'purpleholdend', 'pruple end hold',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenholdend', 'green hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redholdend', 'red hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'blueholdend', 'blue hold end',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'shield' then -- Seek's 'epic' mod
		local liveNoteXml = game.ReplicatedStorage.Modules.Assets.DeathNotes.shieldNote.XML
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes.shieldNote.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		epicNote.MissPunish = true
		epicNote.CanSustain = true
		epicNote.shouldPress = true
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'green0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'red0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'blue0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'purple0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purplehold', 'purple hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'bluehold', 'blue hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenhold', 'green hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redhold', 'red hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'purpleholdend', 'pruple end hold',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenholdend', 'green hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redholdend', 'red hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'blueholdend', 'blue hold end0000',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'Sword' then -- Pibby corrupted
		local liveNoteXml = game.ReplicatedStorage.Modules.Assets.DeathNotes.swordNote.XML
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes.swordNote.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		epicNote.MissPunish = true
		epicNote.CanSustain = true
		epicNote.shouldPress = true
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'green0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'red0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'blue0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'purple0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purplehold', 'purple hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'bluehold', 'blue hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenhold', 'green hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redhold', 'red hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'purpleholdend', 'pruple end hold',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenholdend', 'green hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redholdend', 'red hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'blueholdend', 'blue hold end0000',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == "buble" then
		local liveNoteXml = game.ReplicatedStorage.Modules.Assets.DeathNotes.bubleNote.XML
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'green0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'red0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'blue0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'purple0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purplehold', 'purple hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'bluehold', 'blue hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenhold', 'green hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redhold', 'red hold piece0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'purpleholdend', 'pruple end hold',24);
		epicNote:AddSparrowXML(liveNoteXml,'greenholdend', 'green hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'redholdend', 'red hold end0000',24);
		epicNote:AddSparrowXML(liveNoteXml,'blueholdend', 'blue hold end',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[epicNote.NoteData+1])
	elseif epicNote.Type == "xNote" then
		local liveNoteXml = game.ReplicatedStorage.Modules.Assets.DeathNotes.xNote.XML
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'green0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'red0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'blue0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'purple0000',24,true);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[epicNote.NoteData+1])
	elseif epicNote.Type == 'Static' then -- Sonic exe
		local xmlFile = game.ReplicatedStorage.Modules.Assets.MiscXML["staticOGNotes.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes["staticOGNote"].Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,2,true)
		--epicNote.Animation.GUI.AnchorPoint = Vector2.new()
		epicNote.CanSustain = false
		epicNote.shouldPress = true
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(xmlFile,'purpleScroll', 'purple static',24,true);
		epicNote:AddSparrowXML(xmlFile,'blueScroll', 'blue static',24,true);
		epicNote:AddSparrowXML(xmlFile,'greenScroll', 'green static',24,true);
		epicNote:AddSparrowXML(xmlFile,'redScroll', 'red static',24,true);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'PhantomSonic' then -- Sonic exe
		local xmlFile = game.ReplicatedStorage.Modules.Assets.MiscXML["phantomSonic.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes["phantomSonic"].Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		--epicNote.Animation.GUI.AnchorPoint = Vector2.new()
		epicNote.MissPunish = false
		epicNote.CanSustain = false
		epicNote.shouldPress = false
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(xmlFile,'purpleScroll', 'purple withered',24);
		epicNote:AddSparrowXML(xmlFile,'blueScroll', 'blue withered',24);
		epicNote:AddSparrowXML(xmlFile,'greenScroll', 'green withered',24);
		epicNote:AddSparrowXML(xmlFile,'redScroll', 'red withered',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'Gem' then -- Noke
		epicNote.CanSustain = false
		epicNote.MissPunish = true
		epicNote.shouldPress = true
		local DeathNoteXml = game.ReplicatedStorage.Modules.Assets.MiscXML["gemNote.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes.gemNote.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,2,true)
		epicNote.Animation.GUI.AnchorPoint = Vector2.new()
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(DeathNoteXml,'greenScroll', "gemgreen",24);
		epicNote:AddSparrowXML(DeathNoteXml,'redScroll', 'gemred',24);
		epicNote:AddSparrowXML(DeathNoteXml,'blueScroll', 'gemblue',24);
		epicNote:AddSparrowXML(DeathNoteXml,'purpleScroll', 'gempurple',24);
		epicNote.Offset.X -= 57;
		epicNote.Offset.Y -= 40;
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type == 'BlackGem' then -- Noke
		epicNote.CanSustain = false
		epicNote.MissPunish = true
		epicNote.shouldPress = true
		local DeathNoteXml = game.ReplicatedStorage.Modules.Assets.MiscXML["gemNote.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.DeathNotes.gemNote.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,2,true)
		epicNote.Animation.GUI.AnchorPoint = Vector2.new()
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(DeathNoteXml,'greenScroll', "blackUP",24);
		epicNote:AddSparrowXML(DeathNoteXml,'redScroll', 'blackRIGHT',24);
		epicNote:AddSparrowXML(DeathNoteXml,'blueScroll', 'blackDOWN',24);
		epicNote:AddSparrowXML(DeathNoteXml,'purpleScroll', 'blackLEFT',24);
		epicNote.Offset.X -= 57;
		epicNote.Offset.Y -= 40;
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Type =='kill' then -- Shaggy's death note
		epicNote.CanSustain = false
		epicNote.shouldPress = false
		epicNote.HealthLoss=5;
		local DeathNoteXml = game.ReplicatedStorage.Modules.Assets.noteSkins9K.ShaggyxMatt.XML
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.noteSkins9K.ShaggyxMatt.Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,2,true)
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(DeathNoteXml,'greenScroll', 'kill',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'redScroll', 'kill',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'blueScroll', 'kill',24,true);
		epicNote:AddSparrowXML(DeathNoteXml,'purpleScroll', 'kill',24,true);
		--epicNote.Offset.X -= 12;
		if epicNote.Mania >= 0 then
			epicNote:AddSparrowXML(DeathNoteXml,'greenScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'redScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'blueScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'purpleScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'yellowScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'darkScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'blackScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'whiteScroll', 'kill',24,true);
			epicNote:AddSparrowXML(DeathNoteXml,'violetScroll', 'kill',24,true);
		end
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif(epicNote.Type=='Sword')then
		epicNote.IsSustain=false;
		epicNote.HealthLoss=.5;
		local swordNoteXML = game.ReplicatedStorage.Modules.Assets["SWORD_NOTE.xml"]
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets['SWORD_NOTE'].Image
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,1,true)
		setmetatable(epicNote,NoteClass)
		local animName = "Sword0"
		if(shared.songData.player2=='mika' or shared.songData.player2=='angry-child')then
			animName = 'Shadow0'
		elseif(shared.songData.player2=='army' or shared.songData.player2=='armyRight')then
			animName = 'spear0'
		end
		epicNote:AddSparrowXML(swordNoteXML,"sword",animName,24)
		epicNote:PlayAnimation("sword",true)
	elseif epicNote.Type =='MattCaution' then
		epicNote.CanSustain = false
		epicNote.shouldPress = true
		local liveNoteXml = game.ReplicatedStorage.Modules.Assets.noteSkins9K.ShaggyxMatt.XML
		epicNote.NoteObject.Image = game.ReplicatedStorage.Modules.Assets.noteSkins9K.ShaggyxMatt.Image
		epicNote.Animation = Sprite.new(epicNote.NoteObject,false,2,true)
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'live0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'live0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'live0000',24,true);
		epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'live0000',24,true);
		if epicNote.Mania >= 0 then
			epicNote:AddSparrowXML(liveNoteXml,'greenScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'redScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'blueScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'purpleScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'yellowScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'darkScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'blackScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'whiteScroll', 'live',24);
			epicNote:AddSparrowXML(liveNoteXml,'violetScroll', 'live',24);
		end
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
	elseif epicNote.Mania >= 0 then
		epicNote.Animation=Sprite.new(epicNote.NoteObject,false,2,true)
		setmetatable(epicNote,NoteClass)
		epicNote:AddSparrowXML(XMLModule,'greenScroll', 'green0',24);
		epicNote:AddSparrowXML(XMLModule,'redScroll', 'red0',24);
		epicNote:AddSparrowXML(XMLModule,'blueScroll', 'blue0',24);
		epicNote:AddSparrowXML(XMLModule,'purpleScroll', 'purple0',24);
		epicNote:AddSparrowXML(XMLModule,'yellowScroll', 'yellow0',24);
		epicNote:AddSparrowXML(XMLModule,'darkScroll', 'dark0',24);
		epicNote:AddSparrowXML(XMLModule,'blackScroll', 'black0',24);
		epicNote:AddSparrowXML(XMLModule,'whiteScroll', 'white0',24);
		epicNote:AddSparrowXML(XMLModule,'violetScroll', 'violet0',24);
		
		epicNote:AddSparrowXML(XMLModule,'purpleholdend', 'pruple end hold',24);
		epicNote:AddSparrowXML(XMLModule,'greenholdend', 'green hold end',24);
		epicNote:AddSparrowXML(XMLModule,'redholdend', 'red hold end',24);
		epicNote:AddSparrowXML(XMLModule,'blueholdend', 'blue hold end',24);
		epicNote:AddSparrowXML(XMLModule,'yellowholdend', 'yellow hold end',24);
		epicNote:AddSparrowXML(XMLModule,'darkholdend', 'dark hold end',24);
		epicNote:AddSparrowXML(XMLModule,'blackholdend', 'black hold end',24);
		epicNote:AddSparrowXML(XMLModule,'whiteholdend', 'white hold end',24);
		epicNote:AddSparrowXML(XMLModule,'violetholdend', 'violet hold end',24);
	
		epicNote:AddSparrowXML(XMLModule,'purplehold', 'purple hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'greenhold', 'green hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'redhold', 'red hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'bluehold', 'blue hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'yellowhold', 'yellow hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'darkhold', 'dark hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'blackhold', 'black hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'whitehold', 'white hold piece',24);
		epicNote:AddSparrowXML(XMLModule,'violethold', 'violet hold piece',24);
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].DirNames[noteData+1])
		--epicNote:PlayAnimation( (epicNote.Mania == 1 and DIrectionalShaggyP2Names or (epicNote.Mania == 2 and DirectionalShaggyP3Names or DirectionalNames))[noteData+1] )
	end
	
	epicNote.Animation.ScaleFactors = shared.noteScaleRatio;
	epicNote.Animation.UseScale=true;
	
	if(epicNote.PrevNote==nil)then
		epicNote.PrevNote=epicNote
	end
	
	if(epicNote.IsSustain and epicNote.PrevNote) then
		--epicNote.Score*=.2
		epicNote.PrevNote.HoldParent = true;
		epicNote.DefaultTransparency=.4 
		--epicNote.manualXOffset+=epicNote.Size.X/2
		
		epicNote.NoteObject.ZIndex=1
		epicNote.IsSusEnd=false;
		--epicNote:PlayAnimation((epicNote.Mania == 1 and SustainShaggyP2Animations or (epicNote.Mania == 2 and SustainShaggyP3Animations or SustainAnimations))[noteData+1] .. 'end')
		epicNote:PlayAnimation(maniaListThingy[epicNote.Mania].SusNames[noteData+1] .. "end")
		if Conductor.Downscroll then epicNote.Animation.FlipVertically = true end
		epicNote:FixSize()
		--epicNote.manualXOffset-=epicNote.Size.X/2
		if(epicNote.PrevNote.IsSustain)then
			epicNote.PrevNote.IsSusEnd=false;
			epicNote.PrevNote:PlayAnimation(maniaListThingy[epicNote.Mania].SusNames[noteData+1])
			--epicNote.PrevNote:PlayAnimation((epicNote.Mania == 1 and SustainShaggyP2Animations or (epicNote.Mania == 2 and SustainShaggyP3Animations or SustainAnimations))[noteData+1])
			epicNote.PrevNote.NoteObject.ScaleType=Enum.ScaleType.Tile
			epicNote.PrevNote.Scale.Y=Conductor.stepCrochet/100*epicNote.PrevNote.Scale.Y*1.5*(shared.getSpeed(epicNote.StrumTime));
			epicNote.NoteObject.Rotation = 0
			epicNote.PrevNote:FixSize()
		end
	end
	epicNote:Update()
	return epicNote
end

return NoteClass