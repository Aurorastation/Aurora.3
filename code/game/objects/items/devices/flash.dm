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
	var/last_used = 0 //last world.time it was used.

/obj/item/device/flash/proc/clown_check(var/mob/user)
	if(user && (user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand.</span>")
		user.drop_from_inventory(src)
		return 0
	return 1

/obj/item/device/flash/proc/flash_recharge()
	//capacitor recharges over time
	for(var/i=0, i<3, i++)
		if(last_used+600 > world.time)
			break
		last_used += 600
		times_used -= 2
	last_used = world.time
	times_used = max(0,round(times_used)) //sanity

//attack_as_weapon
/obj/item/device/flash/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!user || !M)	return	//sanity

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been flashed (attempt) with [src.name]  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [src.name] to flash [M.name] ([M.ckey])</span>")
	msg_admin_attack("[user.name] ([user.ckey]) Used the [src.name] to flash [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if(!clown_check(user))	return
	if(broken)
		to_chat(user, "<span class='warning'>\The [src] is broken.</span>")
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			to_chat(user, "<span class='warning'>*click* *click*</span>")
			return
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	var/flashfail = 0

	if(iscarbon(M))
		if (M.is_diona())
			var/mob/living/carbon/C = M
			var/datum/dionastats/DS = C.get_dionastats()
			DS.stored_energy += 10
			M.flash_eyes()
			M.Weaken(5)
			M.eye_blind = 5
			return

		var/safety = M:eyecheck(TRUE)
		if(safety <= 0)
			M.flash_eyes()
			M.confused = 10
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/eyes/E = H.get_eyes()
			if(!E)
				return

			E.flash_act()

		else
			flashfail = TRUE
	else if(issilicon(M))
		if(isrobot(M))
			var/mob/living/silicon/robot/R = M
			if(R.overclocked || R.flash_resistant)
				flashfail = TRUE
		if(!flashfail)
			M.Weaken(rand(3, 7)) //should be that borg is disabled for around 3-7 seconds
	else
		flashfail = TRUE

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	if(!flashfail)
		flick("flash2", src)
		if(!issilicon(M))

			user.visible_message("<span class='disarm'>[user] blinds [M] with the flash!</span>")
		else

			user.visible_message("<span class='notice'>[user] overloads [M]'s sensors with the flash!</span>")
	else

		user.visible_message("<span class='notice'>[user] fails to blind [M] with the flash!</span>")

	return




/obj/item/device/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user || !clown_check(user)) 	return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(broken)
		user.show_message("<span class='warning'>The [src.name] is broken</span>", 2)
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(5*times_used))	//More consequential rolls are made the more you overuse the device.
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			user.show_message("<span class='warning'>*click* *click*</span>", 2)
			return
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("flash2", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	for(var/mob/living/carbon/M in oviewers(3, null))
		if(prob(50))
			if (locate(/obj/item/cloaking_device, M))
				for(var/obj/item/cloaking_device/S in M)
					S.active = 0
					S.icon_state = "shield0"
		var/safety = M.eyecheck(TRUE)
		if(safety < FLASH_PROTECTION_MODERATE)
			if(!M.blinded)
				flick("flash", M.flash)

	return

/obj/item/device/flash/emp_act(severity)
	if(broken)
		return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(5*times_used))
				broken = 1
				icon_state = "flashburnt"
				return
			times_used++
			if(iscarbon(loc))
				var/mob/living/carbon/M = loc
				M.flash_eyes()
				to_chat(M, SPAN_WARNING("Your [name] goes off!"))
	..()

/obj/item/device/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

//attack_as_weapon
/obj/item/device/flash/synthetic/attack(mob/living/M, mob/living/user, var/target_zone)
	..()
	if(!broken)
		broken = 1
		to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
		icon_state = "flashburnt"

/obj/item/device/flash/synthetic/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	..()
	if(!broken)
		broken = 1
		to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
		icon_state = "flashburnt"
