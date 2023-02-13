/obj/item/ship_ammunition/grauwolf_probe
	name = "grauwolf sensor probe"
	desc = "A sensor probe, used to illuminate the area ahead using the dataling."
	icon = 'icons/obj/guns/ship/ship_ammo_flakbox.dmi'
	icon_state = "bundle_he"
	overmap_icon_state = "flak"
	caliber = SHIP_CALIBER_90MM
	ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE
	overmap_behaviour = null
	projectile_type_override = /obj/item/projectile/ship_ammo/grauwolf_probe
	burst = 4

/obj/item/ship_ammunition/grauwolf_probe/transfer_to_overmap(var/new_z)
	var/obj/effect/overmap/start_object = map_sectors["[new_z]"]
	if(!start_object)
		return FALSE

	var/obj/effect/overmap/projectile/probe/P = new(null, start_object.x, start_object.y, origin)
	P.name = name_override ? name_override : name
	P.desc = desc
	P.ammunition = src
	P.target = overmap_target
	P.range = range
	if(istype(origin, /obj/effect/overmap/visitable/ship))
		var/obj/effect/overmap/visitable/ship/S = origin
		P.dir = S.dir
	P.icon_state = overmap_icon_state
	P.speed = 32
	P.entry_target = entry_point
	forceMove(P)
	log_and_message_admins("A projectile ([name]) has entered the Overmap! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[P.x];Y=[P.y];Z=[P.z]'>JMP</a>)")
	return TRUE
/obj/effect/overmap/projectile/probe
	var/obj/effect/overmap/visitable/origin = null
	var/list/contacts = list() // Contacts, aka overmap effects, in view of the probe
	var/scan_range = 4	// How far the probe "sees", aka how strong the radar is, aka in what radius it will reveal effects
	instant_contact = TRUE
	requires_contact = FALSE

/obj/effect/overmap/projectile/probe/Move()

	var/list/diff_contacts = contacts.Copy()	//Stores the previous-cycle viewed effects that are no longer visible
	var/obj/effect/overmap/visitable/ship/ship = origin

	// Get a list of effects in a radius that the probe sees
	contacts = list()
	for(var/obj/effect/overmap/contact in view(scan_range, src))
		if(contact != ship && !(contact in ship.datalinked))
			contacts |= list(contact)

	// Compute the effects that are no longer visible, now the variable is actually a diff, be sure to not remove the ship or datalinked ships
	diff_contacts -= (contacts - list(ship))

	// Removes the contacts no longer visible
	remove_lost_contacts:
		for(var/obj/effect/overmap/lost_contact in diff_contacts)
			for(var/obj/machinery/computer/ship/sensors/sensor_console in ship.consoles)

				// If the ship is seeing it directly, do not remove
				if(lost_contact in sensor_console.objects_in_view)
					continue remove_lost_contacts

				// If another ship is supplying this contact via the datalink, do not remove
				for(var/obj/effect/overmap/visitable/datalinked_ship in ship.datalinked)
					if(lost_contact in sensor_console.datalink_contacts[datalinked_ship])
						continue remove_lost_contacts

				sensor_console.datalink_remove_contact(lost_contact, ship)

	// Add the new ones
	for(var/obj/machinery/computer/ship/sensors/sensor_console in ship.consoles)
		for(var/contact in contacts)
			sensor_console.datalink_add_contact(contact, ship)
	. = ..()

/obj/effect/overmap/projectile/probe/Initialize(var/maploading, var/sx, var/sy, var/obj/effect/overmap/visitable/shooter)
	origin = shooter
	. = ..(maploading, sx, sy, shooter)

/obj/effect/overmap/projectile/probe/Destroy()
	var/obj/effect/overmap/visitable/ship/ship = origin

	remove_contacts:
		for(var/obj/effect/overmap/contact in contacts)
			for(var/obj/machinery/computer/ship/sensors/sensor_console in ship.consoles)
				// If the ship is seeing it directly, do not remove
				if(contact in sensor_console.objects_in_view)
					continue remove_contacts

				// If another ship is supplying this contact via the datalink, do not remove
				for(var/obj/effect/overmap/visitable/datalinked_ship in ship.datalinked)
					if(contact in sensor_console.datalink_contacts[datalinked_ship])
						continue remove_contacts

				sensor_console.datalink_remove_contact(contact, ship)
	. = ..()

/obj/item/projectile/ship_ammo/grauwolf_probe
	name = "sensor probe projectile"
	icon_state = "small_burst"
	damage = 0
	armor_penetration = 0
	penetrating = 0
	anti_materiel_potential = 0
	speed = 40
