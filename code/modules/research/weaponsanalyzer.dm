/obj/machinery/weapons_analyzer
	name = "weapons analyzer"
	desc = "A research device which can be used to put together modular energy weapons, or to gain knowledge about the effectiveness of various objects as weaponry."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "weapon_analyzer"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 60
	active_power_usage = 2000

	var/obj/item/item = null
	var/process = FALSE

	component_types = list(
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/stock_parts/capacitor = 1,
			/obj/item/stock_parts/console_screen = 1
		)

/obj/machinery/weapons_analyzer/examine(mob/user)
	..()
	var/name_of_thing = ""
	if(item)
		name_of_thing = item.name
	to_chat(user, SPAN_NOTICE("It has [name_of_thing ? "[name_of_thing]" : "nothing"] attached."))

/obj/machinery/weapons_analyzer/attackby(var/obj/item/I, var/mob/user as mob)
	if(!I || !user || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(istype(I, /obj/item/gun))
		check_swap(user, I)
		item = I
		H.drop_from_inventory(I)
		I.forceMove(src)
		update_icon()
	else if(istype(I, /obj/item/device/laser_assembly))
		check_swap(user, I)
		var/obj/item/device/laser_assembly/A = I
		A.ready_to_craft = TRUE
		item = A
		H.drop_from_inventory(I)
		I.forceMove(src)
		A.analyzer = WEAKREF(src)
		update_icon()
	else if(istype(I, /obj/item/laser_components) && istype(item, /obj/item/device/laser_assembly))
		if(process)
			to_chat(user, SPAN_WARNING("\The [src] is busy installing a component already."))
			return
		var/obj/item/device/laser_assembly/A = item
		var/success = A.attackby(I, user)
		if(!success)
			return

		if(success == 2)
			playsound(loc, 'sound/machines/weapons_analyzer_finish.ogg', 75, 1)
			addtimer(CALLBACK(src, .proc/reset), 32)
		else
			playsound(loc, 'sound/machines/weapons_analyzer.ogg', 75, 1)
			addtimer(CALLBACK(src, .proc/reset), 15)
		process = TRUE
		update_icon()
	else if(I)
		check_swap(user, I)
		item = I
		H.drop_from_inventory(I)
		I.forceMove(src)
		update_icon()

/obj/machinery/weapons_analyzer/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/weapons_analyzer/proc/reset()
	process = FALSE
	update_icon()

/obj/machinery/weapons_analyzer/proc/check_swap(var/mob/user, var/obj/I)
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

/obj/machinery/weapons_analyzer/verb/eject()
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

/obj/machinery/weapons_analyzer/update_icon()
	icon_state = initial(icon_state)
	cut_overlays()

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
		gun_overlay.pixel_x += 7
		gun_overlay.pixel_y += 8
		add_overlay(gun_overlay)

/obj/machinery/weapons_analyzer/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		. = data = list()

	data["has_inserted"] = item ? TRUE : FALSE

	data["name"] = ""
	data["item"] = FALSE
	data["energy"] = FALSE
	data["gun"] = FALSE
	data["damage_type"] = "none"

	if(istype(item, /obj/item/device/laser_assembly))
		var/obj/item/device/laser_assembly/assembly = item
		data["name"] = assembly.name
		var/list/mods = list()
		data["gun_mods"] = mods
		for(var/i in list(assembly.capacitor, assembly.focusing_lens, assembly.modulator) + assembly.gun_mods)
			var/obj/item/laser_components/l_component = i
			if(!l_component)
				continue

			var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
			mods[initial(l_component.name)] = list(
				"reliability" = initial(l_component.reliability), "damage modifier" = initial(l_component.damage), "fire delay modifier" = initial(l_component.fire_delay),
					"shots modifier" = initial(l_component.shots), "burst modifier" = initial(l_component.burst), "accuracy modifier" = initial(l_component.accuracy), "repair tool" = l_repair_name
				)
		data["gun_mods"] = mods
	
	else if(istype(item, /obj/item/gun))
		var/obj/item/gun/gun = item
		data["name"] = gun.name
		data["gun"] = TRUE
		data["max_shots"] = 0
		data["recharge"] = "none"
		data["recharge_time"] = "none"
		data["damage"] = 0
		data["shrapnel_type"] = "none"
		data["armor_penetration"] = "none"
		data["gun_mods"] = FALSE

		if(istype(gun, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = gun
			var/obj/item/projectile/P = new E.projectile_type
			data["max_shots"] = initial(E.max_shots)
			data["recharge"] = initial(E.self_recharge) ? "self recharging" : "not self recharging"
			data["recharge_time"] = initial(E.recharge_time)
			data["damage"] = initial(P.damage)
			data["damage_type"] = initial(P.damage_type)
			data["check_armor"] = initial(P.check_armor)
			data["stun"] = initial(P.stun) ? "stuns" : "does not stun"
			if(P.shrapnel_type)
				var/obj/item/S = new P.shrapnel_type
				data["shrapnel_type"] = S.name
			else
				data["shrapnel_type"] = "none"
			data["armor_penetration"] = initial(P.armor_penetration)

			if(istype(gun, /obj/item/gun/energy/laser/prototype))
				var/obj/item/gun/energy/laser/prototype/E_prototype = gun
				var/list/mods = list()
				data["gun_mods"] = mods
				for(var/i in list(E_prototype.capacitor, E_prototype.focusing_lens, E_prototype.modulator) + E_prototype.gun_mods)
					var/obj/item/laser_components/l_component = i
					var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
					mods[initial(l_component.name)] = list(
						"reliability" = initial(l_component.reliability), "damage modifier" = initial(l_component.damage), "fire delay modifier" = initial(l_component.fire_delay),
						 "shots modifier" = initial(l_component.shots), "burst modifier" = initial(l_component.burst), "accuracy modifier" = initial(l_component.accuracy), "repair tool" = l_repair_name
						)
				data["gun_mods"] = mods

			if(E.secondary_projectile_type)
				var/obj/item/projectile/P_second = E.secondary_projectile_type
				data["secondary_damage"] = initial(P_second.damage)
				data["secondary_damage_type"] = initial(P_second.damage_type)
				data["secondary_check_armor"] = initial(P_second.check_armor)
				data["secondary_stun"] = initial(P_second.stun) ? "stuns" : "does not stun"
				data["secondary_shrapnel_type"] = initial(P_second.shrapnel_type) ? initial(P_second.shrapnel_type) : "none"
				data["secondary_armor_penetration"] = initial(P_second.armor_penetration)

		else
			var/obj/item/gun/projectile/P_gun = gun
			var/obj/item/ammo_casing/casing = new P_gun.ammo_type
			var/obj/item/projectile/P = new casing.projectile_type
			data["max_shots"] = P_gun.max_shells
			data["damage"] = initial(P.damage)
			data["damage_type"] = initial(P.damage_type)
			data["check_armor"] = initial(P.check_armor)
			data["stun"] = initial(P.stun) ? "stuns" : "does not stun"
			if(P.shrapnel_type)
				var/obj/item/S = new P.shrapnel_type
				data["shrapnel_type"] = S.name
			else
				data["shrapnel_type"] = "none"
		data["burst"] = gun.burst
		data["reliability"] = gun.reliability

	else if(item)
		data["name"] = item.name
		data["item"] = TRUE
		data["force"] = item.force
		data["sharp"] = item.sharp ? "yes" : "no"
		data["edge"] = item.edge ? "likely to dismember" : "unlikely to dismember"
		data["penetration"] = item.armor_penetration
		data["throw_force"] = item.throwforce
		data["damage_type"] = item.damtype
		if(istype(item, /obj/item/melee/energy))
			data["energy"] = TRUE
			var/obj/item/melee/energy/E_item = item
			data["active_force"] = E_item.active_force
			data["active_throw_force"] = E_item.active_throwforce
			data["can_block"] = E_item.can_block_bullets ? "can block" : "cannot block"
			data["base_reflectchance"] = E_item.base_reflectchance
			data["base_block_chance"] = E_item.base_block_chance
			data["shield_power"] = E_item.shield_power

/obj/machinery/weapons_analyzer/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	var/height = item ? 600: 300
	var/width = item ? 500 : 300
	if(istype(item, /obj/item/gun/energy/laser/prototype) || istype(item, /obj/item/device/laser_assembly))
		width = 600

	if (!ui)
		ui = new(user, src, "wanalyzer-analyzer", width, height, capitalize(name))

	if(item)
		var/icon/Icon_used = new /icon(item.icon, item.icon_state)
		ui.add_asset("icon", Icon_used) 
		ui.send_asset("icon")
	ui.open()

/obj/machinery/weapons_analyzer/Topic(href, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return

	if(href_list["print"] && item)
		do_print()

/obj/machinery/weapons_analyzer/proc/do_print()
	var/obj/item/paper/R = new /obj/item/paper(get_turf(src))
	R.color = "#fef8ff"
	R.set_content_unsafe("Weapon Analysis ([item.name])", get_print_info(item))
	print(R, message = "\The [src] beeps, printing \the [R] after a moment.")

/obj/machinery/weapons_analyzer/proc/get_print_info(var/obj/item/device)
	var/dat = "<span class='notice'><b>Analysis performed at [worldtime2text()]</b></span><br>"
	dat += "<span class='notice'><b>Analyzer Item: [device.name]</b></span><br><br>"
	dat += device.get_print_info()
	return dat
