--Hello Skid!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ESP = {
    Enabled = true,
    Players = {
        Enabled = true,
        MaxDistance = 500,
        ShowDistance = true,
        ShowHealth = true,
        IgnoreTeammates = false,
        EnemyColor = Color3.fromRGB(255, 0, 0),
        TextSize = 13,
        TextColor = Color3.new(0.117647, 1.000000, 0.000000),
        OutlineColor = Color3.fromRGB(0, 0, 0)
    },
    NPCs = {
        Enabled = true,
        MaxDistance = 1000,
        ShowDistance = true,
        ShowHealth = true,
        TextSize = 13,
        TextColor = Color3.new(1, 0.65, 0),
        OutlineColor = Color3.fromRGB(0, 0, 0)
    },
    LootBoxes = {
        Enabled = true,
        MaxDistance = 1000,
        ShowDistance = true,
        TextSize = 13,
        TextColor = Color3.new(1, 0.84, 0),
        OutlineColor = Color3.fromRGB(0, 0, 0)
    },
    LootBags = {
        Enabled = true,
        MaxDistance = 1000,
        ShowDistance = true,
        TextSize = 13,
        TextColor = Color3.new(0.29, 0, 0.51),
        OutlineColor = Color3.fromRGB(0, 0, 0)
    },
    RefreshRate = 0
}


local cache = {
    drawings = {},
    espData = {}
}


local function getInstancePosition(instance)
    if not instance then return nil end
    
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

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function getPlayerDistance(instance)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return 0 end
    
    local targetPosition = getInstancePosition(instance)
    if not targetPosition then return 0 end
    
    return getDistance(rootPart.Position, targetPosition)
end


local function getDrawing(id, type, properties)
    if not cache.drawings[id] then
        cache.drawings[id] = Drawing.new(type)
        

        for prop, value in pairs(properties) do
            cache.drawings[id][prop] = value
        end
    end
    
    return cache.drawings[id]
end

local function identifyEntityType(entity)
    if not entity then return "unknown" end
    
    -- NPC identification
    if entity.Name:match("^Humanoid_[%w%-]+$") or entity.Name:match("^%(.-%)Humanoid_[%w%-]+$") then 
        return "npc" 
    end
    
    if entity:IsA("Player") or Players:FindFirstChild(entity.Name) then
        return "player"
    end
    
    -- Check for loot boxes
    if entity.Name == "giftbox_blend" and entity:FindFirstChild("Giftbox01") then
        return "lootbox"
    end
    
    -- Check for loot bags
    if entity.Name == "Lootbag" then
        return "lootbag"
    end
    
    return "unknown"
end

-- Extract NPC name from format
local function extractNPCName(name)
    local tag = "NPC"
    return tag or "NPC"
end


local function updateESP()
    if not ESP.Enabled then

        for id, drawing in pairs(cache.drawings) do
            drawing.Visible = false
        end
        return
    end

    local playerCharacter = LocalPlayer.Character
    local playerRoot = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return end
    
    local playerPosition = playerRoot.Position
    

    for id, data in pairs(cache.espData) do
        local entity = data.entity
        local entityType = data.type
        
        -- Skip if entity no longer exists
        if not entity or not entity.Parent then
            -- Clean up drawings for this entity
            if cache.drawings[id .. "_text"] then
                cache.drawings[id .. "_text"].Visible = false
            end
            cache.espData[id] = nil
            continue
        end
        
        -- Get entity position based on type
        local position
        local humanoid
        
        if entityType == "player" then
            local character = entity.Character
            if not character then continue end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then continue end
            
            position = rootPart.Position
            humanoid = character:FindFirstChild("Humanoid")
        elseif entityType == "npc" then
            local rootPart = entity:FindFirstChild("HumanoidRootPart")
            if not rootPart then continue end
            
            position = rootPart.Position
            humanoid = entity:FindFirstChild("Humanoid")
        else
            position = getInstancePosition(entity)
            if not position then continue end
        end
        

        local distance = getDistance(playerPosition, position)
        local config = ESP[entityType == "player" and "Players" or
                         entityType == "npc" and "NPCs" or
                         entityType == "lootbox" and "LootBoxes" or
                         entityType == "lootbag" and "LootBags"]
        
        if not config or not config.Enabled or distance > config.MaxDistance then

            if cache.drawings[id .. "_text"] then
                cache.drawings[id .. "_text"].Visible = false
            end
            continue
        end
        
        -- Check if entity is on screen
        local screenPos, onScreen = camera:WorldToViewportPoint(position)
        if not onScreen then
            if cache.drawings[id .. "_text"] then
                cache.drawings[id .. "_text"].Visible = false
            end
            continue
        end
        

        local basePosition = Vector2.new(screenPos.X, screenPos.Y)
        local scaleFactor = 1 / (screenPos.Z * 0.75)
        local textOffset = Vector2.new(0, -45 * scaleFactor)
        
        local displayText = ""
        
        if entityType == "player" then
            displayText = entity.Name
            
            if config.ShowHealth and humanoid then
                displayText = string.format("%s [%d/%d]", displayText, 
                    math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
            end
        elseif entityType == "npc" then
            displayText = extractNPCName(entity.Name)
            
            if config.ShowHealth and humanoid then
                displayText = string.format("%s [%d/%d]", displayText, 
                    math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
            end
        elseif entityType == "lootbox" then
            displayText = "Loot Box"
        elseif entityType == "lootbag" then
            displayText = "Loot Bag"
        end
        
        if config.ShowDistance then
            displayText = string.format("%s [%d]", displayText, math.floor(distance))
        end
        
        -- Get or create text drawing
        local textDrawing = getDrawing(id .. "_text", "Text", {
            Text = displayText,
            Size = config.TextSize,
            Center = true,
            Outline = true,
            OutlineColor = config.OutlineColor,
            Color = config.TextColor,
            Font = 2,
            Visible = true
        })
        
        -- Update text
        textDrawing.Text = displayText
        textDrawing.Position = basePosition + textOffset
        textDrawing.Visible = true
    end
end

local function monitorPlayers()
    local function trackPlayer(player)
        if player == LocalPlayer then return end
        
        local id = "player_" .. player.UserId
        
        cache.espData[id] = {
            entity = player,
            type = "player"
        }
    end
    

    for _, player in pairs(Players:GetPlayers()) do
        trackPlayer(player)
    end
    

    Players.PlayerAdded:Connect(trackPlayer)
    
    Players.PlayerRemoving:Connect(function(player)
        local id = "player_" .. player.UserId
        cache.espData[id] = nil
        
        -- Clean up drawings
        if cache.drawings[id .. "_text"] then
            cache.drawings[id .. "_text"].Visible = false
        end
    end)
end

local function monitorNPCs()

    local function scanForNPCs()

        local entities = workspace:FindFirstChild("Entities")
        
        if entities then
            for _, entity in pairs(entities:GetChildren()) do
                if identifyEntityType(entity) == "npc" then
                    local id = "npc_" .. entity.Name
                    
                    if not cache.espData[id] then
                        cache.espData[id] = {
                            entity = entity,
                            type = "npc"
                        }
                    end
                end
            end
        end
        

        for _, entity in pairs(workspace:GetChildren()) do
            if identifyEntityType(entity) == "npc" then
                local id = "npc_" .. entity.Name
                
                if not cache.espData[id] then
                    cache.espData[id] = {
                        entity = entity,
                        type = "npc"
                    }
                end
            end
        end
    end
    

    scanForNPCs()

    spawn(function()
        while wait(ESP.RefreshRate * 2) do 
            scanForNPCs()
        end
    end)
    
    workspace.DescendantAdded:Connect(function(descendant)
        if identifyEntityType(descendant) == "npc" then
            local id = "npc_" .. descendant.Name
            
            if not cache.espData[id] then
                cache.espData[id] = {
                    entity = descendant,
                    type = "npc"
                }
            end
        end
    end)
end

local function monitorLootBoxes()
    local function scanForLootBoxes()
        for _, model in pairs(workspace:GetDescendants()) do
            if model.Name == "giftbox_blend" and model:FindFirstChild("Giftbox01") then
                local id = "lootbox_" .. model:GetFullName()
                
                if not cache.espData[id] then
                    cache.espData[id] = {
                        entity = model,
                        type = "lootbox"
                    }
                end
            end
        end
    end
    

    scanForLootBoxes()
    

    spawn(function()
        while wait(ESP.RefreshRate * 5) do 
            scanForLootBoxes()
        end
    end)
    
    -- Check for new loot boxes
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "Giftbox01" and descendant.Parent and descendant.Parent.Name == "giftbox_blend" then
            local id = "lootbox_" .. descendant.Parent:GetFullName()
            
            if not cache.espData[id] then
                cache.espData[id] = {
                    entity = descendant.Parent,
                    type = "lootbox"
                }
            end
        end
    end)
end

local function monitorLootBags()
    local function scanForLootBags()
        local lootBagsFolder = workspace:FindFirstChild("Lootbags")
        if not lootBagsFolder then return end
        
        for _, lootBag in pairs(lootBagsFolder:GetChildren()) do
            if lootBag.Name == "Lootbag" then
                local id = "lootbag_" .. lootBag:GetFullName()
                
                if not cache.espData[id] then
                    cache.espData[id] = {
                        entity = lootBag,
                        type = "lootbag"
                    }
                end
            end
        end
    end
    

    scanForLootBags()
    

    spawn(function()
        while wait(ESP.RefreshRate * 5) do 
            scanForLootBags()
        end
    end)
    
    local lootBagsFolder = workspace:FindFirstChild("Lootbags")
    if lootBagsFolder then
        lootBagsFolder.ChildAdded:Connect(function(child)
            if child.Name == "Lootbag" then
                local id = "lootbag_" .. child:GetFullName()
                
                if not cache.espData[id] then
                    cache.espData[id] = {
                        entity = child,
                        type = "lootbag"
                    }
                end
            end
        end)
        
        lootBagsFolder.ChildRemoved:Connect(function(child)
            local id = "lootbag_" .. child:GetFullName()
            cache.espData[id] = nil
        end)
    end
    

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Lootbags" then
            child.ChildAdded:Connect(function(lootBag)
                if lootBag.Name == "Lootbag" then
                    local id = "lootbag_" .. lootBag:GetFullName()
                    
                    if not cache.espData[id] then
                        cache.espData[id] = {
                            entity = lootBag,
                            type = "lootbag"
                        }
                    end
                end
            end)
            
            child.ChildRemoved:Connect(function(lootBag)
                local id = "lootbag_" .. lootBag:GetFullName()
                cache.espData[id] = nil
            end)
            

            for _, lootBag in pairs(child:GetChildren()) do
                if lootBag.Name == "Lootbag" then
                    local id = "lootbag_" .. lootBag:GetFullName()
                    
                    if not cache.espData[id] then
                        cache.espData[id] = {
                            entity = lootBag,
                            type = "lootbag"
                        }
                    end
                end
            end
        end
    end)
end

local function init()
    monitorPlayers()
    monitorNPCs()
    monitorLootBoxes()
    monitorLootBags()
    
    RunService.RenderStepped:Connect(updateESP)
    
end

init()
