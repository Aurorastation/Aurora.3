

/obj/item/quikpay
	name = "\improper Idris Quik-Pay"
	desc = "Swipe your ID to make direct company purchases."
	icon = 'icons/obj/item/eftpos.dmi'
	icon_state = "quikpay"
	item_state = "electronic"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT

/obj/item/quikpay/Initialize()
	. = ..()
	src.LoadComponent(/datum/component/quikpay_shop/quikpay)

	//create a short manual as well
	var/obj/item/paper/R = new(src.loc)
	R.name = "Quik And Easy: How to make a transaction"

	R.info += "<b>Quik-Pay setup:</b><br>"
	R.info += "<ol><li>Remember your access code included on the paper that is included with your device</li>"
	R.info += "<li>Unlock it to be able to add items to the menu</li>"
	R.info += "<li>Add items to the menu by typing the item name and its price</li></ol>"
	R.info += "<b>When starting a new transaction:</b><br>"
	R.info += "<ol><li>Have the customer enter the amount of the item they want and then confirm the purchase.</li>"
	R.info += "<li>Allow them to review the sum.</li>"
	R.info += "<li>Have them swipe their card to pay for the items.</li></ol>"


	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.offset_x += 0
	R.offset_y += 0
	R.ico += "paper_stamp-cent"
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Executive Officer's desk.</i>"

/obj/item/quikpay/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	var/datum/component/quikpay_shop/quikpay/qp_shop = src.GetComponent(/datum/component/quikpay_shop/quikpay)
	if(!qp_shop)
		return
	qp_shop.interact_object(attacking_item, user)

/obj/item/quikpay/attack_self(var/mob/user)
	. = ..()
	var/datum/component/quikpay_shop/quikpay/qp_shop = src.GetComponent(/datum/component/quikpay_shop/quikpay)
	if(!qp_shop)
		return
	qp_shop.interact_with_ui(user)

/obj/item/quikpay/afterattack(atom/target, mob/user, proximity)
	if (!proximity) return

	var/datum/component/quikpay_shop/quikpay/qp_shop = src.GetComponent(/datum/component/quikpay_shop/quikpay)
	if(!qp_shop)
		return
	qp_shop.add_item(target, user)
