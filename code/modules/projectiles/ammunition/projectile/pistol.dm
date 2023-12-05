// 10mm
/obj/item/ammo_casing/pistol/coc/civilian
	name = "10mm bullet casing"
	desc = "A 10mm bullet casing"
	caliber = CALIBER_PISTOL_GENERIC_COC
	projectile_type = /obj/item/projectile/bullet/pistol/civilian/coc

/obj/item/ammo_casing/pistol/coc/civilian/rubber
	name = "10mm rubber bullet casing"
	desc = "A 10mm rubber bullet casing"
	projectile_type = /obj/item/projectile/bullet/pistol/civilian/coc/rubber

/obj/item/ammo_casing/pistol/coc/civilian/flash
	name = "10mm flash bullet casing"
	desc = "A 10mm flash bullet casing"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_magazine/pistol/mk58
	name = "magazine (10mm)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/coc/civilian
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 10mm casing = 50 metal + 75 metal for the magazine itself
	caliber = CALIBER_PISTOL_GENERIC_COC
	max_ammo = 9
	multiple_sprites = 1
	ammo_band_icon = "45_overlay"
	ammo_band_icon_empty = "45_overlay_e"

/obj/item/ammo_magazine/pistol/mk58/rubber
	name = "magazine (10mm rubber)"
	ammo_type = /obj/item/ammo_casing/pistol/coc/civilian/rubber
	matter = list(DEFAULT_WALL_MATERIAL = 75, MATERIAL_PLASTIC = 450)
	ammo_band_color = "#20429b"

/obj/item/ammo_magazine/pistol/mk58/flash
	ammo_type = /obj/item/ammo_casing/pistol/coc/civilian/flash
	ammo_band_color = "#FFFFFF"

/obj/item/ammo_magazine/pistol/mk58/auto
	name = "extended magazine (10mm)"
	matter = list(DEFAULT_WALL_MATERIAL = 900) //Extra 25 metal for an extended mag
	max_ammo = 16
