/datum/bounty/item/security/headset
	name = "Security Headset"
	description = "%COMPNAME wants to ensure that their encryption is working correctly. Ship them a security headset from your station so that they can check if it can't access their security channel."
	reward = 800
	wanted_types = list(/obj/item/device/radio/headset/headset_sec , /obj/item/device/radio/headset/heads/hos)

/datum/bounty/item/security/sechuds
	name = "Security HUDSunglasses"
	description = "%BOSSSHORT screwed up and ordered the wrong type of security sunglasses. They request the station ship some of theirs. We'll send you the ones we accidentally ordered."
	reward = 0
	reward_id = "sunglasses"
	wanted_types = list(/obj/item/clothing/glasses/sunglasses/sechud)

/datum/bounty/item/security/riotshotgun
	name = "Pump Shotguns"
	description = "%BOSSSHORT wishes to swap some of your pump shotguns as part of a weapons upgrading program. Send us 2 outdated pump shotguns and we'll send you some better ones."
	reward = 0
	required_count = 2
	reward_id = "shotguns"
	wanted_types = list(/obj/item/weapon/gun/projectile/shotgun/pump)

/datum/bounty/item/security/pinpointer
	name = "Pinpointer"
	description = "Someone might or might not have misplaced a high-value item. Can your station spare a pinpointer to help out? We'll let you borrow some other high value items that recovered in return."
	reward = 0
	reward_id = "high_value"
	wanted_types = list(/obj/item/weapon/pinpointer)

/datum/bounty/item/security/captains_spare
	name = "Captain's Spare"
	description = "%BOSSSHORT requires your station's Captain's Spare ID to test out some new security features. We'll send out some high value items for compensation."
	reward = 0
	reward_id = "high_value"
	wanted_types = list(/obj/item/weapon/card/id/captains_spare)

/datum/bounty/item/security/hardsuit
	name = "Security Voidsuit"
	description = "One of %BOSSSHORT security sectors accidentally ordered more guns instead of the requested voidsuits, however we cannot spare any additional funds! We'll trade you some of our spare guns for a single security hardsuit."
	reward = 0
	reward_id = "guns"
	wanted_types = list(/obj/item/clothing/suit/space/void/security)

/datum/bounty/item/security/forcegloves
	name = "Force Gloves"
	description = "%COMPNAME military academy is conducting close quarter combat exercises. They request that force gloves be shipped. We'll send your security team some spare combat modules in return."
	reward = 0
	reward_id = "combat_manuals"
	wanted_types = list(/obj/item/clothing/gloves/force)

/datum/bounty/item/security/telebaton
	name = "Telebaton"
	description = "Assistants are staging a \"peaceful protest\" on the Odin. Quickly ship a telebaton so we can ensure their swift return to work."
	reward = 2500
	wanted_types = list(/obj/item/weapon/melee/telebaton)