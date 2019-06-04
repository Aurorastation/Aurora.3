/obj/item/shoe_cover
	name = "strange fabric"
	desc = "A fabric that allows for silent walking."
	icon = 'icons/obj/stacks.dmi'
	icon_state = "sheet-cloth"

/obj/item/shoe_cover/afterattack(var/obj/A as obj, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/item/clothing/shoes) && get_dist(src,A) <= 1)
		var/obj/item/clothing/shoes/S = A
		to_chat(user, "You attached the [src] to [S] making movement silent")
		S.silent = 1
		S.desc += " Their soles appear to be made of fabric."
		user.drop_from_inventory(src,A)
		qdel(src)
