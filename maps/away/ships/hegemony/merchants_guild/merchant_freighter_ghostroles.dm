/datum/ghostspawner/human/merchant_guild
	short_name = "merchant_guildman"
	name = "Merchants' Guild Freighter Crew"
	desc = "You are an apprentice of the Unathi Merchants' Guild, assigned to crew a cargo freighter. Act with honor, but seek profit for your ship and your guild."
	tags = list("External")
	spawnpoints = list("merchant_guildman")
	max_count = 3
	uses_species_whitelist = FALSE
	welcome_message = "As an apprentice, you are seeking to prove yourself by working under a full guildsman - in this case, your captain. Follow their orders, and work hard to prove that you have what it takes to make it in the Merchants' Guild."

	outfit = /datum/outfit/admin/merchant_guild
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Merchants' Guild Freighter Crew"
	special_role = "Merchants' Guild Freighter Crew"
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	away_site = TRUE

/datum/outfit/admin/merchant_guild
	name = "Merchants' Guild Freighter Crew"
	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/caligae
	l_ear = /obj/item/device/radio/headset/ship
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/accessory/poncho/unathimantle/merchant

/datum/outfit/admin/merchant_guild/get_id_access()
	return list(access_merchants_guild, access_external_airlocks)

/datum/outfit/admin/merchant_guild/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#1f8c3c", "#ab7318", "#1846ba")
	if(H?.wear_suit)
		H.wear_suit.color = "#2a2b2e"

/datum/ghostspawner/human/merchant_guild/captain
	short_name = "merchant_guildcap"
	name = "Merchants' Guild Freighter Captain"
	desc = "You are a guildsman of the Unathi Merchants' Guild, assigned to command a cargo freighter. Act with honor, but seek profit for your ship, yourself and your guild."
	max_count = 1
	uses_species_whitelist = TRUE
	outfit = /datum/outfit/admin/merchant_guild/captain
	assigned_role = "Merchants' Guild Freighter Captain"
	special_role = "Merchants' Guild Freighter Captain"
	spawnpoints = list("merchant_guildcap")
	welcome_message = "As a full guildsman, you have command of the ship and its crew, your apprentices. You are responsible for their education and assessment in the skills needed to be a merchant - however, your primary goal remains making money."

/datum/outfit/admin/merchant_guild/captain
	uniform = /obj/item/clothing/under/unathi/mogazali
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/pistol/hegemony = 1)

/datum/ghostspawner/human/merchant_guild/guard
	short_name = "merchant_guildguard"
	name = "Merchant Freighter Fighters' Lodge Guard"
	desc = "You are a warrior of the Unathi Fighters' Lodge Guild, hired to protect a cargo freighter for the Merchants' Guild. Keep your ship, crew and cargo safe, and earn your paycheck in the process."
	max_count = 1
	uses_species_whitelist = TRUE
	outfit = /datum/outfit/admin/merchant_guild/guard
	assigned_role = "Merchants' Guild Freighter Security"
	special_role = "Merchants' Guild Freighter Security"
	spawnpoints = list("merchant_guildguard")
	welcome_message = "As a guildsman of the Fighters' Lodge, your job is to ensure the security of the ship so that the merchants can continue to do what they do best. While you should try and act with honor, the most important thing remains keeping yourself and your crew alive."

/datum/outfit/admin/merchant_guild/guard
	uniform = /obj/item/clothing/under/unathi/zazali
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/pistol/hegemony = 1)
	r_pocket = /obj/item/melee/energy/sword/hegemony
	belt = /obj/item/storage/belt/security/full
	back = /obj/item/storage/backpack/rucksack
	backpack_contents = list(/obj/item/clothing/suit/armor/carrier/officer = 1,
							/obj/item/clothing/accessory/arm_guard = 1,
							/obj/item/clothing/accessory/leg_guard = 1,
							/obj/item/clothing/head/helmet/security = 1)
	l_pocket = /obj/item/shield/energy/hegemony
	suit = /obj/item/clothing/accessory/poncho/unathimantle/fighter