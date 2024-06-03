var/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/nuke.dmi'
	icon_state = "idle"
	density = 1
	var/deployable = 0
	var/extended = 0
	var/lighthack = 0
	var/timeleft = 120
	var/timing = 0
	var/alerted = 0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0
	var/safety = 1
	var/obj/item/disk/nuclear/auth = null
	var/removal_stage = 0 // 0 is no removal, 1 is covers removed, 2 is covers open, 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	var/lastentered
	use_power = POWER_USE_OFF
	unacidable = 1
	var/previous_level = ""
	var/datum/wires/nuclearbomb/wires = null

/obj/machinery/nuclearbomb/Initialize()
	. = ..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.
	wires = new/datum/wires/nuclearbomb(src)

/obj/machinery/nuclearbomb/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/nuclearbomb/process()
	if (src.timing)
		src.timeleft = max(timeleft - 2, 0) // 2 seconds per process()
		if (timeleft <= 0)
			spawn
				explode()
		SSnanoui.update_uis(src)
	return

/obj/machinery/nuclearbomb/attackby(obj/item/attacking_item, mob/user, params)
	if (attacking_item.isscrewdriver())
		src.add_fingerprint(user)
		if (src.auth)
			if (panel_open == 0)
				panel_open = 1
				AddOverlays("panel_open")
				to_chat(user, "You unscrew the control panel of [src].")
				attacking_item.play_tool_sound(src, 50)
			else
				panel_open = 0
				CutOverlays("panel_open")
				to_chat(user, "You screw the control panel of [src] back on.")
				attacking_item.play_tool_sound(src, 50)
		else
			if (panel_open == 0)
				to_chat(user, "\The [src] emits a buzzing noise, the panel staying locked in.")
			if (panel_open == 1)
				panel_open = 0
				CutOverlays("panel_open")
				to_chat(user, "You screw the control panel of \the [src] back on.")
				attacking_item.play_tool_sound(src, 50)
			flick("lock", src)
		return TRUE

	if (panel_open && (attacking_item.ismultitool() || attacking_item.iswirecutter()))
		return attack_hand(user)

	if (src.extended)
		if (istype(attacking_item, /obj/item/disk/nuclear))
			usr.drop_from_inventory(attacking_item,src)
			src.auth = attacking_item
			src.add_fingerprint(user)
			return attack_hand(user)

	if (src.anchored)
		switch(removal_stage)
			if(0)
				if(attacking_item.iswelder())
					var/obj/item/weldingtool/WT = attacking_item
					if(!WT.isOn()) return TRUE
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, SPAN_WARNING("You need more fuel to complete this task."))
						return TRUE

					user.visible_message("[user] starts cutting loose the anchoring bolt covers on [src].", "You start cutting loose the anchoring bolt covers with [attacking_item]...")

					if(attacking_item.use_tool(src, user, 40, volume = 50))
						if(!src || !user || !WT.use(5, user)) return TRUE
						user.visible_message("[user] cuts through the bolt covers on [src].", "You cut through the bolt cover.")
						removal_stage = 1
					return TRUE

			if(1)
				if(attacking_item.iscrowbar())
					user.visible_message("[user] starts forcing open the bolt covers on [src].", "You start forcing open the anchoring bolt covers with [attacking_item]...")

					if(attacking_item.use_tool(src, user, 15, volume = 50))
						if(!src || !user) return TRUE
						user.visible_message("[user] forces open the bolt covers on [src].", "You force open the bolt covers.")
						removal_stage = 2
					return TRUE

			if(2)
				if(attacking_item.iswelder())
					var/obj/item/weldingtool/WT = attacking_item
					if(!WT.isOn()) return TRUE
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, SPAN_WARNING("You need more fuel to complete this task."))
						return TRUE

					user.visible_message("[user] starts cutting apart the anchoring system sealant on [src].", "You start cutting apart the anchoring system's sealant with [attacking_item]...")

					if(attacking_item.use_tool(src, user, 150, amount = 5, volume = 50))
						user.visible_message("[user] cuts apart the anchoring system sealant on [src].", "You cut apart the anchoring system's sealant.")
						removal_stage = 3
					return TRUE

			if(3)
				if(attacking_item.iswrench())
					user.visible_message("[user] begins unwrenching the anchoring bolts on [src].", "You begin unwrenching the anchoring bolts...")

					if(attacking_item.use_tool(src, user, 50, volume = 50))
						if(!src || !user) return TRUE
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
					return TRUE

			if(4)
				if(attacking_item.iscrowbar())
					user.visible_message("[user] begins lifting [src] off of the anchors.", "You begin lifting the device off the anchors...")

					if(attacking_item.use_tool(src, user, 80, volume = 50))
						if(!src || !user) return TRUE
						user.visible_message("[user] crowbars [src] off of the anchors. It can now be moved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
						anchored = 0
						removal_stage = 5
				return TRUE
	return ..()

/obj/machinery/nuclearbomb/attack_ghost(mob/user as mob)
	attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if (extended)
		if (panel_open)
			wires.interact(user)
		else
			ui_interact(user)
	else if (deployable)
		if(removal_stage < 5)
			src.anchored = 1
			visible_message(SPAN_WARNING("With a steely snap, bolts slide out of [src] and anchor it to the flooring!"))
		else
			visible_message(SPAN_WARNING("\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut."))
		extended = 1
		if(!src.lighthack)
			flick("lock", src)
			update_icon()
	return

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["hacking"] = 0
	data["auth"] = is_auth(user)
	if (is_auth(user))
		if (yes_code)
			data["authstatus"] = timing ? "Functional/Set" : "Functional"
		else
			data["authstatus"] = "Auth. S2"
	else
		if (timing)
			data["authstatus"] = "Set"
		else
			data["authstatus"] = "Auth. S1"
	data["safe"] = safety ? "Safe" : "Engaged"
	data["time"] = timeleft
	data["timer"] = timing
	data["safety"] = safety
	data["anchored"] = anchored
	data["yescode"] = yes_code
	data["message"] = "AUTH"
	if (is_auth(user))
		data["message"] = code
		if (yes_code)
			data["message"] = "*****"

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nuclear_bomb.tmpl", "Nuke Control Panel", 300, 510)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/nuclearbomb/verb/toggle_deployable()
	set category = "Object"
	set name = "Toggle Deployable"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if (src.deployable)
		to_chat(usr, SPAN_WARNING("You close several panels to make [src] undeployable."))
		src.deployable = 0
	else
		to_chat(usr, SPAN_WARNING("You adjust some panels to make [src] deployable."))
		src.deployable = 1
	return

/obj/machinery/nuclearbomb/proc/is_auth(var/mob/user)
	if(auth)
		return 1
	if(user.can_admin_interact())
		return 1
	return 0

/obj/machinery/nuclearbomb/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["auth"])
		if (auth)
			auth.forceMove(loc)
			yes_code = 0
			auth = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/disk/nuclear))
				usr.drop_from_inventory(I,src)
				auth = I
	if (is_auth(usr))
		if (href_list["type"])
			if (href_list["type"] == "E")
				if (code == r_code)
					yes_code = 1
					code = null
				else
					code = "ERROR"
			else
				if (href_list["type"] == "R")
					yes_code = 0
					code = null
				else
					lastentered = text("[]", href_list["type"])
					if (text2num(lastentered) == null)
						var/turf/LOC = get_turf(usr)
						message_admins("[key_name_admin(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: <a href='?_src_=vars;Vars=\ref[src]'>[lastentered]</a>! ([LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])", 0)
						log_admin("EXPLOIT: [key_name(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: [lastentered]!",ckey=key_name(usr))
					else
						code += lastentered
						if (length(code) > 5)
							code = "ERROR"
		if (yes_code)
			if (href_list["time"])
				var/time = text2num(href_list["time"])
				timeleft += time
				timeleft = Clamp(timeleft, 120, 600)
			if (href_list["timer"])
				if (timing == -1)
					SSnanoui.update_uis(src)
					return
				if (!anchored)
					to_chat(usr, SPAN_WARNING("\The [src] needs to be anchored."))
					SSnanoui.update_uis(src)
					return
				if (safety)
					to_chat(usr, SPAN_WARNING("The safety is still on."))
					SSnanoui.update_uis(src)
					return
				if (wires.is_cut(WIRE_TIMING))
					to_chat(usr, SPAN_WARNING("Nothing happens, something might be wrong with the wiring."))
					SSnanoui.update_uis(src)
					return

				if (!timing && !safety)
					timing = 1
					log_and_message_admins("engaged a nuclear bomb")
					bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
					update_icon()
				else
					secure_device()

				if(alerted == 0)
					set_security_level(SEC_LEVEL_DELTA)
					alerted = 1
			if (href_list["safety"])
				if (wires.is_cut(WIRE_SAFETY))
					to_chat(usr, SPAN_WARNING("Nothing happens, something might be wrong with the wiring."))
					SSnanoui.update_uis(src)
					return
				safety = !safety
				if(safety)
					secure_device()
				update_icon()
			if (href_list["anchor"])
				if(removal_stage == 5)
					anchored = 0
					visible_message(SPAN_WARNING("\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut."))
					SSnanoui.update_uis(src)
					return

				if(!isinspace())
					anchored = !anchored
					if(anchored)
						visible_message(SPAN_WARNING("With a steely snap, bolts slide out of [src] and anchor it to the flooring."))
					else
						secure_device()
						visible_message(SPAN_WARNING("The anchoring bolts slide back into the depths of [src]."))
				else
					to_chat(usr, SPAN_WARNING("There is nothing to anchor to!"))

	SSnanoui.update_uis(src)

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return

	bomb_set--
	timing = 0
	timeleft = Clamp(timeleft, 120, 600)
	update_icon()

/obj/machinery/nuclearbomb/ex_act(severity)
	return

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if (src.safety)
		timing = 0
		return
	src.timing = -1
	src.yes_code = 0
	src.safety = 1
	update_icon()
	playsound(src,'sound/machines/Alarm.ogg',100,0,5)
	if (SSticker.mode)
		SSticker.mode.explosion_in_progress = 1
	sleep(100)

	var/off_station = 0
	var/turf/bomb_location = get_turf(src)
	if(bomb_location && isStationLevel(bomb_location.z))
		if( (bomb_location.x < (128-NUKERANGE)) || (bomb_location.x > (128+NUKERANGE)) || (bomb_location.y < (128-NUKERANGE)) || (bomb_location.y > (128+NUKERANGE)) )
			off_station = 1
	else
		off_station = 2

	if(SSticker.mode && SSticker.mode.name == "Mercenary")
		var/obj/machinery/computer/shuttle_control/multi/antag/syndicate/syndie_location = locate(/obj/machinery/computer/shuttle_control/multi/antag/syndicate)
		if(syndie_location)
			SSticker.mode:syndies_didnt_escape = isNotAdminLevel(syndie_location.z)
		SSticker.mode:nuke_off_station = off_station

	SSticker.station_explosion_cinematic(off_station, null, GetConnectedZlevels(z))
	if(SSticker.mode)
		SSticker.mode.explosion_in_progress = 0
		if(off_station == 1)
			to_world("<b>A nuclear device was set off, but the explosion was out of reach of the station!</b>")
		else if(off_station == 2)
			to_world("<b>A nuclear device was set off, but the device was not on the station!</b>")
		else
			to_world("<b>The station was destoyed by the nuclear blast!</b>")

		SSticker.mode.station_was_nuked = (off_station<2)	//offstation==1 is a draw. the station becomes irradiated and needs to be evacuated.
														//kinda shit but I couldn't  get permission to do what I wanted to do.

		if(!SSticker.mode.check_finished())//If the mode does not deal with the nuke going off so just reboot because everyone is stuck as is
			universe_has_ended = 1
			return

/obj/machinery/nuclearbomb/update_icon()
	if(lighthack)
		icon_state = "idle"
	else if(timing == -1)
		icon_state = "exploding"
	else if(timing)
		icon_state = "urgent"
	else if(extended || !safety)
		icon_state = "greenlight"
	else
		icon_state = "idle"

//====The nuclear authentication disc====
/obj/item/disk/nuclear
	name = "authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEMSIZE_TINY

/obj/item/disk/nuclear/Initialize()
	. = ..()
	nuke_disks |= src

/obj/item/disk/nuclear/Destroy()
	nuke_disks -= src
	if(!nuke_disks.len)
		var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(T)
			var/obj/D = new /obj/item/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!")
	return ..()

/obj/item/disk/nuclear/touch_map_edge()
	qdel(src)

/obj/machinery/nuclearbomb/station
	name = "scuttling device terminal"
	desc = "An ominous looking terminal, designed to scuttle a spaceship."
	icon = 'icons/obj/nuke_station.dmi'
	anchored = 1
	deployable = 1
	extended = 1

	var/list/flash_tiles = list()
	var/last_turf_state

/obj/machinery/nuclearbomb/station/Initialize(mapload)
	..()
	verbs -= /obj/machinery/nuclearbomb/verb/toggle_deployable
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/nuclearbomb/station/LateInitialize()
	for(var/turf/simulated/floor/T in RANGE_TURFS(1, src))
		T.set_flooring(GET_SINGLETON(/singleton/flooring/reinforced/circuit/red))
		flash_tiles += T
	update_icon()

/obj/machinery/nuclearbomb/station/Destroy()
	flash_tiles.Cut()
	return ..()

/obj/machinery/nuclearbomb/station/update_icon()
	var/target_icon_state
	if(lighthack)
		target_icon_state = "rcircuit_off"
		icon_state = "idle"
	else if(timing == -1)
		target_icon_state = "rcircuitanim"
		icon_state = "exploding"
	else if(timing)
		target_icon_state = "rcircuitanim"
		icon_state = "urgent"
	else if(!safety)
		target_icon_state = "rcircuit"
		icon_state = "greenlight"
	else
		target_icon_state = "rcircuit_off"
		icon_state = "idle"

	if(!last_turf_state || target_icon_state != last_turf_state)
		for(var/thing in flash_tiles)
			var/turf/simulated/floor/T = thing
			if(!istype(T.flooring, /singleton/flooring/reinforced/circuit/red))
				flash_tiles -= T
				continue
			T.icon_state = target_icon_state
		last_turf_state = target_icon_state
