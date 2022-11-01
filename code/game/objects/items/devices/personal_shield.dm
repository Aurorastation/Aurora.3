/obj/item/device/personal_shield
	name = "personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots. Comes with a power cell and can be recharged in a recharger."
	icon = 'icons/obj/personal_shield.dmi'
	icon_state = "personal_shield"
	item_state = "personal_shield"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	action_button_name = "Toggle Shield"
	var/obj/item/cell/cell
	var/charge_per_shot = 200
	var/upkeep_cost = 50
	var/obj/aura/personal_shield/device/shield

/obj/item/device/personal_shield/examine(mob/user, distance)
	..()
	if(Adjacent(user))
		to_chat(user, SPAN_NOTICE("\The [src] has [cell.charge] charge remaining. Shield upkeep costs [upkeep_cost] charge, and blocking a shot costs [charge_per_shot] charge."))

/obj/item/device/personal_shield/Initialize()
	. = ..()
	cell = new(src)
	cell.charge = cell.maxcharge //1000 charge
	START_PROCESSING(SSprocessing, src)

/obj/item/device/personal_shield/get_cell()
	return cell

/obj/item/device/personal_shield/process()
	if(shield)
		cell.use(upkeep_cost)

/obj/item/device/personal_shield/attack_self(mob/living/user)
	if(cell.charge && !shield)
		shield = new /obj/aura/personal_shield/device(user)
		shield.added_to(user)
		shield.set_shield(src)
		user.update_inv_belt()
	else
		dissipate()
		user.update_inv_belt()
	update_icon()

/obj/item/device/personal_shield/Move()
	dissipate()
	return ..()

/obj/item/device/personal_shield/forceMove()
	dissipate()
	return ..()

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

/obj/item/device/personal_shield/Destroy()
	dissipate()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(cell)
	return ..()

/obj/item/device/personal_shield/proc/dissipate()
	if(shield?.user)
		to_chat(shield.user, FONT_LARGE(SPAN_WARNING("\The [src] fades around you, dissipating.")))
	QDEL_NULL(shield)
	update_icon()