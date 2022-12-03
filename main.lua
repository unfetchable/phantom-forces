local torso_size = Vector3.new(5, 5, 5) -- default 2, 2, 1
local step = 1/24

local s_players = game:GetService('Players')
local s_rep_first = game:GetService('ReplicatedFirst')

local esp = {} do
    esp.objects = {}

    local f_object = Instance.new('Folder')
    f_object.Name = tostring(math.random(111111111, 999999999))
    f_object.Parent = workspace

    function esp.new(player)
        esp.objects[player] = Instance.new('Highlight')

        local p_cham = esp.objects[player]
        p_cham.Enabled = true
        p_cham.FillColor = Color3.new(1, 0, 0)
        p_cham.OutlineColor = Color3.new(0.5, 0, 0)
        p_cham.FillTransparency = 0.5
        p_cham.OutlineTransparency = 0.9
        p_cham.Parent = f_object

        return p_cham
    end

    for _, player in pairs(s_players:GetPlayers()) do esp.new(player) end

    s_players.PlayerAdded:Connect(function(player) esp.new(player) end)
    s_players.PlayerRemoving:Connect(function(player) esp.objects[player]:Destroy() end)
end

local entity = {} do
    local replication = require(s_rep_first.ClientModules.Rewrite.Replication.ReplicationInterface)

    function entity.get(player)
        local p_entry = replication.getEntry(player)

        if not p_entry then return end
        if not p_entry._thirdPersonObject then return end
        if not p_entry._thirdPersonObject:getCharacterModel() then return end
        
        return p_entry, p_entry._thirdPersonObject, p_entry._thirdPersonObject:getCharacterModel()
    end

    local playerStatus = require(s_rep_first.ClientModules.Rewrite.PlayerStatus.PlayerStatusInterface)

    function entity.friendly(player)
        local p_entry = playerStatus.getEntry(player)

        if not p_entry then return end
        
        return playerStatus.isFriendly(player)
    end
end

local torso_default = Vector3.new(2, 2, 1)

task.spawn(function()
    while task.wait(step) do
        for player, cham in pairs(esp.objects) do
            local p_entity, p_object, p_model = entity.get(player)

            if not p_entity then
                 cham.Adornee = nil
                 continue
            end

            if not entity.friendly(player) and p_model.Name ~= 'Dead' and p_model.Parent ~= workspace.Ignore.DeadBody then
                p_model.Torso.Size = torso_size

                cham.Adornee = p_model
                cham.Enabled = true
            else
                p_model.Torso.Size = Vector3.new(2, 2, 1)

                cham.Adornee = nil
                cham.Enabled = false
            end
        end
    end
end)

task.spawn(function()
    local wm_text = Drawing.new('Text')

    wm_text.Transparency = 1
    wm_text.Visible = true
    wm_text.ZIndex = 1
    wm_text.Center = true
    wm_text.Outline = true
    wm_text.Color = Color3.new(1, 1, 1)
    wm_text.OutlineColor = Color3.new(0, 0, 0)
    wm_text.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, 30)
    wm_text.Font = Drawing.Fonts.Plex
    wm_text.Size = 13

    while task.wait(0.9) do
        wm_text.Text = 'offline esp | demo | '..os.date("%x %X", os.time())
    end
end)