// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["corporate black jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	jackets["corporate brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets["black jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket
	jackets["brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets["flannel jacket, green"] = /obj/item/clothing/suit/storage/toggle/flannel
	jackets["flannel jacket, red"] = /obj/item/clothing/suit/storage/toggle/flannel/red
	jackets["flannel jacket, blue"] = /obj/item/clothing/suit/storage/toggle/flannel/blue
	jackets["flannel jacket, grey"] = /obj/item/clothing/suit/storage/toggle/flannel/gray
	jackets["flannel jacket, purple"] = /obj/item/clothing/suit/storage/toggle/flannel/purple
	jackets["flannel jacket, yellow"] = /obj/item/clothing/suit/storage/toggle/flannel/yellow
	jackets["black vest"] = /obj/item/clothing/suit/storage/toggle/leather_vest
	jackets["brown vest"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	gear_tweaks += new/datum/gear_tweak/path(jackets)

/datum/gear/suit/hazard_vest
	display_name = "hazard vest selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/hazard = list()
	hazard["hazard vest, orange"] = /obj/item/clothing/suit/storage/hazardvest
	hazard["hazard vest, blue"] = /obj/item/clothing/suit/storage/hazardvest/blue
	hazard["hazard vest, white"] = /obj/item/clothing/suit/storage/hazardvest/white
	hazard["hazard vest, green"] = /obj/item/clothing/suit/storage/hazardvest/green
	gear_tweaks += new/datum/gear_tweak/path(hazard)

/datum/gear/suit/hoodie
	display_name = "hoodie"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie

/datum/gear/suit/hoodie/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/datum/gear/suit/overalls/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/surgeryapron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/apron/surgery
	cost = 1
	allowed_roles = list("Scientist", "Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/suit/iacvest
	display_name = "IAC vest"
	path = /obj/item/clothing/suit/iacvest
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Paramedic", "Medical Resident")

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/accessory/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/poncho = list()
	poncho["poncho, tan"] = /obj/item/clothing/accessory/poncho
	poncho["poncho, blue"] = /obj/item/clothing/accessory/poncho/blue
	poncho["poncho, green"] = /obj/item/clothing/accessory/poncho/green
	poncho["poncho, purple"] = /obj/item/clothing/accessory/poncho/purple
	poncho["poncho, red"] = /obj/item/clothing/accessory/poncho/red
	gear_tweaks += new/datum/gear_tweak/path(poncho)

/datum/gear/suit/suitjacket
	display_name = "suit jacket"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket

/datum/gear/suit/suitjacket/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit/storage/toggle/trench

/datum/gear/suit/trenchcoat/New()
	..()
	var/coat = list()
	coat["trenchcoat, brown"] = /obj/item/clothing/suit/storage/toggle/trench
	coat["trenchcoat, grey"] = /obj/item/clothing/suit/storage/toggle/trench/grey
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/dominia
	display_name = "dominia great coat selection"
	path = /obj/item/clothing/suit/storage/toggle/dominia

/datum/gear/suit/dominia/New()
	..()
	var/coat = list()
	coat["dominia great coat"] = /obj/item/clothing/suit/storage/toggle/dominia
	coat["dominia great coat, alternative"] = /obj/item/clothing/suit/storage/toggle/dominia/alt
	coat["dominia cape"] = /obj/item/clothing/suit/storage/dominia
	coat["dominia great coat, black"] = /obj/item/clothing/suit/storage/toggle/dominia/black
	coat["dominia great coat, alternative black"] = /obj/item/clothing/suit/storage/toggle/dominia/black/alt
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/military
	display_name = "military jacket selection"
	description = "A selection of military jackets, for the trained marksman in you."
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/military/New()
	..()
	var/coat = list()
	coat["military jacket"] = /obj/item/clothing/suit/storage/miljacket
	coat["military jacket, alternative"] = /obj/item/clothing/suit/storage/miljacket/alt
	coat["military jacket, green"] = /obj/item/clothing/suit/storage/miljacket/green
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/miscellaneous/peacoat
	display_name = "peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/varsity
	display_name = "varsity jacket selection"
	path = /obj/item/clothing/suit/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(varsities))

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/greenjacket
	display_name = "green suit jacket"
	path = /obj/item/clothing/suit/storage/toggle/greengov

/datum/gear/suit/cardigan
	display_name = "cardigan"
	path = /obj/item/clothing/suit/cardigan
	cost = 1 // has no pockets or any use whatsoever anyway

/datum/gear/suit/cardigan/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)