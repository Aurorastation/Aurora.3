datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/randomize_appearance_for(var/mob/living/carbon/human/H)
		if(H)
			if(H.gender == MALE)
				gender = MALE
			else
				gender = FEMALE
		s_tone = random_skin_tone()
		h_style = random_hair_style(gender, species)
		f_style = random_facial_hair_style(gender, species)
		randomize_hair_color("hair")
		randomize_hair_color("facial")
		randomize_eyes_color()
		randomize_skin_color()
		underwear = rand(1,underwear_m.len)
		undershirt = rand(1,undershirt_t.len)
		backbag = 2
		age = rand(AGE_MIN,AGE_MAX)
		if(H)
			copy_to(H,1)


	proc/randomize_hair_color(var/target = "hair")
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

	proc/randomize_eyes_color()
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

	proc/randomize_skin_color()
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

		r_skin = red
		g_skin = green
		b_skin = blue

	proc/job_type_info()
		var/job_type=null
		var/job_index=null
		if (job_civilian_high)
			job_type="[CIVILIAN]"
			job_index="[job_civilian_high]"
		if (job_engsec_high)
			job_type="[ENGSEC]"
			job_index="[job_engsec_high]"
		if (job_medsci_high)
			job_type="[MEDSCI]"
			job_index="[job_medsci_high]"
		if (!job_type)
			job_type="DEFAULT"
			job_index=1
		return list(job_type,job_index)

	proc/update_preview_icon(var/rem_floor = 0) //this is a little better - jf
		qdel(preview_icon_front)
		qdel(preview_icon_side)
		qdel(preview_icon)
		var/datum/species/current_species = all_species[species]
		if(!current_species) // no species? no preview for you
			return
		if(!rem_floor)
			preview_icon = new/icon("icons/turf/floors.dmi","floor")
			preview_icon.Blend(current_species.create_body_preview_icon(src),ICON_OVERLAY) // create the body icon
		else
			preview_icon = new/icon(current_species.create_body_preview_icon(src),ICON_OVERLAY) // create the body icon
		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon('icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)
		if (current_species.flags & HAS_UNDERWEAR) // do we even need to handle underwear?
			if(underwear > 0 && underwear < 7)
				preview_icon.Blend(new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "underwear[underwear]_[(gender==FEMALE) ? "f" : "m"]_s"),ICON_OVERLAY)
			if(undershirt > 0 && undershirt < 16)
				preview_icon.Blend(new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "undershirt[undershirt]_s"),ICON_OVERLAY)
		var/list/job_types=job_type_info()
		var/datum/preview/job/current_job=get_job_preview_for_index(job_types[1],job_types[2])
		if(istype(current_job))
			preview_icon.Blend(current_job.create_clothes_icon(backbag), ICON_OVERLAY)
		preview_icon_front = new(preview_icon, dir = SOUTH)
		preview_icon_side = new(preview_icon, dir = WEST)
