local ADDON, LootAlert = ...

local L = LootAlert.L
local tonumber = tonumber
local checkboxOn = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
local checkboxOff = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF

local TSM = IsAddOnLoaded("TradeskillMaster")
local UMJ = IsAddOnLoaded("TheUndermineJournal")

-- Set Default Options
C_Timer.After(.1, function()
    LootAlert:RegisterDefaultSetting("alertTrigger", 200)
    LootAlert:RegisterDefaultSetting("MinQuality", 2)
    LootAlert:RegisterDefaultSetting("UMJSource", "recent")
    LootAlert:RegisterDefaultSetting("TSMSource", "DBMinBuyout")
end)

local Options = CreateFrame("Frame", "LootAlertOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(ADDON, "Title")
Options.version = GetAddOnMetadata(ADDON, "Version")

InterfaceOptions_AddCategory(Options)

Options:Hide()
Options:SetScript("OnShow", function()

    local LeftSide = CreateFrame("Frame","LeftSide",Options)
    LeftSide:SetHeight(Options:GetHeight())
    LeftSide:SetWidth(Options:GetWidth()/2)
    LeftSide:SetPoint("TOPLEFT", Options, "TOPLEFT")

    local RightSide = CreateFrame("Frame","RightSide",Options)
    RightSide:SetHeight(Options:GetHeight())
    RightSide:SetWidth(Options:GetWidth()/2)
    RightSide:SetPoint("TOPRIGHT", Options, "TOPRIGHT")

    -- Left Side

    -- Minimum Alert Value Slider
    local MinValueLabel = Options:CreateFontString("MinValueLabel", "ARTWORK", "GameFontNormal")
    MinValueLabel:SetPoint("TOPLEFT", LeftSide, 16, -16)
    MinValueLabel:SetText(L.MinAlertValueLabel )

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
    MinValue.text:SetText(MinValue:GetValue().."|cffffd100G|r")
    MinValue:SetScript("OnValueChanged", function(self,event,arg1)
        MinValue.text:SetText(MinValue:GetValue().."|cffffd100G|r")
        LootAlertDB.alertTrigger = tonumber(MinValue:GetValue())
    end)

    -- Minimum Alert Quality Slider
    local MinQualityLabel = Options:CreateFontString("MinQualityLabel", "ARTWORK", "GameFontNormal")
    MinQualityLabel:SetPoint("TOPLEFT", MinValue, "BOTTOMLEFT", 0, -30)
    MinQualityLabel:SetText(L.MinAlertQualityLabel)

    local name2 = "MinQuality"
    local MinQuality = CreateFrame("Slider", name2, LeftSide, "OptionsSliderTemplate")
    MinQuality:SetPoint("TOPLEFT", MinQualityLabel, "BOTTOMLEFT", 0, -20)
    MinQuality.textLow = _G[name2.."Low"]
    MinQuality.textHigh = _G[name2.."High"]
    MinQuality.text = _G[name2.."Text"]
    MinQuality:SetMinMaxValues(0, 4)
    MinQuality.minValue, MinQuality.maxValue = MinQuality:GetMinMaxValues()
    MinQuality.textLow:SetText("|cffA5A5A5"..ITEM_QUALITY0_DESC.."|r")
    MinQuality.textHigh:SetText("|cffC845FA"..ITEM_QUALITY4_DESC.."|r")
    MinQuality:SetValue(LootAlertDB.MinQuality or 2)
    MinQuality:SetObeyStepOnDrag(true)
    MinQuality:SetValueStep(1)
    MinQuality.text:SetText(LootAlert:GetLootQualityText(MinQuality:GetValue()))
    MinQuality:SetScript("OnValueChanged", function(self,event,arg1)
        MinQuality.text:SetText(LootAlert:GetLootQualityText(MinQuality:GetValue()))
        LootAlertDB.MinQuality = tonumber(MinQuality:GetValue())
    end)

    -- Price Source Dropdown Menu
    if (IsAddOnLoaded("TheUndermineJournal") or IsAddOnLoaded("TradeskillMaster")) then
        local sourceTable = (TSM and LootAlert.TSMSourceTable) or LootAlert.UMJSourceTable
        local currentSource = (TSM and LootAlertDB.TSMSource) or LootAlertDB.UMJSource

        local SourceDropDownMenu = CreateFrame("Frame", "SourceDropDownMenu", LeftSide, "UIDropDownMenuTemplate")
        local SourceDropDownButton = CreateFrame("Button", "SourceDropDownButton", LeftSide , "UIDropDownMenuTemplate")
        SourceDropDownButton:SetPoint("TOP", MinQuality, "BOTTOM", 0, -45)
        SourceDropDownButton:SetPoint("LEFT", LeftSide, "LEFT", -5, 0)
        UIDropDownMenu_SetWidth(SourceDropDownButton, 180)
        UIDropDownMenu_SetText(SourceDropDownButton, LootAlert:GetSourceText(currentSource))

        SourceDropDownButtonButton:SetScript("OnClick", function(self, button, down)
            if ( not DropDownList1:IsVisible() ) then
                if button == "LeftButton" then
                    EasyMenu(sourceTable, SourceDropDownMenu, SourceDropDownButton, 10, 10, "DROPDOWN", 8)
                end
            else
                CloseDropDownMenus()
            end
        end)
        SourceDropDownButton:SetScript("OnClick", function(self, button, down)
            if ( not DropDownList1:IsVisible() ) then
                if button == "LeftButton" then
                    EasyMenu(sourceTable, SourceDropDownMenu, SourceDropDownButton, 10, 10, "DROPDOWN", 8)
                end
            else
                CloseDropDownMenus()
            end
        end)

        SourceDropDownButton.Headline = Options:CreateFontString("UMJHeadline", "ARTWORK", "GameFontNormal")
        SourceDropDownButton.Headline:SetPoint("BOTTOMLEFT", SourceDropDownButton, "TOPLEFT", 20, 5)
        SourceDropDownButton.Headline:SetText(TSM and L.TSMLabel or L.UMJLabel)
    end

    local AddonTitle = Options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
    AddonTitle:SetPoint("BOTTOMRIGHT", -16, 16)
    AddonTitle:SetText(Options.name.." "..Options.version)

    Options:SetScript("OnShow", nil)
end)
