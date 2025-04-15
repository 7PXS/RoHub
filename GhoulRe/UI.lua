local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ESP = {
    Enabled = true,
    Players = {
        Enabled = false,
        MaxDistance = 1000,
        ShowDistance = false,
        ShowHealth = false,
        IgnoreTeammates = false,
        EnemyColor = Color3.fromRGB(255, 0, 0),
        TextSize = 13,
        TextColor = Color3.new(0.117647, 1.000000, 0.000000),
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Tracers = false,
        ShowName = true,
        ShowWeapon = false,
        ShowRace = false
    },
    NPCs = {
        Enabled = false,
        MaxDistance = 1000,
        ShowDistance = false,
        ShowHealth = false,
        TextSize = 13,
        TextColor = Color3.new(1, 0.65, 0),
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Tracers = false,
        ShowName = true,
        ShowWeapon = false,
        ShowRace = false
    },
    LootBoxes = {
        Enabled = false,
        MaxDistance = 1000,
        ShowDistance = false,
        TextSize = 13,
        TextColor = Color3.new(1, 0.84, 0),
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Tracers = false,
        ShowName = true
    },
    LootBags = {
        Enabled = false,
        MaxDistance = 1000,
        ShowDistance = false,
        TextSize = 13,
        TextColor = Color3.new(0.29, 0, 0.51),
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Tracers = false,
        ShowName = true
    },
    RefreshRate = 0
}

local cache = {
    drawings = {},
    espData = {}
}

-- Combat settings
local autoPerry = false
local noStun = false
local apBreaker = false
local saveHPThreshold = 30
local permaDeathGodMode = false

-- Kill Aura settings
local killAuraEnabled = false
local killAuraRange = 15
local targetHealthPercent = 100
local freezeMobsEnabled = false
local freezeRange = 15

-- Movement settings
local flyEnabled = false
local flySpeed = 50
local flyKeyCode = Enum.KeyCode.X
local walkSpeed = 16
local jumpPower = 50

-- Auto Farm settings
local autoFarmEnabled = false
local farmDistance = 5
local farmPosition = "Behind"
local autoLoot = false
local autoHit = false

-- Mission settings
local autoMission = false
local selectedMission = "None"
local tpToMission = false
local autoGrip = false

-- Raid settings
local autoLaunchRaid = false
local selectedRaidBoss = "None"
local autoRaid = false
local autoRetry = false

-- Raid stats
local totalRaids = 0
local successfulRaids = 0
local failedRaids = 0
local successRate = 0

--// Main Libraries \\--
local libary = loadstring(game:HttpGet("https://raw.githubusercontent.com/imagoodpersond/puppyware/main/lib"))()
local NotifyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/imagoodpersond/puppyware/main/notify"))()
local Notify = NotifyLibrary.Notify

-- Create window
local Window = libary:new({
    name = "RoHub", 
    accent = Color3.fromRGB(244, 95, 115), 
    textsize = 13
})

-- Create pages (tabs)
local CombatTab = Window:page({name = "Combat"})
local VisualsTab = Window:page({name = "Visuals"})
local PlayerTab = Window:page({name = "Player"})
local AutoFarmTab = Window:page({name = "AutoFarm"})
local RaidsTab = Window:page({name = "Raids"})

-- Combat Tab Sections
local AutoParrySection = CombatTab:section({name = "Auto Parry", side = "left", size = 150})
local CombatUtilitySection = CombatTab:section({name = "Combat Utility", side = "right", size = 150})

-- Visuals Tab Sections
local PlayerESPSection = VisualsTab:section({name = "Player ESP", side = "left", size = 200})
local NPCESPSection = VisualsTab:section({name = "NPC ESP", side = "left", size = 200})
local LootESPSection = VisualsTab:section({name = "Loot ESP", side = "right", size = 200})
local ESPSettingsSection = VisualsTab:section({name = "ESP Settings", side = "right", size = 150})

-- Player Tab Sections
local MovementSection = PlayerTab:section({name = "Movement", side = "left", size = 200})

-- AutoFarm Tab Sections
local KillAuraSection = AutoFarmTab:section({name = "Kill Aura", side = "left", size = 150})
local MissionSection = AutoFarmTab:section({name = "Mission", side = "left", size = 150})
local FarmingSection = AutoFarmTab:section({name = "Farming", side = "right", size = 250})

-- Raids Tab Sections
local RaidSetupSection = RaidsTab:section({name = "Raid Setup", side = "left", size = 150})
local RaidControlSection = RaidsTab:section({name = "Raid Control", side = "right", size = 150})
local RaidStatsSection = RaidsTab:section({name = "Raid Statistics", side = "right", size = 150})

-- Combat Tab Elements
AutoParrySection:toggle({name = "Auto Parry", def = autoPerry, callback = function(Boolean)
    autoPerry = Boolean
end})

AutoParrySection:toggle({name = "No Stun", def = noStun, callback = function(Boolean)
    noStun = Boolean
end})

AutoParrySection:toggle({name = "AP Breaker", def = apBreaker, callback = function(Boolean)
    apBreaker = Boolean
end})

CombatUtilitySection:slider({name = "Save HP Threshold", def = saveHPThreshold, max = 100, min = 5, rounding = true, callback = function(Value)
    saveHPThreshold = Value
end})

CombatUtilitySection:toggle({name = "PermaDeath GodMode", def = permaDeathGodMode, callback = function(Boolean)
    permaDeathGodMode = Boolean
end})

-- Visuals Tab Elements
-- Player ESP Section
PlayerESPSection:toggle({name = "Enable Player ESP", def = ESP.Players.Enabled, callback = function(Boolean)
    ESP.Players.Enabled = Boolean
end})

PlayerESPSection:toggle({name = "Tracers", def = ESP.Players.Tracers, callback = function(Boolean)
    ESP.Players.Tracers = Boolean
end})

PlayerESPSection:toggle({name = "Health", def = ESP.Players.ShowHealth, callback = function(Boolean)
    ESP.Players.ShowHealth = Boolean
end})

PlayerESPSection:toggle({name = "Name", def = ESP.Players.ShowName, callback = function(Boolean)
    ESP.Players.ShowName = Boolean
end})

PlayerESPSection:toggle({name = "Weapon", def = ESP.Players.ShowWeapon, callback = function(Boolean)
    ESP.Players.ShowWeapon = Boolean
end})

PlayerESPSection:toggle({name = "Distance", def = ESP.Players.ShowDistance, callback = function(Boolean)
    ESP.Players.ShowDistance = Boolean
end})

PlayerESPSection:toggle({name = "Race", def = ESP.Players.ShowRace, callback = function(Boolean)
    ESP.Players.ShowRace = Boolean
end})

-- NPC ESP Section
NPCESPSection:toggle({name = "Enable NPC ESP", def = ESP.NPCs.Enabled, callback = function(Boolean)
    ESP.NPCs.Enabled = Boolean
end})

NPCESPSection:toggle({name = "Tracers", def = ESP.NPCs.Tracers, callback = function(Boolean)
    ESP.NPCs.Tracers = Boolean
end})

NPCESPSection:toggle({name = "Health", def = ESP.NPCs.ShowHealth, callback = function(Boolean)
    ESP.NPCs.ShowHealth = Boolean
end})

NPCESPSection:toggle({name = "Name", def = ESP.NPCs.ShowName, callback = function(Boolean)
    ESP.NPCs.ShowName = Boolean
end})

NPCESPSection:toggle({name = "Weapon", def = ESP.NPCs.ShowWeapon, callback = function(Boolean)
    ESP.NPCs.ShowWeapon = Boolean
end})

NPCESPSection:toggle({name = "Distance", def = ESP.NPCs.ShowDistance, callback = function(Boolean)
    ESP.NPCs.ShowDistance = Boolean
end})

NPCESPSection:toggle({name = "Race", def = ESP.NPCs.ShowRace, callback = function(Boolean)
    ESP.NPCs.ShowRace = Boolean
end})

-- Loot ESP Section
LootESPSection:toggle({name = "Enable LootBox ESP", def = ESP.LootBoxes.Enabled, callback = function(Boolean)
    ESP.LootBoxes.Enabled = Boolean
end})

LootESPSection:toggle({name = "LootBox Tracers", def = ESP.LootBoxes.Tracers, callback = function(Boolean)
    ESP.LootBoxes.Tracers = Boolean
end})

LootESPSection:toggle({name = "LootBox Name", def = ESP.LootBoxes.ShowName, callback = function(Boolean)
    ESP.LootBoxes.ShowName = Boolean
end})

LootESPSection:toggle({name = "LootBox Distance", def = ESP.LootBoxes.ShowDistance, callback = function(Boolean)
    ESP.LootBoxes.ShowDistance = Boolean
end})

LootESPSection:toggle({name = "Enable LootBag ESP", def = ESP.LootBags.Enabled, callback = function(Boolean)
    ESP.LootBags.Enabled = Boolean
end})

LootESPSection:toggle({name = "LootBag Tracers", def = ESP.LootBags.Tracers, callback = function(Boolean)
    ESP.LootBags.Tracers = Boolean
end})

LootESPSection:toggle({name = "LootBag Name", def = ESP.LootBags.ShowName, callback = function(Boolean)
    ESP.LootBags.ShowName = Boolean
end})

LootESPSection:toggle({name = "LootBag Distance", def = ESP.LootBags.ShowDistance, callback = function(Boolean)
    ESP.LootBags.ShowDistance = Boolean
end})

-- ESP Settings Section
ESPSettingsSection:slider({name = "Player ESP Distance", def = ESP.Players.MaxDistance, max = 5000, min = 100, rounding = true, callback = function(Value)
    ESP.Players.MaxDistance = Value
end})

ESPSettingsSection:slider({name = "NPC ESP Distance", def = ESP.NPCs.MaxDistance, max = 5000, min = 100, rounding = true, callback = function(Value)
    ESP.NPCs.MaxDistance = Value
end})

ESPSettingsSection:slider({name = "Loot ESP Distance", def = ESP.LootBoxes.MaxDistance, max = 5000, min = 100, rounding = true, callback = function(Value)
    ESP.LootBoxes.MaxDistance = Value
    ESP.LootBags.MaxDistance = Value
end})

ESPSettingsSection:colorpicker({
    name = "ESP Text Color", 
    cpname = "", 
    def = ESP.Players.TextColor, 
    callback = function(color)
        ESP.Players.TextColor = color
        ESP.NPCs.TextColor = color
        ESP.LootBoxes.TextColor = color
        ESP.LootBags.TextColor = color
    end
})

ESPSettingsSection:colorpicker({
    name = "ESP Tracer Color", 
    cpname = "", 
    def = ESP.Players.EnemyColor, 
    callback = function(color)
        ESP.Players.EnemyColor = color
    end
})

-- Player Tab Elements
-- Fly implementation using CFrame manipulation
local flying = false
local flyKeyPressed = false

-- Create part for flying
local flyPart = Instance.new("Part")
flyPart.Size = Vector3.new(1, 1, 1)
flyPart.Transparency = 1
flyPart.Anchored = true
flyPart.CanCollide = false
flyPart.Name = "FlyPart"
flyPart.Parent = workspace

local function updateFlyPart()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        flyPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end

local function fly()
    if not flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        flying = true
        updateFlyPart()
        
        -- Set up connection to handle flying
        RunService:BindToRenderStep("Flying", Enum.RenderPriority.Camera.Value + 1, function()
            if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character.HumanoidRootPart
                local camera = workspace.CurrentCamera
                local moveDirection = Vector3.new(0, 0, 0)
                
                -- Handle movement input
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                -- Normalize and apply speed
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * flySpeed / 10
                end
                
                -- Move character using CFrame
                rootPart.CFrame = rootPart.CFrame * CFrame.new(moveDirection)
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        flying = false
        RunService:UnbindFromRenderStep("Flying")
    end
end

MovementSection:toggle({name = "Fly", def = flyEnabled, callback = function(Boolean)
    flyEnabled = Boolean
    if flyEnabled then
        fly()
    else
        flying = false
        RunService:UnbindFromRenderStep("Flying")
    end
end})

MovementSection:keybind({name = "Fly Keybind", def = flyKeyCode, callback = function(Key)
    flyKeyCode = Key
    
    -- Set up input handling for fly keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == flyKeyCode then
            flyEnabled = not flyEnabled
            if flyEnabled then
                fly()
            else
                flying = false
                RunService:UnbindFromRenderStep("Flying")
            end
        end
    end)
end})

MovementSection:slider({name = "Fly Speed", def = flySpeed, max = 200, min = 10, rounding = true, callback = function(Value)
    flySpeed = Value
end})

-- Walk Speed implementation using CFrame
local function updateWalkSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        RunService:BindToRenderStep("CustomWalkSpeed", Enum.RenderPriority.Character.Value, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid.MoveDirection.Magnitude > 0 then
                    local moveSpeed = walkSpeed / 16 -- Scale to match default walk speed
                    rootPart.CFrame = rootPart.CFrame + humanoid.MoveDirection * moveSpeed * 0.016
                end
            end
        end)
    end
end

MovementSection:slider({name = "Walk Speed", def = walkSpeed, max = 200, min = 16, rounding = true, callback = function(Value)
    walkSpeed = Value
    updateWalkSpeed()
end})

-- Jump Power using CFrame
local function updateJumpPower()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- Connect to jump event
        humanoid.Jumping:Connect(function(active)
            if active and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, jumpPower / 10, 0)
            end
        end)
    end
end

MovementSection:slider({name = "Jump Power", def = jumpPower, max = 200, min = 50, rounding = true, callback = function(Value)
    jumpPower = Value
    updateJumpPower()
end})

-- AutoFarm Tab Elements
-- Kill Aura Section - Setting NPC health to 0
local function applyKillAura()
    RunService:BindToRenderStep("KillAura", Enum.RenderPriority.Character.Value + 1, function()
        if killAuraEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local playerPosition = rootPart.Position
            
            -- Loop through all workspace descendants
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Parent ~= LocalPlayer.Character then
                    local character = v.Parent
                    if character:FindFirstChild("HumanoidRootPart") then
                        local distance = (playerPosition - character.HumanoidRootPart.Position).Magnitude
                        
                        -- Check if in range and health percentage conditions met
                        if distance <= killAuraRange and (v.Health / v.MaxHealth) * 100 <= targetHealthPercent then
                            -- Set health to 0 to kill
                            v.Health = 0
                        end
                    end
                end
            end
        end
    end)
end

KillAuraSection:toggle({name = "Kill Aura", def = killAuraEnabled, callback = function(Boolean)
    killAuraEnabled = Boolean
    if killAuraEnabled then
        applyKillAura()
    else
        RunService:UnbindFromRenderStep("KillAura")
    end
end})

KillAuraSection:slider({name = "Kill Aura Range", def = killAuraRange, max = 50, min = 5, rounding = true, callback = function(Value)
    killAuraRange = Value
end})

KillAuraSection:slider({name = "Target Health %", def = targetHealthPercent, max = 100, min = 1, rounding = true, callback = function(Value)
    targetHealthPercent = Value
end})

-- Freeze Mobs by breaking their AI
local frozenMobs = {}

local function freezeMobs()
    RunService:BindToRenderStep("FreezeMobs", Enum.RenderPriority.Character.Value + 1, function()
        if freezeMobsEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local playerPosition = rootPart.Position
            
            -- Loop through all workspace descendants
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Parent ~= LocalPlayer.Character then
                    local character = v.Parent
                    if character:FindFirstChild("HumanoidRootPart") then
                        local distance = (playerPosition - character.HumanoidRootPart.Position).Magnitude
                        
                        if distance <= freezeRange then
                            -- Adding to tracked frozen mobs
                            if not frozenMobs[character] then
                                frozenMobs[character] = true
                                
                                -- Method 1: Disable pathfinding
                                if v:FindFirstChild("PathfindingModifier") then
                                    v.PathfindingModifier.Disabled = true
                                end
                                
                                -- Method 2: Set walkspeed to 0
                                v.WalkSpeed = 0
                                
                                -- Method 3: Anchor the root part
                                if character:FindFirstChild("HumanoidRootPart") then
                                    character.HumanoidRootPart.Anchored = true
                                end
                                
                                -- Method 4: Break animations
                                if v:FindFirstChildOfClass("Animator") then
                                    v:FindFirstChildOfClass("Animator"):Destroy()
                                end
                                
                                -- Method 5: Break AI scripts
                                for _, script in pairs(character:GetDescendants()) do
                                    if script:IsA("Script") or script:IsA("LocalScript") then
                                        script.Disabled = true
                                    end
                                end
                            end
                        else
                            -- Remove from tracking if out of range
                            if frozenMobs[character] then
                                frozenMobs[character] = nil
                            end
                        end
                    end
                end
            end
        end
    end)
end

KillAuraSection:toggle({name = "Freeze Mobs", def = freezeMobsEnabled, callback = function(Boolean)
    freezeMobsEnabled = Boolean
    if freezeMobsEnabled then
        freezeMobs()
    else
        RunService:UnbindFromRenderStep("FreezeMobs")
        -- Unfreeze all mobs
        for character, _ in pairs(frozenMobs) do
            if character and character:FindFirstChild("Humanoid") then
                local humanoid = character:FindFirstChild("Humanoid")
                humanoid.WalkSpeed = 16
                
                if character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.Anchored = false
                end
            end
        end
        frozenMobs = {}
    end
end})

KillAuraSection:slider({name = "Freeze Range", def = freezeRange, max = 50, min = 5, rounding = true, callback = function(Value)
    freezeRange = Value
end})

-- Mission Section
MissionSection:toggle({name = "Auto Mission", def = autoMission, callback = function(Boolean)
    autoMission = Boolean
end})

MissionSection:dropdown({
    name = "Mission Selection", 
    def = selectedMission, 
    options = {"None", "Mission 1", "Mission 2", "Mission 3", "Mission 4", "Mission 5"}, 
    callback = function(mission)
        selectedMission = mission
    end
})

MissionSection:toggle({name = "TP to Mission", def = tpToMission, callback = function(Boolean)
    tpToMission = Boolean
end})

MissionSection:toggle({name = "Auto Grip", def = autoGrip, callback = function(Boolean)
    autoGrip = Boolean
end})

-- Farming Section
FarmingSection:toggle({name = "Auto Farm", def = autoFarmEnabled, callback = function(Boolean)
    autoFarmEnabled = Boolean
end})

FarmingSection:slider({name = "Farm Distance", def = farmDistance, max = 20, min = 1, rounding = true, callback = function(Value)
    farmDistance = Value
end})

FarmingSection:dropdown({
    name = "Position", 
    def = farmPosition, 
    options = {"Above", "Under", "Orbit", "Behind", "Front"}, 
    callback = function(position)
        farmPosition = position
    end
})

FarmingSection:toggle({name = "Auto Loot", def = autoLoot, callback = function(Boolean)
    autoLoot = Boolean
end})

FarmingSection:toggle({name = "Auto Hit", def = autoHit, callback = function(Boolean)
    autoHit = Boolean
end})

-- Raids Tab Elements
-- Raid Setup Section
RaidSetupSection:toggle({name = "Auto Launch Raid", def = autoLaunchRaid, callback = function(Boolean)
    autoLaunchRaid = Boolean
end})

RaidSetupSection:dropdown({
    name = "Raid Boss", 
    def = selectedRaidBoss, 
    options = {"None", "Boss 1", "Boss 2", "Boss 3", "Boss 4", "Boss 5"}, 
    callback = function(boss)
        selectedRaidBoss = boss
    end
})

-- Raid Control Section
RaidControlSection:toggle({name = "Auto Raid", def = autoRaid, callback = function(Boolean)
    autoRaid = Boolean
end})

RaidControlSection:toggle({name = "Auto Retry", def = autoRetry, callback = function(Boolean)
    autoRetry = Boolean
end})

RaidControlSection:button({name = "Force Start Raid", callback = function()
    -- Implementation for force starting a raid
    if selectedRaidBoss ~= "None" then
        Notify({
            Title = "RoHub",
            Description = "Starting raid with boss: " .. selectedRaidBoss,
            Duration = 3
        })
    else
        Notify({
            Title = "RoHub",
            Description = "Please select a raid boss first",
            Duration = 3
        })
    end
end})


-- Open the Combat tab by default
CombatTab:openpage()

-- Load notification
Notify({
    Title = "RoHub",
    Description = "UI Loaded Successfully!",
    Duration = 5
})

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
        while wait(0.1) do 
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
        while wait(0.1) do 
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
        while wait(0.1) do 
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
