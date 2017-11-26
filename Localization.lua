local _, LootAlert = ...

local L = {}
LootAlert.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

------------------------------------------------------------------------
-- English
------------------------------------------------------------------------

-- Option Text
L.MinAlertValueLabel = "Minimum Alert Value"
L.MinAlertQualityLabel = "Minimum Alert Quality"
L.UMJLabel = "Undermine Journal Source"
L.TSMLabel = "Trade Skill Master Source"

-- Undermine Journal
L.UMJMarket = "Market"
L.UMJRecent = "Recent"
L.UMJGlobalMedia = "Regional Median"
L.UMJGlobalMean = "Regional Mean"

-- Trade Skill Master
L.TSMMinBuyout = "Min Buyout"
L.TSMMarket = "Market"
L.TSMHistorical = "Historical"
L.TSMRegionMinBuyout = "Region Min Buyout Avg"
L.TSMRegionMarket = "Region Market Avg"
L.TSMRegionHistorical = "Region Historical"
L.TSMRegionSale = "Region Sale Avg"
L.TSMGlobalMinBuyout = "Global Min Buyout Avg"
L.TSMGlobalMarket = "Global Market Avg"
L.TSMGlobalHistorical = "Global Historical"
L.TSMGlobalSale = "Global Sale Avg"

local CURRENT_LOCALE = GetLocale()
if CURRENT_LOCALE == "enUS" then return end

------------------------------------------------------------------------
-- German
------------------------------------------------------------------------

if CURRENT_LOCALE == "deDE" then

return end

------------------------------------------------------------------------
-- Spanish
------------------------------------------------------------------------

if CURRENT_LOCALE == "esES" then

return end

------------------------------------------------------------------------
-- Latin American Spanish
------------------------------------------------------------------------

if CURRENT_LOCALE == "esMX" then

return end

------------------------------------------------------------------------
-- French
------------------------------------------------------------------------

if CURRENT_LOCALE == "frFR" then

return end

------------------------------------------------------------------------
-- Italian
------------------------------------------------------------------------

if CURRENT_LOCALE == "itIT" then

return end

------------------------------------------------------------------------
-- Brazilian Portuguese
------------------------------------------------------------------------

if CURRENT_LOCALE == "ptBR" then

return end

------------------------------------------------------------------------
-- Russian
------------------------------------------------------------------------

if CURRENT_LOCALE == "ruRU" then

return end

------------------------------------------------------------------------
-- Korean
------------------------------------------------------------------------

if CURRENT_LOCALE == "koKR" then

return end

------------------------------------------------------------------------
-- Simplified Chinese
------------------------------------------------------------------------

if CURRENT_LOCALE == "zhCN" then

return end

------------------------------------------------------------------------
-- Traditional Chinese
------------------------------------------------------------------------

if CURRENT_LOCALE == "zhTW" then

return end
