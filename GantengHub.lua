-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
 
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
        Theme = "Light",
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
 
    do
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
            Title = "Cooldown Teleport",
            Default =  45,
            Placeholder = "Recommended  45",
            Numeric = true, -- Only allows numbers
            Finished = false, -- Only calls callback when you press enter
            Callback = function(Value)
                truck_cooldown_teleport = Value
            end
        })    
 
        local CountdownTP =FarmSection:AddParagraph({
            Title = "Countdown Teleport",
            Content = "Teleport in "..tostring(cd)
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
        end
 
        function TruckFarm(value)
            task.spawn(function()
                while wait() do
                    if StopFarm then return end
        
                    local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
                    if not humanoid or humanoid.SeatPart == nil or humanoid.SeatPart.Name ~= "DriveSeat" then
                        return
                    end
        
                    StartCountdown()
        
                    local waypointGui = game.Workspace.Etc.Waypoint.Waypoint:FindFirstChild("BillboardGui")
                    local Waypoint = waypointGui and waypointGui.TextLabel.Text
                    local playerName = LP.Name
                    local carIdentifier = "sCar"
                    local playerCar = game:GetService("Workspace").Vehicles:FindFirstChild(playerName .. carIdentifier)
        
                    if Waypoint == "PT.CDID Cargo Cirebon" then 
                        safelyTeleportCar(playerCar, CFrame.new(-21803.8867, 1046.98877, -27817.0586, 0, 0, -1, 0, 1, 0, 1, 0, 0), 12)
                    elseif Waypoint == "Rojod Semarang" then 
                        safelyTeleportCar(playerCar, CFrame.new(-50889.6602, 1017.86719, -86514.7969), 12)
                    else
                        local waypointPosition = game:GetService("Workspace").Etc.Waypoint.Waypoint.Position
                        safelyTeleportCar(playerCar, CFrame.new(waypointPosition), 7)
                    end
        
                    wait(2.2) 
                end
            end)
        end
 
        function DoJanjijiwaFarm()
            task.spawn(function()
                while wait() and not StopFarm do
                    pcall(function()
                        repeat
                            TakeEarlyPoint(game:GetService("Workspace").Etc.Job.JanjiJiwa.Starter.Prompt)
                            if LP.Backpack:FindFirstChild("Coffee") then
                                game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("JanjiJiwa"):FireServer("Delivery")
                            end
                        until StopFarm == true
                    end)
                end
 
            end)
        end
 
        function DoQuestOffice()
            for i = 0, 4 do
                if StopFarm then break end
                local quest = LP.PlayerGui.Job.Components.Container.Office.Frame.Question.Text
                local Submit = LP.PlayerGui.Job.Components.Container.Office.Frame.SubmitButton
                local splitQuest = string.split(quest, " ")
                local num1 = tonumber(splitQuest[1])
                local operator = splitQuest[2]
                local num2 = tonumber(splitQuest[3])
                local solved;
                if operator == "+" then
                    solved = tostring((num1 + num2))
                elseif operator == "-" then
                    solved = tostring(num1 - num2)
                end
                
                LP.PlayerGui.Job.Components.Container.Office.Frame.TextBox.Text = string.match(solved, "%d+")
                repeat wait(0.5) until LP.PlayerGui.Job.Components.Container.Office.Frame.TextBox.Text == string.match(solved, "%d+")
                if (LP.PlayerGui.Job.Components.Container.Office.Frame.TextBox.Text == string.match(solved, "%d+")) then
                    VIM:SendMouseButtonEvent(Submit.AbsolutePosition.X+Submit.AbsoluteSize.X/2,Submit.AbsolutePosition.Y+50,0,true,Submit,1)
                    VIM:SendMouseButtonEvent(Submit.AbsolutePosition.X+Submit.AbsoluteSize.X/2,Submit.AbsolutePosition.Y+50,0,false,Submit,1)   
                end
            end
        end
 
 
        function StartCountdown()
            for i = truck_cooldown_teleport, 1, -1 do
                if StopFarm then break end;
                cd = i
                CountdownTP:SetTitle("Countdown Teleport")
                CountdownTP:SetDesc("Teleport in "..tostring(cd))
                wait(1)
            end
            
        end
 
        function CheckStartJob()
            local jobStarted = false
            while not jobStarted do
                wait()
                local waypoint = assert(game.Workspace.Etc.Waypoint.Waypoint, "Waypoint not found!")
                local waypointLabel = assert(waypoint.BillboardGui and waypoint.BillboardGui.TextLabel, "Waypoint label not found!")
                local labelText = waypointLabel.Text
                if labelText == "PT.Shad Cirebon" then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(-21799.8, 1042.65, -26797.7)
                    local prompt = assert(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt, "Prompt not found!")
                    for i = 1, 4 do
                        fireproximityprompt(prompt)
                    end
                    game.Workspace.Gravity = 10
                else
                    jobStarted = true
                end
            end
        end
 
 
        function GetWaypointName()
            local waypoint = assert(game.Workspace.Etc.Waypoint.Waypoint, "Waypoint not found!")
            local waypointLabel = assert(waypoint:FindFirstChild("BillboardGui") and waypoint.BillboardGui:FindFirstChild("TextLabel"), "Waypoint label not found!")
            return waypointLabel.Text
        end
 
        function RefreshCash()
            ClientCash:SetDesc(LP:FindFirstChild("PlayerGui").Main.Container.Hub.CashFrame.Frame.TextLabel.Text)
            ClientEarnings:SetDesc(LP:FindFirstChild("PlayerGui").PhoneUI.HolderHP.Homescreen.ProfileScreen.MainFrame.EarningFrame.Value.Text)
        end
 
        LP:FindFirstChild("PlayerGui").Main.Container.Hub.CashFrame.Frame.TextLabel:GetPropertyChangedSignal("Text"):Connect(RefreshCash)
        LP:FindFirstChild("PlayerGui").PhoneUI.HolderHP.Homescreen.ProfileScreen.MainFrame.EarningFrame.Value:GetPropertyChangedSignal("Text"):Connect(RefreshCash)
 
    end
 
    function TimeTrialJakarta()
        fireproximityprompt(workspace.Etc.Race.TimeTrial.Start.Prompt)
 
        local startTime = tick()
        repeat RunS.Heartbeat:Wait() until tick() - startTime >= 10
 
        local playerName = LP.Name
        local playerCar = game:GetService("Workspace").Vehicles[playerName .. "sCar"]
 
        if not playerCar then
            print("Kendaraan player tidak ditemukan!")
            return
        end
 
        repeat RunS.Heartbeat:Wait() until tick() - startTime >= 15
        
        local checkpointCFrames = {
            CFrame.new(-4922.92578, 41.3567047, 363.310974, 2.05039978e-05, -0.86604017, -0.499974549, 1.00000012, 2.05039978e-05, 5.49852848e-06, 5.49852848e-06, -0.499974549, 0.866040111),
            CFrame.new(-3684.76489, 42.3644257, -526.991089, 2.07424164e-05, -0.57355696, -0.819165647, 0.99999994, 2.07424164e-05, 1.07884407e-05, 1.07884407e-05, -0.819165647, 0.573557019),
            CFrame.new(-2025.33301, 46.4877014, -556.023926, -8.22544098e-06, 0.642762423, -0.766065776, 1.00000012, 7.9870224e-06, -3.75509262e-06, 3.75509262e-06, -0.766065776, -0.642762542),
            CFrame.new(-1175.63403, 66.2507553, -29.6842384, -5.96046448e-07, 0.0871878564, -0.996191859, 1, 5.96046448e-07, -5.66244125e-07, 5.66244125e-07, -0.996191859, -0.087187767),
            CFrame.new(-799.506531, 47.0191269, 1184.70581, -8.10623169e-06, -0.642762303, -0.766065598, 1, -8.10623169e-06, -3.78489494e-06, -3.78489494e-06, -0.766065598, 0.642762303),
            CFrame.new(-1528.93933, 44.2638969, 2426.12964, 6.10947609e-05, -0.857243359, -0.514911354, 0.99999994, 6.10947609e-05, 1.69277191e-05, 1.69277191e-05, -0.514911354, 0.857243419),
            CFrame.new(-3078.01807, 44.0052948, 5127.05176, 3.12328339e-05, -0.941413283, -0.33725512, 1, 3.12328339e-05, 5.42402267e-06, 5.42402267e-06, -0.33725512, 0.941413283),
            CFrame.new(-3217.22119, 46.7632523, 5518.37402, -2.31266022e-05, 0.620019555, 0.78458631, 1, 2.31266022e-05, 1.12056732e-05, -1.12056732e-05, 0.78458631, -0.620019674),
            CFrame.new(-3430.00879, 45.0853043, 5427.7749, -4.78029251e-05, 0.710414648, -0.703783453, 1.00000012, 4.76837158e-05, -1.96695328e-05, 1.96695328e-05, -0.703783453, -0.710414648),
            CFrame.new(-4060.83228, 46.4606247, 5065.17041, -8.58306885e-06, 0.0378802717, 0.9992823, 1, 8.58306885e-06, 8.22544098e-06, -8.22544098e-06, 0.9992823, -0.0378801823),
            CFrame.new(-4198.26904, 46.3244781, 5102.25586, 2.84910202e-05, -0.988597989, 0.150579125, 1, 2.84910202e-05, -2.16066837e-06, -2.16066837e-06, 0.150579125, 0.988597989),
            CFrame.new(-4165.93652, 46.7464714, 4843.74316, 1.54972076e-06, -0.422563195, 0.906333447, 1, 1.54972076e-06, -9.83476639e-07, -9.83476639e-07, 0.906333447, 0.422563195),
            CFrame.new(-4751.43848, 43.617115, 4931.35645, -6.43730164e-06, 0.173615277, 0.984813631, 1, 6.37769699e-06, 5.42402267e-06, -5.42402267e-06, 0.984813631, -0.173615336),
            CFrame.new(-5305.7793, 46.3041267, 4970.16943, 4.0948391e-05, 0.966288626, -0.257461786, 1.00000012, -4.12464142e-05, 5.37931919e-06, -5.37931919e-06, -0.257461786, -0.966288805),
            CFrame.new(-5081.28174, 45.4488754, 4867.95801, -1.66893005e-06, 0.198071688, 0.980187535, 1, 1.66893005e-06, 1.34110451e-06, -1.34110451e-06, 0.980187535, -0.198071718),
            CFrame.new(-4683.97754, 46.3174934, 4793.32666, -5.24520874e-06, 0.203165472, 0.979144454, 1, 5.1856041e-06, 4.2617321e-06, -4.2617321e-06, 0.979144454, -0.203165531),
            CFrame.new(-4192.91455, 45.5189095, 4713.36572, 2.10404396e-05, 0.957543075, 0.288290054, 0.99999994, -2.0980835e-05, -3.09944153e-06, 3.09944153e-06, 0.288290054, -0.957543135),
            CFrame.new(-4277.23633, 43.0489655, 4203.81738, -4.42266464e-05, -0.999355972, 0.0358850844, 1, -4.42266464e-05, 7.93486834e-07, 7.93486834e-07, 0.0358850844, 0.999355912),
            CFrame.new(-4404.104, 45.3556252, 3396.99365, 4.29153442e-05, -0.984804988, 0.173663557, 1, 4.29153442e-05, -3.75509262e-06, -3.75509262e-06, 0.173663557, 0.984805048),
            CFrame.new(-4739.25293, 41.2888908, 1538.89795, 4.29153442e-05, -0.984804988, 0.173663557, 1, 4.29153442e-05, -3.75509262e-06, -3.75509262e-06, 0.173663557, 0.984805048),
        }
 
        for i, checkpointCFrame in ipairs(checkpointCFrames) do
            playerCar:SetPrimaryPartCFrame(checkpointCFrame)
            RunS.Heartbeat:Wait()
        end
        
        repeat RunS.Heartbeat:Wait() until tick() - startTime >= 71
 
        local finalCheckpointCFrame = CFrame.new(-4839.61328, 44.5184326, 945.549805, 1.57356262e-05, -0.986318946, 0.164848655, 1.00000012, 1.57356262e-05, -1.31875277e-06, -1.31875277e-06, 0.164848655, 0.986318886)
        playerCar:SetPrimaryPartCFrame(finalCheckpointCFrame)
    end
 
    function AntiAFK()
        AFKVal = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
            wait()
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
        end)
    end
 
 
 
    function FluentMisc()
        SaveManager:SetLibrary(Fluent)
        InterfaceManager:SetLibrary(Fluent)
 
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({})
 
        InterfaceManager:SetFolder("FluentScriptHub")
        SaveManager:SetFolder("FluentScriptHub/specific-game")
 
        InterfaceManager:BuildInterfaceSection(Tabs.Settings)
        SaveManager:BuildConfigSection(Tabs.Settings)
 
        Window:SelectTab(1)
 
        SaveManager:LoadAutoloadConfig()
    end
 
    -- [ CALLBACK FUNCTION ] -- 
    FluentMisc()
    AntiAFK()
    DestroyLogger()
