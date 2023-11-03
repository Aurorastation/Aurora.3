/obj/item/clothing/head/unathi
	name = "straw hat"
	desc = "A simple straw hat, completely protecting the head from harsh sun and heavy rain."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "ronin_hat"
	item_state = "ronin_hat"
	contained_sprite = TRUE

/obj/item/clothing/head/unathi/deco
	name = "decorated straw hat"
	desc = "A simple straw hat, completely protecting the head from harsh sun and heavy rain. This one has decorative ornamentation."
	icon_state = "decorated_ronin_hat"
	item_state = "decorated_ronin_hat"

/obj/item/clothing/head/unathi/deco/green
	icon_state = "decorated_ronin_hat2"
	item_state = "decorated_ronin_hat2"

/obj/item/clothing/head/unathi/deco/blue
	icon_state = "decorated_ronin_hat3"
	item_state = "decorated_ronin_hat3"

/obj/item/clothing/head/unathi/deco/orange
	icon_state = "decorated_ronin_hat4"
	item_state = "decorated_ronin_hat4"

/obj/item/clothing/head/unathi/dark
	icon_state = "darkronin_hat"
	item_state = "darkronin_hat"

/obj/item/clothing/head/unathi/deco/dark
	icon_state = "decorated_darkronin_hat"
	item_state = "decorated_darkronin_hat"

/obj/item/clothing/head/unathi/deco/dark/green
	icon_state = "decorated_darkronin_hat2"
	item_state = "decorated_darkronin_hat2"

/obj/item/clothing/head/unathi/deco/dark/blue
	icon_state = "decorated_darkronin_hat3"
	item_state = "decorated_darkronin_hat3"

/obj/item/clothing/head/unathi/deco/dark/orange
	icon_state = "decorated_darkronin_hat4"
	item_state = "decorated_darkronin_hat4"

/obj/item/clothing/head/unathi/maxtlatl
	name = "Th'akhist headgear"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass; \
	alternatively, colorful feathers from talented hunters are sometimes used."
	desc_extended = "The headgear of the Th'akhist ensemble has a special component to it. Besides the emulated \
	frills made with straw or feathers, the authentic Unathite skull is from the bones of the previous owner, the \
	deceased shaman that came before. Other cultures see it as barbaric; Unathi believe that this enables shamans \
	to call upon their predecessors' wisdom as spirits to empower them."
	icon_state = "maxtlatl-head"
	item_state = "maxtlatl-head"

/obj/item/clothing/head/unathi/maxtlatl/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_head_str)
		var/mutable_appearance/M = mutable_appearance(mob_icon, "[item_state]_translate")
		M.appearance_flags = RESET_COLOR|RESET_ALPHA
		M.pixel_y = 12
		I.add_overlay(M)
	return I
