local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GardenMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Grow A Garden Menu"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 12
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -25, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 12
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Кнопка сворачивания
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -50, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.Gotham
minimizeButton.TextSize = 12
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 4)
minimizeCorner.Parent = minimizeButton

-- Контейнер вкладок
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 25)
tabContainer.Position = UDim2.new(0, 0, 0, 25)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Контейнер содержимого
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Вкладки
local tabs = {"ESP", "Shop", "Dupe"}
local currentTab = "ESP"
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.33, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1)/3, 0, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 12
    tabButton.Parent = tabContainer

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabButton

    tabButtons[tabName] = tabButton

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = tabName == currentTab
    content.Parent = contentFrame
    tabContents[tabName] = content
end

-- Переключение вкладок
local function switchTab(tabName)
    for _, tab in pairs(tabContents) do
        tab.Visible = false
    end
    tabContents[tabName].Visible = true
    currentTab = tabName
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = name == tabName and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    end
end

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Перетаскивание
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Сворачивание
local isMinimized = false
local originalSize = mainFrame.Size
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if isMinimized then
        minimizeButton.Text = "+"
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 250, 0, 25)})
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

-- Закрытие
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Вкладка ESP
local espEnabled = false
local espConnection = nil

local function createBillboard(parent, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
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
    -- Очистка старых меток
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("ESP_Label") then
            obj.ESP_Label:Destroy()
        end
    end
    -- Поиск объектов
    local targetFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("Crates") or workspace
    for _, obj in pairs(targetFolder:GetDescendants()) do
        if obj.Name:lower():match("egg") or obj.Name:lower():match("crate") then
            local petName = "Неизвестно"
            local rarity = "Обычный"
            local weightValue = "N/A"
            local hasData = false
            for _, child in pairs(obj:GetDescendants()) do
                if not hasData then
                    if child.Name:lower() == "petname" or child.Name:lower() == "pet" or child.Name:lower() == "nametag" then
                        petName = child:IsA("StringValue") and child.Value or tostring(child)
                        hasData = true
                    end
                    if child.Name:lower() == "rarity" or child.Name:lower() == "rare" then
                        rarity = child:IsA("StringValue") and child.Value or tostring(child)
                        hasData = true
                    end
                    if child.Name:lower() == "weight" or child.Name:lower() == "mass" or child.Name:lower() == "value" then
                        weightValue = child:IsA("NumberValue") and tostring(child.Value) .. " кг" or tostring(child)
                        hasData = true
                    end
                end
            end
            if hasData then
                local color = rarity == "Legendary" and Color3.fromRGB(255, 215, 0) or
                              rarity == "Epic" and Color3.fromRGB(128, 0, 128) or
                              rarity == "Rare" and Color3.fromRGB(0, 128, 255) or
                              Color3.fromRGB(200, 200, 200)
                createBillboard(obj, petName .. "\n" .. rarity .. "\n" .. weightValue, color)
                print("ESP: Объект:", obj.Name, "Пет:", petName, "Редкость:", rarity, "Вес:", weightValue)
            end
        end
    end
end

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.9, 0, 0, 30)
espButton.Position = UDim2.new(0.05, 0, 0.1, 0)
espButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espButton.Text = "ESP: Выкл"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 12
espButton.Parent = tabContents["ESP"]

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 4)
espCorner.Parent = espButton

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "Вкл" or "Выкл")
    if espEnabled then
        print("ESP включен, сканирование объектов...")
        updateESP()
        espConnection = game:GetService("RunService").Stepped:Connect(function()
            if tick() % 7 < 0.1 then
                updateESP()
            end
        end)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("ESP_Label") then
                obj.ESP_Label:Destroy()
            end
        end
        print("ESP выключен")
    end
end)

-- Вкладка Shop
local seedList = {"Carrot", "Tomato", "Corn", "Candy Blossom", "Zen Seed", "Gourmet Seed"} -- Настройте под реальные семена
local selectedSeed = nil

local seedDropdown = Instance.new("TextButton")
seedDropdown.Size = UDim2.new(0.9, 0, 0, 30)
seedDropdown.Position = UDim2.new(0.05, 0, 0.1, 0)
seedDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
seedDropdown.Text = "Семя: Нет"
seedDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
seedDropdown.Font = Enum.Font.Gotham
seedDropdown.TextSize = 12
seedDropdown.Parent = tabContents["Shop"]

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 4)
dropdownCorner.Parent = seedDropdown

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.9, 0, 0, #seedList * 30)
dropdownFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dropdownFrame.Visible = false
dropdownFrame.Parent = tabContents["Shop"]

local dropdownList = Instance.new("UIListLayout")
dropdownList.Parent = dropdownFrame

for _, seed in ipairs(seedList) do
    local seedButton = Instance.new("TextButton")
    seedButton.Size = UDim2.new(1, 0, 0, 30)
    seedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    seedButton.Text = seed
    seedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    seedButton.Font = Enum.Font.Gotham
    seedButton.TextSize = 12
    seedButton.Parent = dropdownFrame

    local seedCorner = Instance.new("UICorner")
    seedCorner.CornerRadius = UDim.new(0, 4)
    seedCorner.Parent = seedButton

    seedButton.MouseButton1Click:Connect(function()
        selectedSeed = seed
        seedDropdown.Text = "Семя: " .. seed
        dropdownFrame.Visible = false
        print("Выбрано семя:", seed)
    end)
end

seedDropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

local autoBuyButton = Instance.new("TextButton")
autoBuyButton.Size = UDim2.new(0.9, 0, 0, 30)
autoBuyButton.Position = UDim2.new(0.05, 0, 0.3, 0)
autoBuyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyButton.Text = "Автопокупка: Выкл"
autoBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyButton.Font = Enum.Font.Gotham
autoBuyButton.TextSize = 12
autoBuyButton.Parent = tabContents["Shop"]

local autoBuyCorner = Instance.new("UICorner")
autoBuyCorner.CornerRadius = UDim.new(0, 4)
autoBuyCorner.Parent = autoBuyButton

local autoBuyEnabled = false
autoBuyButton.MouseButton1Click:Connect(function()
    autoBuyEnabled = not autoBuyEnabled
    autoBuyButton.Text = "Автопокупка: " .. (autoBuyEnabled and "Вкл" or "Выкл")
    if autoBuyEnabled and selectedSeed then
        print("Автопокупка включена для:", selectedSeed)
        spawn(function()
            while autoBuyEnabled and selectedSeed do
                local success, err = pcall(function()
                    local args = {
                        [1] = "Shop", -- Замените на правильный магазин
                        [2] = selectedSeed,
                        [3] = 1
                    }
                    local gameEvents = ReplicatedStorage:FindFirstChild("GameEvents") or ReplicatedStorage
                    local buyItem = nil
                    for _, event in pairs(gameEvents:GetChildren()) do
                        if event.ClassName == "RemoteEvent" and (event.Name:lower():match("buy") or event.Name:lower():match("purchase")) then
                            buyItem = event
                            break
                        end
                    end
                    if buyItem then
                        buyItem:FireServer(unpack(args))
                        print("Попытка покупки:", selectedSeed, "через", buyItem.Name)
                    else
                        -- Альтернативный формат аргументов
                        local altArgs = {shop = "Shop", item = selectedSeed, quantity = 1}
                        if buyItem then
                            buyItem:FireServer(altArgs)
                            print("Попытка покупки (альтернативный формат):", selectedSeed, "через", buyItem.Name)
                        else
                            error("RemoteEvent для покупки не найден")
                        end
                    end
                end)
                if not success then
                    warn("Ошибка автопокупки: " .. tostring(err))
                    autoBuyEnabled = false
                    autoBuyButton.Text = "Автопокупка: Выкл"
                    break
                end
                wait(2)
            end
        end)
    end
end)

-- Вкладка Dupe
local petList = {"Dog", "Cat", "Dragon", "Unicorn", "Phoenix", "Legendary Pet"} -- Настройте под реальных петов
local selectedPet = nil

local petDropdown = Instance.new("TextButton")
petDropdown.Size = UDim2.new(0.9, 0, 0, 30)
petDropdown.Position = UDim2.new(0.05, 0, 0.1, 0)
petDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
petDropdown.Text = "Пет: Нет"
petDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
petDropdown.Font = Enum.Font.Gotham
petDropdown.TextSize = 12
petDropdown.Parent = tabContents["Dupe"]

local petDropdownCorner = Instance.new("UICorner")
petDropdownCorner.CornerRadius = UDim.new(0, 4)
petDropdownCorner.Parent = petDropdown

local petDropdownFrame = Instance.new("Frame")
petDropdownFrame.Size = UDim2.new(0.9, 0, 0, #petList * 30)
petDropdownFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
petDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
petDropdownFrame.Visible = false
petDropdownFrame.Parent = tabContents["Dupe"]

local petDropdownList = Instance.new("UIListLayout")
petDropdownList.Parent = petDropdownFrame

for _, pet in ipairs(petList) do
    local petButton = Instance.new("TextButton")
    petButton.Size = UDim2.new(1, 0, 0, 30)
    petButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    petButton.Text = pet
    petButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    petButton.Font = Enum.Font.Gotham
    petButton.TextSize = 12
    petButton.Parent = petDropdownFrame

    local petCorner = Instance.new("UICorner")
    petCorner.CornerRadius = UDim.new(0, 4)
    petCorner.Parent = petButton

    petButton.MouseButton1Click:Connect(function()
        selectedPet = pet
        petDropdown.Text = "Пет: " .. pet
        petDropdownFrame.Visible = false
        print("Выбран пет:", pet)
    end)
end

petDropdown.MouseButton1Click:Connect(function()
    petDropdownFrame.Visible = not petDropdownFrame.Visible
end)

local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(0.9, 0, 0, 30)
dupeButton.Position = UDim2.new(0.05, 0, 0.3, 0)
dupeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dupeButton.Text = "Выдать пета"
dupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeButton.Font = Enum.Font.Gotham
dupeButton.TextSize = 12
dupeButton.Parent = tabContents["Dupe"]

local dupeCorner = Instance.new("UICorner")
dupeCorner.CornerRadius = UDim.new(0, 4)
dupeCorner.Parent = dupeButton

dupeButton.MouseButton1Click:Connect(function()
    if selectedPet then
        local success, err = pcall(function()
            local args = {
                [1] = selectedPet,
                [2] = 1
            }
            local gameEvents = ReplicatedStorage:FindFirstChild("GameEvents") or ReplicatedStorage
            local grantPet = nil
            for _, event in pairs(gameEvents:GetChildren()) do
                if event.ClassName == "RemoteEvent" and (event.Name:lower():match("pet") or event.Name:lower():match("grant") or event.Name:lower():match("add") or event.Name:lower():match("reward")) then
                    grantPet = event
                    break
                end
            end
            if grantPet then
                grantPet:FireServer(unpack(args))
                print("Попытка выдать пета:", selectedPet, "через", grantPet.Name)
            else
                -- Альтернативный формат аргументов
                local altArgs = {pet = selectedPet, amount = 1}
                if grantPet then
                    grantPet:FireServer(altArgs)
                    print("Попытка выдать пета (альтернативный формат):", selectedPet, "через", grantPet.Name)
                else
                    error("RemoteEvent для выдачи пета не найден")
                end
            end
        end)
        if not success then
            warn("Ошибка выдачи пета: " .. tostring(err))
        end
    else
        warn("Выберите пета для выдачи")
    end
end)

-- Анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 250, 0, 180)})
tween:Play()
