/datum/gear/accessory
	abstract_type = /datum/gear/accessory
	sort_category = "Accessories"

/datum/gear/accessory/locket
	display_name = "silver locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie

/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/waistcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat_rec
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/waistcoat/New()
	..()
	var/list/waistcoats = list()
	waistcoats["waistcoat"] = /obj/item/clothing/accessory/wcoat_rec
	waistcoats["waistcoat, alt"] = /obj/item/clothing/accessory/silversun/wcoat
	gear_tweaks += new /datum/gear_tweak/path(waistcoats)

/datum/gear/accessory/chaps
	display_name = "chaps selection"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/New()
	..()
	var/list/chaps = list()
	chaps["chaps, brown"] = /obj/item/clothing/accessory/chaps
	chaps["chaps, black"] = /obj/item/clothing/accessory/chaps/black
	gear_tweaks += new /datum/gear_tweak/path(chaps)

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/list/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["security armband"] = /obj/item/clothing/accessory/armband/sec
	armbands["operations armband"] = /obj/item/clothing/accessory/armband/operations
	armbands["first responder armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["IAC armband"] = /obj/item/clothing/accessory/armband/iac
	armbands["tau ceti armband"] = /obj/item/clothing/accessory/armband/tauceti
	gear_tweaks += new /datum/gear_tweak/path(armbands)

/datum/gear/accessory/armband_coloured
	display_name = "armband (colourable)"
	path = /obj/item/clothing/accessory/armband/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster/armpit
	allowed_roles = list("Captain", "Executive Officer", "Bridge Crew", "Security Officer", "Warden", "Head of Security","Investigator", "Security Cadet", "Corporate Liaison", "Consular Officer",
		"Chief Engineer", "Chief Medical Officer", "Research Director", "Operations Manager", "Diplomatic Aide", "Security Personnel")

/datum/gear/accessory/holster/New()
	..()
	var/list/holsters = list()
	holsters["black holster, armpit"] = /obj/item/clothing/accessory/holster/armpit
	holsters["black holster, hip"] = /obj/item/clothing/accessory/holster/hip
	holsters["black holster, waist"] = /obj/item/clothing/accessory/holster/waist
	holsters["black holster, thigh"] = /obj/item/clothing/accessory/holster/thigh
	holsters["brown holster, armpit"] = /obj/item/clothing/accessory/holster/armpit/brown
	holsters["brown holster, hip"] = /obj/item/clothing/accessory/holster/hip/brown
	holsters["brown holster, waist"] = /obj/item/clothing/accessory/holster/waist/brown
	holsters["brown holster, thigh"] = /obj/item/clothing/accessory/holster/thigh/brown
	gear_tweaks += new /datum/gear_tweak/path(holsters)

/datum/gear/accessory/tie
	display_name = "tie selection (colourable)"
	path = /obj/item/clothing/accessory/tie/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie/New()
	..()
	var/list/ties = list()
	ties["tie"] = /obj/item/clothing/accessory/tie/colourable
	ties["tie, gold clip"] = /obj/item/clothing/accessory/tie/colourable/clip
	ties["tie, silver clip"] = /obj/item/clothing/accessory/tie/colourable/clip/silver
	gear_tweaks += new /datum/gear_tweak/path(ties)

/datum/gear/accessory/horrible_tie
	display_name = "horrible tie"
	path = /obj/item/clothing/accessory/horrible

/datum/gear/accessory/neck_accessories_colourable
	display_name = "neck accessories selection (colourable)"
	description = "A selection of various neck accessories, such as ribbons and bows."
	path = /obj/item/clothing/accessory/tie/ribbon
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/neck_accessories_colourable/New()
	..()
	var/list/neck_accessories_colourable = list()
	neck_accessories_colourable["neck ribbon"] = /obj/item/clothing/accessory/tie/ribbon/neck
	neck_accessories_colourable["neck bow"] = /obj/item/clothing/accessory/tie/ribbon/bow
	neck_accessories_colourable["bow tie"] = /obj/item/clothing/accessory/tie/ribbon/bow_tie
	gear_tweaks += new /datum/gear_tweak/path(neck_accessories_colourable)

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Engineering Personnel")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Security Officer","Head of Security","Warden", "Security Cadet", "Investigator", "Security Personnel")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "First Responder", "Medical Intern", "Medical Personnel")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing/grayscale
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/webbing_harness
	display_name = "webbing, harness selection"
	path = /obj/item/clothing/accessory/storage/webbingharness
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/webbing_harness/New()
	..()
	var/list/webbingharness = list()
	webbingharness["webbing harness"] = /obj/item/clothing/accessory/storage/webbingharness
	webbingharness["webbing harness, pouches"] = /obj/item/clothing/accessory/storage/webbingharness/pouches
	webbingharness["webbing harness, pouches alt"] = /obj/item/clothing/accessory/storage/webbingharness/alt
	gear_tweaks += new /datum/gear_tweak/path(webbingharness)

/datum/gear/accessory/colorable_webbing_harness
	display_name = "webbing, colorable harness selection"
	path = /obj/item/clothing/accessory/storage/webbingharness/grayscale
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/colorable_webbing_harness/New()
	..()
	var/list/colorableharness = list()
	colorableharness["webbing harness"] = /obj/item/clothing/accessory/storage/webbingharness/grayscale
	colorableharness["webbing harness, pouches"] = /obj/item/clothing/accessory/storage/webbingharness/pouches/grayscale
	colorableharness["webbing harness, pouches alt"] = /obj/item/clothing/accessory/storage/webbingharness/alt/grayscale
	gear_tweaks += new /datum/gear_tweak/path(colorableharness)

/datum/gear/accessory/brown_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/pouches/brown
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Engineering Personnel")

/datum/gear/accessory/black_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/pouches/black
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator", "Security Personnel")

/datum/gear/accessory/white_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/pouches/white
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "First Responder", "Medical Intern", "Medical Personnel")

/datum/gear/accessory/pouches
	display_name = "drop pouches, simple"
	path = /obj/item/clothing/accessory/storage/pouches/colour
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/overalls_engineer
	display_name = "overalls, engineering"
	path = /obj/item/clothing/accessory/storage/overalls/engineer
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Engineering Personnel")
	cost = 2

/datum/gear/accessory/overalls_mining
	display_name = "overalls, mining"
	path = /obj/item/clothing/accessory/storage/overalls/mining
	allowed_roles = list("Shaft Miner", "Xenoarchaeologist", "Operations Personnel", "Science Personnel")
	cost = 2

/datum/gear/accessory/polo
	display_name = "polo shirts selection"
	description = "A selection of polo shirts."
	path = /obj/item/clothing/accessory/polo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/polo/New()
	..()
	var/list/polo = list()

	polo["blue polo shirt"] = /obj/item/clothing/accessory/polo/polo_blue
	polo["blue polo shirt (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_blue_fem
	polo["red polo shirt"] = /obj/item/clothing/accessory/polo/polo_red
	polo["red polo shirt (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_red_fem
	polo["tan polo shirt"] = /obj/item/clothing/accessory/polo/polo_grayyellow
	polo["tan polo shirt (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_grayyellow_fem
	polo["polo shirt, green strip"] = /obj/item/clothing/accessory/polo/polo_greenstrip
	polo["polo shirt, green strip (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_greenstrip_fem
	polo["polo shirt, blue strip"] = /obj/item/clothing/accessory/polo/polo_bluestrip
	polo["polo shirt, blue strip (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_bluestrip_fem
	polo["polo shirt, red strip"] = /obj/item/clothing/accessory/polo/polo_redstrip
	polo["polo shirt, red strip (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_redstrip_fem

	gear_tweaks += new /datum/gear_tweak/path(polo)

/datum/gear/accessory/polo_colorable
	display_name = "polo shirts selection (colorable)"
	description = "A selection of colorable polo shirts."
	path = /obj/item/clothing/accessory/polo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/polo_colorable/New()
	..()
	var/list/polo_colorable = list()

	polo_colorable["polo shirt"] = /obj/item/clothing/accessory/polo
	polo_colorable["polo shirt (waist fitted)"] = /obj/item/clothing/accessory/polo/polo_fem

	gear_tweaks += new /datum/gear_tweak/path(polo_colorable)

/datum/gear/accessory/sweater
	display_name = "sweater selection"
	path = /obj/item/clothing/accessory/sweater
	description = "A selection of sweaters and sweater vests."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sweater/New()
	..()
	var/list/sweater = list()

	// Sweaters
	sweater["sweater"] = /obj/item/clothing/accessory/sweater
	sweater["tubeneck sweater"] = /obj/item/clothing/accessory/sweater/tubeneck
	sweater["turtleneck sweater"] = /obj/item/clothing/accessory/sweater/turtleneck
	sweater["crewneck sweater"] = /obj/item/clothing/accessory/sweater/crewneck
	sweater["v-neck sweater"] = /obj/item/clothing/accessory/sweater/v_neck
	sweater["deep v-neck sweater"] = /obj/item/clothing/accessory/sweater/v_neck/deep

	// Argyle Sweaters
	sweater["argyle sweater"] = /obj/item/clothing/accessory/sweater/argyle
	sweater["argyle tubeneck sweater"] = /obj/item/clothing/accessory/sweater/argyle/tubeneck
	sweater["argyle turtleneck sweater"] = /obj/item/clothing/accessory/sweater/argyle/turtleneck
	sweater["argyle crewneck sweater"] = /obj/item/clothing/accessory/sweater/argyle/crewneck
	sweater["argyle v-neck sweater"] = /obj/item/clothing/accessory/sweater/argyle/v_neck

	// Sweater Vests
	sweater["sweater vest"] = /obj/item/clothing/accessory/sweater/vest
	sweater["argyle sweater vest"] = /obj/item/clothing/accessory/sweater/argyle/vest

	gear_tweaks += new /datum/gear_tweak/path(sweater)

/datum/gear/accessory/shirt
	display_name = "shirt selection"
	path = /obj/item/clothing/accessory/dressshirt
	description = "A selection of shirts."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/shirt/New()
	..()
	var/list/shirt = list()
	shirt["dress shirt"] = /obj/item/clothing/accessory/dressshirt
	shirt["dress shirt, rolled up"] = /obj/item/clothing/accessory/dressshirt/rolled
	shirt["dress shirt, cropped"] = /obj/item/clothing/accessory/dressshirt/crop
	shirt["cropped dress shirt, rolled up"] = /obj/item/clothing/accessory/dressshirt/crop/rolled
	shirt["dress shirt, alt"] = /obj/item/clothing/accessory/dressshirt/alt
	shirt["dress shirt, alt rolled up"] = /obj/item/clothing/accessory/dressshirt/alt/rolled
	shirt["dress shirt, v-neck alt"] = /obj/item/clothing/accessory/dressshirt/alt/vneck
	shirt["dress shirt, v-neck alt rolled up"] = /obj/item/clothing/accessory/dressshirt/alt/vneck/rolled
	shirt["dress shirt, deep v-neck"] = /obj/item/clothing/accessory/dressshirt/deepv
	shirt["dress shirt, deep v-neck rolled up"] = /obj/item/clothing/accessory/dressshirt/deepv/rolled
	shirt["dress shirt, asymmetric"] = /obj/item/clothing/accessory/dressshirt/asymmetric
	shirt["long-sleeved shirt"] = /obj/item/clothing/accessory/longsleeve
	shirt["long-sleeved shirt, black striped"] = /obj/item/clothing/accessory/longsleeve_s
	shirt["long-sleeved shirt, blue striped"] = /obj/item/clothing/accessory/longsleeve_sb
	shirt["t-shirt"] = /obj/item/clothing/accessory/tshirt
	shirt["t-shirt, cropped"] = /obj/item/clothing/accessory/tshirt_crop
	shirt["blouse"] = /obj/item/clothing/accessory/blouse
	shirt["long-sleeved blouse"] = /obj/item/clothing/accessory/longblouse
	shirt["puffy blouse"] = /obj/item/clothing/accessory/puffyblouse
	shirt["halter top"] = /obj/item/clothing/accessory/haltertop
	gear_tweaks += new /datum/gear_tweak/path(shirt)

/datum/gear/accessory/silversun
	display_name = "silversun floral shirt selection"
	path = /obj/item/clothing/accessory/silversun
	description = "A selection of Silversun floral shirts."
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/silversun/New()
	..()
	var/list/shirts = list()
	shirts["cyan silversun shirt"] = /obj/item/clothing/accessory/silversun
	shirts["red silversun shirt"] = /obj/item/clothing/accessory/silversun/red
	shirts["random colored silversun shirt"] = /obj/item/clothing/accessory/silversun/random
	gear_tweaks += new /datum/gear_tweak/path(shirts)

/datum/gear/accessory/university
	display_name = "university sweatshirt selection"
	path = /obj/item/clothing/accessory/university
	description = "A selection of university sweatshirts."
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/university/New()
	..()
	var/list/university = list()
	university["grey university sweatshirt"] = /obj/item/clothing/accessory/university
	university["crimson university sweatshirt"] = /obj/item/clothing/accessory/university/red
	university["mustard university sweatshirt"] = /obj/item/clothing/accessory/university/yellow
	university["navy university sweatshirt"] = /obj/item/clothing/accessory/university/blue
	university["black university sweatshirt"] = /obj/item/clothing/accessory/university/black
	gear_tweaks += new /datum/gear_tweak/path(university)

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarfs = list()
	scarfs["plain scarf"] = /obj/item/clothing/accessory/scarf
	scarfs["zebra scarf"] = /obj/item/clothing/accessory/scarf/zebra
	gear_tweaks += new /datum/gear_tweak/path(scarfs)

/datum/gear/accessory/dogtags
	display_name = "dogtags"
	path = /obj/item/clothing/accessory/dogtags

/datum/gear/accessory/holobadge
	display_name = "badge, holographic"
	path = /obj/item/clothing/accessory/badge/holo
	allowed_roles = list("Head of Security", "Investigator", "Warden", "Security Officer", "Security Cadet", "Security Personnel")

/datum/gear/accessory/holobadge/New()
	..()
	var/list/holobadges = list()
	holobadges["holobadge"] = /obj/item/clothing/accessory/badge/holo
	holobadges["holobadge cord"] = /obj/item/clothing/accessory/badge/holo/cord
	gear_tweaks += new /datum/gear_tweak/path(holobadges)

/datum/gear/accessory/officerbadge
	display_name = "badge, officer"
	path = /obj/item/clothing/accessory/badge/officer
	allowed_roles = list("Security Officer", "Security Personnel")

/datum/gear/accessory/wardenbadge
	display_name = "badge, warden"
	path = /obj/item/clothing/accessory/badge/warden
	allowed_roles = list("Warden", "Security Personnel")

/datum/gear/accessory/hosbadge
	display_name = "badge, HoS"
	path = /obj/item/clothing/accessory/badge/hos
	allowed_roles = list("Head of Security")

/datum/gear/accessory/detbadge
	display_name = "badge, investigations"
	path = /obj/item/clothing/accessory/badge/investigator
	allowed_roles = list("Investigator", "Security Personnel")

/datum/gear/accessory/badge
	display_name = "badge selection"
	path = /obj/item/clothing/accessory/badge/idbadge

/datum/gear/accessory/badge/New()
	..()
	var/list/badge = list()
	badge["badge, identification"] = /obj/item/clothing/accessory/badge/idbadge
	badge["badge, NanoTrasen ID"] = /obj/item/clothing/accessory/badge/idbadge/nt
	badge["badge, electronic"] = /obj/item/clothing/accessory/badge/idbadge/intel
	gear_tweaks += new /datum/gear_tweak/path(badge)

/datum/gear/accessory/namepin
	display_name = "pins selection"
	path = /obj/item/clothing/accessory/badge/namepin
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/namepin/New()
	..()
	var/list/pin = list()
	pin["pin, name tag"] = /obj/item/clothing/accessory/badge/namepin
	pin["pin, any/all pronouns"] = /obj/item/clothing/accessory/pronoun
	pin["pin, he/him pronouns"] = /obj/item/clothing/accessory/pronoun/hehim
	pin["pin, he/they pronouns"] = /obj/item/clothing/accessory/pronoun/hethey
	pin["pin, she/her pronouns"] = /obj/item/clothing/accessory/pronoun/sheher
	pin["pin, she/they pronouns"] = /obj/item/clothing/accessory/pronoun/shethey
	pin["pin, they/them pronouns"] = /obj/item/clothing/accessory/pronoun/theythem
	pin["pin, it/its pronouns"] = /obj/item/clothing/accessory/pronoun/itits
	pin["pin, please ask! pronouns"] = /obj/item/clothing/accessory/pronoun/ask
	gear_tweaks += new /datum/gear_tweak/path(pin)

/datum/gear/accessory/ribbon
	display_name = "ribbon (colourable)"
	path = /obj/item/clothing/accessory/ribbon
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sleeve_patch
	display_name = "shoulder sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/whalebone
	display_name = "europan bone charm"
	path = /obj/item/clothing/accessory/whalebone
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/gadpathur
	display_name = "gadpathurian cadre brassard selection"
	description = "A selection of cadre brassards from Gadpathur."
	path = /obj/item/clothing/accessory/armband/gadpathur
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/gear/accessory/gadpathur/New()
	..()
	var/list/gadpathur = list()
	gadpathur["cadre brassard"] = /obj/item/clothing/accessory/armband/gadpathur
	gadpathur["industrial cadre brassard"] = /obj/item/clothing/accessory/armband/gadpathur/ind
	gadpathur["medical cadre brassard"] = /obj/item/clothing/accessory/armband/gadpathur/med
	gear_tweaks += new /datum/gear_tweak/path(gadpathur)

/datum/gear/accessory/gadpathur_leader
	display_name = "gadpathurian section leader badge"
	description = "A small metal badge worn by Gadpathurian Section Leaders."
	path = /obj/item/clothing/accessory/gadpathurian_leader
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/gear/accessory/gadpathur_dogtags
	display_name = "gadpathurian dogtags"
	description = "Dogtags issued to Gadpathurians."
	path = /obj/item/clothing/accessory/dogtags/gadpathur
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/gear/accessory/sash_coloured
	display_name = "sash (colourable)"
	path = /obj/item/clothing/accessory/sash/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sash
	display_name = "sash selection"
	description = "A selection of sashes in various colours."
	path = /obj/item/clothing/accessory/sash

/datum/gear/accessory/sash/New()
	..()
	var/list/sash = list()
	sash["yellow sash"] = /obj/item/clothing/accessory/sash
	sash["red sash"] = /obj/item/clothing/accessory/sash/red
	sash["blue sash"] = /obj/item/clothing/accessory/sash/blue
	sash["orange sash"] = /obj/item/clothing/accessory/sash/orange
	sash["purple sash"] = /obj/item/clothing/accessory/sash/purple
	sash["white sash"] =/obj/item/clothing/accessory/sash/white
	gear_tweaks += new /datum/gear_tweak/path(sash)

/datum/gear/accessory/sash_horizontal
	display_name = "horizontal sash (colourable)"
	path = /obj/item/clothing/accessory/sash/horizontal
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/konyang_belt
	display_name = "hanbok belt (colourable)"
	path = /obj/item/clothing/accessory/konyang
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/passcard
	display_name = "human passcard selection"
	path = /obj/item/clothing/accessory/badge/passcard
	cost = 1

/datum/gear/accessory/passcard/New()
	..()
	var/list/passcard = list()
	passcard["passcard, tau ceti"] = /obj/item/clothing/accessory/badge/passcard
	passcard["passcard, sol"] = /obj/item/clothing/accessory/badge/passcard/sol
	passcard["passcard, pluto"] = /obj/item/clothing/accessory/badge/passcard/sol/pluto
	passcard["passcard, jovian"] = /obj/item/clothing/accessory/badge/passcard/sol/jupiter
	passcard["passcard, luna"] = /obj/item/clothing/accessory/badge/passcard/sol/luna
	passcard["passcard, europa"] = /obj/item/clothing/accessory/badge/passcard/sol/europa
	passcard["passcard, cytherean"] = /obj/item/clothing/accessory/badge/passcard/sol/cytherean
	passcard["passcard, jintarian"] = /obj/item/clothing/accessory/badge/passcard/sol/jintarian
	passcard["passcard, eridani"] = /obj/item/clothing/accessory/badge/passcard/eridani
	passcard["passcard, elyra"] = /obj/item/clothing/accessory/badge/passcard/elyra
	passcard["passcard, dominia"] = /obj/item/clothing/accessory/badge/passcard/dominia
	passcard["passcard, coalition"] = /obj/item/clothing/accessory/badge/passcard/coalition
	passcard["passcard, himeo"] = /obj/item/clothing/accessory/badge/passcard/himeo
	passcard["passcard, vysoka"] = /obj/item/clothing/accessory/badge/passcard/vysoka
	passcard["passcard, gadpathur"] = /obj/item/clothing/accessory/badge/passcard/gad
	passcard["passcard, assunzione"] = /obj/item/clothing/accessory/badge/passcard/assu
	passcard["passcard, konyang"] = /obj/item/clothing/accessory/badge/passcard/konyang
	passcard["passcard, visegrad"] = /obj/item/clothing/accessory/badge/passcard/sol/visegrad
	gear_tweaks += new /datum/gear_tweak/path(passcard)

/datum/gear/accessory/workvisa
	display_name = "republic of biesel work visa"
	description = "A work visa issued to those who work in the Republic of Biesel, but who do not have a Biesellite citizenship."
	path = /obj/item/clothing/accessory/badge/passcard/workvisa
	cost = 1

/datum/gear/accessory/passport
	display_name = "human passport selection"
	path = /obj/item/clothing/accessory/badge/passport
	cost = 1

/datum/gear/accessory/passport/New()
	..()
	var/list/passport = list()
	passport["passport, biesel"] = /obj/item/clothing/accessory/badge/passport
	passport["passport, sol"] = /obj/item/clothing/accessory/badge/passport/sol
	passport["passport, elyra"] = /obj/item/clothing/accessory/badge/passport/elyra
	passport["passport, dominia"] = /obj/item/clothing/accessory/badge/passport/dominia
	passport["passport, coalition"] = /obj/item/clothing/accessory/badge/passport/coc
	gear_tweaks += new /datum/gear_tweak/path(passport)

/datum/gear/accessory/TCAFcard
	display_name = "TCAF service cards"
	description = "Identification cards given to reservists and former members of the Tau Ceti Armed Forces."
	path = /obj/item/clothing/accessory/badge/tcaf_papers

/datum/gear/accessory/TCAFcard/New()
	..()
	var/list/TCAFcard = list()
	TCAFcard["reservist"] = /obj/item/clothing/accessory/badge/tcaf_papers/service/reservist
	TCAFcard["veteran"] = /obj/item/clothing/accessory/badge/tcaf_papers/service/veteran
	gear_tweaks += new /datum/gear_tweak/path(TCAFcard)

/datum/gear/accessory/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/blood_patch
	display_name = "blood patch selection"
	description = "An embroidered patch indicating the wearer's blood type."
	path = /obj/item/clothing/accessory/blood_patch

/datum/gear/accessory/blood_patch/New()
	..()
	var/list/patches = list()
	for(var/type in typesof(/obj/item/clothing/accessory/blood_patch))
		var/obj/item/clothing/accessory/blood_patch/BP = type
		patches[initial(BP.name)] = type
	gear_tweaks += new /datum/gear_tweak/path(patches)

/datum/gear/accessory/bandanna
	display_name = "neck bandanna selection"
	path = /obj/item/clothing/accessory/bandanna

/datum/gear/accessory/bandanna/New()
	..()
	var/list/bandanna = list()
	bandanna["red bandanna"] =  /obj/item/clothing/accessory/bandanna
	bandanna["blue bandanna"] = /obj/item/clothing/accessory/bandanna/blue
	bandanna["black bandanna"] = /obj/item/clothing/accessory/bandanna/black
	gear_tweaks += new /datum/gear_tweak/path(bandanna)

/datum/gear/accessory/bandanna_colorable
	display_name = "neck bandanna (colorable)"
	path = /obj/item/clothing/accessory/bandanna/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/flagpatch
	display_name = "generic flagpatch selection"
	path = /obj/item/clothing/accessory/flagpatch/rectangular
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	cost = 1

/datum/gear/accessory/flagpatch/New()
	..()
	var/list/flagpatch = list()
	flagpatch["rectangular flagpatch"] =  /obj/item/clothing/accessory/flagpatch/rectangular
	flagpatch["triangular flagpatch"] = /obj/item/clothing/accessory/flagpatch/triangular
	flagpatch["circular flagpatch"] =  /obj/item/clothing/accessory/flagpatch/circular
	flagpatch["square flagpatch"] =  /obj/item/clothing/accessory/flagpatch/square
	gear_tweaks += new /datum/gear_tweak/path(flagpatch)

/datum/gear/accessory/flagpatch_national
	display_name = "flagpatch selection"
	path = /obj/item/clothing/accessory/flagpatch/biesel
	cost = 1

/datum/gear/accessory/flagpatch_national/New()
	..()
	var/list/flagpatch_national = list()
	flagpatch_national["flagpatch, biesel"] = /obj/item/clothing/accessory/flagpatch/biesel
	flagpatch_national["flagpatch, mictlan"] = /obj/item/clothing/accessory/flagpatch/mictlan
	flagpatch_national["flagpatch, new gibson"] = /obj/item/clothing/accessory/flagpatch/newgibson
	flagpatch_national["flagpatch, valkyrie"] = /obj/item/clothing/accessory/flagpatch/valkyrie
	flagpatch_national["flagpatch, sol"] = /obj/item/clothing/accessory/flagpatch/sol
	flagpatch_national["flagpatch, mars"] = /obj/item/clothing/accessory/flagpatch/mars
	flagpatch_national["flagpatch, gus"] = /obj/item/clothing/accessory/flagpatch/gus
	flagpatch_national["flagpatch, eridani"] = /obj/item/clothing/accessory/flagpatch/eridani
	flagpatch_national["flagpatch, europa"] = /obj/item/clothing/accessory/flagpatch/europa
	flagpatch_national["flagpatch, new hai phong"] = /obj/item/clothing/accessory/flagpatch/newhaiphong
	flagpatch_national["flagpatch, pluto"] = /obj/item/clothing/accessory/flagpatch/pluto
	flagpatch_national["flagpatch, visegrad"] = /obj/item/clothing/accessory/flagpatch/visegrad
	flagpatch_national["flagpatch, silversun"] = /obj/item/clothing/accessory/flagpatch/silversun
	flagpatch_national["flagpatch, callisto"] = /obj/item/clothing/accessory/flagpatch/callisto
	flagpatch_national["flagpatch, venus"] = /obj/item/clothing/accessory/flagpatch/venus
	flagpatch_national["flagpatch, luna"] = /obj/item/clothing/accessory/flagpatch/luna
	flagpatch_national["flagpatch, konyang"] = /obj/item/clothing/accessory/flagpatch/konyang
	flagpatch_national["flagpatch, elyra"] = /obj/item/clothing/accessory/flagpatch/elyra
	flagpatch_national["flagpatch, coalition"] = /obj/item/clothing/accessory/flagpatch/coalition
	flagpatch_national["flagpatch, himeo"] = /obj/item/clothing/accessory/flagpatch/himeo
	flagpatch_national["flagpatch, vysoka"] = /obj/item/clothing/accessory/flagpatch/vysoka
	flagpatch_national["flagpatch, gadpathur"] = /obj/item/clothing/accessory/flagpatch/gadpathur
	flagpatch_national["flagpatch, assunzione"] = /obj/item/clothing/accessory/flagpatch/assunzione
	flagpatch_national["flagpatch, dominia"] = /obj/item/clothing/accessory/flagpatch/dominia
	flagpatch_national["flagpatch, fisanduh"] = /obj/item/clothing/accessory/flagpatch/fisanduh
	flagpatch_national["flagpatch, pra"] = /obj/item/clothing/accessory/flagpatch/pra
	flagpatch_national["flagpatch, dpra"] = /obj/item/clothing/accessory/flagpatch/dpra
	flagpatch_national["flagpatch, nka"] = /obj/item/clothing/accessory/flagpatch/nka
	flagpatch_national["flagpatch, free council"] = /obj/item/clothing/accessory/flagpatch/freecouncil
	flagpatch_national["flagpatch, nralakk"] = /obj/item/clothing/accessory/flagpatch/nralakk
	flagpatch_national["flagpatch, hegemony"] = /obj/item/clothing/accessory/flagpatch/hegemony
	flagpatch_national["flagpatch, port antillia"] = /obj/item/clothing/accessory/flagpatch/portantillia
	flagpatch_national["flagpatch, sedantis"] = /obj/item/clothing/accessory/flagpatch/sedantis
	flagpatch_national["flagpatch, zo'ra"] = /obj/item/clothing/accessory/flagpatch/zora
	flagpatch_national["flagpatch, k'lax"] = /obj/item/clothing/accessory/flagpatch/klax
	flagpatch_national["flagpatch, c'thur"] = /obj/item/clothing/accessory/flagpatch/cthur
	gear_tweaks += new /datum/gear_tweak/path(flagpatch_national)

/datum/gear/accessory/aodai
	display_name = "ao dai"
	description = "A long, split tunic worn over trousers. Traditional on New Hai Phong."
	path = /obj/item/clothing/accessory/aodai
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/earth, /singleton/origin_item/origin/new_hai_phong)

/datum/gear/accessory/aodai/New()
	..()
	var/list/aodai = list()
	aodai["ao dai"] = /obj/item/clothing/accessory/aodai
	aodai["ao dai, new hai phong cut"] = /obj/item/clothing/accessory/aodai/nhp
	aodai["ao dai, masculine formalwear"] = /obj/item/clothing/accessory/aodai/masc
	gear_tweaks += new /datum/gear_tweak/path(aodai)

/datum/gear/accessory/temperature
	display_name = "temperature packs"
	description = "A nice little pack that heats/cools you when worn under your clothes!"
	path = /obj/item/clothing/accessory/temperature
	flags = 0

/datum/gear/accessory/temperature/New()
	..()
	var/list/temperature = list()
	for(var/temp_path in subtypesof(/obj/item/clothing/accessory/temperature))
		var/obj/item/clothing/accessory/temperature/temp_pack = temp_path
		temperature[initial(temp_pack.name)] = temp_path
	gear_tweaks += new /datum/gear_tweak/path(temperature)

/datum/gear/accessory/necklace
	display_name = "colored necklace selection"
	description = "A selection of already-colored necklaces."
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/accessory/necklace/New()
	..()
	var/list/colored = list()
	colored["necklace"] = /obj/item/clothing/accessory/necklace
	colored["golden"] = /obj/item/clothing/accessory/necklace/thin
	colored["silver"] = /obj/item/clothing/accessory/necklace/thin/silver
	colored["golden chain"] = /obj/item/clothing/accessory/necklace/chain
	colored["silver chain"] = /obj/item/clothing/accessory/necklace/chain/silver
	gear_tweaks += new /datum/gear_tweak/path(colored)

/datum/gear/accessory/necklace_uncolored
	display_name = "necklace selection (colorable)"
	description = "A selection of entirely colorable necklaces."
	path = /obj/item/clothing/accessory/necklace/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/necklace_uncolored/New()
	..()
	var/list/necklace_uncolored = list()
	necklace_uncolored["rounded"] = /obj/item/clothing/accessory/necklace/colorable
	necklace_uncolored["low hanging"] = /obj/item/clothing/accessory/necklace/colorable/low
	necklace_uncolored["small"] = /obj/item/clothing/accessory/necklace/colorable/small
	necklace_uncolored["golden dotted"] = /obj/item/clothing/accessory/necklace/colorable/twopiece
	necklace_uncolored["silver dotted"] = /obj/item/clothing/accessory/necklace/colorable/twopiece/silver
	necklace_uncolored["golden pendant"] = /obj/item/clothing/accessory/necklace/colorable/twopiece/pendant
	necklace_uncolored["silver pendant"] = /obj/item/clothing/accessory/necklace/colorable/twopiece/pendant/silver
	necklace_uncolored["large golden pendant"] = /obj/item/clothing/accessory/necklace/colorable/twopiece/pendant/fat
	necklace_uncolored["large silver pendant"] = /obj/item/clothing/accessory/necklace/colorable/twopiece/pendant/silver/fat
	gear_tweaks += new /datum/gear_tweak/path(necklace_uncolored)

/datum/gear/accessory/visegradi_sweater
	display_name = "visegradi patterned sweater"
	path = /obj/item/clothing/accessory/sweater/visegradi
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
