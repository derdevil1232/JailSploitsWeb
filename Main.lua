

--> [[ Load Game ]] <--

while not game:IsLoaded() do
    task.wait()
end


--> [[ Load Services ]] <--

local Services                     = {
	Workspace                      = game:GetService("Workspace"),
	Players                        = game:GetService("Players"),
    HttpService                    = game:GetService("HttpService"),
	ReplicatedStorage              = game:GetService("ReplicatedStorage"),
	RunService                     = game:GetService("RunService"),
	UserInputService               = game:GetService("UserInputService")
}

local Workspace                    = Services.Workspace
local Players                      = Services.Players
local HttpService                  = Services.HttpService
local ReplicatedStorage            = Services.ReplicatedStorage
local RunService                   = Services.RunService
local UserInputService             = Services.UserInputService

--> [[ Load Modules ]] <--

local Modules                      = {
    VehicleUtils                   = require(ReplicatedStorage.Vehicle.VehicleUtils),
    TagUtils                       = require(ReplicatedStorage.Tag.TagUtils),
    GunShopUI                      = require(ReplicatedStorage.Game.GunShop.GunShopUI),
    RayCast                        = require(ReplicatedStorage.Module.RayCast),
    Gun                            = require(ReplicatedStorage.Game.Item.Gun),
    Maid                           = require(ReplicatedStorage.Std.Maid)
}

local GetVehicleModel              = Modules.VehicleUtils.GetLocalVehicleModel
local GetVehiclePacket             = Modules.VehicleUtils.GetLocalVehiclePacket

--> [[ Load Misc ]] <--

local Wait                         = task.wait
local Spawn                        = task.spawn
local Tostring                     = tostring
local CFrameNew                    = CFrame.new

--> [[ Load Settings ]] <--

local Settings                     = {

	Antitaze                       = true,
    Antiarrest                     = true,
	NoRagDoll                      = true,
	NoFallDamage                   = true,
	NoParachute                    = true,
	Aimbot                         = true,
    Poptires                       = true,
	WalkSpeedInt                   = 16,
	JumpPowerInt                   = 50,
	GravityInt                     = 196.2,
	VehicleSpeedInt                = 100,
	VehicleTurnInt                 = 1.4,
	VehicleHeightInt               = 60,
	AimbotDistanceInt              = 100
}

--> [[ Load Player ]] <--

local Player                       = Players.LocalPlayer
local Character                    = nil
local Humanoid                     = nil
local Root                         = nil
local PlayerGui                    = Player:WaitForChild("PlayerGui")

local function GetPlayer(character)
	Character = character
	Humanoid = Character:WaitForChild("Humanoid")
	Root = Character:WaitForChild("HumanoidRootPart")

	Humanoid.Died:Connect(function()
		Character, Root, Humanoid = nil, nil, nil
	end)
end

if Player.Character then
	GetPlayer(Player.Character)
end

Player.CharacterAdded:Connect(GetPlayer)

--> [[ Load Enviornment ]] <--

local HasKeyFunction               = {}
local PunchFunction                = {}
local CrawlFunction                = {}
local CrawlTickTable               = {}
local WalkSpeedFunction            = {}
local StunnedFunction              = {}
local RollTimeFunction             = {}

LPH_NO_VIRTUALIZE(function()
    for _, v in getgc(true) do
        if typeof(v) == "function" then
            if getfenv(v).script == ReplicatedStorage.Game.PlayerUtils then
                if debug.info(v, "n") == "hasKey" then
                    HasKeyFunction = v
                end
            end
    
            if getfenv(v).script == Player.PlayerScripts.LocalScript then
                if debug.info(v, "n") == "CheatCheck" then
                    hookfunction(v, function() end)
                elseif debug.info(v, "n") == "attemptPunch" then
                    PunchFunction = v
                elseif debug.info(v, "n") == "attemptToggleCrawling" then   
                    CrawlFunction = v            
                    CrawlTickTable = getupvalue(v, 9)
                elseif debug.info(v, "n") == "WalkSpeedFun" then
                    WalkSpeedFunction = v
                elseif table.find(debug.getconstants(v), "Stunned") then
                    StunnedFunction = v
                end
            end
    
            if getfenv(v).script == ReplicatedStorage.MovementRoll.MovementRollService then 
                if table.find(debug.getconstants(v), "mapLastRollTime") then
                    RollTimeFunction = v
                end
            end
        end
    end
end)()

--> [[ Load Main Functions ]] <--

local TeleportingToLocation        = false

local TeleportsInfo                = {
    ["Mansion"]                    = CFrameNew(3147, -202, -4516)
}

local GetClosestVehicle = LPH_JIT_MAX(function() 
    local ClosestVehicle = nil
    local ClosestVehicleDistance = math.huge

    for _, v in Workspace.Vehicles:GetChildren() do
        if v:IsA("Model") and v ~= GetVehicleModel() then
            local Distance = (Root.Position - v.PrimaryPart.Position).Magnitude
            if Distance < ClosestVehicleDistance then
                ClosestVehicle = v
                ClosestVehicleDistance = Distance
            end
        end
    end

    return ClosestVehicle
end)

local Teleport = LPH_JIT_MAX(function(location)
    pcall(function()
        local TeleportInfoLocation = TeleportsInfo[location]

        if not TeleportInfoLocation then 
            return 
        end
    
        if TeleportingToLocation then
            return
        end
    
        local TeleportTick = tick();
    
        repeat
            Character:PivotTo(TeleportInfoLocation)
            Wait()
        until tick() - TeleportTick >= 7.5
    end)
end)


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

do
    local Window                   = Library:CreateWindow({
        Title                      = "Jailbreak HypeSpeed V1",
		SubTitle                   = "",
		TabWidth                   = 200,
		Size                       = UDim2.fromOffset(580, 460),
		Acrylic                    = false, 
		Theme                      = "Dark",
		MinimizeKey                = Enum.KeyCode.RightControl 
    })            



    local Window = Rayfield:CreateWindow({
        Name = "HypeSpeed V1 - discord.gg/ehpR5vZr42",
        Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "HypeSpeed V1",
        LoadingSubtitle = "by C3NIOR",
        Theme = "AmberGlow", -- Check https://docs.sirius.menu/rayfield/configuration/themes
     
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
     
        ConfigurationSaving = {
           Enabled = true,
           FolderName = nil, -- Create a custom folder for your hub/game
           FileName = "HypeSpeed"
        },
     
        Discord = {
           Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
           Invite = "ehpR5vZr42", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
           RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
     
        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
           Title = "No Key System",
           Subtitle = "Key System",
           Note = "No Key system!", -- Use this to tell the user how to get a key
           FileName = "ehpR5vZr42", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
           SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
           GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
           Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
     })





    
     local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Toggle = Main:CreateToggle({
    Name = "Enabled",
    CurrentValue = true,
    Flag = "8snb40cmsicy", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function( for _, v in Workspace.MansionRobbery:GetDescendants() do
        if v.Name == "LaserTraps" and v:IsA("Model") then
            for _, v2 in v:GetDescendants() do
                if v2:FindFirstChild("TouchInterest") then
                    v2:Destroy()
                end
            end
        end
        if v.Name == "Lasers" and v:IsA("Model") then 
            for _, v2 in v:GetDescendants() do
                if v2:FindFirstChild("TouchInterest") then
                    v2:Destroy()
                end
            end
        end
    end)
    -- The function that takes place when the toggle is pressed
    -- The variable (Value) is a boolean on whether the toggle is true or false
    end,
 })




end


local FakeSniper = {
    Local = true,
    IgnoreList = {},
    Config = {},
    Maid = Modules.Maid.new(),
    __ClassName = "Sniper",
}

Modules.Gun.SetupBulletEmitter(FakeSniper)

local OldHasKeyFunction             = {}
local OldStunnedFunction            = {}
local OldCrawlFunction              = {}
local OldPointTagFunction           = {}
local OldRayIgnoreTable             = Modules.RayCast.RayIgnoreNonCollideWithIgnoreList
local ProgressButton                = PlayerGui:WaitForChild("AppUI"):WaitForChild("Controls"):WaitForChild("outer_5"):WaitForChild("Button")
local ProgressTracker               = ProgressButton:FindFirstChild("Progress")


OldStunnedFunction = hookfunction(StunnedFunction, LPH_NO_VIRTUALIZE(function(...) 
	if Settings.Antitaze then
		return
	end

	return OldStunnedFunction(...)
end))


OldPointTagFunction = hookfunction(Modules.TagUtils.isPointInTag, LPH_NO_VIRTUALIZE(function(pos, tag)
	if tag == "NoRagdoll" and Settings.NoRagDoll then
		return true
	elseif tag == "NoFallDamage" and Settings.NoFallDamage then
		return true
	elseif tag == "NoParachute" and Settings.NoParachute then
		return true
	end 

	return OldPointTagFunction(pos, tag)
end))

Modules.RayCast.RayIgnoreNonCollideWithIgnoreList = LPH_NO_VIRTUALIZE(function(...)
	if Settings.Aimbot then
		local NearestEnemy = nil
		local NearestDistance = tonumber(Settings.AimbotDistanceInt)
	
		local TargetFromTeam = {
			["Prisoner"] = "Police",
			["Criminal"] = "Police",
			["Police"] = "Criminal"
		}
	
		for _, v in Players:GetPlayers() do
			if v.Team.Name == TargetFromTeam[Player.Team.Name] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
				if (v.Character.HumanoidRootPart.Position - Root.Position).Magnitude < NearestDistance then
					NearestDistance, NearestEnemy = (v.Character.HumanoidRootPart.Position - Root.Position).Magnitude, v
				end
			end
		end

		local Arg = {OldRayIgnoreTable(...)}
	
		if (Tostring(getfenv(2).script) == "BulletEmitter" or Tostring(getfenv(2).script) == "Taser") and NearestEnemy then
			Arg[1] = NearestEnemy.Character.HumanoidRootPart
			Arg[2] = NearestEnemy.Character.HumanoidRootPart.Position
			Arg[3] = NearestEnemy.Character.HumanoidRootPart.Position
		end
	
		return unpack(Arg)
	end

	return OldRayIgnoreTable(...)
end)

Spawn(function()
	LPH_JIT_MAX(function()
        while Wait(0.1) do
            pcall(function()
                local VehicleModel = GetVehiclePacket()
        
        
                if Settings.Antiarrest and Humanoid.Sit == false then
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    Humanoid.Sit = true
                end

                if Settings.Poptires then
                    local ClosestVehicle = GetClosestVehicle()
    
                    if ClosestVehicle then
                        FakeSniper.BulletEmitter.OnHitSurface:Fire(ClosestVehicle.PrimaryPart, ClosestVehicle.PrimaryPart.Position, ClosestVehicle.PrimaryPart.Position)
                    end
                end
            end)
        end
    end)()
end)

