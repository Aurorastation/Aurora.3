	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon_state = "wallet"
	w_class = 2
	max_w_class = 2
	can_hold = list(
		/obj/item/clothing/mask/smokable,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/locket,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/device/paicard)
	slot_flags = SLOT_ID



	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

	. = ..(W, prevent_warning)
	if(.)
			front_id = W
			name = "[name] ([front_id])"
			update_icon()


	if(front_id)
		switch(front_id.icon_state)
			if("id")
				icon_state = "walletid"
				return
			if("guest")
				icon_state = "walletid"
				return
			if("silver")
				icon_state = "walletid_silver"
				return
			if("gold")
				icon_state = "walletid_gold"
				return
			if("centcom")
				icon_state = "walletid_centcom"
				return
	icon_state = "wallet"


	return front_id

	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

	..()
	var/item1_type = pick(                \
	)
	var/item2_type
	if(prob(50))
		item2_type = pick(                    \
		)
	var/item3_type = pick(            \
	)

	if(item1_type)
		new item1_type(src)
	if(item2_type)
		new item2_type(src)
	if(item3_type)
		new item3_type(src)
