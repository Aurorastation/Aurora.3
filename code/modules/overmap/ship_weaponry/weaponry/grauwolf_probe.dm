/obj/item/ship_ammunition/grauwolf_probe
	name = "grauwolf sensor probe"
	desc = "A gun-launched sensor probe, used to scan the area around and relay findings using the datalink."
	icon = 'icons/obj/guns/ship/grauwolfprobe.dmi'
	icon_state = "probe_2"
	overmap_icon_state = "missle_probe"
	caliber = SHIP_CALIBER_90MM
	ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE
	impact_type = SHIP_AMMO_IMPACT_PROBE
	overmap_behaviour = null	// This ammo cannot hit anything
	projectile_type_override = /obj/item/projectile/ship_ammo/grauwolf_probe
	overmap_projectile_type_override = /obj/effect/overmap/projectile/probe
	burst = 1

/obj/effect/overmap/projectile/probe
	var/list/contacts = list() // Contacts, aka overmap effects, in view of the probe
	var/scan_range = 4	// How far the probe "sees", aka how strong the radar is, aka in what radius it will reveal effects
	var/obj/effect/overmap/visitable/ship/ship = null // The ship that shot us, aka the one to datalink send contacts to
	speed = 40

	icon_state = "missle_probe"
	instant_contact = TRUE
	requires_contact = FALSE

/obj/effect/overmap/projectile/probe/Initialize(maploading, sx, sy, origin)
	. = ..()
	ship = origin

/obj/effect/overmap/projectile/probe/Move()

	var/list/diff_contacts = contacts.Copy()	//Stores the previous-cycle viewed effects that are no longer visible

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

// /obj/effect/overmap/projectile/probe/Initialize(var/maploading, var/sx, var/sy, var/obj/effect/overmap/visitable/shooter)
// 	// origin = shooter
// 	. = ..(maploading, sx, sy, shooter)

/obj/effect/overmap/projectile/probe/Destroy()

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
