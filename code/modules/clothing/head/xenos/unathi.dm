/obj/item/clothing/head/unathi
	name = "straw hat"
	desc = "A simple straw hat, completely protecting the head from harsh sun and heavy rain."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "ronin_hat"
	item_state = "ronin_hat"
	contained_sprite = TRUE
	protects_against_weather = TRUE

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
		I.AddOverlays(M)
	return I

/obj/item/clothing/head/helmet/unathi/ancient
	name = "ancient bronze helmet"
	desc = "An outdated helmet designated to be worn by an Unathi, it was commonly used by the Hegemony Levies."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "ancient_helm"
	item_state = "ancient_helm"
	armor = list( //not designed to hold up to bullets or lasers, but still better than nothing.
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_SMALL
	)
	matter = list(MATERIAL_BRONZE = 1000)
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound

/obj/item/clothing/head/helmet/unathi/ancient/mador
	name = "\improper Sinta'Mador bronze helmet"
	desc = "A large and unusual helmet of corroded bronze. Those familiar with Moghresian archaeology might recognize this item as being forged in a Sinta'Mador style."
	icon_state = "mador_helm"
	item_state = "mador_helm"

/obj/item/clothing/head/unathi/ancienthood
	name = "ragged ancient hood"
	desc = "An ancient cloth hood, remarkably intact given the wear of centuries."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "ancient_hood"
	item_state = "ancient_hood"

/obj/item/clothing/head/unathi/ancienthood/crown
	name = "worn ancient crown"
	desc = "An ancient and elaborate crowned hood - clearly meant to adorn the head of someone important."
	icon_state = "ancient_crown"
	item_state = "ancient_crown"
	species_restricted = list(BODYTYPE_UNATHI)

/obj/item/clothing/head/unathi/mador
	name = "\improper Sinta'Mador head wrappings"
	desc = "A set of gray cloth wrappings, used in traditional Sinta'Mador burials. Remarkably well preserved with age."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "mador_headwrappings"
	item_state = "mador_headwrappings"
