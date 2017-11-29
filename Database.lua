local _, LootAlert = ...
local L = LootAlert.L

-- The Undermine Journal Sources
LootAlert.UMJSourceTable = {
    {
        text = L.UMJMarket,
        func = function()
            LootAlertDB.UMJSource = "market"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.UMJSource == "market" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.UMJRecent,
        func = function()
            LootAlertDB.UMJSource = "recent"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.UMJSource == "recent" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.UMJGlobalMedia,
        func = function()
            LootAlertDB.UMJSource = "globalMedian"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.UMJSource == "globalMedian" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.UMJGlobalMean,
        func = function()
            LootAlertDB.UMJSource = "globalMean"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.UMJSource == "globalMean" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = CLOSE,
        func = function() CloseDropDownMenus() end,
        notCheckable = 1,
    },
}

-- TradeSkillMaster Sources
LootAlert.TSMSourceTable = {
    {
        text = L.TSMMinBuyout,
        func = function()
            LootAlertDB.TSMSource = "DBMinBuyout"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBMinBuyout" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMMarket,
        func = function()
            LootAlertDB.TSMSource = "DBMarket"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBMarket" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMHistorical,
        func = function()
            LootAlertDB.TSMSource = "DBHistorical"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBHistorical" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMRegionMinBuyout,
        func = function()
            LootAlertDB.TSMSource = "DBRegionMinBuyoutAvg"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBRegionMinBuyoutAvg" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMRegionMarket,
        func = function()
            LootAlertDB.TSMSource = "DBRegionMarketAvg"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBRegionMarketAvg" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMRegionHistorical,
        func = function()
            LootAlertDB.TSMSource = "DBRegionHistorical"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBRegionHistorical" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMRegionSale,
        func = function()
            LootAlertDB.TSMSource = "DBRegionSaleAvg"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBRegionSaleAvg" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMGlobalMinBuyout,
        func = function()
            LootAlertDB.TSMSource = "DBGlobalMinBuyoutAvg"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBGlobalMinBuyoutAvg" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMGlobalMarket,
        func = function()
            LootAlertDB.TSMSource = "DBGlobalMarketAvg"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBGlobalMarketAvg" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMGlobalHistorical,
        func = function()
            LootAlertDB.TSMSource = "DBGlobalHistorical"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBGlobalHistorical" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = L.TSMGlobalSale,
        func = function()
            LootAlertDB.TSMSource = "DBGlobalSaleAvg"
            UIDropDownMenu_SetSelectedValue(SourceDropdown, SourceDropdown:GetID())
        end,
        checked = function()
            if LootAlertDB and LootAlertDB.TSMSource == "DBGlobalSaleAvg" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = CLOSE,
        func = function() CloseDropDownMenus() end,
        notCheckable = 1,
    },
}
