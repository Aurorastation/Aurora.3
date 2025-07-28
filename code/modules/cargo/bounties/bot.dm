/datum/bounty/item/bot/cleanbot
	name = "Cleanbot"
	description = "There has been a incident out our crusher which resulted in the tragic death of multiple cleanbots. Ship a few replacements."
	reward_low = 270
	reward_high = 370
	required_count = 3
	wanted_types = list(/mob/living/bot/cleanbot)

/datum/bounty/item/bot/farmbot
	name = "Farmbot"
	description = "After a k'ois incident multiple botanists were hospitalized. Provide a few farmbots to handle their duties while they recover."
	reward_low = 370
	reward_high = 430
	required_count = 3
	random_count = 1
	wanted_types = list(/mob/living/bot/farmbot)

/datum/bounty/item/bot/medbot
	name = "Medibot"
	description = "We were unable to recruit a sufficient number of qualified medical professionals this month. Ship us a few medibots to fill the void."
	reward_low = 550
	reward_high = 600
	required_count = 2
	wanted_types = list(/mob/living/bot/medbot)
