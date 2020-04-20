/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	cut_overlays()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				add_overlay(child.mob_icon)

		add_overlay(organ.mob_icon)

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	s_tone = null
	skin_color = null
	hair_color = null
	if(status & ORGAN_ROBOT && !(isipc(human)) && !(isautakh(human)))
		return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_SKIN_TONE))
		s_tone = human.s_tone
	if((human.species.appearance_flags & HAS_SKIN_COLOR) || (human.species.appearance_flags & HAS_SKIN_PRESET))
		skin_color = rgb(human.r_skin, human.g_skin, human.b_skin)
	hair_color = rgb(human.r_hair, human.g_hair, human.b_hair)

/obj/item/organ/external/proc/sync_colour_to_dna()
	s_tone = null
	skin_color = null
	hair_color = null
	if(status & ORGAN_ROBOT && !force_skintone)
		return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_SKIN_TONE))
		s_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if((species.appearance_flags & HAS_SKIN_COLOR) || (species.appearance_flags & HAS_SKIN_PRESET))
		skin_color = rgb(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))
	hair_color = rgb(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = owner.get_eyes()
	if(eyes)
		eyes.update_colour()

/obj/item/organ/external/head/removed()
	get_icon()
	..()

/obj/item/organ/external/head/get_icon()
	..()
	cut_overlays()
	if(!owner || !owner.species)
		return
	if(owner.species.has_organ[owner.species.vision_organ])
		var/obj/item/organ/internal/eyes/eyes = owner.get_eyes()
		if(eyes && species.eyes)
			var/eyecolor
			if (eyes.eye_colour)
				eyecolor = rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])

			var/cache_key = "[species.eyes]_[eyecolor || "nocolor"]"

			var/icon/eyes_icon = SSicon_cache.human_eye_cache[cache_key]
			if (!eyes_icon)
				eyes_icon = new/icon(species.eyes_icons, species.eyes)
				if(eyecolor)
					eyes_icon.Blend(eyecolor, species.eyes_icon_blend)
				else
					eyes_icon.Blend(rgb(128,0,0), species.eyes_icon_blend)

				SSicon_cache.human_eye_cache[cache_key] = eyes_icon

			mob_icon.Blend(eyes_icon, ICON_OVERLAY)
			add_overlay(eyes_icon)

	if(owner.lip_style && (species && (species.appearance_flags & HAS_LIPS)))
		var/icon/lip_icon = SSicon_cache.human_lip_cache["[owner.lip_style]"]
		if (!lip_icon)
			lip_icon = new/icon('icons/mob/human_face/lips.dmi', "[owner.lip_style]")
			SSicon_cache.human_lip_cache["[owner.lip_style]"] = lip_icon

		add_overlay(lip_icon)
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	apply_markings()

	get_internal_organs_overlay()

	add_overlay(owner.generate_hair_icon())

	compile_overlays()

	return mob_icon

/obj/item/organ/external/proc/apply_markings(restrict_to_robotic = FALSE)
	if (!cached_markings)
		update_marking_cache()

	if (LAZYLEN(cached_markings))
		for(var/M in cached_markings)
			var/datum/sprite_accessory/marking/mark_style = cached_markings[M]["datum"]
			if (restrict_to_robotic && !mark_style.is_painted)
				continue

			var/m_color = cached_markings[M]["color"]
			var/cache_key = "[mark_style.icon]-[mark_style.icon_state]-[limb_name]-[m_color]"

			var/icon/finished_icon = SSicon_cache.markings_cache[cache_key]
			if (!finished_icon)
				finished_icon = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[limb_name]")
				finished_icon.Blend(m_color, mark_style.icon_blend_mode)
				SSicon_cache.markings_cache[cache_key] = finished_icon

			add_overlay(finished_icon) //So when it's not on your body, it has icons
			mob_icon.Blend(finished_icon, ICON_OVERLAY) //So when it's on your body, it has icons

/obj/item/organ/external/proc/get_internal_organs_overlay()
	for(var/obj/item/organ/internal/O in internal_organs)
		if(O.on_mob_icon)
			var/cache_key = "[O.on_mob_icon]-[O.icon_state]"

			var/icon/organ_icon = SSicon_cache.internal_organ_cache[cache_key]
			if (!organ_icon)
				organ_icon = new /icon(O.on_mob_icon, O.icon_state)
				SSicon_cache.internal_organ_cache[cache_key] = organ_icon

			add_overlay(organ_icon)
			mob_icon.Blend(organ_icon, ICON_OVERLAY)

/obj/item/organ/external/var/icon_cache_key
/obj/item/organ/external/proc/get_icon(var/skeletal)

	var/gender = "f"
	if(owner && owner.gender == MALE)
		gender = "m"

	if(force_icon)
		mob_icon = new /icon(force_icon, "[icon_name][gendered_icon ? "_[gender]" : ""]")
		if(painted && skin_color)
			mob_icon.Blend(skin_color, ICON_ADD)
		apply_markings(restrict_to_robotic = TRUE)
		get_internal_organs_overlay()
	else
		if(!dna)
			mob_icon = new /icon('icons/mob/human_races/human/r_human.dmi', "[icon_name][gendered_icon ? "_[gender]" : ""]")
		else
			if(!gendered_icon)
				gender = null
			else
				if(dna.GetUIState(DNA_UI_GENDER))
					gender = "f"
				else
					gender = "m"

			if(skeletal)
				mob_icon = new /icon('icons/mob/human_races/r_skeleton.dmi', "[icon_name][gender ? "_[gender]" : ""]")
			else if (status & ORGAN_ROBOT && !force_skintone)
				mob_icon = new /icon('icons/mob/human_races/ipc/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")
			else
				if (status & ORGAN_MUTATED)
					mob_icon = new /icon(species.deform, "[icon_name][gender ? "_[gender]" : ""]")
				else
					mob_icon = new /icon(species.icobase, "[icon_name][gender ? "_[gender]" : ""]")

				if(status & ORGAN_DEAD)
					mob_icon.ColorTone(rgb(10,50,0))
					mob_icon.SetIntensity(0.7)

				if(skin_color)
					mob_icon.Blend(skin_color, ICON_ADD)

				if(!isnull(s_tone))
					if(s_tone >= 0)
						mob_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
					else
						mob_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)


			apply_markings()
			get_internal_organs_overlay()

			if(body_hair)
				var/list/limb_icon_cache = SSicon_cache.limb_icons_cache
				var/cache_key = "[body_hair]-[icon_name]-[hair_color]"
				if(!limb_icon_cache[cache_key])
					var/icon/I = icon(species.icobase, "[icon_name]_[body_hair]")
					I.Blend(hair_color, ICON_ADD)
					limb_icon_cache[cache_key] = I
				mob_icon.Blend(limb_icon_cache[cache_key], ICON_OVERLAY)
				icon_cache_key = cache_key

	icon = mob_icon

	return mob_icon

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// This is NOT safe for caching the organ's own icon, it's only meant to be used for the mob icon cache.
/obj/item/organ/external/proc/get_mob_cache_key()
	var/list/keyparts = list()
	if (is_stump())
		keyparts += "stump"
	else if (status & ORGAN_ROBOT)
		keyparts += "robot:[model || "nomodel"]"
	else if (status & ORGAN_DEAD)
		keyparts += "dead"
	else
		keyparts += "norm"

	keyparts += "[species.race_key]"
	keyparts += "[dna.GetUIState(DNA_UI_GENDER)]"
	keyparts += "[dna.GetUIValue(DNA_UI_SKIN_TONE)]"
	if (skin_color)
		keyparts += "[skin_color]"
	if (body_hair && hair_color)
		keyparts += "[hair_color]"

	if (!cached_markings)
		update_marking_cache()

	for (var/marking in cached_markings)
		keyparts += "[marking][cached_markings[marking]["color"]]"

	for(var/obj/item/organ/internal/O in internal_organs)
		if(O.on_mob_icon)
			keyparts += "[O.on_mob_icon]-[O.icon_state]"

	. = keyparts.Join("_")

/obj/item/organ/external/proc/update_marking_cache()
	if (LAZYLEN(genetic_markings))
		LAZYADD(cached_markings, genetic_markings)
	if (LAZYLEN(temporary_markings))
		LAZYADD(cached_markings, temporary_markings)

// Global scope, used in code below.
var/list/flesh_hud_colours = list("#00ff00","#aaff00","#ffff00","#ffaa00","#ff0000","#aa0000","#660000")
var/list/robot_hud_colours = list("#ffffff","#cccccc","#aaaaaa","#888888","#666666","#444444","#222222","#000000")

/obj/item/organ/external/proc/get_damage_hud_image()

	// Generate the greyscale base icon and cache it for later.
	// icon_cache_key is set by any get_icon() calls that are made.
	// This looks convoluted, but it's this way to avoid icon proc calls.
	var/list/limb_icon_cache = SSicon_cache.limb_icons_cache
	if(!hud_damage_image)
		var/cache_key = "dambase-[icon_cache_key]"
		if(!icon_cache_key || !limb_icon_cache[cache_key])
			limb_icon_cache[cache_key] = icon(get_icon(), null, SOUTH)
		var/image/temp = image(limb_icon_cache[cache_key])
		if(species)
			// Calculate the required colour matrix.
			var/r = 0.30 * species.health_hud_intensity
			var/g = 0.59 * species.health_hud_intensity
			var/b = 0.11 * species.health_hud_intensity
			temp.color = list(r, r, r, g, g, g, b, b, b)
		hud_damage_image = image(null)
		hud_damage_image.overlays += temp

	// Calculate the required color index.
	var/dam_state = min(1,((brute_dam+burn_dam)/max(1,max_damage)))
	var/min_dam_state = min(1,(get_pain()/max(1,max_damage)))
	if(min_dam_state && dam_state < min_dam_state)
		dam_state = min_dam_state
	// Apply colour and return product.
	var/list/hud_colours = !BP_IS_ROBOTIC(src) ? flesh_hud_colours : robot_hud_colours
	hud_damage_image.color = hud_colours[max(1,min(Ceiling(dam_state*hud_colours.len),hud_colours.len))]
	return hud_damage_image
