/obj/structure/mob_spawner/pra
	name = "republican cryogenic storage pod"
	desc = "A pod used to store republican soldiers in suspended animation."
	possible_mob_species = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	oufit = /datum/outfit/admin/republican_soldier
	pick_name = FALSE
	welcome_message = "You are a soldier of the Republican Army, listen to your commander and complete your mission."

/obj/structure/mob_spawner/pra/finish_mob(var/mob/living/carbon/human/target)
	var/final_color
	if(target.species.name == "M'sai Tajara")
		var/fur_color = pick("Silver", "Wheat", "Ivory")
		switch(fur_color)

			if("Silver")
				final_color = "#C0C0C0"

			if("Wheat")
				final_color = "#CDBA96"

			if("Ivory")
				final_color = "#CDCDC0"

	if(target.species.name == "Zhan-Khazan Tajara")
		var/fur_color = pick("Grey", "Chocolate", "Black")
		switch(fur_color)

			if("Grey")
				final_color = "#1E1E1E"

			if("Chocolate")
				final_color = "#5E2612"

			if("Black")
				final_color = "#000000"

	if(target.species.name == "Tajara")
		var/fur_color = pick("Kochiba", "Taupe", "Ruddy", "Orange")
		switch(fur_color)

			if("Kochiba")
				final_color = "#6B4423"

			if("Taupe")
				final_color = "#483C32"

			if("Ruddy")
				final_color = "#8A360F"

			if("Orange")
				final_color = "#EE4000"

	target.r_skin = hex2num(copytext(final_color,2,4))
	target.g_skin = hex2num(copytext(final_color,4,6))
	target.b_skin = hex2num(copytext(final_color,6,8))

	target.r_hair = hex2num(copytext(final_color,2,4))
	target.g_hair = hex2num(copytext(final_color,4,6))
	target.b_hair = hex2num(copytext(final_color,6,8))

	target.update_dna()
	target.regenerate_icons()
	target.update_body()
	target.update_hair()

	target.change_appearance(APPEARANCE_ALL_HAIR | APPEARANCE_EYE_COLOR, target.loc, target)


/obj/structure/mob_spawner/pra/commander
	oufit = /datum/outfit/admin/republican_soldier/commander
	welcome_message = "You are a commander of the Republican Army, lead your soldiers to victory and complete your mission."
	possible_mob_species = list("Tajara", "M'sai Tajara")

/obj/structure/mob_spawner/traveller
	name = "traveller cryogenic storage pod"
	desc = "A pod used to store travellers in suspended animation."
	oufit = /datum/outfit/admin/traveller
	welcome_message = "You are travelling the lands of Adhomai, your reasons and objectives are up for you to decide."

/obj/structure/mob_spawner/traveller/finish_mob(var/mob/living/carbon/human/target)
	target.change_appearance(APPEARANCE_ALL, target.loc, check_species_whitelist = 1)