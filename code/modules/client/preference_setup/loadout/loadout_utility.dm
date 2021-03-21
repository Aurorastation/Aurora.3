/datum/gear/utility
	display_name = "clipboard"
	path = /obj/item/clipboard
	sort_category = "Utility"

/datum/gear/utility/briefcase
	display_name = "briefcase selection"
	description = "A selection of briefcases."
	path = /obj/item/storage/briefcase

/datum/gear/utility/briefcase/New()
	..()
	var/briefcases = list()
	briefcases["brown briefcase"] = /obj/item/storage/briefcase
	briefcases["black briefcase"] = /obj/item/storage/briefcase/black
	briefcases["metal briefcase"] = /obj/item/storage/briefcase/aluminium
	briefcases["NT briefcase"] = /obj/item/storage/briefcase/nt
	gear_tweaks += new/datum/gear_tweak/path(briefcases)

/datum/gear/utility/secure
	display_name = "secure briefcase"
	path = /obj/item/storage/secure/briefcase
	cost = 2

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/folder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["blue folder"] = /obj/item/folder/blue
	folders["grey folder"] = /obj/item/folder
	folders["red folder"] = /obj/item/folder/red
	folders["white folder"] = /obj/item/folder/white
	folders["yellow folder"] = /obj/item/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/fountainpen
	display_name = "fountain pen selection"
	description = "A selection of fountain pens."
	path = /obj/item/pen/fountain
	cost = 1

/datum/gear/utility/fountainpen/New()
	..()
	var/fountainpens = list()
	fountainpens["black fountain pen"] = /obj/item/pen/fountain/black
	fountainpens["grey fountain pen"] = /obj/item/pen/fountain
	fountainpens["silver fountain pen"] = /obj/item/pen/fountain/silver
	fountainpens["white fountain pen"] = /obj/item/pen/fountain/white
	gear_tweaks += new/datum/gear_tweak/path(fountainpens)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/wallet
	display_name = "wallet selection"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/wallet/New()
	..()
	var/wallet = list()
	wallet["wallet, colourable"] = /obj/item/storage/wallet/colourable
	wallet["wallet, purse"] = /obj/item/storage/wallet/purse
	gear_tweaks += new/datum/gear_tweak/path(wallet)

/datum/gear/utility/lanyard
	display_name = "lanyard"
	path = 	/obj/item/storage/wallet/lanyard
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/recorder
	display_name = "universal recorder"
	path = /obj/item/device/taperecorder

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/device/camera

/datum/gear/utility/himeo_kit
	display_name = "himean voidsuit kit"
	path = /obj/item/himeo_kit
	allowed_roles = list("Cargo Technician", "Shaft Miner", "Quartermaster", "Head of Personnel", "Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/utility/wheelchair/color
	display_name = "wheelchair"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/business_card_holder
	display_name = "business card holder"
	path = /obj/item/storage/business_card_holder
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/business_card
	display_name = "business card"
	path = /obj/item/paper/business_card
	flags = 0

/datum/gear/utility/business_card/New()
	..()
	var/list/cards = list()
	cards["business card, divided"] = /obj/item/paper/business_card
	cards["business card, plain"] = /obj/item/paper/business_card/alt
	cards["business card, rounded"] = /obj/item/paper/business_card/rounded
	cards["business card, glass"] = /obj/item/paper/business_card/glass
	gear_tweaks += new /datum/gear_tweak/path(cards)
	gear_tweaks += new /datum/gear_tweak/paper_data()