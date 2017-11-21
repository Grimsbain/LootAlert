local ADDON, LootAlert = ...

local floor = math.floor
local format = format
local tonumber = tonumber

-- Formats money for output.
function coins(money, graphic)
    local GOLD="ffd100"
    local SILVER="e6e6e6"
    local COPPER="c8602c"

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


local tooltip = CreateFrame("GameTooltip", "LootAlertTooltip", nil, "GameTooltipTemplate")
function IsSoulbound(slot)
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

    -- Set Defaults

LootAlert.RegisterDefaultSetting = function(key,value)
    if ( LootAlertDB == nil ) then
        LootAlertDB = {}
    end
    if ( LootAlertDB[key] == nil ) then
        LootAlertDB[key] = value
    end
end