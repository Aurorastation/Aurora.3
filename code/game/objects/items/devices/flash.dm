/obj/item/device/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
	icon_state = "flash"
	item_state = "flash"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

	var/times_used = 0 //Number of times it's been used.
	var/broken = 0     //Is the flash burnt out?

/obj/item/device/flash/proc/clumsy_check(mob/user)
	if(user && (user.is_clumsy()) && prob(50))
		to_chat(user, SPAN_WARNING("\The [src] slips out of your hand."))
		user.drop_from_inventory(src)
		return FALSE
	return TRUE

/obj/item/device/flash/proc/burnout_check(mob/user, intensity = 1)
	if(times_used > 5)
		to_chat(user, SPAN_WARNING("*click* *click*"))
		return

	if(prob(times_used * intensity))
		burnout(user)
	else
		times_used++
		addtimer(CALLBACK(src, /obj/item/device/flash/proc/flash_recharge), 30 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE)

	return broken

/obj/item/device/flash/proc/burnout(mob/user)
	broken = TRUE
	icon_state = "flashburnt"
	to_chat(user, SPAN_WARNING("The bulb has burnt out!"))

/obj/item/device/flash/proc/flash(mob/living/L)
	if(L.flash_act(affect_silicon = TRUE, ignore_inherent = TRUE))
		if(issilicon(L))
			L.Weaken(rand(3, 7))
		else
			L.confused = 10

		return TRUE

/obj/item/device/flash/proc/flash_recharge()
	if(broken)
		return
	times_used = max(0, times_used - 1)
	if(times_used > 0)
		addtimer(CALLBACK(src, /obj/item/device/flash/proc/flash_recharge), 30 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE)

/obj/item/device/flash/proc/robot_flash(mob/user)
	if(!isrobot(user))
		return

	var/atom/movable/overlay/animation = new(user.loc)
	animation.layer = user.layer + 1
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = user
	flick("blspell", animation)
	QDEL_IN(animation, 5)

//attack_as_weapon
/obj/item/device/flash/attack(mob/living/L, mob/living/user, target_zone)
	// Single-target flash
	if(!L || !user || !clumsy_check(user))
		return

	L.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been flashed (attempt) with [src.name]  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [src.name] to flash [L.name] ([L.ckey])</span>")
	msg_admin_attack("[user.name] ([user.ckey]) Used the [src.name] to flash [L.name] ([L.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(L))

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(L)
	if(broken)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

	if(burnout_check(user))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)

	if(isrobot(user))
		robot_flash(user)

	if(flash(L))
		if(issilicon(L))
			user.visible_message(SPAN_WARNING("[user] overloads [L]'s sensors with \the [src]!"))
		else
			user.visible_message(SPAN_WARNING("[user] blinds [L] with \the [src]!"))
	else
		user.visible_message(SPAN_NOTICE("[user] fails to blind [L] with \the [src]."))

/obj/item/device/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	// AOE flash
	if(!user || !clumsy_check(user)) 	return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(broken)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

	if(burnout_check(user, intensity = 5))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)

	flash(user)
	if(isrobot(user))
		robot_flash(user)

	for(var/mob/living/L in oviewers(3, get_turf(user)))
		if(flash(L) && prob(50))
			L.disable_cloaking_device()

/obj/item/device/flash/emp_act(severity)
	var/mob/living/L = loc
	if(!istype(L) || broken || burnout_check(L, intensity = 15 / severity))
		return
	to_chat(L, SPAN_WARNING("Your [src] goes off!"))
	flash(L)
	..()

/obj/item/device/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

/obj/item/device/flash/synthetic/burnout_check()
	. = broken // Single-use
	if(!broken)
		burnout()
