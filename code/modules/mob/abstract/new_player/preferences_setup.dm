/datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H

/datum/preferences/proc/randomize_appearance_for(var/mob/living/carbon/human/H, var/random_gender=TRUE, var/list/culture_restriction = list(), var/list/origin_restriction = list())
	if(random_gender)
		gender = pick(MALE, FEMALE)
	else
		gender = H.gender
	var/datum/species/current_species = GLOB.all_species[species]

	if(current_species)
		if(current_species.appearance_flags & HAS_SKIN_TONE)
			s_tone = random_skin_tone()
		if(current_species.appearance_flags & HAS_EYE_COLOR)
			randomize_eyes_color()
		if(current_species.appearance_flags & HAS_SKIN_COLOR)
			randomize_skin_color(current_species)

	tail_style = length(current_species.selectable_tails) ? pick(current_species.selectable_tails) : null
	h_style = random_hair_style(gender, species)
	f_style = random_facial_hair_style(gender, species)
	randomize_hair_color("hair")
	randomize_hair_color("facial")

	backbag = 2
	pda_choice = 2
	age = rand(getMinAge(),getMaxAge())
	if(length(culture_restriction))
		H.set_culture(GET_SINGLETON(pick(culture_restriction)))
	if(length(origin_restriction))
		for(var/O in origin_restriction)
			if(O in culture_restriction)
				H.set_origin(GET_SINGLETON(O))
				break
		if(!H.origin)
			crash_with("Invalid origin restrictions [english_list(origin_restriction)] for culture restrictions [english_list(culture_restriction)]!")
	if(H)
		copy_to(H,1)

/datum/preferences/proc/randomize_hair_color(var/target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

/datum/preferences/proc/randomize_skin_color(var/datum/species/current_species)
	var/red
	var/green
	var/blue

	if(current_species && current_species.appearance_flags & HAS_SKIN_PRESET)
		var/hex = pick(current_species.character_color_presets)
		r_skin = GetRedPart(hex)
		g_skin = GetGreenPart(hex)
		b_skin = GetBluePart(hex)
		return

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue


/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/mannequin)
	copy_to(mannequin)

	if(!equip_preview_mob)
		return

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	previewJob = return_chosen_high_job()

	if(previewJob)
		mannequin.job = previewJob.title

		var/list/leftovers = list()
		var/list/used_slots = list()

		if((equip_preview_mob & EQUIP_PREVIEW_LOADOUT) && !(previewJob && (equip_preview_mob & EQUIP_PREVIEW_JOB) && (previewJob.type == /datum/job/ai || previewJob.type == /datum/job/cyborg)))
			SSjobs.EquipCustom(mannequin, previewJob, src, leftovers, null, used_slots)

		if((equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob)
			previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title], faction)

		if(equip_preview_mob & EQUIP_PREVIEW_LOADOUT && leftovers.len)
			SSjobs.EquipCustomDeferred(mannequin, src, leftovers, used_slots)

		if (!SSATOMS_IS_PROBABLY_DONE)
			SSatoms.CreateAtoms(list(mannequin))
			mannequin.regenerate_icons()
		else
			mannequin.update_icon()

/datum/preferences/proc/return_chosen_high_job(var/title = FALSE)
	var/datum/job/chosenJob
	if(!SSjobs.initialized)
		return

	if(job_civilian_low & ASSISTANT)
		// Assistant is weird, has to be checked first because it overrides
		chosenJob = SSjobs.bitflag_to_job["[SERVICE]"]["[job_civilian_low]"]
	else if(job_civilian_high)
		chosenJob = SSjobs.bitflag_to_job["[SERVICE]"]["[job_civilian_high]"]
	else if(job_medsci_high)
		chosenJob = SSjobs.bitflag_to_job["[MEDSCI]"]["[job_medsci_high]"]
	else if(job_engsec_high)
		chosenJob = SSjobs.bitflag_to_job["[ENGSEC]"]["[job_engsec_high]"]

	if(istype(chosenJob) && title)
		return chosenJob.title
	return chosenJob

/datum/preferences/proc/update_mannequin()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = SSmobs.get_mannequin(client.ckey)
	mannequin.delete_inventory(TRUE)
	mannequin.species.create_organs(mannequin)
	if(gender)
		mannequin.change_gender(gender)
	dress_preview_mob(mannequin)
	return mannequin

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = update_mannequin()
	var/mutable_appearance/MA = new /mutable_appearance(mannequin)
	MA.appearance_flags = PIXEL_SCALE
	if(mannequin.species?.icon_x_offset)
		MA.pixel_x = mannequin.species.icon_x_offset
	if(mannequin.species?.icon_y_offset)
		MA.pixel_y = mannequin.species.icon_y_offset
	var/matrix/M = matrix()
	M.Scale(scale_x, scale_y)
	MA.transform = M
	update_character_previews(MA, (MA.pixel_x != 0 || MA.pixel_y != 0))
