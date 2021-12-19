var/list/mob_icon_icon_states = list()

/obj/item/proc/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	if(!mob_icon_icon_states[mob_icon])
		mob_icon_icon_states[mob_icon] = icon_states(mob_icon)
	var/needs_shift = !(H.species.bodytype in sprite_sheets)
	if(!needs_shift && length(item_icons))
		needs_shift = (slot in item_icons)
	if(LAZYLEN(H.species.equip_adjust) && H.species.equip_adjust[slot] && length(H.species.equip_adjust[slot]) && (mob_state in mob_icon_icon_states[mob_icon]) && needs_shift)
		// Check the cache for previously made icons.
		var/image_key_mod = get_image_key_mod()
		var/image_key = "[mob_icon]-[mob_state]-[color]-[slot][!isnull(image_key_mod) ? "-[image_key_mod]" : ""]"
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
				canvas = build_shifted_additional_parts(H, mob_icon, slot, canvas, facing_list, use_dir)
				final_I.Insert(canvas, dir = use_dir)
			LAZYINITLIST(H.species.equip_overlays)
			var/image/final_image = overlay_image(final_I, color = color, flags = RESET_COLOR|RESET_ALPHA)
			H.species.equip_overlays[image_key] = final_image
		var/image/I = new() // We return a copy of the cached image, in case downstream procs mutate it.
		I.appearance = H.species.equip_overlays[image_key]
		return I
	var/image/I = overlay_image(mob_icon, mob_state, color, RESET_COLOR|RESET_ALPHA)
	var/image/additional_parts = build_additional_parts(H, mob_icon, slot)
	if(additional_parts)
		I.add_overlay(additional_parts)

	return I

/obj/item/proc/get_image_key_mod()
	return

/obj/item/proc/build_shifted_additional_parts(mob/living/carbon/human/H, mob_icon, slot, var/icon/canvas, var/list/facing_list, use_dir)
	if(!canvas)
		return
	if(build_from_parts)
		var/icon/parts_icon = new(mob_icon, icon_state = "[item_state][contained_sprite ? slot_str_to_contained_flag(slot) : ""]_[worn_overlay]", dir = use_dir)
		canvas.Blend(parts_icon, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
	return canvas

/obj/item/proc/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	var/image/I
	if(build_from_parts)
		I = overlay_image(mob_icon, "[item_state][contained_sprite ? slot_str_to_contained_flag(slot) : ""]_[worn_overlay]", null, RESET_COLOR|RESET_ALPHA)
		if(worn_overlay_color)
			I.color = worn_overlay_color
	return I
