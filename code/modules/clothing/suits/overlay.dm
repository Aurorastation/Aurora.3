// Want a coat with both customisable color and a part of it that's uncolored? Wait no more, with the brand new overlay coats!

// Could possibly make it so clothing has TWO kinds of customisable coloring for contrasting colors, more customisation and other stuff, but that requires loadout code I can't do. -Wezzy

/obj/item/clothing/suit/storage/toggle/overlay/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/suit/storage/toggle/overlay/toggle_open()
	. = ..()
	update_icon()

/obj/item/clothing/suit/storage/toggle/overlay/update_icon()
	. = ..()
	if(build_from_parts)
		cut_overlays()
		add_overlay(overlay_image(icon, "[icon_state]_[worn_overlay]", flags=RESET_COLOR)) //add the overlay w/o coloration of the original sprite

/obj/item/clothing/suit/storage/toggle/overlay/submariner
	name = "submariner's coat"
	desc = "A leather jacket with a synthetic fur collar. It looks comfortable, if a bit warm for the station."
	desc_fluff = "Waterproof leather coats such as this one are commonly worn by Europan submarine crews due to their ability to keep you warm and dry. Comes with a Castillo import synth-fur collar!"
	icon_state = "submariner_coat"
	item_state = "submariner_coat"
	build_from_parts = TRUE
	worn_overlay = "collar"
