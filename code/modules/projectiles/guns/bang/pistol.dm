/obj/item/weapon/gun/bang/colt
	name = "vintage .45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	icon_state = "colt"
	pixel_offset_x = 30
	pixel_offset_y = 18

/obj/item/weapon/gun/bang/sec
	name = ".45 pistol"
	desc = "A NanoTrasen designed sidearm, found pretty much everywhere humans are. Uses .45 rounds."
	icon_state = "secguncomp"
	pixel_offset_x = 28
	pixel_offset_y = 14

/obj/item/weapon/gun/bang/sec/flash
	name = ".45 signal pistol"

/obj/item/weapon/gun/bang/sec/wood
	desc = "A Nanotrasen designed sidearm, this one has a sweet wooden grip. Uses .45 rounds."
	name = "custom .45 Pistol"
	icon_state = "secgundark"

/obj/item/weapon/gun/bang/x9
	name = "automatic .45 pistol"
	desc = "The x9 tactical pistol is a lightweight fast firing handgun. Uses .45 rounds."
	icon_state = "x9tactical"
	pixel_offset_x = 28
	pixel_offset_y = 13

/obj/item/weapon/gun/bang/tanto
	desc = "A Necropolis Industries Tanto .40, designed to compete with the NT Mk58. Uses 10mm rounds."
	name = "10mm pistol"
	icon_state = "c05r"
	pixel_offset_x = 31
	pixel_offset_y = 14

/obj/item/weapon/gun/bang/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	pixel_offset_x = -4
	pixel_offset_y = 15

obj/item/weapon/gun/bang/deagle
	name = ".50 magnum pistol"
	desc = "A robust handgun that uses .50 AE ammo."
	icon_state = "deagle"
	pixel_offset_x = -4
	pixel_offset_y = 16

/obj/item/weapon/gun/bang/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/bang/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"

/obj/item/weapon/gun/bang/pistol
	name = "9mm pistol"
	desc = "500 years since its creation and the Stechkin automatic pistol is still a common sight throughout the Frontier."
	icon_state = "pistol"
	item_state = null
	pixel_offset_x = 26
	pixel_offset_y = 14

/obj/item/weapon/gun/bang/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "zipgun"
	item_state = "sawnshotgun"
	pixel_offset_x = 0
	pixel_offset_y = 12

/obj/item/weapon/storage/box/duelingkit/
	icon = 'icons/obj/weapons.dmi'
	icon_state = "gunbox"
	name = "Dueling Kit"
	desc = "Everything you need to duel, except a weapon."

/obj/item/weapon/storage/box/duelingkit/fill()
	new /obj/item/clothing/gloves/dueling(src)
	new /obj/item/weapon/book/manual/codeduello(src)

/obj/item/weapon/storage/box/duelingkit/colt
	name = "Deluxe Vintage Dueling Kit"
	desc = "Everything you need to duel, including an vintage pistol."

/obj/item/weapon/storage/box/duelingkit/colt/fill()
	..()
	new /obj/item/weapon/gun/bang/colt(src)

/obj/item/weapon/storage/box/duelingkit/sec
	..()
	name = "Deluxe Nanotrasen Dueling Kit"
	desc = "Everything you need to duel, including an Nanotrasen-branded pistol."

/obj/item/weapon/storage/box/duelingkit/sec/fill()
	..()
	new /obj/item/weapon/gun/bang/sec(src)

/obj/item/weapon/storage/box/duelingkit/x9
	..()
	name = "Deluxe x9 Dueling Kit"
	desc = "Everything you need to duel, including an automatic x9 pistol."

/obj/item/weapon/storage/box/duelingkit/x9/fill()
	..()
	new /obj/item/weapon/gun/bang/x9(src)

/obj/item/weapon/storage/box/duelingkit/deagle
	..()
	name = "Deluxe Deagle Dueling Kit"
	desc = "Everything you need to duel, including deagle."

/obj/item/weapon/storage/box/duelingkit/deagle/fill()
	..()
	new /obj/item/weapon/gun/bang/deagle(src)

/obj/item/weapon/storage/box/duelingkit/pirate
	..()
	name = "Deluxe Pirate Dueling Kit"
	desc = "Everything you need to duel, including a pirate style zip gun."

/obj/item/weapon/storage/box/duelingkit/pirate/fill()
	..()
	new /obj/item/weapon/gun/bang/pirate(src)

/obj/item/weapon/storage/box/duelingkit/leyon
	..()
	name = "Deluxe Leyon Dueling Kit"
	desc = "Everything you need to duel, including a compact leyon pistol."

/obj/item/weapon/storage/box/duelingkit/leyon/fill()
	..()
	new /obj/item/weapon/gun/projectile/leyon(src)