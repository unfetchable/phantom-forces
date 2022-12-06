-- phantom forces, silent aim - for Karlo#4262
-- by Harmer#0123, working 12/6/2022

-- variables
local players = game:GetService("Players");
local replicated = game:GetService("ReplicatedFirst");
local localplayer = players.LocalPlayer;
local camera = workspace.CurrentCamera;

-- modules
local particle;
local replication;
local physics, solve;

for _, module in next, getloadedmodules() do
    if module.Name == "particle" then
        particle = require(module);
    elseif module.Name == "ReplicationInterface" then
        replication = require(module);
    elseif module.Name == "physics" then
        physics = require(module);
        solve = debug.getupvalue(physics.timehit, 2);
    end
end

-- functions
local function isVisible(position, ignore)
    return #camera:GetPartsObscuringTarget({ position }, ignore) == 0;
end

local function getClosest(dir, origin, ignore)
    local _angle = fov or 180;
    local _position, _entry;

    replication.operateOnAllEntries(function(player, entry)
        local tpObject = entry and entry._thirdPersonObject;
        local character = tpObject and tpObject._character;
        if character and player.Team ~= localplayer.Team then
            local position = character[targetedPart == "Random" and
                (math.random() < (headChance or 0.5) and "Head" or "Torso") or
                (targetedPart or "Head")].Position;

            if not (visibleCheck and not isVisible(position, ignore)) then
                local dot = dir.Unit:Dot((position - origin).Unit);
                local angle = 180 - (dot + 1) * 90;
                if angle < _angle then
                    _angle = angle;
                    _position = position;
                    _entry = entry;
                end
            end
        end
    end);

    return _position, _entry;
end

local function trajectory(dir, velocity, accel, speed)
    local r1, r2, r3, r4 = solve(
        accel:Dot(accel) * 0.25,
        accel:Dot(velocity),
        accel:Dot(dir) + velocity:Dot(velocity) - speed^2,
        dir:Dot(velocity) * 2,
        dir:Dot(dir));

    local time = (r1>0 and r1) or (r2>0 and r2) or (r3>0 and r3) or r4;
    local bullet = 0.5*accel*time + dir/time + velocity;
    return bullet, time;
end

-- hooks
local old;
old = hookfunction(particle.new, function(args)
    if debug.info(2, "n") == "fireRound" then
        local position, entry = getClosest(args.velocity, args.visualorigin, args.physicsignore);
        if position and entry then
            local index = table.find(debug.getstack(2), args.velocity);

            args.velocity = trajectory(
                position - args.visualorigin,
                entry._velspring._p0,
                -args.acceleration,
                args.velocity.Magnitude);

            debug.setstack(2, index, args.velocity);
        end
    end
    return old(args);
end);

task.spawn(function()
    local text = Drawing.new('Text')

    text.Transparency = 1
    text.Visible = true
    text.ZIndex = 1
    text.Center = true
    text.Outline = true
    text.Color = Color3.new(1, 1, 1)
    text.OutlineColor = Color3.new(0, 0, 0)
    text.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, 30)
    text.Font = Drawing.Fonts.Plex
    text.Size = 13

    while task.wait(0.9) do
        text.Text = "offline's silent | for Karlo | "..os.date("%x %X", os.time())
    end
end)