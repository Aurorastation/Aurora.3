/datum/bounty/item/security/headset
	name = "Security Headset"
	description = "%COMPNAME wants to ensure that their encryption is working correctly. Ship them a security headset so that they can check."
	reward = 150
	wanted_types = list(/obj/item/device/radio/headset/headset_sec , /obj/item/device/radio/headset/heads/hos)

/datum/bounty/item/security/securitybelt
	name = "Security Belt"
	description = "%BOSSSHORT is having difficulties with their security belts. Ship one from the station to receive compensation."
	reward = 150
	wanted_types = list(/obj/item/weapon/storage/belt/security)

/datum/bounty/item/security/sechuds
	name = "Security HUDSunglasses"
	description = "%BOSSSHORT screwed up and ordered the wrong type of security sunglasses. They request the station ship some of theirs."
	reward = 150
	wanted_types = list(/obj/item/clothing/glasses/sunglasses/sechud)

/datum/bounty/item/security/pinpointer
	name = "Pinpointer"
	description = "Someone is needing to locate a high value item. Please send a spare pinpointer to help out."
	reward = 500
	wanted_types = list(/obj/item/weapon/pinpointer)

/datum/bounty/item/security/forcegloves
	name = "Force Gloves"
	description = "%BOSSNAME is performing a demonstration on applied bluespace technology. Ship a pair of forcegloves for use in this."
	reward = 1250
	wanted_types = list(/obj/item/clothing/gloves/force)

/datum/bounty/item/security/recharger
	name = "Rechargers"
	description = "%COMPNAME military academy is conducting marksmanship exercises. They request that rechargers be shipped."
	reward = 600
	required_count = 3
	wanted_types = list(/obj/machinery/recharger)

