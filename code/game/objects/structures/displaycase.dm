/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox"
	desc = "A display case for valuable possessions."
	density = 1
	anchored = 1
	unacidable = 1
	var/health = 30
	var/maxhealth = 30
	var/destroyed = FALSE
	var/item_x_offset = 0
	var/item_y_offset = 1
	var/case_security = 1
	var/delayed_alarm = FALSE
	var/alarm_delay = 20
	var/obj/item/displayed_item = null
	var/held_item = /obj/item/gun/energy/captain
	var/alarm = TRUE
	var/access_needed = access_keycard_auth
	var/open = FALSE


/obj/structure/displaycase/spareid
	name = "spare id containment case"
	desc = "A display case for holding the captain's spare ID, it seems to have a device installed on the side."
	held_item = /obj/item/card/id/captains_spare
	alarm_delay = 3 SECONDS
	case_security = 2


/obj/structure/displaycase/Initialize()
	. = ..()
	if(!displayed_item)
		displayed_item = new held_item(src)
	update_icon()

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/material/shard( src.loc )
			if (displayed_item)
				displayed_item.forceMove(src.loc)
				displayed_item = null
			qdel(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()


/obj/structure/displaycase/proc/open_close(mob/user)
	open = !open
	alarm = !alarm
	visible_message("<span class='notice'>The display case is now [src.open ? "opened" : "closed"].</span>")
	update_icon()

/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	src.healthcheck()
	return

/obj/structure/displaycase/proc/tripalarm(case_security)
	var/area/case_area = get_area(src)
	switch(case_security)
		if(1)
			visible_message("<span class='notice'>[src] pings cheerfully.</span>", "<span class='notice'>You hear a ping.</span>")
		if(2)
			priority_announcement.Announce("Warning, a company asset has been removed from it's storage case. Crew are advised to keep assets in there assigned storage cases.")
		if(3)
			set_security_level(SEC_LEVEL_BLUE)
			priority_announcement.Announce("Warning, a company asset has been removed from the storage case in the [case_area.name]. A blue alert level has been enacted to allow security to recover the asset.")
/obj/structure/displaycase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = 0
			src.destroyed = TRUE
			src.open = TRUE
			new /obj/item/material/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
	return

/obj/structure/displaycase/update_icon()
	underlays.Cut()
	if(displayed_item)
		var/image/I
		I = image(displayed_item.icon, displayed_item.icon_state)
		I.pixel_x = item_x_offset
		I.pixel_y = item_y_offset
		underlays += I
	if(destroyed)
		icon_state = "glassboxb0"
	if(open && !destroyed)
		icon_state = "glassbox_open"
	if(!open && !destroyed)
		icon_state = "glassbox"
	return


/obj/structure/displaycase/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/card/id))
		var/obj/item/card/id/C = W
		if(src.access_needed in C.access && !destroyed)
			open_close(user)
			update_icon()
	if(istype(W,/obj/item))
		if(open && !displayed_item && !destroyed)
			user.drop_from_inventory(W,src)
			W.forceMove(src)
			displayed_item = W
			update_icon()
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == "glass")
		var/obj/item/stack/G = W
		if(health >= maxhealth && !destroyed)
			to_chat(user, "<span class='notice'>The case cannot be repaired further!.</span>")
			return
		if(health <= maxhealth && !destroyed)
			if(G.use(2))
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You carefully apply some panes and fix the glass on [src].</span>")
				health = Clamp(health + maxhealth/5, 0, maxhealth)
			else
				to_chat(user, "<span class='warning'>You need 2 sheets of glass to repair this!.</span>")
	else if(user.a_intent == I_HURT && !destroyed)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		src.health -= W.force
		src.healthcheck()
		..()
		return

/obj/structure/displaycase/attack_hand(mob/user as mob)
	if (src.open && displayed_item)
		to_chat(user, "<span class='notice'>You remove the [displayed_item.name].</span>")
		displayed_item.forceMove(src.loc)
		displayed_item = null
		src.add_fingerprint(user)
		update_icon()
		if(alarm)
			if(delayed_alarm)
				addtimer(CALLBACK(src, .proc/tripalarm, case_security), alarm_delay)
			else
				tripalarm(case_security)
		return
	else
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, "<span class='warning'>[usr] kicks the display case.</span>")
		src.health -= 2
		healthcheck()
		return