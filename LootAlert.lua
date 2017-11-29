local _, LootAlert = ...

local L = LootAlert.L

local floor = floor
local format = format
local ItemData = _G.TSMAPI or {}

function LootAlert_OnLoad(self)
    self:RegisterEvent("LOOT_READY")
    self.lastTime = 0

    -- Set Default Settings
    LootAlert_RegisterDefaultSetting("alertTrigger", 200)
    LootAlert_RegisterDefaultSetting("MinQuality", 2)
    LootAlert_RegisterDefaultSetting("UMJSource", "recent")
    LootAlert_RegisterDefaultSetting("TSMSource", "DBMinBuyout")

    -- Set Panel Title Text
    LootAlertDisplayHeader:SetText(L.LootAlert)

    -- Create Panel & Set Controls
    self.name = L.LootAlert
    self.refresh = function(self)
        AlertValueSlider:SetValue(LootAlertDB.alertTrigger or 200)
        AlertQualitySlider:SetValue(LootAlertDB.MinQuality or 2)

        local currentSource = (self.TSM and LootAlertDB.TSMSource) or LootAlertDB.UMJSource
        UIDropDownMenu_SetText(SourceDropdown, LootAlert_GetSourceText(currentSource))
    end
    InterfaceOptions_AddCategory(self)
end

function AlertValueSlider_OnLoad(self)
    local goldicon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.label = _G[name .. "Label"]
    self.label:SetText(L.MinAlertValueLabel)
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(0, 2000)
    self:SetValue(200)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText(self:GetValue()..goldicon)
    self.textLow:SetText(self.minValue..goldicon)
    self.textHigh:SetText(self.maxValue..goldicon)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(100)
end

function AlertQualitySlider_OnLoad(self)
    local name = self:GetName()
    self.type = CONTROLTYPE_SLIDER
    self.label = _G[name .. "Label"]
    self.label:SetText(L.MinAlertQualityLabel)
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(0, 4)
    self:SetValue(2)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText(LootAlert_GetLootQualityText(self:GetValue()))
    self.textLow:SetText("|cffA5A5A5"..ITEM_QUALITY0_DESC.."|r")
    self.textHigh:SetText("|cffC845FA"..ITEM_QUALITY4_DESC.."|r")
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(1)
end

local function Initialize(self, level)
    local sourceTable = (self.TSM and LootAlert.TSMSourceTable) or LootAlert.UMJSourceTable

	for index = 1, #sourceTable do
		local value = sourceTable[index]
		if (value.text) then
			value.index = index
			UIDropDownMenu_AddButton( value, level )
		end
	end
end

function SourceDropdown_OnLoad(self)
    self.type = CONTROLTYPE_DROPDOWN
    _G[self:GetName().."Title"]:SetText(self.TSM and L.TSMLabel or L.UMJLabel)

	UIDropDownMenu_SetWidth(self, 180)
    UIDropDownMenu_Initialize(self, Initialize, "DROPDOWN")
end

function LootAlert_OnEvent(self, event, ...)
    local itemValue = 0

    for i=1, GetNumLootItems() do
        local lootLink = GetLootSlotLink(i)
        local bindOnPickUp = LootAlert_IsSoulbound(i)

        if (lootLink) then

            -- Gets item loot quality, class, and sub class.
            local _, _, lootQuality, _, _, _, _, _, _, _, _, lootClass, lootSubClass = GetItemInfo(lootLink)

            if not lootQuality then lootQuality = 0 end

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