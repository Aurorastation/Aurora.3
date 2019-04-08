/obj/item/weapon/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon_state = "wallet"
	w_class = 2
	max_w_class = 2
	can_hold = list(
		/obj/item/weapon/spacecash,
		/obj/item/weapon/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/locket,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/weapon/coin,
		/obj/item/weapon/dice,
		/obj/item/weapon/disk,
		/obj/item/weapon/implanter,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/flame/match,
		/obj/item/weapon/paper,
		/obj/item/weapon/paper_bundle,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/stamp,
		/obj/item/device/paicard,
		/obj/item/fluff,
		/obj/item/weapon/key)
	slot_flags = SLOT_ID

	var/obj/item/weapon/card/id/front_id = null


/obj/item/weapon/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

/obj/item/weapon/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/weapon/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/weapon/storage/wallet/update_icon()

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


/obj/item/weapon/storage/wallet/GetID()
	return front_id

/obj/item/weapon/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/weapon/storage/wallet/random/fill()
	..()
	var/item1_type = pick(                \
		/obj/item/weapon/spacecash/c10,   \
		/obj/item/weapon/spacecash/c100,  \
		/obj/item/weapon/spacecash/c1000, \
		/obj/item/weapon/spacecash/c20,   \
		/obj/item/weapon/spacecash/c200,  \
		/obj/item/weapon/spacecash/c50,   \
		/obj/item/weapon/spacecash/c500   \
	)
	var/item2_type
	if(prob(50))
		item2_type = pick(                    \
			/obj/item/weapon/spacecash/c10,   \
			/obj/item/weapon/spacecash/c100,  \
			/obj/item/weapon/spacecash/c1000, \
			/obj/item/weapon/spacecash/c20,   \
			/obj/item/weapon/spacecash/c200,  \
			/obj/item/weapon/spacecash/c50,   \
			/obj/item/weapon/spacecash/c500   \
		)
	var/item3_type = pick(            \
		/obj/item/weapon/coin/silver, \
		/obj/item/weapon/coin/silver, \
		/obj/item/weapon/coin/gold,   \
		/obj/item/weapon/coin/iron,   \
		/obj/item/weapon/coin/iron,   \
		/obj/item/weapon/coin/iron    \
	)

	if(item1_type)
		new item1_type(src)
	if(item2_type)
		new item2_type(src)
	if(item3_type)
		new item3_type(src)

/obj/item/weapon/storage/wallet/poor/fill()
	..()
	new /obj/item/weapon/spacecash/c10 (src)
	new /obj/item/weapon/spacecash/c20 (src)
	new /obj/item/weapon/spacecash/c50 (src)
	if (prob(25))
		new /obj/item/weapon/spacecash/c100 (src)

	new /obj/item/weapon/coin/iron (src)
	new /obj/item/weapon/coin/iron (src)

/obj/item/weapon/storage/wallet/medium/fill()
	..()
	new /obj/item/weapon/spacecash/c20 (src)
	new /obj/item/weapon/spacecash/c50 (src)
	new /obj/item/weapon/spacecash/c50 (src)
	new /obj/item/weapon/spacecash/c100 (src)
	if (prob(25))
		new /obj/item/weapon/spacecash/c200 (src)

	new /obj/item/weapon/coin/silver (src)
	new /obj/item/weapon/coin/silver (src)

/obj/item/weapon/storage/wallet/rich/fill()
	..()
	new /obj/item/weapon/spacecash/c100 (src)
	new /obj/item/weapon/spacecash/c200 (src)
	new /obj/item/weapon/spacecash/c200 (src)
	new /obj/item/weapon/spacecash/c500 (src)
	if (prob(20))
		new /obj/item/weapon/spacecash/c1000 (src)

	new /obj/item/weapon/coin/gold (src)
	new /obj/item/weapon/coin/gold (src)