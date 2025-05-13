ABSTRACT_TYPE(/singleton/autolathe_recipe/ammunition)
	name = "Abstract Ammunition"
	category = "Ammunition"

/singleton/autolathe_recipe/ammunition/New()
	..()

	if(ispath(path, /obj/item/ammo_pile))
		var/obj/item/ammo_pile/pile = path
		var/ammo_type = initial(pile.ammo_type)

		var/obj/item/ammo_casing/ammo = new ammo_type
		var/list/ammo_matter = ammo.matter.Copy()

		resources = ammo_matter
		for(var/material in resources)
			resources[material] = resources[material] * ammo.max_stack

		qdel(ammo)

/singleton/autolathe_recipe/ammunition/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/syringe_cartridge

/singleton/autolathe_recipe/ammunition/shotgun
	name = "shells (blank, shotgun)"
	path = /obj/item/ammo_pile/shotgun_blanks

/singleton/autolathe_recipe/ammunition/shotgun/beanbag
	name = "shells (beanbag, shotgun)"
	path = /obj/item/ammo_pile/shotgun_beanbag

/singleton/autolathe_recipe/ammunition/shotgun/flash
	name = "shells (flash, shotgun)"
	path = /obj/item/ammo_pile/shotgun_flash

/singleton/autolathe_recipe/ammunition/shotgun/stun
	name = "shells (stun cartridge, shotgun)"
	path = /obj/item/ammo_pile/shotgun_stunshell

/singleton/autolathe_recipe/ammunition/shotgun/slug
	name = "shells (slug, shotgun)"
	path = /obj/item/ammo_pile/slug
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/shotgun/pellet
	name = "shells (buckshot, shotgun)"
	path = /obj/item/ammo_pile/shotgun_pellet
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_revolver_1
	name = "speed loader (.357)"
	path = /obj/item/ammo_magazine/a357
	hack_only = TRUE

/singleton/autolathe_recipe/ammunition/detective_revolver_lethal
	name = "speed loader (.38)"
	path = /obj/item/ammo_magazine/c38
	hack_only = TRUE

/singleton/autolathe_recipe/ammunition/detective_revolver_rubber
	name = "speed loader (.38, rubber)"
	path = /obj/item/ammo_magazine/c38/rubber
	hack_only = TRUE

/singleton/autolathe_recipe/ammunition/magazine_fourty_five
	name = "magazine (.45, pistol)"
	path = /obj/item/ammo_magazine/c45m
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_rubber
	name = "magazine (.45, rubber, pistol)"
	path = /obj/item/ammo_magazine/c45m/rubber

/singleton/autolathe_recipe/ammunition/magazine_flash
	name = "magazine (.45, flash, pistol)"
	path = /obj/item/ammo_magazine/c45m/flash

/singleton/autolathe_recipe/ammunition/magazine_fourty_five/extended
	name = "magazine (.45, extended, pistol)"
	path = /obj/item/ammo_magazine/c45m/stendo
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_fourty_five/extended/rubber
	name = "magazine (.45, extended rubber, pistol)"
	path = /obj/item/ammo_magazine/c45m/stendo/rubber
	security_level = SEC_LEVEL_GREEN

/singleton/autolathe_recipe/ammunition/submachine_mag
	name = "magazine (.45, submachine gun)"
	path = /obj/item/ammo_magazine/submachinemag
	hack_only = TRUE

/singleton/autolathe_recipe/ammunition/uzi_mag
	name = "magazine (.45, machine pistol)"
	path = /obj/item/ammo_magazine/c45uzi
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_xanu_pistol
	name = "magazine (4.6mm)"
	path = /obj/item/ammo_magazine/c46m
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_xanu_smg
	name = "magazine (4.6mm, extended)"
	path = /obj/item/ammo_magazine/c46m/extended
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_stetchkin
	name = "magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mm
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_stetchkin_flash
	name = "magazine (9mm, flash)"
	path = /obj/item/ammo_magazine/mc9mm/flash

/singleton/autolathe_recipe/ammunition/magazine_smg
	name = "magazine (9mm, top mounted, machine pistol)"
	path = /obj/item/ammo_magazine/mc9mmt
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_smg_rubber
	name = "magazine (9mm rubber, top mounted, machine pistol)"
	path = /obj/item/ammo_magazine/mc9mmt/rubber

/singleton/autolathe_recipe/ammunition/magazine_c20r
	name = "magazine (10mm)"
	path = /obj/item/ammo_magazine/a10mm
	hack_only = TRUE

/singleton/autolathe_recipe/ammunition/magazine_carbine
	name = "magazine (5.56mm, rifle)"
	path = /obj/item/ammo_magazine/a556
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_carbinepolymer
	name = "magazine (5.56mm polymer, rifle)"
	path = /obj/item/ammo_magazine/a556/polymer
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_smallcarbine
	name = "magazine (5.56mm, carbine)"
	path = /obj/item/ammo_magazine/a556/carbine
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_smallcarbinepolymer
	name = "magazine (5.56mm polymer, carbine)"
	path = /obj/item/ammo_magazine/a556/carbine/polymer
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_xanu_rifle
	name = "magazine (6.5mm, rifle)"
	path = /obj/item/ammo_magazine/a65
	security_level = SEC_LEVEL_RED

/singleton/autolathe_recipe/ammunition/magazine_arifle
	name = "magazine (7.62mm)"
	path = /obj/item/ammo_magazine/c762
	hack_only = TRUE

/singleton/autolathe_recipe/ammunition/clip_boltaction
	name = "clip (7.62mm)"
	path = /obj/item/ammo_magazine/boltaction
	hack_only = TRUE
