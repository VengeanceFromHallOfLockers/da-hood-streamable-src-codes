getgenv().Ordium = {
    SilentAim = {
        Key = "C",
        Enabled = true,
        Prediction = 0.119,
        AimingType = "Default", -- Closest Part, Default
        AimPart = "HumanoidRootPart",
        
        ChanceData = {UseChance = false, Chance = 100},
        FOVData = {Radius = 25, Visibility = true, Rainbow = false},

        AimingData = {CheckKnocked = true, CheckGrabbed = true,
        CheckWalls = true},

    },
    Tracing = {
        Key = 'C',
        Enabled = true,
        Prediction = 8,
        AimPart = "HumanoidRootPart",
        TracingOptions = {Strength = "Hard" , AimingType = "Closest Part",  Smoothness = 0.11} 
    }
}

local Ordium = {functions = {}}

local Vector2New, Cam, Mouse, client, find, Draw, Inset, players, RunService, UIS=
    Vector2.new,
    workspace.CurrentCamera,
    game.Players.LocalPlayer:GetMouse(),
    game.Players.LocalPlayer,
    table.find,
    Drawing.new,
    game:GetService("GuiService"):GetGuiInset().Y,
    game.Players, 
    game.RunService,
    game:GetService("UserInputService")


local mf, rnew = math.floor, Random.new

local Targetting
local lockedCamTo

local userinputservice = game:GetService('UserInputService')
local RS = game:GetService('RunService')

local Circle = Drawing.new("Circle")

local c = Drawing.new('Circle')
c.Radius = getgenv().Ordium.SilentAim.FOVData.Radius *3.71
c.Thickness = 4.5 
c.Color = Color3.new(1,1,1)
c.Visible = getgenv().Ordium.SilentAim.FOVData.Visibility

local c22 = Drawing.new('Circle')
c22.Radius = getgenv().Ordium.SilentAim.FOVData.Radius *3.69
c22.Thickness = 4.5 
c22.Color = Color3.new(1,1,1)
c22.Visible = getgenv().Ordium.SilentAim.FOVData.Visibility

local oc1 = Drawing.new('Circle')
oc1.Radius = getgenv().Ordium.SilentAim.FOVData.Radius *3.7
oc1.Thickness = 2.5 
oc1.Color = Color3.new(0,0,0)
oc1.Visible = getgenv().Ordium.SilentAim.FOVData.Visibility

local oc2 = Drawing.new('Circle')
oc2.Radius = getgenv().Ordium.SilentAim.FOVData.Radius *3.7
oc2.Thickness = 2.5 
oc2.Color = Color3.new(0,0,0)
oc2.Visible = getgenv().Ordium.SilentAim.FOVData.Visibility
 
local UpdateFOV = function()
    c.Position = Vector2New(Mouse.X, Mouse.Y + (Inset))
end

local UpdateFOV1 = function()
    oc1.Position = Vector2New(Mouse.X, Mouse.Y + (Inset))
end

local UpdateFOV2 = function()
    oc2.Position = Vector2New(Mouse.X, Mouse.Y + (Inset))
end

local UpdateFOV3 = function()
    c22.Position = Vector2New(Mouse.X, Mouse.Y + (Inset))
end

RS.Heartbeat:Connect(UpdateFOV)
RS.Heartbeat:Connect(UpdateFOV1)
RS.Heartbeat:Connect(UpdateFOV2)
RS.Heartbeat:Connect(UpdateFOV3)

if getgenv().Ordium.SilentAim.FOVData.Rainbow ~= false then
    while true do
        wait(0)
    oc1.Color = Color3.fromHSV((tick() % 5 / 5), 1, 1)
    oc2.Color = Color3.fromHSV((tick() % 5 / 5), 1, 1)
    end
    end

Ordium.functions.onKeyPress = function(inputObject)
    if inputObject.KeyCode == Enum.KeyCode[getgenv().Ordium.SilentAim.Key:upper()] then
        getgenv().Ordium.SilentAim.Enabled = not getgenv().Ordium.SilentAim.Enabled
    end

    if inputObject.KeyCode == Enum.KeyCode[getgenv().Ordium.Tracing.Key:upper()] then
        getgenv().Ordium.Tracing.Enabled = not getgenv().Ordium.Tracing.Enabled
        if getgenv().Ordium.Tracing.Enabled then
            lockedCamTo = Ordium.functions.returnClosestPlayer(getgenv().Ordium.SilentAim.ChanceData.Chance)
        end
    end
end

UIS.InputBegan:Connect(Ordium.functions.onKeyPress)


Ordium.functions.wallCheck = function(direction, ignoreList)
    if not getgenv().Ordium.SilentAim.AimingData.CheckWalls then
        return true
    end

    local ray = Ray.new(Cam.CFrame.p, direction - Cam.CFrame.p)
    local part, _, _ = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, ignoreList)

    return not part
end

Ordium.functions.pointDistance = function(part)
    local OnScreen = Cam.WorldToScreenPoint(Cam, part.Position)
    if OnScreen then
        return (Vector2New(OnScreen.X, OnScreen.Y) - Vector2New(Mouse.X, Mouse.Y)).Magnitude
    end
end

Ordium.functions.returnClosestPart = function(Character)
    local data = {
        dist = math.huge,
        part = nil,
        filteredparts = {},
        classes = {"Part", "BasePart", "MeshPart"}
    }

    if not (Character and Character:IsA("Model")) then
        return data.part
    end
    local children = Character:GetChildren()
    for _, child in pairs(children) do
        if table.find(data.classes, child.ClassName) then
            table.insert(data.filteredparts, child)
            for _, part in pairs(data.filteredparts) do
                local dist = Ordium.functions.pointDistance(part)
                if Circle.Radius > dist and dist < data.dist then
                    data.part = part
                    data.dist = dist
                end
            end
        end
    end
    return data.part
end

Ordium.functions.returnClosestPlayer = function (amount)
    local data = {
        dist = 1/0,
        player = nil
    }

    amount = amount or nil

    for _, player in pairs(players:GetPlayers()) do
        if (player.Character and player ~= client) then
            local dist = Ordium.functions.pointDistance(player.Character.HumanoidRootPart)
            if Circle.Radius > dist and dist < data.dist and 
            Ordium.functions.wallCheck(player.Character.Head.Position,{client, player.Character}) then
                data.dist = dist
                data.player = player
            end
        end
    end
    local calc = mf(rnew().NextNumber(rnew(), 0, 1) * 100) / 100
    local use = getgenv().Ordium.SilentAim.ChanceData.UseChance
    if use and calc <= mf(amount) / 100 then
        return calc and data.player
    else
        return data.player
    end
end

Ordium.functions.setAimingType = function (player, type)
    local previousSilentAimPart = getgenv().Ordium.SilentAim.AimPart
    local previousTracingPart = getgenv().Ordium.Tracing.AimPart
    if type == "Closest Part" then
        getgenv().Ordium.SilentAim.AimPart = tostring(Ordium.functions.returnClosestPart(player.Character))
        getgenv().Ordium.Tracing.AimPart = tostring(Ordium.functions.returnClosestPart(player.Character))
    elseif type == "Closest Point" then
        Ordium.functions.returnClosestPoint()
    elseif type == "Default" then
        getgenv().Ordium.SilentAim.AimPart = previousSilentAimPart
        getgenv().Ordium.Tracing.AimPart = previousTracingPart
    else
        getgenv().Ordium.SilentAim.AimPart = previousSilentAimPart
        getgenv().Ordium.Tracing.AimPart = previousTracingPart
    end
end

Ordium.functions.aimingCheck = function (player)
    if getgenv().Ordium.SilentAim.AimingData.CheckKnocked == true and player and player.Character then
        if player.Character.BodyEffects["K.O"].Value then
            return true
        end
    end
    if getgenv().Ordium.SilentAim.AimingData.CheckGrabbed == true and player and player.Character then
        if player.Character:FindFirstChild("GRABBING_CONSTRAINT") then
            return true
        end
    end
    return false
end

local lastRender = 0
local interpolation = 0.01

RunService.RenderStepped:Connect(function(delta)
    local valueTypes = 1.375
    lastRender = lastRender + delta
    while lastRender > interpolation do
        lastRender = lastRender - interpolation
    end
    if getgenv().Ordium.Tracing.Enabled and lockedCamTo ~= nil and getgenv().Ordium.Tracing.TracingOptions.Strength == "Hard" then
        local Vel =  lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Velocity / (getgenv().Ordium.Tracing.Prediction * valueTypes)
        local Main = CFrame.new(Cam.CFrame.p, lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Position + (Vel))
        Cam.CFrame = Cam.CFrame:Lerp(Main ,getgenv().Ordium.Tracing.TracingOptions.Smoothness , Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Ordium.functions.setAimingType(lockedCamTo, getgenv().Ordium.Tracing.TracingOptions.AimingType)
    elseif getgenv().Ordium.Tracing.Enabled and lockedCamTo ~= nil and getgenv().Ordium.Tracing.TracingOptions.Strength == "Soft" then
        local Vel =  lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Velocity / (getgenv().Ordium.Tracing.Prediction / valueTypes)
        local Main = CFrame.new(Cam.CFrame.p, lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Position + (Vel))
        Cam.CFrame = Cam.CFrame:Lerp(Main ,getgenv().Ordium.Tracing.TracingOptions.Smoothness , Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Ordium.functions.setAimingType(lockedCamTo, getgenv().Ordium.Tracing.TracingOptions.AimingType)
    else

    end
end)

task.spawn(function ()
    while task.wait() do
        if Targetting then
            Ordium.functions.setAimingType(Targetting, getgenv().Ordium.SilentAim.AimingType)
        end
    end
end)


local __index
__index = hookmetamethod(game,"__index", function(Obj, Property)
    if Obj:IsA("Mouse") and Property == "Hit" then
        Targetting = Ordium.functions.returnClosestPlayer(getgenv().Ordium.SilentAim.ChanceData.Chance)
        if Targetting ~= nil and getgenv().Ordium.SilentAim.Enabled and not Ordium.functions.aimingCheck(Targetting) then
            local currentvelocity = Targetting.Character[getgenv().Ordium.SilentAim.AimPart].Velocity
            local currentposition = Targetting.Character[getgenv().Ordium.SilentAim.AimPart].CFrame

            return currentposition + (currentvelocity * getgenv().Ordium.SilentAim.Prediction)
        end
    end
    return __index(Obj, Property)
end)
