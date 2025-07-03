//wands

/obj/item/gun/energy/wand
	name = "wand of nothing"
	desc = "A magic stick, this one don't do much however."
	icon = 'icons/obj/wands.dmi'
	icon_state = "nothingwand"
	item_state = "wand"
	has_item_ratio = FALSE
	fire_sound = 'sound/magic/wand.ogg'
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	max_shots = 10
	charge_cost = 100
	projectile_type = /obj/projectile/magic
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_BLUESPACE = 6)
	charge_meter = 0
	has_safety = FALSE
	needspin = FALSE

/obj/item/gun/energy/wand/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	. += ""

/obj/item/gun/energy/wand/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", SPAN_DANGER("*fizzle*"))
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/gun/energy/wand/special_check(var/mob/living/user)
	if((user.mutations & HULK))
		to_chat(user, SPAN_DANGER("In your rage you momentarily forget the operation of this wand!"))
		return 0
	return 1

/obj/item/gun/energy/wand/toy
	origin_tech = null
