/obj/machinery/r_n_d/weapons_analyzer
	name = "weapons analyzer"
	desc = "A research device which can be used to put together modular energy weapons, or to gain knowledge about the effectiveness of various objects as weaponry."
	icon_state = "weapon_analyzer"
	idle_power_usage = 60
	active_power_usage = 2000
	var/obj/item/item = null
	var/process = FALSE

	component_types = list(
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/stock_parts/capacitor = 1,
			/obj/item/stock_parts/console_screen = 1
		)

/obj/machinery/r_n_d/weapons_analyzer/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("It has [item ? "[item.name]" : "nothing"] attached.")

/obj/machinery/r_n_d/weapons_analyzer/attackby(obj/item/attacking_item, mob/user)
	if(!attacking_item || !user || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(istype(attacking_item, /obj/item/gun))
		check_swap(user, attacking_item)
		item = attacking_item
		H.drop_from_inventory(attacking_item)
		attacking_item.forceMove(src)
		update_icon()
	else if(istype(attacking_item, /obj/item/device/laser_assembly))
		check_swap(user, attacking_item)
		var/obj/item/device/laser_assembly/A = attacking_item
		A.ready_to_craft = TRUE
		item = A
		H.drop_from_inventory(attacking_item)
		attacking_item.forceMove(src)
		A.analyzer = WEAKREF(src)
		update_icon()
	else if(istype(attacking_item, /obj/item/laser_components) && istype(item, /obj/item/device/laser_assembly))
		if(process)
			to_chat(user, SPAN_WARNING("\The [src] is busy installing a component already."))
			return
		var/obj/item/device/laser_assembly/A = item
		var/success = A.attackby(attacking_item, user)
		if(!success)
			return

		if(success == 2)
			playsound(loc, 'sound/machines/weapons_analyzer_finish.ogg', 75, 1)
			addtimer(CALLBACK(src, PROC_REF(reset)), 32)
		else
			playsound(loc, 'sound/machines/weapons_analyzer.ogg', 75, 1)
			addtimer(CALLBACK(src, PROC_REF(reset)), 15)
		process = TRUE
		update_icon()
	else if(attacking_item)
		check_swap(user, attacking_item)
		item = attacking_item
		H.drop_from_inventory(attacking_item)
		attacking_item.forceMove(src)
		update_icon()

/obj/machinery/r_n_d/weapons_analyzer/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/r_n_d/weapons_analyzer/proc/reset()
	process = FALSE
	update_icon()

/obj/machinery/r_n_d/weapons_analyzer/proc/check_swap(var/mob/user, var/obj/I)
	if(item)
		to_chat(user, SPAN_NOTICE("You swap \the [item] out for \the [I]."))
		if(istype(item, /obj/item/device/laser_assembly))
			var/obj/item/device/laser_assembly/A = item
			A.ready_to_craft = FALSE
			A.analyzer = null
		item.forceMove(get_turf(src))
		user.put_in_hands(item)
		item = null
		update_icon()

/obj/machinery/r_n_d/weapons_analyzer/verb/eject()
	set name = "Eject Inserted Item"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(istype(item, /obj/item/device/laser_assembly))
		var/obj/item/device/laser_assembly/A = item
		A.ready_to_craft = FALSE
		A.analyzer = null
		A.forceMove(get_turf(src))
		item = null
		update_icon()

	else if(item)
		item.forceMove(get_turf(src))
		item = null
		update_icon()

	else
		to_chat(usr, SPAN_WARNING("There is nothing in \the [src]."))

/obj/machinery/r_n_d/weapons_analyzer/update_icon()
	icon_state = initial(icon_state)
	ClearOverlays()

	var/icon/Icon_used

	if(istype(item, /obj/item/device/laser_assembly))
		var/obj/item/device/laser_assembly/A = item
		A.update_icon()
		icon_state = process ?  "[icon_state]_working" : "[icon_state]_on"
		Icon_used = new /icon(item.icon, item.icon_state)
	else if(item)
		icon_state = "[icon_state]_on"
		Icon_used = new /icon(item.icon, item.icon_state)

	if(Icon_used)
		// Making gun sprite smaller and centering it where we want, cause dang they are thicc
		Icon_used.Scale(round(Icon_used.Width() * 0.75), round(Icon_used.Height() * 0.75))
		var/image/gun_overlay = image(Icon_used)
		gun_overlay.pixel_x += 4
		gun_overlay.pixel_y += 12
		AddOverlays(gun_overlay)

/obj/machinery/r_n_d/weapons_analyzer/ui_data(mob/user)
	var/list/data = list()

	if(istype(item, /obj/item/device/laser_assembly))
		var/obj/item/device/laser_assembly/assembly = item
		var/list/mods = list()
		for(var/i in list(assembly.capacitor, assembly.focusing_lens, assembly.modulator) + assembly.gun_mods)
			var/obj/item/laser_components/l_component = i
			if(!l_component)
				continue

			var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
			mods += list(list(
				"name" = initial(l_component.name),
				"reliability" = initial(l_component.reliability),
				"damage_modifier" = initial(l_component.damage),
				"fire_delay_modifier" = initial(l_component.fire_delay),
				"shots_modifier" = initial(l_component.shots),
				"burst_modifier" = initial(l_component.burst),
				"accuracy_modifier" = initial(l_component.accuracy),
				"repair_tool" = l_repair_name
			))
		data["gun_mods"] = mods
		data["laser_assembly"] = list("name" = assembly.name)

	else if(istype(item, /obj/item/gun))
		var/obj/item/gun/gun = item
		data["gun"] = list(
			"name" = gun.name,
			"max_shots" = 0,
			"recharge" = "none",
			"recharge_time" = "none",
			"damage" = 0,
			"shrapnel_type" = "none",
			"armor_penetration" = "none",
			"gun_mods" = "none",
			"stun" = "does not stun"
		)

		if(istype(gun, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = gun
			var/obj/projectile/P = new E.projectile_type
			data["gun"]["max_shots"] = initial(E.max_shots)
			data["gun"]["recharge"] = initial(E.self_recharge) ? "self recharging" : "not self recharging"
			data["gun"]["recharge_time"] = initial(E.recharge_time)
			data["gun"]["damage"] = initial(P.damage)
			data["gun"]["damage_type"] = initial(P.damage_type)
			data["gun"]["check_armor"] = initial(P.check_armor)
			data["gun"]["stun"] = initial(P.stun) ? "stuns" : "does not stun"
			if(P.shrapnel_type)
				var/obj/item/S = new P.shrapnel_type
				data["gun"]["shrapnel_type"] = S.name
			else
				data["gun"]["shrapnel_type"] = "none"
			data["gun"]["armor_penetration"] = initial(P.armor_penetration)

			if(istype(gun, /obj/item/gun/energy/laser/prototype))
				var/obj/item/gun/energy/laser/prototype/E_prototype = gun
				var/list/mods = list()
				for(var/i in list(E_prototype.capacitor, E_prototype.focusing_lens, E_prototype.modulator) + E_prototype.gun_mods)
					var/obj/item/laser_components/l_component = i
					var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
					mods += list(list(
						"name" = initial(l_component.name),
						"reliability" = initial(l_component.reliability),
						"damage_modifier" = initial(l_component.damage),
						"fire_delay_modifier" = initial(l_component.fire_delay),
						"shots_modifier" = initial(l_component.shots),
						"burst_modifier" = initial(l_component.burst),
						"accuracy_modifier" = initial(l_component.accuracy),
						"repair_tool" = l_repair_name
					))
				data["gun_mods"] = mods

			if(E.secondary_projectile_type)
				var/obj/projectile/P_second = E.secondary_projectile_type
				data["gun"]["secondary_damage"] = initial(P_second.damage)
				data["gun"]["secondary_damage_type"] = initial(P_second.damage_type)
				data["gun"]["secondary_check_armor"] = initial(P_second.check_armor)
				data["gun"]["secondary_stun"] = initial(P_second.stun) ? "stuns" : "does not stun"
				data["gun"]["secondary_shrapnel_type"] = initial(P_second.shrapnel_type) ? initial(P_second.shrapnel_type) : "none"
				data["gun"]["secondary_armor_penetration"] = initial(P_second.armor_penetration)

		else
			var/obj/item/gun/projectile/P_gun = gun
			var/obj/item/ammo_casing/casing = new P_gun.ammo_type
			var/obj/projectile/P = new casing.projectile_type
			data["gun"]["max_shots"] = P_gun.max_shells
			data["gun"]["damage"] = initial(P.damage)
			data["gun"]["damage_type"] = initial(P.damage_type)
			data["gun"]["check_armor"] = initial(P.check_armor)
			data["gun"]["stun"] = initial(P.stun) ? "stuns" : "does not stun"
			if(P.shrapnel_type)
				var/obj/item/S = new P.shrapnel_type
				data["shrapnel_type"] = S.name
			else
				data["shrapnel_type"] = "none"
		data["gun"]["burst"] = gun.burst
		data["gun"]["reliability"] = gun.reliability

	else if(item)
		data["item"] = list()
		data["item"]["name"] = item.name
		data["item"]["force"] = item.force
		data["item"]["sharp"] = item.sharp ? "yes" : "no"
		data["item"]["edge"] = item.edge ? "likely to dismember" : "unlikely to dismember"
		data["item"]["penetration"] = item.armor_penetration
		data["item"]["throw_force"] = item.throwforce
		data["item"]["damage_type"] = item.damtype
		if(istype(item, /obj/item/melee/energy))
			data["item"]["energy"] = TRUE
			var/obj/item/melee/energy/E_item = item
			data["item"]["active_force"] = E_item.active_force
			data["item"]["active_throw_force"] = E_item.active_throwforce
			data["item"]["can_block"] = E_item.can_block_bullets ? "can block" : "cannot block"
			data["item"]["base_reflect_chance"] = E_item.base_reflectchance
			data["item"]["base_block_chance"] = E_item.base_block_chance
			data["item"]["shield_power"] = E_item.shield_power
	return data

/obj/machinery/r_n_d/weapons_analyzer/ui_interact(mob/user, var/datum/tgui/ui)
	var/height = item ? 600: 300
	var/width = item ? 500 : 300
	if(istype(item, /obj/item/gun/energy/laser/prototype) || istype(item, /obj/item/device/laser_assembly))
		width = 600

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WeaponsAnalyzer", "Weapons Analyzer", width, height)
		ui.open()

	ui.open()

/obj/machinery/r_n_d/weapons_analyzer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if((action == "print") && item)
		do_print()
		. = TRUE

/obj/machinery/r_n_d/weapons_analyzer/proc/do_print()
	var/obj/item/paper/R = new /obj/item/paper(get_turf(src))
	R.color = "#fef8ff"
	R.set_content_unsafe("Weapon Analysis ([item.name])", get_print_info(item))
	print(R, message = "\The [src] beeps, printing \the [R] after a moment.", user = usr)

/obj/machinery/r_n_d/weapons_analyzer/proc/get_print_info(var/obj/item/device)
	var/dat = "<span class='notice'><b>Analysis performed at [worldtime2text()]</b></span><br>"
	dat += "<span class='notice'><b>Analyzer Item: [device.name]</b></span><br><br>"
	dat += device.get_print_info()
	return dat
