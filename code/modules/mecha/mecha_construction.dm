/mob/living/heavy_vehicle/proc/dismantle()
	var/obj/structure/heavy_vehicle_frame/frame = new(get_turf(src))
	frame.arms = arms
	frame.body = body
	frame.head = head
	frame.legs = legs

	arms.forceMove(frame)
	legs.forceMove(frame)
	body.forceMove(frame)
	head.forceMove(frame)

	frame.is_wired = 0
	frame.is_reinforced = 3
	frame.set_name = name
	frame.name = "frame of \the [frame.set_name]"
	frame.update_icon()
	qdel(src)
	return

/mob/living/heavy_vehicle/proc/install_system(var/obj/item/system, var/system_hardpoint, var/mob/user)

	if(hardpoints_locked || hardpoints[system_hardpoint])
		return 0

	var/obj/item/weapon/mecha_equipment/ME = system
	if(istype(ME))
		if(ME.restricted_hardpoints && !(system_hardpoint in ME.restricted_hardpoints))
			return 0
		if(ME.restricted_software)
			if(!head || !head.software)
				return 0
			var/found
			for(var/software in ME.restricted_software)
				if(software in head.software.installed_software)
					found = 1
					break
			if(!found)
				return 0
		ME.owner = src

	if(user)
		user.unEquip(system)
		user << "<span class='notice'>You install \the [system] in \the [src]'s [system_hardpoint].</span>"
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	system.forceMove(src)
	hardpoints[system_hardpoint] = system

	var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[system_hardpoint]
	H.holding = system

	system.screen_loc = H.screen_loc
	system.layer = H.layer+0.1

	hud_elements |= system
	refresh_hud()
	update_hardpoint_overlays()

	return 1

/mob/living/heavy_vehicle/proc/remove_system(var/system_hardpoint, var/mob/user)

	if(hardpoints_locked || !hardpoints[system_hardpoint])
		return 0

	var/obj/item/system = hardpoints[system_hardpoint]
	hardpoints[system_hardpoint] = null

	if(system_hardpoint == selected_hardpoint)
		clear_selected_hardpoint()

	var/obj/item/weapon/mecha_equipment/ME = system
	if(istype(ME)) ME.owner = null
	system.forceMove(get_turf(src))
	system.screen_loc = null
	system.layer = initial(system.layer)

	var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[system_hardpoint]
	H.holding = null

	if(pilot && pilot.client)
		pilot.client.screen -= system
	hud_elements -= system
	refresh_hud()
	update_hardpoint_overlays()

	if(user)
		system.forceMove(get_turf(user))
		user.put_in_hands(system)
		user << "<span class='notice'>You remove \the [system] from \the [src]'s [system_hardpoint].</span>"
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	return 1