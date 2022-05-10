local graphics = GetPartFromPort(1, "Screen")
local blue = GetPort(2)
local yellow = GetPort(3)
local green = GetPort(4)
local red = GetPort(5)
local colors = {red, green, yellow, blue}
local colorstring = {"red", "green", "yellow", "blue"}
local positions = {{0.17, 0.25}, {1 - 0.3 - 0.17, 0.25}, {0.17, 0.25 + 0.35}, {1 - 0.3 - 0.17, 0.25 + 0.35}}
local rgb = {{0.5, 0.2, 0.2}, {0.2, 0.5, 0.2}, {0.5, 0.5, 0.2}, {0.2, 0.2, 0.5}}
local rgb_active = {{1, 0, 0}, {0, 1, 0}, {1, 1, 0}, {0, 0, 1}}
local colorrects = {}
local PressButtonEnabled = false
local score = 0
local pattern = {}
local gameover = false

graphics:ClearElements()

local statetext = graphics:CreateElement("TextBox", {
	Size = UDim2.fromScale(0.5, 0.2);
	Position = UDim2.fromScale(0.25, 0);
	TextStrokeTransparency = 0.5;
	Font = "Arcade";
	Text = "WAITING";
	TextScaled = true;
	TextColor3 = Color3.new(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
})
local scoretext = graphics:CreateElement("TextBox", {
	Size = UDim2.fromScale(0.15, 0.15);
	Position = UDim2.fromScale(0, 0);
	TextStrokeTransparency = 0.5;
	Font = "Arcade";
	Text = 0;
	TextScaled = true;
	TextColor3 = Color3.new(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
})

function updateState(text)
	statetext:ChangeProperties({
		Text = text;
	})
end

function updateScore()
	scoretext:ChangeProperties({
		Text = score
	})
end

local plrSequence = {}
local hold = false
local function onColorClick(color, i, rect, skipCheck)
	if PressButtonEnabled == true or skipCheck == true then
		if gameover then
			gameover = false
			rand()
		end
		rect:ChangeProperties({
			BackgroundColor3 = Color3.new(rgb_active[i][1], rgb_active[i][2], rgb_active[i][3])
		})
		task.wait(0.5)
		rect:ChangeProperties({
			BackgroundColor3 = Color3.new(rgb[i][1], rgb[i][2], rgb[i][3])
		})
		if skipCheck == false then
			table.insert(plrSequence, i)
			if #plrSequence >= #pattern and not hold then
				if table.concat(plrSequence) == table.concat(pattern) then
					updateState("NICE!")
					score = score + 1
					updateScore()
					hold = true
					plrSequence = {}
					PressButtonEnabled = false
					task.wait(1)
					rand()
				else
					updateState("GAME OVER")
					score = 0
					updateScore()
					gameover = true
					hold = true
					plrSequence = {}
					updateScore()
					PressButtonEnabled = false
					task.wait(1)
					PressButtonEnabled = true
					updateState("PRESS BUTTON TO START")
				end
			end
		end
	end
end

function rand()
	pattern = {}
	PressButtonEnabled = false
	plrSequence = {}
	updateState("COPY THIS")
	hold = false
	task.wait(0.5)
	for i = 1, math.random(3, 3 + (score/2)) do
		table.insert(pattern, math.random(1, 4))
	end
	for i,v in pairs(pattern) do
		onColorClick(colorstring[v], v, colorrects[v], true)
		task.wait(1 - (score / 10))
	end
	PressButtonEnabled = true
	for i = 1, 10 do
		task.wait(1 - (score / 15))
		if hold then return end
		updateState(i)
	end
	updateState("GAME OVER")
	score = 0
	plrSequence = {}
	updateScore()
	gameover = true
	PressButtonEnabled = false
	task.wait(1)
	PressButtonEnabled = true
	updateState("PRESS BUTTON TO START")
end

for i,v in pairs(colors) do
	local crect = graphics:CreateElement("Frame", {
		BackgroundColor3 = Color3.new(rgb[i][1], rgb[i][2], rgb[i][3]);
		Position = UDim2.fromScale(positions[i][1], positions[i][2]);
		Size = UDim2.fromScale(0.3, 0.3);
		BorderSizePixel = 5;
		BorderColor3 = Color3.new(0.6, 0.6, 0.6)
	})
	table.insert(colorrects, crect)
	colors[i]:Connect("Triggered", function() onColorClick(colorstring[i], i, crect, false) end)
end

rand()
