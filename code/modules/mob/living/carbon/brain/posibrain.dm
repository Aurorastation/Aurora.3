/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = 3
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)

	var/searching = 0
	var/askDelay = 10 * 60 * 1
	req_access = list(access_robotics)
	var/damageamount = 60
	locked = 0


/obj/item/device/mmi/digital/posibrain/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		to_chat(user, "<span class='notice'>You carefully locate the manual activation switch and start the positronic brain's boot process.</span>")
		icon_state = "posibrain-searching"
		src.searching = 1
		var/datum/ghosttrap/G = get_ghost_trap("positronic brain")
		G.request_player(brainmob, "Someone is requesting a personality for a positronic brain.", 60 SECONDS)
		spawn(600) reset_search()

/obj/item/device/mmi/digital/posibrain/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	if(src.brainmob && src.brainmob.key) return

	src.searching = 0
	icon_state = "posibrain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<span class='notice'>The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?</span>")

/obj/item/device/mmi/digital/posibrain/attack_ghost(var/mob/abstract/observer/user)
	if(!searching || (src.brainmob && src.brainmob.key))
		return

	var/datum/ghosttrap/G = get_ghost_trap("positronic brain")
	if(!G.assess_candidate(user))
		return
	var/response = alert(user, "Are you sure you wish to possess this [src]?", "Possess [src]", "Yes", "No")
	if(response == "Yes")
		G.transfer_personality(user, brainmob)
	return

/obj/item/device/mmi/digital/posibrain/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*</span>\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "</span><span class='info'>*---------*</span>"
	to_chat(user, msg)
	return

/obj/item/device/mmi/digital/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()

/obj/item/device/mmi/digital/posibrain/New()
	..()
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name


/obj/item/device/mmi/digital/posibrain/proc/healthcheck()
	if(damageamount <=0)
		playsound(loc, 'sound/items/countdown.ogg', 125, 1)
		sleep(20)
		playsound(loc, 'sound/effects/alert.ogg', 125, 1)
		sleep(10)
		new /obj/effect/gibspawner/robot(src.loc)
		qdel(src)
	return

/obj/item/device/mmi/digital/posibrain/bullet_act(var/obj/item/projectile/Proj)

	if(!Proj.nodamage)
		switch(Proj.damage_type)
			if(BRUTE)
				healthcheck()
				damageamount -= (rand(5,10))
			if(BURN)
				healthcheck()
				damageamount -= (rand(25,30))

/obj/item/device/mmi/digital/posibrain/attackby(obj/item/O as obj, mob/user as mob, params)

	if (istype(O, /obj/item) && user.a_intent == "harm")
		healthcheck()
		damageamount -= (rand(5,8))

	if (istype(O, /obj/item/weldingtool) && user.a_intent == "harm")
		healthcheck()
		damageamount -= (rand(10,20))

