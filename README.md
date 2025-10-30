# StealMyBrainrot_script_public

## Execute this to use script (OLD)
```lua
local key = "PLACEHOLDER"
loadstring(game:HttpGet("https://raw.githubusercontent.com/UndefinedClear/StealMyBrainrot_script_public/refs/heads/main/script.lua", true))()
```

## NEW
```lua
local key_for_script = "PLACEHOLDER"

local chunk = loadstring(game:HttpGet("https://raw.githubusercontent.com/UndefinedClear/StealMyBrainrot_script_public/refs/heads/main/script.lua", true))
local script = chunk()  -- теперь код выполнен

script(key_for_script)
```
