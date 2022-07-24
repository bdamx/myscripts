local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "anti british hub", HidePremium = true, SaveConfig = false, ConfigFolder = "OrionTest"})


-- functions

-- medkit
if not getgenv().MedkitGiver then
    for i,v in pairs(workspace:GetDescendants()) do
        if v:IsA('ClickDetector') and v.Parent.Parent.Name == 'Medkit' then
            getgenv().MedkitGiver = v
        end
    end
end

local medkitClickDetector = getgenv().MedkitGiver



-- anti grab
local hitboxes = {
    'LeftHand',
    'LeftLowerArm',
    'RightHand',
    'RightLowerArm',
    'LeftFoot',
    'LeftLowerLeg',
    'RightFoot',
    'RightLowerLeg'

}

if not getgenv().titan_touch_connections then
    getgenv().titan_touch_connections = {}
end

local titanTouchConnections = getgenv().titan_touch_connections


local function titanCheck(instance)
    local isTitan = false

    local splitName = instance.Name:split(' ')
    if splitName[1] == 'Titan' and instance:IsA('Model') then isTitan = true end

    return isTitan
end

local function disconnectTitanGrab(titan)

    for i,v in pairs(hitboxes) do
        repeat task.wait() until titan:FindFirstChild(tostring(v))
    end


    for i,v in pairs(titan:GetChildren()) do
        if v:IsA('BasePart') and table.find(hitboxes, v.Name) then
            v.CanTouch = false
        end
    end
end

local function connectTitanGrabs()
    for _, titan in pairs(workspace:GetDescendants()) do
        if titanCheck(titan) then
            for i,v in pairs(hitboxes) do
                repeat task.wait() until titan:FindFirstChild(tostring(v))
            end


            for i,v in pairs(titan:GetChildren()) do
                if v:IsA('BasePart') and table.find(hitboxes, v.Name) then
                    v.CanTouch = true
                end
            end
        end
    end
end

local function connectTitans()
    for _, object in pairs(workspace:GetChildren()) do
        if object.Name == 'Spawner' then
            for i,v in pairs(object:GetDescendants()) do

                if titanCheck(v) then
                    disconnectTitanGrab(v)
                end
            end


            func = object.DescendantAdded:Connect(function(descendant)
                if titanCheck(descendant) then
                    disconnectTitanGrab(descendant)
                end
            end)

            table.insert(titanTouchConnections, func)

        elseif titanCheck(object) then

            disconnectTitanGrab(object)

        end
    end

    local func2 = workspace.ChildAdded:Connect(function(child)
        if titanCheck(child) then
            disconnectTitanGrab(child)
        end
    end)

    table.insert(titanTouchConnections, func2)

end


















local gui = game:GetService("CoreGui").Orion

local GearTab = Window:MakeTab({
    Name = "Gear",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

GearTab:AddButton({
    Name = "Refill",
    Callback = function()

        local player = game:GetService('Players').LocalPlayer

        if not player.Backpack:FindFirstChild('Gear') then
            OrionLib:MakeNotification({
                Name = "Bruh",
                Content = "u don't have gear dumbass",
                Image = "rbxassetid://4483345998",
                Time = 5

            })
            return
        end

        local conn = getconnections(game.ReplicatedStorage.UI.RefillEvent.OnClientEvent)[1]

        local func = conn.Function

        setconstant(func, 4, 'Archivable')
        setconstant(func, 5, 'Stop')

        func('Refilling')
    end
})

local TitanTab = Window:MakeTab({
    Name = "Titans",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TitanTab:AddToggle({
    Name = "Anti Grab(You will still get bit)",
    Default = false,
    Callback = function(value)
        if value then
            connectTitans()

        else

            for i,v in pairs(titan_touch_connections) do
                v:Disconnect()
            end

            connectTitanGrabs()

            table.clear(titan_touch_connections)

        end
    end
})

local OtherTab = Window:MakeTab({
    Name = "Other",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

OtherTab:AddButton({
    Name = "Get Medkit",
    Callback = function()
        if not medkitClickDetector then
            OrionLib:MakeNotification({
                Name = "You can't heal lol",
                Content = "no medkit giver found",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            return
        end
        fireclickdetector(medkitClickDetector)
    end
})

game:GetService('UserInputService').InputBegan:Connect(function(input, isTyping)
    if isTyping then return end

    if input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

OrionLib:Init()

