local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Настройки
local TOGGLE_KEY = Enum.KeyCode.E
local FLY_SPEED = 20
local ACCELERATION = 4
local VERTICAL_SPEED = 20

-- Состояние
local flying = false
local velocity = Vector3.new()
local desiredVelocity = Vector3.new()

-- Ввод
local inputState = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    up = false,
    down = false
}

-- Функция направления движения по камере
local function getMoveDirection()
    local camCFrame = camera.CFrame
    local look = camCFrame.LookVector
    local right = camCFrame.RightVector

    local dir = Vector3.new()
    if inputState.forward then dir = dir + Vector3.new(look.X, 0, look.Z) end
    if inputState.backward then dir = dir - Vector3.new(look.X, 0, look.Z) end
    if inputState.right then dir = dir + Vector3.new(right.X, 0, right.Z) end
    if inputState.left then dir = dir - Vector3.new(right.X, 0, right.Z) end

    if dir.Magnitude > 0 then
        return dir.Unit
    else
        return Vector3.new(0,0,0)
    end
end

-- Ввод клавиш
uis.InputBegan:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode
    if key == TOGGLE_KEY then
        flying = not flying
        print(flying and "🟩 Полёт включён" or "🟥 Полёт выключен")
    elseif key == Enum.KeyCode.W then
        inputState.forward = true
    elseif key == Enum.KeyCode.S then
        inputState.backward = true
    elseif key == Enum.KeyCode.A then
        inputState.left = true
    elseif key == Enum.KeyCode.D then
        inputState.right = true
    elseif key == Enum.KeyCode.Space then
        inputState.up = true
    elseif key == Enum.KeyCode.LeftControl then
        inputState.down = true
    end
end)

uis.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then inputState.forward = false
    elseif key == Enum.KeyCode.S then inputState.backward = false
    elseif key == Enum.KeyCode.A then inputState.left = false
    elseif key == Enum.KeyCode.D then inputState.right = false
    elseif key == Enum.KeyCode.Space then inputState.up = false
    elseif key == Enum.KeyCode.LeftControl then inputState.down = false
    end
end)

-- Главный цикл полёта
runService.RenderStepped:Connect(function(dt)
    if not flying then return end
    if not hrp or not hrp.Parent then return end

    local dir = getMoveDirection()
    local vert = 0
    if inputState.up then vert = VERTICAL_SPEED
    elseif inputState.down then vert = -VERTICAL_SPEED
    end

    desiredVelocity = Vector3.new(dir.X * FLY_SPEED, vert, dir.Z * FLY_SPEED)
    velocity = velocity:Lerp(desiredVelocity, math.clamp(ACCELERATION * dt, 0, 1))

    -- Применяем скорость
    if hrp.AssemblyLinearVelocity then
        hrp.AssemblyLinearVelocity = velocity
    else
        hrp.Velocity = velocity
    end
end)
