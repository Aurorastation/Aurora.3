/datum/map_template/ruin/exoplanet/adhomai_battlefield
	name = "Adhomai Battlefield"
	id = "adhomai_battlefield"
	description = "An old battlefield littered with the remains of soldiers and their machines."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffix = "adhomai/adhomai_battlefield.dmm"

/obj/effect/landmark/corpse/pra_soldier
	name = "PRA Soldier"
	corpseuniform = /obj/item/clothing/under/tajaran/pra_uniform
	corpsesuit = /obj/item/clothing/suit/storage/tajaran/pra_jacket/armored
	corpseshoes = /obj/item/clothing/shoes/tajara/jackboots
	corpsehelmet = /obj/item/clothing/head/beret/tajaran/pra
	corpseid = FALSE
	species = SPECIES_TAJARA_MSAI

/obj/effect/landmark/corpse/pra_soldier/do_extra_customization(var/mob/living/carbon/human/M)
	if(prob(25))
		M.equip_to_slot_or_del(new /obj/item/photo/soldier(M), slot_r_store)
	if(prob(50))
		M.equip_to_slot_or_del(new /obj/item/gun/projectile/pistol/adhomai(M), slot_l_store)
	var/cadaver_color = pick("white", "ivory", "silver")
	switch(cadaver_color)
		if("white")
			M.change_hair_color(238, 223, 204)
			M.change_skin_color(238, 223, 204)
		if("ivory")
			M.change_hair_color(205, 205, 192)
			M.change_skin_color(205, 205, 192)
		if("silver")
			M.change_hair_color(192, 192, 192)
			M.change_skin_color(192, 192, 192)

	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(cardinal)

/obj/item/photo/soldier
	name = "family photo"
	desc = "A picture of a happy Tajaran family. This photo is crumpled and slightly bloody."