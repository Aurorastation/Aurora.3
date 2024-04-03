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
	max_stack = 6

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
	max_stack = 15

/obj/item/ammo_casing/c9mm/flash
	desc = "A 9mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/c45/revolver
	desc = "A .45 revolver bullet casing."
	max_stack = 6
	projectile_type = /obj/item/projectile/bullet/pistol/revolver

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
	max_stack = 10

/obj/item/ammo_casing/c10mm/rubber
	desc = "A 10mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	max_stack = 10

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
	max_stack = 7

/obj/item/ammo_casing/smg10mm
	desc  = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/c46mm
	desc = "A 4.6mm bullet casing."
	caliber = "4.6mm"
	projectile_type = /obj/item/projectile/bullet/pistol
	max_stack = 15

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12-gauge slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	reload_sound = /singleton/sound_category/shotgun_reload
	drop_sound = /singleton/sound_category/casing_drop_sound_shotgun
	max_stack = 8

/obj/item/ammo_casing/shotgun/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12-gauge shell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/pellet/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A 12-gauge blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A 12-gauge practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list(MATERIAL_STEEL = 90)

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A 12-gauge beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12-gauge taser cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(DEFAULT_WALL_MATERIAL = 360, MATERIAL_GLASS = 720)
	reload_sound = 'sound/weapons/reload_shell_emp.ogg'

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	. = ..()

	if(prob(100/severity))
		BB = null

	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A 12-gauge chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	spent_icon = "fshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(DEFAULT_WALL_MATERIAL = 90, MATERIAL_GLASS = 90)
	reload_sound = 'sound/weapons/reload_shell_emp.ogg'

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary shell"
	desc = "A 12-gauge incendiary shell."
	icon_state = "ishell"
	spent_icon = "ishell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/incendiary
	matter = list(DEFAULT_WALL_MATERIAL = 450)

/obj/item/ammo_casing/shotgun/emp
	name = "haywire slug"
	desc = "A 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type = /obj/item/projectile/ion
	matter = list(DEFAULT_WALL_MATERIAL = 260, MATERIAL_URANIUM = 200)
	reload_sound = 'sound/weapons/reload_shell_emp.ogg'

/obj/item/ammo_casing/shotgun/tracking
	name = "tracking slug"
	desc = "A 12-gauge shotgun slug fitted with a tracking implant, set to activate upon embedding flesh."
	icon_state = "trackingshell"
	spent_icon = "trackingshell-spent"
	projectile_type = /obj/item/projectile/bullet/tracking

/obj/item/ammo_casing/shotgun/moghes
	name = "wall shell"
	desc = "The appropriately-named wall shell, made specifically for the Moghesian wall gun."
	desc_extended = "This complicated and expensive shotgun shell fires both a solid slug and a hail of shots at the same time, making it a destructive and dangerous ammunition at all ranges, assuming the user can point in the target's general direction. Somehow it seems to somewhat fit in other shotgun type weaponry too."
	icon_state = "moghes_shell"
	spent_icon = "moghes_shell_spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/moghes

/obj/item/ammo_casing/tranq
	name = "PPS shell"
	desc = "A .50 cal PPS bullet casing."
	icon_state = "ishell"
	spent_icon = "ishell-spent"
	caliber = "PPS"
	projectile_type = /obj/item/projectile/bullet/rifle/tranq
	max_stack = 6

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/rifle/a762
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	max_stack = 2

/obj/item/ammo_casing/a762/spent/Initialize()
	. = ..()
	expend()

/obj/item/ammo_casing/a762/blank
	desc = "A 7.62mm blank casing."
	projectile_type = /obj/item/projectile/bullet/blank

/obj/item/ammo_casing/a145
	name = "shell casing"
	desc = "A 14.5mm shell."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	max_stack = 2

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/rifle/a556
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	max_stack = 7

/obj/item/ammo_casing/a556/ap
	desc = "A 5.56mm armor piercing round."
	projectile_type = /obj/item/projectile/bullet/rifle/a556/ap

/obj/item/ammo_casing/a556/practice
	desc = "A 5.56mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a556/practice

/obj/item/ammo_casing/a556/polymer
	desc = "A 5.56mm polymer bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a556/polymer

/obj/item/ammo_casing/a556/blank
	desc = "A 5.56mm blank casing."
	projectile_type = /obj/item/projectile/bullet/blank

/obj/item/ammo_casing/a556/spent/Initialize()
	. = ..()
	expend()

/obj/item/ammo_casing/a65
	desc = "A 6.5mm bullet casing."
	desc_extended = "Designed by de Namur not long after the interstellar war, the 6.5mmx40mm cartridge, designed to fit the needs of Xanu's military while going away from the legacy rounds used by the Sol Alliance. This cartridge has been wildly successful, and has been adopted by the majority of the Coalition of Colonies and beyond."
	caliber = "a65"
	projectile_type = /obj/item/projectile/bullet/rifle/a65
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	max_stack = 7

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"
	max_stack = 1

/obj/item/ammo_casing/rocket/konyang
	icon_state = "kgm_rocket"

/obj/item/ammo_casing/chameleon
	name = "chameleon bullets"
	desc = "A set of bullets for the Chameleon Gun."
	projectile_type = /obj/item/projectile/bullet/chameleon
	caliber = ".45"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap
	max_stack = 6

/obj/item/ammo_casing/flechette
	desc = "A flechette casing."
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette_casing"
	caliber = "flechette"
	projectile_type = /obj/item/projectile/bullet/flechette
	max_stack = 4

/obj/item/ammo_casing/flechette/explosive
	projectile_type = /obj/item/projectile/bullet/flechette/explosive

/obj/item/ammo_casing/vintage
	projectile_type = /obj/item/projectile/bullet/rifle/vintage
	desc = "A .30-06 Government bullet casing. It looks old, and you can barely understand the writing stamped on it."
	caliber = "30-06 govt"
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	max_stack = 6

/obj/item/ammo_casing/vintage/spent/Initialize()
	. = ..()
	expend()

/obj/item/ammo_casing/govt
	projectile_type = /obj/item/projectile/bullet/rifle/govt
	desc = "A .45-70 Government bullet casing."
	caliber = "45-70 govt"
	icon_state = "gcasing"
	spent_icon = "gcasing-spent"
	max_stack = 4

/obj/item/ammo_casing/slugger
	projectile_type = /obj/item/projectile/bullet/rifle/slugger
	caliber = "slugger"
	icon_state = "slugger-sharp"
	spent_icon = "slugger-spent"
	max_stack = 2

/obj/item/ammo_casing/gauss
	name = "tungsten slug"
	desc = "A heavy tungsten gauss slug."
	caliber = "gauss"
	icon_state = "tungstenslug"
	spent_icon = "tungstenslug-spent"
	projectile_type = /obj/item/projectile/bullet/gauss
	max_stack = 2

/obj/item/ammo_casing/gauss/carbine
	name = "compact tungsten slug"
	desc = "A heavy tungsten gauss slug. This one has a casing adapated for carbine models."
	projectile_type = /obj/item/projectile/bullet/gauss/carbine

/obj/item/ammo_casing/gauss/emp
	name = "ion slug"
	desc = "A heavy ion gauss slug."
	icon_state = "empslug"
	projectile_type = /obj/item/projectile/ion/gauss
	reload_sound = 'sound/weapons/reload_shell_emp.ogg'

/obj/item/ammo_casing/plasma_slug
	name = "plasma slug"
	desc = "A plasma slug."
	icon_state = "plasmaslug"
	caliber = "plasma slug"
	projectile_type = /obj/item/projectile/plasma
	max_stack = 2

/obj/item/ammo_casing/plasma_bolt
	name = "plasma bolt"
	desc = "A plasma bolt."
	icon_state = "plasmabolt"
	caliber = "plasma bolt"
	projectile_type = /obj/item/projectile/plasma/light
	max_stack = 4

/obj/item/ammo_casing/cannon
	name = "cannonball"
	desc = "A solid metal projectile."
	icon_state = "cannonball"
	caliber = "cannon"
	projectile_type = /obj/item/projectile/bullet/cannonball
	matter = list(DEFAULT_WALL_MATERIAL = 800)
	w_class = ITEMSIZE_NORMAL
	slot_flags = null
	max_stack = 1
	reload_sound = 'sound/weapons/reloads/shotgun_pump.ogg'
	drop_sound = /singleton/sound_category/generic_drop_sound

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
	w_class = ITEMSIZE_NORMAL
	slot_flags = null
	desc = "A miniaturized version of a nuclear bomb."
	projectile_type = /obj/item/projectile/bullet/nuke
	drop_sound = /singleton/sound_category/generic_drop_sound
	max_stack = 2

/obj/item/ammo_casing/musket
	name = "musket ball"
	desc = "A solid ball made of lead."
	icon_state = "musketball"
	caliber = "musket"
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	reload_sound = 'sound/weapons/reloads/shotgun_pump.ogg'

/obj/item/ammo_casing/recoilless_rifle
	name = "anti-tank warhead"
	icon_state = "missile"
	caliber = "recoilless_rifle"
	w_class = ITEMSIZE_NORMAL
	slot_flags = null
	projectile_type = /obj/item/projectile/bullet/recoilless_rifle
	reload_sound = 'sound/weapons/reloads/shotgun_pump.ogg'
	max_stack = 1

/obj/item/ammo_casing/peac
	name = "anti-materiel AP cannon cartridge"
	icon_state = "peac"
	spent_icon = "peac-spent"
	caliber = "peac"
	w_class = ITEMSIZE_NORMAL
	slot_flags = null
	projectile_type = /obj/item/projectile/bullet/peac
	drop_sound = 'sound/items/drop/shell_drop.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'
	reload_sound = 'sound/weapons/railgun_insert_emp.ogg'
	max_stack = 1

/obj/item/ammo_casing/peac/he
	name = "anti-materiel HE cannon cartridge"
	projectile_type = /obj/item/projectile/bullet/peac/he

/obj/item/ammo_casing/peac/shrapnel
	name = "anti-materiel FRAG cannon cartridge"
	projectile_type = /obj/item/projectile/bullet/peac/shrapnel

/obj/item/ammo_casing/kumar_super
	name =".599 kumar super casing"
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	caliber = ".599 Kumar Super"
	projectile_type = /obj/item/projectile/bullet
	max_stack = 5

/obj/item/ammo_casing/c6mm
	desc = "A 6mm bullet casing."
	caliber = "6mm"
	projectile_type = /obj/item/projectile/bullet/pistol/assassin
	max_stack = 15

/obj/item/ammo_casing/moghes_pistol
	desc = "A Moghesian pistol casing."
	icon_state = "moghes_casing_p"
	spent_icon = "moghes_casing_p_spent"
	caliber = "11.6mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium/ap
	max_stack = 15

/obj/item/ammo_casing/moghes_rifle
	desc = "A Moghesian rifle casing."
	icon_state = "moghes_casing"
	spent_icon = "moghes_casing_spent"
	caliber = "5.8mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a556
	max_stack = 7
