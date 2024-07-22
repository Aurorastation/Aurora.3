/datum/map_template/ruin/exoplanet/moghes_wasteland_battlefield
	name = "Wasteland Battlefield"
	id = "moghes_wasteland_battlefield"
	description = "A battlefield of the Contact War, now long forgotten."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_battlefield.dmm"
	unit_test_groups = list(1)

/obj/effect/landmark/corpse/hegemony_soldier
	name = "Hegemony Soldier"
	corpseuniform = /obj/item/clothing/under/unathi
	corpsesuit = /obj/item/clothing/suit/armor/unathi/hegemony
	corpsehelmet = /obj/item/clothing/head/helmet/unathi/hegemony
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/hegemony_soldier/do_extra_customization(var/mob/living/carbon/human/M)
	M.gender = MALE
	M.ChangeToSkeleton()
	if(prob(15))
		M.equip_to_slot_or_del(new /obj/item/melee/energy/sword/hegemony(M), slot_r_store)

/obj/effect/landmark/corpse/trad_soldier
	name = "Traditionalist Soldier"
	corpseuniform = /obj/item/clothing/under/unathi
	corpsesuit = /obj/item/clothing/suit/armor/unathi
	corpsehelmet = /obj/item/clothing/head/helmet/unathi
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/trad_soldier/do_extra_customization(mob/living/carbon/human/M)
	M.gender = MALE
	M.ChangeToSkeleton()
	if(prob(15))
		M.equip_to_slot_or_del(new /obj/item/material/sword/longsword(M), slot_belt)
