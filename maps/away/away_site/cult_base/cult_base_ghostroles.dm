
// ---------------------- spawners

/datum/ghostspawner/human/cult_base_cultist
	short_name = "cult_base_cultist"
	name = "Cult Base Cultist"
	tags = list("External")
	desc = "\
		You are a follower of the Geometer of Blood. Others have already left the material plane, but you were told to stay. \
		You were part of some archeological expedition, but that is important no more. \
		You wake up, visitors are coming, and they do not know the word of Nar-Sie yet. \
		(OOC Note: This is an antagonist role.)\
		"
	welcome_message = "\
		You were part of an archeological expedition, hired by some independent scientist, to look for artifacts in a asteroid belt. \
		But that is important no more, and you see the world clearly now. Others have already left the material plane, but you were told to stay. \
		Now you wake up, visitors are coming, and they should learn the word of Nar-Sie too, and spread it to others as well. \
		You live and breathe for the Dark One, but your death may not be in vain. \
		<br>\
		(OOC Note: This is an antagonist role which places typical antagonist expectations on you. \
		You are expected to try to generate an interesting encounter with whoever has docked on the away site. \
		You may try to blend in with the visitors, befriend or trick them, but you you are not 'normal', you follow Nar-Sie. \
		Remember to follow basic escalation rules, and have fun!)\
		"

	spawnpoints = list("cult_base_cultist")
	max_count = 4
	enabled = FALSE

	outfit = /datum/outfit/admin/cult_base_cultist
	possible_species = list(
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD,
		SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN,
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,
		SPECIES_UNATHI,
	)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Cult Base Cultist"
	respawn_flag = null

// ---------------------- outfits

/datum/outfit/admin/cult_base_cultist
	name = "Cult Base Cultist"

	id = /obj/item/card/id/away_site
	uniform = list(
		/obj/item/clothing/under/syndicate/tracksuit,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/overalls,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/offworlder/drab,
	)
	suit = list(
		/obj/item/clothing/suit/cultrobes,
		/obj/item/clothing/suit/cultrobes/alt,
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/longcoat,
		/obj/item/clothing/suit/storage/toggle/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black,
	)
	glasses = list(
		/obj/item/clothing/glasses/fakesunglasses/aviator,
		/obj/item/clothing/glasses/sunglasses/aviator,
		/obj/item/clothing/glasses/hud/health/aviator,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/science,
		/obj/item/clothing/glasses/safety/goggles,
	)
	gloves = list(
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/gloves/brown,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/black_leather,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/gloves/force,
	)
	shoes = list(
		/obj/item/clothing/shoes/cult,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
		/obj/item/clothing/shoes/magboots,
		/obj/item/clothing/shoes/sneakers/blue,
		/obj/item/clothing/shoes/sneakers/hitops/brown,
	)
	belt = list(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/fannypack,
		/obj/item/storage/belt/medical/first_responder,
		/obj/item/storage/belt/military,
		/obj/item/storage/belt/mining,
		/obj/item/storage/belt/security/full,
		/obj/item/storage/belt/soulstone/full
	)
	back = list(
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/leather/withwallet,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/messenger/syndie,
		/obj/item/storage/backpack/satchel/pocketbook,
		/obj/item/storage/backpack/cultpack,
	)
	r_hand = list(
		/obj/item/device/flashlight/lantern/on,
		/obj/item/device/flashlight/maglight/on,
		/obj/item/device/flashlight/heavy/on,
		/obj/item/device/flashlight/lamp,
	)
	l_hand = list(
		/obj/item/melee/cultblade,
		/obj/item/melee/telebaton,
		/obj/item/melee/baton/stunrod,
		/obj/item/material/sword/improvised_sword,
		/obj/item/material/sword/longsword,
		/obj/item/material/hatchet/machete/steel,
		/obj/item/material/kitchen/utensil/knife/boot,
		/obj/item/material/knife/butterfly,
	)
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/material/knife/ritual = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
	)

/datum/outfit/admin/cult_base_cultist/post_equip(mob/living/carbon/human/human, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(human))
		human.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(human.mind)
		cult.add_antagonist(human.mind)

/datum/outfit/admin/goon/get_id_access()
	return list(ACCESS_GENERIC_AWAY_SITE, ACCESS_EXTERNAL_AIRLOCKS)
