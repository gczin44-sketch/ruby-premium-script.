---------------------------------------------------------
-- SERVIÇOS E VARIÁVEIS INICIAIS
---------------------------------------------------------
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

---------------------------------------------------------
-- ANIMAÇÃO DE INTRODUÇÃO (TELA PRETA & EMOJIS)
---------------------------------------------------------
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "RubyIntroGui"
IntroGui.ResetOnSpawn = false
IntroGui.DisplayOrder = 999
IntroGui.Parent = CoreGui

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Parent = IntroGui

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0.8, 0, 0.2, 0)
IntroText.Position = UDim2.new(0.1, 0, 0.4, 0)
IntroText.BackgroundTransparency = 1
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.Font = Enum.Font.SourceSansBold
IntroText.TextSize = 36
IntroText.TextScaled = true
IntroText.Text = ""
IntroText.Parent = Background

-- Sequência da Animação
task.spawn(function()
    IntroText.Text = "🥊  VS  🥊"
    task.wait(1)
    
    IntroText.Text = "🥊 💥 🥊"
    task.wait(0.8)
    
    IntroText.Text = "💥 🥊 🏆"
    task.wait(1)
    
    IntroText.TextColor3 = Color3.fromRGB(255, 50, 50)
    IntroText.Text = "🔴⚪⚫ SÃO PAULO VENCEU!"
    task.wait(1.8)
    
    local fadeBackground = TweenService:Create(Background, TweenInfo.new(1), {BackgroundTransparency = 1})
    local fadeText = TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 1})
    
    fadeBackground:Play()
    fadeText:Play()
    
    fadeBackground.Completed:Wait()
    IntroGui:Destroy()
end)

-- Aguarda a introdução terminar para carregar a interface
task.wait(4.8)

---------------------------------------------------------
-- CARREGAMENTO DA RAYFIELD LIBRARY
---------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "💎 Ruby Premium - Torcidas Online",
   Icon = 0,
   LoadingTitle = "Ruby Premium",
   LoadingSubtitle = "Edição São Paulo",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

---------------------------------------------------------
-- ABA 1: COMBATE AVANÇADO
---------------------------------------------------------
local AdvCombatTab = Window:CreateTab("Combate Avançado", 4483345998)

local superPunchEnabled = false
local punchPower = 150

AdvCombatTab:CreateToggle({
   Name = "Super Soco (Jogar Inimigo Longe)",
   CurrentValue = false,
   Flag = "SuperPunchFlag",
   Callback = function(Value)
       superPunchEnabled = Value
   end,
})

AdvCombatTab:CreateSlider({
   Name = "Força do Impacto (Knockback)",
   Range = {50, 500},
   Increment = 10,
   Suffix = " Força",
   CurrentValue = 150,
   Flag = "PunchPowerFlag",
   Callback = function(Value)
       punchPower = Value
   end,
})

RunService.Stepped:Connect(function()
    if superPunchEnabled and LocalPlayer.Character then
        local myChar = LocalPlayer.Character
        for _, partName in pairs({"RightHand", "LeftHand", "RightArm", "LeftArm"}) do
            local limb = myChar:FindFirstChild(partName)
            if limb then
                limb.Touched:Connect(function(hit)
                    if not superPunchEnabled then return end
                    local targetChar = hit.Parent
                    if targetChar and targetChar:FindFirstChild("Humanoid") and targetChar ~= myChar then
                        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                        if targetHrp and myHrp then
                            local direction = (targetHrp.Position - myHrp.Position).Unit
                            targetHrp.Velocity = direction * punchPower + Vector3.new(0, punchPower / 2, 0)
                        end
                    end
                end)
            end
        end
    end
end)

local reachEnabled = false
local reachSize = 8

AdvCombatTab:CreateToggle({
   Name = "Aumentar Alcance dos Golpes (Hitbox)",
   CurrentValue = false,
   Flag = "ReachFlag",
   Callback = function(Value)
       reachEnabled = Value
   end,
})

AdvCombatTab:CreateSlider({
   Name = "Tamanho da Hitbox",
   Range = {4, 20},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 8,
   Flag = "ReachSizeFlag",
   Callback = function(Value)
       reachSize = Value
   end,
})

RunService.RenderStepped:Connect(function()
    if reachEnabled and LocalPlayer.Character then
        local rightHand = LocalPlayer.Character:FindFirstChild("RightHand") or LocalPlayer.Character:FindFirstChild("Right Arm")
        if rightHand then
            rightHand.Size = Vector3.new(reachSize, reachSize, reachSize)
            rightHand.Transparency = 0.7
            rightHand.BrickColor = BrickColor.new("Bright red")
            rightHand.CanCollide = false
        end
    end
end)

---------------------------------------------------------
-- ABA 2: UTILITÁRIOS PVP
---------------------------------------------------------
local CombatTab = Window:CreateTab("Utilitários PvP", 4483345998)

local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "RubyCrosshairTO"
CrosshairGui.Parent = CoreGui
CrosshairGui.ResetOnSpawn = false

local CrosshairLabel = Instance.new("TextLabel")
CrosshairLabel.Size = UDim2.new(0, 30, 0, 30)
CrosshairLabel.Position = UDim2.new(0.5, -15, 0.5, -15)
CrosshairLabel.BackgroundTransparency = 1
CrosshairLabel.Text = "🧿"
CrosshairLabel.TextSize = 22
CrosshairLabel.Visible = false
CrosshairLabel.Parent = CrosshairGui

CombatTab:CreateToggle({
   Name = "Mira Central de Combate (🧿)",
   CurrentValue = false,
   Flag = "CrosshairFlag",
   Callback = function(Value)
       CrosshairLabel.Visible = Value
   end,
})

local infJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

CombatTab:CreateToggle({
   Name = "Pulo Infinito (Esquiva)",
   CurrentValue = false,
   Flag = "InfJumpFlag",
   Callback = function(Value)
       infJumpEnabled = Value
   end,
})

local noclipEnabled = false
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

CombatTab:CreateToggle({
   Name = "NoClip (Atravessar Obstáculos)",
   CurrentValue = false,
   Flag = "NoClipFlag",
   Callback = function(Value)
       noclipEnabled = Value
   end,
})

---------------------------------------------------------
-- ABA 3: RADAR RIVAL (ESP INIMIGOS)
---------------------------------------------------------
local RadarTab = Window:CreateTab("Radar Rival", 4483345998)

local espDistanceEnabled = false
local espOnlyEnemies = true
local espObjects = {}
local playerConnections = {}

local function removeEsp(player)
    if espObjects[player] then
        if espObjects[player].Gui then
            espObjects[player].Gui:Destroy()
        end
        espObjects[player] = nil
    end
end

local function isEnemy(player)
    if player == LocalPlayer then return false end
    
    if LocalPlayer.Team and player.Team then
        return player.Team ~= LocalPlayer.Team
    end
    
    if LocalPlayer.TeamColor and player.TeamColor then
        return player.TeamColor ~= LocalPlayer.TeamColor
    end
    
    return true
end

local function applyEsp(player)
    if player == LocalPlayer then return end
    
    if espOnlyEnemies and not isEnemy(player) then
        removeEsp(player)
        return
    end

    local function setupChar(character)
        if not character then return end
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        removeEsp(player)

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DistanceESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.Parent = hrp

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 14
        textLabel.Text = "[INIMIGO] " .. player.Name .. " [...]"
        textLabel.Parent = billboard

        espObjects[player] = {Gui = billboard, Label = textLabel, Character = character}
    end

    if player.Character then
        setupChar(player.Character)
    end
    
    if not playerConnections[player] then
        playerConnections[player] = player.CharacterAdded:Connect(setupChar)
    end
end

RunService.RenderStepped:Connect(function()
    if not espDistanceEnabled then return end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if not myHrp then return end

    for player, data in pairs(espObjects) do
        if espOnlyEnemies and not isEnemy(player) then
            removeEsp(player)
        elseif data.Character and data.Character:FindFirstChild("HumanoidRootPart") then
            local distanceStuds = (myHrp.Position - data.Character.HumanoidRootPart.Position).Magnitude
            local distanceMeters = math.floor(distanceStuds * 0.28)
            
            data.Label.Text = "🎯 " .. player.Name .. " [" .. tostring(distanceMeters) .. "m]"
        end
    end
end)

RadarTab:CreateToggle({
   Name = "ESP Distância de Jogadores",
   CurrentValue = false,
   Flag = "ESPDistanceFlag",
   Callback = function(Value)
       espDistanceEnabled = Value

       if Value then
           for _, player in pairs(Players:GetPlayers()) do
               applyEsp(player)
           end

           playerConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
               if espDistanceEnabled then
                   applyEsp(player)
               end
           end)

           playerConnections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(player)
               removeEsp(player)
               if playerConnections[player] then
                   playerConnections[player]:Disconnect()
                   playerConnections[player] = nil
               end
           end)
       else
           for player, _ in pairs(espObjects) do
               removeEsp(player)
           end
       end
   end,
})

RadarTab:CreateToggle({
   Name = "Mostrar Apenas Inimigos",
   CurrentValue = true,
   Flag = "ESPOnlyEnemiesFlag",
   Callback = function(Value)
       espOnlyEnemies = Value
       
       if espDistanceEnabled then
           for _, player in pairs(Players:GetPlayers()) do
               if Value and not isEnemy(player) then
                   removeEsp(player)
               else
                   applyEsp(player)
               end
           end
       end
   end,
})

---------------------------------------------------------
-- ABA 4: DESEMPENHO & FPS
---------------------------------------------------------
local PerformanceTab = Window:CreateTab("Desempenho", 4483345998)

PerformanceTab:CreateToggle({
   Name = "FPS Booster (Anti-Lag)",
   CurrentValue = false,
   Flag = "FPSBoosterFlag",
   Callback = function(Value)
       if Value then
           local terrain = Workspace:FindFirstChildOfClass("Terrain")
           if terrain then
               terrain.WaterWaveSize = 0
               terrain.WaterWaveSpeed = 0
               terrain.WaterReflectance = 0
               terrain.WaterTransparency = 0
           end
           Lighting.GlobalShadows = false
           settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
       else
           Lighting.GlobalShadows = true
           settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
       end
   end,
})

PerformanceTab:CreateToggle({
   Name = "Gráfico de Massinha",
   CurrentValue = false,
   Flag = "MassinhaFlag",
   Callback = function(Value)
       if Value then
           for _, v in pairs(Workspace:GetDescendants()) do
               if v:IsA("BasePart") and not v:IsA("MeshPart") then
                   v.Material = Enum.Material.SmoothPlastic
               end
           end
       end
   end,
})

---------------------------------------------------------
-- ABA 5: COLETOR DE ARMAS & ROUBO DE ITENS
---------------------------------------------------------
local ItemTab = Window:CreateTab("Coletor de Objetos", 4483345998)

-- BOTÃO DE DUPLICAR ITEM
ItemTab:CreateButton({
   Name = "🌀 Duplicar Item Equipado (Local)",
   Callback = function()
       local char = LocalPlayer.Character
       local tool = char and char:FindFirstChildOfClass("Tool")
       local backpack = LocalPlayer:FindFirstChild("Backpack")
       
       if tool and backpack then
           local itemClonado = tool:Clone()
           itemClonado.Parent = backpack
           
           Rayfield:Notify({
               Title = "Item Duplicado!",
               Content = "Item clonado no inventário (Lembrando: visibilidade/uso local devido ao FE).",
               Duration = 4,
               Image = 4483345998,
           })
       else
           Rayfield:Notify({
               Title = "Atenção",
               Content = "Equipe o item/arma na mão antes de clicar em duplicar.",
               Duration = 3,
               Image = 4483345998,
           })
       end
   end,
})

-- BOTÃO DE SOLTAR ITEM (NOVO)
ItemTab:CreateButton({
   Name = "📦 Soltar Item Equipado",
   Callback = function()
       local char = LocalPlayer.Character
       local tool = char and char:FindFirstChildOfClass("Tool")
       
       if tool then
           tool.Parent = Workspace
           Rayfield:Notify({
               Title = "Item Solto!",
               Content = "Você soltou o item '" .. tool.Name .. "' no chão.",
               Duration = 3,
               Image = 4483345998,
           })
       else
           Rayfield:Notify({
               Title = "Atenção",
               Content = "Você precisa estar segurando um item na mão para soltá-lo.",
               Duration = 3,
               Image = 4483345998,
           })
       end
   end,
})

local autoPickEnabled = false

local function coletarArmasProximas()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Tool") and item.Parent ~= char and not item.Parent:FindFirstChild("Humanoid") then
            local handle = item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")
            if handle then
                handle.CFrame = hrp.CFrame
            end
        elseif item:IsA("ProximityPrompt") then
            local parentPart = item.Parent
            if parentPart and parentPart:IsA("BasePart") then
                local dist = (hrp.Position - parentPart.Position).Magnitude
                if dist <= 25 then
                    fireproximityprompt(item)
                end
            end
        end
    end
end

ItemTab:CreateButton({
   Name = "Puxar Armas / Objetos Próximos",
   Callback = function()
       coletarArmasProximas()
   end,
})

ItemTab:CreateToggle({
   Name = "Auto-Coletar Armas do Chão (Loop)",
   CurrentValue = false,
   Flag = "AutoPickUpFlag",
   Callback = function(Value)
       autoPickEnabled = Value
   end,
})

task.spawn(function()
    while true do
        task.wait(0.5)
        if autoPickEnabled then
            pcall(coletarArmasProximas)
        end
    end
end)

local jogadorAlvoSelecionado = nil

local function obterJogadoresComArma()
    local lista = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                table.insert(lista, player.Name .. " [" .. tool.Name .. "]")
            end
        end
    end
    if #lista == 0 then
        table.insert(lista, "Ninguém com arma equipada")
    end
    return lista
end

local DropdownRoubar = ItemTab:CreateDropdown({
   Name = "Selecione o Jogador com Arma",
   Options = obterJogadoresComArma(),
   CurrentOption = {"Aguardando..."},
   Flag = "DropdownRoubaArmaFlag",
   Callback = function(Option)
       local nomePlayer = tostring(Option[1]):match("^(.-)%s%[")
       if nomePlayer then
           jogadorAlvoSelecionado = Players:FindFirstChild(nomePlayer)
       end
   end,
})

ItemTab:CreateButton({
   Name = "Atualizar Jogadores Armados",
   Callback = function()
       DropdownRoubar:Set(obterJogadoresComArma())
   end,
})

ItemTab:CreateButton({
   Name = "🗡️ Roubar Arma do Jogador Selecionado",
   Callback = function()
       if jogadorAlvoSelecionado and jogadorAlvoSelecionado.Character then
           local tool = jogadorAlvoSelecionado.Character:FindFirstChildOfClass("Tool")
           local myChar = LocalPlayer.Character
           local myBackpack = LocalPlayer:FindFirstChild("Backpack")

           if tool and myChar and myBackpack then
               tool.Parent = myBackpack
               local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
               local myHrp = myChar:FindFirstChild("HumanoidRootPart")
               if handle and myHrp then
                   handle.CFrame = myHrp.CFrame
               end
           end
       end
   end,
})

---------------------------------------------------------
-- ABA 6: EXTRAS
---------------------------------------------------------
local ExtrasTab = Window:CreateTab("Extras", 4483345998)

local rageModeEnabled = false
local legitModeEnabled = false

ExtrasTab:CreateToggle({
   Name = "🔥 Rage Mode (Modo Agressivo)",
   CurrentValue = false,
   Flag = "RageModeFlag",
   Callback = function(Value)
       rageModeEnabled = Value
       if Value then
           if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
               LocalPlayer.Character.Humanoid.WalkSpeed = 35
               LocalPlayer.Character.Humanoid.JumpPower = 100
           end
           Rayfield:Notify({
               Title = "Rage Mode Ativado",
               Content = "Atributos de movimentação aumentados ao máximo.",
               Duration = 3,
               Image = 4483345998,
           })
       else
           if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
               LocalPlayer.Character.Humanoid.WalkSpeed = 16
               LocalPlayer.Character.Humanoid.JumpPower = 50
           end
       end
   end,
})

ExtrasTab:CreateToggle({
   Name = "🛡️ Legit Mode (Modo Discreto)",
   CurrentValue = false,
   Flag = "LegitModeFlag",
   Callback = function(Value)
       legitModeEnabled = Value
       if Value then
           if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
               LocalPlayer.Character.Humanoid.WalkSpeed = 16
               LocalPlayer.Character.Humanoid.JumpPower = 50
           end
           Rayfield:Notify({
               Title = "Legit Mode Ativado",
               Content = "Atributos redefinidos para o padrão normal.",
               Duration = 3,
               Image = 4483345998,
           })
       end
   end,
})

local autoHealEnabled = false

ExtrasTab:CreateToggle({
   Name = "❤️ Auto Heal (Cura Automática)",
   CurrentValue = false,
   Flag = "AutoHealFlag",
   Callback = function(Value)
       autoHealEnabled = Value
   end,
})

task.spawn(function()
    while true do
        task.wait(1)
        if autoHealEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                local healItem = LocalPlayer.Backpack:FindFirstChild("Medkit") 
                    or LocalPlayer.Backpack:FindFirstChild("Curativo") 
                    or LocalPlayer.Backpack:FindFirstChild("Bandage")
                    or LocalPlayer.Character:FindFirstChild("Medkit")
                    or LocalPlayer.Character:FindFirstChild("Curativo")
                
                if healItem then
                    if healItem.Parent == LocalPlayer.Backpack then
                        humanoid:EquipTool(healItem)
                    end
                    healItem:Activate()
                end
            end
        end
    end
end)

local healthEspEnabled = false
local healthEspObjects = {}

local function applyHealthEsp(player)
    if player == LocalPlayer then return end

    local function setupChar(character)
        if not character then return end
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        local hum = character:WaitForChild("Humanoid", 5)
        if not hrp or not hum then return end

        if healthEspObjects[player] and healthEspObjects[player].Gui then
            healthEspObjects[player].Gui:Destroy()
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HealthESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 4.5, 0)
        billboard.Parent = hrp

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 14
        
        local function atualizarTexto(vida)
            local ratio = math.clamp(vida / hum.MaxHealth, 0, 1)
            textLabel.Text = "💚 " .. player.Name .. " [" .. math.floor(vida) .. " HP]"
            textLabel.TextColor3 = Color3.fromRGB(math.floor(255 * (1 - ratio)), math.floor(255 * ratio), 50)
        end

        atualizarTexto(hum.Health)
        textLabel.Parent = billboard

        local conn = hum.HealthChanged:Connect(function(newHealth)
            if healthEspEnabled then
                atualizarTexto(newHealth)
            end
        end)

        healthEspObjects[player] = {Gui = billboard, Label = textLabel, Connection = conn}
    end

    if player.Character then
        setupChar(player.Character)
    end
    
    player.CharacterAdded:Connect(setupChar)
end

ExtrasTab:CreateToggle({
   Name = "💚 Health ESP (Mostrar Vida dos Players)",
   CurrentValue = false,
   Flag = "HealthESPFlag",
   Callback = function(Value)
       healthEspEnabled = Value
       if Value then
           for _, player in pairs(Players:GetPlayers()) do
               applyHealthEsp(player)
           end
       else
           for player, data in pairs(healthEspObjects) do
               if data.Gui then data.Gui:Destroy() end
               if data.Connection then data.Connection:Disconnect() end
           end
           healthEspObjects = {}
       end
   end,
})
