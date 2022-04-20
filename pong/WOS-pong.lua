local graphics = GetPartFromPort(1, "Screen")
local player1keyboard = GetPartFromPort(3, "Keyboard") -- left side
local player2keyboard = GetPartFromPort(2, "Keyboard") -- right side
local score1, score2 = 0, 0
local player1y, player2y, player1paddle, player2paddle, ball, game, ballx, bally, yBounce, xBounce, score1box, score2box
function initTitle()
	graphics:ClearElements()
	game = false
	score1 = 0
	score2 = 0
	title = graphics:CreateElement("TextBox", {
		Size = UDim2.fromScale(1, 0.5);
		Position = UDim2.fromScale(0, 0);
		TextStrokeTransparency = 0;
		Font = "Arcade";
		Text = "POG";
		TextScaled = true;
		TextColor3 = Color3.new(1, 1, 1);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
	})
	subtitle = graphics:CreateElement("TextBox", {
		Size = UDim2.fromScale(1, 0.5);
		Position = UDim2.fromScale(0, 0.5);
		TextStrokeTransparency = 0;
		Font = "Arcade";
		Text = "Either player press anything to start.";
		TextScaled = true;
		TextColor3 = Color3.new(1, 1, 1);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
	})
end


function initGame()
	graphics:ClearElements()
	if score1 > 4 or score2 > 4 then
		if score1 > 4 then
			wintext = graphics:CreateElement("TextBox", {
				Size = UDim2.fromScale(1, 1);
				Position = UDim2.fromScale(0, 0);
				TextStrokeTransparency = 0;
				Font = "Arcade";
				Text = "LEFT PLAYER WINS";
				TextScaled = true;
				TextColor3 = Color3.new(1, 1, 1);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
			})
			task.wait(2)
			initTitle()
		else
			wintext = graphics:CreateElement("TextBox", {
				Size = UDim2.fromScale(1, 1);
				Position = UDim2.fromScale(0, 0);
				TextStrokeTransparency = 0;
				Font = "Arcade";
				Text = "RIGHT PLAYER WINS";
				TextScaled = true;
				TextColor3 = Color3.new(1, 1, 1);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
			})
			task.wait(2)
			initTitle()
		end
	else
		player1paddle = graphics:CreateElement("Frame", {
			Size = UDim2.fromScale(0.05, 0.25);
			Position = UDim2.fromScale(0.05, 0.05);
			BackgroundTransparency = 0;
			BackgroundColor3 = Color3.new(1, 1, 1);
			BorderSizePixel = 0;
		})
		player2paddle = graphics:CreateElement("Frame", {
			Size = UDim2.fromScale(0.05, 0.25);
			Position = UDim2.fromScale(0.9, 0.05);
			BackgroundTransparency = 0;
			BackgroundColor3 = Color3.new(1, 1, 1);
			BorderSizePixel = 0;
		})
		ball = graphics:CreateElement("Frame", {
			Size = UDim2.fromScale(0.03, 0.05);
			Position = UDim2.fromScale(0.5, 0.5);
			BorderSizePixel = 0;
			BackgroundColor3 = Color3.new(1, 1, 1);
		})
		score1box = graphics:CreateElement("TextBox", {
			Size = UDim2.fromScale(0.06, 0.1);
			Position = UDim2.fromScale(0.25, 0.05);
			TextStrokeTransparency = 0;
			Font = "Arcade";
			Text = score1;
			TextScaled = true;
			TextColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		})
		score2box = graphics:CreateElement("TextBox", {
			Size = UDim2.fromScale(0.06, 0.1);
			Position = UDim2.fromScale(0.75, 0.05);
			TextStrokeTransparency = 0;
			Font = "Arcade";
			Text = score2;
			TextScaled = true;
			TextColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		})
		task.wait(1)
		ballx = 0.5
		bally = 0.5
		xBounce = 0.01
		yBounce = -0.02
		player1y = 0.05
		player2y = 0.05
		game = true
	end
end


initTitle()

function KeyInput(player, key)
	if game then
		local mod = 0
		if key == "W" then
			mod = -0.05
		elseif key == "S" then
			mod = 0.05
		end
		if player == 1 then
			player1y = player1y + mod
			if player1y < 0.05 then player1y = 0.05 end
			if player1y > 0.70 then player1y = 0.70 end
			player1paddle:ChangeProperties({
				Position = UDim2.new(0.05, 0, player1y, 0)
			})
		else
			player2y = player2y + mod
			if player2y < 0.05 then player2y = 0.05 end
			if player2y > 0.70 then player2y = 0.70 end
			player2paddle:ChangeProperties({
				Position = UDim2.new(0.9, 0, player2y)
			})
		end
	else
		initGame()
	end
end

player1keyboard:Connect("KeyPressed", function(key) KeyInput(1, key) end)
player2keyboard:Connect("KeyPressed", function(key) KeyInput(2, key) end)


function AABBcoll(rectA, rectB)
    local ax2, bx2, ay2, by2 = rectA.x + rectA.width, rectB.x + rectB.width, rectA.y + rectA.height, rectB.y + rectB.height
    return ax2 > rectB.x and bx2 > rectA.x and ay2 > rectB.y and by2 > rectA.y
end

local rectP1 = {x = 0.05, y = player1y, width = 0.05, height = 0.25}
local rectP2 = {x = 0.9, y = player2y, width = 0.05, height = 0.25}
local rectBall = {x = ballx, y = bally, width = 0.03, height = 0.05}
while true do
	if game then
		if bally < 0 then yBounce = 0.02 end
		if bally > 1 - 0.05 then yBounce = -0.02 end
		
		if ballx < 0 then
			score2 = score2 + 1
			initGame() 
		end
		if ballx > 1.05 then 
			score1 = score1 + 1
			initGame()
		end
		
		rectP1.y = player1y
		rectP2.y = player2y
		rectBall.x = ballx
		rectBall.y = bally

		if AABBcoll(rectP1, rectBall) then
			xBounce = 0.01
		elseif AABBcoll(rectP2, rectBall) then
			xBounce = -0.01
		end
		
		ballx = ballx + xBounce
		bally = bally + yBounce
		ball:ChangeProperties({
			Position = UDim2.new(ballx, 0, bally, 0)
		})
	end
end
