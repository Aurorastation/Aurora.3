/obj/machinery/ship_weapon/coilgun
	name = "type 21 nadziak solarian coilgun"
	desc = "The venerable Nadziak-class line of coilguns was born in the fires of the Interstellar War, where its ability to shred shields and low-class hulls have ensured its immortality in the infrastructure of the Solarian Navy."
	desc_extended = "Although originally an expensive blunder made by over-worked Kumar Arms designers, the Nadziak later preformed to an outstanding degree following numerous improvements. Its fame among post-War Admirals was such that it's name and purpose has largely remained the same, with a new 'Type' iteration commissioned every decade or so. With the expulsion of Zavodskoi and its subsidiary from Solarian space, this aging giant and symbol of military might is under threat of being consumed by the resulting arms manufacturing vacuum."
	icon = 'icons/obj/machines/ship_guns/sol_coilgun.dmi'

	heavy_firing_sound = 'sound/weapons/railgun.ogg'
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS

/obj/item/ship_ammunition/coilgun
	name = "tungsten rod"
	desc = "A rod used as ammunition for a coilgun."
	caliber = SHIP_CALIBER_COILGUN
	overmap_icon_state = "cannon" //change this before merge

/obj/item/projectile/ship_ammo/coilgun
	name = "high-power tungsten rod"
	icon_state = "heavy"
	damage = 10000
	armor_penetration = 1000

/obj/item/projectile/ship_ammo/coilgun/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] blows [M] apart and punches straight through!</font>"))
		M.gib()

/obj/machinery/ammunition_loader/sol
	icon_state = "ammo_loader_sol"

/obj/structure/viewport/sol
	icon_state = "viewport_sol"