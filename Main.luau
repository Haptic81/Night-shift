if _G.HapticUI then _G.HapticUI:Destroy() end

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")

local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
Gui.Name = "HapticUI"
Gui.IgnoreGuiInset = true
_G.HapticUI = Gui

local Frame = Instance.new("Frame", Gui)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame.Visible = false
Frame.ClipsDescendants = true
Frame.BackgroundTransparency = 0
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 6)

local TitleBtn = Instance.new("TextButton", Frame)
TitleBtn.Text = "HapticHub BETA"
TitleBtn.Font = Enum.Font.GothamMedium
TitleBtn.TextSize = 14
TitleBtn.TextColor3 = Color3.new(1, 1, 1)
TitleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBtn.Size = UDim2.new(0, 80, 0, 22)
TitleBtn.Position = UDim2.new(0, 10, 0, 10)

local TitleUICorner = Instance.new("UICorner", TitleBtn)
TitleUICorner.CornerRadius = UDim.new(0, 5)

local MenuBtn = Instance.new("TextButton", Frame)
MenuBtn.Text = "≡"
MenuBtn.Font = Enum.Font.Gotham
MenuBtn.TextSize = 12
MenuBtn.TextColor3 = Color3.new(1,1,1)
MenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MenuBtn.Size = UDim2.new(0, 22, 0, 22)
MenuBtn.Position = UDim2.new(1, -32, 0, 10)

local MenuCorner = Instance.new("UICorner", MenuBtn)
MenuCorner.CornerRadius = UDim.new(0, 5)

local TabButton = Instance.new("TextButton", Frame)
TabButton.Text = "Main"
TabButton.Font = Enum.Font.GothamMedium
TabButton.TextSize = 12
TabButton.TextColor3 = Color3.new(1,1,1)
TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabButton.Size = UDim2.new(0, 55, 0, 22)
TabButton.Position = UDim2.new(0.5, -27, 0, 10)
TabButton.Visible = false

local TabCorner = Instance.new("UICorner", TabButton)
TabCorner.CornerRadius = UDim.new(0, 5)

local TabFrame = Instance.new("Frame", Frame)
TabFrame.BackgroundTransparency = 1
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.Size = UDim2.new(1, 0, 1, -50)
TabFrame.Visible = false

local function createButton(name, y)
	local btn = Instance.new("TextButton", TabFrame)
	btn.Size = UDim2.new(0, 140, 0, 28)
	btn.Position = UDim2.new(0, 20, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextSize = 14
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 5)
	return btn
end

local WalkspeedButton = createButton("", 10)
local SpeedBox = Instance.new("TextBox", WalkspeedButton)
SpeedBox.BackgroundTransparency = 1
SpeedBox.Size = UDim2.new(1, 0, 1, 0)
SpeedBox.Text = "WalkSpeed"
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.ClearTextOnFocus = false

local SpeedLabel = Instance.new("TextLabel", TabFrame)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 140, 0, 14)
SpeedLabel.Position = UDim2.new(0, 20, 0, 38)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextColor3 = Color3.fromRGB(120,120,120)
SpeedLabel.Text = "Current: " .. tostring(Hum.WalkSpeed)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local NoclipBtn = createButton("Noclip: Off", 60)
local InfJumpBtn = createButton("Infinite Jump: Off", 100)
local GetKeysBtn = createButton("Get All Keys", 140)
local BrightFlashBtn = createButton("Brighter Flashlight: Off", 180)
local GetHighBtn = createButton("Get High", 220)

local EyeOverlay = Instance.new("Frame", Gui)
EyeOverlay.BackgroundColor3 = Color3.new(0,0,0)
EyeOverlay.Size = UDim2.new(1, 0, 1, 0)
EyeOverlay.BackgroundTransparency = 1
EyeOverlay.ZIndex = 100
EyeOverlay.Visible = false

local eyeTweenIn = TweenService:Create(EyeOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.85})
local eyeTweenOut = TweenService:Create(EyeOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})

local noclip = false
local infjump = false
local brightFlash = false
local dizzy = false
local floating = false
local savedSpeed = Hum.WalkSpeed

local cam = workspace:FindFirstChild("Camera")
local flashCam = cam and cam:FindFirstChild("FlashlightCamera")
local function setFlashlightBrightness(on)
	if not flashCam then return end
	for _,v in pairs(flashCam:GetChildren()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Brightness = on and 10 or 1
		end
	end
end

SpeedBox.FocusLost:Connect(function()
	local val = tonumber(SpeedBox.Text)
	if val then
		savedSpeed = val
		Hum.WalkSpeed = val
		SpeedLabel.Text = "Current: " .. tostring(val)
	end
end)

NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipBtn.Text = "Noclip: " .. (noclip and "On" or "Off")
end)

InfJumpBtn.MouseButton1Click:Connect(function()
	infjump = not infjump
	InfJumpBtn.Text = "Infinite Jump: " .. (infjump and "On" or "Off")
end)

GetKeysBtn.MouseButton1Click:Connect(function()
	for _, obj in ipairs(game:GetDescendants()) do
		if obj:IsA("Tool") and obj:FindFirstChildOfClass("TouchTransmitter") then
			obj.Handle.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
		end
	end
end)

BrightFlashBtn.MouseButton1Click:Connect(function()
	brightFlash = not brightFlash
	BrightFlashBtn.Text = "Brighter Flashlight: " .. (brightFlash and "On" or "Off")
	setFlashlightBrightness(brightFlash)
end)

GetHighBtn.MouseButton1Click:Connect(function()
	if floating then return end
	floating = true
	local root = Char:FindFirstChild("HumanoidRootPart")
	if not root then floating = false return end

	EyeOverlay.Visible = true
	eyeTweenIn:Play()

	local camConn = RunService.RenderStepped:Connect(function()
		local offset = Vector3.new(math.random(-1,1), math.random(-1,1), math.random(-1,1)) * 0.2
		cam.CFrame = cam.CFrame * CFrame.new(offset)
	end)

	Hum.WalkSpeed = savedSpeed / 2

	for i = 1, 100 do
		if not root then break end
		root.CFrame = root.CFrame + Vector3.new(0, 0.3, 0)
		wait(0.01)
	end

	wait(2.5)

	camConn:Disconnect()
	Hum.WalkSpeed = savedSpeed
	eyeTweenOut:Play()
	wait(0.4)
	EyeOverlay.Visible = false
	floating = false
end)

UIS.InputBegan:Connect(function(input)
	if infjump and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
		if Hum:GetState() ~= Enum.HumanoidStateType.Seated then
			Hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
	if Hum and Hum.WalkSpeed ~= savedSpeed and not dizzy then
		Hum.WalkSpeed = savedSpeed
	end
end)

spawn(function()
	while wait(math.random(15,30)) do
		EyeOverlay.Visible = true
		eyeTweenIn:Play()
		wait(0.3)
		eyeTweenOut:Play()
		wait(0.3)
		eyeTweenIn:Play()
		wait(0.3)
		eyeTweenOut:Play()
		wait(0.3)
		EyeOverlay.Visible = false
	end
end)

spawn(function()
	while wait(math.random(40, 70)) do
		dizzy = true
		Hum.WalkSpeed = math.random(2, 10)
		for i = 1, 20 do
			Char:SetPrimaryPartCFrame(Char.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(math.random(-15,15)), 0))
			wait(0.05)
		end
		dizzy = false
	end
end)

local toggled = false

local function showUI()
	Frame.Visible = true
	TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 500, 0, 350),
		BackgroundTransparency = 0
	}):Play()
	wait(0.2)
	TitleBtn.TextTransparency = 0
	MenuBtn.TextTransparency = 0
end

local function hideUI()
	TweenService:Create(Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1
	}):Play()
	TitleBtn.TextTransparency = 1
	MenuBtn.TextTransparency = 1
	TabButton.Visible = false
	TabFrame.Visible = false
	wait(0.2)
	Frame.Visible = false
end

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		toggled = not toggled
		if toggled then showUI() else hideUI() end
	end
end)

MenuBtn.MouseButton1Click:Connect(function()
	TabButton.Visible = not TabButton.Visible
end)

TabButton.MouseButton1Click:Connect(function()
	TabFrame.Visible = not TabFrame.Visible
end)
