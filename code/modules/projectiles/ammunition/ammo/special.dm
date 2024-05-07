/obj/item/ammo_casing/musket
	name = "musket ball"
	desc = "A solid ball made of lead."
	icon_state = "musketball"
	caliber = CALIBER_MUSKET
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
