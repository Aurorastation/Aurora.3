
/obj/machinery/deployableshield
	name = "energy barricade"
	desc = "A deployable energy barricade."
	density = 0
	anchored = 1
	opacity = 0
	icon = 'icons/obj/deployableshield.dmi'
	icon_state = "deployableshield_open"
	req_access = list(access_sec_doors)
	idle_power_usage = 0
	use_power = 0
	var/on = FALSE
	var/shieldhealth = 100
	var/shieldmaxhealth = 100
	var/open = 0

/obj/machinery/deployableshield/bullet_act(var/obj/item/projectile/Proj)
	var/bullet_damage = Proj.get_structure_damage()
	if(!bullet_damage)
		return
	

	shieldhealth -= bullet_damage / 2
	..()
	if(shieldhealth <= 0)
		delamshield()
	return

/obj/machinery/deployableshield/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			delamshield()
			return
		if(3.0)
			if(prob(50))
				delamshield()
				return


/obj/machinery/deployableshield/CollidedWith(atom/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(on && (emagged))
			shock(M,85)
		

/obj/machinery/deployableshield/attack_hand(mob/user as mob)
	add_fingerprint(user)
	return


/obj/machinery/deployableshield/AltClick(mob/user)
	if(isrobot(user))
		if(!on && (!open))
			closeshield()
			src.visible_message("\The [src] buzz's as the field comes to life.", "You hear something hum sharply.")
		else if(!open)
			openshield()
			src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")
	else
		return

	

/obj/machinery/deployableshield/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if(!check_access(W))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		if(!on && (!open))
			closeshield()
			src.visible_message("\The [src] buzz's as the field comes to life.", "You hear something hum sharply.")
		else if(!open)
			openshield()
			src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")


	if(istype(W, /obj/item/weapon/energyshield_generator))
		var/obj/item/weapon/energyshield_generator/S = W
		src.visible_message("\The [src] is loaded into the [S].", "You hear gears whining.")
		S.shieldsleft += 1
		qdel(src)

	if(W.isscrewdriver())
		open = !open
		to_chat(user, "<span class='notice'>Maintenance panel is now [src.open ? "opened" : "closed"].</span>")

	if(W.iswelder())
		if(shieldhealth < shieldmaxhealth)
			if(open)
				if (do_after(user, 40))
					shieldhealth = min(shieldmaxhealth, shieldhealth+25)
					user.visible_message("<span class='warning'>[user] repairs [src]!</span>","<span class='notice'>You repair [src]!</span>")
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			else
				to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
		else
			to_chat(user, "<span class='notice'>[src] does not need repaired.</span>")
	else if(W.damtype == BRUTE || W.damtype == BURN)
		attackshield(W.force)
		..()
	return

/obj/machinery/deployableshield/emag_act(var/remaining_charges, var/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "<span class='warning'>You short out [src]'s maintenance hatch lock.</span>")
		log_and_message_admins("emagged [src]'s maintenance hatch lock")
		return 1

/obj/machinery/deployableshield/proc/attackshield(var/damage)
	shieldhealth = max(0, shieldhealth - damage)
	if(shieldhealth <= 0)
		delamshield(1)


/obj/machinery/deployableshield/proc/openshield()
	density = 0
	opacity = 0
	on = FALSE
	idle_power_usage = 80
	use_power = 0
	update_icon()

/obj/machinery/deployableshield/proc/closeshield()
	density = 1
	opacity = 0
	on = TRUE
	idle_power_usage = 6000
	use_power = 1
	update_icon()

/obj/machinery/deployableshield/update_icon()
	if(!on)
		icon_state = "deployableshield_open"
	else
		icon_state = "deployableshield_closed"

/obj/machinery/deployableshield/proc/delamshield()
	var/turf/T = src.loc
	tesla_zap(T, 3, 2500)
	spark(T, 5, alldirs)
	new /obj/item/stack/material/steel(T, 5)
	qdel(src)