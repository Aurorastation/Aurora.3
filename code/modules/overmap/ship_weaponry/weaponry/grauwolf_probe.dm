// /obj/machinery/ship_weapon/grauwolf
// 	name = "grauwolf flak battery"
// 	desc = "A Kumar Arms flak battery developed in 2461 as part of the same <i>\"Chivalry\"</i> line of the Longbow. Its barrels may look smaller than its significantly larger kin's, \
// 			but don't let that fool you: this gun will shred through smaller ships."
// 	icon = 'icons/obj/machinery/ship_guns/grauwolf.dmi'
// 	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/flak_fire.ogg'
// 	icon_state = "weapon_base"
// 	max_ammo = 5
// 	caliber = SHIP_CALIBER_90MM
// 	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

// /obj/machinery/ammunition_loader/grauwolf
// 	name = "grauwolf flak loader"

/obj/item/ship_ammunition/grauwolf_probe
	name = "grauwolf sensor probe"
	desc = "A sensor probe, used to illuminate the area ahead using the dataling."
	icon = 'icons/obj/guns/ship/ship_ammo_flakbox.dmi'
	icon_state = "bundle_he"
	overmap_icon_state = "flak"
	caliber = SHIP_CALIBER_90MM
	ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE
	projectile_type_override = /obj/item/projectile/ship_ammo/grauwolf
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

// /obj/item/ship_ammunition/grauwolf_bundle/ap
// 	name = "grauwolf armor-piercing flak bundle"
// 	desc = "A bundle of armor-piercing flak shells."
// 	icon_state = "bundle_ap"
// 	impact_type = SHIP_AMMO_IMPACT_AP
// 	projectile_type_override = /obj/item/projectile/ship_ammo/grauwolf/ap

/obj/effect/overmap/projectile/probe
	var/obj/effect/overmap/visitable/origin = null

/obj/effect/overmap/projectile/probe/move_to()
	var/list/contacts = list()

	for(var/obj/effect/overmap/contact in view(7, src))
		contacts |= list(contact)

	//var/obj/item/ship_ammunition/ammo = src.ammo
	var/obj/effect/overmap/visitable/ship/ship = origin

	for(var/obj/machinery/computer/ship/sensors/sensor_console in ship.consoles)
		for(var/contact in contacts)
			sensor_console.datalink_add_contact(contact, ship)
	. = ..()

/obj/effect/overmap/projectile/probe/Initialize(var/maploading, var/sx, var/sy, var/obj/effect/overmap/visitable/shooter)
	origin = shooter
	. = ..(maploading, sx, sy)

/obj/item/projectile/ship_ammo/grauwolf
	name = "high-explosive flak"
	icon_state = "small_burst"
	damage = 0
	armor_penetration = 0
	penetrating = 0
	anti_materiel_potential = 0
	speed = 80

/obj/item/projectile/ship_ammo/grauwolf/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()

/obj/item/projectile/ship_ammo/grauwolf/process()
	. = ..()

/obj/item/projectile/ship_ammo/grauwolf/fire(angle, atom/direct_target)
	. = ..()
