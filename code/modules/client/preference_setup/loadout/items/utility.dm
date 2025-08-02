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
	var/list/briefcases = list()
	briefcases["brown briefcase"] = /obj/item/storage/briefcase
	briefcases["black briefcase"] = /obj/item/storage/briefcase/black
	briefcases["metal briefcase"] = /obj/item/storage/briefcase/aluminium
	briefcases["NT briefcase"] = /obj/item/storage/briefcase/nt
	gear_tweaks += new /datum/gear_tweak/path(briefcases)

/datum/gear/utility/secure
	display_name = "secure briefcase"
	path = /obj/item/storage/secure/briefcase
	cost = 2

/datum/gear/utility/purse
	display_name = "purse"
	description = "A small, fashionable bag typically worn over the shoulder."
	slot = slot_back
	path = /obj/item/storage/backpack/satchel/pocketbook/purse
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/folder

/datum/gear/utility/folder/New()
	..()
	var/list/folders = list()
	folders["blue folder"] = /obj/item/folder/blue
	folders["grey folder"] = /obj/item/folder
	folders["red folder"] = /obj/item/folder/red
	folders["white folder"] = /obj/item/folder/white
	folders["yellow folder"] = /obj/item/folder/yellow
	gear_tweaks += new /datum/gear_tweak/path(folders)

/datum/gear/utility/journal
	display_name = "journal"
	description = "A journal, kind of like a folder, but bigger! And personal."
	path = /obj/item/journal
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/notepad
	display_name = "notepad"
	description = "A notepad for jotting down notes in meetings or interrogations."
	path = /obj/item/journal/notepad
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/fountainpen
	display_name = "fountain pen selection"
	description = "A selection of fountain pens."
	path = /obj/item/pen/fountain
	cost = 1

/datum/gear/utility/fountainpen/New()
	..()
	var/list/fountainpens = list()
	fountainpens["black fountain pen"] = /obj/item/pen/fountain/black
	fountainpens["grey fountain pen"] = /obj/item/pen/fountain
	fountainpens["silver fountain pen"] = /obj/item/pen/fountain/silver
	fountainpens["white fountain pen"] = /obj/item/pen/fountain/white
	gear_tweaks += new /datum/gear_tweak/path(fountainpens)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/classicwallet
	display_name = "wallet"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/utility/wallet
	display_name = "wallet selection"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/wallet/New()
	..()
	var/list/wallet = list()
	wallet["wallet, colourable"] = /obj/item/storage/wallet/colourable
	wallet["wallet, purse"] = /obj/item/storage/wallet/purse
	gear_tweaks += new /datum/gear_tweak/path(wallet)

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
	path = /obj/item/voidsuit_modkit/himeo
	allowed_roles = list("Shaft Miner", "Operations Manager", "Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Engineering Personnel", "Operations Personnel")
	origin_restriction = list(/singleton/origin_item/origin/himeo, /singleton/origin_item/origin/ipc_himeo, /singleton/origin_item/origin/free_council)

// See the IPC-exclusive tab for the human variant.
/datum/gear/utility/assunzione_kit
	display_name = "assunzionii voidsuit kit"
	path = /obj/item/voidsuit_modkit/assunzione
	allowed_roles = list("Research Director", "Scientist", "Xenoarchaeologist", "Xenobiologist", "Xenobotanist", "Research Intern", "Science Personnel")
	origin_restriction = list(/singleton/origin_item/origin/assunzione, /singleton/origin_item/origin/ipc_assunzione)

/datum/gear/utility/wheelchair
	display_name = "wheelchair"
	path = /obj/item/material/stool/chair/wheelchair
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/business_card_holder
	display_name = "business card holder"
	description = "Comes in different materials."
	path = /obj/item/storage/business_card_holder
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/utility/business_card_holder/New()
	..()
	var/list/holders = list()
	holders["business card holder, metal"] = /obj/item/storage/business_card_holder
	holders["business card holder, wood"] = /obj/item/storage/business_card_holder/wood
	holders["business card holder, leather"] = /obj/item/storage/business_card_holder/leather
	holders["business card holder, plastic"] = /obj/item/storage/business_card_holder/plastic
	gear_tweaks += new /datum/gear_tweak/path(holders)

/datum/gear/utility/business_card
	display_name = "business card"
	description = "A selection of business cards." // I'm not smart enough to make it spawn inside the holders and carry over the text so we'll have to live with this
	path = /obj/item/paper/business_card
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/business_card/New()
	..()
	var/list/cards = list()
	cards["paper business card, divided"] = /obj/item/paper/business_card
	cards["paper business card, plain"] = /obj/item/paper/business_card/alt
	cards["paper business card, rounded"] = /obj/item/paper/business_card/rounded
	cards["glass business card"] = /obj/item/paper/business_card/glass
	cards["glass business card, black flair"] = /obj/item/paper/business_card/glass/b
	cards["glass business card, grey flair"] = /obj/item/paper/business_card/glass/g
	cards["glass business card, silver flair"] = /obj/item/paper/business_card/glass/s
	cards["glass business card, white flair"] = /obj/item/paper/business_card/glass/w
	gear_tweaks += new /datum/gear_tweak/path(cards)
	gear_tweaks += new /datum/gear_tweak/paper_data()

/datum/gear/utility/paper
	display_name = "colorable paper"
	path = /obj/item/paper
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/paper/New()
	..()
	gear_tweaks += new /datum/gear_tweak/paper_data()

/datum/gear/utility/buddy_tag
	display_name = "buddy tag"
	path = /obj/item/clothing/accessory/buddytag
	cost = 2

/datum/gear/utility/plasticbag
	display_name = "resealable plastic bag"
	path = /obj/item/evidencebag/plasticbag

/datum/gear/utility/buddy_tag/New()
	..()
	gear_tweaks += new /datum/gear_tweak/buddy_tag_config()

/datum/gear/utility/earphones
	display_name = "earphones selection"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/ears/earphones
	cost = 1

/datum/gear/utility/earphones/New()
	..()
	var/list/earphones = list()
	earphones["headphones"] = /obj/item/clothing/ears/earphones/headphones
	earphones["earphones"] = /obj/item/clothing/ears/earphones
	earphones["earbuds"] = /obj/item/clothing/ears/earphones/earbuds
	gear_tweaks += new /datum/gear_tweak/path(earphones)

/datum/gear/utility/earphones_music_cartridge
	display_name = "earphones music cartridge selection"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	path = /obj/item/music_cartridge/audioconsole
	cost = 1

/datum/gear/utility/earphones_music_cartridge/New()
	..()
	var/list/music_cartridges = list()
	music_cartridges["Konyang Vibes 2463"] = /obj/item/music_cartridge/konyang_retrowave
	music_cartridges["Top of the Charts 66 (Venusian Hits)"] = /obj/item/music_cartridge/venus_funkydisco
	music_cartridges["SCC Welcome Package"] = /obj/item/music_cartridge/audioconsole
	music_cartridges["Spacer Classics Vol. 1"] = /obj/item/music_cartridge/ss13
	music_cartridges["Indulgence EP (X-Rock)"] = /obj/item/music_cartridge/xanu_rock
	music_cartridges["Electro-Swing of Adhomai"] = /obj/item/music_cartridge/adhomai_swing
	music_cartridges["Europa: Best of the 50s"] = /obj/item/music_cartridge/europa_various
	gear_tweaks += new /datum/gear_tweak/path(music_cartridges)
