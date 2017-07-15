/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				add_overlay(child.mob_icon)

		overlays |= organ.mob_icon

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	s_tone = null
	s_col = null
	h_col = null
	if(status & ORGAN_ROBOT && !(isipc(human)))
		return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_SKIN_TONE))
		s_tone = human.s_tone
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		s_col = list(human.r_skin, human.g_skin, human.b_skin)
	h_col = list(human.r_hair, human.g_hair, human.b_hair)

/obj/item/organ/external/proc/sync_colour_to_dna()
	s_tone = null
	s_col = null
	h_col = null
	if(status & ORGAN_ROBOT && !force_skintone)
		return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_SKIN_TONE))
		s_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		s_col = list(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))
	h_col = list(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/eyes/eyes
	if (species.vision_organ)
		eyes = owner.internal_organs_by_name[species.vision_organ]
	else
		eyes = owner.internal_organs_by_name["eyes"]

	if(eyes)
		eyes.update_colour()

/obj/item/organ/external/head/removed()
	get_icon()
	..()

/obj/item/organ/external/head/get_icon()
	..()
	overlays.Cut()
	if(!owner || !owner.species)
		return
	if(owner.species.has_organ["eyes"] || (owner.species.vision_organ && owner.species.has_organ[species.vision_organ]))
		var/obj/item/organ/eyes/eyes = owner.internal_organs_by_name["eyes"] || owner.internal_organs_by_name[species.vision_organ]
		if(eyes && species.eyes)
			var/icon/eyes_icon = new/icon('icons/mob/human_face.dmi', species.eyes)
			if(eyes)
				eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
			else
				eyes_icon.Blend(rgb(128,0,0), ICON_ADD)
			mob_icon.Blend(eyes_icon, ICON_OVERLAY)
			overlays |= eyes_icon

	if(owner.lip_style && (species && (species.appearance_flags & HAS_LIPS)))
		var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips_[owner.lip_style]_s")
		overlays |= lip_icon
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		var/m_color = markings[M]["color"]
		var/cache_key = "[mark_style.icon]-[mark_style.icon_state]-[limb_name]-[m_color]"

		var/icon/finished_icon = SSicon_cache.markings_cache[cache_key]
		if (!finished_icon)
			finished_icon = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[limb_name]")
			finished_icon.Blend(m_color, ICON_ADD)
			SSicon_cache.markings_cache[cache_key] = finished_icon

		add_overlay(finished_icon) //So when it's not on your body, it has icons
		mob_icon.Blend(finished_icon, ICON_OVERLAY) //So when it's on your body, it has icons

	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype() in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)
			overlays |= facial_s

	if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
		if(hair_style && (species.get_bodytype() in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration && islist(h_col) && h_col.len >= 3)
				hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), ICON_ADD)
			overlays |= hair_s

	return mob_icon

/obj/item/organ/external/proc/get_icon(var/skeletal)

	var/gender = "f"
	if(owner && owner.gender == MALE)
		gender = "m"

	if(force_icon)
		mob_icon = new /icon(force_icon, "[icon_name][gendered_icon ? "_[gender]" : ""]")
		if(painted)
			if(s_col && s_col.len >= 3)
				mob_icon.Blend(rgb(s_col[1], s_col[2], s_col[3]), ICON_ADD)
	else
		if(!dna)
			mob_icon = new /icon('icons/mob/human_races/r_human.dmi', "[icon_name][gendered_icon ? "_[gender]" : ""]")
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
				mob_icon = new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")
			else
				if (status & ORGAN_MUTATED)
					mob_icon = new /icon(species.deform, "[icon_name][gender ? "_[gender]" : ""]")
				else
					mob_icon = new /icon(species.icobase, "[icon_name][gender ? "_[gender]" : ""]")

				if(status & ORGAN_DEAD)
					mob_icon.ColorTone(rgb(10,50,0))
					mob_icon.SetIntensity(0.7)

				if(!isnull(s_tone))
					if(s_tone >= 0)
						mob_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
					else
						mob_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
				else if(s_col && s_col.len >= 3)
					mob_icon.Blend(rgb(s_col[1], s_col[2], s_col[3]), ICON_ADD)

			//Body markings, does not include head, duplicated (sadly) above.
			for(var/M in markings)
				var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
				var/m_color = markings[M]["color"]
				var/cache_key = "[mark_style.icon]-[mark_style.icon_state]-[limb_name]-[m_color]"

				var/icon/finished_icon = SSicon_cache.markings_cache[cache_key]
				if (!finished_icon)
					finished_icon = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[limb_name]")
					finished_icon.Blend(m_color, ICON_ADD)
					SSicon_cache.markings_cache[cache_key] = finished_icon

				add_overlay(finished_icon) //So when it's not on your body, it has icons
				mob_icon.Blend(finished_icon, ICON_OVERLAY) //So when it's on your body, it has icons

			if(body_hair && islist(h_col) && h_col.len >= 3)
				var/list/limb_icon_cache = SSicon_cache.body_hair_cache
				var/cache_key = "[body_hair]-[icon_name]-[h_col[1]][h_col[2]][h_col[3]]"
				if(!limb_icon_cache[cache_key])
					var/icon/I = icon(species.icobase, "[icon_name]_[body_hair]")
					I.Blend(rgb(h_col[1],h_col[2],h_col[3]), ICON_ADD)
					limb_icon_cache[cache_key] = I
				mob_icon.Blend(limb_icon_cache[cache_key], ICON_OVERLAY)

	dir = EAST
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
