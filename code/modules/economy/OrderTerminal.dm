/obj/machinery/orderterminal
	name = "Idris Ordering Terminal"
	desc = "An ordering terminal designed by Idris for quicker expedition."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "kitchenterminal"
	anchored = 1
	idle_power_usage = 10
	var/machine_id = ""

	var/list/items = list()
	var/list/items_to_price = list()
	var/list/buying = list()

	var/new_item = ""
	var/new_price = 0

	var/sum = 0
	var/editmode = FALSE // Permits the menu to be changed
	var/confirmorder = FALSE // Waits for an id to confirm an order
	var/receipt = ""
	var/ticket = ""
	var/destinationact = "Service"
	var/ticket_number = 1
	req_one_access = list(ACCESS_BAR, ACCESS_GALLEY, ACCESS_CARGO) // Access to change the menu

/obj/machinery/orderterminal/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Items can be paid for with id cards or charge cards, and a receipt will be printed."
	. += "The terminal can print a paper which can be used to quickly fill it out in the future by using it on the register."

/obj/machinery/orderterminal/Initialize()
	. = ..()
	src.LoadComponent(/datum/component/quikpay_shop/orderterminal/food, req_one_access, destinationact)
	update_icon()

/obj/machinery/orderterminal/power_change()
	..()
	update_icon()

/obj/machinery/orderterminal/update_icon()
	ClearOverlays()
	if(stat & NOPOWER)
		set_light(FALSE)
		return

	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "kitchenterminal-active", plane = ABOVE_LIGHTING_PLANE)
	AddOverlays(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/orderterminal/process()
	if(stat & NOPOWER)
		ClearOverlays()
		set_light(FALSE)
		return

/obj/machinery/orderterminal/attack_hand(var/mob/user)
	if(stat & NOPOWER)
		balloon_alert(user, "no power")
		return
	var/datum/component/quikpay_shop/orderterminal/food/qp_shop = src.GetComponent(/datum/component/quikpay_shop/orderterminal/food)
	if(!qp_shop)
		return
	qp_shop.ui_interact(user)

/obj/machinery/orderterminal/attackby(obj/item/attacking_item, mob/user)
	if(stat & NOPOWER)
		balloon_alert(user, "no power")
		return
	var/datum/component/quikpay_shop/orderterminal/food/qp_shop = src.GetComponent(/datum/component/quikpay_shop/orderterminal/food)
	if(!qp_shop)
		return
	qp_shop.interact_object(attacking_item, user)
