local Conductor = require(script.Parent.Conductor)
return {
	ratingStrings = {
		"sick";
		"good";
		"bad";
		"trash";
	};
	ratingWindow = {
		50, -- sick
		130, -- good
		148, -- bad
		166 -- trash
	};
	ratingWeights = {
		1, -- sick
		.8, -- good
		.5, -- bad
		.1 -- trash
	};
	ratingNames = {
		sick="rbxassetid://7224617321",
		good="rbxassetid://7224617575",
		bad="rbxassetid://7224617690",
		trash="rbxassetid://7224617840";
	};
	GetScore = function(self,rating)
		if(rating=='sick') then
			return 380
		elseif(rating=='good')then
			return 150
		elseif(rating==nil or rating=='miss')then
			return -50;
		else
			return 0
		end
	end;
	GetAccuracy=function(self,rating)
		local idx = table.find(self.ratingStrings,rating)
		return self.ratingWeights[idx] or 1
	end;
	GetRating = function(self,ms)
		local diff = math.abs(ms);
		for i = 1,#self.ratingWindow do
			local timing = self.ratingWindow[i];
			local rating = self.ratingStrings[i];
			if(diff<=timing)then
				return rating
			end
		end
	end;
	
}
