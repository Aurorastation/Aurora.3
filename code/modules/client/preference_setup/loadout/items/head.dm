/datum/gear/head
	display_name = "headwear, circuitry (empty)"
	path = /obj/item/clothing/head/circuitry
	sort_category = "Hats and Headwear"
	slot = slot_head

/datum/gear/head/New()
	..()
	gear_tweaks += list(GLOB.gear_tweak_hair_block)

/datum/gear/head/bandana
	display_name = "bandana selection"
	description = "A selection of bandanas. Comes in departmental colors."
	path = /obj/item/clothing/head/bandana
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/bandana/New()
	..()
	var/list/bandanas = list()
	bandanas["bandana"] = /obj/item/clothing/head/bandana
	bandanas["bandana, red"] = /obj/item/clothing/head/bandana/red
	bandanas["bandana, captain"] = /obj/item/clothing/head/bandana/captain
	bandanas["bandana, security"] = /obj/item/clothing/head/bandana/security
	bandanas["bandana, science"] = /obj/item/clothing/head/bandana/science
	bandanas["bandana, medical"] = /obj/item/clothing/head/bandana/medical
	bandanas["bandana, engineering"] = /obj/item/clothing/head/bandana/engineering
	bandanas["bandana, atmospherics"] = /obj/item/clothing/head/bandana/atmos
	bandanas["bandana, hydroponics"] = /obj/item/clothing/head/bandana/hydro
	bandanas["bandana, operations"] = /obj/item/clothing/head/bandana/cargo
	bandanas["bandana, mining"] = /obj/item/clothing/head/bandana/miner
	bandanas["bandana, janitor"] = /obj/item/clothing/head/bandana/janitor

	gear_tweaks += new /datum/gear_tweak/path(bandanas)

/datum/gear/head/softcap
	display_name = "softcap selection"
	description = "A selection of softcaps. Comes in departmental colors."
	path = /obj/item/clothing/head/softcap
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/softcap/New()
	..()
	var/list/softcaps = list()
	softcaps["softcap"] = /obj/item/clothing/head/softcap
	softcaps["softcap, rainbow"] = /obj/item/clothing/head/softcap/rainbow
	softcaps["softcap, red"] = /obj/item/clothing/head/softcap/red
	softcaps["softcap, captain"] = /obj/item/clothing/head/softcap/captain
	softcaps["softcap, security"] = /obj/item/clothing/head/softcap/security
	softcaps["softcap, science"] = /obj/item/clothing/head/softcap/science
	softcaps["softcap, medical"] = /obj/item/clothing/head/softcap/medical
	softcaps["softcap, engineering"] = /obj/item/clothing/head/softcap/engineering
	softcaps["softcap, atmospherics"] = /obj/item/clothing/head/softcap/atmos
	softcaps["softcap, hydroponics"] = /obj/item/clothing/head/softcap/hydro
	softcaps["softcap, operations"] = /obj/item/clothing/head/softcap/cargo
	softcaps["softcap, mining"] = /obj/item/clothing/head/softcap/miner
	softcaps["softcap, janitor"] = /obj/item/clothing/head/softcap/custodian

	gear_tweaks += new /datum/gear_tweak/path(softcaps)

/datum/gear/head/beret
	display_name = "beret selection"
	description = "A selection of berets. Comes in departmental colors."
	path = /obj/item/clothing/head/beret
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/beret/New()
	..()
	var/list/berets = list()
	berets["beret"] = /obj/item/clothing/head/beret
	berets["beret, red"] = /obj/item/clothing/head/beret/red
	berets["beret, captain"] = /obj/item/clothing/head/beret/captain
	berets["beret, security"] = /obj/item/clothing/head/beret/security
	berets["beret, science"] = /obj/item/clothing/head/beret/science
	berets["beret, medical"] = /obj/item/clothing/head/beret/medical
	berets["beret, engineering"] = /obj/item/clothing/head/beret/engineering
	berets["beret, atmospherics"] = /obj/item/clothing/head/beret/atmos
	berets["beret, hydroponics"] = /obj/item/clothing/head/beret/hydro
	berets["beret, operations"] = /obj/item/clothing/head/beret/cargo
	berets["beret, mining"] = /obj/item/clothing/head/beret/miner
	berets["beret, janitor"] = /obj/item/clothing/head/beret/janitor

	gear_tweaks += new /datum/gear_tweak/path(berets)

/datum/gear/head/hos
	display_name = "headwear, security (head of security)"
	description = "A selection of head of security headwear."
	path = /obj/item/clothing/head
	allowed_roles = list("Head of Security")

/datum/gear/head/hos/New()
	..()
	var/list/hoshead = list()
	hoshead["head of security hat"] = /obj/item/clothing/head/hos
	hoshead["head of security beret"] = /obj/item/clothing/head/beret/security/hos
	gear_tweaks += new /datum/gear_tweak/path(hoshead)

/datum/gear/head/hardhat
	display_name = "hard hat selection"
	path = /obj/item/clothing/head/hardhat
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Operations Manager", "Hangar Technician", "Shaft Miner", "Xenoarchaeologist", "Engineering Personnel", "Operations Personnel")

/datum/gear/head/hardhat/New()
	..()
	var/list/hardhat = list()
	hardhat["hard hat, operations yellow"] = /obj/item/clothing/head/hardhat
	hardhat["hard hat, command blue"] = /obj/item/clothing/head/hardhat/dblue
	hardhat["hard hat, engineering orange"] = /obj/item/clothing/head/hardhat/orange
	hardhat["hard hat, zavodskoi red"] = /obj/item/clothing/head/hardhat/red
	hardhat["hard hat, hephaestus green"] = /obj/item/clothing/head/hardhat/green
	gear_tweaks += new /datum/gear_tweak/path(hardhat)

/datum/gear/head/flowercrown
	display_name = "flowercrown selection"
	description = "A set of flowercrowns, perfect for the queen or even the king."
	path = /obj/item/clothing/head

/datum/gear/head/flowercrown/New()
	..()
	var/list/flowercrown = list()
	flowercrown["crown, sunflower"] = /obj/item/clothing/head/sunflower_crown
	flowercrown["crown, harebell"] = /obj/item/clothing/head/lavender_crown
	flowercrown["crown, poppy"] = /obj/item/clothing/head/poppy_crown
	gear_tweaks += new /datum/gear_tweak/path(flowercrown)

/datum/gear/head/hair_accessories
	display_name = "hair accessories selection"
	description = "A selection of hair accessories."
	path = /obj/item/clothing/head/pin
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/head/hair_accessories/New()
	..()
	var/list/hair_accessories = list()
	hair_accessories["hair pin, red flower"] = /obj/item/clothing/head/pin/flower
	hair_accessories["hair pin, blue flower"] = /obj/item/clothing/head/pin/flower/blue
	hair_accessories["hair pin, pink flower"] = /obj/item/clothing/head/pin/flower/pink
	hair_accessories["hair pin, yellow flower"] = /obj/item/clothing/head/pin/flower/yellow
	hair_accessories["hair pin, violet flower"] = /obj/item/clothing/head/pin/flower/violet
	hair_accessories["hair pin, orange flower"] = /obj/item/clothing/head/pin/flower/orange
	hair_accessories["hair pin, silversun dawnflower"] = /obj/item/clothing/head/pin/flower/silversun
	gear_tweaks += new /datum/gear_tweak/path(hair_accessories)

/datum/gear/head/hair_accessories_colourable
	display_name = "hair accessories selection (colourable)"
	description = "A selection of colourable hair accessories."
	path = /obj/item/clothing/head/pin
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/hair_accessories_colourable/New()
	..()
	var/list/hair_accessories_colourable = list()
	hair_accessories_colourable["hair ribbon, headband"] = /obj/item/clothing/head/pin/ribbon/head
	hair_accessories_colourable["hair bow"] = /obj/item/clothing/head/pin/ribbon/back
	hair_accessories_colourable["hair bow, small"] = /obj/item/clothing/head/pin/ribbon/small
	hair_accessories_colourable["hair pin"] = /obj/item/clothing/head/pin
	hair_accessories_colourable["hair pin, flower"] = /obj/item/clothing/head/pin/flower/white
	hair_accessories_colourable["hair pin, clover"] = /obj/item/clothing/head/pin/clover
	hair_accessories_colourable["hair pin, butterfly"] = /obj/item/clothing/head/pin/butterfly
	hair_accessories_colourable["hair pin, magnet"] = /obj/item/clothing/head/pin/magnetic
	gear_tweaks += new /datum/gear_tweak/path(hair_accessories_colourable)

/datum/gear/head/surgical
	display_name = "surgical cap selection"
	path = /obj/item/clothing/head/surgery/pmc
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Intern", "Xenobiologist", "Research Director", "Investigator", "Medical Personnel")

/datum/gear/head/surgical/New()
	..()
	var/list/surgical = list()
	surgical["surgical cap, nanotrasen navy blue"] = /obj/item/clothing/head/surgery
	surgical["surgical cap, zeng-hu purple"] = /obj/item/clothing/head/surgery/zeng
	surgical["surgical cap, PMCG blue"] = /obj/item/clothing/head/surgery/pmc
	surgical["surgical cap, PMCG grey"] = /obj/item/clothing/head/surgery/pmc/alt
	surgical["surgical cap, zavodskoi black"] = /obj/item/clothing/head/surgery/zavod
	surgical["surgical cap, idris green"] = /obj/item/clothing/head/surgery/idris
	gear_tweaks += new /datum/gear_tweak/path(surgical)

/datum/gear/head/iac
	display_name = "IAC headgear selection"
	description = "A selection of hats worn by Interstellar Aid Corps volunteers."
	path = /obj/item/clothing/head/softcap/iac
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Intern", "Medical Personnel")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/iac/New()
	..()
	var/list/iac = list()
	iac["IAC cap"] = /obj/item/clothing/head/softcap/iac
	iac["IAC beret"] = /obj/item/clothing/head/beret/iac
	gear_tweaks += new /datum/gear_tweak/path(iac)

/datum/gear/head/tcaf
	display_name = "tcaf hat selection"
	path = /obj/item/clothing/head/beret/legion
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/tcaf/New()
	..()
	var/list/tcaf = list()
	tcaf["tcaf beret, dress"] = /obj/item/clothing/head/beret/legion/tcaf
	tcaf["tcaf beret, field"] = /obj/item/clothing/head/beret/legion/tcaf/tcaf_field
	tcaf["tcfl beret, dress"] = /obj/item/clothing/head/beret/legion
	tcaf["tcfl beret, field"] = /obj/item/clothing/head/beret/legion/field
	tcaf["tcfl softcap"] = /obj/item/clothing/head/softcap/tcfl
	gear_tweaks += new /datum/gear_tweak/path(tcaf)

/datum/gear/head/peakedcap
	display_name = "corporate peaked cap selection"
	description = "A selection of corporate-colored peaked caps. Note that the cap should align with your character's chosen faction."
	path = /obj/item/clothing/head/peaked_cap
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	allowed_roles = list("Head of Security", "Security Officer", "Warden", "Investigator", "Security Personnel",
	"Captain", "Executive Officer")

/datum/gear/head/peakedcap/New()
	..()
	var/list/caps = list()
	caps["peaked cap, Zavodskoi Interstellar"] = /obj/item/clothing/head/peaked_cap/zavodskoi
	caps["peaked cap, Zavodskoi Interstellar, no logo"] = /obj/item/clothing/head/peaked_cap/zavodskoi/no_logo
	caps["peaked cap, Zavodskoi Interstellar, alt"] = /obj/item/clothing/head/peaked_cap/zavodskoi/alt
	caps["peaked cap, Zavodskoi Interstellar, alt, no logo"] = /obj/item/clothing/head/peaked_cap/zavodskoi/alt/no_logo
	caps["peaked cap, Idris Incorporated"] = /obj/item/clothing/head/peaked_cap/idris
	caps["peaked cap, Idris Incorporated, no logo"] = /obj/item/clothing/head/peaked_cap/idris/no_logo
	caps["peaked cap, Private Military Contracting Group"] = /obj/item/clothing/head/peaked_cap/pmcg
	caps["peaked cap, Private Military Contracting Group, no logo"] = /obj/item/clothing/head/peaked_cap/pmcg/no_logo
	gear_tweaks += new /datum/gear_tweak/path(caps)

/datum/gear/head/warden
	display_name = "headwear, security (warden)"
	description = "A selection of warden headwear."
	path = /obj/item/clothing/head
	allowed_roles = list("Head of Security" , "Warden", "Security Personnel")

/datum/gear/head/warden/New()
	..()
	var/list/wardenhead = list()
	wardenhead["warden hat, Zavodskoi Interstellar"] = /obj/item/clothing/head/warden/zavod
	wardenhead["warden hat, Zavodskoi Interstellar, alt"] = /obj/item/clothing/head/warden/zavod/alt
	wardenhead["warden hat, Idris Incorporated"] = /obj/item/clothing/head/warden/idris
	wardenhead["warden hat, Private Military Contracting Group"] = /obj/item/clothing/head/warden/pmc
	wardenhead["warden beret"] = /obj/item/clothing/head/beret/security/warden
	gear_tweaks += new /datum/gear_tweak/path(wardenhead)

/datum/gear/head/hats
	display_name = "hat selection"
	description = "A selection of hats."
	path = /obj/item/clothing/head/boaterhat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/head/hats/New()
	..()
	var/list/hats = list()
	hats["hat, boatsman"] = /obj/item/clothing/head/boaterhat
	hats["hat, bowler"] = /obj/item/clothing/head/bowler
	hats["hat, fez"] = /obj/item/clothing/head/fez
	hats["hat, beaver"] = /obj/item/clothing/head/beaverhat
	hats["hat, sombrero"] = /obj/item/clothing/head/sombrero
	hats["hat, bear pelt"] = /obj/item/clothing/head/bearpelt
	gear_tweaks += new /datum/gear_tweak/path(hats)

/datum/gear/head/hats_colourable
	display_name = "hat selection (colourable)"
	description = "A selection of colorable hats."
	path = /obj/item/clothing/head/flatcap/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/head/hats_colourable/New()
	..()
	var/list/hats_colourable = list()
	hats_colourable["hat, flatcap"] = /obj/item/clothing/head/flatcap/colourable
	hats_colourable["hat, feather trilby"] = /obj/item/clothing/head/feathertrilby
	hats_colourable["hat, woolen"] = /obj/item/clothing/head/wool
	hats_colourable["hat, fedora"] = /obj/item/clothing/head/fedora
	hats_colourable["hat, top hat"] = /obj/item/clothing/head/top_hat
	hats_colourable["hat, cowboy"] = /obj/item/clothing/head/cowboy
	hats_colourable["hat, cowboy wide"] = /obj/item/clothing/head/cowboy/wide
	hats_colourable["hat, sun hat"] = /obj/item/clothing/head/wide_hat
	hats_colourable["hat, sun hat with band"] = /obj/item/clothing/head/wide_hat/alt
	hats_colourable["hat, wide pointed"] = /obj/item/clothing/head/wide_hat/pointed
	hats_colourable["hat, wide pointed with band"] = /obj/item/clothing/head/wide_hat/pointed/alt
	hats_colourable["hat, headband"] = /obj/item/clothing/head/headbando
	hats_colourable["hat, bandana"] = /obj/item/clothing/head/bandana/colorable
	hats_colourable["hat, softcap"] = /obj/item/clothing/head/softcap/colorable
	hats_colourable["hat, softcap with accent"] = /obj/item/clothing/head/softcap/colorable/accent
	hats_colourable["hat, newsboy"] = /obj/item/clothing/head/softcap/newsboy
	hats_colourable["hat, visegradi nyakas"] = /obj/item/clothing/head/ushanka/cap
	hats_colourable["hat, beret"] = /obj/item/clothing/head/beret/colorable
	hats_colourable["hat, peaked beret"] = /obj/item/clothing/head/beret/peaked/colorable
	hats_colourable["hat, side cap"] = /obj/item/clothing/head/sidecap
	hats_colourable["hat, hijab"] = /obj/item/clothing/head/hijab
	hats_colourable["hat, hood"] = /obj/item/clothing/head/plain_hood
	hats_colourable["hat, turban"] = /obj/item/clothing/head/turban
	hats_colourable["hat, tanker cap"] = /obj/item/clothing/head/tanker
	hats_colourable["hat, ushanka"] = /obj/item/clothing/head/ushanka
	hats_colourable["hat, hairnet"] = /obj/item/clothing/head/hairnet
	gear_tweaks += new /datum/gear_tweak/path(hats_colourable)

/datum/gear/head/beanie
	display_name = "beanie selection"
	description = "A selection of beanies."
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/head/beanie/New()
	..()
	var/list/hats = list()
	hats["beanie"] = /obj/item/clothing/head/beanie
	hats["beanie, ear flap"] = /obj/item/clothing/head/beanie/earflap
	hats["beanie, submariner"] = /obj/item/clothing/head/beanie/submariner
	gear_tweaks += new /datum/gear_tweak/path(hats)

/datum/gear/head/bucket_hat
	display_name = "bucket hat selection"
	description = "A selection of bucket hats."
	path = /obj/item/clothing/head/bucket
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION

/datum/gear/head/bucket_hat/New()
	..()
	var/list/hats = list()
	hats["hat, bucket"] = /obj/item/clothing/head/bucket
	hats["hat, boonie"] = /obj/item/clothing/head/bucket/boonie
	hats["hat, camo boonie"] = /obj/item/clothing/head/bucket/boonie/camo
	gear_tweaks += new /datum/gear_tweak/path(hats)

/*
	Block Hair Adjustment
*/

GLOBAL_DATUM_INIT(gear_tweak_hair_block, /datum/gear_tweak/hair_block, new())

/datum/gear_tweak/hair_block/get_contents(var/metadata)
	return "Blocks Hair: [metadata]"

/datum/gear_tweak/hair_block/get_default()
	return "Default"

/datum/gear_tweak/hair_block/get_metadata(var/user, var/metadata)
	return tgui_input_list(user, "Choose whether you want your headgear to block hair, or use the headgear's default.", "Hair Blocking", list("Yes", "No", "Default"), metadata)

/datum/gear_tweak/hair_block/tweak_item(var/obj/item/clothing/head/H, var/metadata)
	if(!istype(H))
		return
	if(!H.allow_hair_covering)
		return
	switch(metadata)
		if("Yes")
			H.flags_inv |= BLOCKHEADHAIR
		if("No")
			H.flags_inv &= ~BLOCKHEADHAIR
