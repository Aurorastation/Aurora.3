/obj/item/bee_pack
	name = "bee pack"
	desc = "A stasis pack for moving bees. Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beepack"
	var/full = TRUE

/obj/item/bee_pack/Initialize()
	. = ..()
	add_overlay("beepack-full")

/obj/item/bee_pack/update_icon()
	cut_overlays()
	add_overlay("beepack-[full ? "full" : "empty"]")

/obj/item/bee_pack/proc/empty()
	name = "empty bee pack"
	desc = "A stasis pack for moving bees. It's empty."
	full = FALSE
	update_icon()

/obj/item/bee_pack/proc/fill()
	name = initial(name)
	desc = initial(desc)
	full = TRUE
	update_icon()