proc/valid_sprite_accessories(gender,species,test_list)
	var/list/valid = list()
	for(var/style in test_list)
		var/datum/sprite_accessory/S = test_list[style]
		if( !(species in S.species_allowed))
			continue
		if (S.gender!=NEUTER)
			if (S.gender!=gender)
				continue
		valid[style] = S
	return valid
	

proc/get_valid_hairstyles(gender, species)
	return valid_sprite_accessories(gender,species,hair_styles_list)
	
	
proc/get_valid_facialhairstyles(gender, species)
	return valid_sprite_accessories(gender,species,facial_hair_styles_list)


proc/random_hair_style(gender, species)
	var/h_style = "Bald"
	if (species)
		var/list/valid_hairstyles = get_valid_hairstyles(gender,species)
		if(valid_hairstyles.len)
			h_style = pick(valid_hairstyles)
	return h_style
	

proc/random_facial_hair_style(gender, species)
	var/f_style = "Shaved"
	if (species)
		var/list/valid_facialhairstyles = get_valid_facialhairstyles(gender,species)
		if(valid_facialhairstyles.len)
			f_style = pick(valid_facialhairstyles)
	return f_style
	

proc/random_name(gender, species = "Human")

	var/datum/species/current_species
	if(species)
		current_species = all_species[species]

	if(!current_species || current_species.name == "Human")
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return current_species.get_random_name(gender)

proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"
	return "0"

/*
Proc for attack log creation, because really why not
1 argument is the actor
2 argument is the target of action
3 is the description of action(like punched, throwed, or any other verb)
4 should it make adminlog note or not
5 is the tool with which the action was made(usually item)					5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
6 is additional information, anything that needs to be added
*/

/proc/add_logs(mob/user, mob/target, what_done, var/admin=1, var/object=null, var/addition=null)
	if(user && ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(target && ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(admin)
		log_attack("<font color='red'>[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] [what_done] [target ? "[target.name][(ismob(target) && target.ckey)? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")

//checks whether this item is a module of the robot it is located in.
/proc/is_robot_module(var/obj/item/thing)
	if (!thing || !istype(thing.loc, /mob/living/silicon/robot))
		return 0
	var/mob/living/silicon/robot/R = thing.loc
	return (thing in R.module.modules)


/proc/this_guy_is_allowed_to_drag_that_guy_into_something(atom/movable/target as mob|obj, mob/user as mob, obj/target_object as obj)
	if(istype(target, /obj/screen))	//fix for HUD elements making their way into the world - Pete
		return
	if(target.loc == user) //no you can't pull things out of your ass
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis || user.resting) //are you cuffed, dying, lying, stunned or other
		return
	if(get_dist(user, target_object) > 1 || get_dist(user, target) > 1 || user.contents.Find(target_object)) // is the mob anchored, too far away from you, or are you too far away from the source
		return
	if(!ismob(target)) //mobs only
		return
	if(!ishuman(user) && !isrobot(user)) //No ghosts or mice putting people into the sleeper
		return
	if(istype(user, /mob/living/silicon/robot/drone)) // drones don't get to use medical machinery
		return
	if(user.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if(!istype(user.loc, /turf) || !istype(target.loc, /turf)) // are you in a container/closet/pod/etc?
		return
	var/mob/living/L = target
	if(!istype(L) || L.buckled)
		return
	return TRUE


/proc/this_is_an_animal_or_a_robot(atom/movable/target as mob|obj)
	return (istype(target, /mob/living/simple_animal) || istype(target, /mob/living/silicon))


/proc/allowed_to_add_this_person_to_a_medical_machine(atom/movable/target as mob|obj, mob/user as mob, obj/target_object as obj, var/occupant)
	if(!this_guy_is_allowed_to_drag_that_guy_into_something(target,user,target_object))
		return
	if(this_is_an_animal_or_a_robot(target))
		return
	if(occupant)
		user << "\blue <B>The [target_object] is already occupied!</B>"
		return
	var/mob/living/L = target
	if(L.abiotic())
		user << "\red <B>Subject cannot have abiotic items on.</B>"
		return
	for(var/mob/living/carbon/slime/M in range(1,L))
		if(M.Victim == L)
			usr << "\red [L.name] will not fit into the [target_object] because they have a slime latched onto their head."
			return
	return TRUE