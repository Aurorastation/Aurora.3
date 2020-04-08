/obj/item/device/encryptionkey
	name = "standard encryption key"
	desc = "An encryption key for a radio headset. Contains cypherkeys."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/translate_binary = FALSE
	var/translate_hive = FALSE
	var/translate_hivenet = FALSE
	var/syndie = FALSE // Signifies that it de-crypts Syndicate transmissions
	var/list/channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE)

/obj/item/device/encryptionkey/attackby(obj/item/W, mob/user)
	return

/obj/item/device/encryptionkey/syndicate
	icon_state = "cypherkey"
	channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE, CHANNEL_MERCENARY = TRUE)
	origin_tech = list(TECH_ILLEGAL = 3)
	description_antag = "An encryption key that allows you to intercept comms and speak on private non-station channels. Use :t to access the private channel."
	syndie = TRUE

/obj/item/device/encryptionkey/raider
	icon_state = "cypherkey"
	channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE, CHANNEL_RAIDER = TRUE)
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = TRUE

/obj/item/device/encryptionkey/ninja
	icon_state = "cypherkey"
	channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE, CHANNEL_NINJA = TRUE)
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = TRUE

/obj/item/device/encryptionkey/binary
	icon_state = "cypherkey"
	translate_binary = TRUE
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/device/encryptionkey/hivenet
	name = "hivenet encryption chip"
	desc = "It appears to be a Vaurca hivenet encryption chip, for localized broadcasts."
	translate_hivenet = TRUE
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "neuralchip"

/obj/item/device/encryptionkey/headset_sec
	name = "security radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list(CHANNEL_SECURITY = TRUE)

/obj/item/device/encryptionkey/headset_eng
	name = "engineering radio encryption key"
	icon_state = "eng_cypherkey"
	channels = list(CHANNEL_ENGINEERING = TRUE)

/obj/item/device/encryptionkey/headset_rob
	name = "robotics radio encryption key"
	icon_state = "rob_cypherkey"
	channels = list(CHANNEL_ENGINEERING = TRUE, CHANNEL_SCIENCE = TRUE)

/obj/item/device/encryptionkey/headset_med
	name = "medical radio encryption key"
	icon_state = "med_cypherkey"
	channels = list(CHANNEL_MEDICAL = TRUE)

/obj/item/device/encryptionkey/headset_sci
	name = "science radio encryption key"
	icon_state = "sci_cypherkey"
	channels = list(CHANNEL_SCIENCE = TRUE)

/obj/item/device/encryptionkey/headset_medsci
	name = "medical research radio encryption key"
	icon_state = "medsci_cypherkey"
	channels = list(CHANNEL_MEDICAL = TRUE, CHANNEL_SCIENCE = TRUE)

/obj/item/device/encryptionkey/headset_com
	name = "command radio encryption key"
	icon_state = "com_cypherkey"
	channels = list(CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/heads/captain
	name = "captain's encryption key"
	icon_state = "cap_cypherkey"
	channels = list(CHANNEL_COMMAND = TRUE, CHANNEL_SECURITY = TRUE, CHANNEL_ENGINEERING = FALSE, CHANNEL_SCIENCE = FALSE, CHANNEL_MEDICAL = FALSE, CHANNEL_SUPPLY = FALSE, CHANNEL_SERVICE = FALSE)

/obj/item/device/encryptionkey/heads/ai_integrated
	name = "ai integrated encryption key"
	desc = "Integrated encryption key"
	icon_state = "cap_cypherkey"
	channels = list(CHANNEL_COMMAND = TRUE, CHANNEL_SECURITY = TRUE, CHANNEL_ENGINEERING = TRUE, CHANNEL_SCIENCE = TRUE, CHANNEL_MEDICAL = TRUE, CHANNEL_SUPPLY = TRUE, CHANNEL_SERVICE = TRUE, CHANNEL_AI_PRIVATE = TRUE)

/obj/item/device/encryptionkey/heads/rd
	name = "research director's encryption key"
	icon_state = "rd_cypherkey"
	channels = list(CHANNEL_SCIENCE = TRUE, CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/heads/hos
	name = "head of security's encryption key"
	icon_state = "hos_cypherkey"
	channels = list(CHANNEL_SECURITY = TRUE, CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/heads/ce
	name = "chief engineer's encryption key"
	icon_state = "ce_cypherkey"
	channels = list(CHANNEL_ENGINEERING = TRUE, CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/heads/cmo
	name = "chief medical officer's encryption key"
	icon_state = "cmo_cypherkey"
	channels = list(CHANNEL_MEDICAL = TRUE, CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/heads/hop
	name = "head of personnel's encryption key"
	icon_state = "hop_cypherkey"
	channels = list(CHANNEL_SUPPLY = TRUE, CHANNEL_SERVICE = TRUE, CHANNEL_COMMAND = TRUE, CHANNEL_SECURITY = FALSE)

/obj/item/device/encryptionkey/headset_cargo
	name = "supply radio encryption key"
	icon_state = "cargo_cypherkey"
	channels = list(CHANNEL_SUPPLY = TRUE)

/obj/item/device/encryptionkey/headset_service
	name = "service radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list(CHANNEL_SERVICE = TRUE)

/obj/item/device/encryptionkey/ert
	name = "\improper ERT radio encryption key"
	channels = list(CHANNEL_RESPONSE_TEAM = TRUE, CHANNEL_SCIENCE = TRUE, CHANNEL_COMMAND = TRUE, CHANNEL_MEDICAL = TRUE, CHANNEL_ENGINEERING = TRUE, CHANNEL_SECURITY = TRUE, CHANNEL_SUPPLY = TRUE, CHANNEL_SERVICE = TRUE)

/obj/item/device/encryptionkey/onlyert
	name = "\improper ERT radio encryption key"
	channels = list(CHANNEL_RESPONSE_TEAM = TRUE)

/obj/item/device/encryptionkey/entertainment
	name = "entertainment radio key"
	channels = list(CHANNEL_ENTERTAINMENT = TRUE)

/obj/item/device/encryptionkey/rev
	name = "standard encryption key"
	desc = "An encryption key for a radio headset. Contains cypherkeys."
	channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE, CHANNEL_RAIDER = TRUE)
	origin_tech = list(TECH_ILLEGAL = 2)
	description_antag = "An encryption key that allows you to speak on private non-station channels. Use :x to access the private channel."