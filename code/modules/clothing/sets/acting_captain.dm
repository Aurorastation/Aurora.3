/obj/item/clothing/head/acapcap
	name = "acting captain's cap"
	desc = "A headdress that signifies the wearer as the acting captain."
	icon = 'icons/clothing/kit/acting_captain.dmi'
	icon_state = "acapcap"
	item_state = "acapcap"
	contained_sprite = TRUE

/obj/item/clothing/suit/acapjacket
	name = "acting captain's jacket"
	desc = "A comfortable jacket that signifies the wearer as the acting captain."
	icon = 'icons/clothing/kit/acting_captain.dmi'
	icon_state = "acapjacket"
	item_state = "acapjacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/accessory/armband/acap
	name = "acting captain's armband"
	desc = "An armband worn by the acting captain, to look fancy, to wear less, or to be extra."
	icon = 'icons/clothing/kit/acting_captain.dmi'
	icon_state = "acaparm"
	item_state = "acaparm"
	contained_sprite = TRUE

/obj/item/storage/briefcase/nt/acap
	name = "acting captain uniform briefcase"
	desc = "An NT-branded briefcase containing an optional acting captain's uniform. To be dealt out during an emergency when no captain is physically able to lead."
	starts_with = list(
		/obj/item/clothing/head/acapcap = 1,
		/obj/item/clothing/suit/acapjacket = 1,
		/obj/item/clothing/accessory/armband/acap = 1,
		/obj/item/device/radio/headset/heads/captain = 1
	)