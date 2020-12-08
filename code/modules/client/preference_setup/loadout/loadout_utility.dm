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

/datum/gear/utility/hearing_aid
	display_name = "hearing aid selection"
	path = /obj/item/device/hearing_aid
	cost = 1

/datum/gear/utility/hearing_aid/New()
	..()
	var/hearingaids = list()
	hearingaids["hearing aid, skrell design"] = /obj/item/device/hearing_aid
	hearingaids["hearing aid, human design"] = /obj/item/device/hearing_aid/human
	gear_tweaks += new/datum/gear_tweak/path(hearingaids)

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
	path = 	/obj/item/device/taperecorder

/datum/gear/utility/camera
	display_name = "camera"
	path = 	/obj/item/device/camera

/datum/gear/utility/fannypack
	display_name = "fannypack selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/gear/utility/fannypack/New()
	..()
	var/list/fannys = list()
	fannys["leather fannypack"] = /obj/item/storage/belt/fannypack
	fannys["black fannypack"] = /obj/item/storage/belt/fannypack/black
	fannys["blue fannypack"] = /obj/item/storage/belt/fannypack/blue
	fannys["cyan fannypack"] = /obj/item/storage/belt/fannypack/cyan
	fannys["green fannypack"] = /obj/item/storage/belt/fannypack/green
	fannys["orange fannypack"] = /obj/item/storage/belt/fannypack/orange
	fannys["purple fannypack"] = /obj/item/storage/belt/fannypack/purple
	fannys["red fannypack"] = /obj/item/storage/belt/fannypack/red
	fannys["white fannypack"] = /obj/item/storage/belt/fannypack/white
	fannys["yellow fannypack"] = /obj/item/storage/belt/fannypack/yellow
	gear_tweaks += new/datum/gear_tweak/path(fannys)

/datum/gear/utility/toolbelt_alt
	display_name = "tool-belt, alt"
	cost = 0
	path = /obj/item/storage/belt/utility/alt
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Roboticist")

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
