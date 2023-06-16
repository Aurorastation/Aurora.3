/obj/machinery/ship_weapon/blaster
	name = "HI-M96 mining blaster"
	desc = "An old, but functional, Hephaestus Industries Model 2396 mining blaster intended, in theory, to smash apart rocks and other mineral sites in order to extract their resources more easily. This particular HI-M96 has been field-modified to remove the normal safety limits on detonation range and can be used as a weapon if one is so inclined."
	desc_extended = "Originally produced during the waning years of Solarian hegemony over much of the Orion Spur, the Model 2396 remains, despite its age, a very common piece of mining equipment in remote or underdeveloped areas of the Spur such as the former Solarian Frontier Sectors where newer equipment is either too rare to use widely. Threats from pirates and privateers have driven miners and independent merchants in these areas to long rely on field-modified M96s as improvised ship-to-ship artillery pieces as their mining charges are perfectly capable of ripping through hulls as effectively as they rip through rock. It is, however, awkward and kludgy to aim due to its nature as an improvised weapon and most discard the M96 when more modern -- or practical -- weaponry is acquired."
	icon = 'icons/obj/machinery/ship_guns/blaster.dmi'
	icon_state = "weapon_base"
	projectile_type = /obj/item/projectile/ship_ammo/blaster

	heavy_firing_sound = 'sound/weapons/railgun.ogg'
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	caliber = SHIP_CALIBER_BLASTER

/obj/item/ship_ammunition/blaster
	name = "mining blaster charge"
	name_override = "mining blaster charge"
	desc = "A single-use charge for a mining blaster."
	icon = 'icons/obj/guns/ship/ship_ammo_blaster.dmi'
	icon_state = "blaster_charge"
	caliber = SHIP_CALIBER_BLASTER
	overmap_icon_state = "med_laser"
	impact_type = SHIP_AMMO_IMPACT_BLASTER

/obj/item/projectile/ship_ammo/blaster
	name = "blaster charge"
	icon_state = "blaster"
	damage = 10000
	armor_penetration = 1000
	penetrating = 1

/obj/item/projectile/ship_ammo/blaster/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] disintegrates [M]'s chest and blasts them into pieces!</font>"))
	if(isturf(target) || isobj(target))
		explosion(target, 2, 5, 7)

/obj/machinery/ammunition_loader/blaster
	name = "mining blaster loader"