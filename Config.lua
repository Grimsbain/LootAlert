local ADDON, LootAlert = ...

-- local L = LootAlert.L
local _G = getfenv(0)
local GetCVar = _G.GetCVar
local SetCVar = _G.SetCVar
local format = _G.string.format
local tonumber = _G.tonumber
local checkboxOn = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
local checkboxOff = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF

-- Set Default Options
C_Timer.After(.1, function()
    LootAlert.RegisterDefaultSetting("alertTrigger", 200)
    LootAlert.RegisterDefaultSetting("MinQuality", 2)
    LootAlert.RegisterDefaultSetting("UMJSource", "recent")
    LootAlert.RegisterDefaultSetting("TSMSource", "DBMinBuyout")
end)

local function GetLootQualityText(value)
    if value == 0 then
        return "|cffA5A5A5Poor|r"
    elseif value == 1 then
        return "|cffFFFFFFCommon|r"
    elseif value == 2 then
        return "|cff15B300Uncommon|r"
    elseif value == 3 then
        return "|cff0091F2Rare|r"
    elseif value == 4 then
        return "|cffC845FAEpic|r"
    end
end

local Options = CreateFrame("Frame", "LootAlertOptions", InterfaceOptionsFramePanelContainer)

Options.name = GetAddOnMetadata(ADDON, "Title")
Options.version = GetAddOnMetadata(ADDON, "Version")

InterfaceOptions_AddCategory(Options)

Options:Hide()
Options:SetScript("OnShow", function()

    local LeftSide = CreateFrame("Frame","LeftSide",Options)
    LeftSide:SetHeight(Options:GetHeight())
    LeftSide:SetWidth(Options:GetWidth()/2)
    LeftSide:SetPoint("TOPLEFT",Options,"TOPLEFT")

    local RightSide = CreateFrame("Frame","RightSide",Options)
    RightSide:SetHeight(Options:GetHeight())
    RightSide:SetWidth(Options:GetWidth()/2)
    RightSide:SetPoint("TOPRIGHT",Options,"TOPRIGHT")

    -- Left Side --

    local BasicOptions = Options:CreateFontString("BasicOptions", "ARTWORK", "GameFontNormalLarge")
    BasicOptions:SetPoint("TOPLEFT", LeftSide, 16, -16)
    BasicOptions:SetText(Options.name.." "..GAMEOPTIONS_MENU)

    local MinValueLabel = Options:CreateFontString("MinValueLabel", "ARTWORK", "GameFontNormal")
    MinValueLabel:SetPoint("TOPLEFT", BasicOptions, "BOTTOMLEFT", 0, -30)
    MinValueLabel:SetText("Minimum Alert Value")

    local name = "MinValue"
    local MinValue = CreateFrame("Slider", name, LeftSide, "OptionsSliderTemplate")
    MinValue:SetPoint("TOPLEFT", MinValueLabel, "BOTTOMLEFT", 0, -20)
    MinValue.textLow = _G[name.."Low"]
    MinValue.textHigh = _G[name.."High"]
    MinValue.text = _G[name.."Text"]
    MinValue:SetMinMaxValues(0, 5000)
    MinValue.minValue, MinValue.maxValue = MinValue:GetMinMaxValues()
    MinValue.textLow:SetText(MinValue.minValue.."|cffffd100G|r")
    MinValue.textHigh:SetText(MinValue.maxValue.."|cffffd100G|r")
    MinValue:SetValue(LootAlertDB.alertTrigger or 200)
    MinValue:SetObeyStepOnDrag(true)
    MinValue:SetValueStep(100)
    MinValue.text:SetText(format("%.0f",MinValue:GetValue()).."|cffffd100G|r")
    MinValue:SetScript("OnValueChanged", function(self,event,arg1)
        MinValue.text:SetText(format("%.0f",MinValue:GetValue()).."|cffffd100G|r")
        LootAlertDB.alertTrigger = tonumber(format("%.0f",MinValue:GetValue()))
    end)

    local MinQualityLabel = Options:CreateFontString("MinQualityLabel", "ARTWORK", "GameFontNormal")
    MinQualityLabel:SetPoint("TOPLEFT", MinValue, "BOTTOMLEFT", 0, -30)
    MinQualityLabel:SetText("Minimum Alert Quality")

    local name2 = "MinQuality"
    local MinQuality = CreateFrame("Slider", name2, LeftSide, "OptionsSliderTemplate")
    MinQuality:SetPoint("TOPLEFT", MinQualityLabel, "BOTTOMLEFT", 0, -20)
    MinQuality.textLow = _G[name2.."Low"]
    MinQuality.textHigh = _G[name2.."High"]
    MinQuality.text = _G[name2.."Text"]
    MinQuality:SetMinMaxValues(0, 4)
    MinQuality.minValue, MinQuality.maxValue = MinQuality:GetMinMaxValues()
    MinQuality.textLow:SetText("|cffA5A5A5Poor|r")
    MinQuality.textHigh:SetText("|cffC845FAEpic|r")
    MinQuality:SetValue(LootAlertDB.MinQuality or 2)
    MinQuality:SetObeyStepOnDrag(true)
    MinQuality:SetValueStep(1)
    MinQuality.text:SetText(GetLootQualityText(MinQuality:GetValue()))
    MinQuality:SetScript("OnValueChanged", function(self,event,arg1)
        MinQuality.text:SetText(GetLootQualityText(MinQuality:GetValue()))
        LootAlertDB.MinQuality = tonumber(format("%.0f",MinQuality:GetValue()))
    end)

    -- // Undermin Journal Source Dropdown
    if (IsAddOnLoaded("TheUndermineJournal") and not IsAddOnLoaded("TradeskillMaster")) then

    local UMJLabel = Options:CreateFontString("UMJLabel", "ARTWORK", "GameFontNormal")
    UMJLabel:SetPoint("TOPLEFT", MinQuality, "BOTTOMLEFT", 0, -30)
    UMJLabel:SetText("Undermine Journal Source")

        local buttonText, currentSource = "", LootAlertDB.UMJSource

        if (currentSource == "market") then
            buttonText = "Market";
        elseif (currentSource == "recent") then
            buttonText = "Recent";
        elseif (currentSource == "globalMedian") then
            buttonText = "Global Median";
        elseif (currentSource == "globalMean") then
            buttonText = "Global Mean";
        end

        local UMJDropDownMenu = CreateFrame("Frame", "UMJDropDownMenu", LeftSide, "UIDropDownMenuTemplate")
        local UMJDropDownButton = CreateFrame("Button", "UMJDropDownButton", LeftSide , "UIPanelButtonTemplate")
        local UMJSourceTable = {
            {
                text = "Market Price",
                func = function()
                    LootAlertDB.UMJSource = "market"
                    UMJDropDownButton:SetText("Market Price")
                end,
                checked = function()
                    if LootAlertDB.UMJSource == "market" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Recent",
                func = function()
                    LootAlertDB.UMJSource = "recent"
                    UMJDropDownButton:SetText("Recent")
                end,
                checked = function()
                    if LootAlertDB.UMJSource == "recent" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Global Median",
                func = function()
                    LootAlertDB.UMJSource = "globalMedian"
                    UMJDropDownButton:SetText("Global Median")
                end,
                checked = function()
                    if LootAlertDB.UMJSource == "globalMedian" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Global Mean",
                func = function()
                    LootAlertDB.UMJSource = "globalMean"
                    UMJDropDownButton:SetText("Global Mean")
                end,
                checked = function()
                    if LootAlertDB.UMJSource == "globalMean" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = CLOSE,
                func = function() CloseDropDownMenus() end,
                notCheckable = 1,
            },
        }

        UMJDropDownButton:SetPoint("TOPLEFT", UMJLabel, "BOTTOMLEFT", 0, -10)
        UMJDropDownButton:SetSize(150,25)
        UMJDropDownButton:SetText(buttonText)
        UMJDropDownButton:SetScript("OnClick", function(self, button, down)
            if ( not DropDownList1:IsVisible() ) then
                if button == "LeftButton" then
                    EasyMenu(UMJSourceTable,UMJDropDownMenu, self:GetName(), 0, 0, "DROPDOWN", 5)
                end
            else
                CloseDropDownMenus()
            end
        end)
        UMJDropDownButton:RegisterForClicks("LeftButtonUp")
    end

    -- // TradeSkillMaster Source Dropdown
    if (IsAddOnLoaded("TradeskillMaster")) then

    local TSMLabel = Options:CreateFontString("TSMLabel", "ARTWORK", "GameFontNormal")
    TSMLabel:SetPoint("TOPLEFT", MinQuality, "BOTTOMLEFT", 0, -30)
    TSMLabel:SetText("TradeSkillMaster Source")

        local buttonText, currentSource = "", LootAlertDB.TSMSource

        if (currentSource == "DBMinBuyout") then
            buttonText = "Min Buyout";
        elseif (currentSource == "DBMarket") then
            buttonText = "Market";
        elseif (currentSource == "DBHistorical") then
            buttonText = "Historical";
        elseif (currentSource == "DBRegionMinBuyoutAvg") then
            buttonText = "Region Min Buyout Avg";
        elseif (currentSource == "DBRegionMarketAvg") then
            buttonText = "Region Market Avg";
        elseif (currentSource == "DBRegionHistorical") then
            buttonText = "Region Historical";
        elseif (currentSource == "DBRegionSaleAvg") then
            buttonText = "Region Sale Avg";
        elseif (currentSource == "DBGlobalMinBuyoutAvg") then
            buttonText = "Global Min Buyout Avg";
        elseif (currentSource == "DBGlobalMarketAvg") then
            buttonText = "Global Market Avg";
        elseif (currentSource == "DBGlobalHistorical") then
            buttonText = "Global Historical";
        elseif (currentSource == "DBGlobalSaleAvg") then
            buttonText = "Global Sale Avg";
        end

        local TSMDropDownMenu = CreateFrame("Frame", "TSMDropDownMenu", LeftSide, "UIDropDownMenuTemplate")
        local TSMDropDownButton = CreateFrame("Button", "TSMDropDownButton", LeftSide , "UIPanelButtonTemplate")
        local TSMSourceTable = {
            {
                text = "Min Buyout",
                func = function()
                    LootAlertDB.TSMSource = "DBMinBuyout"
                    TSMDropDownButton:SetText("Min Buyout")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBMinBuyout" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Market",
                func = function()
                    LootAlertDB.TSMSource = "DBMarket"
                    TSMDropDownButton:SetText("Market")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBMarket" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Historical",
                func = function()
                    LootAlertDB.TSMSource = "DBHistorical"
                    TSMDropDownButton:SetText("Historical")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBHistorical" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Region Min Buyout Avg",
                func = function()
                    LootAlertDB.TSMSource = "DBRegionMinBuyoutAvg"
                    TSMDropDownButton:SetText("Region Min Buyout Avg")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBRegionMinBuyoutAvg" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Region Market Avg",
                func = function()
                    LootAlertDB.TSMSource = "DBRegionMarketAvg"
                    TSMDropDownButton:SetText("Region Market Avg")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBRegionMarketAvg" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Region Historical",
                func = function()
                    LootAlertDB.TSMSource = "DBRegionHistorical"
                    TSMDropDownButton:SetText("Region Historical")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBRegionHistorical" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Region Sale Avg",
                func = function()
                    LootAlertDB.TSMSource = "DBRegionSaleAvg"
                    TSMDropDownButton:SetText("Region Sale Avg")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBRegionSaleAvg" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Global Min Buyout Avg",
                func = function()
                    LootAlertDB.TSMSource = "DBGlobalMinBuyoutAvg"
                    TSMDropDownButton:SetText("Global Min Buyout Avg")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBGlobalMinBuyoutAvg" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Global Market Avg",
                func = function()
                    LootAlertDB.TSMSource = "DBGlobalMarketAvg"
                    TSMDropDownButton:SetText("Global Market Avg")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBGlobalMarketAvg" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Global Historical",
                func = function()
                    LootAlertDB.TSMSource = "DBGlobalHistorical"
                    TSMDropDownButton:SetText("Global Historical")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBGlobalHistorical" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = "Global Sale Avg",
                func = function()
                    LootAlertDB.TSMSource = "DBGlobalSaleAvg"
                    TSMDropDownButton:SetText("Global Sale Avg")
                end,
                checked = function()
                    if LootAlertDB.TSMSource == "DBGlobalSaleAvg" then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                text = CLOSE,
                func = function() CloseDropDownMenus() end,
                notCheckable = 1,
            },
        }

        TSMDropDownButton:SetPoint("TOPLEFT", TSMLabel, "BOTTOMLEFT", 0, -10)
        TSMDropDownButton:SetSize(150,25)
        TSMDropDownButton:SetText(buttonText)
        TSMDropDownButton:SetScript("OnClick", function(self, button, down)
            if ( not DropDownList1:IsVisible() ) then
                if button == "LeftButton" then
                    EasyMenu(TSMSourceTable,TSMDropDownMenu, self:GetName(), 0, 0, "DROPDOWN", 5)
                end
            else
                CloseDropDownMenus()
            end
        end)
        TSMDropDownButton:RegisterForClicks("LeftButtonUp")
    end

    function Options:Refresh()
        -- TankMode:SetChecked(LootAlertDB.TankMode)
    end

    Options:Refresh()
    Options:SetScript("OnShow", nil)
end)
