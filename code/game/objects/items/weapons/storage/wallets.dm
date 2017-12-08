/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon_state = "wallet"
	w_class = 2
	max_w_class = 2
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/locket,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/flame/lighter,
		/obj/item/flame/match,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/screwdriver,
		/obj/item/stamp,
		/obj/item/device/paicard)
	slot_flags = SLOT_ID

	var/obj/item/card/id/front_id = null


/obj/item/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

/obj/item/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/storage/wallet/update_icon()

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


/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/fill()
	..()
	var/item1_type = pick(                \
		/obj/item/spacecash/c10,   \
		/obj/item/spacecash/c100,  \
		/obj/item/spacecash/c1000, \
		/obj/item/spacecash/c20,   \
		/obj/item/spacecash/c200,  \
		/obj/item/spacecash/c50,   \
		/obj/item/spacecash/c500   \
	)
	var/item2_type
	if(prob(50))
		item2_type = pick(                    \
			/obj/item/spacecash/c10,   \
			/obj/item/spacecash/c100,  \
			/obj/item/spacecash/c1000, \
			/obj/item/spacecash/c20,   \
			/obj/item/spacecash/c200,  \
			/obj/item/spacecash/c50,   \
			/obj/item/spacecash/c500   \
		)
	var/item3_type = pick(            \
		/obj/item/coin/silver, \
		/obj/item/coin/silver, \
		/obj/item/coin/gold,   \
		/obj/item/coin/iron,   \
		/obj/item/coin/iron,   \
		/obj/item/coin/iron    \
	)

	if(item1_type)
		new item1_type(src)
	if(item2_type)
		new item2_type(src)
	if(item3_type)
		new item3_type(src)
