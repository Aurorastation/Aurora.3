// COC Generic (10mm)
/obj/item/ammo_casing/pistol/coc/civilian
	name = "\improper 10mm bullet casing"
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

/obj/item/ammo_magazine/pistol/c10mm
	name = "\improper Mk58 magazine (10mm)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/coc/civilian
	matter = list(DEFAULT_WALL_MATERIAL = 525)
	caliber = CALIBER_PISTOL_GENERIC_COC
	max_ammo = 9
	multiple_sprites = 1
	ammo_band_icon = "45_overlay"
	ammo_band_icon_empty = "45_overlay_e"

/obj/item/ammo_magazine/pistol/c10mm/rubber
	name = "\improper Mk58 magazine (10mm rubber)"
	ammo_type = /obj/item/ammo_casing/pistol/coc/civilian/rubber
	matter = list(DEFAULT_WALL_MATERIAL = 75, MATERIAL_PLASTIC = 450)
	ammo_band_color = "#20429b"

/obj/item/ammo_magazine/pistol/c10mm/flash
	ammo_type = /obj/item/ammo_casing/pistol/coc/civilian/flash
	ammo_band_color = "#FFFFFF"

/obj/item/ammo_magazine/pistol/c10mm/auto
	name = "\improper Mk58 extended magazine (10mm)"
	matter = list(DEFAULT_WALL_MATERIAL = 900)
	max_ammo = 16

//Sol Generic (9mm)
/obj/item/ammo_casing/pistol/sol/civilian
	name = "\improper 9mm bullet casing"
	desc = "A 9mm bullet casing"
	caliber = CALIBER_PISTOL_GENERIC_COC
	projectile_type = /obj/item/projectile/bullet/pistol/civilian/sol

/obj/item/ammo_casing/pistol/sol/civilian/rubber
	name = "9mm rubber bullet casing"
	desc = "A 9mm rubber bullet casing"
	projectile_type = /obj/item/projectile/bullet/pistol/civilian/sol/rubber

/obj/item/ammo_casing/pistol/sol/civilian/flash
	name = "9mm flash bullet casing"
	desc = "A 9mm flash bullet casing"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_magazine/pistol/s9mm
	name = "\improper Moonlight magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = CALIBER_PISTOL_GENERIC_SOL
	ammo_type = /obj/item/ammo_casing/pistol/sol/civilian
	max_ammo = 12
	multiple_sprites = TRUE

/obj/item/ammo_magazine/pistol/s9mm/flash
	ammo_type = /obj/item/ammo_casing/pistol/sol/civilian/flash

/obj/item/ammo_magazine/pistol/s9mm/full
	name = "fullsize Moonlight magazine (9mm)"
	icon_state = "9x19p_fullsize"
	max_ammo = 17

/obj/item/ammo_magazine/pistol/s9mm/extended
	name = "extended Moonlight magazine (9mm)"
	icon_state = "9x19p_highcap"
	max_ammo = 30

/obj/item/ammo_magazine/pistol/speedloader/s9mm
	name = "speedloader (9mm)"
	icon_state = "a454"
	caliber = CALIBER_PISTOL_GENERIC_SOL
	ammo_type = /obj/item/ammo_casing/c45/revolver
	max_ammo = 6

//Coalition Military (caseless 5mm)
/obj/item/ammo_casing/pistol/coc/military
	name = "\improper 5mm caseless bullet"
	desc = "A military-grade 5mm caseless bullet"
	icon_state = "clbullet"
	caliber = CALIBER_PISTOL_MILITARY_COC
	projectile_type = /obj/item/projectile/bullet/pistol/military/coc
	max_stack = 10
	is_caseless = TRUE

/obj/item/ammo_magazine/pistol/c5mm
	name = "\improper dNAC-5 magazine (5mm)"
	icon_state = "5mmp"
	caliber = CALIBER_PISTOL_MILITARY_COC
	max_ammo = 12
	ammo_type = /obj/item/ammo_casing/pistol/coc/military
	multiple_sprites = TRUE

/obj/item/ammo_magazine/pistol/c5mm/extended
	icon_state = "5mmp_extended"
	max_ammo = 20

//Sol Military (4.6mm)
/obj/item/ammo_casing/pistol/sol/military
	name = "\improper 4.6mm bullet casing"
	desc = "A military-grade 4.6mm bullet casing"
	caliber = CALIBER_PISTOL_MILITARY_SOL
	projectile_type = /obj/item/projectile/bullet/pistol/military/sol
	max_stack = 10

/obj/item/ammo_magazine/pistol/pattern5
	name = "\improper Pattern 5 magazine (4.6mm)"
	icon_state = "pattern5"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/sol/military
	matter = list(DEFAULT_WALL_MATERIAL = 525)
	caliber = CALIBER_PISTOL_MILITARY_SOL
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/pattern5/extended
	name = "\improper Pattern 5 extended magazine (4.6mm)"
	icon_state = "pattern5-ext"
	max_ammo = 12

/obj/item/ammo_magazine/pistol/pattern5/pattern6
	name = "\improper Pattern 6 magazine (4.6mm)"
	max_ammo = 18

//50AE
/obj/item/ammo_casing/pistol/desert_eagle
	name = "\improper .50AE bullet casing"
	desc = "A .50AE bullet casing."
	caliber = CALIBER_PISTOL_50AE
	projectile_type = /obj/item/projectile/bullet/pistol/heavy

/obj/item/ammo_magazine/pistol/desert_eagle
	name = "\improper Desert Eagle magazine (.50AE)"
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_50AE
	max_ammo = 8
	ammo_type = /obj/item/ammo_casing/pistol/desert_eagle

//Heavy Pistol (12mm)
/obj/item/ammo_casing/pistol/heavy
	name = "\improper 12mm bullet casing"
	desc = "A 12mm bullet casing."
	caliber = CALIBER_PISTOL_HEAVY
	projectile_type = /obj/item/projectile/bullet/pistol/heavy

/obj/item/ammo_magazine/pistol/heavy
	name = "heavy pistol magazine (12mm)"
	icon_state = "heavypistol"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_HEAVY
	max_ammo = 7
	ammo_type = /obj/item/ammo_casing/pistol/heavy

/obj/item/ammo_magazine/pistol/speedloader/heavy
	name = "speedloader (12mm)"
	icon_state = "a454"
	insert_sound = /singleton/sound_category/revolver_reload
	ammo_type = /obj/item/ammo_casing/pistol/heavy
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 7
	multiple_sprites = 1

//.357 Magnum
/obj/item/ammo_casing/pistol/revolver
	name = "\improper .357 Magnum bullet casing"
	desc = "A .357 Magnum bullet casing."
	caliber = CALIBER_PISTOL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/pistol/revolver

/obj/item/ammo_magazine/pistol/speedloader/revolver
	name = "speed loader (.357)"
	icon_state = "T38"
	caliber = CALIBER_PISTOL_MAGNUM
	insert_sound = /singleton/sound_category/revolver_reload
	ammo_type = /obj/item/ammo_casing/pistol/revolver
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 8
	multiple_sprites = 1

//.38 Special
/obj/item/ammo_casing/pistol/revolver/special
	name = "\improper .38 Special bullet casing"
	desc = "A .38 Special bullet casing."
	caliber = CALIBER_PISTOL_SPECIAL
	projectile_type = /obj/item/projectile/bullet/pistol/revolver/pocket

/obj/item/ammo_magazine/pistol/speedloader/special
	name = "speed loader (.38 Special)"
	icon_state = "38"
	caliber = CALIBER_PISTOL_SPECIAL
	insert_sound = /singleton/sound_category/revolver_reload
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/pistol/revolver/special
	max_ammo = 6
	multiple_sprites = 1
