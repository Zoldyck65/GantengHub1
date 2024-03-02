loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
 
repeat wait() until game:IsLoaded()
    local Camera = workspace.CurrentCamera
    local Workspace = game:GetService("Workspace")
    local ReplStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local COREGUI = game:GetService("CoreGui")
    local LP = game:GetService("Players").LocalPlayer
    local HumanoidRootPart = LP.Character.HumanoidRootPart
    local VirtualUser = game:GetService("VirtualUser")
    local VIM = game:GetService("VirtualInputManager")
 
    --Service
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local RunS = game:GetService("RunService")
    local TPS = game:GetService("TeleportService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local TeleportService = game:GetService("TeleportService")

  local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/download/1.1.0/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
 
 
 
    local Window = Fluent:CreateWindow({
        Title = "Ganteng Hub",
        SubTitle = "By Isnahamzah And Yanzz",
        TabWidth = 100,
        Size = UDim2.fromOffset(450, 350),
        Acrylic = false, 
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl 
    })
 
    local Tabs = {
        Stats           = Window:AddTab({ Title = "Stats", Icon = "nil" }),
        MainTab         = Window:AddTab({ Title = "AutoFarm", Icon = "nil" }),
        VehicleTab      = Window:AddTab({ Title = "Dealership", Icon = "nil" }),
        Environment     = Window:AddTab({ Title = "Misc", Icon = "nil" }),
        Settings        = Window:AddTab({ Title = "Settings", Icon = "nil" }),        
    }
 
    local Options = Fluent.Options
 
        local brightloop
 
        local function DayWeather()
            game:GetService("Lighting").ClockTime = 12
        end
 
        local function NightWeather()
            game:GetService("Lighting").ClockTime = 0
        end
 
        local function StartWeatherLoop(weatherFunction)
            if brightloop then
                brightloop:Disconnect() 
            end
            brightloop = game:GetService("RunService").RenderStepped:Connect(weatherFunction)
        end
 
        local weatherStatus = Tabs.Environment:AddDropdown("Dropdown", {
            Title = "Select Weather",
            Values = {"Day", "Night"},
            Multi = false,
            Default = "",
        })
        
        weatherStatus:OnChanged(function(Value)
            if Value == "Day" then
                StartWeatherLoop(DayWeather)
            elseif Value == "Night" then
                StartWeatherLoop(NightWeather)
            else
                if brightloop then
                    brightloop:Disconnect() 
                end
            end
        end)
 
        local ShadowToggle = Tabs.Environment:AddToggle("shaow", {Title = "Shadow Options", Default = false})
 
        ShadowToggle:OnChanged(function(Value)
            game:GetService("Lighting").GlobalShadows = Value
        end)
 
        function destroyListedObjects()
            local objectsToDestroy = {
                "AmbientLightRevamp",
                "ChristmasEvent",
                "Map.TrafficLight",
                "Map.Tree",
                "Map.17",
                "Map.Chirstmas",
                "Map.Ramadhan",
                "Map.RoadLight"
            }
        
            for _, objectName in ipairs(objectsToDestroy) do
                local object
                if objectName:find("%.") then
                    local parts = {}
                    for part in objectName:gmatch("[^%.]+") do
                        table.insert(parts, part)
                    end
        
                    object = workspace
                    for _, partName in ipairs(parts) do
                        object = object:FindFirstChild(partName)
                        if not object then break end
                    end
                else
                    object = workspace:FindFirstChild(objectName)
                end
        
                if object then
                    object:Destroy()
                else
                    warn(objectName .. " not found in workspace")
                end
            end
        end
        
        Tabs.Environment:AddButton({
            Title = "Boost FPS",
            Description = "the effect will continue until you relog",
            Callback = function()
                destroyListedObjects()
            end
        })
 
 
        -- [ FARM SECTION ]
        local FarmSection = Tabs.MainTab:AddSection("AutoFarm")
 
        local truck_cooldown_teleport = 50
        local cd = 0;
 
        local AmountCooldown = FarmSection:AddInput("Input", {
            Title = "Coolown Teleport",
            Default =  50,
            Placeholder = "Recommended  50",
            Numeric = true, -- Only allows numbers
            Finished = false, -- Only calls callback when you press enter
            Callback = function(Value)
                truck_cooldown_teleport = Value
            end
        })    
 
        getgenv().SelectedJob = nil;
        local JobDrop = FarmSection:AddDropdown("Dropdown", {
            Title = "Select Job",
            Values = {"Office Worker", "Janji Jiwa", "Truck Driver"},
            Multi = false,
            Default = getgenv().SelectedJob,
        })
        
        JobDrop:OnChanged(function(Value)
            getgenv().SelectedJob = Value
        end)
 
        local Toggle = FarmSection:AddToggle("StartFarm", {Title = "Auto Farm", Default = false })
 
        Toggle:OnChanged(function()
            if Options.StartFarm.Value == true then
                if getgenv().SelectedJob ~= nil then
                    if StopFarm == true then
                        StopFarm = false
                    end
                    DoFarm(getgenv().SelectedJob)
                else
                    Fluent:Notify({
                        Title = "Turu Hub",
                        Content = "Please Select a Job First",
                        Duration = 5 -- Set to nil to make the notification not disappear
                    })
                end
            else
                if string.find(tostring(getgenv().SelectedJob), "Driver") then
                    cd = 0;
                end 
                StopFarm = true
            end
 
        end)
        local StatsSection = Tabs.Stats:AddSection("Stats")
 
        local ClientCash = StatsSection:AddParagraph({
            Title = "Your Cash",
            Content = LP:FindFirstChild("PlayerGui").Main.Container.Hub.CashFrame.Frame.TextLabel.Text
        })
 
        local ClientEarnings =  StatsSection:AddParagraph({
            Title = "Earnings Cash",
            Content = LP:FindFirstChild("PlayerGui").PhoneUI.HolderHP.Homescreen.ProfileScreen.MainFrame.EarningFrame.Value.Text
        })
 
        local ClientTime =  StatsSection:AddParagraph({
            Title = "Farming Time",
            Content = "You're not start Auto Farming"
        })

        local CountdownTP =StatsSection:AddParagraph({
            Title = "Countdown Teleport",
            Content = "Teleport in "..tostring(cd)
        })
 
        -- [ SNIPER BOX ]
        local BoxSniper = Tabs.Environment:AddSection("Box")
 
        BoxSniper:AddButton({
            Title = "Daily Box",
            Description = "",
            Callback = function()
                local args = {
                    [1] = "Claim"
                }
                game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Box:FireServer(unpack(args))
            end
        })
 
        BoxSniper:AddButton({
            Title = "Gamepass Box",
            Description = "",
            Callback = function()
                local args = {
                    [1] = "Buy",
                    [2] = "Gamepass Box"
                }
                game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Box:FireServer(unpack(args))
            end
        })
 
        BoxSniper:AddButton({
            Title = "Limited Box",
            Description = "",
            Callback = function()
                local args = {
                    [1] = "Buy",
                    [2] = "Limited Box"
                }
                game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Box:FireServer(unpack(args))
            end
        })
 
        local dealershipParent = workspace.Etc:FindFirstChild("Dealership")
        local dealershipNames = {}
        local dealershipPrompts = {}
 
        if dealershipParent then
            for _, child in ipairs(dealershipParent:GetChildren()) do
                table.insert(dealershipNames, child.Name)
                dealershipPrompts[child.Name] = child.Prompt
            end
        end
 
        local DealershipJakarta = Tabs.VehicleTab:AddDropdown("Dropdown", {
            Title = "Dealership",
            Values = dealershipNames,
            Multi = false,
            Default = "",
        })
 
        DealershipJakarta:OnChanged(function(Value)
            local promptToFire = dealershipPrompts[Value]
            if promptToFire then
                fireproximityprompt(promptToFire)
            end
        end)
 
        function CashFormat(cash)
            local v70 = 1
            local v73 = string.len(cash)
            local v74 = v73 - 1
            local v77 = math.floor((v74) / 3)
            local v78 = v77
            local v79 = 1
            for v70 = v70, v78, v79 do
                v73 = string.sub
                v77 = v73(cash, 1, (-3) * v70 - v70)
                v74 = string.sub
                cash = v77 .. "," .. v74(cash, (-3) * v70 - v70 + 1)
            end
            v79 = "RP. "
            v78 = v79 .. cash
            return v78
        
        end
 
        function DoFarm(job)
            if job == "Truck Driver" then
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "U", false, game)
                wait(0.8)
                local args = { "Truck" }
                game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Job:FireServer(unpack(args))
                game.Workspace.Gravity = 10
                wait(2)
                game.Workspace.Gravity = 0
 
                local TweenService = game:GetService("TweenService")
                local HumanoidRootPart = LP.Character.HumanoidRootPart
                local targetCFrame = CFrame.new(-21799.8, 1042.65, -26797.7)
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
                local tweenProperties = {CFrame = targetCFrame}
                local tween = TweenService:Create(HumanoidRootPart, tweenInfo, tweenProperties)
                tween:Play()
                tween.Completed:Wait() 
 
                CheckStartJob() 
                wait(5)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)
                game.Workspace.Gravity = 10
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)
                wait(2)
                local destination = GetWaypointName()
                wait(1)
                game.Workspace.Gravity = 100
                wait(1)
                SpawnTruck()
                wait(4)
                GetInsideOfCar()
                wait(3)
                RemoveTrailerFromTruck()
                wait()
                wait(0.5)
                TruckFarm(StopFarm)
                GetTimer()
            elseif job == "Office Worker" then
                game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Job:FireServer("Office")
                game.Workspace.Gravity = 10
                wait(2)
                game.Workspace.Gravity = 0
                TakeEarlyPoint(game:GetService("Workspace").Etc.Job.Office.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Office.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Office.Starter.Prompt)
                game.Workspace.Gravity = 10
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Office.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Office.Starter.Prompt)
                wait(2)
                local destination = GetWaypointName()
                game.Workspace.Gravity = 100
                wait(1)
                repeat wait()
                    DoQuestOffice()
                until StopFarm == true
            elseif job == "Janji Jiwa" then
                local args = { "JanjiJiwa" }
                game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Job:FireServer(unpack(args))
                game.Workspace.Gravity = 10
                wait(2)
                game.Workspace.Gravity = 0
                TakeEarlyPoint(game:GetService("Workspace").Etc.Job.JanjiJiwa.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.JanjiJiwa.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.JanjiJiwa.Starter.Prompt)
                game.Workspace.Gravity = 10
                fireproximityprompt(game:GetService("Workspace").Etc.Job.JanjiJiwa.Starter.Prompt)
                fireproximityprompt(game:GetService("Workspace").Etc.Job.JanjiJiwa.Starter.Prompt)
                wait(2)
                local destination = GetWaypointName()
                game.Workspace.Gravity = 100
                DoJanjijiwaFarm()
            end
 
        end
    
 
        function GetTimer()
            local jobTime = tick()
            local startTime = os.date("%H:%M:%S")
            local startDate = os.date("%Y-%m-%d")
        
            while wait() do
                local elapsedTime = tick() - jobTime
                local timeText = ""
        
                if elapsedTime < 60 then
                    timeText = string.format("%.1f seconds", elapsedTime)
                elseif elapsedTime < 3600 then
                    timeText = string.format("%.1f minutes", elapsedTime / 60)
                else
                    timeText = string.format("%.1f hours", elapsedTime / 3600)
                end
        
                local currentTime = os.date("%H:%M:%S")
 
                ClientTime:SetDesc("You've been farming for: " .. timeText)
            end
        end
 
        local function GetDistance(Endpoint)
            if typeof(Endpoint) == "Instance" then
                Endpoint = Vector3.new(Endpoint.Position.X, LP.Character:FindFirstChild("HumanoidRootPart").Position.Y, Endpoint.Position.Z)
            elseif typeof(Endpoint) == "CFrame" then
                Endpoint = Vector3.new(Endpoint.Position.X, LP.Character:FindFirstChild("HumanoidRootPart").Position.Y, Endpoint.Position.Z)
            end
            local Magnitude = (Endpoint - LP.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
            return Magnitude
        end
 
        function TakeEarlyPoint(starterPrompts)
            local waypointPosition = game:GetService("Workspace").Etc.Waypoint.Waypoint.Position
            local humanoidRootPart = LP.Character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(waypointPosition)
            wait(1.5)
            for i = 1, 6 do
                fireproximityprompt(starterPrompts)
            end
        end
 
        function SpawnJobCar(waypointPos, promts)
            local waypointPosition = waypointPos
            local playerName = LP.Name
            local carIdentifier = "sCar"
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(waypointPosition)
 
            fireproximityprompt(promts)
            wait(1)
            fireproximityprompt(promts)
        end
 
        function SpawnTruck()
            local TweenService = game:GetService("TweenService")
            local HumanoidRootPart = LP.Character.HumanoidRootPart
            local waypointPosition = game.Workspace.Etc.Job.Truck.Spawner.Part.Position
        
            local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            
            local tweenProperties = {
                CFrame = CFrame.new(waypointPosition)
            }
        
            local tween = TweenService:Create(HumanoidRootPart, tweenInfo, tweenProperties)
            tween:Play()
            tween.Completed:Wait() 
        
            fireproximityprompt(game.Workspace.Etc.Job.Truck.Spawner.Part.Prompt)
            wait(1)
            fireproximityprompt(game.Workspace.Etc.Job.Truck.Spawner.Part.Prompt)
        end
 
        function GetInsideOfCar()
            local playerName = LP.Name
            local carIdentifier = "sCar"
            local DriveSeat = game:GetService("Workspace").Vehicles[playerName .. carIdentifier]:WaitForChild("DriveSeat", 9e9)
            local humanoidRootPart = LP.Character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(DriveSeat.Position)
            wait(1.5)
            local promptDriveSeat = DriveSeat.PromptDriveSeat
            fireproximityprompt(promptDriveSeat)
            wait(0.5)
            if LP.Character.Humanoid.SeatPart == nil or LP.Character.Humanoid.SeatPart.Name ~= "DriveSeat" then
                fireproximityprompt(promptDriveSeat)
                wait(0.5)
            end
        end
 
        function RemoveTrailerFromTruck()
            local playerName = LP.Name
            local carIdentifier = "sCar"
            local playerCar = game.Workspace.Vehicles[playerName .. carIdentifier]
            for _, descendant in pairs(playerCar:GetDescendants()) do
                if descendant.Name == "Trailer1" then
                    descendant:Destroy()
                end
            end
        end
 
        function safelyTeleportCar(playerCar, cframe)
            if not playerCar or not cframe then return end
            local playerPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local pingValue = tonumber(playerPing:match("%d+"))
        
            local waitTime = 0
            local delayMessage = ""
        
            if pingValue > 100 then
                waitTime = 8
                delayMessage = "Adding delay of 8 seconds."
            elseif pingValue > 80 then
                waitTime = 5
                delayMessage = "Adding delay of 5 seconds."
            elseif pingValue < 30 then
                waitTime = 3
                delayMessage = "Adding delay of 3 seconds."
            end
 
            CountdownTP:SetDesc(delayMessage)
        
            local success, errorMessage = pcall(function()
                wait(waitTime) 
                playerCar:SetPrimaryPartCFrame(cframe)
                game.Workspace.Gravity = -5
                CountdownTP:SetTitle("Teleported")
                CountdownTP:SetDesc("Teleported successfully!")
                wait(1)
                game.Workspace.Gravity = 500
            end)
            if not success then
                warn("Error teleporting car: " .. errorMessage)
            end
