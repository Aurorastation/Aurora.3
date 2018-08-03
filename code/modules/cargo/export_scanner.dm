/obj/item/export_scanner
	name = "export scanner"
	desc = "A device used to check objects against Nanotrasen exports and bounty database."
	icon = 'icons/obj/device.dmi'
	icon_state = "price_scanner"
	slot_flags = SLOT_BELT
	item_flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 1
	var/obj/machinery/computer/cargo/cargo_console = null

/obj/item/export_scanner/afterattack(obj/O, mob/user, proximity)
	. = ..()
	if(!istype(O) || !proximity)
		return

	var/price = SScargo.export_item_and_contents(O, FALSE, FALSE, dry_run=TRUE)
	if(price)
		to_chat(user, "<span class='notice'>Scanned [O], value: <b>[price]</b> credits[O.contents.len ? " (contents included)" : ""].</span>")
	else
		to_chat(user, "<span class='warning'>Scanned [O], no export value.</span>")
	if(SScargo.bounty_ship_item_and_contents(O, dry_run=TRUE))
		to_chat(user, "<span class='notice'>Scanned item is eligible for one or more bounties.</span>")
