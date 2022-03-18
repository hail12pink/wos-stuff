local TouchScreen = GetPartFromPort(1, "TouchScreen")


TouchScreen:ClearElements()

local background = TouchScreen:CreateElement("ImageLabel", {
Position = UDim2.fromOffset(0, 0);
Size = UDim2.fromOffset(85 * 5, 155 * 5);
Image = "http://www.roblox.com/asset/?id=5041064379";
})


local scorerect = TouchScreen:CreateElement("Frame", {
Position = UDim2.fromOffset(0 - 50, 155*5/2 - 25);
Size = UDim2.fromOffset(150, 50);
Rotation = 90;
BorderSizePixel = 5;
BackgroundColor3 = Color3.new(0.4, 0.4, 0.4);
BorderColor3 = Color3.new(0.5, 0.5, 0.5);
})

local Rscore = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(0, 155*5/2 - 70);
Size = UDim2.fromOffset(50, 50);
Rotation = 270;
BorderSizePixel = 0;
BackgroundTransparency = 1;
TextColor3 = Color3.new(0.7, 0.4, 0.4);
TextStrokeTransparency = 0.5;
Font = "Arcade";
Text = "0";
TextScaled = true;
})

local Bscore = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(0, 155*5/2 + 25);
Size = UDim2.fromOffset(50, 50);
Rotation = 270;
BorderSizePixel = 0;
BackgroundTransparency = 1;
TextColor3 = Color3.new(0.4, 0.4, 0.7);
TextStrokeTransparency = 0.5;
Font = "Arcade";
Text = "0";
TextScaled = true;
})

local puck = TouchScreen:CreateElement("ImageLabel", {
Position = UDim2.fromOffset(85*5/2 - 30, 155*5/2 - 30);
Size = UDim2.fromOffset(60, 60);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Image = "http://www.roblox.com/asset/?id=5041127888";
})


local paddleR = TouchScreen:CreateElement("ImageLabel", {
Position = UDim2.fromScale(-500, -500);
Size = UDim2.fromOffset(80, 80);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Image = "http://www.roblox.com/asset/?id=5041129017";
})

local paddleB = TouchScreen:CreateElement("ImageLabel", {
Position = UDim2.fromScale(-500, -500);
Size = UDim2.fromOffset(80, 80);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Image = "http://www.roblox.com/asset/?id=5041128448";
})

local victory1 = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(85*5/2 - 175, 155*5/2 - 100);
Size = UDim2.fromOffset(350, 100);
BackgroundTransparency = 1;
BorderSizePixel = 0;
TextScaled = true;
TextColor3 = Color3.new(1, 1, 1);
TextStrokeTransparency = 0;
Rotation = 180;
Font = "Arcade";
Text = "";
})

local victory2 = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(85*5/2 - 175, 155*5/2);
Size = UDim2.fromOffset(350, 100);
BackgroundTransparency = 1;
BorderSizePixel = 0;
TextScaled = true;
TextColor3 = Color3.new(1, 1, 1);
TextStrokeTransparency = 0;
Rotation = 0;
Font = "Arcade";
Text = "";
})

local title = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(0 - 25, 155*5/2 - 125/2);
Size = UDim2.fromOffset(400, 100);
Rotation = 270;
BorderSizePixel = 0;
BackgroundTransparency = 1;
TextColor3 = Color3.new(1, 1, 1);
TextStrokeTransparency = 0;
Font = "Arcade";
Text = "AIR HOCKEY";
TextScaled = true;
})

local blueJoin = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(0 + 220, 155*5/2 + 150);
Size = UDim2.fromOffset(150, 150);
Rotation = 270;
BorderSizePixel = 5;
BorderColor3 = Color3.new(0.4, 0.4, 0.8);
BackgroundTransparency = 0;
BackgroundColor3 = Color3.new(0.2, 0.2, 0.8);
TextColor3 = Color3.new(1, 1, 1);
TextStrokeTransparency = 0;
Font = "Arcade";
Text = "BLUE PLAYER\nMOUSE OVER TO JOIN";
TextScaled = true;
TextXAlignment = "Center";
})

local redJoin = TouchScreen:CreateElement("TextLabel", {
Position = UDim2.fromOffset(0 + 220, 155*5/2 - 150*2);
Size = UDim2.fromOffset(150, 150);
Rotation = 270;
BorderSizePixel = 5;
BorderColor3 = Color3.new(0.8, 0.4, 0.4);
BackgroundTransparency = 0;
BackgroundColor3 = Color3.new(0.8, 0.2, 0.2);
TextColor3 = Color3.new(1, 1, 1);
TextStrokeTransparency = 0;
Font = "Arcade";
Text = "RED PLAYER\nMOUSE OVER TO JOIN";
TextScaled = true;
TextXAlignment = "Center";
})

local puckP = {
x = 85*5/2 - 30;
y = 155*5/2 - 30;
xv = 0;
yv = 0;
}

function titleScreen()
	puck:ChangeProperties({
		ImageTransparency = 1;
	})
	
	paddleB:ChangeProperties({
		ImageTransparency = 1;
	})
	
	paddleR:ChangeProperties({
		ImageTransparency = 1;
	})
	
	title:ChangeProperties({
	TextTransparency = 0;
	})
	blueJoin:ChangeProperties({
	Transparency = 0;
	})
	redJoin:ChangeProperties({
	Transparency = 0;
	})
	pointsB = 0
	pointsR = 0
	game = false
	playerB = nil
	playerR = nil
end

titleScreen()
game = false
	puck:ChangeProperties({
		Transparency = 1;
	})
local playerR = nil
local playerB = nil
local pointsB = 0
local pointsR = 0
local old = {}

function AABBcoll(rectA, rectB)
    local ax2, bx2, ay2, by2 = rectA.x + rectA.width, rectB.x + rectB.width, rectA.y + rectA.height, rectB.y + rectB.height
    return ax2 > rectB.x and bx2 > rectA.x and ay2 > rectB.y and by2 > rectA.y
end

TouchScreen:Connect("CursorMoved", function(cursor)
	if cursor.Player == playerR and game then
		cursor.Y = math.clamp(cursor.Y, 0, 155*5/2)
		paddleR:ChangeProperties({
			Position = UDim2.fromOffset(cursor.X - 40, cursor.Y - 40)
		})
		currentplayer = 0
	elseif cursor.Player == playerB and game then
		cursor.Y = math.clamp(cursor.Y, 155*5/2, 155*5)
		paddleB:ChangeProperties({
			Position = UDim2.fromOffset(cursor.X - 40, cursor.Y - 40)
		})
		currentplayer = 2
	end
	
	if not game then
		if pointAABBcoll({x = cursor.X, y = cursor.Y}, {x = 220, y = 155*5/2 + 150, width = 150, height = 150}) then
			if not playerB then
				blueJoin:ChangeProperties({
					Text = cursor.Player
				})
				playerB = cursor.Player
			end
		elseif playerB == cursor.Player then
			blueJoin:ChangeProperties({
				Text = "BLUE PLAYER\nMOUSE OVER TO JOIN"
			})
			playerB = nil
		end
		
		if pointAABBcoll({x = cursor.X, y = cursor.Y}, {x = 0 + 220, y = 155*5/2 - 150*2, width = 150, height = 150}) then
			if not playerR then
				redJoin:ChangeProperties({
					Text = cursor.Player
				})
				playerR = cursor.Player
			end
		elseif playerR == cursor.Player then
			redJoin:ChangeProperties({
				Text = "RED PLAYER\nMOUSE OVER TO JOIN"
			})
			playerR = nil
		end
		
		
		if playerR and playerB and playerR ~= playerB then
			game = true
			
			puck:ChangeProperties({
			ImageTransparency = 0;
			})

			paddleB:ChangeProperties({
			ImageTransparency = 0;
			})

			paddleR:ChangeProperties({
			ImageTransparency = 0;
			})
			title:ChangeProperties({
				Transparency = 1;
			})
			blueJoin:ChangeProperties({
				Transparency = 1;
			})
			redJoin:ChangeProperties({
				Transparency = 1;
			})
		end
	end

	local isColliding = math.abs((cursor.X - 40 - puckP.x) * (cursor.X - 40 - puckP.x) + (cursor.Y - 40 - puckP.y) * (cursor.Y - 40 - puckP.y)) < (40 + 30) * (40 + 30)
	if isColliding and old then
		--336216725
		puckP.xv = puckP.xv + ((cursor.X - old[1 + currentplayer]) / 5) + (((puckP.x + 30) - cursor.X) / 5)
		puckP.yv = puckP.yv + ((cursor.Y - old[2 + currentplayer]) / 5) + (((puckP.y + 30) - cursor.Y) / 5)
		local difference = Vector2.new(cursor.X - puckP.x, cursor.Y - puckP.y)
		
        puckP.x = puckP.x + ((15 + 30) - difference.X) / 4
        puckP.y = puckP.y + ((15 + 30) - difference.Y) / 4
	end
	
	old[1 + currentplayer] = cursor.X
	old[2 + currentplayer] = cursor.Y
end)

function pointAABBcoll(point, rectangle)
	local TopEdgeY = rectangle.y
	local BottomEdgeY = rectangle.y + rectangle.height
	local LeftEdgeX = rectangle.x
	local RightEdgeX = rectangle.x + rectangle.width
	return
	TopEdgeY < point.y and
	BottomEdgeY > point.y and
	LeftEdgeX < point.x and
	RightEdgeX > point.x
end


while true do
	if game then
		
		if puckP.xv > 0 then puckP.xv = puckP.xv - 0.5 end
		if puckP.xv < 0 then puckP.xv = puckP.xv + 0.5 end
		if puckP.yv > 0 then puckP.yv = puckP.yv - 0.5 end
		if puckP.yv < 0 then puckP.yv = puckP.yv + 0.5 end
		if math.floor(puckP.xv * 2) / 2 == 0 then puckP.xv = 0 end
		if math.floor(puckP.yv * 2) / 2 == 0 then puckP.yv = 0 end
		if puckP.xv > 0 then puckP.xv = puckP.xv - 0.5 end
		if puckP.xv < 0 then puckP.xv = puckP.xv + 0.5 end
		if puckP.yv > 0 then puckP.yv = puckP.yv - 0.5 end
		if puckP.yv < 0 then puckP.yv = puckP.yv + 0.5 end
		if math.floor(puckP.xv * 2) / 2 == 0 then puckP.xv = 0 end
		if math.floor(puckP.yv * 2) / 2 == 0 then puckP.yv = 0 end
		puckP.x = puckP.x + puckP.xv
		puckP.y = puckP.y + puckP.yv
		-- 85*5, 155*5
		
		if puckP.y < 0 or puckP.y > (155*5 - 60) then
			if not (puckP.x > 140 and puckP.x < 240) then
				puckP.yv = puckP.yv * -1
				puckP.y = math.clamp(puckP.y, 0, 155*5 - 60)
			elseif puckP.y < -60 or puckP.y > 155*5 then
				local winner, wincolor
				if puckP.y < -60 then
					winner = "BLUE"
					pointsB = pointsB + 1
					wincolor = {0.4, 0.4, 0.8}
				else
					winner = "RED"
					pointsR = pointsR + 1
					wincolor = {0.8, 0.4, 0.4}
				end
				
				victory1:ChangeProperties({
					Text = winner .. " SCORES";
					TextColor3 = Color3.new(wincolor[1], wincolor[2], wincolor[3])
				})
				
				victory2:ChangeProperties({
					Text = winner .. " SCORES";
					TextColor3 = Color3.new(wincolor[1], wincolor[2], wincolor[3])
				})
				
				wait(2)
				
				victory1:ChangeProperties({
					Text = "";
				})
				
				victory2:ChangeProperties({
					Text = "";
				})
				
				Bscore:ChangeProperties({
					Text = pointsB;
				})
				
				Rscore:ChangeProperties({
					Text = pointsR;
				})
				
				if pointsR > 4 or pointsB > 4 then
					victory1:ChangeProperties({
						Text = winner .. " WINS";
						TextColor3 = Color3.new(wincolor[1], wincolor[2], wincolor[3])
					})
				
					victory2:ChangeProperties({
						Text = winner .. " WINS";
						TextColor3 = Color3.new(wincolor[1], wincolor[2], wincolor[3])
					})
					
					wait(2)
					titleScreen()
					pointsB = 0
					pointsR = 0
					playerB = nil
					playerR = nil
					game = false
					Bscore:ChangeProperties({
					Text = pointsB;
					})

					Rscore:ChangeProperties({
					Text = pointsR;
					})
					victory1:ChangeProperties({
						Text = "";
						TextColor3 = Color3.new(wincolor[1], wincolor[2], wincolor[3])
					})
				
					victory2:ChangeProperties({
						Text = "";
						TextColor3 = Color3.new(wincolor[1], wincolor[2], wincolor[3])
					})
				end
			
				puckP = {
				x = 85*5/2 - 30;
				y = 155*5/2 - 30;
				xv = 0;
				yv = 0;
				}
			end
		end
		
		if puckP.x < 30 or puckP.x > (85*5 - 60) then
			puckP.xv = puckP.xv * -1
			puckP.x = math.clamp(puckP.x, 0, 85*5 - 60)

		end

		puck:ChangeProperties({
			Position = UDim2.fromOffset(puckP.x, puckP.y)
		})
	end
	
end
