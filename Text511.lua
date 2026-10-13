local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configuración: pon el nombre (o parte del nombre) del jugador
-- Ejemplo: getgenv().TARGET = "Juan"
-- getgenv().TARGET = "SheriffPlayer123"

local function findKnife()
    local char = LocalPlayer.Character
    if not char then return nil end

    if char:FindFirstChild("Knife") then
        return char.Knife
    end

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        local knife = bp:FindFirstChild("Knife")
        if knife then
            return knife
        end
    end

    return nil
end

local function findTargets()
    local targets = {}
    local search = getgenv().TARGET

    if type(search) \~= "string" or search == "" then
        return targets
    end

    search = string.lower(search)

    for _, player in ipairs(Players:GetPlayers()) do
        if player \~= LocalPlayer and player.Character and player.Character:FindFirstChild("RightLowerArm") then
            local username = string.lower(player.Name)
            local displayName = string.lower(player.DisplayName)

            if string.find(username, search, 1, true)
                or string.find(displayName, search, 1, true) then
                table.insert(targets, player)
            end
        end
    end

    return targets
end

local function equipAndActivateKnife()
    local knife = findKnife()
    if not knife then return end

    local char = LocalPlayer.Character
    if not char then return end

    -- Desequipar otras tools
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool \~= knife then
            LocalPlayer.Character.Humanoid:UnequipTools()
        end
    end

    -- Equipar Knife
    LocalPlayer.Character.Humanoid:EquipTool(knife)
    task.wait(0.5) -- Espera a que la Knife esté equipada

    -- Simular activación de la herramienta (click)
    knife:Activate()

    -- Targets por nombre
    local targets = findTargets()

    -- Fire HandleTouched al mismo tiempo
    for _, plr in ipairs(targets) do
        if knife.Events and knife.Events:FindFirstChild("HandleTouched") then
            knife.Events.HandleTouched:FireServer(plr.Character.RightLowerArm)
        end
    end
end

equipAndActivateKnife()
