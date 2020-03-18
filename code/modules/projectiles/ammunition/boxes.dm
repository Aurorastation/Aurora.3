/obj/item/ammo_magazine/a357
	name = "speed loader (.357)"
	icon_state = "T38"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/a454
	name = "speed loader (.454)"
	icon_state = "a454"
	caliber = "454"
	ammo_type = /obj/item/ammo_casing/a454
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/c38
	name = "speed loader (.38)"
	icon_state = "38"
	caliber = "38"
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c38/rubber
	name = "speed loader (.38 rubber)"
	ammo_type = /obj/item/ammo_casing/c38/rubber

/obj/item/ammo_magazine/c38/emp
	name = "speed loader (.38 haywire)"
	ammo_type = /obj/item/ammo_casing/c38/emp
	matter = list(DEFAULT_WALL_MATERIAL = 360, MATERIAL_URANIUM = 600)

/obj/item/ammo_magazine/c45
	name = "ammunition Box (.45)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = ".45"
	matter = list(DEFAULT_WALL_MATERIAL = 2250)
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_magazine/c45x
	name = "magazine (.45)"
	icon_state = "45x-16"
	origin_tech = list(TECH_COMBAT = 3)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m
	name = "magazine (.45)"
	icon_state = "45-10"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c45m/rubber
	name = "magazine (.45 rubber)"
	icon_state = "r45"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/c45m/practice
	name = "magazine (.45 practice)"
	ammo_type = /obj/item/ammo_casing/c45/practice

/obj/item/ammo_magazine/c45m/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/c45/flash

/obj/item/ammo_magazine/mc10mm
	name = "magazine (10mm)"
	icon_state = "5.56"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c10mm
	matter = list(DEFAULT_WALL_MATERIAL = 475) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = "10mm"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/ammo_magazine/mc10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc10mm/rubber
	name = "magazine (10mm rubber)"
	ammo_type = /obj/item/ammo_casing/c10mm/rubber

/obj/item/ammo_magazine/mc10mm/leyon
	name = "ammo clip (10mm)"
	icon_state = "10mmclip"
	mag_type = SPEEDLOADER
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm/flash
	ammo_type = /obj/item/ammo_casing/c9mm/flash

/obj/item/ammo_magazine/c9mm
	name = "ammunition box (9mm)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_magazine/c9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = "9mm"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mmt/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_magazine/mc9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/c9mm/practice

/obj/item/ammo_magazine/c45
	name = "ammunition box (.45)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = ".45"
	matter = list(DEFAULT_WALL_MATERIAL = 2250)
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_magazine/c9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a10mm
	name = "magazine (10mm)"
	icon_state = "12mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556
	name = "magazine (5.56mm)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a556"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/a556/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556/practice
	name = "magazine (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556/practice

/obj/item/ammo_magazine/a556/ap
	name = "magazine (5.56mm AP)"
	icon_state = "5.56AP"
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = /obj/item/ammo_casing/a556/ap

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".50"
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a50/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a75
	name = "ammo magazine (20mm)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = "75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0

/obj/item/ammo_magazine/trodpack
	name = "tungsten rod pack"
	icon_state = "trodpack-2"
	mag_type = MAGAZINE
	caliber = "trod"
	ammo_type = /obj/item/ammo_casing/trod
	multiple_sprites = 1
	max_ammo = 2

/obj/item/ammo_magazine/trodpack/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a762
	name = "magazine box (7.62mm)"
	icon_state = "a762"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/a762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c762
	name = "magazine (7.62mm)"
	icon_state = "c762"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/c762/sol
	icon_state = "battlerifle_mag"
	multiple_sprites = 0

/obj/item/ammo_magazine/boltaction
	name = "ammo clip (7.62mm)"
	icon_state = "762"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/boltaction/vintage
	name = "vintage stripper clip"
	ammo_type = /obj/item/ammo_casing/vintage
	caliber = "vintage"

/obj/item/ammo_magazine/c45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = ".45"
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/c45uzi/empty
	initial_ammo = 0

/obj/item/ammo_magazine/submachinemag
	name = "magazine (.45)"
	icon_state = "tommy-mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	caliber = ".45"
	max_ammo = 20

/obj/item/ammo_magazine/submachinemag/empty
	initial_ammo = 0

/obj/item/ammo_magazine/submachinedrum
	name = "drum magazine (.45)"
	icon_state = "tommy-drum"
	w_class = 3 // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	caliber = ".45"
	max_ammo = 50

/obj/item/ammo_magazine/caps
	name = "speed loader (caps)"
	icon_state = "T38"
	caliber = "caps"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	max_ammo = 7
	multiple_sprites = 1

//dragunov magazine

/obj/item/ammo_magazine/d762
	name = "magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/d762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/flechette
	name = "flechette rounds"
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette"
	mag_type = MAGAZINE
	caliber = "flechette"
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	ammo_type = /obj/item/ammo_casing/flechette
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/flechette/empty
	initial_ammo = 0

/obj/item/ammo_magazine/flechette/explosive
	name = "explosive flechette rounds"
	desc = "A box of ten explosive flechettes that can be remotely detonated by a certain signal."
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette_e"
	mag_type = MAGAZINE
	caliber = "flechette"
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	ammo_type = /obj/item/ammo_casing/flechette/explosive
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/flechette/explosive/empty
	initial_ammo = 0

/obj/item/ammo_magazine/assault_shotgun
	name = "magazine (slug)"
	icon_state = "csmb"
	caliber = "shotgun"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 8
	matter = list(MATERIAL_STEEL = 2880)
	multiple_sprites = 1

/obj/item/ammo_magazine/assault_shotgun/shells
	name = "magazine (shells)"
	icon_state = "csm"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/ammo_magazine/assault_shotgun/incendiary
	name = "magazine (incendiary shells)"
	icon_state = "csmi"
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary
	matter = list(DEFAULT_WALL_MATERIAL = 3600)

/obj/item/ammo_magazine/assault_shotgun/stun
	name = "magazine (stun shells)"
	icon_state = "csms"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	matter = list(DEFAULT_WALL_MATERIAL = 2880, MATERIAL_GLASS = 5760)

/obj/item/ammo_magazine/minigun
	name = "minigun magazine box (7.62mm)"
	icon_state = "a762"
	mag_type = MAGAZINE
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 1000

/obj/item/ammo_magazine/gauss
	name = "tungsten slug box"
	icon_state = "slugbox"
	mag_type = MAGAZINE
	caliber = "gauss"
	ammo_type = /obj/item/ammo_casing/gauss
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/gauss/emp
	name = "ion slug box"
	icon_state = "empslugbox"
	ammo_type = /obj/item/ammo_casing/gauss/emp


/obj/item/ammo_magazine/plasma
	name = "heavy duty plasma cell"
	icon_state = "heavy_plasma_cell"
	mag_type = MAGAZINE
	caliber = "plasma slug"
	ammo_type = /obj/item/ammo_casing/plasma_slug
	max_ammo = 10

/obj/item/ammo_magazine/plasma/light
	name = "small plasma cell"
	icon_state = "light_plasma_cell"
	caliber = "plasma bolt"
	ammo_type = /obj/item/ammo_casing/plasma_bolt
	max_ammo = 30

/obj/item/ammo_magazine/nuke
	name = "nuclear launcher cartridge"
	icon_state = "nukemag"
	w_class = 3
	mag_type = MAGAZINE
	caliber = "nuke"
	ammo_type = /obj/item/ammo_casing/nuke
	max_ammo = 2
	multiple_sprites = 1
