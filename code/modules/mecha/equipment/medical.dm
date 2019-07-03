/obj/item/weapon/mecha_equipment/sleeper
	name = "mounted stasis capsule"
	desc = "A compact cryogenic storage unit for an injured patient."
	icon_state = "mecha_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	flags = NOBLUDGEON
	restricted_software = list(MECH_SOFTWARE_MEDICAL)

	var/mob/living/occupant

/obj/item/weapon/mecha_equipment/sleeper/attack_self(var/mob/user)
	if(istype(loc, /mob/living/heavy_vehicle))
		return eject()
	return

/obj/item/weapon/mecha_equipment/sleeper/attack()
	return

/obj/item/weapon/mecha_equipment/sleeper/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	if(!istype(loc, /mob/living/heavy_vehicle))
		return
	if(!inrange)
		return
	if(target == src)
		return
	if(istype(target, /mob/living))
		if(occupant)
			user << "<span class='warning'>\The [src] already has someone inside.</span>"
			return
		visible_message("<span class='notice'>\The [src] begins loading \the [target] into \the [src].</span>")
		var/mob/living/M = target
		if(do_after(user, 20) && src && owner && M && user && owner.Adjacent(M))
			target << "<span class='notice'>\The [owner] scoops you into \the [src], and everything goes dark and cool.</span>"
			occupant = M
			M.forceMove(src)
	else
		user << "<span class='notice'>You eject \the [occupant] from \the [src].</span>"
		eject(target)
		return

/obj/item/weapon/mecha_equipment/sleeper/get_hardpoint_status_value()
	return (occupant ? (occupant.health/occupant.maxHealth) : null)

/obj/item/weapon/mecha_equipment/sleeper/get_hardpoint_maptext()
	return (occupant ? "[round((occupant.health/occupant.maxHealth)*100)]%" : null)

/obj/item/weapon/mecha_equipment/sleeper/proc/eject(var/target)
	if(!occupant)
		return
	if(!target)
		target = src
	occupant.forceMove(get_turf(target))
	if(occupant.client)
		occupant.client.eye = occupant
	occupant = null