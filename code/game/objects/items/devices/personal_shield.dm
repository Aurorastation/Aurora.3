/obj/item/device/personal_shield
	name = "personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots. Comes with a power cell and can be recharged in a recharger."
	icon = 'icons/obj/personal_shield.dmi'
	icon_state = "personal_shield"
	item_state = "personal_shield"
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	action_button_name = "Toggle Shield"
	var/obj/item/cell/cell
	var/charge_per_shot = 200
	var/upkeep_cost = 2
	var/obj/aura/personal_shield/device/shield

/obj/item/device/personal_shield/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		. += "\The [src] has <b>[cell.charge]</b> charge remaining."
		. += "Shield upkeep costs <b>[upkeep_cost]</b> charge, and blocking a shot costs <b>[charge_per_shot]</b> charge."

/obj/item/device/personal_shield/Initialize()
	. = ..()
	cell = new(src)
	cell.charge = cell.maxcharge //1000 charge

/obj/item/device/personal_shield/Destroy()
	dissipate()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(cell)

	return ..()

/obj/item/device/personal_shield/get_cell()
	return cell

/obj/item/device/personal_shield/process(seconds_per_tick)
	if(shield)
		if(!ismob(src.loc))
			deactivate()
			return
		cell.use(upkeep_cost*seconds_per_tick)

/obj/item/device/personal_shield/attack_self(mob/living/user)
	if(cell.charge && !shield)
		activate(user)
	else
		deactivate(user)

/**
 * Activates the shield
 *
 * * user - The user that activated the shield
 */
/obj/item/device/personal_shield/proc/activate(mob/living/user)
	if(cell.charge && !shield)
		shield = new /obj/aura/personal_shield/device(user)
		shield.added_to(user)
		shield.set_shield(src)
		user.update_inv_belt()

	START_PROCESSING(SSprocessing, src)

	update_icon()

/**
 * Deactivates the shield
 *
 * * user - The user that deactivated the shield, if any
 */
/obj/item/device/personal_shield/proc/deactivate(mob/living/user)
	if(shield)
		dissipate()
		user?.update_inv_belt()

	STOP_PROCESSING(SSprocessing, src)

	update_icon()

/obj/item/device/personal_shield/proc/take_charge()
	cell.use(charge_per_shot)
	if(cell.percent() == 0)
		to_chat(shield.user, FONT_LARGE(SPAN_WARNING("\The [src] begins to spark as it breaks!")))
		QDEL_NULL(shield)
		update_icon()
		return

/obj/item/device/personal_shield/update_icon()
	if(cell.charge && shield)
		icon_state = "[initial(icon_state)]_on"
		item_state = "[initial(item_state)]_on"
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"

/obj/item/device/personal_shield/proc/dissipate()
	if(shield?.user)
		to_chat(shield.user, FONT_LARGE(SPAN_WARNING("\The [src] fades around you, dissipating.")))
	QDEL_NULL(shield)
	update_icon()
