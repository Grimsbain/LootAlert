local ADDON, LootAlert = ...
local select = select
local floor = floor

-- Defaults to TSM price source if loaded.
local TSM = IsAddOnLoaded("TradeskillMaster");
local UMJ = IsAddOnLoaded("TheUndermineJournal");
if (TSM or not UMJ) then return end

local item = {}
local alertTrigger = LootAlert.alertTrigger;
local minQuality = LootAlert.minQuality;
local source = LootAlert.umjSource;

local function onEvent(self, event)

    for i=1, GetNumLootItems() do
        local lootLink = GetLootSlotLink(i);

        if (lootLink ~= nil) then

            -- Gets the quality (common,uncommon,rare,epic...) of the item or defaults to zero if the value comes back nil.
            local lootQuality = select(3,GetItemInfo(lootLink)) or 0
            local lootClass = select(12,GetItemInfo(lootLink)) or 0;
            local lootSubClass = select(13,GetItemInfo(lootLink)) or 0;

            -- Checks item quality vs set min quality.
            if (lootQuality >= minQuality or (lootClass == 15 and lootSubClass == 2)) then

                -- Get Item Value from UMJ
                TUJMarketInfo(lootLink,item)
                local itemValue = item[source]

                -- Checks to see if value returned is nil or zero.
                if (itemValue ~= nil and itemValue ~= 0) then
                    -- Formats gold output using coins function.
                    local formatedCoins = coins(itemValue,true)
                    local valueInGold = floor(itemValue/10000)

                    -- If item value is worth over 200g it will display a raid warning and a message in chat.
                    if (valueInGold >= alertTrigger) then
                        local str = lootLink .. " - " .. formatedCoins

                        RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"])
                        print(str)
                    end
                end
            end
        end
    end
end

--Runs when a loot window is opened.
local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', onEvent)
addon:RegisterEvent('LOOT_OPENED')