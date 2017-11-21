local ADDON, LootAlert = ...
local select = select
local floor = floor

-- Defaults to TSM price source if loaded.
local TSM = IsAddOnLoaded("TradeskillMaster");
local UMJ = IsAddOnLoaded("TheUndermineJournal");
if (TSM or not UMJ) then return end

local item = {}

local function onEvent(self, event)
    if (event == "LOOT_READY") then
        for i=1, GetNumLootItems() do
            local lootLink = GetLootSlotLink(i);
            local bindOnPickUp = IsSoulbound(i);

            if (lootLink ~= nil) then

                -- Gets item loot quality, class, and sub class.
                local _, _, lootQuality, _, _, _, _, _, _, _, _, lootClass, lootSubClass = GetItemInfo(lootLink);

                if not lootQuality then
                    lootQuality = 0;
                end

                -- Checks if the item is a pet or mount.
                if (lootClass == 15 and (lootSubClass == 2 or lootSubClass == 5)) then
                    local str = lootLink;
                    RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"]);
                    print(str);

                -- Checks if item is BoE and compares item quality to the set minimum quality.
                elseif (not bindOnPickUp and lootQuality >= LootAlertDB.MinQuality) then

                    -- Get Item Value from UMJ
                    TUJMarketInfo(lootLink,item);
                    local itemValue = item[LootAlertDB.UMJSource];

                    -- Checks to see if value returned is nil or zero.
                    if (itemValue ~= nil and itemValue ~= 0) then
                        -- Formats gold output using coins function.
                        local formatedCoins = coins(itemValue,true);
                        local valueInGold = floor(itemValue/10000);

                        -- If item value is worth over alertTrigger it will display a raid warning and a message in chat.
                        if (valueInGold >= LootAlertDB.alertTrigger) then
                            local str = lootLink .. "|cffFFFFFF : " .. formatedCoins .."|r";
                            RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"]);
                            print(str);
                        end
                    end
                end
            end
        end
    end
end

-- Runs when a loot window is opened.
local addon = CreateFrame('Frame')
addon:RegisterEvent('LOOT_READY')
addon:SetScript('OnEvent', onEvent)