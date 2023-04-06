-- ENCRYPT SOURCE LEAK
-- FUCK KAZ & EU FAT ASS SKIDS
-- DONT BUY FROM GG/EXTERNAL NOR GG/EXTERNAL
-- LEAKED BY xeno#0666 . RBLVengeance#0001
-- ONLY BUY FROM discord.gg/streamables 
-- discord.gg/rbl
-- discord.gg/rbldhc 
-- discord.gg/kittenassist
-- https://discord.gg/AdBGh4Fksh
-- https://discord.gg/ntjB49uYAd

getgenv().FovKey = "b" -- fov switch key, if you dont wanna look blatant long range rev

getgenv().Parts = {"Head", "HumanoidRootPart, UpperTorso"} -- {"Head", "HumanoidRootPart"}

getgenv().Hitchance = 100

getgenv().Fov = 10 -- semi legit Rev: 9, 8, 8.5, 7.6, 7.5, 7.3
                   -- Rev(far): 7, 6.7, 6.4, 5.6, 5.3
                   -- Shotgun: 12, 11, 10, 10.5, 9.8, 9.4,
                   ------------------
                   -- legit star =
                   -- Rev: 6, 5.7, 5.5, 5.2, 5, 4.8, 4.6, 4.3, 4 
                   -- Rev(far): 4, 3.8, 3.6, 3.4, 3.2, 3, 2.8
                   -- Shotgun: 7, 6.8, 6.7, 6.5, 6.3, 6.1, 6, 5.7, 5.5, 5.3

getgenv().ShowFOV = true

getgenv().MacroKey = "x" -- to use the built in lua macro

-- soft Aim
getgenv().AimlockKey = "q"
getgenv().SmoothnessAmount = 0.016
getgenv().PredictionVelocity = 7.12
----------------------------------
local Aiming = loadstring(game:HttpGet("https://pastebin.com/raw/3A9wdSkL"))()
Aiming.ShowFOV = getgenv().ShowFOV
Aiming.TargetPart = getgenv().Parts
Aiming.HitChance = getgenv().Hitchance
Aiming.TeamCheck(false)
Aiming.ShowFov = false
 
 
 
local Workspace = game:GetService("Workspace")
 
local Players = game:GetService("Players")
 
local RunService = game:GetService("RunService")
 
local UserInputService = game:GetService("UserInputService")
 
 
 
local LocalPlayer = Players.LocalPlayer
 
local Mouse = LocalPlayer:GetMouse()
 
local CurrentCamera = Workspace.CurrentCamera
 
 
 local DaHoodSettings = {
 
    SilentAim = true,
 
    AimLock = false,
 
    Prediction = 0.119,
 
    AimLockKeybind = Enum.KeyCode.E,
 
    Resolver = true,
 
}
 
getgenv().DaHoodSettings = DaHoodSettings

 
 
 
 
 
function Aiming.Check()
 
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
 
        return false
 
    end
 
    local Character = Aiming.Character(Aiming.Selected)
 
    local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
 
    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
 
    if (KOd or Grabbed) then
 
        return false
 
    end
 
    return true
 
end
 
 

task.spawn(function()
 
    while task.wait() do
 
        if DaHoodSettings.Resolver and Aiming.Selected ~= nil and (Aiming.Selected.Character)  then
 
            local oldVel = game.Players[Aiming.Selected.Name].Character.HumanoidRootPart.Velocity
 
            game.Players[Aiming.Selected.Name].Character.HumanoidRootPart.Velocity = Vector3.new(oldVel.X, -0, oldVel.Z)
 
        end 
 
    end
 
end)
 
local Script = {Functions = {}}
 
 
 
Script.Functions.getToolName = function(name)
 
    local split = string.split(string.split(name, "[")[2], "]")[1]
 
    return split
 
end
 
 
 
Script.Functions.getEquippedWeaponName = function(player)
 
   if (player.Character) and player.Character:FindFirstChildWhichIsA("Tool") then
 
      local Tool =  player.Character:FindFirstChildWhichIsA("Tool")
 
      if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and not string.find(Tool.Name, "Phone") then 
 
         return Script.Functions.getToolName(Tool.Name)
 
      end
 
   end
 
   return nil
 
end
 
 
 
game:GetService("RunService").RenderStepped:Connect(function()
 
    if Script.Functions.getEquippedWeaponName(game.Players.LocalPlayer) ~= nil then
 
        local WeaponSettings = GunSettings[Script.Functions.getEquippedWeaponName(game.Players.LocalPlayer)]
 
        if WeaponSettings ~= nil then
 
            Aiming.FOV = WeaponSettings.FOV
 
        else
 
            Aiming.FOV = 11.5
 
        end
 
    end    
 
end)
 
 
 
local __index
 
__index = hookmetamethod(game, "__index", function(t, k)
 
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and Aiming.Check()) then
 
        local SelectedPart = Aiming.SelectedPart
 
        if (DaHoodSettings.SilentAim and (k == "Hit" or k == "Target")) then
 
            local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
 
            return (k == "Hit" and Hit or SelectedPart)
 
        end
 
    end
 
 
 
    return __index(t, k)
 
end)
 
 
 
RunService:BindToRenderStep("AimLock", 0, function()
 
    if (DaHoodSettings.AimLock and Aiming.Check() and UserInputService:IsKeyDown(DaHoodSettings.AimLockKeybind)) then
 
        local SelectedPart = Aiming.SelectedPart
 
        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
 
        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
 
    end
end)

BulletColor = true

if BulletColor == true then
bullet_tracer_color = Color3.fromRGB(0, 0, 255)
function GetGun()
    if game.Players.LocalPlayer.Character then
        for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:FindFirstChild 'Ammo' then
                return v
            end
        end
    end
    return nil
end

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
}

local Local = {
    Player = Services.Players.LocalPlayer,
    Mouse = Services.Players.LocalPlayer:GetMouse(),
}
local Other = {
    Camera = workspace.CurrentCamera,
    BeamPart = Instance.new("Part", workspace)
}

Other.BeamPart.Name = "BeamPart"
Other.BeamPart.Transparency = 1
local Settings = {
    StartColor = MainAccentColor,
    EndColor = MainAccentColor,
    StartWidth = 4,
    EndWidth = 4,
    ShowImpactPoint = true,
    ImpactTransparency = 0.2,
    ImpactColor = Color3.new(1, 1, 1),
    Time = 0.435,
}
game:GetService "RunService".Heartbeat:Connect(function()
    if game:GetService("Workspace").Ignored:FindFirstChild 'BULLET_RAYS' and BulletColor then
        game:GetService("Workspace").Ignored.BULLET_RAYS:Destroy()
    end
end)
local funcs = {}
Local.Mouse.TargetFilter = Other.BeamPart
function funcs:Beam(v1, v2)
    v2 = Vector3.new(v2.X - 0.1, v2.Y + 0.2, v2.Z)
    local colorSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, bullet_tracer_color),
        ColorSequenceKeypoint.new(1, bullet_tracer_color),
    })
    local Part = Instance.new("Part", Other.BeamPart)
    Part.Size = Vector3.new(0, 0, 0)
    Part.Massless = true
    Part.Transparency = 1
    Part.CanCollide = false
    Part.Position = v1
    Part.Anchored = true
    local Attachment = Instance.new("Attachment", Part)
    local Part2 = Instance.new("Part", Other.BeamPart)
    Part2.Size = Vector3.new(0, 0, 0)
    Part2.Transparency = 0
    Part2.CanCollide = false
    Part2.Position = v2
    Part2.Anchored = true
    Part2.Material = Enum.Material.Plastic
    Part2.Color = Settings.ImpactColor
    Part2.Massless = true
    local Attachment2 = Instance.new("Attachment", Part2)
    local Beam = Instance.new("Beam", Part)
    Beam.FaceCamera = true
    Beam.Color = colorSequence
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.LightEmission = 6
    Beam.LightInfluence = 1
    Beam.Width0 = 0.05
    Beam.Width1 =  0.05
    Beam.Texture = "http://www.roblox.com/asset/?id=5210472215"
    Beam.TextureSpeed = 0
    Beam.TextureLength = 0
    delay(Settings.Time, function()
        Part:Destroy()
        Part2:Destroy()
    end)
end

spawn(function()
    while task.wait(0.5) do
        gun = GetGun()
        if gun then
            LastAmmo = gun.Ammo.Value
            gun.Ammo:GetPropertyChangedSignal("Value"):Connect(function()
                if BulletColor and gun.Ammo.Value < LastAmmo then
                    LastAmmo = gun.Ammo.Value
                    funcs:Beam(gun.Handle.Position, Local.Mouse.hit.p)
                end
            end)
        end
    end
end)

local a = "[Revolver]"
end

    Mouse.KeyDown:Connect(
        function(Key)
            if Key == getgenv().MacroKey then
                SpeedGlitch = not SpeedGlitch
                if SpeedGlitch == true then
                    repeat
                        game:GetService("RunService").Heartbeat:wait()
                        keypress(0x49)
                        game:GetService("RunService").Heartbeat:wait()
                        keypress(0x4F)
                        game:GetService("RunService").Heartbeat:wait()
                        keyrelease(0x49)
                        game:GetService("RunService").Heartbeat:wait()
                        keyrelease(0x4F)
                        game:GetService("RunService").Heartbeat:wait()
                    until SpeedGlitch == false
                end
            end
        end
    )
    
    local mouseyea = game.Players.LocalPlayer:GetMouse()
    mouseyea.KeyDown:Connect(
        function(ToggleKey)
            if ToggleKey ==  getgenv().FovKey then
                if Aiming.FOV == 30 then
                    Aiming.FOV = 8
                    small:Play()
                else
                    Aiming.FOV = 30
                    big:Play()
                end
            end
        end
    )   
    getgenv().OldAimPart = "Head"
getgenv().AimPart = "Head" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}  
    getgenv().AimRadius = 30 -- How far away from someones character you want to lock on at
    getgenv().ThirdPerson = true 
    getgenv().FirstPerson = true
    getgenv().TeamCheck = false -- Check if Target is on your Team (True means it wont lock onto your teamates, false is vice versa) (Set it to false if there are no teams)
    getgenv().PredictMovement = true -- Predicts if they are moving in fast velocity (like jumping) so the aimbot will go a bit faster to match their speed 
    getgenv().CheckIfJumped = true
    getgenv().Smoothness = true

    local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
    local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
    local Aimlock, MousePressed, CanNotify = true, false, false;
    local AimlockTarget;
    local OldPre;
    

    
    getgenv().WorldToViewportPoint = function(P)
        return Camera:WorldToViewportPoint(P)
    end
    
    getgenv().WorldToScreenPoint = function(P)
        return Camera.WorldToScreenPoint(Camera, P)
    end
    
    getgenv().GetObscuringObjects = function(T)
        if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 
            local RayPos = workspace:FindPartOnRay(RNew(
                T[getgenv().AimPart].Position, Client.Character.Head.Position)
            )
            if RayPos then return RayPos:IsDescendantOf(T) end
        end
    end
    
    getgenv().GetNearestTarget = function()
        -- Credits to whoever made this, i didnt make it, and my own mouse2plr function kinda sucks
        local players = {}
        local PLAYER_HOLD  = {}
        local DISTANCES = {}
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= Client then
                table.insert(players, v)
            end
        end
        for i, v in pairs(players) do
            if v.Character ~= nil then
                local AIM = v.Character:FindFirstChild("Head")
                if getgenv().TeamCheck == true and v.Team ~= Client.Team then
                    local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                    local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                    local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i] = {}
                    PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr = v
                    PLAYER_HOLD[v.Name .. i].diff = DIFF
                    table.insert(DISTANCES, DIFF)
                elseif getgenv().TeamCheck == false and v.Team == Client.Team then 
                    local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                    local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                    local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i] = {}
                    PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr = v
                    PLAYER_HOLD[v.Name .. i].diff = DIFF
                    table.insert(DISTANCES, DIFF)
                end
            end
        end
        
        if unpack(DISTANCES) == nil then
            return nil
        end
        
        local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
        if L_DISTANCE > getgenv().AimRadius then
            return nil
        end
        
        for i, v in pairs(PLAYER_HOLD) do
            if v.diff == L_DISTANCE then
                return v.plr
            end
        end
        return nil
    end
    
    Mouse.KeyDown:Connect(function(a)
        if not (Uis:GetFocusedTextBox()) then 
            if a == AimlockKey and AimlockTarget == nil then
                pcall(function()
                    if MousePressed ~= true then MousePressed = true end 
                    local Target;Target = GetNearestTarget()
                    if Target ~= nil then 
                        AimlockTarget = Target
                    end
                end)
            elseif a == AimlockKey and AimlockTarget ~= nil then
                if AimlockTarget ~= nil then AimlockTarget = nil end
                if MousePressed ~= false then 
                    MousePressed = false 
                end
            end
        end
    end)
    
    RService.RenderStepped:Connect(function()
        if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then 
            if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
                CanNotify = true 
            else 
                CanNotify = false 
            end
        elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 
            if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
                CanNotify = true 
            else 
                CanNotify = false 
            end
        elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then 
            if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
                CanNotify = true 
            else 
                CanNotify = false 
            end
        end
        if Aimlock == true and MousePressed == true then 
            if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 
                if getgenv().FirstPerson == true then
                    if CanNotify == true then
                        if getgenv().PredictMovement == true then
                            if getgenv().Smoothness == true then
                                --// The part we're going to lerp/smoothen \\--
                                local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                                
                                --// Making it work \\--
                                Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
                            else
                                Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                            end
                        elseif getgenv().PredictMovement == false then 
                            if getgenv().Smoothness == true then
                                --// The part we're going to lerp/smoothen \\--
                                local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)

                                --// Making it work \\--
                                Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
                            else
                                Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                            end
                        end
                    end
                end
            end
        end
         if CheckIfJumped == true then
       if AimlockTarget.Character.HuDDDDDDDDDDWmanoid.FloorMaterial == Enum.Material.Air then
    
           getgenv().AimPart = "UpperTorso"
       else
         getgenv().AimPart = getgenv().OldAimPart

       end
    end
end)
