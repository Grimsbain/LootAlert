local ADDON, LootAlert = ...
local select = select
local floor = floor

-- Defaults to TSM price source if loaded.
local TSM = IsAddOnLoaded("TradeskillMaster");
local UMJ = IsAddOnLoaded("TheUndermineJournal");
local ATOR = IsAddOnLoaded("Auctionator");
if (TSM or UMJ or not ATOR) then return end

local alertTrigger = LootAlert.alertTrigger;
local minQuality = LootAlert.minQuality;
local pet = false;

local function onEvent(self, event)

    for i=1, GetNumLootItems() do
        local lootLink = GetLootSlotLink(i);
        local bindOnPickUp = IsSoulbound(i);

        if (lootLink ~= nil) then

            -- Gets the quality (common,uncommon,rare,epic...) of the item or defaults to zero if the value comes back nil.
            local lootQuality = select(3,GetItemInfo(lootLink)) or 0;
            -- Class check for companion pets.
            local lootClass = select(12,GetItemInfo(lootLink)) or 0;
            local lootSubClass = select(13,GetItemInfo(lootLink)) or 0;

            -- Checks if the item is a pet or mount.
            if (lootClass == 15 and (lootSubClass == 2 or lootSubClass == 5)) then
                local str = lootLink
                RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"]);
                print(str);

            -- Checks item a BoE and quality vs set min quality.
            elseif (not bindOnPickUp and lootQuality >= minQuality) then

                -- Get Item Value from Auctionator
                local itemValue = Atr_GetAuctionBuyout(lootLink);

                -- Checks to see if value returned is nil or zero.
                if (itemValue ~= nil and itemValue ~= 0) then
                    -- Formats gold output using coins function.
                    local formatedCoins = coins(itemValue,true);
                    local valueInGold = floor(itemValue/10000);

                    -- If item value is worth over alertTrigger it will display a raid warning and a message in chat.
                    if (valueInGold >= alertTrigger) then
                        local str = lootLink .. " - " .. formatedCoins;

                        RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"]);
                        print(str);
                    end
                end
            end
        end
    end
end

--Runs when a loot window is opened.
local addon = CreateFrame('Frame')
addon:RegisterEvent('LOOT_READY')
addon:SetScript('OnEvent', onEvent)