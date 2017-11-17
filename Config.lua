local ADDON, LootAlert = ...

-- // Minimum gold threshold. 200 Default
LootAlert.alertTrigger = 200;

-- // Minimum Item Quality Level, 0 = Poor, 1 = Common, 2 = Uncommon (Default), 3 = Rare, 4 = Epic, 5 = Legendary
LootAlert.minQuality = 2;

-- // Sources
-- // Undermine Journal Sources: globalMedian, globalMean, globalStdDev, market, stddev, recent.
-- // Tradeskill Master Sources: DBMinBuyout, DBMarket, DBHistorical, DBRegionMinBuyoutAvg, DBRegionMarketAvg,
-- // DBRegionHistorical, DBRegionSaleAvg, DBGlobalMinBuyoutAvg, DBGlobalMarketAvg, DBGlobalHistorical, DBGlobalSaleAvg

LootAlert.umjSource = "recent"
LootAlert.tsmSource = "DBMinBuyout"