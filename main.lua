--// HUB by TREmir2857
warn("made by TREmir2857")
warn("make sure you subscribed EmirScripts on yt!")
 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
 
local currentTeam = "Neutral"
 
-- TEAM SCANNER (Optimized)
task.spawn(function()
    while true do
        pcall(function()
            if player.Team then
                currentTeam = player.Team.Name
            end
        end)
        task.wait(0.1) -- Daha hızlı takım kontrolü için 100ms bekle
    end
end)
 
 
 
 
-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CustomHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
 
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 555)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
 
local function createButton(text, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 10 + (order - 1) * 50)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Text = text
    button.Parent = frame
    return button
end
 
local RunService = game:GetService("RunService")
 
-- SPEED BUTTON
local speedButton = createButton("Speed 250", 1)
local isSpeedOn = false
 
-- Loop
RunService.Heartbeat:Connect(function()
	if isSpeedOn then
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 250
			end
		end
	end
end)
 
speedButton.MouseButton1Click:Connect(function()
	isSpeedOn = not isSpeedOn
	if isSpeedOn then
		speedButton.Text = "Speed OFF"
	else
		speedButton.Text = "Speed 250"
		-- Kapandığında varsayılan hıza dön
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 16
			end
		end
	end
end)
 
 
-- GO TO BALL BUTTON
local goToBall = false
local ballButton = createButton("Go to the ball: OFF", 2)
ballButton.MouseButton1Click:Connect(function()
    goToBall = not goToBall
    ballButton.Text = goToBall and "Go to the ball: ON" or "Go to the ball: OFF"
end)
 
task.spawn(function()
    while true do
        if goToBall then
            local footballModel = workspace:FindFirstChild("Football")
            if footballModel and footballModel:FindFirstChild("FootBallHitbox") then
                local ball = footballModel.FootBallHitbox
                if ball and ball:IsA("BasePart") and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = ball.CFrame + Vector3.new(0, 2, 0)
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)
 
-- AUTO STEAL BUTTON
local autoSteal = false
local stealButton = createButton("Auto Steal (Click Tackle)", 3)
stealButton.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealButton.Text = autoSteal and "Auto Steal: ON" or "Auto Steal (Click Tackle)"
end)
 
task.spawn(function()
    while true do
        if autoSteal then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local theirRoot = plr.Character.HumanoidRootPart
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if theirRoot and myRoot then
                        theirRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -1)
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)
 
-- AUTO DRIBBLE BUTTON
local autoDribble = false
local dribbleButton = createButton("Auto Slide (PC ONLY)", 4)
dribbleButton.MouseButton1Click:Connect(function()
    autoDribble = not autoDribble
    dribbleButton.Text = autoDribble and "Auto Slide: ON" or "Auto Slide (PC ONLY)"
end)
 
task.spawn(function()
    while true do
        if autoDribble then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
        task.wait(0.01)
    end
end)
 
-- AUTO GOAL
local autoGoal = false
local autoGoalButton = createButton("Auto Goal: OFF", 5)
autoGoalButton.MouseButton1Click:Connect(function()
    autoGoal = not autoGoal
    autoGoalButton.Text = autoGoal and "Auto Goal: ON" or "Auto Goal: OFF"
end)
 
task.spawn(function()
    while true do
        if autoGoal then
            local goal
            -- Takım kontrolünü optimize et
            if currentTeam == "Blue" then
                goal = workspace.Map:FindFirstChild("AwayGoal")
            elseif currentTeam == "White" then
                goal = workspace.Map:FindFirstChild("HomeGoal")
            end
 
            if goal and goal:FindFirstChild("GoalHitbox") and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local goalPart = goal.GoalHitbox
                    -- Hedefi daha doğru şekilde yerleştir
                    goalPart.CFrame = root.CFrame * CFrame.new(0, 3, 0)
                end
            end
        end
        task.wait(0.1) -- Performans için 100ms bekleyin
    end
end)
 
-- EMIR HUB Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 180, 0, 30)
label.Position = UDim2.new(0, 10, 0, 10 + (5 * 50))
label.BackgroundTransparency = 1
label.Text = "EMIR HUB"
label.TextColor3 = Color3.fromRGB(0, 100, 0)
label.Font = Enum.Font.FredokaOne
label.TextSize = 20
label.Parent = frame
 
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.8
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.Parent = label
 
-- TEXTBOX
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 180, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 10 + (5 * 50) + 40)
textBox.PlaceholderText = "Enter Style name"
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 18
textBox.Text = ""
textBox.ClearTextOnFocus = false
textBox.Parent = frame
 
-- APPLY BUTTON
local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0, 180, 0, 30)
applyButton.Position = UDim2.new(0, 10, 0, 10 + (5 * 50) + 80)
applyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
applyButton.TextColor3 = Color3.new(1, 1, 1)
applyButton.Font = Enum.Font.SourceSansBold
applyButton.TextSize = 18
applyButton.Text = "Apply Style"
applyButton.Parent = frame
 
applyButton.MouseButton1Click:Connect(function()
    local stats = player:FindFirstChild("Stats")
    if stats and stats:FindFirstChild("Style") then
        stats.Style.Value = textBox.Text
		wait(0)workspace.TREmir2857.Settings.DribbleCooldown.Value = 0
    end
end)
wait(0)workspace.TREmir2857.Settings.DribbleCooldown.Value = 0
 
-- AUTO DRIBBLE BUTTON
local autoDribble = false
local dribbleButton = createButton("Auto Dribble (PC ONLY)", 9)
dribbleButton.MouseButton1Click:Connect(function()
    autoDribble = not autoDribble
    dribbleButton.Text = autoDribble and "Auto Dribble: ON" or "Auto Dribble (PC ONLY)"
end)
 
task.spawn(function()
    while true do
        if autoDribble then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        end
        task.wait(0.01)
    end
end)
wait(0)workspace.TREmir2857.Humanoid.DisplayName = "THE REAL LOKI"
--
-- LOOP BRING BALL
local goToBall = false
local ballButton = createButton("Bring Ball: OFF", 10)
ballButton.MouseButton1Click:Connect(function()
	goToBall = not goToBall
	ballButton.Text = goToBall and "Bring Ball: ON" or "Bring Ball: OFF"
end)
 
task.spawn(function()
	while true do
		if goToBall then
			local footballModel = workspace:FindFirstChild("Football")
			if footballModel and footballModel:FindFirstChild("FootBallHitbox") then
				local ball = footballModel.FootBallHitbox
				if ball and ball:IsA("BasePart") and player.Character then
					local root = player.Character:FindFirstChild("HumanoidRootPart")
					if root then
						-- Topu bacak hizasında ve biraz önde konumlandır
						ball.CFrame = root.CFrame * CFrame.new(0, -2.5, -2.2)
					end
				end
			end
		end
		task.wait(0.01)
	end
end)
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local main = playerGui:WaitForChild("Main")
local goalPositions = main:WaitForChild("GoalPositions")
-- AUTO SELECT TEAM BUTTON (Added this section)
local autoSelectTeam = false
local autoButton = createButton("Auto Select Team: OFF", 11)
autoButton.MouseButton1Click:Connect(function()
    autoSelectTeam = not autoSelectTeam
    autoButton.Text = autoSelectTeam and "Auto Select Team: ON" or "Auto Select Team: OFF"
end)
 
task.spawn(function()
    while true do
        if autoSelectTeam then
            local playerGui = player:WaitForChild("PlayerGui")
            local main = playerGui:WaitForChild("Main")
            local goalPositions = main:WaitForChild("GoalPositions")
            goalPositions.Visible = true  -- Set GoalPositions visible to true every loop
        end
        task.wait(1.5)  -- Wait for 0.5 seconds before checking again
    end
end)
