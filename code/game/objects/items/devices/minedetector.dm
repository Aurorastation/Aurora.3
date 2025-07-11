/obj/item/device/mine_detector
	name = "mine detector"
	desc = "A device capable of detecting mines and traps in a range."
	icon = 'icons/obj/item/device/gps.dmi'
	icon_state = "gps"
	item_state = "radio"

	///The types that are detected by this device
	var/list/detectable_types = list(/obj/item/landmine, /obj/item/trap)

	///The range in which the detection happens
	var/detection_range = 4

	///The angle from the center in which the detection happens
	var/detection_angle = 30

	///The last time this was activated, to avoid spamming it. In `world.time`
	var/last_use = null

	///How much to wait before allowing a new scan
	var/delay_between_scans = 3 SECONDS

	///If this detector is able to perform scans automatically, instead of having to trigger them manually
	var/can_scan_automatically = FALSE

	///The timer ID for the automatic rescans
	var/timer_id = null

/obj/item/device/mine_detector/attack_self(mob/user)
	. = ..()
	ClearOverlays()
	//Apply the delay and check it is passed, so a new scan can be done
	if((last_use + delay_between_scans) > world.time)
		return

	last_use = world.time

	if(!can_scan_automatically)
		perform_scan(user)

	else

		//If there's no timer, start a new one, otherwise stop the callbacks (aka stop the automatic scanning)
		if(!timer_id)
			to_chat(user, SPAN_NOTICE("You power on the automatic mine detection system, which shows a loading screen with a progress bar."))
			timer_id = addtimer(CALLBACK(src, PROC_REF(perform_scan), user), delay_between_scans, TIMER_UNIQUE|TIMER_STOPPABLE)
			AddOverlays("gps_on")
		else
			to_chat(user, SPAN_NOTICE("You power off the automatic mine detection system."))
			deltimer(timer_id)
			timer_id = null


/obj/item/device/mine_detector/proc/perform_scan(mob/user)

	var/list/turfs_scanned = get_turfs_in_cone(get_turf(src), dir2angle(user.dir), detection_range, detection_angle)

	//This will contain the distance of the closest detected object
	var/minimum_distance_detected = null

	var/obj/effect/overlay/teleport_pulse/scanned = new() //This goes in nullspace because we want to project the image to the user only

	//Search across the content of the turfs we got in the cone
	for(var/turf/turf as anything in turfs_scanned)

		//Show the effect on every turf that was scanned, to the user
		user.client.images += image(scanned, turf)

		for(var/item in turf.contents)

			//If it's a type we can detect
			if(is_type_in_list(item, detectable_types))

				//Set it as the minimum distance mine if it's either not set, or closer than the previous detection
				var/distance = get_dist(src, item)
				if(isnull(minimum_distance_detected) || (distance < minimum_distance_detected))
					minimum_distance_detected = distance

	//Select the appropriate sound to play based on the distance, but only if something was detected
	if(!isnull(minimum_distance_detected))
		var/sound = null

		//Pick the audio based on the distance
		if(minimum_distance_detected < 2)
			sound = 'sound/items/devices/minedetector/minedetector_close.ogg'
		else if(minimum_distance_detected <= (detection_range / 2))
			sound = 'sound/items/devices/minedetector/minedetector_medium.ogg'
		else
			sound = 'sound/items/devices/minedetector/minedetector_far.ogg'

		//Play it
		playsound(src, sound, 75, FALSE)

	//Reregister the next callback timer if we're running automatic scans
	if(can_scan_automatically && timer_id)
		timer_id = addtimer(CALLBACK(src, PROC_REF(perform_scan), user), delay_between_scans, TIMER_UNIQUE|TIMER_STOPPABLE)

/*#############
	Subtypes
#############*/

/obj/item/device/mine_detector/advanced
	name = "advanced mine detector"
	desc = "A device capable of detecting mines and traps in a range. This one is more advanced, featuring automatic scanning as well as a broader detection angle."
	detection_angle = 45
	can_scan_automatically = TRUE
