GLOBAL_LIST_EMPTY(plant_seed_sprites)

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "random"
	w_class = WEIGHT_CLASS_SMALL

	storage_slot_sort_by_name = TRUE
	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	update_seed()
	. = ..()

/// Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(SSplants.seeds) && SSplants.seeds[seed_type])
		seed = SSplants.seeds[seed_type]
	update_appearance()

/// Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance(var/ret_image = FALSE)
	if(!seed)
		return

	// This is very hacky, but we clear the icon state here because the ingame packets
	// are all pure overlays, but we still want seeds to show up in StrongDMM.
	icon_state = "blank"

	// Update icon.
	ClearOverlays()
	var/is_seeds = ((seed.seed_noun in list(SEED_NOUN_SEEDS, SEED_NOUN_PITS, SEED_NOUN_NODES)) ? 1 : 0)
	var/image/seed_mask
	var/seed_base_key = "base-[is_seeds ? seed.get_trait(TRAIT_PLANT_COLOUR) : SEED_NOUN_SPORES]"
	if(GLOB.plant_seed_sprites[seed_base_key])
		seed_mask = GLOB.plant_seed_sprites[seed_base_key]
	else
		seed_mask = image('icons/obj/seeds.dmi',"[is_seeds ? "seed" : "spore"]-mask")
		if(is_seeds) // Spore glass bits aren't coloured.
			seed_mask.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		GLOB.plant_seed_sprites[seed_base_key] = seed_mask

	var/image/seed_overlay
	var/seed_overlay_key = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
	if(GLOB.plant_seed_sprites[seed_overlay_key])
		seed_overlay = GLOB.plant_seed_sprites[seed_overlay_key]
	else
		seed_overlay = image('icons/obj/seeds.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		seed_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		GLOB.plant_seed_sprites[seed_overlay_key] = seed_overlay

	AddOverlays(seed_mask)
	AddOverlays(seed_overlay)

	if(is_seeds)
		src.name = "packet of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It has a picture of \a [seed.display_name] on the front."
	else
		src.name = "sample of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It's labelled as coming from \a [seed.display_name]."

	if(ret_image)
		var/icon/sm = icon('icons/obj/seeds.dmi', "[is_seeds ? "seed" : "spore"]-mask")
		var/icon/so = icon('icons/obj/seeds.dmi', "[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		var/p_color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		so *= p_color
		if(is_seeds)
			var/s_color = seed.get_trait(TRAIT_PLANT_COLOUR)
			sm *= s_color
		sm.Blend(so, ICON_OVERLAY)
		return sm

/obj/item/seeds/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "All plants have preferential heat and light values. They will grow faster if close to these values. Plants also have tolerance values, \
	and will stop growing and begin to take damage when outside of their tolerances. Use hydroponics trays to get plants within their optimal values!"
	. += "Plants can be mutated with any mutagen, altering their genes in a random way. Do this with caution as the results may be hazardous!"

/obj/item/seeds/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()

	if(seed && !seed.roundstart)
		. += "It's tagged as variety #[seed.uid]."

	var/lower_heat_preference = seed.get_trait(TRAIT_IDEAL_HEAT) - seed.get_trait(TRAIT_HEAT_PREFERENCE)
	var/higher_heat_preference = seed.get_trait(TRAIT_IDEAL_HEAT) + seed.get_trait(TRAIT_HEAT_PREFERENCE)
	var/lower_light_preference = seed.get_trait(TRAIT_IDEAL_LIGHT) - seed.get_trait(TRAIT_LIGHT_PREFERENCE)
	var/higher_light_preference = seed.get_trait(TRAIT_IDEAL_LIGHT) + seed.get_trait(TRAIT_LIGHT_PREFERENCE)

	var/lower_heat_tolerance = seed.get_trait(TRAIT_IDEAL_HEAT) - seed.get_trait(TRAIT_HEAT_TOLERANCE)
	var/higher_heat_tolerance = seed.get_trait(TRAIT_IDEAL_HEAT) + seed.get_trait(TRAIT_HEAT_TOLERANCE)
	var/lower_light_tolerance = seed.get_trait(TRAIT_IDEAL_LIGHT) - seed.get_trait(TRAIT_LIGHT_TOLERANCE)
	var/higher_light_tolerance = seed.get_trait(TRAIT_IDEAL_LIGHT) + seed.get_trait(TRAIT_LIGHT_TOLERANCE)

	. += SPAN_NOTICE("This grows optimally between <b>[lower_heat_preference] and [higher_heat_preference] kelvin</b>, and between <b>[lower_light_preference] and [higher_light_preference] lumens.</b> It is capable of any growth at all between <b>[lower_heat_tolerance] and [higher_heat_tolerance] kelvin</b>, and between <b>[lower_light_tolerance] and [higher_light_tolerance] lumens.</b>")

/obj/item/seeds/cutting
	name = SEED_NOUN_CUTTINGS
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.name = "packet of [seed.seed_name] cuttings"

/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/Initialize()
	seed = SSplants.create_random_seed()
	seed_type = seed.name
	. = ..()
