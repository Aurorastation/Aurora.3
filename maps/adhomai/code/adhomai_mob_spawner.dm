/obj/structure/mob_spawner/pra
	name = "republican cryogenic storage pod"
	desc = "A pod used to store republican soldiers in suspended animation."
	possible_mob_species = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	oufit = /datum/outfit/admin/republican_soldier
	pick_name = FALSE
	welcome_message = "You are a soldier of the Republican Army, listen to your commander and complete your mission."

/obj/structure/mob_spawner/pra/finish_mob(var/mob/living/carbon/human/target)
	var/red
	var/green
	var/blue

	if(target.species.name == "M'sai Tajara")
		var/fur_color = pick("Silver", "Wheat", "Ivory")
		switch(fur_color)

			if("Silver")
				red = 192
				green = 192
				blue = 192

			if("Wheat")
				red = 205
				green = 186
				blue = 150

			if("Ivory")
				red = 205
				green = 205
				blue = 192

	if(target.species.name == "Zhan-Khazan Tajara")
		var/fur_color = pick("Grey", "Chocolate", "Black")
		switch(fur_color)

			if("Grey")
				red = 30
				green = 30
				blue = 30

			if("Chocolate")
				red = 94
				green = 38
				blue = 18

			if("Black")
				red = 0
				green = 0
				blue = 0

	if(target.species.name == "Tajara")
		var/fur_color = pick("Kochiba", "Taupe", "Ruddy", "Orange")
		switch(fur_color)

			if("Kochiba")
				red = 107
				green = 68
				blue =  35

			if("Taupe")
				red = 72
				green = 60
				blue = 50

			if("Ruddy")
				red = 138
				green = 54
				blue = 15

			if("Orange")
				red = 238
				green = 64
				blue = 0

	target.change_skin_color(red, green, blue)
	target.change_hair_color(red, green, blue)
	target.change_facial_hair_color(red, green, blue)
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