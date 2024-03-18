// Revolvos //
/obj/item/ammo_magazine/a357
	name = "speed loader (.357)"
	icon_state = "T38"
	caliber = "357"
	insert_sound = /singleton/sound_category/revolver_reload
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 8
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a454
	name = "speed loader (.454)"
	icon_state = "a454"
	caliber = "454"
	insert_sound = /singleton/sound_category/revolver_reload
	ammo_type = /obj/item/ammo_casing/a454
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c38
	name = "speed loader (.38)"
	icon_state = "38"
	caliber = "38"
	insert_sound = /singleton/sound_category/revolver_reload
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c38/rubber
	name = "speed loader (.38 rubber)"
	ammo_type = /obj/item/ammo_casing/c38/rubber

/obj/item/ammo_magazine/c38/emp
	name = "speed loader (.38 haywire)"
	ammo_type = /obj/item/ammo_casing/c38/emp
	matter = list(DEFAULT_WALL_MATERIAL = 360, MATERIAL_URANIUM = 600)

/obj/item/ammo_magazine/c45/revolver
	name = "speed loader (.45)"
	icon_state = "a454"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45/revolver
	max_ammo = 6
	multiple_sprites = TRUE

// End of Revolvos //

// Pistols and handguns //
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
	icon_state = "45x"
	origin_tech = list(TECH_COMBAT = 3)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 16
	multiple_sprites = 1

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

/obj/item/ammo_magazine/c45m
	name = "magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m/stendo
	name = "extended magazine (.45)"
	desc = "A custom .45 pistol magazine fitted with an extended baseplate, increasing capacity to eleven rounds."
	icon_state = "45e"
	max_ammo = 11

/obj/item/ammo_magazine/c45m/lebman
	name = "extended magazine (.45)"
	desc = "A custom .45 pistol magazine made by welding two together. Has double the capacity of a normal magazine at eighteen rounds."
	icon_state = "45l"
	max_ammo = 18

/obj/item/ammo_magazine/c45m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c45m/rubber
	name = "magazine (.45 rubber)"
	icon_state = "r45"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/c45m/practice
	name = "magazine (.45 practice)"
	icon_state = "45_practice"
	ammo_type = /obj/item/ammo_casing/c45/practice

/obj/item/ammo_magazine/c45m/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/c45/flash

/obj/item/ammo_magazine/c45m/auto
	name = "extended magazine (.45)"
	icon_state = "45a"
	desc = "A NanoTrasen-produced extended magazine for their Mk58 line of pistols. \
	The overall construction has been strengthened to withstand the rigors of fully-automatic fire."
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m/dominia
	name = "dominian service pistol magazine (.45)"
	desc = "A magazine specifically designed for a Dominian service pistol."
	icon = 'icons/obj/guns/dominia_pistol.dmi'
	icon_state = "dom_pistol_mag"
	max_ammo = 11

/obj/item/ammo_magazine/c46m
	name = "magazine (4.6mm)"
	icon_state = "4.6x30p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "4.6mm"
	desc = "A magazine designed for the dNAC-4.6 pistol."
	ammo_type = /obj/item/ammo_casing/c46mm
	max_ammo = 15
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c46m/extended
	name = "extended magazine (4.6mm)"
	icon_state = "4.6x30p_extended"
	desc = "A magazine designed for the dNAC-4.6 II submachine gun, but can also be used in the dNAC-4.6 pistol."
	max_ammo = 30

/obj/item/ammo_magazine/super_heavy
	name = ".599 magazine"
	desc = "A bulky magazine for the Kumar Arms 2557."
	icon_state = "k2557"
	caliber = ".599 Kumar Super"
	ammo_type = /obj/item/ammo_casing/kumar_super
	mag_type = MAGAZINE
	max_ammo = 5
	multiple_sprites = 1
	insert_sound = 'sound/weapons/k2557-insert.ogg'

/obj/item/ammo_magazine/mc10mm
	name = "magazine (10mm)"
	desc = "A detachable magazine for a modified NanoTrasen Mk1, made from stamped sheet metal."
	icon_state = "12mm"
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
	insert_sound = 'sound/weapons/clip_insert.ogg'

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm/flash
	name = "magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/c9mm/flash

// End of pistols //

// Submachine guns and PDWs
/obj/item/ammo_magazine/c9mm
	name = "ammunition box (9mm)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	caliber = "9mm"
	insert_sound = /singleton/sound_category/polymer_slide_reload
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
	insert_sound = /singleton/sound_category/polymer_slide_reload
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
	insert_sound = /singleton/sound_category/polymer_slide_reload
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = ".45"
	max_ammo = 16
	insert_sound = /singleton/sound_category/polymer_slide_reload
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
	insert_sound = /singleton/sound_category/polymer_slide_reload
	max_ammo = 20

/obj/item/ammo_magazine/submachinemag/empty
	initial_ammo = 0

/obj/item/ammo_magazine/submachinemag/assassin
	name = "magazine (6mm)"
	icon_state = "tommy-mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c6mm
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	caliber = "6mm"
	insert_sound = /singleton/sound_category/polymer_slide_reload
	max_ammo = 30

/obj/item/ammo_magazine/submachinedrum
	name = "drum magazine (.45)"
	icon_state = "tommy-drum"
	w_class = ITEMSIZE_NORMAL // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	caliber = ".45"
	insert_sound = /singleton/sound_category/polymer_slide_reload
	max_ammo = 50

/obj/item/ammo_magazine/smg10mm
	name = "smg magazine (10mm)"
	desc = "A detachable magazine for the improvised konyanger pirate SMG, made from scrap metal."
	icon_state = "10mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/smg10mm
	caliber = "10mm"
	max_ammo = 20
	multiple_sprites = 1

// End of SMGs and PDWs //

// Rifles and bigger calibers //
/obj/item/ammo_magazine/a556
	name = "magazine (5.56mm)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a556"
	insert_sound = /singleton/sound_category/rifle_slide_reload
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 30
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

/obj/item/ammo_magazine/a556/polymer
	name = "magazine (5.56mm lethal polymer)"
	icon_state = "5.56AP"
	ammo_type = /obj/item/ammo_casing/a556/polymer

/obj/item/ammo_magazine/a556/k556
	name = "konyang rifle magazine"
	icon_state = "k556rifle_mag"

/obj/item/ammo_magazine/a556/carbine
	name = "carbine magazine (5.56mm)"
	icon_state = "5.56c"
	desc = "A 5.56 ammo magazine fit for a carbine, not an assault rifle."
	matter = list(DEFAULT_WALL_MATERIAL = 1250)
	max_ammo = 15

/obj/item/ammo_magazine/a556/carbine/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556/carbine/practice
	name = "carbine magazine (5.56mm practice)"
	icon_state = "5.56c_practice"
	ammo_type = /obj/item/ammo_casing/a556/practice

/obj/item/ammo_magazine/a556/carbine/ap
	name = "carbine magazine (5.56mm AP)"
	icon_state = "5.56APc"
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = /obj/item/ammo_casing/a556/ap

/obj/item/ammo_magazine/a556/carbine/polymer
	name = "carbine magazine (5.56mm lethal polymer)"
	icon_state = "5.56APc"
	ammo_type = /obj/item/ammo_casing/a556/polymer

/obj/item/ammo_magazine/a556/carbine/blank
	name = "carbine magazine (5.56mm blank)"
	icon_state = "5.56c_practice"
	ammo_type = /obj/item/ammo_casing/a556/blank

/obj/item/ammo_magazine/a556/carbine/konyang47
	name = "konyang carbine magazine"
	icon_state = "k47_mag"

/obj/item/ammo_magazine/a556/makeshift
	name = "makeshift magazine (5.56mm)"
	icon_state = "5.56m"
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	max_ammo = 7

/obj/item/ammo_magazine/a556/makeshift/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556/dlmg
	name = "MPR-24/5 light machine gun magazine (5.56mm)"
	max_ammo = 50
	icon = 'icons/obj/guns/dominia_lmg.dmi'
	icon_state = "dom_lmg_mag"

/obj/item/ammo_magazine/a65
	name = "magazine (6.5mm)"
	icon_state = "c6.5mm"
	origin_tech = list(TECH_COMBAT = 3)
	mag_type = MAGAZINE
	caliber = "a65"
	insert_sound = /singleton/sound_category/rifle_slide_reload
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a65
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a65/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a75
	name = "ammo magazine (20mm)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = "75"
	insert_sound = /singleton/sound_category/rifle_slide_reload
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
	insert_sound = 'sound/weapons/reloads/rifle_slide3.ogg'
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
	insert_sound = /singleton/sound_category/rifle_slide_reload
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
	insert_sound = /singleton/sound_category/rifle_slide_reload
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/c762/sol
	icon_state = "battlerifle_mag"
	multiple_sprites = 0

/obj/item/ammo_magazine/c762/dpra
	icon_state = "mrrazhak_mag"

/obj/item/ammo_magazine/c762/dominia
	name = "mpr-24/5 carbine magazine (7.62mm)"
	icon = 'icons/obj/guns/dominia_carbine.dmi'
	icon_state = "dom_carbine_mag"

/obj/item/ammo_magazine/boltaction
	name = "ammo clip (7.62mm)"
	icon_state = "762"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	max_ammo = 5
	multiple_sprites = 1
	insert_sound = 'sound/weapons/clip_insert.ogg'

/obj/item/ammo_magazine/boltaction/blank
	ammo_type = /obj/item/ammo_casing/a762/blank

/obj/item/ammo_magazine/boltaction/vintage
	name = "vintage stripper clip"
	ammo_type = /obj/item/ammo_casing/vintage
	caliber = "vintage"

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

// Shotguns and special //
/obj/item/ammo_magazine/flechette
	name = "flechette rounds"
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette"
	mag_type = MAGAZINE
	caliber = "flechette"
	insert_sound = /singleton/sound_category/rifle_slide_reload
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
	insert_sound = /singleton/sound_category/rifle_slide_reload
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

/obj/item/ammo_magazine/xanan_shotgun
	name = "magazine"
	desc = "A magazine for the dNAC-12 combat shotgun."
	icon = 'icons/obj/guns/xanu_shotgun_mags.dmi'
	icon_state = "xanu_shell_magazine"
	caliber = "shotgun"
	insert_sound = /singleton/sound_category/rifle_slide_reload
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 8
	matter = list(MATERIAL_STEEL = 2880)
	multiple_sprites = 1

/obj/item/ammo_magazine/xanan_shotgun/shells
	name = "magazine (buckshot)"
	icon_state = "xanu_shell_magazine_buckshot"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/ammo_magazine/xanan_shotgun/incendiary
	name = "magazine (incendiary)"
	icon_state = "xanu_shell_magazine_incendiary"
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary

/obj/item/ammo_magazine/xanan_shotgun/beanbag
	name = "magazine (beanbag)"
	icon_state = "xanu_shell_magazine_beanbag"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_magazine/xanan_shotgun/slugs
	name = "magazine (slugs)"
	icon_state = "xanu_shell_magazine_slug"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_magazine/xanan_shotgun/emp
	name = "magazine (haywire slugs)"
	icon_state = "xanu_shell_magazine_emp"
	ammo_type = /obj/item/ammo_casing/shotgun/emp

/obj/item/ammo_magazine/xanan_shotgun/stun
	name = "magazine (stun)"
	icon_state = "xanu_shell_magazine_stun"
	ammo_type = /obj/item/ammo_casing/shotgun/emp

/obj/item/ammo_magazine/xanan_shotgun/tracker
	name = "magazine (tracking slug)"
	icon_state = "xanu_shell_magazine_tracker"
	ammo_type = /obj/item/ammo_casing/shotgun/tracking

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
	insert_sound = 'sound/weapons/railgun_insert.ogg'


/obj/item/ammo_magazine/gauss/emp
	name = "ion slug box"
	icon_state = "empslugbox"
	ammo_type = /obj/item/ammo_casing/gauss/emp
	insert_sound = 'sound/weapons/railgun_insert_emp.ogg'

/obj/item/ammo_magazine/plasma
	name = "heavy duty plasma cell"
	icon_state = "heavy_plasma_cell"
	mag_type = MAGAZINE
	caliber = "plasma slug"
	insert_sound = 'sound/weapons/railgun_insert_emp.ogg'
	ammo_type = /obj/item/ammo_casing/plasma_slug
	max_ammo = 10

/obj/item/ammo_magazine/plasma/light
	name = "small plasma cell"
	icon_state = "light_plasma_cell"
	caliber = "plasma bolt"
	ammo_type = /obj/item/ammo_casing/plasma_bolt
	max_ammo = 30

/obj/item/ammo_magazine/plasma/light/pistol
	name = "tiny plasma cell"
	ammo_type = /obj/item/ammo_casing/plasma_bolt
	max_ammo = 15

/obj/item/ammo_magazine/nuke
	name = "nuclear launcher cartridge"
	icon_state = "nukemag"
	w_class = ITEMSIZE_NORMAL
	mag_type = MAGAZINE
	caliber = "nuke"
	insert_sound = 'sound/weapons/reloads/rifle_slide3.ogg'
	ammo_type = /obj/item/ammo_casing/nuke
	max_ammo = 2
	multiple_sprites = 1

/obj/item/ammo_magazine/caps
	name = "speed loader (caps)"
	icon_state = "T38"
	caliber = "caps"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/konyang_shotgun
	name = "konyang shotgun magazine"
	icon_state = "konyang_shotgun"
	caliber = "shotgun"
	insert_sound = /singleton/sound_category/rifle_slide_reload
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/spitterpistol
	name = "spitter pistol magazine"
	icon_state = "spitterpistol_mag"
	caliber = "11.6mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/moghes_pistol
	max_ammo = 8

/obj/item/ammo_magazine/hookmg
	name = "hook machinegun magazine"
	icon_state = "hookmg_ammobox"
	caliber = "5.8mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/moghes_rifle
	max_ammo = 50

/obj/item/ammo_magazine/crackrifle
	name = "crack rifle magazine"
	icon_state = "crackrifle_mag"
	caliber = "5.8mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/moghes_rifle
	max_ammo = 33

/obj/item/ammo_magazine/tempestsmg
	name = "tempest smg magazine"
	icon_state = "tempestsmg_mag"
	caliber = "11.6mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/moghes_pistol
	max_ammo = 20
