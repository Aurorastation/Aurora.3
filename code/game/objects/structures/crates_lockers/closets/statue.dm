/mob/statue_mob
	name = "statue prisoner"
	universal_understand = 1

/mob/statue_mob/send_emote()
	to_chat(src, "You are unable to move while trapped as a statue.")

/mob/statue_mob/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	to_chat(src, "You are unable to speak while trapped as a statue.")

/obj/structure/closet/statue
	name = "statue"
	desc = "An incredibly lifelike marble carving."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	density = TRUE
	anchored = TRUE
	health = 0 //destroying the statue kills the mob within
	var/timer = 90 //eventually the person will be freed
	var/mob/statue_mob/imprisoned = null //the temporary mob that is created when someone is put inside a statue

/obj/structure/closet/statue/eternal
	timer = -1

/obj/structure/closet/statue/Destroy()
	QDEL_NULL(imprisoned)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/closet/statue/Initialize(mapload, mob/living/L)
	if(isliving(L))
		if(L.buckled_to)
			L.buckled_to = 0
			L.anchored = 0
		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src

		L.drop_r_hand()
		L.drop_l_hand()

		L.forceMove(src)
		L.sdisabilities |= MUTE
		health = L.health + 300 //stoning damaged mobs will result in easier to shatter statues
		L.frozen = TRUE

		create_icon(L)

		var/mob/statue_mob/temporarymob = new (src)
		temporarymob.forceMove(src)
		if(L.mind)
			temporarymob.key = L.key
		imprisoned = temporarymob

	if(health == 0) //meaning if the statue didn't find a valid target
		if(flags_1 & INITIALIZED_1)
			stack_trace("Warning: [src]([type]) initialized multiple times!")
		flags_1 |= INITIALIZED_1

		return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSprocessing, src)
	. = ..()

/obj/structure/closet/statue/process()
	timer -= 2

	if (timer == 10)
		visible_message(SPAN_NOTICE("\The [src]'s surface begins cracking and dissolving!"))

	if (timer <= 0)
		dump_contents()
		STOP_PROCESSING(SSprocessing, src)
		qdel(src)

/obj/structure/closet/statue/proc/create_icon(var/mob/living/L)
	appearance = L
	appearance_flags |= KEEP_TOGETHER
	dir = L.dir
	color = list(
					0.30, 0.3, 0.25,
					0.30, 0.3, 0.25,
					0.30, 0.3, 0.25
				)
	name = "statue of [L.name]"
	desc = "An incredibly lifelike stone carving."

	if(iscorgi(L))
		name = "statue of a corgi"
		desc = "If it takes forever, I will wait for you..."

/obj/structure/closet/statue/dump_contents()

	for(var/obj/O in src)
		O.forceMove(loc)

	for(var/mob/living/M in src)
		if(imprisoned)
			if(imprisoned.key)
				M.key = imprisoned.key

		M.forceMove(loc)
		M.sdisabilities &= ~MUTE
		M.frozen = FALSE
		M.take_overall_damage((M.health - health - 100),0) //any new damage the statue incurred is transferred to the mob
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/statue/open()
	return

/obj/structure/closet/statue/close()
	return

/obj/structure/closet/statue/toggle()
	return

/obj/structure/closet/statue/proc/check_health()
	if(health <= 0)
		for(var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	health -= hitting_projectile.get_structure_damage()
	check_health()

/obj/structure/closet/statue/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(damage && environment_smash)
		for(var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/ex_act(severity)
	for(var/mob/M in src)
		M.ex_act(severity)
		health -= 60 / severity
		check_health()

/obj/structure/closet/statue/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	health -= attacking_item.force
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("[user] strikes [src] with [attacking_item]."))
	check_health()

/obj/structure/closet/statue/mouse_drop_receive(atom/dropped, mob/user, params)
	return

/obj/structure/closet/statue/relaymove(mob/living/user, direction)
	. = ..()

	return

/obj/structure/closet/statue/attack_hand()
	return

/obj/structure/closet/statue/verb_toggleopen()
	return

/obj/structure/closet/statue/update_icon()
	return

/obj/structure/closet/statue/proc/shatter(mob/user as mob)
	if (user)
		user.frozen = FALSE
		user.dust()
	dump_contents()
	visible_message(SPAN_WARNING("[src] shatters!."))
	qdel(src)


/obj/structure/closet/statue/ice
	name = "ice cube"
	desc = "A large ice cube."
	anchored = FALSE

/obj/structure/closet/statue/ice/create_icon(var/mob/living/L)
	appearance = L
	dir = L.dir
	var/image/I
	I = image(icon = 'icons/obj/statue.dmi', icon_state = "icecube")
	AddOverlays(I)

/obj/structure/closet/statue/ice/shatter(mob/user as mob)
	if (user)
		user.frozen = FALSE
		if(isliving(user))
			var/mob/living/L = user
			L.adjustBruteLoss(30)
			L.bodytemperature -= 150

	dump_contents()
	visible_message(SPAN_WARNING("\The [src] shatters!"))
	qdel(src)
