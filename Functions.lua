local ADDON, LootAlert = ...
local L = LootAlert.L

local floor = math.floor
local format = format
local tonumber = tonumber

-- Formats money for output.
function LootAlert:Coins(money, graphic)
    local GOLD = "ffd100"
    local SILVER = "e6e6e6"
    local COPPER = "c8602c"

    local GSC_3 = "|cff%s%d|cff000000.|cff%s%02d|cff000000.|cff%s%02d|r"
    local GSC_2 = "|cff%s%d|cff000000.|cff%s%02d|r"
    local GSC_1 = "|cff%s%d|r"

    local iconpath = "Interface\\MoneyFrame\\UI-"
    local goldicon = "%d|T"..iconpath.."GoldIcon:0|t"
    local silvericon = "%s|T"..iconpath.."SilverIcon:0|t"
    local coppericon = "%s|T"..iconpath.."CopperIcon:0|t"

    money = floor(tonumber(money) or 0)
    local g = floor(money / 10000)
    local s = floor(money % 10000 / 100)
    local c = money % 100

    if not graphic then
        if g > 0 then
            if (c > 0) then
                return GSC_3:format(GOLD, g, SILVER, s, COPPER, c)
            else
                return GSC_2:format(GOLD, g, SILVER, s)
            end
        elseif s > 0 then
            if (c > 0) then
                return GSC_2:format(SILVER, s, COPPER, c)
            else
                return GSC_1:format(SILVER, s)
            end
        else
            return GSC_1:format(COPPER, c)
        end
    else
        if g > 0 then
            if (c > 0) then
                return goldicon:format(g)..silvericon:format("%02d"):format(s)..coppericon:format("%02d"):format(c)
            else
                return goldicon:format(g)..silvericon:format("%02d"):format(s)
            end
        elseif s > 0  then
            if (c > 0) then
                return silvericon:format("%d"):format(s)..coppericon:format("%02d"):format(c)
            else
                return silvericon:format("%d"):format(s)
            end
        else
            return coppericon:format("%d"):format(c)
        end
    end
end

-- Soulbound Function
local tooltip = CreateFrame("GameTooltip", "LootAlertTooltip", nil, "GameTooltipTemplate")
function LootAlert:IsSoulbound(slot)
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetLootItem(slot)
    tooltip:Show()
    for i = 1,tooltip:NumLines() do
        if(_G["LootAlertTooltipTextLeft"..i]:GetText() == ITEM_SOULBOUND) then
            return true
        end
    end
    tooltip:Hide()
    return false
end

-- Register Default Settings
function LootAlert:RegisterDefaultSetting(key,value)
    if ( LootAlertDB == nil ) then
        LootAlertDB = {}
    end
    if ( LootAlertDB[key] == nil ) then
        LootAlertDB[key] = value
    end
end

-- Item Quality Text with coloring.
function LootAlert:GetLootQualityText(value)
    if value == 0 then
        return "|cffA5A5A5"..ITEM_QUALITY0_DESC.."|r"
    elseif value == 1 then
        return "|cffFFFFFF"..ITEM_QUALITY1_DESC.."|r"
    elseif value == 2 then
        return "|cff15B300"..ITEM_QUALITY2_DESC.."|r"
    elseif value == 3 then
        return "|cff0091F2"..ITEM_QUALITY3_DESC.."|r"
    elseif value == 4 then
        return "|cffC845FA"..ITEM_QUALITY4_DESC.."|r"
    end
end

-- Get Source Text
function LootAlert:GetSourceText(value)
    -- UMJ
    if (value == "market") then
        return L.UMJMarket
    elseif (value == "recent") then
        return L.UMJRecent
    elseif (value == "globalMedian") then
        return L.UMJGlobalMedia
    elseif (value == "globalMean") then
        return L.UMJGlobalMean
    -- TSM
    elseif (value == "DBMinBuyout") then
        return L.TSMMinBuyout
    elseif (value == "DBMarket") then
        return L.TSMMarket
    elseif (value == "DBHistorical") then
        return L.TSMHistorical
    elseif (value == "DBRegionMinBuyoutAvg") then
        return L.TSMRegionMinBuyout
    elseif (value == "DBRegionMarketAvg") then
        return L.TSMRegionMarket
    elseif (value == "DBRegionHistorical") then
        return L.TSMRegionHistorical
    elseif (value == "DBRegionSaleAvg") then
        return L.TSMRegionSale
    elseif (value == "DBGlobalMinBuyoutAvg") then
        return L.TSMGlobalMinBuyout
    elseif (value == "DBGlobalMarketAvg") then
        return L.TSMGlobalMarket
    elseif (value == "DBGlobalHistorical") then
        return L.TSMGlobalHistorical
    elseif (value == "DBGlobalSaleAvg") then
        return L.TSMGlobalSale
    end
end