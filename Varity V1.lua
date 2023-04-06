if getgenv().xeno then return getgenv().xeno end

-- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- // Vars
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Optimisation Vars (ugly)
local Drawingnew = Drawing.new
local Color3fromRGB = Color3.fromRGB
local Vector2new = Vector2.new
local GetGuiInset = GuiService.GetGuiInset
local Randomnew = Random.new
local mathfloor = math.floor
local CharacterAdded = LocalPlayer.CharacterAdded
local CharacterAddedWait = CharacterAdded.Wait
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local RaycastParamsnew = RaycastParams.new
local EnumRaycastFilterTypeBlacklist = Enum.RaycastFilterType.Blacklist
local Raycast = Workspace.Raycast
local GetPlayers = Players.GetPlayers
local Instancenew = Instance.new
local IsDescendantOf = Instancenew("Part").IsDescendantOf
local FindFirstChildWhichIsA = Instancenew("Part").FindFirstChildWhichIsA
local FindFirstChild = Instancenew("Part").FindFirstChild
local tableremove = table.remove
local tableinsert = table.insert

-- // Silent Aim Vars
getgenv().xeno = {
    Enabled = true,

    ShowFOV = false,
    FOV = 95,
    FOVColour = Color3fromRGB(0, 0, 0),

    VisibleCheck = true,
    
    HitChance = 130,

    Selected = nil,
    SelectedPart = nil,

    TargetPart = {"Head", "HumanoidRootPart"},

    Ignored = {
        Teams = {
            {
                Team = LocalPlayer.Team,
                TeamColor = LocalPlayer.TeamColor,
            },
        },
        Players = {
            LocalPlayer,
            91318356
        }
    }
}
local xeno = getgenv().xeno

-- // Create circle
local circle = Drawingnew("Circle")
circle.Transparency = 1
circle.Thickness = 2
circle.Color = xeno.FOVColour
circle.Filled = false
xeno.FOVCircle = circle

-- // Update
function xeno.UpdateFOV()
    -- // Make sure the circle exists
    if not (circle) then
        return
    end

    -- // Set Circle Properties
    circle.Visible = xeno.ShowFOV
    circle.Radius = (xeno.FOV * 3)
    circle.Position = Vector2new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
    circle.Color = xeno.FOVColour

    -- // Return circle
    return circle
end

-- // Custom Functions
local CalcChance = function(percentage)
    -- // Floor the percentage
    percentage = mathfloor(percentage)

    -- // Get the chance
    local chance = mathfloor(Randomnew().NextNumber(Randomnew(), 0, 1) * 100) / 100

    -- // Return
    return chance <= percentage / 100
end

-- // Customisable Checking Functions: Is a part visible
function xeno.IsPartVisible(Part, PartDescendant)
    -- // Vars
    local Character = LocalPlayer.Character or CharacterAddedWait(CharacterAdded)
    local Origin = CurrentCamera.CFrame.Position
    local _, OnScreen = WorldToViewportPoint(CurrentCamera, Part.Position)

    -- //
    if (OnScreen) then
        -- // Vars
        local raycastParams = RaycastParamsnew()
        raycastParams.FilterType = EnumRaycastFilterTypeBlacklist
        raycastParams.FilterDescendantsInstances = {Character, CurrentCamera}

        -- // Cast ray
        local Result = Raycast(Workspace, Origin, Part.Position - Origin, raycastParams)

        -- // Make sure we get a result
        if (Result) then
            -- // Vars
            local PartHit = Result.Instance
            local Visible = (not PartHit or IsDescendantOf(PartHit, PartDescendant))

            -- // Return
            return Visible
        end
    end

    -- // Return
    return false
end

-- // Ignore player
function xeno.IgnorePlayer(Player)
    -- // Vars
    local Ignored = xeno.Ignored
    local IgnoredPlayers = Ignored.Players

    -- // Find player in table
    for _, IgnoredPlayer in ipairs(IgnoredPlayers) do
        -- // Make sure player matches
        if (IgnoredPlayer == Player) then
            return false
        end
    end

    -- // Blacklist player
    tableinsert(IgnoredPlayers, Player)
    return true
end

-- // Unignore Player
function xeno.UnIgnorePlayer(Player)
    -- // Vars
    local Ignored = xeno.Ignored
    local IgnoredPlayers = Ignored.Players

    -- // Find player in table
    for i, IgnoredPlayer in ipairs(IgnoredPlayers) do
        -- // Make sure player matches
        if (IgnoredPlayer == Player) then
            -- // Remove from ignored
            tableremove(IgnoredPlayers, i)
            return true
        end
    end

    -- //
    return false
end

-- // Ignore team
function xeno.IgnoreTeam(Team, TeamColor)
    -- // Vars
    local Ignored = xeno.Ignored
    local IgnoredTeams = Ignored.Teams

    -- // Find team in table
    for _, IgnoredTeam in ipairs(IgnoredTeams) do
        -- // Make sure team matches
        if (IgnoredTeam.Team == Team and IgnoredTeam.TeamColor == TeamColor) then
            return false
        end
    end

    -- // Ignore team
    tableinsert(IgnoredTeams, {Team, TeamColor})
    return true
end

-- // Unignore team
function xeno.UnIgnoreTeam(Team, TeamColor)
    -- // Vars
    local Ignored = xeno.Ignored
    local IgnoredTeams = Ignored.Teams

    -- // Find team in table
    for i, IgnoredTeam in ipairs(IgnoredTeams) do
        -- // Make sure team matches
        if (IgnoredTeam.Team == Team and IgnoredTeam.TeamColor == TeamColor) then
            -- // Remove
            tableremove(IgnoredTeams, i)
            return true
        end
    end

    -- // Return
    return false
end

-- //  Toggle team check
function xeno.TeamCheck(Toggle)
    if (Toggle) then
        return xeno.IgnoreTeam(LocalPlayer.Team, LocalPlayer.TeamColor)
    end

    return xeno.UnIgnoreTeam(LocalPlayer.Team, LocalPlayer.TeamColor)
end

-- // Check teams
function xeno.IsIgnoredTeam(Player)
    -- // Vars
    local Ignored = xeno.Ignored
    local IgnoredTeams = Ignored.Teams

    -- // Check if team is ignored
    for _, IgnoredTeam in ipairs(IgnoredTeams) do
        -- // Make sure team matches
        if (Player.Team == IgnoredTeam.Team and Player.TeamColor == IgnoredTeam.TeamColor) then
            return true
        end
    end

    -- // Return
    return false
end

-- // Check if player (and team) is ignored
function xeno.IsIgnored(Player)
    -- // Vars
    local Ignored = xeno.Ignored
    local IgnoredPlayers = Ignored.Players

    -- // Loop
    for _, IgnoredPlayer in ipairs(IgnoredPlayers) do
        -- // Check if Player Id
        if (typeof(IgnoredPlayer) == "number" and Player.UserId == IgnoredPlayer) then
            return true
        end

        -- // Normal Player Instance
        if (IgnoredPlayer == Player) then
            return true
        end
    end

    -- // Team check
    return xeno.IsIgnoredTeam(Player)
end

-- // Get the Direction, Normal and Material
function xeno.Raycast(Origin, Destination, UnitMultiplier)
    if (typeof(Origin) == "Vector3" and typeof(Destination) == "Vector3") then
        -- // Handling
        if (not UnitMultiplier) then UnitMultiplier = 1 end

        -- // Vars
        local Direction = (Destination - Origin).Unit * UnitMultiplier
        local Result = Raycast(Workspace, Origin, Direction)

        -- // Make sure we have a result
        if (Result) then
            local Normal = Result.Normal
            local Material = Result.Material

            return Direction, Normal, Material
        end
    end

    -- // Return
    return nil
end

-- // Get Character
function xeno.Character(Player)
    return Player.Character
end

-- // Check Health
function xeno.CheckHealth(Player)
    -- // Get Humanoid
    local Character = xeno.Character(Player)
    local Humanoid = FindFirstChildWhichIsA(Character, "Humanoid")

    -- // Get Health
    local Health = (Humanoid and Humanoid.Health or 0)

    -- //
    return Health > 0
end

-- // Check if silent aim can used
function xeno.Check()
    return (xeno.Enabled == true and xeno.Selected ~= LocalPlayer and xeno.SelectedPart ~= nil)
end
xeno.checkSilentAim = xeno.Check

-- // Get Closest Target Part
function xeno.GetClosestTargetPartToCursor(Character)
    local TargetParts = xeno.TargetPart

    -- // Vars
    local ClosestPart = nil
    local ClosestPartPosition = nil
    local ClosestPartOnScreen = false
    local ClosestPartMagnitudeFromMouse = nil
    local ShortestDistance = 1/0

    -- //
    local function CheckTargetPart(TargetPart)
        -- // Convert string -> Instance
        if (typeof(TargetPart) == "string") then
            TargetPart = FindFirstChild(Character, TargetPart)
        end

        -- // Make sure we have a target
        if not (TargetPart) then
            return
        end

        -- // Get the length between Mouse and Target Part (on screen)
        local PartPos, onScreen = WorldToViewportPoint(CurrentCamera, TargetPart.Position)
        local GuiInset = GetGuiInset(GuiService)
        local Magnitude = (Vector2new(PartPos.X, PartPos.Y - GuiInset.Y) - Vector2new(Mouse.X, Mouse.Y)).Magnitude

        -- //
        if (Magnitude < ShortestDistance) then
            ClosestPart = TargetPart
            ClosestPartPosition = PartPos
            ClosestPartOnScreen = onScreen
            ClosestPartMagnitudeFromMouse = Magnitude
            ShortestDistance = Magnitude
        end
    end

    -- // String check
    if (typeof(TargetParts) == "string") then
        -- // Check if it all
        if (TargetParts == "All") then
            -- // Loop through character children
            for _, v in ipairs(Character:GetChildren()) do
                -- // See if it a part
                if not (v:IsA("BasePart")) then
                    continue
                end

                -- // Check it
                CheckTargetPart(v)
            end
        else
            -- // Individual
            CheckTargetPart(TargetParts)
        end
    end

    -- //
    if (typeof(TargetParts) == "table") then
        -- // Loop through all target parts and check them
        for _, TargetPartName in ipairs(TargetParts) do
            CheckTargetPart(TargetPartName)
        end
    end

    -- //
    return ClosestPart, ClosestPartPosition, ClosestPartOnScreen, ClosestPartMagnitudeFromMouse
end

-- // Silent Aim Function
function xeno.GetClosestPlayerToCursor()
    -- // Vars
    local TargetPart = nil
    local ClosestPlayer = nil
    local Chance = CalcChance(xeno.HitChance)
    local ShortestDistance = 1/0

    -- // Chance
    if (not Chance) then
        xeno.Selected = LocalPlayer
        xeno.SelectedPart = nil

        return LocalPlayer
    end

    -- // Loop through all players
    for _, Player in ipairs(GetPlayers(Players)) do
        -- // Get Character
        local Character = xeno.Character(Player)

        -- // Make sure isn't ignored and Character exists
        if (xeno.IsIgnored(Player) == false and Character) then
            -- // Vars
            local TargetPartTemp, _, _, Magnitude = xeno.GetClosestTargetPartToCursor(Character)

            -- // Check if part exists and health
            if (TargetPartTemp and xeno.CheckHealth(Player)) then
                -- // Check if is in FOV
                if (circle.Radius > Magnitude and Magnitude < ShortestDistance) then
                    -- // Check if Visible
                    if (xeno.VisibleCheck and not xeno.IsPartVisible(TargetPartTemp, Character)) then continue end

                    -- // Set vars
                    ClosestPlayer = Player
                    ShortestDistance = Magnitude
                    TargetPart = TargetPartTemp
                end
            end
        end
    end

    -- // End
    xeno.Selected = ClosestPlayer
    xeno.SelectedPart = TargetPart
end

-- // Heartbeat Function
Heartbeat:Connect(function()
    xeno.UpdateFOV()
    xeno.GetClosestPlayerToCursor()
end)

-- //
return xeno
