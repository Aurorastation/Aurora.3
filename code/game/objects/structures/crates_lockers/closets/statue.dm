/mob/statue_mob
	name = "statue prisoner"
	universal_understand = 1

/mob/statue_mob/send_emote()
	to_chat(src, "You are unable to move while trapped as a statue.")

/mob/statue_mob/say()
	to_chat(src, "You are unable to speak while trapped as a statue.")

/obj/structure/closet/statue
	name = "statue"
	desc = "An incredibly lifelike marble carving."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	density = 1
	anchored = 1
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
		if(L.buckled)
			L.buckled = 0
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

		appearance = L
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

		var/mob/statue_mob/temporarymob = new (src)
		temporarymob.forceMove(src)
		if(L.mind)
			temporarymob.key = L.key
		imprisoned = temporarymob

	if(health == 0) //meaning if the statue didn't find a valid target
		qdel(src)
		return

	START_PROCESSING(SSprocessing, src)
	..()

/obj/structure/closet/statue/process()
	timer -= 2

	if (timer == 10)
		visible_message("<span class='notice'>\The [src]'s surface begins cracking and dissolving!</span>")

	if (timer <= 0)
		dump_contents()
		STOP_PROCESSING(SSprocessing, src)
		qdel(src)

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
		M.take_overall_damage((M.health - health - 100),0) //any new damage the statue incurred is transfered to the mob
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

/obj/structure/closet/statue/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	check_health()

	return

/obj/structure/closet/statue/attack_generic(var/mob/user, damage, attacktext, environment_smash)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(damage && environment_smash)
		for(var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/ex_act(severity)
	for(var/mob/M in src)
		M.ex_act(severity)
		health -= 60 / severity
		check_health()

/obj/structure/closet/statue/attackby(obj/item/I as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	health -= I.force
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] strikes [src] with [I].</span>")
	check_health()

/obj/structure/closet/statue/MouseDrop_T()
	return

/obj/structure/closet/statue/relaymove()
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
	visible_message("<span class='warning'>[src] shatters!.</span>")
	qdel(src)
