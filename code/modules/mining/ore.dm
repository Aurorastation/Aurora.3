	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore1"
	w_class = 2
	throwforce = 10
	var/datum/geosample/geologic_data
	var/material

	name = "pitchblende"
	icon_state = "ore_uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = ORE_URANIUM

	name = "hematite"
	icon_state = "ore_iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_IRON

	name = "raw carbon"
	icon_state = "ore_coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_COAL

	name = "sand"
	icon_state = "ore_glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_SAND
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
		H.eye_blind += 5
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)


	name = "phoron crystals"
	icon_state = "ore_phoron"
	origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	material = ORE_PHORON

	name = "native silver ore"
	icon_state = "ore_silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = ORE_SILVER

	name = "native gold ore"
	icon_state = "ore_gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = ORE_GOLD

	name = "diamonds"
	icon_state = "ore_diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = ORE_DIAMOND

	name = "raw platinum"
	icon_state = "ore_platinum"
	material = ORE_PLATINUM

	name = "raw hydrogen"
	icon_state = "ore_hydrogen"
	material = ORE_HYDROGEN

	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"
	material = null

	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8
	if(icon_state == "ore1")
		icon_state = "ore[pick(1,2,3)]"

	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()
