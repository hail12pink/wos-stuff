-- WOS Tetris
-- sugar plum fairy audio id 5670198522

local Screen      = GetPartFromPort(1, "Screen")
local ButtonRight = GetPartFromPort(1, "Button")
local ButtonUp    = GetPartFromPort(2, "Button")
local ButtonLeft  = GetPartFromPort(3, "Button")
local ButtonDown  = GetPartFromPort(4, "Button")
local Speaker     = GetPartFromPort(5, "Speaker")

Speaker:ClearSounds()

local LoopingSounds = {}

function PlayAudio(position, speed, endtime, loop, loopname)
	local sound = Speaker:LoadSound("rbxassetid://9041444475")
	sound.TimePosition = position
	sound.PlaybackSpeed = speed
	sound.Volume = 2
	sound:Play() 
	if loop then LoopingSounds[loopname] = true end
	task.spawn(function() 
			task.wait(endtime)
			if loopname and LoopingSounds[loopname] then
				PlayAudio(position, speed, endtime, loop, loopname)
			end
			sound:Stop() -- this is objectively stupid
		end)
	return sound
end

Screen:ClearElements()
local bg = Screen:CreateElement("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0);
			Position = UDim2.new(0, 0, 0, 0);
			Image = "rbxassetid://8991379639";
			ImageColor3 = Color3.fromRGB(162,203,153);
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
	};
	pieces = {
		"8991401855", -- 1: J
		"8991403114", -- 2: L
		"8991403723", -- 3: O
		"8991404976", -- 4: S
		"8991405800", -- 5: T
		"8991406495", -- 6: Z
		"8991400935", -- 7: I
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
		{0, 1, 0, 0},
		{0, 1, 0, 0},
		{0, 1, 0, 0},
		{0, 1, 0, 0}
	}
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
		})
		grid[y][x] = {0, 0}
		imgGrid[y][x] = image
	end
end

local speed = 0.2
local next
local current
local currentTab
local currentX, currentY

function UpdateGrid()
	for y = 1, 20 do
		for x = 1, 10 do
			local cell = grid[y][x]
			imgGrid[y][x].Image = "rbxassetid://" .. assets.blocks[cell[1]]
			for cY, tab in pairs(currentTab) do
				for cX, isOn in pairs(tab) do
					if cX + currentX == x and cY + currentY == y and isOn == 1 then
						imgGrid[y][x].Image = "rbxassetid://" ..  assets.blocks[current]
					end
				end
			end
		end
	end
end

function GenerateNewPiece()
	current = math.random(1, 7)
	currentTab = blockdata[current]
	currentX = 4
	currentY = 0
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
			if isOn == 1 and (x > 10 or x < 1 or y > 18 or not (gridPos == 0 or gridPos == nil)) then
				return true
			end
		end
	end

	return false
end

ButtonLeft:Connect("OnClick", function()
	if current then
		if not TestCollision(currentTab, -1, 0) then
			currentX = currentX - 1
			UpdateGrid()
		end
	end
end)

ButtonRight:Connect("OnClick", function()
	if current then
		if not TestCollision(currentTab, 1, 0) then
			currentX = currentX + 1
		end
	end
end)

ButtonUp:Connect("OnClick", function()
	if current then
		local rotated = rotate_CCW_90(rotate_CCW_90(rotate_CCW_90(currentTab)))
		local pos = {0, -1, 1, -2, 2}
		for _,v in pairs(pos) do
			if not TestCollision(rotated, v, 0) then
				currentTab = rotated
				currentX = currentX + v
				return
			end
		end
	end
end)

local endLoop = false

GetPartFromPort(6, "Button"):Connect("OnClick", function()
	endLoop = true
end)

local placing = false

PlayAudio(13.5, 1/3, 39, true, "ThemeA")

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
				placing = false
				for cY, tab in pairs(currentTab) do
					for cX, isOn in pairs(tab) do
						if isOn == 1 then
							local x = cX + currentX
							local y = cY + currentY
							grid[y][x][1] = current
						end
					end
				end
				local linesCleared = {}
				local flashers = {}
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
										BackgroundColor3 =  Color3.fromRGB(33, 38, 22);
										BorderSizePixel = 0;
										ZIndex=100;
									}))
							end
						end
					end
				end
				if #linesCleared > 0 then
					print(table.concat(linesCleared))
					for i=1, 4 do
						for _,v in pairs(flashers) do
							v.BackgroundTransparency = 1
						end
						wait(0.2)
						for _,v in pairs(flashers) do
							v.BackgroundTransparency = 0
						end
						wait(0.2)
					end
					for _,v in pairs(flashers) do
							v:Destroy()
						end
					for _,v in pairs(linesCleared) do
						table.remove(grid, v)
						table.insert(grid, 1, {{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0}})
					end
					linesCleared = {}
					flashers = {}
				end
				task.wait(0.2)
				GenerateNewPiece()
			else
				placing = true
			end
		end
		UpdateGrid()
	end
end
