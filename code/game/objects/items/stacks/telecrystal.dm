#define CRYSTAL_TYPE_TELECRYSTAL "telecrystal"
#define CRYSTAL_TYPE_BLUECRYSTAL "bluecrystal"

/obj/item/stack/telecrystal
	name = "telecrystal"
	desc = "It seems to be pulsing with suspiciously enticing energies."
	singular_name = "telecrystal"
	icon_state = "telecrystal"
	w_class = WEIGHT_CLASS_TINY
	max_amount = 50
	item_flags = ITEM_FLAG_NO_BLUDGEON
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)
	icon_has_variants = TRUE
	var/crystal_type = CRYSTAL_TYPE_TELECRYSTAL

/obj/item/stack/telecrystal/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Crystals can be activated by utilizing them on devices with an actively running uplink. They will not activate on unactivated uplinks."

/obj/item/stack/telecrystal/five/Initialize()
	. = ..()
	amount = 5
	update_icon()

/obj/item/stack/telecrystal/twentyfive/Initialize()
	. = ..()
	amount = 25
	update_icon()

/obj/item/stack/telecrystal/fifty/Initialize()
	. = ..()
	amount = 50
	update_icon()

/obj/item/stack/telecrystal/afterattack(var/obj/item/I, mob/user, proximity)
	if(!proximity)
		return
	if(istype(I, /obj/item))
		if(I.hidden_uplink && I.hidden_uplink.active) //No metagaming by using this on every PDA around just to see if it gets used up.
			if(crystal_type == CRYSTAL_TYPE_TELECRYSTAL)
				I.hidden_uplink.telecrystals += amount
			else if(crystal_type == CRYSTAL_TYPE_BLUECRYSTAL)
				I.hidden_uplink.bluecrystals += amount
			I.hidden_uplink.update_tgui_data()
			SSnanoui.update_uis(I.hidden_uplink)
			use(amount)
			to_chat(user, SPAN_NOTICE("You slot \the [src] into \the [I] and charge its internal uplink."))

/obj/item/stack/telecrystal/blue
	name = "bluecrystal"
	singular_name = "bluecrystal"
	icon_state = "bluecrystal"
	crystal_type = CRYSTAL_TYPE_BLUECRYSTAL

/obj/item/stack/telecrystal/blue/five/Initialize()
	. = ..()
	amount = 5
	update_icon()

/obj/item/stack/telecrystal/blue/twentyfive/Initialize()
	. = ..()
	amount = 25
	update_icon()

/obj/item/stack/telecrystal/blue/fifty/Initialize()
	. = ..()
	amount = 50
	update_icon()

#undef CRYSTAL_TYPE_TELECRYSTAL
#undef CRYSTAL_TYPE_BLUECRYSTAL
