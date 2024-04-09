/datum/map_template/ruin/exoplanet/moghes_wasteland_battlefield
	name = "Wasteland Battlefield"
	id = "moghes_wasteland_battlefield"
	description = "A battlefield of the Contact War, now long forgotten."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	suffixes = list("moghes/moghes_wasteland_battlefield.dmm")

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
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/gun/energy/pistol/hegemony(M), slot_belt)
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/melee/energy/sword/hegemony(M), slot_r_store)
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/tempestsmg(M), slot_back)
	if(prob(10))
		M.equip_to_slot_or_del(new /obj/item/gun/energy/rifle/hegemony(M), slot_back)
	if(prob(5))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/shotgun/wallgun(M), slot_belt)
	if(prob(1))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/heavysniper/unathi(M), slot_back)

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
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/pistol/spitter(M), slot_belt)
	if(prob(10))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/crackrifle(M), slot_back)
	if(prob(1))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/rifle/hook_mg(M), slot_back)
