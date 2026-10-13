local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function findTargets()
    local targets = {}
    local search = getgenv().TARGET

    if type(search) ~= "string" or search == "" then
        return targets
    end

    search = string.lower(search)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
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

local targets = findTargets()

for _, player in ipairs(targets) do
    print("Jugador encontrado:", player.Name, player.DisplayName)
end
