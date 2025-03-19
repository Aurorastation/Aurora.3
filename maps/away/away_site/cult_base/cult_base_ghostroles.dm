
// ---------------------- spawners

/datum/ghostspawner/human/cult_base_cultist
	short_name = "cult_base_cultist"
	name = "Cult Base Cultist"
	tags = list("External")
	desc = "\
		You are a follower of the Geometer of Blood. \
		You wake up, visitors are coming, and they do not know the word of Nar-Sie yet. \
		"
	desc_ooc = "\
		This is an antagonist role. \
		"
	welcome_message = "\
		You were part of an archeological expedition, hired by some independent scientist, to look for artifacts in a asteroid belt. \
		But that is important no more, and you see the world clearly now. Others have already left the material plane, but you were told to stay, \
		as your mind is impure, your thoughts are clouded, and you are to prove your worth before leaving the material plane. \
		Now you wake up, visitors are coming, and they should learn the word of Nar-Sie too, or be left unbothered if they are unwilling. \
		Your death must not be in vain, and your actions must not lead to the Cult being discovered. \
		"
	welcome_message_ooc = "\
		This is an antagonist role which places typical antagonist expectations on you. \
		You are expected to try to generate an interesting encounter with whoever has docked to the away site. \
		You may try to blend in with the visitors, try to trick them, but you are not 'normal', you follow Nar-Sie. \
		You are supposed to act covert, and not bring too much attention to Nar-Sie. \
		You do not have the cult tome, but you may still use runes you find on the floor, or use cult languages. \
		You may click a plasteel wall to push on it, and open a hidden door. \
		Remember to follow basic escalation rules, and have fun! \
		"

	spawnpoints = list("cult_base_cultist")
	max_count = 4
	enabled = FALSE
	enable_dmessage = TRUE

	outfit = /obj/outfit/admin/cult_base_cultist
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	possible_species = list(
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD,
		SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN,
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,
		SPECIES_UNATHI,
	)

	assigned_role = "Independent Spacer"
	special_role = "Cult Base Cultist"
	respawn_flag = null

/datum/ghostspawner/human/cult_base_cultist/more
	short_name = "cult_base_cultist_more"
	name = "Cult Base Cultist, More"
	desc_ooc = "\
		This is enabled by staff if more cultists are desired. This is an antagonist role. \
		"

// ---------------------- corpses

/obj/effect/landmark/corpse/cult_base_cultist
	name = "Cult Base Cultist Corpse"
	species = list(SPECIES_HUMAN, SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_UNATHI)
	outfit = list(
		/obj/outfit/admin/cult_base_cultist_corpse,
		/obj/outfit/admin/generic,
		/obj/outfit/admin/generic/engineer,
		/obj/outfit/admin/generic/security,
		/obj/outfit/admin/generic/medical,
	)

/obj/effect/landmark/corpse/cult_base_cultist/do_extra_customization(var/mob/living/carbon/human/human)
	// turn to random dir
	human.dir = pick(NORTH, SOUTH, EAST, WEST)

	// slit throat
	var/obj/item/organ/external/head = human.get_organ(BP_HEAD)
	if(head)
		head.sever_artery()
	human.take_overall_damage(150, 100)

	// add blood
	human.w_uniform?.add_blood(human)
	human.wear_suit?.add_blood(human)
	human.gloves?.add_blood(human)
	human.shoes?.add_blood(human)

// ---------------------- outfits

/obj/outfit/admin/cult_base_cultist
	name = "Cult Base Cultist"

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
		/obj/item/clothing/suit/cultrobes/alt,
		/obj/item/clothing/suit/cultrobes/alt,
		/obj/item/clothing/suit/space/cult,
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
		/obj/item/clothing/glasses/safety/goggles/science,
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
		/obj/item/clothing/shoes/winter,
		/obj/item/clothing/shoes/magboots,
		/obj/item/clothing/shoes/sneakers/blue,
		/obj/item/clothing/shoes/sneakers/brown,
		/obj/item/clothing/shoes/sneakers/hitops/brown,
	)
	accessory = list(
		/obj/item/clothing/accessory/storage/bayonet,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/clothing/accessory/storage/overalls,
		/obj/item/clothing/accessory/storage/pouches,
		/obj/item/clothing/accessory/storage/pouches/white,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbingharness,
	)
	belt = list(
		/obj/item/storage/belt/fannypack,
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/medical/paramedic/full,
		/obj/item/storage/belt/mining/full,
		/obj/item/storage/belt/security/full/alt,
		/obj/item/storage/belt/security/full/pistol45,
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
		/obj/item/device/flashlight/on,
		/obj/item/device/flashlight/lantern/on,
		/obj/item/device/flashlight/maglight/on,
		/obj/item/device/flashlight/heavy/on,
	)
	l_hand = list(
		/obj/item/melee/cultblade,
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
		/obj/item/device/flashlight/flare/glowstick/random = 1,
		/obj/random/junk = 1,
		/obj/item/material/knife/ritual = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
	)
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/fingerless,
		SPECIES_TAJARA = /obj/item/clothing/gloves/fingerless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/fingerless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/fingerless,
	)

/obj/outfit/admin/cult_base_cultist/post_equip(mob/living/carbon/human/human, visualsOnly = FALSE)
	. = ..()

	// add species equipment
	if(isoffworlder(human))
		human.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

	// add matching matching head items
	if(istype(human.wear_suit, /obj/item/clothing/suit/cultrobes/alt))
		human.equip_or_collect(new /obj/item/clothing/head/culthood/alt, slot_head)
	if(istype(human.wear_suit, /obj/item/clothing/suit/space/cult))
		human.equip_or_collect(new /obj/item/clothing/head/helmet/space/cult, slot_head)

	// add other random equipment
	if(prob(10))
		human.equip_or_collect(new /obj/item/gun/projectile/revolver/detective, slot_in_backpack)
		human.equip_or_collect(new /obj/item/ammo_magazine/c38, slot_in_backpack)
	if(prob(10))
		human.equip_or_collect(new /obj/random/firstaid, slot_in_backpack)
	if(prob(20))
		human.equip_or_collect(new /obj/random/medical, slot_in_backpack)
	if(prob(20))
		human.equip_or_collect(new /obj/random/loot, slot_in_backpack)
	if(prob(20))
		human.equip_or_collect(new /obj/random/tool, slot_in_backpack)
	if(prob(25))
		human.equip_or_collect(new /obj/item/crowbar/red, slot_in_backpack)

	// make into a cultist
	if(human.mind)
		GLOB.cult.add_antagonist(human.mind, do_not_equip=TRUE)

	// add blood
	if(prob(75))
		human.w_uniform?.add_blood(human)
		human.wear_suit?.add_blood(human)
		human.l_hand?.add_blood(human)
		human.gloves?.add_blood(human)
		human.shoes?.add_blood(human)

/obj/outfit/admin/cult_base_cultist_corpse
	name = "Cult Base Cultist Corpse"

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
		/obj/item/clothing/suit/cultrobes/alt,
	)
	head = list(
		/obj/item/clothing/head/culthood/alt
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
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
	)
