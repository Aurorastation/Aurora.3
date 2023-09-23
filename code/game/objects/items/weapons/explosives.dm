/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 2)
	var/datum/wires/explosive/c4/wires = null
	var/detonate_time = 0
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/obj/effect/plastic_explosive/effect_overlay

/obj/item/plastique/Initialize()
	. = ..()
	wires = new(src)

/obj/item/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/plastique/attackby(var/obj/item/I, var/mob/user)
	if(I.isscrewdriver())
		open_panel = !open_panel
		to_chat(user, "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>")
		return TRUE
	else if(I.iswirecutter() || I.ismultitool() || istype(I, /obj/item/device/assembly/signaler ))
		wires.Interact(user)
		return TRUE
	else
		return ..()

/obj/item/plastique/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = Clamp(newtime, 10, 60000)
		timer = newtime
		to_chat(user, SPAN_NOTICE("Timer set for [timer] seconds."))

/obj/item/plastique/afterattack(atom/movable/target, mob/user, flag)
	if (!flag)
		return
	if(ismob(target) || istype(target, /turf/unsimulated) || isopenturf(target) || istype(target, /obj/item/storage/) || istype(target, /obj/item/clothing/accessory/storage/) || istype(target, /obj/item/clothing/under))
		return
	if(deploy_check(user))
		return
	to_chat(user, SPAN_NOTICE("Planting explosives..."))

	if(do_after(user, 50, TRUE, target))
		user.do_attack_animation(target)
		deploy_c4(target, user)

/obj/item/plastique/proc/deploy_check(var/mob/user)
	return FALSE

/obj/item/plastique/proc/deploy_c4(var/atom/movable/explode_target, mob/user)
	user.drop_from_inventory(src, get_turf(user))
	src.target = explode_target

	log_and_message_admins("planted [src.name] on [target.name] with [src.timer] second fuse", user, get_turf(target))

	new /obj/effect/plastic_explosive(get_turf(user), target, src)
	to_chat(user, "Bomb has been planted. Timer counting down from [timer].")

	detonate_time = world.time + (timer * 10)
	addtimer(CALLBACK(src, PROC_REF(explode), get_turf(target)), timer * 10)

/obj/item/plastique/proc/explode(turf/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	QDEL_NULL(effect_overlay)
	if(location)
		explosion(location, -1, -1, 2, 3, spreading = 0)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1, no_product = TRUE)
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)

	qdel(src)

/obj/item/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/plastique/cyborg
	name = "plastic explosives dispenser"
	desc = "A stationbound-mounted C4 dispenser, how thrilling!"
	desc_antag = "When used, this dispenser will deploy C4 on a target, upon which it will enter a charging state. After two minutes, it will restock a new C4 bundle."
	var/can_deploy = TRUE
	var/recharge_time = 5 MINUTES
	maptext_x = 3
	maptext_y = 2

/obj/item/plastique/cyborg/Initialize()
	. = ..()
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/plastique/cyborg/attackby()
	return

/obj/item/plastique/cyborg/deploy_check(mob/user)
	if(!can_deploy)
		to_chat(user, SPAN_WARNING("\The [src] hasn't recharged yet!"))
		return TRUE
	..()

/obj/item/plastique/cyborg/deploy_c4(atom/movable/target, mob/user)
	var/obj/item/plastique/C4 = new /obj/item/plastique(target)
	C4.timer = src.timer
	C4.target = target

	log_and_message_admins("planted [C4.name] on [target.name] with [C4.timer] second fuse", user, get_turf(target))

	new /obj/effect/plastic_explosive(get_turf(user), target, C4)
	to_chat(user, SPAN_NOTICE("Bomb has been planted. Timer counting down from [C4.timer]."))

	C4.detonate_time = world.time + (timer * 10)
	addtimer(CALLBACK(C4, PROC_REF(explode), get_turf(target)), timer * 10)
	addtimer(CALLBACK(src, PROC_REF(recharge)), recharge_time)
	can_deploy = FALSE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 6px;\">Charge</span>"

/obj/item/plastique/cyborg/proc/recharge()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R?.cell)
			R.cell.use(1000)
	can_deploy = TRUE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/plastique/dirty
	name = "dirty bomb"
	desc = "A small explosive laced with radium. The explosion is small, but the radioactive material will remain for a fair while."
	timer = 300

/obj/item/plastique/dirty/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = Clamp(newtime, 300, 60000)
		timer = newtime
		to_chat(user, SPAN_NOTICE("Timer set for [timer] seconds."))

/obj/item/plastique/dirty/explode(turf/location)
	if(location)
		SSradiation.radiate(src, 250)
		new /obj/effect/decal/cleanable/greenglow(get_turf(src))
	..()
