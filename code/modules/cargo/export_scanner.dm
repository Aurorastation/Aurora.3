/obj/item/export_scanner
	name = "export scanner"
	desc = "A device used to check objects against NanoTrasen exports and bounty database."
	icon = 'icons/obj/item/device/price_scanner.dmi'
	icon_state = "price_scanner"
	slot_flags = SLOT_BELT
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	siemens_coefficient = 1

/obj/item/export_scanner/afterattack(obj/O, mob/user, proximity)
	. = ..()
	if(!istype(O) || !proximity)
		return

	var/price = SScargo.export_item_and_contents(O, FALSE, FALSE, dry_run=TRUE)
	if(price)
		to_chat(user, SPAN_NOTICE("Scanned [O], value: <b>[price]</b> credits[O.contents.len ? " (contents included)" : ""]."))
	else
		to_chat(user, SPAN_WARNING("Scanned [O], no export value."))
	if(SScargo.bounty_ship_item_and_contents(O, dry_run=TRUE))
		to_chat(user, SPAN_NOTICE("Scanned item is eligible for one or more bounties."))
