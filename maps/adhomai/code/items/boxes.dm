/obj/item/weapon/storage/box/double_tank
	autodrobe_no_remove = 1

/obj/item/weapon/storage/box/double_tank/fill()
	..()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/weapon/tank/emergency_oxygen/double(src)

