-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables --
local player = Players.LocalPlayer
local BankAmount = 0
local selectedShopItem = "None"

if not ReplicatedStorage:FindFirstChild("structures") then return end
if getgenv().Loaded then return end
getgenv().Loaded = true

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Build & Steal time (Spectra Client) v1.0",
    SubTitle = "by 1DeRBy1",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 340),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

local Tabs = {
    Bank = Window:AddTab({ Title = "Bank", Icon = "landmark" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-bag" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Bank:AddInput("Amount", {
    Title = "Enter Amount",
    Description = "Enter amount to deposit/withdraw",
    Default = "0",
    Placeholder = "Enter a Number...",
    Numeric = true,
    Callback = function(v)
        BankAmount = tonumber(v) or 0
    end
})

Tabs.Bank:AddButton({
    Title = "Deposit Time",
    Description = "Deposits your specified time",
    Callback = function()
        local bankEvent = player.PlayerGui:FindFirstChild("bank") and player.PlayerGui.bank:FindFirstChild("RemoteEvent")
        if bankEvent then
            bankEvent:FireServer(BankAmount, "deposit")
        end
    end
})

Tabs.Bank:AddButton({
    Title = "Withdraw Time",
    Description = "Withdraws your specified time",
    Callback = function()
        local bankEvent = player.PlayerGui:FindFirstChild("bank") and player.PlayerGui.bank:FindFirstChild("RemoteEvent")
        if bankEvent then
            bankEvent:FireServer(BankAmount, "withdraw")
        end
    end
})

local gearFolder = ReplicatedStorage:FindFirstChild("gear")
local gearNames = {}
if gearFolder then
    for _, item in ipairs(gearFolder:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(gearNames, item.Name)
        end
    end
    table.sort(gearNames)
end

selectedShopItem = gearNames[1] or "None"

Tabs.Shop:AddDropdown("ItemSelect", {
    Title = "Select item",
    Values = gearNames,
    Default = #gearNames > 0 and 1 or nil,
    Callback = function(v)
        selectedShopItem = v
    end
})

Tabs.Shop:AddButton({
    Title = "Buy selected item",
    Callback = function()
        if selectedShopItem ~= "None" and gearFolder then
            local item = gearFolder:FindFirstChild(selectedShopItem)
            local shopEvent = player.PlayerGui:FindFirstChild("shop") and player.PlayerGui.shop:FindFirstChild("RemoteEvent")
            if item and shopEvent then
                shopEvent:FireServer(item)
            end
        end
    end
})

Tabs.Settings:AddDropdown("InterfaceTheme", {
    Title = "Theme",
    Values = Fluent.Themes,
    Default = Fluent.Theme,
    Callback = function(theme)
        Fluent:SetTheme(theme)
    end
})

Tabs.Settings:AddToggle("TransparentToggle", {
    Title = "Transparency",
    Default = Fluent.Transparency,
    Callback = function(t)
        Fluent:ToggleTransparency(t)
    end
})

Window:SelectTab(1)
