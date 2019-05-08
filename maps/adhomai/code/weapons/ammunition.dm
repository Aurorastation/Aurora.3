// BULLETS AND CARTRIDGES
/obj/item/ammo_casing/c38/nka
	desc = "A .38 bullet casing. It seems to possess a steel cartridge and iron core."
	icon = 'icons/adhomai/weapons/ammunition.dmi'
	icon_state = "38-casing"
	spent_icon = "38-casing-spent"
	matter = list(DEFAULT_WALL_MATERIAL = 20, "iron" = 5)
	contained_sprite = TRUE

/obj/item/ammo_casing/a762/nka
	desc = "A 7.62mm bullet casing. It seems to possess a steel cartridge and iron core."
	icon = 'icons/adhomai/weapons/ammunition.dmi'
	icon_state = "762-casing"
	spent_icon = "762-casing-spent"
	matter = list(DEFAULT_WALL_MATERIAL = 40, "iron" = 10)
	contained_sprite = TRUE

/obj/item/ammo_casing/rpg
	name = "rocket-propelled grenade"
	desc = "A high explosive designed to be fired from a launcher."
	icon = 'icons/adhomai/weapons/ammunition.dmi'
	icon_state = "rpg"
	projectile_type = /obj/item/projectile/bullet/cannon
	caliber = "rpg"

// MAGAZINES AND CLIPS
/obj/item/ammo_magazine/boltaction/nka
	name = "stripper clip"
	desc = "A stripper clip issued to members of the Imperial Adhomian Army."
	icon = 'icons/adhomai/weapons/ammunition.dmi'
	icon_state = "762SC"
	ammo_type = /obj/item/ammo_casing/a762/nka
	matter = list(DEFAULT_WALL_MATERIAL = 40)
	contained_sprite = TRUE

/obj/item/ammo_magazine/boltaction/nka/enbloc
	name = "en bloc clip"
	desc = "An en block clip issued to members of the Imperial Adhomian Army."
	icon_state = "762EBC"
	matter = list(DEFAULT_WALL_MATERIAL = 40)
	mag_type = MAGAZINE

/obj/item/ammo_magazine/nka
	name = "ammunition magazine"
	desc = "A somewhat reliable sidearm magazine issued to members of the Imperial Adhomian Army."
	icon = 'icons/adhomai/weapons/ammunition.dmi'
	icon_state = "38M"
	max_ammo = 5
	ammo_type = /obj/item/ammo_casing/c38/nka
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	caliber = "38"
	multiple_sprites = 1
	mag_type = MAGAZINE
	contained_sprite = TRUE

/obj/item/ammo_magazine/nka/kt_76
	name = ".38 stripper clip"
	desc = "A reliable sidearm magazine issued to members of the Imperial Adhomian Army."
	icon_state = "38SC"
	max_ammo = 10
	matter = list(DEFAULT_WALL_MATERIAL = 40)
	multiple_sprites = 1
	mag_type = SPEEDLOADER

/obj/item/ammo_magazine/c38/nka
	name = "speed loader (.38)"
	icon_state = "38SL"
	icon = 'icons/adhomai/weapons/ammunition.dmi'
	caliber = "38"
	matter = list(DEFAULT_WALL_MATERIAL = 30)
	ammo_type = /obj/item/ammo_casing/c38/nka
	max_ammo = 6
	multiple_sprites = 1
	contained_sprite = TRUE