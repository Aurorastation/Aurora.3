/obj/machinery/weapons_analyzer
	name = "Weapons Analyzer"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "weapon_analyzer"
	density = 1
	anchored = 1
	use_power = 1
	var/obj/item/gun/gun = null
	var/obj/item/item = null
	var/obj/item/device/laser_assembly/assembly = null
	var/process = FALSE

/obj/machinery/weapons_analyzer/examine(mob/user)
	..()
	var/name_of_thing
	if(gun)
		name_of_thing = gun.name
	else if(item)
		name_of_thing = item.name
	to_chat(user, span("notice", "It has [name_of_thing ? "[name_of_thing]" : "nothing"] attached."))

/obj/machinery/weapons_analyzer/attackby(var/obj/item/I, var/mob/user as mob)
	if(!I || !user || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(istype(I, /obj/item/gun))

		if(!check_gun(user))
			return

		gun = I

		H.drop_from_inventory(I)
		I.forceMove(src)
		update_icon()
	else if(istype(I, /obj/item/device/laser_assembly))
		if(!check_gun(user))
			return

		var/obj/item/device/laser_assembly/A = I
		A.ready_to_craft = TRUE
		assembly = A
		H.drop_from_inventory(I)
		I.forceMove(src)
		A.analyzer = WEAKREF(src)
		update_icon()
	else if(istype(I, /obj/item/laser_components))
		if(!assembly)
			to_chat(user, span("warning", "\The [src] does not have any assembly installed!"))
			return
		if(process)
			to_chat(user, span("warning", "\The [src] is busy installing component!"))
			return
		assembly.attackby(I, user)
		playsound(loc, 'sound/machines/weapns_analyzer.ogg', 75, 1)
		process = TRUE
		addtimer(CALLBACK(src, .proc/reset), 65)
		update_icon()
	else if(I)
		item = I
		H.drop_from_inventory(I)
		I.forceMove(src)
		update_icon()

/obj/machinery/weapons_analyzer/attack_hand(mob/user as mob)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/weapons_analyzer/proc/reset()
	process = FALSE
	update_icon()

/obj/machinery/weapons_analyzer/proc/check_gun(var/mob/user)
	if(gun)
		to_chat(user, span("warning", "\The [src] already has \the [gun] mounted. Remove it first."))
		return FALSE
	if(assembly)
		to_chat(user, span("warning", "\The [src] already has \the [assembly] mounted. Remove it first."))
		return FALSE
	if(item)
		to_chat(user, span("warning", "\The [src] already has \the [item] mounted. Remove it first."))
		return FALSE

	return TRUE

/obj/machinery/weapons_analyzer/verb/eject_inserted_item()
	set category = "Object"
	set name = "Eject inserted item"
	set src in view(1)

	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))
		return
	
	if(gun)
		gun.forceMove(usr.loc)
		gun = null
		update_icon()

	else if(item)
		item.forceMove(usr.loc)
		item = null
		update_icon()

	else if(assembly)
		gun.forceMove(usr.loc)
		assembly.ready_to_craft = FALSE
		assembly.analyzer = null
		assembly = null
		update_icon()
	else
		to_chat(usr, span("warning", "There is nothing in \the [src]."))

/obj/machinery/weapons_analyzer/update_icon()
	icon_state = initial(icon_state)
	cut_overlays()

	var/icon/Icon_used

	if(gun)
		gun.update_icon()
		icon_state = "[icon_state]_on"
		Icon_used = new /icon(gun.icon, gun.icon_state)

	else if(assembly)
		assembly.update_icon()
		icon_state = process ?  "[icon_state]_working" : "[icon_state]_on"
		Icon_used = new /icon(assembly.icon, assembly.icon_state)
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

//#define UIDEBUG

/obj/machinery/weapons_analyzer/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		. = data = list()
	data["name"] = ""
	data["item"] = FALSE
	data["energy"] = FALSE
	data["gun"] = FALSE
	if(item)
		data["name"] = item.name
		data["item"] = TRUE
		data["force"] = item.force
		data["sharp"] = item.sharp ? "sharp" : "not sharp"
		data["edge"] = item.edge ? "likely to dismember" : "not likely to dismember"
		data["penetration"] = item.armor_penetration
		data["throw_force"] = item.throwforce
		if(istype(item, /obj/item/melee/energy))
			data["energy"] = TRUE
			var/obj/item/melee/energy/E_item = item
			data["active_force"] = E_item.active_force
			data["active_throw_force"] = E_item.active_throwforce
			data["can_block"] = E_item.can_block_bullets ? "can block" : "cannot block"
			data["base_reflectchance"] = E_item.base_reflectchance
			data["base_block_chance"] = E_item.base_block_chance
			data["shield_power"] = E_item.shield_power
	else if(gun)
		data["name"] = gun.name
		data["gun"] = TRUE
		data["max_shots"] = 0
		data["recharge"] = "none"
		data["recharge_time"] = "none"
		data["damage"] = 0
		if(istype(gun, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = gun
			var/obj/item/projectile/P = new E.projectile_type
			data["max_shots"] = E.max_shots
			data["recharge"] = E.self_recharge ? "self recharging" : "not self recharging"
			data["recharge_time"] = E.recharge_time
			data["damage"] = P.damage
			if(E.secondary_projectile_type)
				var/obj/item/projectile/P_second = new E.secondary_projectile_type
				data["secondary_damage"] = P_second.damage
		else
			var/obj/item/gun/projectile/P_gun = gun
			var/obj/item/ammo_casing/casing = P_gun.chambered
			var/obj/item/projectile/P = new casing.projectile_type
			data["max_shots"] = P_gun.max_shells
			data["damage"] = P.damage
		data["burst"] = gun.burst
		data["reliability"] = gun.reliability

/obj/machinery/weapons_analyzer/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "wanalyzer-analyzer", 500, 500, capitalize(name))

	var/icon/Icon_used
	if(gun)
		Icon_used = new /icon(gun.icon, gun.icon_state)

	else if(assembly)
		Icon_used = new /icon(assembly.icon, assembly.icon_state)
	else if(item)
		Icon_used = new /icon(item.icon, item.icon_state)
	ui.add_asset("icon", Icon_used) 
	ui.send_asset("icon")
	ui.open()