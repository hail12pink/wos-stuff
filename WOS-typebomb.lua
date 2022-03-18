local graphics = GetPartFromPort(1, "Screen")
local input = GetPartFromPort(2, "Keyboard")
local title, subtext, game
graphics:ClearElements()
local bg
local function title()
	game = false
	bg = graphics:CreateElement("ImageLabel", {
		Image = "http://www.roblox.com/asset/?id=544449328";
		Size = UDim2.fromScale(1, 1);
		Position = UDim2.fromScale(0, 0);
		BackgroundColor3 = Color3.new(1, 1, 1);
		BackgroundTransparency = 0;
		ZIndex = -10;
	})
	title = graphics:CreateElement("TextLabel", {
		Size = UDim2.fromScale(1, 0.25);
		Position = UDim2.fromScale(0, 0);
		TextStrokeTransparency = 0.5;
		TextStrokeColor3 = Color3.new(0, 0, 0);
		Font = "SciFi";
		Text = "Type Bomb";
		TextScaled = true;
		TextColor3 = Color3.new(1, 1, 1);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
	})
	subtext = graphics:CreateElement("TextLabel", {
		Size = UDim2.fromScale(1, 0.25);
		Position = UDim2.fromScale(0, 0.25);
		TextStrokeTransparency = 0.5;
		Font = "SourceSans";
		Text = "Type anything to start";
		TextScaled = true;
		TextColor3 = Color3.new(1, 1, 1);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
	})
end

local selection

local function keyInput(text)
	if game == false then
		game = true
		title:ChangeProperties({
			Text = ""
		})
		subtext:ChangeProperties({
			Text = ""
		})
	else
		if string.sub(text, 0, string.len(text) - 1) == selection.word then
			selection.element:Destroy()
			selection.disabled = true
			table.foreach(bombs, function(key, v)
				if v.word == selection.word then
					table.remove(v, key)
				end
			end)
		end
	end
end

local words = {"hello", "aargh", "bruh", "apple", "arc", "linear", "realized", "happy", "pencils", "mystery",
"goodbye", "seen", "unheard", "well", "eating", "running", "jumping", "pelot", "iron", "grass", "greeting", "known", "ironically", "bruh", "lizard", "retry"}
local bombs = {}
local values = {}
local function insert(key, value)
	table.insert(values, value.x)
end


local function checkMax(i)
	values = {}
	table.foreach(bombs, insert)
	if #values == 1 then
		return values[1]
	elseif #values == 2 then
		return math.max(values[1], values[2])
	elseif #values == 3 then
		return math.max(values[1], values[2], values[3])
	end
end

local function update(i, self)
	if self.disabled then
		table.remove(bombs, i)
		return
	end
	self.x = self.x + 0.01
	if self.x > 1 then
		graphics:ClearElements()
		bombs = {}
		game = false
		bg = graphics:CreateElement("ImageLabel", {
			Image = "http://www.roblox.com/asset/?id=544449328";
			Size = UDim2.fromScale(1, 1);
			Position = UDim2.fromScale(0, 0);
			BackgroundColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = 0;
			ZIndex = -10;
		})
		title = graphics:CreateElement("TextLabel", {
			Size = UDim2.fromScale(1, 0.25);
			Position = UDim2.fromScale(0, 0);
			TextStrokeTransparency = 0.5;
			TextStrokeColor3 = Color3.new(0, 0, 0);
			Font = "SciFi";
			Text = "Type Bomb";
			TextScaled = true;
			TextColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		})
		subtext = graphics:CreateElement("TextLabel", {
			Size = UDim2.fromScale(1, 0.25);
			Position = UDim2.fromScale(0, 0.25);
			TextStrokeTransparency = 0.5;
			Font = "SourceSans";
			Text = "Type anything to start";
			TextScaled = true;
			TextColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		})
		return
	end
	self.element:ChangeProperties({
		Position = UDim2.fromScale(self.x, self.y)
	})
	if checkMax(self.x) == self.x then
		selection = self
		self.element:ChangeProperties({
			TextColor3 = Color3.new(1, 1, 0);
		})
	end
end

local function newText()
	local txt = words[math.random(1, #words)]
	if string.find(txt, "#") then return end
	local bomb = {}
	bomb.y = math.random(0, 9) / 10
	bomb.x = -0.3
	bomb.word = txt
	bomb.element = graphics:CreateElement("TextLabel", {
		Size = UDim2.fromScale(0.15, 0.1);
		Position = UDim2.fromScale(bomb.x, bomb.y);
		Text = txt;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		TextColor3 = Color3.new(1, 1, 1)
	})
	setmetatable(bomb, bombs)
	table.insert(bombs, bomb)
end


input:ConnectToEvent("TextInputted", keyInput)
title()

local timer = 0
while true do
	if game then
		timer = timer + 0.1
		if timer > 5 then
			timer = 0
			newText()
		end
		table.foreach(bombs, update)
	end
end

