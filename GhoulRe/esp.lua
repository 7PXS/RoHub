--Hello Skid!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera



-- config options
local ESP = {
    Enabled = true,
    Players = {
        Enabled = true,
        MaxDistance = 1000,
        ShowDistance = true,
        ShowHealth = true,
        IgnoreTeammates = false,
        RefreshRate = 0.1,
        ProximityNotificationsEnabled = false,
        ProximityNotificationDistance = 500,
        EnemyColor = Color3.fromRGB(255, 0, 0),
        Text = {
            Enabled = true,
            Font = 2,
            Size = 13,
            Color = Color3.new(0.117647, 1.000000, 0.000000),
            Outline = true,
            OutlineColor = Color3.fromRGB(0, 0, 0)
        },
        HealthBar = {
            Enabled = true,
            Height = 4000,
            Width = 2,
            Color = Color3.fromRGB(0, 255, 0),
            BackgroundColor = Color3.fromRGB(255, 0, 0),
            Outline = true,
            OutlineColor = Color3.fromRGB(0, 0, 0)
        },
        Tracer = {
            Enabled = false,
            Color = Color3.fromRGB(0, 255, 255),
            Thickness = 1,
            Origin = "Bottom",
            Transparency = 0.7
        }
    }
}

-- player info functions
local function getPlayerRank(playerName)
    local entity = workspace.Entities:FindFirstChild(playerName)
    if entity and entity:FindFirstChild("Rank") then
        return tostring(entity.Rank.Value)
    end
    return "No Rank"
end

local function getPlayerWeapon(playerName)
    local entity = workspace.Entities:FindFirstChild(playerName)
    if entity and entity:FindFirstChild("Type") then
        return tostring(entity.Type.Value)
    end
    return "No Weapon"
end

local function getInstancePosition(instance)
    if instance:IsA("BasePart") then
        return instance.Position
    elseif instance:IsA("Model") then
        return instance:GetPivot().Position
    else
        local primaryPart = instance.PrimaryPart
        local rootPart = instance:FindFirstChild("HumanoidRootPart")
        local reference = primaryPart or rootPart or instance:FindFirstChildWhichIsA("BasePart")
        
        if reference then
            return reference.Position
        end
    end
    return nil
end

-- utility stuff
local function getDistance(instance)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return 0 end
    
    local targetPosition = getInstancePosition(instance)
    if not targetPosition then return 0 end
    
    return (rootPart.Position - targetPosition).Magnitude
end

local function createDrawing(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createESP(player)
    local settings = ESP.Players
    
    local esp = {
        Player = player,
        Drawings = {
            Info = nil,
            HealthBarOutline = nil,
            HealthBarBackground = nil,
            HealthBarFill = nil,
            Tracer = nil
        },
        Connection = nil
    }

    local function updateFont()
        if esp.Drawings.Info then
            esp.Drawings.Info.Font = settings.Text.Font
        end
    end
    
    -- text creation
    if settings.Text.Enabled then
        esp.Drawings.Info = createDrawing("Text", {
            Text = "",
            Size = settings.Text.Size,
            Center = true,
            Outline = settings.Text.Outline,
            OutlineColor = settings.Text.OutlineColor,
            Color = settings.Text.Color,
            Font = settings.Text.Font,
            Visible = false
        })
    end

    esp.UpdateFont = updateFont
    
    -- health bar creation
    if settings.HealthBar.Enabled then
        esp.Drawings.HealthBarOutline = createDrawing("Square", {
            Thickness = 1,
            Color = settings.HealthBar.OutlineColor,
            Filled = false,
            Visible = false
        })
        
        esp.Drawings.HealthBarBackground = createDrawing("Square", {
            Color = settings.HealthBar.BackgroundColor,
            Filled = true,
            Visible = false
        })
        
        esp.Drawings.HealthBarFill = createDrawing("Square", {
            Color = settings.HealthBar.Color,
            Filled = true,
            Visible = false
        })
    end
    
    -- tracer creation
    if settings.Tracer.Enabled then
        esp.Drawings.Tracer = createDrawing("Line", {
            Thickness = settings.Tracer.Thickness,
            Color = settings.Tracer.Color,
            Transparency = settings.Tracer.Transparency,
            Visible = false
        })
    end
    
    -- updating esp elements
    local function updateESP()
        if not ESP.Enabled or not settings.Enabled then
            for _, drawing in pairs(esp.Drawings) do
                if drawing then
                    drawing.Visible = false
                end
            end
            return
        end
        
        if not player or not player.Parent then
            esp:Destroy()
            return
        end
        
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
            for _, drawing in pairs(esp.Drawings) do
                if drawing then
                    drawing.Visible = false
                end
            end
            return
        end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        local position = rootPart.Position
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(position)
        local distance = getDistance(character)
        
        local isVisible = onScreen and distance <= settings.MaxDistance
        
        if settings.IgnoreTeammates and player.Team == LocalPlayer.Team then
            isVisible = false
        end
        
        if isVisible then
            local basePosition = Vector2.new(screenPos.X, screenPos.Y)
            local scaleFactor = 1 / (screenPos.Z * 0.75)
            local textOffset = Vector2.new(0, -45 * scaleFactor)
            
            if esp.Drawings.Info and settings.Text.Enabled then
                local playerName = player.Name
                local rank = getPlayerRank(playerName)
                local weapon = getPlayerWeapon(playerName)
                
                local infoText = playerName
                infoText = string.format("%s [%s]", infoText, rank)
                infoText = string.format("%s [%s]", infoText, weapon)
                
                if settings.ShowHealth and humanoid then
                    infoText = string.format("%s [%d/%d]", infoText, math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                end
                if settings.ShowDistance then
                    infoText = string.format("%s [%d]", infoText, math.floor(distance))
                end
                
                esp.Drawings.Info.Text = infoText
                esp.Drawings.Info.Position = basePosition + textOffset
                esp.Drawings.Info.Visible = true
            end
            
            if settings.HealthBar.Enabled and humanoid and esp.Drawings.HealthBarOutline then
                local healthBarWidth = settings.HealthBar.Width
                local healthBarHeight = settings.HealthBar.Height * scaleFactor
                local healthBarPosition = basePosition + Vector2.new(-30 * scaleFactor, -healthBarHeight/2)
                
                esp.Drawings.HealthBarOutline.Size = Vector2.new(healthBarWidth + 2, healthBarHeight + 2)
                esp.Drawings.HealthBarOutline.Position = healthBarPosition - Vector2.new(1, 1)
                esp.Drawings.HealthBarOutline.Visible = true
                
                esp.Drawings.HealthBarBackground.Size = Vector2.new(healthBarWidth, healthBarHeight)
                esp.Drawings.HealthBarBackground.Position = healthBarPosition
                esp.Drawings.HealthBarBackground.Visible = true
                
                local healthRatio = humanoid.Health / humanoid.MaxHealth
                esp.Drawings.HealthBarFill.Size = Vector2.new(healthBarWidth, healthBarHeight * healthRatio)
                esp.Drawings.HealthBarFill.Position = Vector2.new(
                    healthBarPosition.X,
                    healthBarPosition.Y + (healthBarHeight * (1 - healthRatio))
                )
                esp.Drawings.HealthBarFill.Visible = true
            end
            
            if esp.Drawings.Tracer and settings.Tracer.Enabled then
                local origin
                if settings.Tracer.Origin == "Mouse" then
                    origin = Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)
                elseif settings.Tracer.Origin == "Center" then
                    origin = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
                else
                    origin = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)
                end
                
                esp.Drawings.Tracer.From = origin
                esp.Drawings.Tracer.To = basePosition
                esp.Drawings.Tracer.Visible = true
            end
        else
            for _, drawing in pairs(esp.Drawings) do
                if drawing then
                    drawing.Visible = false
                end
            end
        end
    end
    
    -- cleanup
    function esp:Destroy()
        for _, drawing in pairs(self.Drawings) do
            if drawing then
                drawing:Remove()
            end
        end
        if self.Connection then
            self.Connection:Disconnect()
        end
    end
    
    esp.Connection = RunService.RenderStepped:Connect(updateESP)
    updateESP()
    
    return esp
end

-- main esp management
local espObjects = {}

-- player handling
local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        espObjects[player] = createESP(player)
    end
end

local function onPlayerRemoving(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

-- setup existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        onPlayerAdded(player)
    end
end

-- event connections
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
