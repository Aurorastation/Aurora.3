/obj/item/shoe_cover
	name = "strange fabric"
	desc = "A fabirc that allows for silent walking."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-cloth"

/obj/item/shoe_cover/afterattack(var/obj/A as obj, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/item/clothing/shoes) && get_dist(src,A) <= 1)
		var/obj/item/clothing/shoes/S = A
		user << "You attahed the [src] to [S] making movement silent"
		S.silent = 1
		S.desc += " They appear to have some type of fabric soles"
		user.drop_from_inventory(src,A)
		qdel(src)
