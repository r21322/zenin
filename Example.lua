--[[
	ZeninUI — full feature showcase.
	Every element, window option and runtime API is used at least once. Run it in an executor;
	re-running it unloads the previous window automatically.
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/r21322/zenin/main/ZeninUi.lua"))()

-- Custom theme: only a couple of tokens are required, the rest are derived.
Library.AddTheme("Midnight", {
	WindowBg = Color3.fromRGB(12, 14, 22),
	Text = Color3.fromRGB(232, 236, 255),
})

local Window = Library.CreateWindow({
	Title = "Zenin Showcase",
	Logo = "sparkles",
	Theme = "Dark",
	Accent = Color3.fromRGB(255, 89, 89),
	ToggleKey = Enum.KeyCode.RightShift,
	Scale = 1,
	ConfigFolder = "ZeninShowcase",
	Configs = {AutoLoad = true},
	Watermark = {
		Title = "Zenin",
		Site = "zenin.dev",
		Modes = {"Time", "FPS", "Ping"},
	},
	KeybindList = {Title = "Keybinds", ShowInactive = true},
	-- Uncomment to gate the window behind a key prompt:
	-- KeySystem = {Title = "Zenin Key", Keys = {"demo-key"}, KeyLink = "https://example.com", SaveKey = true},
})

---------------------------------------------------------------------------------------------------
-- Tab 1: Basics — toggle, slider, dropdowns, buttons, dependencies, per-element settings
---------------------------------------------------------------------------------------------------
local Basics = Window.AddTab({Name = "Basics", Icon = "layout-grid"})

local Combat = Basics.AddSection({Name = "Toggles & Sliders", Side = "Left"})

local Aimbot = Combat.AddToggle({
	Name = "Aimbot",
	Default = false,
	Flag = "Aimbot",
	Callback = function(on) print("Aimbot:", on) end,
})

-- Disabled until Aimbot is on.
local Fov = Combat.AddSlider({
	Name = "FOV",
	Min = 10, Max = 360, Default = 90, Step = 5,
	Suffix = "°",
	Flag = "AimbotFov",
	DependsOn = Aimbot,
	Callback = function(v) print("FOV:", v) end,
})

Combat.AddSlider({
	Name = "Smoothness",
	Min = 0, Max = 1, Default = 0.35, Step = 0.05,
	Format = function(v) return string.format("%d%%", v * 100) end,
	Flag = "Smoothness",
	DependsOn = "Aimbot", -- a flag name works too
})

-- Per-element settings panel (gear icon) with nested elements.
local AimSettings = Aimbot.AddSettings({Title = "Aimbot Settings"})
AimSettings.AddDropdown({Name = "Target Part", Options = {"Head", "Torso", "Random"}, Default = "Head", Flag = "AimPart"})
AimSettings.AddToggle({Name = "Visible Check", Default = true, Flag = "AimVisCheck"})
AimSettings.AddSlider({Name = "Prediction", Min = 0, Max = 10, Default = 2, Flag = "AimPrediction"})

Combat.AddToggle({Name = "Hidden Until Aimbot Off", Flag = "Inverse", DependsOn = Aimbot, InvertDependency = true})

local Choices = Basics.AddSection({Name = "Dropdowns", Side = "Right"})

local Weapon = Choices.AddDropdown({
	Name = "Weapon",
	Icon = "sword",
	Options = {"Pistol", "Rifle", "Shotgun"},
	Default = "Rifle",
	Flag = "Weapon",
	Callback = function(v) print("Weapon:", v) end,
})

Choices.AddDropdown({
	Name = "Optional Pick",
	Options = {"A", "B", "C"},
	AllowNone = true,
	Placeholder = "Nothing selected",
	Flag = "Optional",
})

local Esp = Choices.AddMultiDropdown({
	Name = "ESP Parts",
	Options = {"Box", "Name", "Health", "Distance", "Tracer"},
	Default = {"Box", "Name"},
	Flag = "EspParts",
	Callback = function(list) print("ESP:", table.concat(list, ", ")) end,
})

local Buttons = Basics.AddSection({Name = "Buttons", Side = "Right"})

Buttons.AddButton({
	Name = "Add Sniper option",
	Callback = function()
		Weapon.AddOption("Sniper")
		Window.Notify({Title = "Dropdown", Content = "Added 'Sniper' to Weapon.", Icon = "plus"})
	end,
})

Buttons.AddButton({Name = "Select every ESP part", Callback = function() Esp.SelectAll() end})

-- Giving an Icon/Description turns AddButton into a card button.
Buttons.AddButton({
	Name = "Reset Basics",
	Description = "Puts every control in this tab back to its default.",
	Icon = "rotate-ccw",
	ButtonText = "Reset",
	Callback = function()
		Aimbot.Set(false)
		Fov.Set(90)
		Weapon.Set("Rifle")
		Esp.Set({"Box", "Name"})
	end,
})

---------------------------------------------------------------------------------------------------
-- Tab 2: Inputs — text, numeric, keybinds, color pickers, stepper, segmented, range
---------------------------------------------------------------------------------------------------
local Inputs = Window.AddTab({Name = "Inputs", Icon = "keyboard"})

local Text = Inputs.AddSection({Name = "Text & Numbers", Side = "Left"})

Text.AddInput({
	Name = "Player Name",
	Placeholder = "Type a username…",
	MaxLength = 20,
	Flag = "PlayerName",
	Callback = function(t) print("Name:", t) end,
})

Text.AddInput({
	Name = "Walk Speed",
	Numeric = true, Min = 0, Max = 500, Default = 16,
	Finished = false, -- fire while typing instead of on focus loss
	Flag = "WalkSpeedInput",
})

Text.AddStepper({
	Name = "Jump Power",
	Min = 0, Max = 200, Default = 50, Step = 5,
	Flag = "JumpPower",
	Callback = function(v) print("Jump:", v) end,
})

Text.AddRangeSlider({
	Name = "Distance Range",
	Min = 0, Max = 1000, Default = {100, 600}, Step = 10,
	Suffix = " studs",
	Flag = "DistRange",
	Callback = function(range) print("Range:", range[1], range[2]) end,
})

Text.AddSegmented({
	Name = "Mode",
	Options = {"Legit", "Rage", "Custom"},
	Default = "Legit",
	Flag = "Mode",
})

local Binds = Inputs.AddSection({Name = "Keybinds", Side = "Right"})

Binds.AddKeybind({
	Name = "Fly",
	Default = "F",
	Mode = "Toggle", -- Toggle / Hold / Press; right-click the bind to switch between allowed modes
	Flag = "FlyKey",
	Callback = function(active) print("Fly:", active) end,
	ChangedCallback = function(bind) print("Fly bound to", bind) end,
})

Binds.AddKeybind({
	Name = "Sprint",
	Default = "LeftShift",
	Mode = "Hold",
	Flag = "SprintKey",
	Callback = function(held) print("Sprint:", held) end,
})

Binds.AddKeybind({
	Name = "Teleport",
	Default = "Ctrl+T", -- modifier combos are supported
	Mode = "Press",
	Flag = "TeleportKey",
	Callback = function() print("Teleport!") end,
})

local Colors = Inputs.AddSection({Name = "Colors", Side = "Right"})

Colors.AddColorPicker({
	Name = "ESP Color",
	Default = Color3.fromRGB(0, 200, 255),
	Alpha = 0.8,
	Flag = "EspColor",
	Callback = function(c, alpha) print("ESP color:", c, alpha) end,
})

-- Up to four swatches in one row.
Colors.AddColorPicker({
	Name = "Team Colors",
	Colors = {Color3.fromRGB(80, 200, 120), Color3.fromRGB(235, 87, 87), Color3.fromRGB(250, 200, 70)},
	Flag = "TeamColors",
})

---------------------------------------------------------------------------------------------------
-- Tab 3: Display — labels, paragraphs, dividers, progress bar, sub-tabs
---------------------------------------------------------------------------------------------------
local Display = Window.AddTab({Name = "Display", Icon = "monitor"})
local Overview = Display.AddSubTab({Name = "Overview", Icon = "eye"})
local Live = Display.AddSubTab({Name = "Live", Icon = "activity"})

local Info = Overview.AddSection({Name = "Text", Side = "Left"})
Info.AddLabel({Text = "A plain label."})
Info.AddLabel({Text = "<b>Rich</b> <i>text</i> label", RichText = true, Center = true})
local Status = Info.AddLabel({Text = "Status: idle", Color = Color3.fromRGB(150, 150, 156)})
Info.AddDivider({Text = "Paragraph"})
Info.AddParagraph({
	Title = "About",
	Content = "Paragraphs wrap long text automatically. Use them for descriptions, changelogs or help.",
})
Info.AddDivider()

local Progress = Live.AddSection({Name = "Progress", Side = "Left"})
local Bar = Progress.AddProgressBar({Name = "Loading", Max = 100, Default = 0, ShowValue = true})
Progress.AddButton({
	Name = "Run fake task",
	Callback = function()
		task.spawn(function()
			Bar.Set(0)
			Status.Set("Status: running")
			for _ = 1, 20 do
				task.wait(0.05)
				Bar.Increment(5)
			end
			Status.Set("Status: done")
			Window.Notify({Title = "Task", Content = "Finished!", Icon = "check", Duration = 3})
		end)
		return "Started" -- a returned string flashes on the button
	end,
})

---------------------------------------------------------------------------------------------------
-- Tab 4: API — window/runtime methods driven from buttons
---------------------------------------------------------------------------------------------------
local Api = Window.AddTab({Name = "API", Icon = "code"})

local WinSec = Api.AddSection({Name = "Window", Side = "Left"})
WinSec.AddDropdown({
	Name = "Theme",
	Options = Window.GetThemes(),
	Default = Window.GetTheme(),
	Callback = function(name) Window.SetTheme(name) end,
})
WinSec.AddButton({Name = "Random accent", Callback = function()
	Window.SetAccent(Color3.fromHSV(math.random(), 0.7, 1))
end})
WinSec.AddButton({Name = "Center window", Callback = function() Window.Center() end})
WinSec.AddButton({Name = "Open settings page", Callback = function() Window.SelectSettings() end})
WinSec.AddButton({Name = "Change toggle key to Insert", Callback = function()
	Window.SetToggleKey(Enum.KeyCode.Insert)
	Window.Notify({Title = "Toggle key", Content = "Press Insert to show/hide the UI."})
end})

local FlagSec = Api.AddSection({Name = "Flags & Configs", Side = "Right"})
FlagSec.AddButton({Name = "Print all flags", Callback = function()
	for flag, value in pairs(Library.Flags) do print(flag, value) end
end})
FlagSec.AddButton({Name = "Save 'showcase' config", Callback = function()
	local ok, err = Window.SaveConfig("showcase")
	if not ok then Window.Notify({Title = "Config", Content = "Save failed: " .. tostring(err)}) end
	return ok and "Saved" or "Failed"
end})
FlagSec.AddButton({Name = "Load 'showcase' config", Callback = function() Window.LoadConfig("showcase") end})
FlagSec.AddButton({Name = "Unload UI", Callback = function() Library.Unload() end})

-- Options are reachable by flag anywhere in the script.
Library.Options.Aimbot.OnChanged(function(on)
	Status.Set(on and "Status: aimbot armed" or "Status: idle")
end)

---------------------------------------------------------------------------------------------------
-- Extras: header button, settings-page section, on-screen keyboard config, lifecycle
---------------------------------------------------------------------------------------------------
Window.AddHeaderButton({
	Icon = "bell",
	Callback = function()
		Window.Notify({Title = "Hello", Content = "This came from a header button.", Icon = "bell", Duration = 4})
	end,
})

local Extra = Window.AddSettingsSection({Name = "Showcase", Side = "Right"})
Extra.AddToggle({Name = "Mouse wheel scrolling", Default = false, Callback = function(on) Window.SetMouseWheel(on) end})

-- Mobile: the custom on-screen keyboard used by inputs on touch devices.
Library.Keyboard.Configure({Mode = "Auto", Layout = "Default"})

Window.Watermark.SetDetail("showcase")
Window.KeybindList.SetShowInactive(true)

Window.OnUnload(function() print("Zenin showcase unloaded") end)

Window.Notify({
	Title = "Zenin Showcase",
	Content = "Loaded. Press RightShift to toggle the UI.",
	Icon = "sparkles",
	Duration = 5,
})
