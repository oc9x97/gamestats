-- Create a ScreenGui to hold the GUI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGUI" -- Name the ScreenGui for easier reference
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Calculate the desired size of the GUI
local guiWidth = 400 -- Adjust the width as needed
local guiHeight = 300 -- Adjust the height as needed

-- Create a Frame for the black background
local frame = Instance.new("Frame")
frame.Name = "CustomFrame" -- Name the Frame for easier reference
frame.Size = UDim2.new(0, guiWidth, 0, guiHeight)
frame.Position = UDim2.new(0.5, -guiWidth/2, 0.5, -guiHeight/2)
frame.BackgroundTransparency = 0.3
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Create a UICorner to round the edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.1, 0) -- Adjust the radius as needed
uiCorner.Parent = frame

-- Function to get the game's name
local function getGameName()
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)

    if success and gameInfo then
        return gameInfo.Name
    else
        return "Unknown Game"
    end
end

-- Create a TextLabel for the game name (same as previous code)
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Name = "GameNameLabel"
gameNameLabel.Size = UDim2.new(0, 200, 0, 40)
gameNameLabel.Position = UDim2.new(0.5, -100, 0, 10)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.TextColor3 = Color3.new(1, 1, 1)
gameNameLabel.TextSize = 24
gameNameLabel.Font = Enum.Font.SourceSansBold
gameNameLabel.Text = getGameName()
gameNameLabel.Parent = frame

-- Create a TextLabel for the number of players in-game
local playersInGameLabel = Instance.new("TextLabel")
playersInGameLabel.Name = "PlayersInGameLabel"
playersInGameLabel.Size = UDim2.new(0, 200, 0, 40)
playersInGameLabel.Position = UDim2.new(0.5, -100, 0, 60)
playersInGameLabel.BackgroundTransparency = 1
playersInGameLabel.TextColor3 = Color3.new(1, 1, 1)
playersInGameLabel.TextSize = 18 -- Adjust the text size as needed
playersInGameLabel.Font = Enum.Font.SourceSansBold
playersInGameLabel.Parent = frame

-- Function to update the "Players In-Game" label with the current number of players
local function updatePlayersInGameLabel()
    local playerCount = #game.Players:GetPlayers()
    playersInGameLabel.Text = "Players In-Game: " .. playerCount
end

-- Initial update of the label
updatePlayersInGameLabel()

-- Create a Timer to periodically update the player count (e.g., every 5 seconds)
local updateInterval = 5 -- Adjust the interval as needed (in seconds)
local timer = Instance.new("BindableEvent")
timer.Name = "UpdateTimer"
timer.Parent = frame

-- Function to update the player count and restart the timer
local function updateAndRestartTimer()
    updatePlayersInGameLabel()
    wait(updateInterval)
    timer:Fire()
end

-- Connect the timer event to the updateAndRestartTimer function
timer.Event:Connect(updateAndRestartTimer)

-- Start the timer
timer:Fire()

-- Create the close (X) button (same as previous code)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundTransparency = 1
closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
closeButton.TextColor3 = Color3.new(1, 0, 0)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.Parent = frame

-- Function to hide the GUI on button click (same as previous code)
local function hideGUI()
    screenGui:Remove()
end

-- Connect the button click event to the hideGUI function (same as previous code)
closeButton.MouseButton1Click:Connect(hideGUI)

-- Variables for drag-and-drop functionality
local isDragging = false
local offset = Vector2.new()

-- Function to start dragging
local function startDragging(input)
    isDragging = true
    offset = frame.Position - UDim2.new(0, input.Position.X, 0, input.Position.Y)
end

-- Function to stop dragging
local function stopDragging()
    isDragging = false
end

-- Connect input events for dragging
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDragging(input.Position)
    end
end)

frame.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        frame.Position = UDim2.new(0, input.Position.X + offset.X, 0, input.Position.Y + offset.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopDragging()
    end
end)

-- To always teleport to the mouse when dragging
local function followMouse()
    if isDragging then
        local mouse = game.Players.LocalPlayer:GetMouse()
        frame.Position = UDim2.new(0, mouse.X + offset.X, 0, mouse.Y + offset.Y)
    end
end

-- Connect a RenderStepped event to continuously follow the mouse while dragging
game:GetService("RunService").RenderStepped:Connect(followMouse)
