#define UNDERSCORE_OR_NULL(target) "[target ? "[target]_" : ""]"

/datum/unit_test/hardsuit_sprite_test
	name = "Hardsuit Sprite Test"

/datum/unit_test/hardsuit_sprite_test/start_test()
	for(var/rig_path in subtypesof(/obj/item/rig))
		var/obj/item/rig/R = new rig_path
		var/list/rig_states = icon_states(R.icon)

		if(!(R.icon_state in rig_states))
			fail("[R.name]'s module icon_state isn't in its icon file.")
		if(!("[R.icon_state]_ba" in rig_states))
			fail("[R.name]'s on-back module icon_state isn't in its icon file.")

		var/list/species_to_check = list("") // blank means default, human
		if(length(R.icon_supported_species_tags))
			species_to_check += R.icon_supported_species_tags

		if(R.helm_type)
			if(!("[R.icon_state]_helmet" in rig_states))
				fail("[R.name]'s helmet icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_helmet" in rig_states))
				fail("[R.name]'s sealed helmet icon_state isn't in its icon file.")
		if(R.suit_type)
			if(!("[R.icon_state]_suit" in rig_states))
				fail("[R.name]'s suit icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_suit" in rig_states))
				fail("[R.name]'s sealed suit icon_state isn't in its icon file.")
		if(R.glove_type)
			if(!("[R.icon_state]_gloves" in rig_states))
				fail("[R.name]'s gloves icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_gloves" in rig_states))
				fail("[R.name]'s sealed gloves icon_state isn't in its icon file.")
		if(R.boot_type)
			if(!("[R.icon_state]_shoes" in rig_states))
				fail("[R.name]'s shoes icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_shoes" in rig_states))
				fail("[R.name]'s sealed shoes icon_state isn't in its icon file.")

		for(var/short in species_to_check)
			short = UNDERSCORE_OR_NULL(short)
			if(R.helm_type)
				if(!("[short][R.icon_state]_he" in rig_states))
					fail("[short] [R.name]'s helmet item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_he" in rig_states))
					fail("[short] [R.name]'s sealed helmet item_state isn't in its icon file.")
			if(R.suit_type)
				if(!("[short][R.icon_state]_su" in rig_states))
					fail("[short] [R.name]'s suit item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_su" in rig_states))
					fail("[short] [R.name]'s sealed suit item_state isn't in its icon file.")
			if(R.glove_type)
				if(!("[short][R.icon_state]_gl" in rig_states))
					fail("[short] [R.name]'s gloves item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_gl" in rig_states))
					fail("[short] [R.name]'s sealed gloves item_state isn't in its icon file.")
			if(R.boot_type)
				if(!("[short][R.icon_state]_sh" in rig_states))
					fail("[short] [R.name]'s shoes item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_he" in rig_states))
					fail("[short] [R.name]'s sealed shoes item_state isn't in its icon file.")

	if(!reported)
		pass("All hardsuits have their correct sprites.")

	return TRUE

#undef UNDERSCORE_OR_NULL(target)