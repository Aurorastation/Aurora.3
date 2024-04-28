/mob/living/heavy_vehicle/proc/dismantle()
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	var/obj/structure/heavy_vehicle_frame/frame = new(get_turf(src))
	for(var/hardpoint in hardpoints)
		remove_system(hardpoint, force = 1)
	hardpoints.Cut()

	remove_arms(frame)
	remove_legs(frame)
	remove_body(frame)
	remove_head(frame)

	frame.is_wired = FRAME_WIRED_ADJUSTED
	frame.is_reinforced = FRAME_REINFORCED_WELDED
	frame.set_name = name
	frame.name = "frame of \the [frame.set_name]"
	frame.queue_icon_update()

	qdel(src)

/mob/living/heavy_vehicle/proc/remove_body_part(obj/item/mech_component/part, atom/dest)
	if(!part)
		return

	if(!dest)
		dest = get_turf(src)

	if(part == arms)
		remove_arms(dest)
	else if(part == legs)
		remove_legs(dest)
	else if(part == body)
		remove_body(dest)
	else if(part == head)
		remove_head(dest)

/mob/living/heavy_vehicle/proc/remove_arms(atom/dest)
	if(!arms)
		return

	var/obj/structure/heavy_vehicle_frame/frame = dest

	if(istype(frame))
		frame.arms = arms

	arms.forceMove(dest)
	arms = null

/mob/living/heavy_vehicle/proc/remove_legs(atom/dest)
	if(!legs)
		return

	pass_flags &= PASSRAILING //if previously was hoverthrusters, need to update pass flag

	var/obj/structure/heavy_vehicle_frame/frame = dest

	if(istype(frame))
		frame.legs = legs

	legs.forceMove(dest)
	legs = null

/mob/living/heavy_vehicle/proc/remove_body(atom/dest)
	if(!body)
		return

	var/obj/structure/heavy_vehicle_frame/frame = dest

	if(istype(frame))
		frame.body = body

	body.forceMove(dest)
	body = null

/mob/living/heavy_vehicle/proc/remove_head(atom/dest)
	if(!head)
		return

	var/obj/structure/heavy_vehicle_frame/frame = dest

	if(istype(frame))
		frame.head = head

	head.forceMove(dest)
	head = null

/mob/living/heavy_vehicle/proc/forget_module(var/module_to_forget)
	//Realistically a module disappearing without being uninstalled is wrong and a bug or adminbus
	var/target = null
	for(var/hardpoint in hardpoints)
		if(hardpoints[hardpoint]== module_to_forget)
			target = hardpoint
			break

	if(target)
		hardpoints[target] = null

	if(target == selected_hardpoint)
		clear_selected_hardpoint()

	GLOB.destroyed_event.unregister(module_to_forget, src, PROC_REF(forget_module))

	var/obj/screen/mecha/hardpoint/H = hardpoint_hud_elements[target]
	H.holding = null

	hud_elements -= module_to_forget
	refresh_hud()
	queue_icon_update()

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot && pilot.client)
			pilot.client.screen -= module_to_forget

/mob/living/heavy_vehicle/proc/install_system(var/obj/item/system, var/system_hardpoint, var/mob/user)
	if(hardpoints_locked || hardpoints[system_hardpoint])
		return 0

	if(user)
		var/delay = 30
		if(delay > 0)
			user.visible_message("<span class='notice'>\The [user] begins trying to install \the [system] into \the [src].</span>")
			if(!do_after(user, delay, src) || user.get_active_hand() != system)
				return FALSE

			if(user.unEquip(system))
				to_chat(user, "<span class='notice'>You install \the [system] in \the [src]'s [system_hardpoint].</span>")
				playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			else return FALSE
	var/obj/item/mecha_equipment/ME = system
	if(istype(ME))
		if(ME.restricted_hardpoints && !(system_hardpoint in ME.restricted_hardpoints))
			return FALSE
		if(ME.restricted_software)
			if(!head || !head.software)
				return FALSE
			var/found
			for(var/software in ME.restricted_software)
				if(software in head.software.installed_software)
					found = TRUE
					break
			if(!found)
				return FALSE
		ME.installed(src)
		GLOB.destroyed_event.register(system, src, PROC_REF(forget_module))


	system.forceMove(src)
	hardpoints[system_hardpoint] = system

	var/obj/screen/mecha/hardpoint/H = hardpoint_hud_elements[system_hardpoint]
	H.holding = system

	system.screen_loc = H.screen_loc
	system.hud_layerise()

	hud_elements |= system
	refresh_hud()
	queue_icon_update()

	return 1

/mob/living/heavy_vehicle/proc/remove_system_interact(var/system_hardpoint, var/mob/user, var/force)
	if((hardpoints_locked && !force) || !hardpoints[system_hardpoint])
		return 0

	var/obj/item/system = hardpoints[system_hardpoint]
	if(user)
		var/delay = 30
		if(delay > 0)
			user.visible_message("<span class='notice'>\The [user] begins trying to remove \the [system] from \the [src].</span>")
			if(!do_after(user, delay, src) || hardpoints[system_hardpoint] != system)
				return FALSE

	remove_system(system_hardpoint, force)

	if(user)
		system.forceMove(get_turf(user))
		user.put_in_hands(system)
		to_chat(user, "<span class='notice'>You remove \the [system] in \the [src]'s [system_hardpoint].</span>")
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

/mob/living/heavy_vehicle/proc/remove_system(var/system_hardpoint, var/force)
	if((hardpoints_locked && !force) || !hardpoints[system_hardpoint])
		return 0

	var/obj/item/system = hardpoints[system_hardpoint]
	hardpoints[system_hardpoint] = null

	if(system_hardpoint == selected_hardpoint)
		clear_selected_hardpoint()

	var/obj/item/mecha_equipment/ME = system
	if(istype(ME))
		ME.uninstalled()
	system.forceMove(get_turf(src))
	system.screen_loc = null
	system.layer = initial(system.layer)
	GLOB.destroyed_event.unregister(system, src, PROC_REF(forget_module))

	var/obj/screen/mecha/hardpoint/H = hardpoint_hud_elements[system_hardpoint]
	H.holding = null

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot && pilot.client)
			pilot.client.screen -= system

	hud_elements -= system
	refresh_hud()
	queue_icon_update()

	return system
