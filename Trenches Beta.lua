local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local CurrentTarget = nil

local Connections = {
	CharacterAdded = {}
}

getgenv().cham = false
getgenv().nameESP = false
getgenv().boxESP = false
getgenv().esp_loaded = false
getgenv().Visibility = false

table.insert(Connections.CharacterAdded, LocalPlayer.CharacterAdded:Connect(function(Char)
	Character = Char
	Humanoid = Char:WaitForChild("Humanoid")
	HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")
end))

local Aimbot = {}; do
	local Loops = {RenderStepped = {}, Heartbeat = {}, Stepped = {}}
	function Aimbot:BindToRenderStepped(id, callback)
		if not Loops.RenderStepped[id] then
			Loops.RenderStepped[id] = RunService.RenderStepped:Connect(callback)
		end
	end
	function Aimbot:UnbindFromRenderStepped(id)
		if Loops.RenderStepped[id] then
			Loops.RenderStepped[id]:Disconnect()
			Loops.RenderStepped[id] = nil
		end
	end
	function Aimbot:StoreCurrentTarget(Player)
		CurrentTarget = Player
	end
	function Aimbot:IfHolding()
		return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	end
    function Aimbot:DistanceCheck(Player, Distance)
        shared.DistanceCheck = shared.DistanceCheck or true
        shared.Distance = shared.Distance or 100

        if Distance and shared.DistanceCheck then
            return (Player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= Distance
        else
            return false
        end
    end

    function Aimbot:TeamCheck(Player, Toggle)
		if Toggle then
			for i,v in pairs(game.Players:GetPlayers()) do
                if v.Team ~= game.Players.LocalPlayer.Team then
                    return false
                else
                    return true
                end
            
            end
        end
	end

	function Aimbot:GetClosestPlayerToMouse()
		local ClosestPlayer = nil
		local ClosestPlayerDistance = math.huge

		for _, Player in next, Players:GetPlayers() do
			if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
				local ScreenPoint = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
				local MousePoint = Vector2.new(Mouse.X, Mouse.Y)
				local Distance = (MousePoint - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                local _, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)

				if Aimbot:DistanceCheck(Player, shared.Distance) and OnScreen and Distance < ClosestPlayerDistance then
					ClosestPlayer = Player
					ClosestPlayerDistance = Distance
				end
			end
		end

		return ClosestPlayer
	end
    function Aimbot:GetClosestFromDistance()
        local ClosestPlayer = nil
        local ClosestPlayerDistance = math.huge

        for _, Player in next, Players:GetPlayers() do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local Distance = (Player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude

                if Aimbot:DistanceCheck(Player, shared.Distance) and Distance < ClosestPlayerDistance then
                    ClosestPlayer = Player
                    ClosestPlayerDistance = Distance
                end
            end
        end

        return ClosestPlayer
    end
    function Aimbot:DoMethod()
        shared.Method = shared.Method or "Closest To Mouse"

        if shared.Method == "Closest To Mouse" then
            return self:GetClosestPlayerToMouse()
        elseif shared.Method == "Distance" then
            return self:GetClosestFromDistance()
        end
    end
	Aimbot:StoreCurrentTarget(Aimbot:DoMethod())
	function Aimbot:Update()
		getgenv().Smoothness = shared.Smoothness or .25
		getgenv().TeamCheck = shared.TeamCheck or false
        getgenv().SelectedView = shared.SelectedView or "First Person"
        getgenv().TargetPart = shared.TargetPart or "Head"

		if CurrentTarget and CurrentTarget.Character then
			local Vector = Camera:WorldToViewportPoint(CurrentTarget.Character:WaitForChild(TargetPart).Position)

			if not self:IfHolding() then
				self:StoreCurrentTarget(self:DoMethod())
			elseif self:IfHolding() and self:TeamCheck(CurrentTarget, TeamCheck) then
				if SelectedView == "First Person" and UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
					Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, CurrentTarget.Character:WaitForChild(TargetPart).Position), Smoothness)
				elseif SelectedView == "Third Person" and UIS.MouseBehavior == Enum.MouseBehavior.Default then
					mousemoverel((Vector.X - Mouse.X) / 2 * Smoothness, (Vector.Y - Mouse.Y - 35) / 2 * Smoothness)
                elseif SelectedView == "Auto" then
                    if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
                        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, CurrentTarget.Character:WaitForChild(TargetPart).Position), Smoothness)
                    elseif UIS.MouseBehavior == Enum.MouseBehavior.Default then
                        mousemoverel((Vector.X - Mouse.X) / 2 * Smoothness, (Vector.Y - Mouse.Y - 35) / 2 * Smoothness)
                    end
				end
			end
		else
			self:StoreCurrentTarget(self:DoMethod())
		end
	end
	function Aimbot:Toggle(boolean)
		if boolean then
			self:BindToRenderStepped("Aimbot", function()
				self:Update()
			end)
		else
			self:UnbindFromRenderStepped("Aimbot")
		end
	end
end


local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
	Name = "Trenches:Beta (By Nice Cheats REBORN)",
	LoadingTitle = "Trenches:Beta (By Nice Cheats REBORN)",
	LoadingSubtitle = "By Linix#0132",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Trenches:Beta Nice Cheats",
		FileName = "NiceCheats"
	},
})

local Main = Window:CreateTab('Main')
Main:CreateSection("Aimbot")

Main:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(AimAssistToggle)
        Aimbot:Toggle(AimAssistToggle)
    end,
})

Main:CreateSection("Aimbot Settings")

Main:CreateDropdown({
    Name = "Method",
    Options = {"Closest To Mouse", "Distance"},
    CurrentOption = "Closest To Mouse",
    Callback = function(Method)
        shared.Method = Method
    end,
})

Main:CreateDropdown({
    Name = "Target Part",
    Options = {
        "Head",
        "Torso",
        "Right Arm",
        "Left Arm",
        "Right Leg",
        "Left Leg"
    },
    CurrentOption = "Head",
    Callback = function(TargetPart)
        if TargetPart == "Torso" then
            shared.TargetPart = "HumanoidRootPart"
        elseif TargetPart ~= "Torso" then
            shared.TargetPart = TargetPart
        end
    end,
})

Main:CreateDropdown({
    Name = "Selected View",
    Options = {"First Person", "Third Person", "Auto"},
    CurrentOption = "First Person",
    Callback = function(SelectedView)
        shared.SelectedView = SelectedView
    end,
})

Main:CreateSlider({
    Name = "Smoothness",
    Range = {0, 1},
    Increment = .01,
    CurrentValue = .25,
    Callback = function(Smoothness)
        shared.Smoothness = Smoothness
    end,
})

Main:CreateToggle({
    Name = "Distance Check",
    CurrentValue = true,
    Callback = function(DistanceCheckToggle)
        shared.DistanceCheck = DistanceCheckToggle
    end,
})

Main:CreateSlider({
    Name = "Distance",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 100,
    Callback = function(Distance)
        shared.Distance = Distance
    end,
})

Main:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(TeamCheckToggle)
        shared.TeamCheck = TeamCheckToggle
    end,
})

Main:CreateSection("Esp")

Main:CreateToggle({
    Name = "ON/OFF",
    CurrentValue = getgenv().Visibility,
    Callback = function(Value)
        if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
        getgenv().Visibility = Value
    end,
})

Main:CreateSection("Esp Settings")

Main:CreateToggle({
    Name = "Box",
    CurrentValue = getgenv().Visibility,
    Callback = function(Value)
        if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
        getgenv().boxESP = Value
    end,
})

Main:CreateToggle({
    Name = "Names",
    CurrentValue = getgenv().Visibility,
    Callback = function(Value)
        if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
        getgenv().nameESP = Value
    end,
})

Main:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().useTeamColor = Value
    end,
})

Main:CreateToggle({
    Name = "Chams",
    CurrentValue = getgenv().Visibility,
    Callback = function(Value)
        if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
        getgenv().cham = Value
    end,
})
