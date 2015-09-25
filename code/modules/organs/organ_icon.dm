var/global/list/limb_icon_cache = list()

/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.mob_icon
		overlays += organ.mob_icon

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	s_tone = null
	s_col = null
	if(status & ORGAN_ROBOT)
		return
	if(!isnull(human.s_tone) && (human.species.flags & HAS_SKIN_TONE))
		s_tone = human.s_tone
	if(human.species.flags & HAS_SKIN_COLOR)
		s_col = list(human.r_skin, human.g_skin, human.b_skin)

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/eyes/eyes = owner.internal_organs_by_name["eyes"]
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/removed()
	get_icon()
	..()

/obj/item/organ/external/head/get_icon()
	..()
	overlays.Cut()
	if(!owner || !owner.species)
		return
	var/icon/eyes_icon = owner.eye_icon()
	if(eyes_icon)
		mob_icon.Blend(eyes_icon, ICON_OVERLAY)
		overlays |= eyes_icon
	
	if(owner.lip_style && (owner.species && (owner.species.flags & HAS_LIPS)))
		var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips_[owner.lip_style]_s")
		if(lip_icon)
			overlays |= lip_icon
			mob_icon.Blend(lip_icon, ICON_OVERLAY)

	var/icon/facial_hair_icon = owner.facial_hair_icon()
	if(facial_hair_icon)
		mob_icon.Blend(facial_hair_icon, ICON_OVERLAY)
		overlays |= facial_hair_icon

	if(owner.should_we_show_hair())
		var/icon/hair_icon = owner.hair_icon()
		if(hair_icon)
			mob_icon.Blend(hair_icon, ICON_OVERLAY)
			overlays |= hair_icon
			
	return mob_icon

/obj/item/organ/external/proc/get_icon(var/skeletal)


	var/gender
	if(force_icon)
		mob_icon = new /icon(force_icon, "[icon_name]")
	else
		if(!owner)
			mob_icon = new /icon('icons/mob/human_races/r_human.dmi', "[icon_name][gendered_icon ? "_f" : ""]")
		else

			if(gendered_icon)
				if(owner.gender == FEMALE)
					gender = "f"
				else
					gender = "m"

			if(skeletal)
				mob_icon = new /icon('icons/mob/human_races/r_skeleton.dmi', "[icon_name][gender ? "_[gender]" : ""]")
			else if (status & ORGAN_ROBOT)
				mob_icon = get_synthetic_icon()
			else
				if (status & ORGAN_MUTATED)
					mob_icon = new /icon(owner.species.deform, "[icon_name][gender ? "_[gender]" : ""]")
				else
					mob_icon = new /icon(owner.species.icobase, "[icon_name][gender ? "_[gender]" : ""]")

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

	dir = EAST
	icon = mob_icon

	return mob_icon

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return TRUE
	if (covering) // check to see if we lose the covering
		if (covering.coverage==SYNTHETIC_COVERING_WORKING)
			if (!can_take_covering()) // if your limbs get badly damaged you lose the covering
				covering.coverage = SYNTHETIC_COVERING_DAMAGED
				owner.update_body(TRUE)
				return TRUE
	return FALSE

	
/obj/item/organ/external/proc/valid_covering()
	if (status & ORGAN_ROBOT)
		if (covering) 
			return (covering.coverage) // is our covering working?
		return FALSE // if we have no covering at all 
	return TRUE // squishies always have skin
	

/obj/item/organ/external/proc/get_synthetic_icon_key()
	if (!covering) // no covering at all, this should not happen
		return "R" // regular old robot
	return covering.get_icon_key()
	
		
/obj/item/organ/external/proc/get_synthetic_icon()
	if (!covering) // no covering at all, this should not happen
		return new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][get_gender_string()]")
	return covering.get_icon()
	
	
/obj/item/organ/external/proc/get_gender_string()
	if (!gendered_icon) // most organs aren't gender specific
		return ""
	if (owner) // if we're a gender specific organ with an owner
		return (owner.gender == FEMALE ? "_f" : "_m")
	return "_f"

	
/obj/item/organ/external/proc/get_icon_key()
	if (status & ORGAN_DESTROYED)
		return "L" // l for lost
	if (status & ORGAN_DEAD)
		return "D" // d for dead
	if (status & ORGAN_ROBOT)
		return get_synthetic_icon_key()
	return "G" // regular old limb
