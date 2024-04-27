/mob/living/simple_animal/hostile/commanded
	name = "commanded"
	var/short_name = null
	stance = COMMANDED_STOP
	melee_damage_lower = 0
	melee_damage_upper = 0
	density = FALSE
	belongs_to_station = TRUE
	hostile_nameable = TRUE

	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "attack", "follow")

	var/list/sad_emote = list("whimpers")

	var/mob/master = null //undisputed master. Their commands hold ultimate sway and ultimate power.
	var/datum/weakref/following_mob_ref
	var/list/allowed_targets = list() //WHO CAN I KILL D:

	var/retribution = 1 //whether or not they will attack us if we attack them like some kinda dick.

/mob/living/simple_animal/hostile/commanded/Initialize()
	. = ..()
	if(!short_name)
		short_name = name

/mob/living/simple_animal/hostile/commanded/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(thinking_enabled && !stat && ((speaker in friends) || speaker == master))
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	if(thinking_enabled && !stat && ((speaker in friends) || speaker == master))
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/can_name(var/mob/living/M)
	if(master && (M != master))
		to_chat(M, SPAN_WARNING("You can't name \the [src] because you aren't their master!"))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/commanded/do_nickname(var/mob/living/M)
	var/input = sanitizeSafe(input("What nickname do you want to give \the [src]?","Choose a name") as null|text, MAX_NAME_LEN)
	if(!input)
		return
	short_name = input

/mob/living/simple_animal/hostile/commanded/proc/get_command(cmdtext, list/searchnames)
	searchnames |= list("everyone", "everybody")
	for(var/name in searchnames)
		if(dd_hasprefix(cmdtext, name))
			return copytext(cmdtext, length(name) + 1)

/mob/living/simple_animal/hostile/commanded/think()
	while(command_buffer.len > 0)
		var/mob/speaker = command_buffer[1]
		var/text = command_buffer[2]
		var/filtered_name = lowertext(html_decode(name))
		var/filtered_short = lowertext(html_decode(short_name))
		var/substring = get_command(text, list(filtered_name, filtered_short))

		if(substring)
			listen(speaker, substring)

		command_buffer.Remove(command_buffer[1],command_buffer[2])
	..()
	switch(stance)
		if(COMMANDED_FOLLOW)
			follow_target()
		if(COMMANDED_STOP)
			commanded_stop()

/mob/living/simple_animal/hostile/commanded/change_stance(var/new_stance)
	if(following_mob_ref)
		var/mob/mob_to_follow = following_mob_ref.resolve()
		UnregisterSignal(mob_to_follow, COMSIG_MOB_POINT)
		following_mob_ref = null

	. = ..()
	if(!.)
		return

	switch(stance)
		if(COMMANDED_STOP)
			MOB_SHIFT_TO_NORMAL_THINKING(src)
		if(COMMANDED_FOLLOW)
			MOB_SHIFT_TO_FAST_THINKING(src)
		if(COMMANDED_MISC)
			MOB_SHIFT_TO_NORMAL_THINKING(src)

/mob/living/simple_animal/hostile/commanded/on_think_disabled()
	..()
	command_buffer.Cut()

/mob/living/simple_animal/hostile/commanded/FindTarget(var/new_stance = HOSTILE_STANCE_ATTACK)
	if(!allowed_targets.len)
		return null
	var/mode = "specific"
	if(allowed_targets[1] == "everyone") //we have been given the golden gift of murdering everything. Except our master, of course. And our friends. So just mostly everyone.
		mode = "everyone"
	for(var/atom/A in targets)
		var/mob/M = null
		if(A == src)
			continue
		if(isliving(A))
			M = A
		if(M && M.stat)
			continue
		if(mode == "specific")
			if(!(A in allowed_targets))
				continue
			change_stance(new_stance)
			return A
		else
			if(M == master || (M in friends))
				continue
			change_stance(new_stance)
			return A


/mob/living/simple_animal/hostile/commanded/proc/follow_target()
	stop_automated_movement = 1
	var/mob/mob_to_follow = following_mob_ref?.resolve()
	if(mob_to_follow && get_dist(src, mob_to_follow) <= 10)
		walk_to(src,mob_to_follow,1,move_to_delay)

/mob/living/simple_animal/hostile/commanded/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

/mob/living/simple_animal/hostile/commanded/proc/listen(var/mob/speaker, var/text)
	for(var/command in known_commands)
		if(findtext(text,command))
			switch(command)
				if("stay")
					if(stay_command(speaker,text)) //find a valid command? Stop. Dont try and find more.
						break
				if("stop")
					if(stop_command(speaker,text))
						break
				if("attack")
					if(attack_command(speaker,text))
						break
				if("follow")
					if(follow_command(speaker,text))
						break
				else
					misc_command(speaker,text) //for specific commands

	return 1

//returns a list of everybody we wanna do stuff with.
/mob/living/simple_animal/hostile/commanded/proc/get_targets_by_name(var/text, var/filter_friendlies = 0)
	var/list/possible_targets = hearers(src,10)
	. = list()
	for(var/mob/M in possible_targets)
		if(filter_friendlies && ((M in friends) || M.faction == faction || M == master))
			continue
		var/found = 0
		if(findtext(text, "[M]"))
			found = 1
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[M]")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			for(var/a in parsed_name)
				if(a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if(findtext(text,"[a]"))
					found = 1
					break
		if(found)
			. += M


/mob/living/simple_animal/hostile/commanded/proc/attack_command(var/mob/speaker, var/text, var/mob/mob_target)
	target_mob = null //want me to attack something? Well I better forget my old target.
	walk_to(src,0)
	change_stance(HOSTILE_STANCE_ATTACKING)
	if(text == "attack" || findtext(text,"everyone") || findtext(text,"anybody") || findtext(text, "somebody") || findtext(text, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming non-pickiness.
		allowed_targets = list("everyone")//everyone? EVERYONE
		return 1

	if(mob_target)
		allowed_targets += mob_target
		friends -= mob_target
	else
		allowed_targets += get_targets_by_name(text)
	if(emote_hear && emote_hear.len)
		audible_emote("[pick(emote_hear)].",0)
	return targets.len != 0

/mob/living/simple_animal/hostile/commanded/proc/stay_command(var/mob/speaker,var/text)
	target_mob = null
	change_stance(COMMANDED_STOP)
	stop_automated_movement = 1
	walk_to(src, 0)
	if(emote_hear && emote_hear.len)
		audible_emote("[pick(emote_hear)].",0)
	return 1

/mob/living/simple_animal/hostile/commanded/proc/stop_command(var/mob/speaker,var/text)
	allowed_targets = list()
	walk_to(src, 0)
	change_stance(HOSTILE_STANCE_IDLE)
	stop_automated_movement = 0
	if(emote_hear && emote_hear.len)
		audible_emote("[pick(emote_hear)].",0)
	return 1

/mob/living/simple_animal/hostile/commanded/proc/follow_command(var/mob/speaker, var/text, var/mob/mob_target)
	allowed_targets = list()
	walk_to(src, 0)

	if(emote_hear && emote_hear.len)
		audible_emote("[pick(emote_hear)].",0)

	if(!mob_target)
		if(findtext(text, "me"))
			mob_target = speaker
		else
			var/list/targets = get_targets_by_name(text)
			if(targets.len > 1 || !targets.len) //CONFUSED. WHO DO I FOLLOW?
				return FALSE
			mob_target = targets[1]

	change_stance(COMMANDED_FOLLOW) //GOT SOMEBODY. BETTER FOLLOW EM.
	following_mob_ref = WEAKREF(mob_target)
	friends |= mob_target
	RegisterSignal(mob_target, COMSIG_MOB_POINT, PROC_REF(point_command))

	return 1

/mob/living/simple_animal/hostile/commanded/proc/misc_command(var/mob/speaker,var/text)
	return 0

/mob/living/simple_animal/hostile/commanded/handle_pointed_at(var/mob/pointer)
	if(pointer != master && !(pointer in friends))
		return
	var/mob_to_follow = following_mob_ref?.resolve()
	if(stance != COMMANDED_FOLLOW || mob_to_follow != pointer)
		follow_command(pointer, mob_target = pointer)
	else
		stop_command(pointer)

/mob/living/simple_animal/hostile/commanded/proc/point_command(var/mob/pointer, var/atom/pointed_at)
	SIGNAL_HANDLER

	if(pointed_at == src || pointer == pointed_at || !isliving(pointed_at))
		return

	switch(pointer.a_intent)
		if(I_GRAB)
			INVOKE_ASYNC(src, PROC_REF(follow_command), pointer, null, pointed_at)
		if(I_HURT)
			if(pointed_at != master || (!(pointed_at in friends) || pointer == master))
				INVOKE_ASYNC(src, PROC_REF(attack_command), pointer, null, pointed_at)

/mob/living/simple_animal/hostile/commanded/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	//if they attack us, we want to kill them. None of that "you weren't given a command so free kill" bullshit.
	. = ..()

	// We forgive our master
	if(user == master)
		change_stance(HOSTILE_STANCE_IDLE)
		target_mob = null
		audible_emote("[pick(sad_emote)].",0)
		return
	if(. && retribution)
		change_stance(HOSTILE_STANCE_ATTACK)
		target_mob = user
		allowed_targets += user //fuck this guy in particular.
		if(user in friends) //We were buds :'(
			friends -= user


/mob/living/simple_animal/hostile/commanded/attack_hand(mob/living/carbon/human/M as mob)
	..()

	// We forgive our master
	if(M == master)
		change_stance(HOSTILE_STANCE_IDLE)
		target_mob = null
		if(M.a_intent == I_HURT)
			audible_emote("[pick(sad_emote)].",0)
		return
	if(M.a_intent == I_HELP && prob(40)) //chance that they won't immediately kill anyone who pets them. But only a chance.
		change_stance(HOSTILE_STANCE_IDLE)
		target_mob = null
		audible_emote("growls at [M].")
		to_chat(M, SPAN_WARNING("Maybe you should keep your hands to yourself..."))
		return

	if(M.a_intent == I_HURT && retribution) //assume he wants to hurt us.

		target_mob = M
		allowed_targets += M
		change_stance(HOSTILE_STANCE_ATTACK)
		if(M in friends)
			friends -= M

/mob/living/simple_animal/hostile/commanded/attack_generic(var/mob/user, var/damage, var/attack_message)
	..()

	// We forgive our master
	if(user == master)
		target_mob = null
		change_stance(HOSTILE_STANCE_IDLE)
		audible_emote("[pick(sad_emote)].",0)

/mob/living/simple_animal/hostile/commanded/bullet_act(var/obj/item/projectile/P, var/def_zone)
	..()

	// We forgive our master
	if (ismob(P.firer) && P.firer == master)
		target_mob = null
		change_stance(HOSTILE_STANCE_IDLE)
		audible_emote("[pick(sad_emote)].",0)

/mob/living/simple_animal/hostile/commanded/handle_attack_by(var/obj/item/O, var/mob/user)
	..()
	// We forgive our master
	if(user == master)
		target_mob = null
		change_stance(HOSTILE_STANCE_IDLE)
		if(!istype(O, brush)) //we don't get sad if we're brushed!
			audible_emote("[pick(sad_emote)].",0)

/mob/living/simple_animal/hostile/commanded/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)//Standardization and logging -Sieve
	..()

	if(istype(AM,/obj/))
		var/obj/O = AM
		if(ismob(O.thrower))
			if(O.thrower == master)
				target_mob = null
				change_stance(HOSTILE_STANCE_IDLE)
				audible_emote("[pick(sad_emote)].",0)
