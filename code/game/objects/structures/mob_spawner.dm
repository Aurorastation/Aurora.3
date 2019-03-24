/obj/structure/mob_spawner
	name = "cryogenic storage pod"
	desc = "A pod used to store individual in suspended animation"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	var/used_icon = "sleeper_0"
	var/used = FALSE
	var/list/possible_mob_species = list("Human")
	var/oufit
	var/mob_name
	var/list/possible_mob_gender = list(MALE, FEMALE)
	var/pick_name = TRUE
	var/welcome_message = "You are nothing but a stranger in a strange land."
	var/announce_when_created = TRUE

/obj/structure/mob_spawner/Initialize()
	. = ..()
	if(announce_when_created)
		for(var/mob/abstract/observer/O in player_list)
			if(!O.MayRespawn())
				continue
			if(O.client)
				var/area/A = get_area(src)
				to_chat(O, "[ghost_follow_link(src, O)] <span class='deadsay'><font size=3><b>A [src.name] has been created at \the [A].</a></b></font></span>")

/obj/structure/mob_spawner/examine(mob/user)
	if(..(user, 1) && used)
		to_chat(user, "It is empty.")

/obj/structure/mob_spawner/attack_ghost(mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(src, span("alert", "The game hasn't started yet!"))
		return

	if(used)
		to_chat(user, "<span class='warning'>This spawner has been used already!</span>")
		return

	var/choice = alert(user, "Would you like to use this spawner?","Mob Spawner", "Yes", "No")

	if(choice == "Yes")
		create_mob(user.key)

/obj/structure/mob_spawner/update_icon()
	if(used)
		icon_state = used_icon
	else
		icon_state = initial(icon_state)

/obj/structure/mob_spawner/proc/create_mob(ckey)
	if(used)
		return

	used = TRUE
	update_icon()
	var/mob/living/carbon/human/H = new(get_turf(src))
	H.key = ckey
	H.change_gender(pick(possible_mob_gender))
	H.set_species(pick(possible_mob_species))

	if(oufit)
		H.preEquipOutfit(oufit,FALSE)
		H.equipOutfit(oufit,FALSE)

	var/newname
	if(pick_name)
		newname = sanitizeSafe(input(H,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
		if(!newname || newname == "")
			newname = get_mob_name(H)
		H.fully_replace_character_name(H.real_name,newname)
	else
		newname = get_mob_name(H)

	H.fully_replace_character_name(H.real_name,newname)

	to_chat(H, welcome_message)

	finish_mob(H)

/obj/structure/mob_spawner/proc/get_mob_name(var/mob/living/carbon/human/target)
	if(name)
		return mob_name
	else
		return target.species.get_random_name(target.gender)

/obj/structure/mob_spawner/proc/finish_mob(var/mob/living/carbon/human/target)
	target.change_appearance(APPEARANCE_ALL_HAIR | APPEARANCE_SKIN | APPEARANCE_EYE_COLOR, target.loc, target)