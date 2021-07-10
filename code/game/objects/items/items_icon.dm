var/list/mob_icon_icon_states = list()

/obj/item/proc/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	if(!mob_icon_icon_states[mob_icon])
		mob_icon_icon_states[mob_icon] = icon_states(mob_icon)
	if(LAZYLEN(H.species.equip_adjust) && H.species.equip_adjust[slot] && length(H.species.equip_adjust[slot]) && (mob_state in mob_icon_icon_states[mob_icon]))
		// Check the cache for previously made icons.
		var/image_key = "[mob_icon]-[mob_state]-[color]-[slot]"
		if(!LAZYISIN(H.species.equip_overlays, image_key))
			var/icon/final_I = new(H.species.icon_template ? H.species.icon_template : 'icons/mob/human.dmi',"blank")
			var/list/shifts = H.species.equip_adjust[slot]

			// Apply all pixel shifts for each direction.
			for(var/shift_facing in shifts)
				var/list/facing_list = shifts[shift_facing]
				var/use_dir = text2num(shift_facing)
				var/icon/equip = new(mob_icon, icon_state = mob_state, dir = use_dir)
				var/icon/canvas = new(H.species.icon_template ? H.species.icon_template : 'icons/mob/human.dmi',"blank")
				canvas.Blend(equip, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
				if(build_from_parts)
					var/icon/parts_icon = new(mob_icon, icon_state = "[item_state][contained_sprite ? slot_str_to_contained_flag(slot) : ""]_[worn_overlay]", dir = use_dir)
					canvas.Blend(parts_icon, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
				final_I.Insert(canvas, dir = use_dir)
			LAZYINITLIST(H.species.equip_overlays)
			var/image/final_image = overlay_image(final_I, color = color, flags = RESET_COLOR|RESET_ALPHA)
			H.species.equip_overlays[image_key] = final_image
		var/image/I = new() // We return a copy of the cached image, in case downstream procs mutate it.
		I.appearance = H.species.equip_overlays[image_key]
		return I
	var/image/I = overlay_image(mob_icon, mob_state, color, RESET_COLOR|RESET_ALPHA)
	if(build_from_parts)
		I.add_overlay(overlay_image(mob_icon, "[item_state][contained_sprite ? slot_str_to_contained_flag(slot) : ""]_[worn_overlay]", null, RESET_COLOR|RESET_ALPHA))
	return I
