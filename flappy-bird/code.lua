local Screen = GetPartFromPort(1, "Screen")
local Keyboard = GetPartFromPort(1, "Keyboard")
local bestScore = 0

Screen:ClearElements()

function AABBcoll(rectA, rectB)
    local ax2, bx2, ay2, by2 = rectA.Position.X.Scale + rectA.Size.X.Scale, rectB.Position.X.Scale + rectB.Size.X.Scale, rectA.Position.Y.Scale + rectA.Size.Y.Scale, rectB.Position.Y.Scale + rectB.Size.Y.Scale
    return ax2 > rectB.Position.X.Scale and bx2 > rectA.Position.X.Scale and ay2 > rectB.Position.Y.Scale and by2 > rectA.Position.Y.Scale
end

local bg = Screen:CreateElement("ImageLabel", {
    Image = "rbxassetid://10490634871",
    Size = UDim2.fromScale(1, 2),
    Position = UDim2.fromScale(0, -0.7),
    ZIndex = -10
})

local ground = Screen:CreateElement("ImageLabel", {
    Image = "rbxassetid://10490725123",
    Size = UDim2.fromScale(1.3, 0.35),
    Position = UDim2.fromScale(0, 0.85),
    BorderSizePixel = 0
})

local bird = Screen:CreateElement("ImageLabel", {
    Image = "rbxassetid://10489223093",
    Size = UDim2.fromScale(0.118, 0.08),
    AnchorPoint = Vector2.new(0.3, 0),
    Position = UDim2.fromScale(0.3, 0.43),
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
})

local hitbox = Screen:CreateElement("Frame", {
    Size = UDim2.fromScale(0.05, 0.04),
    Position = UDim2.fromScale(0.325, 0.432),
    BackgroundTransparency = 1,
    BorderSizePixel = 0
})

local birdFrames = {
    "rbxassetid://10489223093", "rbxassetid://10489223752", "rbxassetid://10489223093", "rbxassetid://10489222250"
}

local message = Screen:CreateElement("ImageLabel", {
    Image = "rbxassetid://10491032328",
    Size = UDim2.fromScale(0.63, 0.58),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.45),
    BackgroundTransparency = 1,
})

local numbers = {
    "10492479878",
    "10492590755",
    "10492480732",
    "10492489659",
    "10492490263",
    "10492490790",
    "10492492042",
    "10492493646",
    "10492494220",
    "10492533395"

}

local numbersalt = {
    "10500257412",
    "10500259747",
    "10500260335",
    "10500261224",
    "10500262067",
    "10500743338",
    "10500734924",
    "10501993565",
    "10501580362",
    "10500737419"

}

function NumDrawer(x, y, len, useAlt)
	local t = {}
    local size = UDim2.fromScale(0.08, 0.14)
    local numbers = numbers
    if useAlt then
        numbers = numbersalt
        size = UDim2.fromScale(0.04, 0.07)
    end
	for i=1, len do
		table.insert(t, Screen:CreateElement("ImageLabel", {
			Size = size;
			Position = UDim2.fromScale(x - i * size.X.Scale,y);
			Image = "";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ResampleMode = "Pixelated";
            ZIndex = 10
		}))
	end
	t.Update = function(val)
		for i,v in pairs(t) do
			if type(v) ~= "function" then
				v.Image =  ""
			end
		end
		for i=1, #val do
			t[tonumber(#val)-i+1].Image = "rbxassetid://" .. numbers[tonumber(string.sub(val, i, i))+1]
            if not useAlt then 
                t[tonumber(#val)-i+1].Position = UDim2.fromScale(x + (i * size.X.Scale) - (#val * size.X.Scale / 2), y)
            end
		end
	end
    t.Destroy = function()
        for i,v in pairs(t) do
            if type(v) ~= "function" then v:Destroy() end
        end
    end

	t.Update("0")
	return t
end

local scoreVal = NumDrawer(0.4, 0.01, 9)
local score = 0



local animateBird = true
local inTitle = true




local yv = 0
local yv_old = 0
local y = 0.43
local flaptime = 0
local gameover = false

Keyboard:Connect("KeyPressed", function(key)
    if key == Enum.KeyCode.W and not gameover then
        if inTitle then
            inTitle = false
            task.spawn(function()
                for i=1, 50 do
                    task.wait()
                    message.ImageTransparency += 0.05
                end
            end)
        end
        yv = -0.6
        animateBird = true
        flaptime = 0.7
        bird.Image = birdFrames
    end
end)

local aposition = 1
local last = 0
local pipeCountdown = 2
local pipes = {}
local medals = {
    "10500090039",
    "10500090689",
    "10500091381",
    "10500092020"
}

local function endGame()
    if not gameover then
        gameover = true
        local flash = Screen:CreateElement("Frame", {
            Size = UDim2.fromScale(1,1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            ZIndex = 99
        })
        for i=1, 3 do
            flash.BackgroundTransparency = 1-i/3
            task.wait()
        end

        for i=1, 5 do
            flash.BackgroundTransparency = i/5
            task.wait()
        end

        task.delay(1, function()

            local window = Screen:CreateElement("ImageLabel", {
                Size = UDim2.fromScale(0.8, 0.4),
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 1),
                Image = "rbxassetid://10500085762",
                BackgroundTransparency = 1,
                ResampleMode = "Pixelated",
                BorderSizePixel = 0
            })
    
            for i = 1, 50 do
                t = i / 50
                task.wait()
                window.Position = UDim2.fromScale(0.5, ((1 - (1 - t) * (1 - t)) * -0.8) + 1)
            end

            local endScoreVal = NumDrawer(0.8, 0.31, 3, true)
            local bestScoreVal = NumDrawer(0.8, 0.46, 3, true)
            bestScoreVal.Update(tostring(bestScore))

            for i = 1, score do
                endScoreVal.Update(tostring(i))
                task.wait()
            end
            local new
            if score > bestScore then
                bestScore = score
                bestScoreVal.Update(tostring(score))
                new = Screen:CreateElement("ImageLabel", {
                    Size = UDim2.fromScale(0.1, 0.04),
                    Position = UDim2.fromScale(0.59, 0.405),
                    Image = "rbxassetid://10502938824",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ResampleMode = "Pixelated"
                })
            end
            local medal
            if score >= 10 then
                medal = Screen:CreateElement("ImageLabel", {
                    Size = UDim2.fromScale(0.16, 0.16),
                    Position = UDim2.fromScale(0.185, 0.345),
                    Image = "rbxassetid://" .. medals[math.floor(math.clamp(score/10, 1, 4))],
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ResampleMode = "Pixelated"
                })
            end
            
            task.wait(7)

            flash.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            for i=1, 10 do
                flash.BackgroundTransparency = 1-i/10
                task.wait()
            end

            inTitle = true
            y = 0.43
            yv = 0
            score = 0
            scoreVal.Update("0")
            animateBird = true
            window:Destroy()
            endScoreVal.Destroy()
            bestScoreVal.Destroy()
            if medal then medal:Destroy() end
            if new then new:Destroy() end
            for i,v in pairs(pipes) do
                v:Destroy()
            end
            pipes = {}
            bird.Rotation = 0
            message.ImageTransparency = 0
            hitbox.Position = UDim2.new(0.325,0.432)
            pipeCountdown = 2
    
            for i=1, 10 do
                flash.BackgroundTransparency = i/10
                task.wait()
            end

            gameover = false

            flash:Destroy()
        end)
    end
end


while true do
    print(yv)
    local dt = math.clamp(task.wait(), 0, 0.2)
    if not gameover then
        ground.Position = UDim2.fromScale(ground.Position.X.Scale - dt/5, ground.Position.Y.Scale)
        if ground.Position.X.Scale <= -0.28 then
            ground.Position = UDim2.fromScale(0, ground.Position.Y.Scale)
        end
    end
    last += dt

    if animateBird and last >= 0.1 then
        last = 0
        aposition += 1
        if aposition >= 5 then
            aposition = 1
        end
        bird.Image = birdFrames[aposition]
        if inTitle then
            bird.Position = UDim2.fromScale(bird.Position.X.Scale, 0.43 + math.sin(tick()*5) * 0.01) -- math.sin(2 * math.pi() * tick())
        end
    end


    if not inTitle then
        yv += dt*1.3
        if yv >= 0 then
            yv += (yv/25)
        end
        yv = math.clamp(yv, -1, 1)
        y += (yv + yv_old) * 0.5 * dt
        if AABBcoll(hitbox, ground) then
            y = 0.8
            yv = 0
            endGame()
        else
            bird.Rotation = math.clamp(yv * 90, -30, 180)
        end
        bird.Position = UDim2.fromScale(bird.Position.X.Scale, y)
        hitbox.Position = UDim2.fromScale(bird.Position.X.Scale, y + 0.02)
       

        if flaptime > 0 then
            flaptime -= dt
            if flaptime <= 0 then
                animateBird = false
            end
        end

        pipeCountdown -= dt
        if pipeCountdown < 0 then
            pipeCountdown = 2.5
            local height = math.random()*0.38- 0.1
            local bottom = Screen:CreateElement("ImageLabel", {
                Image = "rbxassetid://10498724936",
                Size = UDim2.fromScale(0.18, 1.2),
                Position = UDim2.fromScale(1.2, height - 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = -1
            })
            local top = Screen:CreateElement("ImageLabel", {
                Image = "rbxassetid://10498699452",
                Size = UDim2.fromScale(0.18, 1.2),
                Position = UDim2.fromScale(1.2, height + 0.5),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = -1
            })

            local score = Screen:CreateElement("Frame", {
                Size = UDim2.fromScale(0.05, 0.3),
                Position = UDim2.fromScale(1.266, height+0.2),
                BorderSizePixel = 0,
                ZIndex = -1,
                BackgroundTransparency = 1
            })

            table.insert(pipes, top)
            table.insert(pipes, bottom)
            table.insert(pipes, score)
        end

        if not gameover then
            for i,pipe in pairs(pipes) do
                pipe.Position = UDim2.fromScale(pipe.Position.X.Scale - dt/5, pipe.Position.Y.Scale)
                if pipe.Position.X.Scale <= -0.2 then
                    pipe:Destroy()
                    table.remove(pipes, i)
                end
                if AABBcoll(hitbox, pipe) then
                    if pipe.ClassName == "Frame" then
                        score += 1
                        scoreVal.Update(tostring(score))
                        pipe:Destroy()
                        table.remove(pipes, i)
                    else
                        yv = math.clamp(yv, 0, 1)
                        endGame()
                    end
                end
            end
        end
    end

    yv_old = yv
end
