--[[

STUFF (all on port 1):

Screen, (display)
Keyboard, (input)
Button (off button)

CONTROLS (keyboard):

R - Rotate
A - Left
D - Right

]]--

local Screen      = GetPartFromPort(1, "Screen")
local Keyboard    = GetPartFromPort(1, "Keyboard")

Screen:ClearElements()
local bg = Screen:CreateElement("ImageLabel", {
	Size = UDim2.new(1, 0, 1, 0);
	Position = UDim2.new(0, 0, 0, 0);
	Image = "rbxassetid://8991379639";
	ImageColor3 = Color3.fromRGB(162,203,153);
	ResampleMode = "Pixelated";
})


local assets = {
	blocks = {
		[0] = "",
		"8991383511", -- 1: J
		"8991384086", -- 2: L 
		"8991385084", -- 3: O
		"8991386042", -- 4: S
		"8991386803", -- 5: T
		"8991501198", -- 6: Z
		"8991381252", -- 7: I Top
		"8991381961", -- 8: I Med
		"8991382807", -- 9: I Bottom
		"9056710996", -- 10: I Side Top
		"9056711273", -- 11: I Side Med
		"9056711975", -- 12: I Side Bottom

	};
	pieces = {
		"9050471489", -- 1: J
		"9050471979", -- 2: L
		"9050335948", -- 3: O
		"9050449206", -- 4: S
		"9050472922", -- 5: T
		"9050337273", -- 6: Z
		"9082101911", -- 7: I
	};
	numbers = {
		"9057994575",
		"9057285217",
		"9057285433",
		"9057285755",
		"9057286111",
		"9057286326",
		"9057286751",
		"9057286968",
		"9057287232",
		"9057287484"
	}
}

local blockdata = {
	{
		{1, 0, 0},
		{1, 1, 1},
		{0, 0, 0},
	},
	{
		{0, 0, 1},
		{1, 1, 1},
		{0, 0, 0},
	},
	{
		{1, 1},
		{1, 1}
	},
	{
		{0, 1, 1},
		{1, 1, 0},
		{0, 0, 0}
	},
	{
		{0, 1, 0},
		{1, 1, 1},
		{0, 0, 0}
	},
	{
		{1, 1, 0},
		{0, 1, 1},
		{0, 0, 0}
	},
	{
		{0, 2, 0, 0},
		{0, 3, 0, 0},
		{0, 3, 0, 0},
		{0, 4, 0, 0}
	}
}

local direction = {
	[0] = {[2] = 7, [3] = 8, [4] = 9};
	[90] = {[2] = 12, [3] = 11, [4] = 10};
	[180] = {[2] = 9, [3] = 8, [4] = 7};
	[270] = {[2] = 10, [3] = 11, [4] = 12};
}

-- stolen from stackexchange ez
function rotate_CCW_90(m)
	local rotated = {}
	for c, m_1_c in ipairs(m[1]) do
		local col = {m_1_c}
		for r = 2, #m do
			col[r] = m[r][c]
		end
		table.insert(rotated, 1, col)
	end
	return rotated
end

local grid = {}
local imgGrid = {} 

for y = 1, 20 do
	grid[y] = {}
	imgGrid[y] = {}
	for x = 1, 10 do
		local image = Screen:CreateElement("ImageLabel", {
			Size = UDim2.fromScale(0.0523, 0.0555);
			Position = UDim2.fromScale(x * 0.0523, y * 0.0555 - 0.0555);
			Image = "";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ImageColor3 = Color3.fromRGB(162,203,153);
			ResampleMode = "Pixelated";
		})
		grid[y][x] = {0, 0}
		imgGrid[y][x] = image
	end
end

function NumDrawer(x, y, len)
	local t = {}
	for i=1, len do
		table.insert(t, Screen:CreateElement("ImageLabel", {
			Size = UDim2.fromScale(0.04, 0.049);
			Position = UDim2.fromScale(x - (i*0.0523), y );
			Image = "";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ImageColor3 = Color3.fromRGB(162,203,153);
			ResampleMode = "Pixelated";
		}))
	end
	t.Update = function(val)
		for i,v in pairs(t) do
			if type(v) ~= "function" then
				v.Image =  ""
			end
		end
		for i=1, #val do
			print(tonumber(#val)-i)
			t[tonumber(#val)-i+1].Image = "rbxassetid://" .. assets.numbers[tonumber(string.sub(val, i, i))+1]
		end
	end

	t.Update("0")
	return t
end

local score = 0
local scoreVal = NumDrawer(0.952, 0.1734375, 6)
local level = 0
local levelVal = NumDrawer(0.952, 0.39, 2)
local lines = 0
local levelProg = 0
local linesVal = NumDrawer(0.952, 0.56, 3)

local linesToScore = {
	40, 100, 300, 1200
}


local speed = 0.3
local next
local current
local currentTab
local currentX, currentY
local rotation = 0

function UpdateGrid()
	for y = 1, 20 do
		for x = 1, 10 do
			local cell = grid[y][x]
			imgGrid[y][x].Image = "rbxassetid://" .. assets.blocks[cell[1]]
			for cY, tab in pairs(currentTab) do
				for cX, isOn in pairs(tab) do
					if cX + currentX == x and cY + currentY == y and isOn >= 1 then
						if isOn == 1 then
							imgGrid[y][x].Image = "rbxassetid://" ..  assets.blocks[current]
						else
							imgGrid[y][x].Image = "rbxassetid://" ..  assets.blocks[direction[rotation][isOn]]
						end
					end
				end
			end
		end
	end
end

local next = Screen:CreateElement("ImageLabel", {
	Size = UDim2.fromScale(0.523, 1);
	Position = UDim2.fromScale(0.735 , 0.777);
	Image = "";
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	ImageColor3 = Color3.fromRGB(162,203,153);
	ResampleMode = "Pixelated";
})

local nextPiece = math.random(1, 7)
function GenerateNewPiece()
	current = nextPiece
	nextPiece = math.random(1,7)
	currentTab = blockdata[current]
	currentX = 4
	currentY = 0
	rotation = 0
	next.Image = "rbxassetid://" .. assets.pieces[nextPiece]
	local nextTab = blockdata[nextPiece]
	next.Size = UDim2.fromScale(#nextTab * 0.0523, #nextTab[1] * 0.0555)
end
GenerateNewPiece()

function TestCollision(shape, xShift, yShift)
	for cY, tab in pairs(shape) do
		for cX, isOn in pairs(tab) do
			local x = cX + currentX + xShift
			local y = cY + currentY + yShift
			local gridPos
			if grid[y] and grid[y][x] then
				gridPos = grid[y][x][1]
			else
				gridPos = nil
			end
			if isOn >= 1 and (x > 10 or x < 1 or y > 18 or not (gridPos == 0 or gridPos == nil)) then
				return true
			end
		end
	end

	return false
end

Keyboard:Connect("KeyPressed", function(key)
	print(key)

	if key == Enum.KeyCode.A then
		print("eft")
		
		if current then
			if not TestCollision(currentTab, -1, 0) then
				currentX = currentX - 1
				UpdateGrid()
			end
		end
	elseif key == Enum.KeyCode.D then
		print("right")
		if current then
			if not TestCollision(currentTab, 1, 0) then
				currentX = currentX + 1
				UpdateGrid()
			end
		end
	elseif key == Enum.KeyCode.R then
		print("rotate")
		
		if current then
			local rotated = rotate_CCW_90(rotate_CCW_90(rotate_CCW_90(currentTab)))
			local pos = {0, -1, 1, -2, 2}
			for _,v in pairs(pos) do
				if not TestCollision(rotated, v, 0) then
					currentTab = rotated
					currentX = currentX + v
					rotation += 90
					if rotation == 360 then rotation = 0 end
					return
				end
			end
		end
	end
end)

local endLoop = false

GetPartFromPort(1, "Button"):Connect("OnClick", function()
	endLoop = true
end)

local placing = false



while task.wait(speed) do
	if endLoop then 
		Screen:ClearElements()
		error() 
	end
	if current then
		if not TestCollision(currentTab, 0, 1) then
			currentY = currentY + 1
		else
			if placing == true then
				if currentY == 0 then
					currentTab = {{0}}
					task.wait(0.1)
					for y = 1, 20 do
						for x = 1, 10 do
							grid[20-y+1][x][1] = 2
						end
						UpdateGrid()
						task.wait(0.05)
					end
					task.wait(0.2)
					local gameover = Screen:CreateElement("ImageLabel", {
						Size = UDim2.fromScale(0.523, 1);
						Position = UDim2.fromScale(0.0523, 0);
						Image = "rbxassetid://9081027252";
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ImageColor3 = Color3.fromRGB(162,203,153);
					})

					current = nil
				else 
					placing = false
					for cY, tab in pairs(currentTab) do
						for cX, isOn in pairs(tab) do
							if isOn >= 1 then
								local x = cX + currentX
								local y = cY + currentY
								if isOn == 1 then
									grid[y][x][1] = current
								else
									grid[y][x][1] = direction[rotation][isOn]
								end
							end
						end
					end
					local linesCleared = {}
					local flashers = {}
					local didClear = false
					for y = 1, 20 do
						local blockCount = 0
						for x = 1, 10 do
							local cell = grid[y][x]
							if cell[1] ~= 0 then
								blockCount = blockCount + 1
								if blockCount == 10 then
									table.insert(linesCleared, y)
									table.insert(flashers, Screen:CreateElement("TextLabel", 
										{
											Text = "";
											Position = UDim2.fromScale(0.0523, y * 0.0555 - 0.0555);
											Size = UDim2.fromScale(0.523, 0.0555);
											BackgroundColor3 =  Color3.fromRGB(63, 83, 49);
											BorderSizePixel = 0;
											ZIndex=100;
										}))
								end
							end
						end
					end
					if #linesCleared > 0 then
						for i=1, 3 do
							for _,v in pairs(flashers) do
								v.BackgroundTransparency = 1
							end
							task.wait(0.2)
							for _,v in pairs(flashers) do
								v.BackgroundTransparency = 0
							end
							task.wait(0.2)
						end
						for _,v in pairs(flashers) do
							v:Destroy()
						end
						for _,v in pairs(linesCleared) do
							table.remove(grid, v)
							table.insert(grid, 1, {{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0}})
						end
						score = score + linesToScore[#linesCleared] * (level + 1)
						scoreVal.Update(tostring(score))
						lines = lines + #linesCleared
						levelProg = levelProg + #linesCleared
						if levelProg >= 10 then
							levelProg = 0
							level = level + 1
							speed = speed / 1.5
						end
						linesVal.Update(tostring(lines))
						linesCleared = {}
						flashers = {}
					end
					task.wait(0.2)
					GenerateNewPiece()
				end
			else
				placing = true
			end
		end
		UpdateGrid()
	end
end
