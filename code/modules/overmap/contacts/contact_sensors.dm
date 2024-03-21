#define SENSORS_DISTANCE_COEFFICIENT 5
/obj/machinery/computer/ship/sensors
	var/list/objects_in_view = list() 		// Associative list of objects in view -> identification process
	var/list/contact_datums = list()		// Associate an /obj/effect -> /datum/overmap_contact
	var/list/trackers = list()
	var/list/datalink_contacts = list()		// A list of the datalink contacts we're receiving from the datalinks
	var/tmp/muted = FALSE

/obj/machinery/computer/ship/sensors/Destroy()
	objects_in_view.Cut()
	trackers.Cut()

	for(var/key in contact_datums)
		var/datum/overmap_contact/record = contact_datums[key]
		qdel(record)
	contact_datums.Cut()
	. = ..()

/obj/machinery/computer/ship/sensors/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	. = ..()
	if(. && linked && !contact_datums[linked])
		var/datum/overmap_contact/record = new(src, linked)
		contact_datums[linked] = record
		record.marker.alpha = 255

/obj/machinery/computer/ship/sensors/proc/reveal_contacts(var/mob/user)
	if(user && user.client)
		for(var/key in contact_datums)
			var/datum/overmap_contact/record = contact_datums[key]
			if(record)
				user.client.images |= record.marker

/obj/machinery/computer/ship/sensors/proc/hide_contacts(var/mob/user)
	if(user && user.client)
		for(var/key in contact_datums)
			var/datum/overmap_contact/record = contact_datums[key]
			if(record)
				user.client.images -= record.marker

/obj/machinery/computer/ship/sensors/process()
	..()

	update_sound()

	if(!linked)
		return

	// Update our own marker icon regardless of power or sensor connections.
	var/sensor_range = 0

	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors?.use_power)
		sensor_range = round(sensors.range,1)
	var/datum/overmap_contact/self_record = contact_datums[linked]
	self_record.update_marker_icon()
	self_record.show()

	// Update our 'sensor range' (ie. overmap lighting)
	if(!sensors || !sensors.use_power || (stat & (NOPOWER|BROKEN)))
		if(length(datalink_contacts))
			var/remove_link = !sensors || (stat & BROKEN)
			datalink_remove_all_ships_datalink(remove_link)
		for(var/key in contact_datums)
			var/datum/overmap_contact/record = contact_datums[key]
			if(record.effect == linked)
				continue
			qdel(record) // Immediately cut records if power is lost.

		objects_in_view.Cut()
	else
		self_record.ping_radar(sensor_range)

		// What can we see?
		var/list/objects_in_current_view = list()

		// Find all sectors with a tracker on their z-level. Only works on ships when they are in space.
		for(var/obj/item/ship_tracker/tracker in trackers)
			if(tracker.enabled)
				var/obj/effect/overmap/visitable/tracked_effect = overmap_sectors["[GET_Z(tracker)]"]
				if(tracked_effect && istype(tracked_effect) && tracked_effect != linked && tracked_effect.requires_contact)
					objects_in_current_view[tracked_effect] = TRUE
					objects_in_view[tracked_effect] = 100


		// Handle datalinked view
		datalink_process()

		var/turf/overmap_grid_turf = get_turf(linked)

		for(var/obj/effect/overmap/contact in view(sensor_range, overmap_grid_turf))
			if(contact == linked)
				continue
			if(!contact.requires_contact)	   // Only some effects require contact for visibility.
				continue

			objects_in_current_view[contact] = TRUE

			if(contact.instant_contact)   // Instantly identify the object in range.
				objects_in_view[contact] = 100
			else if(!(contact in objects_in_view))
				objects_in_view[contact] = 0

		if(sensors.deep_scan_toggled)
			for(var/obj/effect/overmap/contact in range(sensors.deep_scan_range, overmap_grid_turf))
				if(!contact.sensor_range_override)
					continue
				if(contact == linked)
					continue
				if(!contact.requires_contact)	   // Only some effects require contact for visibility.
					continue

				objects_in_current_view[contact] = TRUE

				if(contact.instant_contact)   // Instantly identify the object in range.
					objects_in_view[contact] = 100
				else if(!(contact in objects_in_view))
					objects_in_view[contact] = 0

		for(var/obj/effect/overmap/contact in objects_in_view) //Update everything.

			// Are we already aware of this object?
			var/datum/overmap_contact/record = contact_datums[contact]

			// Fade out and remove anything that is out of range.
			if(QDELETED(contact) || !objects_in_current_view[contact]) // Object has exited sensor range.
				if(record)
					animate(record.marker, alpha=0, 2 SECOND, 1, LINEAR_EASING)
					QDEL_IN(record, 2 SECOND) // Need to restart the search if you've lost contact with the object.
					if(contact.scannable)	  // Scannable objects are the only ones that give off notifications to prevent spam
						visible_message(SPAN_NOTICE("\The [src] states, \"Contact lost with [record.name].\""))
						playsound(loc, 'sound/machines/sensors/contact_lost.ogg', 30, 1)
				objects_in_view -= contact
				continue

			// Generate contact information for this overmap object.
			var/bearing = round(90 - Atan2(contact.x - linked.x, contact.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			if(!record) // Begin attempting to identify ship.
				// The chance of detection decreases with distance to the target ship.
				if(contact.scannable && prob((SENSORS_DISTANCE_COEFFICIENT * contact.sensor_visibility)/max(get_dist(linked, contact), 0.5)))
					var/bearing_variability = round(30/sensors.sensor_strength, 5)
					var/bearing_estimate = round(rand(bearing-bearing_variability, bearing+bearing_variability), 5)
					if(bearing_estimate < 0)
						bearing_estimate += 360
					// Give the player an idea of where the ship is in relation to the ship.
					if(objects_in_view[contact] <= 0)
						if(!muted)
							visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"Unknown contact designation '[contact.unknown_id]' detected nearby, bearing [bearing_estimate], error +/- [bearing_variability]. Beginning trace.\""))
						objects_in_view[contact] = round(sensors.sensor_strength**2)
					else
						objects_in_view[contact] += round(sensors.sensor_strength**2)
						if(!muted)
							visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"Contact '[contact.unknown_id]' tracing [objects_in_view[contact]]% complete, bearing [bearing_estimate], error +/- [bearing_variability].\""))
					playsound(loc, 'sound/machines/sensors/contactgeneric.ogg', 10, 1) //Let players know there's something nearby.
				if(objects_in_view[contact] >= 100) // Identification complete.
					record = new /datum/overmap_contact(src, contact)
					contact_datums[contact] = record
					if(contact.scannable)
						playsound(loc, 'sound/machines/sensors/newcontact.ogg', 30, 1)
						visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"New contact identified, designation [record.name], bearing [bearing].\""))
					record.show()
					animate(record.marker, alpha=255, 2 SECOND, 1, LINEAR_EASING)
				continue
			// Update identification information for this record.
			record.update_marker_icon()

			var/time_delay = max((SENSOR_TIME_DELAY * get_dist(linked, contact)),1)
			if(!record.pinged)
				addtimer(CALLBACK(record, PROC_REF(ping)), time_delay)

/obj/machinery/computer/ship/sensors/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	var/obj/item/device/multitool/P = attacking_item
	if(!istype(P))
		return
	var/obj/item/ship_tracker/tracker = P.get_buffer()
	if(!tracker || !istype(tracker))
		return

	if(tracker in trackers)
		trackers -= tracker
		GLOB.destroyed_event.unregister(tracker, src, PROC_REF(remove_tracker))
		to_chat(user, SPAN_NOTICE("You unlink the tracker in \the [P]'s buffer from \the [src]."))
		return
	trackers += tracker
	GLOB.destroyed_event.register(tracker, src, PROC_REF(remove_tracker))
	to_chat(user, SPAN_NOTICE("You link the tracker in \the [P]'s buffer to \the [src]."))

/obj/machinery/computer/ship/sensors/proc/remove_tracker(var/obj/item/ship_tracker/tracker)
	trackers -= tracker

/obj/machinery/computer/ship/sensors/proc/datalink_process()
	for(var/obj/effect/overmap/visitable/datalink_ship in src.connected.datalinked)					// Get ships that are datalinked with us
		for(var/obj/machinery/computer/ship/sensors/sensor_console in datalink_ship.consoles)							// Pick one sensor console


			var/list/diff_datalink_contacts = list()

			// If it's not a known datalinked ship already, initalize its list of supplied contacts
			if(!length(datalink_contacts[datalink_ship]))
				datalink_contacts[datalink_ship] = list()

			datalink_process_all_contacts_of_console(sensor_console, datalink_ship)

			// If it's a known datalink, compute the lost contacts to remove
			if(datalink_contacts[datalink_ship])
				diff_datalink_contacts = datalink_contacts[datalink_ship] - (sensor_console.objects_in_view + list(datalink_ship))

			for(var/obj/effect/overmap/datalink_contact in diff_datalink_contacts)
				datalink_remove_contact(datalink_contact, datalink_ship)
			continue

		// Handle the datalinked ship's own contact
		var/datum/overmap_contact/ship_contact_record = contact_datums[datalink_ship]

		if(!ship_contact_record)
			datalink_add_contact(datalink_ship, datalink_ship, force = TRUE)
			ship_contact_record = contact_datums[datalink_ship]

		ship_contact_record.ping()
		ship_contact_record.update_marker_icon()

/obj/machinery/computer/ship/sensors/proc/datalink_process_all_contacts_of_console(var/obj/machinery/computer/ship/sensors/sensor_console, var/obj/effect/overmap/visitable/datalink_ship)
	for(var/obj/effect/overmap/datalink_contact in sensor_console.objects_in_view) // Pick one contact that the sensor console has
		if(datalink_contact != src.connected)
			if(!(datalink_contact in datalink_contacts[datalink_ship]))		// This is a new datalink contact
				if(!(contact_datums[datalink_contact]))
					datalink_add_contact(datalink_contact, datalink_ship)
			else
				var/datum/overmap_contact/datalink_contact_record = contact_datums[datalink_contact]

				if(datalink_contact_record && !QDELING(datalink_contact_record))
					datalink_contact_record.ping()


/obj/machinery/computer/ship/sensors/proc/datalink_remove_all_contacts_of_console(var/obj/machinery/computer/ship/sensors/sensor_console, var/obj/effect/overmap/visitable/datalink_ship)
	for(var/obj/effect/overmap/datalink_contact in sensor_console.objects_in_view)
		if(datalink_contact != src.connected)
			datalink_remove_contact(datalink_contact, datalink_ship)


/obj/machinery/computer/ship/sensors/proc/datalink_add_contact(var/obj/effect/overmap/datalink_contact, var/obj/effect/overmap/visitable/datalink_ship, var/force = FALSE)
	if(!(datalink_contact in datalink_contacts[datalink_ship]) && !(objects_in_view[datalink_contact]) || force)			// This is a new datalink contact

		var/datum/overmap_contact/datalink_contact_record = contact_datums[datalink_contact]					// Is it already in the contact_datums?
		if(!datalink_contact_record)																			// If not, create it
			datalink_contact_record = new /datum/overmap_contact(src, datalink_contact)
			contact_datums[datalink_contact] = datalink_contact_record											// And add it with its associated effect


		if(!QDELING(datalink_contact_record))
			// Show the new contact
			datalink_contact_record.show()
			datalink_contact_record.ping()
			animate(datalink_contact_record.marker, alpha=255, 2 SECOND, 1, LINEAR_EASING)
			datalink_contact_record.update_marker_icon()

			// Add it to the contact datum
			if(!datalink_contacts[datalink_ship])
				datalink_contacts[datalink_ship] = list()
			datalink_contacts[datalink_ship] |= list(datalink_contact)


/obj/machinery/computer/ship/sensors/proc/datalink_remove_contact(var/obj/effect/overmap/datalink_contact, var/obj/effect/overmap/visitable/datalink_ship)
	var/datum/overmap_contact/datalink_contact_record = contact_datums[datalink_contact]							// Retrieve the contact record
	if(!datalink_contact_record)
		return
	animate(datalink_contact_record.marker, alpha=0, 2 SECOND, 1, LINEAR_EASING)
	QDEL_IN(datalink_contact_record, 2 SECOND)

	if(datalink_contacts[datalink_ship])
		datalink_contacts[datalink_ship] -= list(datalink_contact)


/obj/machinery/computer/ship/sensors/proc/datalink_add_ship_datalink(var/obj/effect/overmap/visitable/datalink_ship)
	datalink_ship.datalinked |= src.connected
	src.connected.datalinked |= datalink_ship

/obj/machinery/computer/ship/sensors/proc/datalink_remove_ship_datalink(var/obj/effect/overmap/visitable/datalink_ship, var/remove_link)
	if(datalink_contacts[datalink_ship])
		for(var/obj/machinery/computer/ship/sensors/sensor_console in datalink_ship.consoles)
			// Remove the two ships from each other's datalinked list
			if(remove_link)
				src.connected.datalinked -= datalink_ship
				datalink_ship.datalinked -= src.connected

			// Removes the ship contact itself from the contacts

			var/datum/overmap_contact/ship_contact_record = contact_datums[datalink_ship]

			if(ship_contact_record)
				animate(ship_contact_record.marker, alpha=0, 2 SECOND, 1, LINEAR_EASING)
				QDEL_IN(ship_contact_record, 2 SECOND)
				//contact_datums[datalink_ship] -= ship_contact_record

			// Remove all contacts
			datalink_remove_all_contacts_of_console(sensor_console, datalink_ship)


			datalink_contacts.Remove(datalink_ship)

			// Recurse the function on the other ship's instance
			sensor_console.datalink_remove_ship_datalink(src.connected, remove_link)
		visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"A datalink contact was severed! Recalibrating...\""))


/obj/machinery/computer/ship/sensors/proc/datalink_remove_all_ships_datalink(var/remove_link)
	for(var/obj/effect/overmap/visitable/datalink_ship in linked.datalinked)
		for(var/obj/machinery/computer/ship/sensors/sensor_console in datalink_ship.consoles)
			sensor_console.datalink_remove_ship_datalink(linked, remove_link)
			break


#undef SENSORS_DISTANCE_COEFFICIENT
