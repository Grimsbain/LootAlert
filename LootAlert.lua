local _, LootAlert = ...

local floor = floor
local ItemData = _G.TSMAPI or {}

function LootAlert_OnEvent(self, event, ...)
    local itemValue = 0

    for i=1, GetNumLootItems() do
        local lootLink = GetLootSlotLink(i)
        local bindOnPickUp = LootAlert_IsSoulbound(i)

        if (lootLink) then

            -- Gets item loot quality, class, and sub class.
            local _, _, lootQuality, _, _, _, _, _, _, _, _, lootClass, lootSubClass = GetItemInfo(lootLink) or _, _, 0, _, _, _, _, _, _, _, _, 0, 0

            -- Checks if the item is a pet or mount.
            if (lootClass == 15 and (lootSubClass == 2 or lootSubClass == 5)) then
                local str = lootLink
                RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"])
                print(str)

            -- Checks if item is BoE and compares item quality to the set minimum quality.
            elseif (not bindOnPickUp and lootQuality >= LootAlertDB.MinQuality) then

                -- Get Item Value
                if self.TSM then
                    itemValue = ItemData:GetItemValue(lootLink,LootAlertDB.TSMSource) or 0
                elseif self.UMJ then
                    TUJMarketInfo(lootLink,ItemData)
                    itemValue = ItemData[LootAlertDB.UMJSource] or 0
                else
                    itemValue = Atr_GetAuctionBuyout(lootLink) or 0
                end

                -- Checks to see if value returned is nil or zero.
                if (itemValue and itemValue ~= 0) then
                    -- Formats gold output using coins function.
                    local formatedCoins = LootAlert_Coins(itemValue)
                    local valueInGold = floor(itemValue/10000)

                    -- If item value is worth over alertTrigger it will display a raid warning and a message in chat.
                    if (valueInGold >= LootAlertDB.alertTrigger) then
                        local str = lootLink .. "|cffFFFFFF : " .. formatedCoins .."|r"
                        RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"])
                        print(str)
                    end
                end
            end
        end
    end
end