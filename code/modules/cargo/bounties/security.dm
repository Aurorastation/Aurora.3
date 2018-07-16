/datum/bounty/item/security/headset/New()
	..()
	name = "Security Headset"
	description = "[current_map.company_name] wants to ensure that their encryption is working correctly. Ship them a security headset so that they can check."
	reward = 800
	wanted_types = list(/obj/item/device/radio/headset/headset_sec , /obj/item/device/radio/headset/heads/hos)

/datum/bounty/item/security/securitybelt/New()
	..()
	name = "Security Belt"
	description = "[current_map.boss_short] is having difficulties with their security belts. Ship one from the station to receive compensation."
	reward = 800
	wanted_types = list(/obj/item/weapon/storage/belt/security)

/datum/bounty/item/security/sechuds/New()
	..()
	name = "Security HUDSunglasses"
	description = "[current_map.boss_short] screwed up and ordered the wrong type of security sunglasses. They request the station ship some of theirs."
	reward = 800
	wanted_types = list(/obj/item/clothing/glasses/sunglasses/sechud)

/datum/bounty/item/security/riotshotgun/New()
	..()
	name = "Riot Shotguns"
	description = "Tajara are protesting in the Civilian Sectors! Ship riot shotguns quickly, or things are going to get dirty."
	reward = 5000
	required_count = 2
	wanted_types = list(/obj/item/weapon/gun/projectile/shotgun/pump)

/datum/bounty/item/security/pinpointer/New()
	..()
	name = "Pinpointer"
	description = "Someone might or might not have misplaced a high-value item. Can the station spare a pinpointer to help out?"
	reward = 1500
	wanted_types = list(/obj/item/weapon/pinpointer)

/datum/bounty/item/security/captains_spare/New()
	..()
	name = "Captain's Spare"
	description = "Captain Bart of Station 12 has forgotten his ID! Ship him your station's spare, would you?"
	reward = 1500
	wanted_types = list(/obj/item/weapon/card/id/captains_spare)

/datum/bounty/item/security/hardsuit/New()
	..()
	name = "Security Hardsuit"
	description = "Pirates have engaged the NMV Icarus! Quick! Ship a security hardsuit to aid the fight!"
	reward = 2000
	wanted_types = list(/obj/item/clothing/suit/space/void/security)

/datum/bounty/item/security/forcegloves/New()
	..()
	name = "Force Gloves"
	description = "Captain Francis of Station 8 has been challenged to a sparring duel in the holodeck. Ship him a pair of forcegloves so there can be a fair fight."
	reward = 2000
	wanted_types = list(/obj/item/clothing/gloves/force)

/datum/bounty/item/security/recharger/New()
	..()
	name = "Rechargers"
	description = "[current_map.company_name] military academy is conducting marksmanship exercises. They request that rechargers be shipped."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/machinery/recharger)

/datum/bounty/item/security/sabre/New()
	..()
	name = "Telebaton"
	description = "Assistants are staging a \"peaceful protest\" on the Odin. Quickly ship a telebaton so we can ensure their swift return to work."
	reward = 2500
	wanted_types = list(/obj/item/weapon/melee/telebaton)

