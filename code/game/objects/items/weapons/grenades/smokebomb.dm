/obj/item/grenade/smokebomb
	name = "smoke bomb"
	desc = "It is set to detonate in 2 seconds."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "flashbang"
	det_time = 20
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	var/datum/effect/effect/system/smoke_spread/bad/smoke

/obj/item/grenade/smokebomb/New()
	..()
	src.smoke = new /datum/effect/effect/system/smoke_spread/bad
	src.smoke.attach(src)

/obj/item/grenade/smokebomb/Destroy()
	qdel(smoke)
	smoke = null
	return ..()

/obj/item/grenade/smokebomb/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	src.smoke.set_up(10, 0, usr.loc)
	spawn(0)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()

	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update_icon()
	sleep(80)
	qdel(src)
	return

/obj/item/grenade/smokebomb/cyborg
	name = "mounted smoke deployer"
	desc = "A stationbound-mounted smoke grenade deployer. Activate to deploy."
	desc_antag = "When activated, it will deploy a smokebomb which will instantly prime, blowing out clouds of smoke. Upon deploying, it will enter a charging state which will restock a new smokebomb in two minutes."
	var/can_deploy = TRUE
	var/recharge_time = 5 MINUTES
	maptext_x = 3
	maptext_y = 2

/obj/item/grenade/smokebomb/cyborg/Initialize()
	. = ..()
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/grenade/smokebomb/cyborg/attack_self(mob/user)
	if(!can_deploy)
		to_chat(user, SPAN_WARNING("\The [src] hasn't recharged yet!"))
		return

	to_chat(user, SPAN_NOTICE("You quietly deploy a smokebomb."))
	var/obj/item/grenade/smokebomb/SB = new /obj/item/grenade/smokebomb(get_turf(src))
	SB.det_time = 1
	SB.prime()

	addtimer(CALLBACK(src, .proc/recharge), recharge_time)
	can_deploy = FALSE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 6px;\">Charge</span>"

/obj/item/grenade/smokebomb/cyborg/proc/recharge()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R?.cell)
			R.cell.use(1000)
	can_deploy = TRUE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"