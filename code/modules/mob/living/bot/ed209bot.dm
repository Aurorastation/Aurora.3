#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_ARREST		2		// arresting target
#define SECBOT_START_PATROL	3		// start patrol
#define SECBOT_WAIT_PATROL	4		// waiting for signals
#define SECBOT_PATROL		5		// patrolling
#define SECBOT_SUMMON		6		// summoned by PDA
#define SECBOT_STOP			7		// basically 'do nothing'
#define SECBOT_FOLLOW		8		// follows a target

/mob/living/bot/secbot/ed209
	name = "ED-209 Security Robot"
	desc = "A security robot. He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed2090"
	density = 0
	health = 100
	maxHealth = 100

	bot_version = "2.5"
	is_ranged = 1
	preparing_arrest_sounds = new()

	a_intent = I_HURT
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = HEAVY

	var/shot_delay = 4
	var/last_shot = 0

	// vars for verbal commands
	var/short_name = null
	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "arrest", "detain", "follow", "patrol")
	var/emote_hear = "states"
	move_to_delay = 3

/mob/living/bot/secbot/ed209/Initialize()
	..()
	if(!short_name)
		short_name = name

/mob/living/bot/secbot/ed209/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(thinking_enabled && !stat && has_ui_access(speaker))
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/bot/secbot/ed209/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	if(thinking_enabled && !stat && has_ui_access(speaker))
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/bot/secbot/ed209/think()
	while(command_buffer.len > 0)
		var/mob/speaker = command_buffer[1]
		var/text = command_buffer[2]
		var/filtered_name = lowertext(html_decode(name))
		var/filtered_short = lowertext(html_decode(short_name))
		if(dd_hasprefix(text,filtered_name))
			var/substring = copytext(text,length(filtered_name)+1) //get rid of the name.
			listen(speaker,substring)
		else if(dd_hasprefix(text,filtered_short))
			var/substring = copytext(text,length(filtered_short)+1) //get rid of the name.
			listen(speaker,substring)
		command_buffer.Remove(command_buffer[1],command_buffer[2])
	..()
	switch(mode)
		if(SECBOT_FOLLOW)
			follow_target()
		if(SECBOT_STOP)
			commanded_stop()

/mob/living/bot/secbot/ed209/on_think_disabled()
	..()
	command_buffer.Cut()

/mob/living/bot/secbot/ed209/proc/follow_target()
	if(!target)
		return
	if(target in view(7, src))
		walk_to(src,target,1,move_to_delay)

/mob/living/bot/secbot/ed209/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

/mob/living/bot/secbot/ed209/proc/listen(var/mob/speaker, var/text)
	for(var/command in known_commands)
		if(findtext(text,command))
			switch(command)
				if("stay")
					if(stay_command(speaker,text)) //find a valid command? Stop. Dont try and find more.
						break
				if("stop")
					if(stop_command(speaker,text))
						break
				if("arrest")
					if(arrest_command(speaker,text))
						break
				if("detain")
					if(arrest_command(speaker,text))
						break
				if("follow")
					if(follow_command(speaker,text))
						break
				if("patrol")
					if(patrol_command(speaker, text))
						break

	return 1

//returns a list of everybody we wanna do stuff with.
/mob/living/bot/secbot/ed209/proc/get_target_by_name(var/text)
	var/list/possible_targets = hearers(src,10)
	for(var/mob/M in possible_targets)
		if(findtext(text, "[M]"))
			return M
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[M]")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			for(var/a in parsed_name)
				if(a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if(findtext(text,"[a]"))
					return M
	return null

/mob/living/bot/secbot/ed209/proc/arrest_command(var/mob/speaker,var/text)
	target = null //want me to attack something? Well I better forget my old target.
	walk_to(src,0)

	target = get_target_by_name(text)
	if(!(target in view(7, src)))
		return 0

	if(findtext(text,"detain"))
		arrest_type = 1
	else
		arrest_type = 0

	if(isnull(target))
		custom_emote(2, "[emote_hear], \"Error, unit is unable to find target in view range!\"")
		return 0
	else
		if(ishuman(target))
			idcheck = TRUE
			var/mob/living/carbon/human/H = target
			var/perpname = H.name
			var/obj/item/card/id/id = H.GetIdCard()
			if(id)
				perpname = id.registered_name

			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(R && R.security)
				R.security.criminal = "*Arrest*"
			else
				custom_emote(2, "[emote_hear], \"Warning, [target] does not have Security records! Enabling security records check mode!\"")
				check_records = TRUE
			mode = SECBOT_HUNT
			custom_emote(2, "[emote_hear], \"[arrest_type ? ("Detaining") : ("Arresting")] [target]\"")

/mob/living/bot/secbot/ed209/proc/stay_command(var/mob/speaker,var/text)
	walk_to(src, src, 0, move_to_delay)
	mode = SECBOT_IDLE
	auto_patrol = 0
	target = null
	check_records = FALSE
	custom_emote(2, "[emote_hear], \"Roger that, going into idle mode. Auto patrol disabled.\"")
	return 1

/mob/living/bot/secbot/ed209/proc/stop_command(var/mob/speaker,var/text)
	if(!on)
		return
	walk_to(src, src, 0, move_to_delay)
	check_records = FALSE
	custom_emote(2, "[emote_hear], \"Roger that, unit going offline.\"")
	turn_off()
	return 1

/mob/living/bot/secbot/ed209/proc/patrol_command(var/mob/speaker,var/text)
	walk_to(src, src, 0, move_to_delay)
	mode = SECBOT_IDLE
	auto_patrol = 1
	target = null
	custom_emote(2, "[emote_hear], \"Roger that, starting patrol now.\"")
	return 1

/mob/living/bot/secbot/ed209/proc/follow_command(var/mob/speaker,var/text)
	//we can assume 'stop following' is handled by stop_command
	if(findtext(text,"me"))
		mode = SECBOT_FOLLOW
		target = speaker
		custom_emote(2, "[emote_hear], \"Roger that, following you\"")
		return 1

	target = get_target_by_name(text)
	if(!(target in view(7, src)))
		return 0

	if(!target)
		return 0

	mode = SECBOT_FOLLOW
	custom_emote(2, "[emote_hear], \"Roger that, following [target]\"")

	return 1

/mob/living/bot/secbot/ed209/verb/change_name()
	set name = "Change nickname"
	set category = "IC"
	set src in view(1)

	if(!usr.mind)	return 0

	// Check if they are set to arrest
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/perpname = H.name
		var/obj/item/card/id/id = H.GetIdCard()
		if(id)
			perpname = id.registered_name

		var/datum/record/general/R = SSrecords.find_record("name", perpname)
		if(R && R.security && R.security.criminal == "*Arrest*")
			to_chat(usr, "<span class='warning'>Warning, you do not have access!</span>")

	// Check if they have access to the bot
	if(!has_ui_access(usr))
		to_chat(usr, "<span class='warning'>Warning, you do not have access!</span>")
		return 0

	var/short_input = sanitizeSafe(input("What do you want [src] respond to?", , ""), MAX_NAME_LEN)

	if(src && short_input && !usr.stat && in_range(usr,src))
		short_name = short_input
		return 1

/mob/living/bot/secbot/ed209/update_icons()
	if(on && is_attacking)
		icon_state = "ed209-c"
	else
		icon_state = "ed209[on]"

/mob/living/bot/secbot/ed209/explode()
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/secbot_assembly/ed209_assembly(Tsec)

	var/obj/item/gun/energy/taser/G = new /obj/item/gun/energy/taser(Tsec)
	G.power_supply.charge = 0
	if(prob(50))
		new /obj/item/robot_parts/l_leg(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/r_leg(Tsec)
	if(prob(50))
		if(prob(50))
			new /obj/item/clothing/head/helmet(Tsec)
		else
			new /obj/item/clothing/suit/armor/vest(Tsec)

	spark(src, 3, alldirs)

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	qdel(src)

/mob/living/bot/secbot/ed209/RangedAttack(var/atom/A)
	if(!(target in view(7, src)))
		walk_to(src, target, 6, move_to_delay)
		return
	if(last_shot + shot_delay > world.time)
		to_chat(src, "You are not ready to fire yet!")
		return

	last_shot = world.time
	var/projectile = /obj/item/projectile/beam/stun
	if(emagged)
		projectile = /obj/item/projectile/beam

	playsound(loc, emagged ? 'sound/weapons/Laser.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/P = new projectile(loc)
	var/def_zone = get_exposed_defense_zone(A)
	P.launch_projectile(A, def_zone)
// Assembly

/obj/item/secbot_assembly/ed209_assembly
	name = "ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed209_frame"
	item_state = "ed209_frame"
	created_name = "ED-209 Security Robot"
	var/lasercolor = ""

/obj/item/secbot_assembly/ed209_assembly/attackby(var/obj/item/W as obj, var/mob/user as mob)
	..()

	if(W.ispen())
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
		return

	switch(build_step)
		if(0, 1)
			if(istype(W, /obj/item/robot_parts/l_leg) || istype(W, /obj/item/robot_parts/r_leg))
				user.drop_from_inventory(W,get_turf(src))
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the robot leg to [src].</span>")
				name = "legs/frame assembly"
				if(build_step == 1)
					item_state = "ed209_leg"
					icon_state = "ed209_leg"
				else
					item_state = "ed209_legs"
					icon_state = "ed209_legs"
				return 1

		if(2)
			if(istype(W, /obj/item/clothing/suit/storage/vest))
				user.drop_from_inventory(W,get_turf(src))
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the armor to [src].</span>")
				name = "vest/legs/frame assembly"
				item_state = "ed209_shell"
				icon_state = "ed209_shell"
				return 1

		if(3)
			if(W.iswelder())
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					build_step++
					name = "shielded frame assembly"
					to_chat(user, "<span class='notice'>You welded the vest to [src].</span>")
					return 1
		if(4)
			if(istype(W, /obj/item/clothing/head/helmet))
				user.drop_from_inventory(W,get_turf(src))
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the helmet to [src].</span>")
				name = "covered and shielded frame assembly"
				item_state = "ed209_hat"
				icon_state = "ed209_hat"
				return 1

		if(5)
			if(isprox(W))
				user.drop_from_inventory(W,get_turf(src))
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the prox sensor to [src].</span>")
				name = "covered, shielded and sensored frame assembly"
				item_state = "ed209_prox"
				icon_state = "ed209_prox"
				return 1

		if(6)
			if(W.iscoil())
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					to_chat(user, "<span class='warning'>You need one coil of wire to wire [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire [src].</span>")
				if(do_after(user, 40) && build_step == 6)
					if(C.use(1))
						build_step++
						to_chat(user, "<span class='notice'>You wire the ED-209 assembly.</span>")
						name = "wired ED-209 assembly"
				return

		if(7)
			if(istype(W, /obj/item/gun/energy/taser))
				name = "taser ED-209 assembly"
				build_step++
				to_chat(user, "<span class='notice'>You add [W] to [src].</span>")
				item_state = "ed209_taser"
				icon_state = "ed209_taser"
				user.drop_from_inventory(W,get_turf(src))
				qdel(W)
				return 1

		if(8)
			if(W.isscrewdriver())
				playsound(src.loc, W.usesound, 100, 1)
				var/turf/T = get_turf(user)
				to_chat(user, "<span class='notice'>Now attaching the gun to the frame...</span>")
				sleep(40)
				if(get_turf(user) == T && build_step == 8)
					build_step++
					name = "armed [name]"
					to_chat(user, "<span class='notice'>Taser gun attached.</span>")

		if(9)
			if(istype(W, /obj/item/cell))
				build_step++
				to_chat(user, "<span class='notice'>You complete the ED-209.</span>")
				var/turf/T = get_turf(src)
				new /mob/living/bot/secbot/ed209(T,created_name,lasercolor)
				user.drop_from_inventory(W,get_turf(src))
				qdel(W)
				qdel(src)
				return 1

#undef SECBOT_IDLE
#undef SECBOT_HUNT
#undef SECBOT_ARREST
#undef SECBOT_START_PATROL
#undef SECBOT_WAIT_PATROL
#undef SECBOT_PATROL
#undef SECBOT_SUMMON
#undef SECBOT_STOP
#undef SECBOT_FOLLOW