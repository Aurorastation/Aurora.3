/obj/machinery/computer/telescience
	name = "\improper Telepad Control Console"
	desc = "Used to create bluespace portals using the telescience telepad."
	icon_screen = "teleport"
	icon_keyboard = "lightblue_key"
	icon_keyboard_emis = "lightblue_key_mask"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/telesci_console
	var/sending = 1

	/**
	 * The telepad that this console controls
	 */
	var/obj/machinery/telepad/telepad = null

	var/temp_msg = "Telescience control console initialized.<BR>Welcome."

	// VARIABLES //

	///How many teleports left until it becomes uncalibrated
	var/teles_left

	///Projectile data, info about the latest teleport/aim that was done
	var/datum/projectile_data/last_tele_data = null

	///The zlevel aim offset, that was inputted by the user as a target
	var/zlevel_offset = 0

	///The Zlevel that is being targeted, aka the real one
	var/target_zlevel

	///The rotation that was inputted by the user as a target
	var/rotation = 0

	///The angle that was inputted by the user as a target
	var/angle = 45

	///The power that was inputted by the user as a target
	var/power = 5

	///The power offset
	var/power_off

	///The rotation offset
	var/rotation_off
	//var/angle_off

	///The target of the last teleportation, a `/turf`
	var/turf/last_target

	// Based on the power used
	var/teleport_cooldown = 0 // every index requires a bluespace crystal

	/**
	 * A `/list` of power options that this console provides, for the projectile portal calculation
	 *
	 * Each added telecrystal (in `crystals`) unlocks an additional option, up to `max_crystals`
	 */
	var/list/power_options = list(5, 10, 20, 25, 30, 40, 50, 80, 100)

	///Boolean, if we're teleporting (aka opening a portal) right now
	var/teleporting = FALSE

	var/starting_crystals = 0	//Edit this on the map, seriously.
	var/max_crystals = 5

	/**
	 * A `/list` of `/obj/item/bluespace_crystal` that this console contains
	 */
	var/list/obj/item/bluespace_crystal/crystals = list()

	///A GPS that this console contains
	var/obj/item/device/gps/inserted_gps

	///A list of Zlevels that belong to the visitable (generally a ship) we are in
	var/list/our_zlevels = list()

	/**
	 * A list of currently known Zlevels translations below our ship/visitable
	 *
	 * K -> String, the fake zlevel that can be aimed at, it's an absolute number (the console will show it as negative),
	 * starts at the offset of the lowest zlevel of the visitable the console is in
	 * (eg: console at the second zlevel of a ship, with one zlevel below it of the same ship, this will start with an index of 2, the console will show it as -2)
	 *
	 * V -> Number, the actual zlevel
	 */
	var/list/overmap_contacts_zlevels = list()

	/**
	 * The portal that is the origin, above the telepad
	 *
	 * Do *not* set this directly, use `set_origin_portal()`
	 */
	var/obj/effect/portal/origin_portal

	/**
	 * The portal that is the destination
	 *
	 * Do *not* set this directly, use `set_destination_portal()`
	 */
	var/obj/effect/portal/destination_portal

/obj/machinery/computer/telescience/Initialize()
	. = ..()

	recalibrate()

	for(var/i = 1; i <= starting_crystals; i++)
		crystals += new /obj/item/bluespace_crystal/artificial(null) // starting crystals

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/telescience/LateInitialize()
	. = ..()

	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

			//If we got hooked up correctly, populate the list of our zlevels
			if(linked)
				for(var/zlevel in GLOB.map_sectors)
					if(GLOB.map_sectors["[zlevel]"] == linked)
						our_zlevels += text2num(zlevel)


/obj/machinery/computer/telescience/Destroy()
	eject()
	if(inserted_gps)
		inserted_gps.forceMove(loc)
		inserted_gps = null

	if(!QDELETED(origin_portal))
		QDEL_NULL(origin_portal)

	if(!QDELETED(destination_portal))
		QDEL_NULL(destination_portal)

	QDEL_LIST(crystals)

	telepad = null

	return ..()

/obj/machinery/computer/telescience/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "There are [length(crystals) ? length(crystals) : "no"] bluespace crystal\s in the crystal slots."


/obj/machinery/computer/telescience/attackby(obj/item/attacking_item, mob/user, params)

	if(istype(attacking_item, /obj/item/bluespace_crystal))
		if(length(crystals) >= max_crystals)
			to_chat(user, SPAN_WARNING("There are not enough crystal slots."))
			return

		user.drop_item(src)
		crystals += attacking_item
		attacking_item.forceMove(null)
		user.visible_message("[user] inserts [attacking_item] into \the [src]'s crystal slot.",
								SPAN_NOTICE("You insert [attacking_item] into \the [src]'s crystal slot."))
		updateDialog()

	else if(istype(attacking_item, /obj/item/device/gps))

		if(!inserted_gps)
			inserted_gps = attacking_item
			user.unEquip(attacking_item)
			attacking_item.forceMove(src)
			user.visible_message("[user] inserts [attacking_item] into \the [src]'s GPS device slot.",
									SPAN_NOTICE("You insert [attacking_item] into \the [src]'s GPS device slot."))

	else if(attacking_item.ismultitool())

		var/obj/item/device/multitool/M = attacking_item
		if(M.buffer && istype(M.buffer, /obj/machinery/telepad))
			telepad = M.buffer
			M.buffer = null
			to_chat(user, SPAN_CAUTION("You upload the data from the [attacking_item.name]'s buffer."))

	else
		..()

/obj/machinery/computer/telescience/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	src.attack_hand(user)

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/telescience/interact(mob/user)
	var/t
	if(!telepad)
		in_use = 0     //Yeah so if you deconstruct teleporter while its in the process of shooting it wont disable the console
		t += "<div class='statusDisplay'>No telepad located. <BR>Please add telepad data via use of Multitool.</div><BR>"
	else
		if(inserted_gps)
			t += "<A href='byond://?src=[REF(src)];ejectGPS=1'>Eject GPS</A>"
			t += "<A href='byond://?src=[REF(src)];setMemory=1'>Set GPS memory</A>"
		else
			t += "<span class='linkOff'>Eject GPS</span>"
			t += "<span class='linkOff'>Set GPS memory</span>"
		t += "<div class='statusDisplay'>[temp_msg]</div><BR>"
		t += "<A href='byond://?src=[REF(src)];setrotation=1'>Set Bearing</A>"
		t += "<div class='statusDisplay'>[rotation]&deg;</div>"
		t += "<A href='byond://?src=[REF(src)];setangle=1'>Set Elevation</A>"
		t += "<div class='statusDisplay'>[angle]&deg;</div>"
		t += "<span class='linkOn'>Set Power</span>"
		t += "<div class='statusDisplay'>"

		for(var/i = 1; i <= length(power_options); i++)
			if(length(crystals) + telepad.efficiency < i)
				t += "<span class='linkOff'>[power_options[i]]</span>"
				continue
			if(power == power_options[i])
				t += "<span class='linkOn'>[power_options[i]]</span>"
				continue
			t += "<A href='byond://?src=[REF(src)];setpower=[i]'>[power_options[i]]</A>"
		t += "</div>"

		t += "<A href='byond://?src=[REF(src)];setz=1'>Set Vertical Offset</A>"
		t += "<div class='statusDisplay'>[!isnull(zlevel_offset) ? zlevel_offset : "No Data"]</div>"

		t += "<BR><A href='byond://?src=[REF(src)];send=1'>Open Portal</A>"
		t += "<BR><A href='byond://?src=[REF(src)];recal=1'>Recalibrate Crystals</A> <A href='byond://?src=[REF(src)];eject=1'>Eject Crystals</A>"

		// Information about the last teleport
		t += "<BR><div class='statusDisplay'>"
		if(!last_tele_data)
			t += "No teleport data found."
		else
			t += "Source Location: ([last_tele_data.src_x], [last_tele_data.src_y])<BR>"
			//t += "Distance: [round(last_tele_data.distance, 0.1)]m<BR>"
			t += "Time: [round(last_tele_data.time, 0.1)] secs<BR>"
		t += "</div>"

	var/datum/browser/popup = new(user, "telesci", name, 300, 500)
	popup.set_content(t)
	popup.open()
	return

/**
 * Causes sparks to be emitted from the linked telepad
 */
/obj/machinery/computer/telescience/proc/sparks()
	SHOULD_NOT_SLEEP(TRUE)

	if(telepad)
		spark(telepad, 5, GLOB.alldirs)
	else
		return

/**
 * Called when the portal fails to be created
 */
/obj/machinery/computer/telescience/proc/telefail()
	SHOULD_NOT_SLEEP(TRUE)

	sparks()
	visible_message(SPAN_WARNING("The telepad weakly fizzles."))
	return

/obj/machinery/computer/telescience/proc/doteleport(mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(teleport_cooldown > world.time)
		temp_msg = "Telepad is recharging power.<BR>Please wait [round((teleport_cooldown - world.time) / 10)] seconds."
		return

	if(teleporting)
		temp_msg = "Telepad is in use.<BR>Please wait."
		return

	if(telepad)

		var/truePower = clamp(power + power_off, 1, 1000)
		var/trueRotation = rotation + rotation_off
		var/trueAngle = clamp(angle, 1, 90)

		var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
		last_tele_data = proj_data

		var/trueX = clamp(round(proj_data.dest_x, 1), 1, world.maxx)
		var/trueY = clamp(round(proj_data.dest_y, 1), 1, world.maxy)
		var/spawn_time = round(proj_data.time)

		var/turf/target = locate(trueX, trueY, target_zlevel)
		last_target = target
		flick("pad-beam", telepad)

		if(spawn_time > 1.5 SECONDS)
			playsound(telepad.loc, 'sound/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = 1
			temp_msg = "Powering up bluespace crystals.<BR>Please wait."

		addtimer(CALLBACK(src, PROC_REF(complete_doteleport), user, target), spawn_time SECONDS)

/**
 * Completes the teleportation process, after the timer has expired, to be called only by
 * the timer set by `doteleport()`
 */
/obj/machinery/computer/telescience/proc/complete_doteleport(mob/user, turf/target)
	SHOULD_NOT_SLEEP(TRUE)

	if(!telepad)
		return
	if(telepad.stat & NOPOWER)
		return
	teleporting = 0
	teleport_cooldown = world.time + (power * 2)
	teles_left -= 1

	// use a lot of power
	var/power_to_use = (power KILO WATTS)
	if(overmap_contacts_zlevels["[abs(zlevel_offset)]"])
		power_to_use += (300 KILO WATTS * abs(zlevel_offset))

	use_power_oneoff(power_to_use)

	spark(telepad, 5, GLOB.alldirs)

	temp_msg = "Bluespace portal creation successful.<BR>"
	if(teles_left < 10)
		temp_msg += "<BR>Calibration required soon."
	else
		temp_msg += "Data printed below."

	spark(telepad, 5, GLOB.alldirs)

	var/turf/source = target
	var/turf/dest = get_turf(telepad)
	var/log_msg = ""
	log_msg += ": [key_name(user)] has teleported "

	if(sending)
		source = dest
		dest = target

		flick("pad-beam", telepad)
		playsound(telepad.loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff_distance = 5)

	var/total_lifespawn = 25 * length(crystals)

	var/obj/effect/portal/origin = new /obj/effect/portal(dest, null, null, total_lifespawn, 0)
	set_origin_portal(origin)

	var/obj/effect/portal/destination = new /obj/effect/portal(source,  null, null, total_lifespawn, 0)
	set_destination_portal(destination)


	origin.set_target(destination)
	destination.set_target(origin)
	origin.has_failed = FALSE
	destination.has_failed = FALSE

	updateDialog()

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	//If the offset was never changed, use the current zlevel
	if(isnull(target_zlevel))
		target_zlevel = GET_Z(src)

	if(rotation == null || angle == null)
		temp_msg = "ERROR!<BR>Set a angle, rotation and sector."
		return
	if(power <= 0)
		telefail()
		temp_msg = "ERROR!<BR>No power selected!"
		return
	if(telepad)
		if(locate(/obj/effect/portal, telepad.loc))
			temp_msg = "ERROR!<BR>Bluespace portal located at \the [telepad] location!"
			return
	if(angle < 1 || angle > 90)
		telefail()
		temp_msg = "ERROR!<BR>Elevation is less than 1 or greater than 90."
		return
	if(teles_left > 0)
		doteleport(user)
	else
		telefail()
		temp_msg = "ERROR!<BR>Calibration required."
		return

/**
 * Ejects the telecrystals from the console
 */
/obj/machinery/computer/telescience/proc/eject()
	SHOULD_NOT_SLEEP(TRUE)

	for(var/obj/item/I in crystals)
		I.forceMove(src.loc)
		crystals -= I
	power = 0

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(!telepad)
		updateDialog()
		return
	if(telepad.panel_open)
		temp_msg = "Telepad undergoing physical maintenance operations."

	if(href_list["setrotation"])
		var/new_rot = input("Please input desired bearing in degrees.", name, rotation) as num
		if(..()) // Check after we input a value, as they could've moved after they entered something
			return
		rotation = clamp(new_rot, -900, 900)
		rotation = round(rotation, 0.01)

	if(href_list["setangle"])
		var/new_angle = input("Please input desired elevation in degrees.", name, angle) as num
		if(..())
			return
		angle = clamp(round(new_angle, 0.1), 1, 9999)

	if(href_list["setpower"])
		var/index = href_list["setpower"]
		index = text2num(index)
		if(index != null && power_options[index])
			if(length(crystals) + telepad.efficiency >= index)
				power = power_options[index]

	if(href_list["setz"])
		var/inputed_new_z = tgui_input_number(usr, "Please input desired height offset", "Section Selection", 0, max_value = world.maxz, min_value = world.maxz*-1, round_value = TRUE)

		if(..())
			return

		//Use a holder var to do the calculations, detached from the user input, as we vary it
		var/new_z = inputed_new_z
		//If we crossed the 0 mark, get a free additional zlevel (so we don't have to deal with a zlevel 0)
		if(new_z < 0 && abs(new_z) >= src.z)
			new_z--

		//Prevent people from targeting admin levels
		if(isAdminLevel(src.z + new_z))
			to_chat(usr, SPAN_WARNING("Bluespace forces prevent this offset from being used."))
			return

		//If we are going into the negatives, those are "fake" zlevels that we use to refer
		//to outside areas (like other ships, planets, sites, you name it)
		//Same goes for not connected zlevels, in case we ever add them above us
		if((src.z + new_z) < 0 || !AreConnectedZLevels(src.z, (src.z + new_z)))

			overmap_contacts_zlevels = list()

			var/list/obj/effect/overmap/visitable/already_added_visitables = list()

			//Get the minimum zlevel that we need to offset to be extraneous of our ship
			//eg. if we are on Zlevel 4, and our ship covers Z 1 to 5, we have 3 Zlevels
			//that are ours, so we need to offset by 4 to start being outside our zlevels
			//(of course those zlevels would be virtual ones, to place the translation to the real ones for overmap visitables)
			var/our_zlevel = src.z
			var/min_zlevel_below_us = 1
			while((our_zlevel-=1) in our_zlevels)
				min_zlevel_below_us++

			for(var/obj/machinery/computer/ship/sensors/S in SSmachinery.machinery)
				//If we have ownership of this
				if(linked.check_ownership(S))

					//If the deep scan is toggled, we do not allow it, as the range is too large
					//print a message to the user and break the loop
					var/obj/machinery/shipsensors/ship_sensors = S.sensor_ref?.resolve()
					if((ship_sensors?.deep_scan_toggled))
						to_chat(usr, SPAN_WARNING("The deep scan is currently enabled and interferes with the teleporter lock ability."))
						break

					for(var/obj/effect/overmap/visitable/known_visitable in S.objects_in_view)
						//If not fully scanned and identified, skip
						if(S.objects_in_view[known_visitable] < 100)
							continue

						//If it's us or some BS, skip
						if(known_visitable.map_z == our_zlevels)
							continue

						//If we added this already, skip
						if(known_visitable in already_added_visitables)
							continue


						//Ok, we found what would be the offset below us to start adding shit, let's add shit
						for(var/contact_zlevel in known_visitable.map_z)
							overmap_contacts_zlevels["[min_zlevel_below_us+length(overmap_contacts_zlevels)]"] = contact_zlevel

						//Mark it as added
						already_added_visitables += known_visitable

					//One console gave us the zlevels, we can break the loop
					if(length(overmap_contacts_zlevels))
						break

			if((src.z + new_z) < 0 && (num2text(abs(new_z)-1) in overmap_contacts_zlevels))
				target_zlevel = overmap_contacts_zlevels["[abs(new_z)-1]"]
				zlevel_offset = inputed_new_z
			else
				to_chat(usr, SPAN_WARNING("There is nothing targetable at this height."))
				return

		//Same area as us
		else
			if((src.z+new_z) in our_zlevels)
				target_zlevel = (src.z+new_z)
				zlevel_offset = inputed_new_z
			else
				to_chat(usr, SPAN_WARNING("There is nothing targetable at this height."))

	if(href_list["ejectGPS"])
		if(inserted_gps)
			inserted_gps.forceMove(loc)
			inserted_gps = null

	if(href_list["setMemory"])
		if(last_target && inserted_gps)
			inserted_gps.locked_location = last_target
			temp_msg = "Location saved."
		else
			temp_msg = "ERROR!<BR>No data was stored."

	if(href_list["send"])
		sending = 1
		teleport(usr)

	if(href_list["recal"])
		recalibrate()
		sparks()
		temp_msg = "NOTICE:<BR>Calibration successful."

	if(href_list["eject"])
		eject()
		temp_msg = "NOTICE:<BR>Bluespace crystals ejected."

	updateDialog()

/obj/machinery/computer/telescience/process(seconds_per_tick)
	if((stat & NOPOWER) || (telepad?.stat & NOPOWER))
		QDEL_NULL(origin_portal)

/**
 * Recomputes the parameters used for aiming
 */
/obj/machinery/computer/telescience/proc/recalibrate()
	SHOULD_NOT_SLEEP(TRUE)

	teles_left = rand(30, 40)
	//angle_off = rand(-25, 25)
	power_off = rand(-4, 0)
	rotation_off = rand(-10, 10)

/**
 * Sets the origin portal
 *
 * * orig_portal - An `/obj/effect/portal` that will act as the "origin"
 */
/obj/machinery/computer/telescience/proc/set_origin_portal(obj/effect/portal/orig_portal)
	SHOULD_NOT_SLEEP(TRUE)

	origin_portal = orig_portal
	RegisterSignal(origin_portal, COMSIG_QDELETING, PROC_REF(handle_portal_qdel))

/**
 * Sets the origin portal
 *
 * * dest_portal - An `/obj/effect/portal` that will act as the "destination"
 */
/obj/machinery/computer/telescience/proc/set_destination_portal(obj/effect/portal/dest_portal)
	SHOULD_NOT_SLEEP(TRUE)

	destination_portal = dest_portal
	RegisterSignal(destination_portal, COMSIG_QDELETING, PROC_REF(handle_portal_qdel))

/**
 * Handles a portal being deleted
 */
/obj/machinery/computer/telescience/proc/handle_portal_qdel()
	SIGNAL_HANDLER

	destination_portal = null
	origin_portal = null
