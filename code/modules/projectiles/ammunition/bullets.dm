/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/pistol/revolver

/obj/item/ammo_casing/a454
	desc = "A .454 bullet casing."
	caliber = "454"
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/ammo_casing/a75
	desc = "A 20mm bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/c38/rubber
	desc = "A .38 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"

/obj/item/ammo_casing/c38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(DEFAULT_WALL_MATERIAL = 130, MATERIAL_URANIUM = 100)

/obj/item/ammo_casing/trod
	desc = "hyperdense tungsten rod residue."
	icon_state = "trod"
	caliber = "trod"
	projectile_type = /obj/item/projectile/bullet/trod

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/c9mm/flash
	desc = "A 9mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/c9mm/rubber
	desc = "A 9mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"

/obj/item/ammo_casing/c9mm/practice
	desc = "A 9mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/c10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/c10mm/rubber
	desc = "A 10mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/medium

/obj/item/ammo_casing/c45/practice
	desc = "A .45 practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/c45/rubber
	desc = "A .45 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"

/obj/item/ammo_casing/c45/flash
	desc = "A .45 flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/a12mm
	desc = "A 12mm bullet casing."
	caliber = "12mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list(MATERIAL_STEEL = 90)

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(DEFAULT_WALL_MATERIAL = 360, MATERIAL_GLASS = 720)

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	spent_icon = "fshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(DEFAULT_WALL_MATERIAL = 90, MATERIAL_GLASS = 90)

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary shell"
	desc = "A 12 gauge incendiary shell."
	icon_state = "ishell"
	spent_icon = "ishell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/incendiary
	matter = list(DEFAULT_WALL_MATERIAL = 450)

/obj/item/ammo_casing/shotgun/emp
	name = "haywire slug"
	desc = "A 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/ion
	matter = list(DEFAULT_WALL_MATERIAL = 260, MATERIAL_URANIUM = 200)

/obj/item/ammo_casing/tranq
	name = "PPS shell"
	desc = "A .50 cal PPS bullet casing."
	icon_state = "ishell"
	spent_icon = "ishell-spent"
	caliber = "PPS"
	projectile_type = /obj/item/projectile/bullet/rifle/tranq

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/rifle/a762
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"

/obj/item/ammo_casing/a762/spent/Initialize()
	. = ..()
	expend()

/obj/item/ammo_casing/a145
	name = "shell casing"
	desc = "A 14.5mm shell."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/rifle/a556
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"

/obj/item/ammo_casing/a556/ap
	desc = "A 5.56mm armor piercing round."
	projectile_type = /obj/item/projectile/bullet/rifle/a556/ap

/obj/item/ammo_casing/a556/practice
	desc = "A 5.56mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a556/practice

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"

/obj/item/ammo_casing/chameleon
	name = "chameleon bullets"
	desc = "A set of bullets for the Chameleon Gun."
	projectile_type = /obj/item/projectile/bullet/chameleon
	caliber = ".45"

/*
/obj/item/ammo_casing/a418
	desc = "A .418 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/suffocationbullet

/obj/item/ammo_casing/a666
	desc = "A .666 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/cyanideround
*/

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap

/obj/item/ammo_casing/flechette
	desc = "A flechette casing."
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette_casing"
	caliber = "flechette"
	projectile_type = /obj/item/projectile/bullet/flechette

/obj/item/ammo_casing/flechette/explosive
	projectile_type = /obj/item/projectile/bullet/flechette/explosive

/obj/item/ammo_casing/vintage
	projectile_type = /obj/item/projectile/bullet/rifle/vintage
	desc = "Some vintage shell casing. It looks old, and you can't understand the writing stamped on it."
	caliber = "vintage"
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"

/obj/item/ammo_casing/gauss
	name = "tungsten slug"
	desc = "A heavy tungsten gauss slug."
	caliber = "gauss"
	icon_state = "tungstenslug"
	projectile_type = /obj/item/projectile/bullet/gauss

/obj/item/ammo_casing/gauss/emp
	name = "ion slug"
	desc = "A heavy ion gauss slug."
	icon_state = "empslug"
	projectile_type = /obj/item/projectile/ion/gauss

/obj/item/ammo_casing/plasma_slug
	name = "plasma slug"
	desc = "A plasma slug."
	icon_state = "plasmaslug"
	caliber = "plasma slug"
	projectile_type = /obj/item/projectile/plasma

/obj/item/ammo_casing/plasma_bolt
	name = "plasma bolt"
	desc = "A plasma bolt."
	icon_state = "plasmabolt"
	caliber = "plasma bolt"
	projectile_type = /obj/item/projectile/plasma/light

/obj/item/ammo_casing/cannon
	name = "cannonball"
	desc = "A solid metal projectile."
	icon_state = "cannonball"
	caliber = "cannon"
	projectile_type = /obj/item/projectile/bullet/cannonball
	matter = list(DEFAULT_WALL_MATERIAL = 800)
	w_class = 3

/obj/item/ammo_casing/cannon/explosive
	name = "explosive cannonball"
	desc = "A solid metal projectile loaded with an explosive charge."
	icon_state = "cannonball_explosive"
	projectile_type = /obj/item/projectile/bullet/cannonball/explosive

/obj/item/ammo_casing/cannon/canister
	name = "canister shot"
	desc = "A solid projectile filled with deadly shrapnel."
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun/canister

/obj/item/ammo_casing/nuke
	name = "miniaturized nuclear warhead"
	icon_state = "nuke"
	caliber = "nuke"
	desc = "A miniaturized version of a nuclear bomb."
	projectile_type = /obj/item/projectile/bullet/nuke
