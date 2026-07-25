-- SERVIÇOS E VARIÁVEIS INICIAIS
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- ANIMAÇÃO DE INTRODUÇÃO (TELA PRETA & EMOJIS)
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
    IntroText.Text = "🥊 VS 🥊"
    task.wait(1)
    IntroText.Text = "🥊 💥 🥊"
    task.wait(0.8)
    IntroText.Text = "💥 🥊 🏆: E NOIX QUE TA Rlk MT e Rlk GB porra"
    task.wait(1)
    IntroText.TextColor3 = Color3.fromRGB(255, 50, 50)
    IntroText.Text = "AGITA PORRA NO DF E NOIX Q TA!"
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

-- CARREGAMENTO DA RAYFIELD LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "💎Torcidas Online",
   Icon = 0,
   LoadingTitle = "Ruby Premium",
   LoadingSubtitle = "Edição BRASILEIRA DF",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ABA 1: COMBATE & ANTI-AIM
local CombatTab = Window:CreateTab("Combate", 4483345998)

CombatTab:CreateSection("Modos de Jogo")

CombatTab:CreateToggle({
   Name = "Rage Mode",
   CurrentValue = false,
   Flag = "RageMode",
   Callback = function(Value) end,
})

CombatTab:CreateToggle({
   Name = "Legit Mode",
   CurrentValue = false,
   Flag = "LegitMode",
   Callback = function(Value) end,
})

CombatTab:CreateSection("Movimentação & Defesa")

CombatTab:CreateToggle({
   Name = "Spinbot",
   CurrentValue = false,
   Flag = "Spinbot",
   Callback = function(Value) end,
})

CombatTab:CreateToggle({
   Name = "Anti Aim",
   CurrentValue = false,
   Flag = "AntiAim",
   Callback = function(Value) end,
})

-- ABA 2: VISUAIS & ESP
local VisualsTab = Window:CreateTab("Visuais", 4483345998)

VisualsTab:CreateSection("ESP & Wallhack")

VisualsTab:CreateToggle({
   Name = "Player ESP / Wallhack",
   CurrentValue = false,
   Flag = "PlayerESP",
   Callback = function(Value) end,
})

VisualsTab:CreateToggle({
   Name = "Box ESP",
   CurrentValue = false,
   Flag = "BoxESP",
   Callback = function(Value) end,
})

VisualsTab:CreateToggle({
   Name = "Name ESP",
   CurrentValue = false,
   Flag = "NameESP",
   Callback = function(Value) end,
})

VisualsTab:CreateToggle({
   Name = "Skeleton ESP",
   CurrentValue = false,
   Flag = "SkeletonESP",
   Callback = function(Value) end,
})

VisualsTab:CreateToggle({
   Name = "Chams",
   CurrentValue = false,
   Flag = "Chams",
   Callback = function(Value) end,
})

VisualsTab:CreateToggle({
   Name = "Radar",
   CurrentValue = false,
   Flag = "Radar",
   Callback = function(Value) end,
})

-- ABA 3: MUNDO & CÂMERA
local WorldTab = Window:CreateTab("Mundo & Câmera", 4483345998)

WorldTab:CreateSection("Ajustes de Visão")

WorldTab:CreateSlider({
   Name = "FOV Changer",
   Range = {70, 120},
   Increment = 1,
   Suffix = " FOV",
   CurrentValue = 70,
   Flag = "FOVChanger",
   Callback = function(Value)
       Workspace.CurrentCamera.FieldOfView = Value
   end,
})

WorldTab:CreateSlider({
   Name = "Zoom",
   Range = {10, 70},
   Increment = 1,
   Suffix = " Zoom",
   CurrentValue = 70,
   Flag = "CameraZoom",
   Callback = function(Value)
       Workspace.CurrentCamera.FieldOfView = Value
   end,
})

WorldTab:CreateToggle({
   Name = "Fullbright / Brightness",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
       if Value then
           Lighting.Brightness = 2
           Lighting.ClockTime = 14
           Lighting.GlobalShadows = false
       else
           Lighting.Brightness = 1
           Lighting.GlobalShadows = true
       end
   end,
})
