/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/mob/user = src, var/check_species_whitelist = TRUE, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/list/culture_restriction = list(), var/list/origin_restriction = list(), var/datum/ui_state/ui_state = GLOB.always_state, var/datum/state_object = src, var/update_id = FALSE)
	var/datum/tgui_module/appearance_changer/AC = new /datum/tgui_module/appearance_changer(src, check_species_whitelist, species_whitelist, species_blacklist, culture_restriction, origin_restriction, ui_state, state_object, update_id)
	AC.flags = flags
	AC.ui_interact(user)

/mob/living/carbon/human/proc/change_species(var/new_species)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in GLOB.all_species))
		return

	set_species(new_species)
	reset_hair()
	if(isipc(src))
		var/obj/item/organ/internal/ipc_tag/tag = internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data(TRUE)
	return 1

/mob/living/carbon/human/proc/change_gender(var/set_gender, var/ignore_gender_check = FALSE)
	if(gender == set_gender && !ignore_gender_check)
		return

	gender = set_gender
	pronouns = gender
	dna.SetUIState(DNA_UI_GENDER, gender != MALE, 1)
	reset_hair()
	update_body()
	species.create_organs(src)
	return 1

/mob/living/carbon/human/proc/change_hair(var/hair_style)
	if(!hair_style)
		return

	if(h_style == hair_style)
		return

	if(!(hair_style in GLOB.hair_styles_list))
		return

	h_style = hair_style

	update_hair()
	return 1

/**
 * Sets gradient style and updates hair overlay
 */
/mob/living/carbon/human/proc/change_gradient(var/gradient)
	if(!gradient)
		return

	if(g_style == gradient)
		return

	if(!(gradient in GLOB.hair_gradient_styles_list))
		return

	g_style = gradient

	update_hair()
	return TRUE

/mob/living/carbon/human/proc/change_facial_hair(var/facial_hair_style)
	if(!facial_hair_style)
		return

	if(f_style == facial_hair_style)
		return

	if(!(facial_hair_style in GLOB.facial_hair_styles_list))
		return

	f_style = facial_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = generate_valid_hairstyles()
	var/list/valid_facial_hairstyles = generate_valid_facial_hairstyles()

	if(length(valid_hairstyles))
		h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		h_style = "Bald"

	if(length(valid_facial_hairstyles))
		f_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		f_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(var/red, var/green, var/blue)
	if(red == r_eyes && green == g_eyes && blue == b_eyes)
		return

	r_eyes = red
	g_eyes = green
	b_eyes = blue

	update_eyes()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_hair_color(var/red, var/green, var/blue)
	if(red == r_hair && green == g_hair && blue == b_hair)
		return

	r_hair = red
	g_hair = green
	b_hair = blue

	force_update_limbs()
	update_body()
	update_hair()
	return 1

/**
 * Sets gradient colour and updates sprite
 */
/mob/living/carbon/human/proc/change_gradient_color(var/red, var/green, var/blue)
	if(red == r_grad && green == g_grad && blue == b_grad)
		return

	r_grad = red
	g_grad = green
	b_grad = blue

	force_update_limbs()
	update_body()
	update_hair()
	return TRUE

/mob/living/carbon/human/proc/change_facial_hair_color(var/red, var/green, var/blue)
	if(red == r_facial && green == g_facial && blue == b_facial)
		return

	r_facial = red
	g_facial = green
	b_facial = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_skin_color(var/red, var/green, var/blue)
	if((red == r_skin && green == g_skin && blue == b_skin) || (!(species.appearance_flags & HAS_SKIN_COLOR) && !(species.appearance_flags & HAS_SKIN_PRESET)))
		return

	r_skin = red
	g_skin = green
	b_skin = blue

	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_skin_tone(var/tone)
	if(s_tone == tone || !(species.appearance_flags & HAS_SKIN_TONE))
		return

	s_tone = tone

	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/update_dna()
	check_dna()
	dna.ready_dna(src)

/mob/living/carbon/human/proc/change_limb(var/limb, var/company)
	var/obj/item/organ/external/target = organs_by_name[limb]
	if(limb == BP_HEAD || limb == BP_CHEST || limb == BP_GROIN) //don't want to robotize or delete head/torso if this somehow happens
		return
	if(company == "Normal" || !target || target.species == GLOB.all_species["Nymph Limb"]) //If they're missing the limb, create a new one so it can be transformed properly. We also need to redo this here if they're editing a nymph limb to properly remove it.
		species.create_organs(src)
		remove_verb(src, /mob/living/carbon/human/proc/detach_nymph_limb) //this resets organs, so we can remove this here. if we don't we get funny stuff like being able to detach non-nymph arms or the verb just sticks around

	if(company == "Amputated")
		organs_by_name[limb] = null
		organs -= target
		if(target.children) // This might need to become recursive.
			for(var/obj/item/organ/external/child in target.children)
				organs_by_name[child.limb_name] = null
				organs -= child

	if(company == "Diona Nymph") //special snowflake code for diona limbs go brrr
		target.AddComponent(/datum/component/nymph_limb)
		var/datum/component/nymph_limb/D = target.GetComponent(/datum/component/nymph_limb)
		if(D)
			D.nymphize(src, target.limb_name, TRUE)

	else
		target.robotize(company)

	force_update_limbs()
	updatehealth()
	update_body()
	return TRUE

/mob/living/carbon/human/proc/change_organ(var/organ_tag, var/modification)
	var/obj/item/organ/internal/target = internal_organs_by_name[organ_tag]
	if(istype(target))
		switch(modification)
			if("Assisted")
				target.mechassist()
			if("Mechanical")
				target.robotize()
			if("Removed")
				qdel(target)
	update_body()
	return TRUE

/mob/living/carbon/human/proc/generate_valid_prosthetics()
	var/list/valid_prosthetics = PROSTHETICS_UNRESTRICTED
	if(species.valid_prosthetics)
		valid_prosthetics.Add(species.valid_prosthetics)
	return valid_prosthetics

/mob/living/carbon/human/proc/generate_valid_limbs()
	var/list/valid_limbs = list()
	for(var/L in BP_ALL_LIMBS)
		if(L != BP_CHEST && L != BP_HEAD && L != BP_GROIN)
			valid_limbs += parse_zone(L) //turn it into actual text for the selection
	return valid_limbs

/mob/living/carbon/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
	var/list/valid_species = new()
	for(var/current_species_name in GLOB.all_species)
		var/datum/species/current_species = GLOB.all_species[current_species_name]

		if(check_whitelist && GLOB.config.usealienwhitelist && !check_rights(R_ADMIN, 0, src)) //If we're using the whitelist, make sure to check it!
			if(!(current_species.spawn_flags & CAN_JOIN))
				continue
			if(whitelist.len && !(current_species_name in whitelist))
				continue
			if(blacklist.len && (current_species_name in blacklist))
				continue
			if((current_species.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, current_species_name))
				continue

		valid_species += current_species_name

	return valid_species

/mob/living/carbon/human/proc/generate_valid_hairstyles(var/check_gender = 1)
	var/list/valid_hairstyles = new()
	if(species.bald)
		return valid_hairstyles
	for(var/hairstyle in GLOB.hair_styles_list)
		var/datum/sprite_accessory/S = GLOB.hair_styles_list[hairstyle]

		if(check_gender && gender == MALE && S.gender == FEMALE)
			continue
		if(check_gender && gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.type in S.species_allowed))
			continue

		valid_hairstyles += hairstyle

	return valid_hairstyles

/**
 * Returns a list of all valid gradient styles for this mob
 */
/mob/living/carbon/human/proc/generate_valid_gradients()
	var/list/valid_gradient_styles = list()
	if(species.bald)
		return valid_gradient_styles
	for(var/gradient in GLOB.hair_gradient_styles_list)
		var/datum/sprite_accessory/S = GLOB.hair_gradient_styles_list[gradient]

		if(!(species.type in S.species_allowed))
			continue

		valid_gradient_styles += gradient
	return valid_gradient_styles

/mob/living/carbon/human/proc/generate_valid_facial_hairstyles()
	var/list/valid_facial_hairstyles = new()
	if(species.bald)
		return valid_facial_hairstyles
	for(var/facialhairstyle in GLOB.facial_hair_styles_list)
		var/datum/sprite_accessory/S = GLOB.facial_hair_styles_list[facialhairstyle]

		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.type in S.species_allowed))
			continue

		valid_facial_hairstyles += facialhairstyle

	return valid_facial_hairstyles

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in organs)
		O.sync_colour_to_human(src)
	update_body(2)//Forces new icon generation
