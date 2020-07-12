/datum/bounty/item/bot/cleanbot
	name = "Cleanbot"
	description = "There has been a incident out our crusher which resulted in the tragic death of multiple cleanbots. Ship a few replacements."
	reward_low = 27
	reward_high = 37
	required_count = 3
	wanted_types = list(/mob/living/bot/cleanbot)

/datum/bounty/item/bot/secbot
	name = "Secbot"
	description = "To revitalise the residential zones on the %DOCKSHORT, management has decided to increase the security presence. Ship us a few security bots."
	reward_low = 40
	reward_high = 45
	required_count = 2
	wanted_types = list(/mob/living/bot/secbot)

/datum/bounty/item/bot/ed209
	name = "ED 209"
	description = "To increase the security presence at our checkpoints we need a couple of ED209s."
	reward_low = 85
	reward_high = 95
	required_count = 2
	wanted_types = list(/mob/living/bot/secbot/ed209)

/datum/bounty/item/bot/farmbot
	name = "Farmbot"
	description = "After a k'ois incident multiple botanists are hospitalized. Provide a few farmbots to handle their duties while they recover."
	reward_low = 37
	reward_high = 43
	required_count = 3
	random_count = 1
	wanted_types = list(/mob/living/bot/farmbot)

/datum/bounty/item/bot/floorbot
	name = "Floorbot"
	description = "We need a few floorbots to assist our engineers in expanding some offices."
	reward_low = 40
	reward_high = 45
	required_count = 4
	random_count = 1
	wanted_types = list(/mob/living/bot/floorbot)
	
/datum/bounty/item/bot/medbot
	name = "Medbot"
	description = "We were unable to recruit a sufficient number of qualified medical professionals this month. Ship us a few medbots to fill the void."
	reward_low = 55
	reward_high = 60
	required_count = 2
	wanted_types = list(/mob/living/bot/medbot)

