/obj/machinery/ship_weapon/bruiser
	name = "bruiser cannon II"
	desc = "Among the Hegemony's earliest forays into ranged weaponry for their military ships, although obsolete nowadays, the Bruiser is popular among many Unathi sailors - including pirates - for its extreme simplicity, allowing it to fire handcraft ammo with minimal modification."
	icon = 'icons/obj/machines/ship_guns/bruiser.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/cannon.ogg'
	icon_state = "weapon_base"
	max_ammo = 1
	projectile_type = /obj/item/projectile/ship_ammo/bruiser
	caliber = SHIP_CALIBER_135MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ammunition_loader/bruiser
	name = "bruiser ammunition loader"
	icon_state = "ammo_loader_unathi"

/obj/item/ship_ammunition/bruiser
	name = "bruiser canister shell"
	name_override = "canister shot"
	desc = "A rough shell that should fit in a bruiser cannon. This one is filled with shot that causes wide damage, but must get through the hull first."
	icon = 'icons/obj/guns/ship/ship_ammo_midshell.dmi'
	icon_state = "shell_canister"
	w_class = ITEMSIZE_LARGE
	impact_type = SHIP_AMMO_IMPACT_FMJ
	ammunition_flags = null
	caliber = SHIP_CALIBER_135MM
	burst = 11
	cookoff_heavy = 0
	overmap_icon_state = "flak"

/obj/item/ship_ammunition/bruiser/get_speed()
	return 35

/obj/item/ship_ammunition/bruiser/flechette
	name = "bruiser beehive shell"
	name_override = "flechette burst"
	desc = "A rough shell that should fit in a bruiser cannon. This one is filled with projectiles that easily get through the hull, but do little damage."
	icon_state = "shell_flechette"
	burst = 9
	projectile_type_override = /obj/item/projectile/ship_ammo/bruiser/flechette

/obj/item/projectile/ship_ammo/bruiser
	name = "canister shot pellet"
	icon_state = "small"
	damage = 35
	armor_penetration = 35
	penetrating = 1

/obj/item/projectile/ship_ammo/bruiser/flechette
	name = "beehive flechette"
	icon_state = "small_burst"
	damage = 20
	armor_penetration = 50
	penetrating = 5