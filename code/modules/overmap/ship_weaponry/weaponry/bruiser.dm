/obj/machinery/ship_weapon/bruiser
	name = "bruiser cannon II"
	desc = "Among the Hegemony's earliest forays into ranged weaponry for their military ships, newer models of the Bruiser remain common on Hegemony ships. Older designs of the weapon popular among many Unathi sailors - including pirates - for their extreme simplicity, allowing them to fire handcrafted ammunition with minimal modification."
	desc_extended = "The Hegemony Model I 'Bruiser' was the first spaceship-mounted weapon to be designed by Izweski engineers - a simple enough design for a heavy ballistic cannon. The Bruiser is also notable for the light weight of its ammunition, allowing an Unathi to carry a shell without need of mechanical assistance - minimizing the expensive equipment that a vessel might require to fight. The Model I Bruiser was inaccurate, slow to fire and prone to overheating, leading to the design of the commonly-used Hegemony Model II 'Bruiser', largely seen on the corvettes and destroyers of the Izweski Navy. The Model II is faster, more accurate and capable of firing at much higher velocities, enabling the smaller ships of the Navy to punch above their weight class in battle."
	icon = 'icons/obj/machinery/ship_guns/bruiser.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/cannon.ogg'
	icon_state = "weapon_base"
	max_ammo = 1
	projectile_type = /obj/projectile/ship_ammo/bruiser
	caliber = SHIP_CALIBER_178MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN
	load_time = 4 SECONDS

/obj/machinery/ammunition_loader/bruiser
	name = "bruiser ammunition loader"
	icon_state = "ammo_loader_unathi"

/obj/item/ship_ammunition/bruiser
	name = "makeshift bruiser canister shell"
	name_override = "canister shot"
	desc = "A rough, handmade shell that should fit in a bruiser cannon. This one is filled with shot that causes wide damage, but must get through the hull first."
	icon = 'icons/obj/guns/ship/ship_ammo_midshell.dmi'
	icon_state = "shell_canister"
	w_class = ITEMSIZE_LARGE
	impact_type = SHIP_AMMO_IMPACT_FMJ
	ammunition_flags = SHIP_AMMO_FLAG_VERY_HEAVY
	mob_carry_size = 10 //unathi, dionae and all vaurca can lift these bad boys up.
	caliber = SHIP_CALIBER_178MM
	burst = 11
	cookoff_heavy = 0
	overmap_icon_state = "cannon_salvo"

/obj/item/ship_ammunition/bruiser/get_speed()
	return 35

/obj/item/ship_ammunition/bruiser/real/get_speed()
	return 25

/obj/item/ship_ammunition/bruiser/flechette
	name = "makeshift bruiser beehive shell"
	name_override = "flechette burst"
	desc = "A rough, handmade shell that should fit in a bruiser cannon. This one is filled with projectiles that easily get through the hull, but do little damage."
	icon_state = "shell_flechette"
	burst = 9
	projectile_type_override = /obj/projectile/ship_ammo/bruiser/flechette

/obj/item/ship_ammunition/bruiser/he
	name = "makeshift bruiser explosive shell"
	name_override = "explosive shell"
	desc = "A rough, handmade shell that should fit in a bruiser cannon. This one is filled with makeshift explosives."
	icon_state = "shell_he"
	impact_type = SHIP_AMMO_IMPACT_HE
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	burst = 0
	cookoff_heavy = 1
	overmap_icon_state = "cannon_heavy"
	projectile_type_override = /obj/projectile/ship_ammo/bruiser/he

/obj/item/ship_ammunition/bruiser/real/he
	name = "bruiser explosive shell"
	name_override = "explosive shell"
	desc = "A high-explosive shell designed for the Hegemony Bruiser cannon. Manufactured by Hephaestus Industries"
	icon_state = "shell_he_real"
	impact_type = SHIP_AMMO_IMPACT_HE
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	burst = 0
	cookoff_heavy = 2
	overmap_icon_state = "cannon_heavy"
	projectile_type_override = /obj/projectile/ship_ammo/bruiser/real/he

/obj/item/ship_ammunition/bruiser/real/ap
	name = "bruiser armor-piercing shell"
	name_override = "armor-piercing shell"
	desc = "An armor-piercing shell designed for the Hegemony Bruiser cannon. Manufactured by Hephaestus Industries"
	icon_state = "shell_ap_real"
	impact_type = SHIP_AMMO_IMPACT_AP
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	burst = 0
	cookoff_heavy = 2
	overmap_icon_state = "cannon_heavy"
	projectile_type_override = /obj/projectile/ship_ammo/bruiser/real/ap

/obj/item/ship_ammunition/bruiser/real/canister
	name = "bruiser canister shell"
	name_override = "canister shot"
	desc = "An expensive shell designed for the Hegemony Bruiser cannon by Hephaestus Industries. This one bursts into many small pellets."
	icon_state = "shell_canister_real"
	burst = 23
	projectile_type_override = /obj/projectile/ship_ammo/bruiser/real/canister

/obj/item/ship_ammunition/bruiser/real/beehive
	name = "bruiser beehive shell"
	name_override = "slugger shot"
	desc = "An expensive shell designed for the Hegemony Bruiser cannon by Hephaestus Industries. Very popular among Unathi, this shell bursts into many slugger projectiles that punch through the hull with less mass, but more force."
	icon_state = "shell_flechette_real"
	burst = 9
	projectile_type_override = /obj/projectile/ship_ammo/bruiser/real/beehive

/obj/projectile/ship_ammo/bruiser
	name = "canister shot pellet"
	icon_state = "small"
	damage = 35
	armor_penetration = 35
	penetrating = 1

/obj/projectile/ship_ammo/bruiser/flechette
	name = "beehive flechette"
	icon_state = "small_burst"
	damage = 20
	armor_penetration = 50
	penetrating = 5
	embed = TRUE
	embed_chance = 40
	shrapnel_type = /obj/item/material/shard/shrapnel/flechette

/obj/projectile/ship_ammo/bruiser/he
	name = "178mm shell"
	icon_state = "heavy"
	damage = 150
	armor_penetration = 75
	penetrating = 0

/obj/projectile/ship_ammo/bruiser/he/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	explosion(target, 1, 3, 6)

/obj/projectile/ship_ammo/bruiser/real/he
	name = "178mm shell"
	icon_state = "heavy"
	damage = 350
	armor_penetration = 125
	penetrating = 0

/obj/projectile/ship_ammo/bruiser/real/ap
	name = "178mm shell"
	icon_state = "heavy"
	damage = 250
	armor_penetration = 250
	penetrating = 2

/obj/projectile/ship_ammo/bruiser/real/canister
	damage = 40
	armor_penetration = 40
	penetrating = 2
	stun = 2

/obj/projectile/ship_ammo/bruiser/real/beehive //comparable to slugger projectiles but slightly stronger
	name = "massive slug"
	icon_state = "heavy"
	damage = 65
	armor_penetration = 10
	penetrating = 6
	stun = 4
	weaken = 4
	maiming = TRUE
	maim_rate = 3
	maim_type = DROPLIMB_BLUNT
	anti_materiel_potential = 2

/obj/projectile/ship_ammo/bruiser/real/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ammo.impact_type == SHIP_AMMO_IMPACT_HE)
		explosion(target, 3, 6, 8)
	if(ammo.impact_type == SHIP_AMMO_IMPACT_AP)
		explosion(target, 0, 2, 4)

/obj/projectile/ship_ammo/bruiser/real/beehive/on_hit(atom/movable/target, blocked, def_zone, is_landmark_hit)
	if(istype(target))
		var/throwdir = dir
		target.throw_at(get_edge_target_turf(target, throwdir),9,8)
		return 1
