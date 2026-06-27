/obj/structure/machinery/camera
	name = "security camera"
	desc = "It's used to monitor compartments."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 5
	active_power_usage = 10
	layer = CAMERA_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	maxhealth = OBJECT_HEALTH_EXTREMELY_LOW
	armor = list(
		MELEE = ARMOR_MELEE_SMALL,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR
	)

	var/list/network = list(NETWORK_STATION)
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1
	anchored = 1.0
	var/invuln = null
	var/bugged = 0
	var/obj/item/camera_assembly/assembly = null

	var/toughness = 5 //sorta fragile

	// WIRES
	/// Wires datum
	var/datum/wires/camera/wires = null

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = 0
	var/busy = 0

	var/on_open_network = 0

	var/affected_by_emp_until = 0

/obj/structure/machinery/camera/Initialize()
	wires = new(src)
	assembly = new(src)
	assembly.state = 4
	SSmachinery.all_cameras += src

	// Use this to look for cameras that have the same c_tag.
	if(!isnull(src.c_tag))
		for(var/obj/structure/machinery/camera/C in GLOB.cameranet.cameras)
			var/list/tempnetwork = C.network&src.network
			if(C != src && C.c_tag == src.c_tag && tempnetwork.len)

				#if !defined(UNIT_TEST)
				log_mapping_error("The camera [src.c_tag] at [src.x]-[src.y]-[src.z] conflicts with the c_tag of the camera in [C.x]-[C.y]-[C.z]!")

				#else
				SSunit_tests_config.UT.fail("The camera [src.c_tag] at [src.x]-[src.y]-[src.z] conflicts with the c_tag of the camera in [C.x]-[C.y]-[C.z]!")

				#endif

	if(!src.network || src.network.len < 1)
		if(loc)
			log_mapping_error("[src.name] in [get_area(src)] (x:[src.x] y:[src.y] z:[src.z] has errored. [src.network?"Empty network list":"Null network list"]")
		else
			log_mapping_error("[src.name] in [get_area(src)]has errored. [src.network?"Empty network list":"Null network list"]")
		ASSERT(src.network)
		ASSERT(src.network.len > 0)

	set_pixel_offsets()

	var/list/open_networks = difflist(network, GLOB.restricted_camera_networks)
	on_open_network = open_networks.len
	if(on_open_network)
		GLOB.cameranet.add_source(src)

	return ..()

/obj/structure/machinery/camera/Destroy()
	SSmachinery.all_cameras -= src
	deactivate(null, 0) //kick anyone viewing out
	if(assembly)
		QDEL_NULL(assembly)

	cancelCameraAlarm(force = TRUE)
	cancelAlarm()

	for(var/mob/target in motionTargets.Copy())
		lostTarget(target)

	if(area_motion && area_motion.motioncamera == src)
		area_motion.motioncamera = null
	area_motion = null

	QDEL_NULL(wires)

	GLOB.cameranet.cameras -= src

	if(on_open_network)
		GLOB.cameranet.remove_source(src)

	. = ..()

/obj/structure/machinery/camera/set_pixel_offsets()
	pixel_x = dir & (NORTH|SOUTH) ? 0 : (dir == EAST ? -13 : 13)
	pixel_y = dir & (NORTH|SOUTH) ? (dir == NORTH ? -3 : DEFAULT_WALL_OFFSET) : 0

/obj/structure/machinery/camera/process()
	if((stat & EMPED) && world.time >= affected_by_emp_until)
		stat &= ~EMPED
		cancelCameraAlarm()
		update_icon()
		update_coverage()
	return internal_process()

/obj/structure/machinery/camera/proc/internal_process()
	// motion camera event loop
	if (stat & (EMPED|NOPOWER))
		return
	if(!isMotion())
		. = PROCESS_KILL
		return
	if (detectTime > 0)
		var/elapsed = world.time - detectTime
		if (elapsed > alarm_delay)
			triggerAlarm()
	else if (detectTime == -1)
		for (var/mob/target in motionTargets)
			if (target.stat == 2 || QDELING(target)) lostTarget(target)
			// If not detecting with motion camera...
			if (!area_motion)
				// See if the camera is still in range
				if(!in_range(src, target))
					// If they aren't in range, lose the target.
					lostTarget(target)

/obj/structure/machinery/camera/emp_act(severity)
	. = ..()

	if(!isEmpProof() && prob(100/severity))
		if(!affected_by_emp_until || (world.time < affected_by_emp_until))
			affected_by_emp_until = max(affected_by_emp_until, world.time + (90 SECONDS / severity))
		else
			stat |= EMPED
			set_light(0)
			triggerCameraAlarm()
			kick_viewers()
			update_icon()
			update_coverage()

/obj/structure/machinery/camera/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	add_damage(hitting_projectile.get_structure_damage(), hitting_projectile.damage_flags(), hitting_projectile.damage_type, hitting_projectile.armor_penetration, hitting_projectile)

/obj/structure/machinery/camera/ex_act(severity)
	if(src.invuln)
		return

	//camera dies if an explosion touches it!
	if(severity <= 2 || prob(50))
		destroy()

	..() //and give it the regular chance of being deleted outright

/obj/structure/machinery/camera/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..()
	if (istype(hitting_atom, /obj))
		var/obj/O = hitting_atom
		if (O.throwforce >= src.toughness)
			visible_message(SPAN_WARNING("<B>[src] was hit by [O].</B>"))
		add_damage(O.throwforce, O.damage_flags(), O.damtype, O.armor_penetration, O)

/obj/structure/machinery/camera/proc/setViewRange(var/num = 7)
	src.view_range = num
	GLOB.cameranet.update_visibility(src, 0)

/obj/structure/machinery/camera/attack_hand(mob/living/carbon/human/user as mob)
	if(!istype(user))
		return

	if(user.species.can_shred(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		set_status(0)
		user.do_attack_animation(src)
		visible_message(SPAN_WARNING("\The [user] slashes at [src]!"))
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
		add_hiddenprint(user)
		destroy()

/obj/structure/machinery/camera/attackby(obj/item/attacking_item, mob/user)
	update_coverage()
	// DECONSTRUCTION
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		//to_chat(user, SPAN_NOTICE("You start to [panel_open ? "close" : "open"] the camera's panel."))
		//if(toggle_panel(user)) // No delay because no one likes screwdrivers trying to be hip and have a duration cooldown
		panel_open = !panel_open
		user.visible_message(SPAN_WARNING("[user] screws the camera's panel [panel_open ? "open" : "closed"]!"),
		SPAN_NOTICE("You screw the camera's panel [panel_open ? "open" : "closed"]."))
		attacking_item.play_tool_sound(get_turf(src), 50)
		return TRUE

	else if((attacking_item.tool_behaviour == TOOL_WIRECUTTER || attacking_item.tool_behaviour == TOOL_MULTITOOL) && panel_open)
		interact(user)
		return TRUE

	else if(attacking_item.tool_behaviour == TOOL_WELDER && (wires.CanDeconstruct() || (stat & BROKEN)))
		if(weld(attacking_item, user))
			if(assembly)
				assembly.forceMove(src.loc)
				assembly.anchored = 1
				assembly.camera_name = c_tag
				assembly.camera_network = english_list(network, "Station", ",", ",")
				assembly.update_icon()
				assembly.dir = src.dir
				if(stat & BROKEN)
					assembly.state = 2
					to_chat(user, SPAN_NOTICE("You repaired \the [src] frame."))
				else
					assembly.state = 1
					to_chat(user, SPAN_NOTICE("You cut \the [src] free from the wall."))
					new /obj/item/stack/cable_coil(loc, 2)
				assembly = null //so qdel doesn't eat it.
			qdel(src)
		return TRUE

	// OTHER
	else if (can_use() && (istype(attacking_item, /obj/item/paper)) && isliving(user))
		var/info = null
		var/mob/living/U = user
		var/obj/item/paper/X = null

		var/itemname = ""
		if(istype(attacking_item, /obj/item/paper))
			X = attacking_item
			itemname = X.name
			info = X.info
		to_chat(U, "You hold \a [itemname] up to the camera ...")
		for(var/mob/living/silicon/ai/O in GLOB.living_mob_list)
			var/entry = O.addCameraRecord(itemname,info)
			if(!O.client) continue
			if(U.name == "Unknown")
				to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras ...<a href='byond://?src=[REF(O)];readcapturedpaper=[REF(entry)]'>view message</a>")
			else
				to_chat(O, "<b><a href='byond://?src=[REF(O)];track2=[REF(O)];track=[REF(U)];trackname=[html_encode(U.name)]'>[U]</a></b> holds \a [itemname] up to one of your cameras ...<a href='byond://?src=[REF(O)];readcapturedpaper=[entry]'>view message</a>")

		for(var/mob/O in GLOB.player_list)
			if (istype(O.machine, /obj/structure/machinery/computer/security))
				var/obj/structure/machinery/computer/security/S = O.machine
				if (S.current_camera == src)
					to_chat(O, "[U] holds \a [itemname] up to one of the cameras ...")
					O << browse("<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>", "window=[itemname]") //Force people watching to open the page so they can't see it again)
		return TRUE

	else if (istype(attacking_item, /obj/item/camera_bug))
		if (!src.can_use())
			to_chat(user, SPAN_WARNING("Camera non-functional."))
		else if (src.bugged)
			to_chat(user, SPAN_NOTICE("Camera bug removed."))
			src.bugged = 0
		else
			to_chat(user, SPAN_NOTICE("Camera bugged."))
			src.bugged = 1
		return TRUE

	else if(attacking_item.damtype == DAMAGE_BRUTE || attacking_item.damtype == DAMAGE_BURN) //bashing cameras
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (attacking_item.force >= src.toughness)
			user.do_attack_animation(src)
			user.visible_message(SPAN_DANGER("[user] has [LAZYPICK(attacking_item.attack_verb,"attacked")] [src] with [attacking_item]!"))
			if (istype(attacking_item, /obj/item)) //is it even possible to get into attackby() with non-items?
				var/obj/item/I = attacking_item
				if (I.hitsound)
					playsound(loc, I.hitsound, I.get_clamped_volume(), 1, -1)
		add_damage(attacking_item.force, attacking_item.damage_flags(), attacking_item.damtype, attacking_item.armor_penetration, attacking_item)
		return TRUE
	else
		return ..()

/obj/structure/machinery/camera/proc/deactivate(user as mob, var/choice = 1)
	// The only way for AI to reactivate cameras are malf abilities, this gives them different messages.
	if(istype(user, /mob/living/silicon/ai))
		user = null

	if(choice != 1)
		//legacy support, if choice is != 1 then just kick viewers without changing status
		kick_viewers()
	else
		set_status(!src.status)
		if (!(src.status))
			if(user)
				visible_message(SPAN_NOTICE("[user] has deactivated [src]!"))
			else
				visible_message(SPAN_NOTICE("[src] clicks and shuts down. "))
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			icon_state = "[initial(icon_state)]1"
			add_hiddenprint(user)
		else
			if(user)
				visible_message(SPAN_NOTICE("[user] has reactivated [src]!"))
			else
				visible_message(SPAN_NOTICE("[src] clicks and reactivates itself. "))
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			icon_state = initial(icon_state)
			add_hiddenprint(user)

	invalidateCameraCache()

	if(!can_use())
		set_light(0)

	GLOB.cameranet.update_visibility(src)

/obj/structure/machinery/camera/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	if(!(stat & BROKEN))
		destroy()

//Used when someone breaks a camera
/obj/structure/machinery/camera/proc/destroy()
	stat |= BROKEN
	wires.cut_all()

	kick_viewers()
	triggerCameraAlarm()
	update_icon()
	update_coverage()

	//sparks
	spark(loc, 5)
	playsound(loc, SFX_SPARKS, 50, 1)

/obj/structure/machinery/camera/proc/set_status(var/newstatus)
	if (status != newstatus)
		status = newstatus
		update_coverage()
		// now disconnect anyone using the camera
		//Apparently, this will disconnect anyone even if the camera was re-activated.
		//I guess that doesn't matter since they couldn't use it anyway?
		kick_viewers()

/obj/structure/machinery/camera/check_eye(mob/user)
	if(!can_use()) return -1
	if(isXRay()) return SEE_TURFS|SEE_MOBS|SEE_OBJS
	return 0

/obj/structure/machinery/camera/grants_equipment_vision(mob/user)
	return can_use()

//This might be redundant, because of check_eye()
/obj/structure/machinery/camera/proc/kick_viewers()
	for(var/mob/O in GLOB.player_list)
		if (istype(O.machine, /obj/structure/machinery/computer/security))
			var/obj/structure/machinery/computer/security/S = O.machine
			if (S.current_camera == src)
				O.unset_machine()
				O.reset_view(null)
				to_chat(O, "The screen bursts into static.")

/obj/structure/machinery/camera/update_icon()
	if (!status || (stat & BROKEN))
		icon_state = "[initial(icon_state)]1"
	else if (stat & EMPED)
		icon_state = "[initial(icon_state)]emp"
	else
		icon_state = initial(icon_state)

/obj/structure/machinery/camera/proc/triggerCameraAlarm(var/duration = 0)
	alarm_on = 1
	GLOB.camera_alarm.triggerAlarm(loc, src, duration)

/obj/structure/machinery/camera/proc/cancelCameraAlarm(var/force = FALSE)
	if(wires.is_cut(WIRE_ALARM) && !force)
		return

	alarm_on = 0
	GLOB.camera_alarm.clearAlarm(loc, src)

//if false, then the camera is listed as DEACTIVATED and cannot be used
/obj/structure/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & (EMPED|BROKEN))
		return 0
	return 1

/obj/structure/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(!pos)
		return list()

	if(isXRay())
		see = range(view_range, pos)
	else
		see = get_hear(view_range, pos)
	return see

// Temporary plane cube camera static diagnostic.
/obj/structure/machinery/camera/verb/delete_camera()
	set name = "Delete Camera"
	set category = "Debug"
	set src in world

	if(!check_rights(R_DEBUG))
		return

	var/mob/user = usr
	var/obj/structure/machinery/camera/deleted_camera = src
	var/turf/origin = get_turf(deleted_camera)
	var/list/deleted_seen_before = deleted_camera.can_see()
	var/list/relevant_chunks = camera_static_debug_collect_relevant_chunks(deleted_camera, origin, deleted_seen_before)
	var/list/report = list()
	var/camera_ref = REF(deleted_camera)

	report += "Delete Camera diagnostic report"
	report += "Started at world.time=[world.time], realtime=[world.realtime], usr=[key_name(user)]"
	report += "Target ref=[camera_ref], type=[deleted_camera.type], tag=[deleted_camera.c_tag], origin=[camera_static_debug_turf_line(origin)]"
	report += ""

	camera_static_debug_append_delete_state(report, "BEFORE DELETE", deleted_camera, origin, relevant_chunks, deleted_seen_before)

	qdel(deleted_camera)

	camera_static_debug_append_delete_state(report, "AFTER QDEL IMMEDIATE", deleted_camera, origin, relevant_chunks, deleted_seen_before)

	to_chat(user, SPAN_NOTICE("Delete Camera diagnostics captured. Final report will open after the camera static update buffer."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(camera_static_debug_finish_delete_report), user, report, deleted_camera, origin, relevant_chunks, deleted_seen_before, camera_ref), 30)

/proc/camera_static_debug_finish_delete_report(var/mob/user, var/list/report, var/obj/structure/machinery/camera/deleted_camera, var/turf/origin, var/list/relevant_chunks, var/list/deleted_seen_before, var/camera_ref)
	camera_static_debug_add_stale_chunks(deleted_camera, relevant_chunks)
	camera_static_debug_append_delete_state(report, "AFTER UPDATE BUFFER", deleted_camera, origin, relevant_chunks, deleted_seen_before)

	var/html = {"
		<html>
		<head>
			<title>Delete Camera Diagnostics</title>
			<style>
				body { background: #111; color: #ddd; font-family: monospace; }
				pre { white-space: pre-wrap; }
			</style>
		</head>
		<body><pre>[html_encode(jointext(report, "\n"))]</pre></body>
		</html>
	"}

	if(!QDELETED(user) && user.client)
		user << browse(html, "window=delete_camera_diagnostics;size=1200x900")

/proc/camera_static_debug_collect_relevant_chunks(var/obj/structure/machinery/camera/deleted_camera, var/turf/origin, var/list/deleted_seen_before)
	var/list/relevant_chunks = list()

	for(var/key in GLOB.cameranet.chunks)
		var/datum/chunk/chunk = GLOB.cameranet.chunks[key]
		if(!chunk)
			continue
		if(deleted_camera in chunk.sources)
			relevant_chunks[chunk] = TRUE

	if(origin)
		var/x1 = max(0, origin.x - 8) & ~0xf
		var/y1 = max(0, origin.y - 8) & ~0xf
		var/x2 = min(world.maxx, origin.x + 8) & ~0xf
		var/y2 = min(world.maxy, origin.y + 8) & ~0xf
		for(var/x = x1; x <= x2; x += 16)
			for(var/y = y1; y <= y2; y += 16)
				if(GLOB.cameranet.is_chunk_generated(x, y, origin.z))
					var/datum/chunk/chunk = GLOB.cameranet.get_chunk(x, y, origin.z)
					relevant_chunks[chunk] = TRUE

	for(var/turf/seen_turf in deleted_seen_before)
		if(GLOB.cameranet.is_chunk_generated(seen_turf.x, seen_turf.y, seen_turf.z))
			var/datum/chunk/chunk = GLOB.cameranet.get_chunk(seen_turf.x, seen_turf.y, seen_turf.z)
			relevant_chunks[chunk] = TRUE

	return relevant_chunks

/proc/camera_static_debug_add_stale_chunks(var/obj/structure/machinery/camera/deleted_camera, var/list/relevant_chunks)
	for(var/key in GLOB.cameranet.chunks)
		var/datum/chunk/chunk = GLOB.cameranet.chunks[key]
		if(!chunk)
			continue
		if(deleted_camera in chunk.sources)
			relevant_chunks[chunk] = TRUE

/proc/camera_static_debug_append_delete_state(var/list/report, var/label, var/obj/structure/machinery/camera/deleted_camera, var/turf/origin, var/list/relevant_chunks, var/list/deleted_seen_before)
	report += "==================== [label] ===================="
	report += "world.time=[world.time], tick_usage=[world.tick_usage]"
	report += "deleted_camera_ref=[REF(deleted_camera)], qdeleted=[camera_static_debug_bool(QDELETED(deleted_camera))], origin=[camera_static_debug_turf_line(origin)]"
	report += "origin_stack=[origin ? camera_static_debug_stack_text(origin.z) : "null"], origin_plane_offset=[origin ? camera_static_debug_plane_offset(origin.z) : "null"], origin_lowest_stack_offset=[origin ? camera_static_debug_lowest_plane_offset(origin.z) : "null"]"
	report += "deleted_seen_before=[length(deleted_seen_before)] by_z=[camera_static_debug_count_by_z(deleted_seen_before)]"
	report += "global_cameranet: sources=[length(GLOB.cameranet.sources)], cameras=[length(GLOB.cameranet.cameras)], chunks=[length(GLOB.cameranet.chunks)], deleted_in_sources=[camera_static_debug_bool(deleted_camera in GLOB.cameranet.sources)], deleted_in_cameras=[camera_static_debug_bool(deleted_camera in GLOB.cameranet.cameras)]"

	if(!QDELETED(deleted_camera))
		var/list/open_networks = difflist(deleted_camera.network, GLOB.restricted_camera_networks)
		report += "camera_vars: name=[deleted_camera.name], tag=[deleted_camera.c_tag], status=[deleted_camera.status], stat=[deleted_camera.stat], can_use=[camera_static_debug_bool(deleted_camera.can_use())], on_open_network=[deleted_camera.on_open_network], network=[camera_static_debug_join_list(deleted_camera.network)], open_networks=[camera_static_debug_join_list(open_networks)], view_range=[deleted_camera.view_range], short_range=[deleted_camera.short_range], dir=[deleted_camera.dir], density=[deleted_camera.density], opacity=[deleted_camera.opacity], invisibility=[deleted_camera.invisibility], loc=[camera_static_debug_turf_line(get_turf(deleted_camera))]"
	else
		report += "camera_vars: camera is qdeleted; only saved origin/deleted_seen_before are used below."

	camera_static_debug_append_covering_camera_scan(report, label, deleted_camera, origin, deleted_seen_before)

	report += "relevant_chunks=[length(relevant_chunks)]"
	for(var/datum/chunk/chunk as anything in relevant_chunks)
		camera_static_debug_append_chunk_snapshot(report, chunk, deleted_camera, deleted_seen_before)
	report += ""

/proc/camera_static_debug_append_covering_camera_scan(var/list/report, var/label, var/obj/structure/machinery/camera/deleted_camera, var/turf/origin, var/list/deleted_seen_before)
	report += "covering_camera_scan ([label]):"
	var/found = FALSE
	for(var/obj/structure/machinery/camera/C in GLOB.cameranet.cameras)
		if(QDELETED(C))
			continue
		var/turf/camera_turf = get_turf(C)
		var/list/seen = C.can_see()
		var/list/overlap = seen & deleted_seen_before
		var/same_stack = origin && camera_turf && camera_static_debug_same_stack(origin.z, camera_turf.z)
		var/near_origin = origin && camera_turf && max(abs(camera_turf.x - origin.x), abs(camera_turf.y - origin.y)) <= 24
		if(!length(overlap) && !(same_stack && near_origin))
			continue
		found = TRUE
		report += "  camera ref=[REF(C)] deleted_target=[camera_static_debug_bool(C == deleted_camera)] tag=[C.c_tag] qdeleted=[camera_static_debug_bool(QDELETED(C))] can_use=[camera_static_debug_bool(C.can_use())] on_open_network=[C.on_open_network] loc=[camera_static_debug_turf_line(camera_turf)] same_stack=[camera_static_debug_bool(same_stack)] seen=[length(seen)] overlap_deleted_seen=[length(overlap)] in_sources=[camera_static_debug_bool(C in GLOB.cameranet.sources)] in_cameras=[camera_static_debug_bool(C in GLOB.cameranet.cameras)]"
	if(!found)
		report += "  none"

/proc/camera_static_debug_append_chunk_snapshot(var/list/report, var/datum/chunk/chunk, var/obj/structure/machinery/camera/deleted_camera, var/list/deleted_seen_before)
	if(!chunk)
		report += "  null chunk"
		return

	var/list/coverage = camera_static_debug_build_chunk_coverage(chunk, deleted_camera, deleted_seen_before)
	var/list/visible_without_coverage = chunk.visibleTurfs - coverage
	var/list/coverage_not_visible = coverage - chunk.visibleTurfs
	var/list/obscured_with_coverage = chunk.obscuredTurfs & coverage
	var/list/visible_and_obscured = chunk.visibleTurfs & chunk.obscuredTurfs
	var/list/unclassified_turfs = chunk.turfs - chunk.visibleTurfs - chunk.obscuredTurfs

	report += "  ---- chunk ref=[REF(chunk)] key=[camera_static_debug_chunk_key(chunk)] coords=([chunk.x],[chunk.y],[chunk.z]) stack=[camera_static_debug_stack_text(chunk.z)] dirty=[camera_static_debug_bool(chunk.dirty)] updating=[camera_static_debug_bool(chunk.updating)] seenby=[length(chunk.seenby)] sources=[length(chunk.sources)] deleted_in_sources=[camera_static_debug_bool(deleted_camera in chunk.sources)]"
	report += "    counts: turfs=[length(chunk.turfs)] by_z=[camera_static_debug_count_by_z(chunk.turfs)], visible=[length(chunk.visibleTurfs)] by_z=[camera_static_debug_count_by_z(chunk.visibleTurfs)], obscuredTurfs=[length(chunk.obscuredTurfs)] by_z=[camera_static_debug_count_by_z(chunk.obscuredTurfs)], obscured_images=[length(chunk.obscured)], cached_obfuscation_images=[length(chunk.obfuscation?.obfuscation_images)]"
	report += "    coverage: actively_covered=[length(coverage)] by_z=[camera_static_debug_count_by_z(coverage)], all_turfs_hist=[camera_static_debug_coverage_histogram(chunk.turfs, coverage)], visible_hist=[camera_static_debug_coverage_histogram(chunk.visibleTurfs, coverage)], obscured_hist=[camera_static_debug_coverage_histogram(chunk.obscuredTurfs, coverage)]"
	report += "    consistency: visible_without_active_coverage=[length(visible_without_coverage)], active_coverage_not_visible=[length(coverage_not_visible)], obscured_with_active_coverage=[length(obscured_with_coverage)], visible_and_obscured=[length(visible_and_obscured)], unclassified_turfs=[length(unclassified_turfs)]"

	report += "    sources:"
	if(length(chunk.sources))
		for(var/atom/source as anything in chunk.sources)
			camera_static_debug_append_source_snapshot(report, source, chunk, deleted_camera, deleted_seen_before)
	else
		report += "      none"

	camera_static_debug_append_turf_list(report, "visible_without_active_coverage", visible_without_coverage, coverage, 80)
	camera_static_debug_append_turf_list(report, "active_coverage_not_visible", coverage_not_visible, coverage, 80)
	camera_static_debug_append_turf_list(report, "obscured_with_active_coverage", obscured_with_coverage, coverage, 80)
	camera_static_debug_append_turf_list(report, "visible_and_obscured", visible_and_obscured, coverage, 80)
	camera_static_debug_append_turf_list(report, "unclassified_turfs", unclassified_turfs, coverage, 80)

/proc/camera_static_debug_append_source_snapshot(var/list/report, var/atom/source, var/datum/chunk/chunk, var/obj/structure/machinery/camera/deleted_camera, var/list/deleted_seen_before)
	var/turf/source_turf = get_turf(source)
	var/source_seen_len = "n/a"
	var/source_seen_in_chunk = "n/a"
	var/source_overlap_deleted = "n/a"
	var/source_can_use = "n/a"
	var/source_tag = "n/a"
	var/source_on_open_network = "n/a"

	if(istype(source, /obj/structure/machinery/camera))
		var/obj/structure/machinery/camera/source_camera = source
		source_tag = "[source_camera.c_tag]"
		source_on_open_network = "[source_camera.on_open_network]"
		if(!QDELETED(source_camera))
			source_can_use = "[source_camera.can_use()]"
			var/list/source_seen = source_camera == deleted_camera ? deleted_seen_before : source_camera.can_see()
			source_seen_len = "[length(source_seen)]"
			source_seen_in_chunk = "[length(source_seen & chunk.turfs)]"
			source_overlap_deleted = "[length(source_seen & deleted_seen_before)]"
	else if(isAI(source) && !QDELETED(source))
		var/mob/living/silicon/ai/AI = source
		var/list/source_seen = seen_turfs_in_range(AI, world.view)
		source_can_use = "[AI.stat != DEAD]"
		source_seen_len = "[length(source_seen)]"
		source_seen_in_chunk = "[length(source_seen & chunk.turfs)]"
		source_overlap_deleted = "[length(source_seen & deleted_seen_before)]"

	report += "      ref=[REF(source)] type=[source?.type] deleted_target=[camera_static_debug_bool(source == deleted_camera)] qdeleted=[camera_static_debug_bool(QDELETED(source))] tag=[source_tag] can_use=[source_can_use] on_open_network=[source_on_open_network] loc=[camera_static_debug_turf_line(source_turf)] in_global_sources=[camera_static_debug_bool(source in GLOB.cameranet.sources)] in_global_cameras=[camera_static_debug_bool(source in GLOB.cameranet.cameras)] seen=[source_seen_len] seen_in_chunk=[source_seen_in_chunk] overlap_deleted_seen=[source_overlap_deleted]"

/proc/camera_static_debug_build_chunk_coverage(var/datum/chunk/chunk, var/obj/structure/machinery/camera/deleted_camera, var/list/deleted_seen_before)
	var/list/coverage = list()
	for(var/atom/source as anything in chunk.sources)
		var/list/source_seen
		if(istype(source, /obj/structure/machinery/camera))
			var/obj/structure/machinery/camera/source_camera = source
			if(QDELETED(source_camera) || !source_camera.can_use())
				continue
			source_seen = source_camera == deleted_camera ? deleted_seen_before : source_camera.can_see()
		else if(isAI(source))
			var/mob/living/silicon/ai/AI = source
			if(QDELETED(AI) || AI.stat == DEAD)
				continue
			source_seen = seen_turfs_in_range(AI, world.view)
		else
			continue

		for(var/turf/seen_turf as anything in source_seen & chunk.turfs)
			coverage[seen_turf] = coverage[seen_turf] + 1
	return coverage

/proc/camera_static_debug_append_turf_list(var/list/report, var/title, var/list/turfs, var/list/coverage, var/limit)
	if(!length(turfs))
		return
	report += "    [title] sample (showing up to [limit] of [length(turfs)]):"
	var/count = 0
	for(var/turf/T as anything in turfs)
		count++
		if(count > limit)
			report += "      ... [length(turfs) - limit] more"
			break
		var/coverage_count = coverage ? coverage[T] : null
		report += "      [camera_static_debug_turf_line(T)] coverage=[isnull(coverage_count) ? 0 : coverage_count]"

/proc/camera_static_debug_turf_line(var/turf/T)
	if(!T)
		return "null"
	var/area/A = get_area(T)
	var/area_name = A ? A.name : "null"
	return "[COORD(T)] type=[T.type] area=[area_name] density=[T.density] opacity=[T.opacity] plane=[T.plane] z_offset=[camera_static_debug_plane_offset(T.z)] lowest_stack_offset=[camera_static_debug_lowest_plane_offset(T.z)]"

/proc/camera_static_debug_chunk_key(var/datum/chunk/chunk)
	for(var/key in GLOB.cameranet.chunks)
		if(GLOB.cameranet.chunks[key] == chunk)
			return key
	return "not in GLOB.cameranet.chunks"

/proc/camera_static_debug_count_by_z(var/list/turfs)
	if(!length(turfs))
		return "none"
	var/list/counts = list()
	for(var/turf/T as anything in turfs)
		if(!isturf(T))
			continue
		counts["z[T.z]"] = counts["z[T.z]"] + 1
	return camera_static_debug_assoc_text(counts)

/proc/camera_static_debug_coverage_histogram(var/list/turfs, var/list/coverage)
	if(!length(turfs))
		return "none"
	var/list/counts = list()
	for(var/turf/T as anything in turfs)
		var/coverage_count = coverage[T]
		if(isnull(coverage_count))
			coverage_count = 0
		counts["[coverage_count]"] = counts["[coverage_count]"] + 1
	return camera_static_debug_assoc_text(counts)

/proc/camera_static_debug_assoc_text(var/list/assoc)
	if(!length(assoc))
		return "none"
	var/list/parts = list()
	for(var/key in assoc)
		parts += "[key]=[assoc[key]]"
	return jointext(parts, ", ")

/proc/camera_static_debug_stack_text(z)
	var/list/stack = SSmapping.get_connected_levels(z)
	if(length(stack))
		return camera_static_debug_join_list(stack)
	return "\[[z]\]"

/proc/camera_static_debug_join_list(var/list/L)
	if(!length(L))
		return "\[\]"
	return "\[[jointext(L, ", ")]\]"

/proc/camera_static_debug_plane_offset(z)
	if(!SSmapping.z_level_to_plane_offset || z < 1 || z > length(SSmapping.z_level_to_plane_offset))
		return "null"
	return SSmapping.z_level_to_plane_offset[z]

/proc/camera_static_debug_lowest_plane_offset(z)
	if(!SSmapping.z_level_to_lowest_plane_offset || z < 1 || z > length(SSmapping.z_level_to_lowest_plane_offset))
		return "null"
	return SSmapping.z_level_to_lowest_plane_offset[z]

/proc/camera_static_debug_same_stack(z_a, z_b)
	if(isnull(z_a) || isnull(z_b))
		return FALSE
	var/list/stack_a = SSmapping.get_connected_levels(z_a)
	var/list/stack_b = SSmapping.get_connected_levels(z_b)
	if(length(stack_a) && length(stack_b))
		return stack_a == stack_b
	return z_a == z_b

/proc/camera_static_debug_bool(value)
	return value ? "TRUE" : "FALSE"

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/simulated/wall/T = null
	for(var/i = 1; i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					src.set_dir(SOUTH)
				if(SOUTH)
					src.set_dir(NORTH)
				if(WEST)
					src.set_dir(EAST)
				if(EAST)
					src.set_dir(WEST)
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/structure/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(var/mob/M)
	for(var/obj/structure/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/obj/structure/machinery/camera/proc/weld(var/obj/item/weldingtool/WT, var/mob/user)

	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	// Do after stuff here
	to_chat(user, SPAN_NOTICE("You start to weld the [src].."))
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	user.flash_act(FLASH_PROTECTION_MAJOR)
	busy = 1
	if(WT.use_tool(src, user, 100, volume = 50))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0

/obj/structure/machinery/camera/interact(mob/living/user as mob)
	if(!panel_open || istype(user, /mob/living/silicon/ai))
		return

	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

	user.set_machine(src)
	wires.interact(user)

/obj/structure/machinery/camera/proc/add_network(var/network_name)
	add_networks(list(network_name))

/obj/structure/machinery/camera/proc/remove_network(var/network_name)
	remove_networks(list(network_name))

/obj/structure/machinery/camera/proc/add_networks(var/list/networks)
	var/network_added
	network_added = 0
	for(var/network_name in networks)
		if(!(network_name in src.network))
			network += network_name
			network_added = 1

	if(network_added)
		update_coverage(1)

/obj/structure/machinery/camera/proc/remove_networks(var/list/networks)
	var/network_removed
	network_removed = 0
	for(var/network_name in networks)
		if(network_name in src.network)
			network -= network_name
			network_removed = 1

	if(network_removed)
		update_coverage(1)

/obj/structure/machinery/camera/proc/replace_networks(var/list/networks)
	if(networks.len != network.len)
		network = networks
		update_coverage(1)
		return

	for(var/new_network in networks)
		if(!(new_network in network))
			network = networks
			update_coverage(1)
			return

/obj/structure/machinery/camera/proc/clear_all_networks()
	if(network.len)
		network.Cut()
		update_coverage(1)

/obj/structure/machinery/camera/proc/nano_structure()
	var/cam = list()
	cam["name"] = sanitize(c_tag)
	cam["deact"] = !can_use()
	cam["camera"] = "[REF(src)]"
	cam["x"] = x
	cam["y"] = y
	cam["z"] = z
	return cam

// Resets the camera's wires to fully operational state. Used by one of Malfunction abilities.
/obj/structure/machinery/camera/proc/reset_wires()
	if(!wires)
		return
	if (stat & BROKEN) // Fix the camera
		stat &= ~BROKEN
	wires.cut_all(src)
	wires.repair()
	update_icon()
	update_coverage()
