/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_door = "mixed"

/obj/structure/closet/athletic_mixed/fill()
	new /obj/item/towel/random(src)
	new /obj/item/towel/random(src)
	new /obj/item/clothing/under/shorts/athletic/grey(src)
	new /obj/item/clothing/under/shorts/athletic/black(src)
	new /obj/item/clothing/under/shorts/athletic/red(src)
	new /obj/item/clothing/under/shorts/athletic/blue(src)
	new /obj/item/clothing/under/shorts/athletic/green(src)
	new /obj/item/clothing/under/swimsuit/red(src)
	new /obj/item/clothing/under/swimsuit/black(src)
	new /obj/item/clothing/under/swimsuit/blue(src)
	new /obj/item/clothing/under/swimsuit/green(src)
	new /obj/item/clothing/under/swimsuit/purple(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/shoes/swimmingfins(src)
	new /obj/item/clothing/shoes/swimmingfins(src)

/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "It's a storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/fill()
	new /obj/item/clothing/gloves/boxing/blue(src)
	new /obj/item/clothing/gloves/boxing/green(src)
	new /obj/item/clothing/gloves/boxing/yellow(src)
	new /obj/item/clothing/gloves/boxing(src)

/obj/structure/closet/masks
	name = "mask closet"
	desc = "IT'S A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/fill()
	new /obj/item/clothing/mask/luchador(src)
	new /obj/item/clothing/mask/luchador/rudos(src)
	new /obj/item/clothing/mask/luchador/tecnicos(src)
