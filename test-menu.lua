local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowAGardenMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 250)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Grow A Garden Menu"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Кнопка сворачивания
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.Gotham
minimizeButton.TextSize = 14
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeButton

-- Контейнер вкладок
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Контейнер содержимого
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -60)
contentFrame.Position = UDim2.new(0, 0, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Вкладки
local tabs = {"ESP", "Shop", "Automation"}
local currentTab = "ESP"
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.33, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1)/3, 0, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.Parent = tabContainer

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 5)
    tabCorner.Parent = tabButton

    tabButtons[tabName] = tabButton

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = tabName == currentTab
    content.Parent = contentFrame
    tabContents[tabName] = content
end

-- Функция переключения вкладок
local function switchTab(tabName)
    for _, tab in pairs(tabContents) do
        tab.Visible = false
    end
    tabContents[tabName].Visible = true
    currentTab = tabName
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = name == tabName and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    end
end

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Логика перетаскивания
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Логика сворачивания
local isMinimized = false
local originalSize = mainFrame.Size
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if isMinimized then
        minimizeButton.Text = "+"
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 350, 0, 30)})
        tween:Play()
        contentFrame.Visible = false
        tabContainer.Visible = false
    else
        minimizeButton.Text = "-"
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = originalSize})
        tween:Play()
        contentFrame.Visible = true
        tabContainer.Visible = true
    end
end)

-- Логика закрытия
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Вкладка ESP
local espEnabled = false
local espConnection = nil

local function createBillboard(parent, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Display"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = billboard
end

local function updateESP()
    if not espEnabled then return end
    -- Очистка старых ESP
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("ESP_Display") then
            obj.ESP_Display:Destroy()
        end
    end
    -- Поиск яиц и ящиков (предполагаемые имена, нужно проверить в игре)
    local targetFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("Crates") or workspace
    for _, obj in pairs(targetFolder:GetDescendants()) do
        if obj.Name == "Egg" or obj.Name == "Crate" then
            local data = obj:FindFirstChild("PetData") or obj:FindFirstChild("CrateData") or obj:FindFirstChild("Data")
            local weight = obj:FindFirstChild("Weight") or obj:FindFirstChild("Mass")
            local rarity = obj:FindFirstChild("Rarity") and obj.Rarity.Value or "Common"
            if data then
                local petName = data.Value or "Unknown"
                local weightValue = weight and weight.Value or "N/A"
                local color = rarity == "Legendary" and Color3.fromRGB(255, 215, 0) or
                              rarity == "Epic" and Color3.fromRGB(128, 0, 128) or
                              rarity == "Rare" and Color3.fromRGB(0, 128, 255) or
                              Color3.fromRGB(255, 255, 255)
                createBillboard(obj, petName .. " (" .. rarity .. ", " .. weightValue .. " kg)", color)
            end
        end
    end
end

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.9, 0, 0, 40)
espButton.Position = UDim2.new(0.05, 0, 0.1, 0)
espButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espButton.Text = "Toggle ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 14
espButton.Parent = tabContents["ESP"]

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 5)
espCorner.Parent = espButton

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "Toggle ESP: " .. (espEnabled and "ON" or "OFF")
    if espEnabled then
        updateESP()
        espConnection = game:GetService("RunService").Stepped:Connect(function()
            if tick() % 2 < 0.1 then -- Обновление каждые 2 секунды
                updateESP()
            end
        end)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("ESP_Display") then
                obj.ESP_Display:Destroy()
            end
        end
    end
end)

-- Вкладка Shop
local seedList = {"Carrot", "Tomato", "Corn", "Candy Blossom", "Zen Seed Pack", "Gourmet Seed Pack"} -- Настройте под реальные семена
local selectedSeed = nil

local seedDropdown = Instance.new("TextButton")
seedDropdown.Size = UDim2.new(0.9, 0, 0, 40)
seedDropdown.Position = UDim2.new(0.05, 0, 0.1, 0)
seedDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
seedDropdown.Text = "Выберите семя: None"
seedDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
seedDropdown.Font = Enum.Font.Gotham
seedDropdown.TextSize = 14
seedDropdown.Parent = tabContents["Shop"]

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 5)
dropdownCorner.Parent = seedDropdown

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.9, 0, 0, #seedList * 40)
dropdownFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false
dropdownFrame.Parent = tabContents["Shop"]

local dropdownList = Instance.new("UIListLayout")
dropdownList.Parent = dropdownFrame

for _, seed in ipairs(seedList) do
    local seedButton = Instance.new("TextButton")
    seedButton.Size = UDim2.new(1, 0, 0, 40)
    seedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    seedButton.Text = seed
    seedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    seedButton.Font = Enum.Font.Gotham
    seedButton.TextSize = 14
    seedButton.Parent = dropdownFrame

    local seedCorner = Instance.new("UICorner")
    seedCorner.CornerRadius = UDim.new(0, 5)
    seedCorner.Parent = seedButton

    seedButton.MouseButton1Click:Connect(function()
        selectedSeed = seed
        seedDropdown.Text = "Выберите семя: " .. seed
        dropdownFrame.Visible = false
    end)
end

seedDropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

local autoBuyButton = Instance.new("TextButton")
autoBuyButton.Size = UDim2.new(0.9, 0, 0, 40)
autoBuyButton.Position = UDim2.new(0.05, 0, 0.3, 0)
autoBuyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoBuyButton.Text = "Автопокупка: OFF"
autoBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyButton.Font = Enum.Font.Gotham
autoBuyButton.TextSize = 14
autoBuyButton.Parent = tabContents["Shop"]

local autoBuyCorner = Instance.new("UICorner")
autoBuyCorner.CornerRadius = UDim.new(0, 5)
autoBuyCorner.Parent = autoBuyButton

local autoBuyEnabled = false
autoBuyButton.MouseButton1Click:Connect(function()
    autoBuyEnabled = not autoBuyEnabled
    autoBuyButton.Text = "Автопокупка: " .. (autoBuyEnabled and "ON" or "OFF")
    if autoBuyEnabled and selectedSeed then
        spawn(function()
            while autoBuyEnabled and selectedSeed do
                local success, err = pcall(function()
                    -- Настройте путь и аргументы под игру
                    local args = {
                        [1] = "Shop", -- Может быть "SeedShop" или другой, проверьте в ReplicatedStorage
                        [2] = selectedSeed,
                        [3] = 1
                    }
                    ReplicatedStorage:FindFirstChild("GameEvents"):FindFirstChild("BuyItem"):FireServer(unpack(args))
                end)
                if not success then
                    warn("Ошибка автопокупки: " .. tostring(err))
                    autoBuyEnabled = false
                    autoBuyButton.Text = "Автопокупка: OFF"
                    break
                end
                wait(2) -- Задержка 2 секунды для снижения нагрузки
            end
        end)
    end
end)

-- Вкладка Automation
local autoFarmButton = Instance.new("TextButton")
autoFarmButton.Size = UDim2.new(0.9, 0, 0, 40)
autoFarmButton.Position = UDim2.new(0.05, 0, 0.1, 0)
autoFarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoFarmButton.Text = "Автофарм: OFF"
autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmButton.Font = Enum.Font.Gotham
autoFarmButton.TextSize = 14
autoFarmButton.Parent = tabContents["Automation"]

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 5)
farmCorner.Parent = autoFarmButton

local autoFarmEnabled = false
autoFarmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmButton.Text = "Автофарм: " .. (autoFarmEnabled and "ON" or "OFF")
    if autoFarmEnabled then
        spawn(function()
            while autoFarmEnabled do
                local success, err = pcall(function()
                    for _, plant in pairs(workspace:GetDescendants()) do
                        if plant.Name == "Plant" and plant:FindFirstChild("Growth") then
                            ReplicatedStorage:FindFirstChild("GameEvents"):FindFirstChild("HarvestPlant"):FireServer(plant)
                        end
                    end
                end)
                if not success then
                    warn("Ошибка автофарма: " .. tostring(err))
                    autoFarmEnabled = false
                    autoFarmButton.Text = "Автофарм: OFF"
                    break
                end
                wait(1)
            end
        end)
    end
end)

-- Анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 350, 0, 250)})
tween:Play()
