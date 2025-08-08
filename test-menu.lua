-- ESP Tab: Egg and Crate Detector
local espEnabled = false
local espConnection = nil -- Для хранения соединения с RenderStepped

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
    -- Поиск яиц и ящиков
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Egg" or obj.Name == "Crate" then
            local data = obj:FindFirstChild("PetData") or obj:FindFirstChild("CrateData")
            local weight = obj:FindFirstChild("Weight") -- Предполагаемый атрибут веса
            if data and data:IsA("StringValue") then
                local petName = data.Value or "Unknown"
                local rarity = (obj:FindFirstChild("Rarity") and obj.Rarity.Value) or "Common"
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
espButton.Text = "Toggle Egg/Crate ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 14
espButton.Parent = tabContents["ESP"]

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 5)
espCorner.Parent = espButton

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "Toggle Egg/Crate ESP: " .. (espEnabled and "ON" or "OFF")
    if espEnabled then
        updateESP() -- Первоначальное обновление
        espConnection = game:GetService("RunService").Stepped:Connect(function()
            -- Обновление раз в 1 секунду вместо каждого кадра
            if tick() % 1 < 0.1 then
                updateESP()
            end
        end)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        -- Очистка всех ESP
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("ESP_Display") then
                obj.ESP_Display:Destroy()
            end
        end
    end
end)

-- Shop Tab: Auto Seed Purchase
local seedDropdown = Instance.new("TextButton")
seedDropdown.Size = UDim2.new(0.9, 0, 0, 40)
seedDropdown.Position = UDim2.new(0.05, 0, 0.1, 0)
seedDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
seedDropdown.Text = "Select Seed: None"
seedDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
seedDropdown.Font = Enum.Font.Gotham
seedDropdown.TextSize = 14
seedDropdown.Parent = tabContents["Shop"]

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 5)
dropdownCorner.Parent = seedDropdown

local seedList = {"Carrot", "Tomato", "Corn", "Candy Blossom", "Zen Seed Pack", "Gourmet Seed Pack"}
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.9, 0, 0, #seedList * 40)
dropdownFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false
dropdownFrame.Parent = tabContents["Shop"]

local dropdownList = Instance.new("UIListLayout")
dropdownList.Parent = dropdownFrame

local selectedSeed = nil
for i, seed in ipairs(seedList) do
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
        seedDropdown.Text = "Select Seed: " .. seed
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
autoBuyButton.Text = "Auto Buy Seeds: OFF"
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
    autoBuyButton.Text = "Auto Buy Seeds: " .. (autoBuyEnabled and "ON" or "OFF")
    if autoBuyEnabled and selectedSeed then
        spawn(function()
            while autoBuyEnabled and selectedSeed do
                local success, err = pcall(function()
                    local args = {
                        [1] = "SeedShop",
                        [2] = selectedSeed,
                        [3] = 1
                    }
                    ReplicatedStorage.GameEvents.BuyItem:FireServer(unpack(args))
                end)
                if not success then
                    warn("Ошибка автопокупки: " .. tostring(err))
                    autoBuyEnabled = false
                    autoBuyButton.Text = "Auto Buy Seeds: OFF"
                    break
                end
                wait(1)
            end
        end)
    end
end)
