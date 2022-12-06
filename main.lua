-- made by Offline
-- #pfskiddies

assert(Drawing, "missing dependency: drawing")
repeat
	task.wait()
until game:IsLoaded()
-- Services
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
-- Localizing
local local_player = players.LocalPlayer
local get_children = game.GetChildren
local find_first_child = game.FindFirstChild
local new_drawing = Drawing.new
local camera = workspace.CurrentCamera or game:GetService("Workspace").CurrentCamera

-- Setup
local rootPart = "Head"
local objects_folder: Folder = game:GetService("Workspace").Players
local coreGui = game:GetService("CoreGui")
-- main
local object_ID = {}
local eps = {}

local function Setup()
	for _, team in pairs(objects_folder:GetChildren()) do
		for _, object in pairs(get_children(team)) do
			local id = object:GetDebugId()
			if not table.find(object_ID, id) then
				table.insert(object_ID, id)
				eps[id] = {
					esp_object = object,
					text_esp = new_drawing("Text", false),
					highlight = Instance.new("Highlight", coreGui),
				}
				eps[id].text_esp.Center = true
				eps[id].text_esp.Outline = true
				eps[id].text_esp.Font = 1
				eps[id].text_esp.Size = 14
				eps[id].highlight.Adornee = eps[id].esp_object
				eps[id].highlight.FillColor = Color3.new(1, 0, 0)
				eps[id].highlight.OutlineColor = Color3.new(.5, 0, 0)
				eps[id].highlight.FillTransparency = 0.5
				eps[id].highlight.OutlineTransparency = 0.9
			end
		end
	end
end

Setup()
shared.max_distance = math.huge
shared.object_esp_enabled = true
run_service.RenderStepped:Connect(function()
	if not shared.object_esp_enabled then
		return
	end
	for _, value in pairs(eps) do
		if
			shared.object_esp_enabled
			and find_first_child(value.esp_object, rootPart)
			and value.esp_object.Parent.Name ~= local_player.TeamColor.Name
		then
			local name = value.esp_object.Name
			local vec3_position = find_first_child(value.esp_object, rootPart).Position
			local screen_position, on_screen = camera:WorldToScreenPoint(vec3_position)
			local distant_from_character = local_player:DistanceFromCharacter(vec3_position)
			if on_screen and math.round(distant_from_character) <= shared.max_distance then
				value.text_esp.Position = Vector2.new(
					screen_position.X,
					screen_position.Y + math.clamp(distant_from_character / 10, 10, 30) - 10
				)
				value.text_esp.Color = Color3.fromHSV(math.clamp(distant_from_character / 5, 0, 125) / 255, 0.75, 1)
				value.text_esp.Text = name .. "[" .. math.round(distant_from_character) .. "]"
				value.text_esp.Size = math.clamp(30 - distant_from_character / 10, 16, 30)
				value.text_esp.Transparency = math.clamp((500 - distant_from_character) / 200, 0.2, 1)
				value.text_esp.Visible = false
				 -- value.highlight.FillColor =
				 -- 	Color3.fromHSV(math.clamp(distant_from_character / 5, 0, 125) / 255, 0.75, 1)
				 -- value.highlight.FillTransparency = math.clamp((500 - distant_from_character) / 200, 0.2, 1)

				value.highlight.Enabled = true
			else
				value.text_esp.Visible = false
				value.highlight.Enabled = false
			end
		else
			value.text_esp.Visible = false
			value.highlight.Enabled = false
		end
	end
end)
objects_folder.DescendantAdded:Connect(function()
	Setup()
end)
objects_folder.DescendantRemoving:Connect(function(child)
	local id = child:GetDebugId()
	if table.find(object_ID, id) then
		eps[id].text_esp:Remove()
		eps[id].highlight:Destroy()
		eps[id].esp_object = nil
		eps[id] = nil
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
        wm_text.Text = 'offline esp | patch fix | '..os.date("%x %X", os.time())
    end
end)