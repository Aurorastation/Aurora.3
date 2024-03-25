/obj/item/camera_assembly
	name = "camera assembly"
	desc = "A pre-fabricated security camera kit, ready to be assembled and mounted to a surface."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "cameracase"
	w_class = ITEMSIZE_SMALL
	anchored = 0

	matter = list(MATERIAL_ALUMINIUM = 700, MATERIAL_GLASS = 300)

	//	Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_upgrades = list(/obj/item/device/assembly/prox_sensor, /obj/item/stack/material/osmium, /obj/item/stock_parts/scanning_module)
	var/list/upgrades = list()
	var/camera_name
	var/camera_network
	var/state = 0
	var/busy = 0
	/*
				0 = Nothing done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach upgrades)
				4 = Screwdriver panel closed and is fully built (you cannot attach upgrades)
	*/

/obj/item/camera_assembly/attackby(obj/item/attacking_item, mob/user)

	switch(state)

		if(0)
			// State 0
			if(attacking_item.iswrench() && isturf(src.loc))
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "You wrench the assembly into place.")
				anchored = 1
				state = 1
				update_icon()
				auto_turn()
				return TRUE

		if(1)
			// State 1
			if(attacking_item.iswelder())
				if(weld(attacking_item, user))
					to_chat(user, "You weld the assembly securely into place.")
					anchored = 1
					state = 2
				return TRUE

			else if(attacking_item.iswrench())
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "You unattach the assembly from its place.")
				anchored = 0
				update_icon()
				state = 0
				return TRUE

		if(2)
			// State 2
			if(attacking_item.iscoil())
				var/obj/item/stack/cable_coil/C = attacking_item
				if(C.use(2))
					to_chat(user, "<span class='notice'>You add wires to the assembly.</span>")
					state = 3
				else
					to_chat(user, "<span class='warning'>You need 2 coils of wire to wire the assembly.</span>")
				return TRUE

			else if(attacking_item.iswelder())

				if(weld(attacking_item, user))
					to_chat(user, "You unweld the assembly from its place.")
					state = 1
					anchored = 1
				return TRUE


		if(3)
			// State 3
			if(attacking_item.isscrewdriver())
				attacking_item.play_tool_sound(get_turf(src), 50)

				var/input = sanitize( tgui_input_text(user, "Which networks would you like to connect this camera to? Separate networks with a comma. No Spaces!\nFor example: Station,Security,Secret",
											"Set Network", (camera_network ? camera_network : NETWORK_STATION)) )
				if(!input)
					to_chat(usr, "No input found please hang up and try your call again.")
					return TRUE

				var/list/tempnetwork = text2list(input, ",")
				if(tempnetwork.len < 1)
					to_chat(usr, "No network found please hang up and try your call again.")
					return TRUE

				var/area/camera_area = get_area(src)
				var/temptag = "[sanitize(camera_area.name)] ([rand(1, 999)])"
				input = sanitizeSafe( tgui_input_text(user, "How would you like to name the camera?", "Set Camera Name", (camera_name ? camera_name : temptag), MAX_NAME_LEN), MAX_NAME_LEN )

				state = 4
				var/obj/machinery/camera/C = new(src.loc)
				src.forceMove(C)
				C.assembly = src

				C.auto_turn()

				C.replace_networks(uniquelist(tempnetwork))

				C.c_tag = input

				for(var/i = 5; i >= 0; i -= 1)
					var/direct = tgui_input_list(user, "Direction?", "Assembling Camera", list("Confirm", "NORTH", "EAST", "SOUTH", "WEST"))
					if(direct != "Confirm")
						C.dir = text2dir(direct)
						C.set_pixel_offsets()
					if(i != 0)
						var/confirm = tgui_input_list(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", list("Yes", "No"))
						if(confirm == "Yes")
							break
				return TRUE

			else if(attacking_item.iswirecutter())

				new/obj/item/stack/cable_coil(get_turf(src), 2)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, "You cut the wires from the circuits.")
				state = 2
				return TRUE

	// Upgrades!
	if(is_type_in_list(attacking_item, possible_upgrades) && !is_type_in_list(attacking_item, upgrades)) // Is a possible upgrade and isn't in the camera already.
		if(istype(attacking_item, /obj/item/stock_parts/scanning_module))
			var/obj/item/stock_parts/scanning_module/SM = attacking_item
			if(SM.rating < 2)
				to_chat(user, SPAN_WARNING("That scanning module doesn't seem advanced enough."))
				return
		to_chat(user, "You attach \the [attacking_item] into the assembly inner circuits.")
		upgrades += attacking_item
		user.remove_from_mob(attacking_item)
		attacking_item.forceMove(src)
		return

	// Taking out upgrades
	else if(attacking_item.iscrowbar() && upgrades.len)
		var/obj/U = locate(/obj) in upgrades
		if(U)
			to_chat(user, "You unattach an upgrade from the assembly.")
			attacking_item.play_tool_sound(get_turf(src), 50)
			U.forceMove(get_turf(src))
			upgrades -= U
		return

	..()

/obj/item/camera_assembly/update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/camera_assembly/attack_hand(mob/user as mob)
	if(!anchored)
		..()

/obj/item/camera_assembly/proc/weld(var/obj/item/weldingtool/WT, var/mob/user)

	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	to_chat(user, "<span class='notice'>You start to weld the [src]..</span>")
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	user.flash_act(FLASH_PROTECTION_MAJOR)
	busy = 1
	if(WT.use_tool(src, user, 20, volume = 50))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0
