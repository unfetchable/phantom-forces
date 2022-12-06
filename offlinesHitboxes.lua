-- made by Offline
-- #pfskiddies

Size = 8 -- setting higher than 8 will make your guns deal 0 damage, 2-5 to look legit
Transparency = 0.5

game:GetService("RunService").Stepped:Connect(
    function()
        for i, v in next, workspace.Players:GetDescendants() do
            if v:FindFirstChild("Left Leg") and not v:FindFirstChildWhichIsA("MeshPart") then
                sethiddenproperty(v["Left Leg"], "Massless", true)
                v["Left Leg"].CanCollide = false
                v["Left Leg"].Transparency = Transparency
                if
                    v["Left Leg"].Size ~= Vector3.new(Size, Size, Size) and
                        v["Left Leg"].Mesh.Scale ~= Vector3.new(Size, Size, Size)
                 then
                    v["Left Leg"].Size = Vector3.new(Size, Size, Size)
                    v["Left Leg"].Mesh.Scale = Vector3.new(Size, Size, Size)
                end
                if v["Left Leg"].Parent.Parent.Name == "Bright blue" then
                    v["Left Leg"].BrickColor = BrickColor.new("Bright blue")
                end
                if v["Left Leg"].Parent.Parent.Name == "Bright orange" then
                    v["Left Leg"].BrickColor = BrickColor.new("Bright orange")
                end
            end
        end
    end
)

while wait() do
    for i, v in next, workspace.Ignore.DeadBody:GetChildren() do
        v:Destroy()
    end
end