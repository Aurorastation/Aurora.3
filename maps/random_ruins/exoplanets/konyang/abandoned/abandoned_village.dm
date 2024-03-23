/datum/map_template/ruin/exoplanet/konyang_abandoned_village
	name = "Konyang Abandoned Village"
	id = "konyang_abandoned_village"
	description = "A rural village on Konyang, abandoned for any reason."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned_village.dmm")
	ban_ruins = list(/datum/map_template/ruin/exoplanet/konyang_village)

/obj/effect/landmark/corpse/konyang_villager
	name = "Konyang Villager"
	corpseuniform = /obj/item/clothing/under/konyang
	corpseshoes = /obj/item/clothing/shoes/konyang
	corpseid = FALSE
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/konyang_villager/do_extra_customization(mob/living/carbon/human/M)
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hooded/wintercoat/konyang(M), slot_wear_suit)
	M.adjustBruteLoss(rand(200, 400))
	M.change_skin_tone(rand(0, 100))
	M.dir = pick(GLOB.cardinal)
