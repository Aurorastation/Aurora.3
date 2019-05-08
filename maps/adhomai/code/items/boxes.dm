/obj/item/weapon/storage/box/double_tank
	autodrobe_no_remove = 1

/obj/item/weapon/storage/box/double_tank/fill()
	..()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/weapon/tank/emergency_oxygen/double(src)

/obj/item/weapon/storage/box/clip_pouch
	name = "clip pouch"
	desc = "A small pouch for holding ammunition."
	icon = 'icons/adhomai/items/military_equipment.dmi'
	icon_state = "clipbag"
	w_class = 2
	foldable = null
	autodrobe_no_remove = 1
	can_hold = list(
		/obj/item/ammo_magazine/nka,
		/obj/item/ammo_magazine/boltaction/nka,
		/obj/item/ammo_magazine/c38/nka
		)

/obj/item/weapon/storage/box/clip_pouch/cartridge
	name = "cartridge pouch"
	desc = "A small pouch for holding ammunition. This one is designed for single cartridges."
	icon = 'icons/adhomai/items/military_equipment.dmi'
	icon_state = "clipbag"
	w_class = 2
	foldable = null
	autodrobe_no_remove = 1
	max_storage_space = 28
	can_hold = list(
		/obj/item/ammo_casing/a762/nka
		)

/obj/item/weapon/storage/bag/plants/produce/adhomai
	name = "produce bag"
	desc = "A large bag of random, leftover produce."
	max_storage_space = 20

/obj/item/weapon/storage/bag/plants/produce/adhomai/fill()
	for(var/i in 1 to 20)
		new /obj/random_produce_adhomai(src)
	make_exact_fit()


