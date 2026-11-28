//snowflake guns for xenoarch because you can't override the update_icon() proc inside the giant mess that is find creation
/obj/item/gun/energy/proc/get_xenoarch_gun_hints(mob/user)
	. = list()
	if(GET_SKILL_LEVEL(user, ARCHAOLOGY_SKILL_COMPONENT) >= SKILL_LEVEL_FAMILIAR && power_supply)
		if(power_supply.rigged)
			. += SPAN_DANGER("Your knowledge of ancient relics warns you that the internal power cell's containment matrix is degraded and will detonate if fired!")
		else if(power_supply.maxcharge == 0)
			. += SPAN_WARNING("The internal power cell is fused and cannot hold a charge.")

/obj/item/gun/energy/laser/xenoarch
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "egun3"

/obj/item/gun/energy/laser/xenoarch/update_icon()
	return

/obj/item/gun/energy/laser/xenoarch/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += get_xenoarch_gun_hints(user)

/obj/item/gun/energy/laser/practice/xenoarch
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "egun1"

/obj/item/gun/energy/laser/practice/xenoarch/update_icon()
	return

/obj/item/gun/energy/laser/practice/xenoarch/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += get_xenoarch_gun_hints(user)

/obj/item/gun/energy/xray/xenoarch
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "egun5"

/obj/item/gun/energy/xray/xenoarch/update_icon()
	return

/obj/item/gun/energy/xray/xenoarch/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += get_xenoarch_gun_hints(user)

/obj/item/gun/energy/captain/xenoarch
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "egun4"

/obj/item/gun/energy/captain/xenoarch/update_icon()
	return

/obj/item/gun/energy/captain/xenoarch/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += get_xenoarch_gun_hints(user)
