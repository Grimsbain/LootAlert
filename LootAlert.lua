local ADDON, LootAlert = ...
local select = select
local floor = floor

local TSM = IsAddOnLoaded("TradeskillMaster")
local UMJ = IsAddOnLoaded("TheUndermineJournal")
local ATOR = IsAddOnLoaded("Auctionator")

-- Requires at least one of the above to run.
if not TSM and not UMJ and not ATOR then return end

if TSM then local TSMAPI = _G.TSMAPI end
local item = {}
local itemValue = 0
local lasttime = 0

local function onEvent(self, event)
    if (event == "LOOT_READY") then
        if time() == lasttime then return end

        for i=1, GetNumLootItems() do
            local lootLink = GetLootSlotLink(i)
            local bindOnPickUp = LootAlert:IsSoulbound(i)

            if (lootLink ~= nil) then

                -- Gets item loot quality, class, and sub class.
                local _, _, lootQuality, _, _, _, _, _, _, _, _, lootClass, lootSubClass = GetItemInfo(lootLink)

                if not lootQuality then
                    lootQuality = 0
                end

                -- Checks if the item is a pet or mount.
                if (lootClass == 15 and (lootSubClass == 2 or lootSubClass == 5)) then
                    local str = lootLink
                    RaidNotice_AddMessage(RaidWarningFrame, str, ChatTypeInfo["RAID_WARNING"])
                    print(str)

                -- Checks if item is BoE and compares item quality to the set minimum quality.
                elseif (not bindOnPickUp and lootQuality >= LootAlertDB.MinQuality) then

                    -- Get Item Value
                    if TSM then
                        itemValue = TSMAPI:GetItemValue(lootLink,LootAlertDB.TSMSource) or 0
                    elseif UMJ then
                        TUJMarketInfo(lootLink,item)
                        itemValue = item[LootAlertDB.UMJSource] or 0
                    else
                        itemValue = Atr_GetAuctionBuyout(lootLink) or 0
                    end

                    -- Checks to see if value returned is nil or zero.
                    if (itemValue ~= nil and itemValue ~= 0) then
                        -- Formats gold output using coins function.
                        local formatedCoins = LootAlert:Coins(itemValue,true)
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

        lasttime = time()
    end
end

-- Runs when a loot window is opened.
local watcher = CreateFrame('Frame')
watcher:RegisterEvent('LOOT_READY')
watcher:SetScript('OnEvent', onEvent)