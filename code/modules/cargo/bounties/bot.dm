/datum/bounty/item/bot/mark_high_priority(scale_reward)
	return ..(max(scale_reward * 0.7, 1.2))

/datum/bounty/item/bot/cleanbot
	name = "Cleanbot"
	description = "There has been a incident out our crusher which resulted in the death of multiple janitors. Ship a replacement."
	reward = 2000
	required_count = 3
	wanted_types = list(/mob/living/bot/cleanbot)

/datum/bounty/item/bot/secbot
	name = "Secbot"
	description = "To revitalise the residential zones on the Odin management has decided to increase the security presence. Ship us a few security bots."
	reward = 2500
	required_count = 2
	wanted_types = list(/mob/living/bot/secbot)

/datum/bounty/item/bot/ed209
	name = "ED 209"
	description = "To increase the security presence at our checkpoints we need a couple of ED209s."
	reward = 5000
	required_count = 2
	wanted_types = list(/mob/living/bot/secbot/ed209)

/datum/bounty/item/bot/farmbot
	name = "Farmbot"
	description = "After a k'ois incident multiple botanists are hospitalized. Provide a farmbot to replace them."
	reward = 2000
	required_count = 3
	wanted_types = list(/mob/living/bot/farmbot)

/datum/bounty/item/bot/floorbot
	name = "Floorbot"
	description = "We need a few floorbots to assist our engineers in expanding a managers office."
	reward = 5000
	required_count = 4
	wanted_types = list(/mob/living/bot/floorbot)
	
/datum/bounty/item/bot/medbot
	name = "Medbot"
	description = "We were unable to recruit a sufficient number of qualified medical professionals this month. Ship us a few medbots to fill the void."
	reward = 4000
	required_count = 2
	wanted_types = list(/mob/living/bot/medbot)

