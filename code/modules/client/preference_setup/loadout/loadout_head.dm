/datum/gear/head
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/New()
	..()
	gear_tweaks += list(gear_tweak_hair_block)

/datum/gear/head/ushanka_grey
	display_name = "ushanka, grey"
	path = /obj/item/clothing/head/ushanka/grey

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

/datum/gear/head/bandana_color
	display_name = "bandana (colorable)"
	path = /obj/item/clothing/head/bandana/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

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
	softcaps["softcap, tcfl"] = /obj/item/clothing/head/softcap/tcfl

	gear_tweaks += new /datum/gear_tweak/path(softcaps)

/datum/gear/head/softcap_color
	display_name = "softcap (colorable)"
	path = /obj/item/clothing/head/softcap/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

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

/datum/gear/head/beret_color
	display_name = "beret (colorable)"
	path = /obj/item/clothing/head/beret/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/sidecap
	display_name = "side cap"
	path = /obj/item/clothing/head/sidecap
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/warden
	display_name = "headwear, security (warden)"
	description = "A selection of warden headwear."
	path = /obj/item/clothing/head
	allowed_roles = list("Head of Security" , "Warden")

/datum/gear/head/warden/New()
	..()
	var/list/wardenhead = list()
	wardenhead["warden hat, zavod"] = /obj/item/clothing/head/warden/zavod
	wardenhead["warden hat, zavod alt"] = /obj/item/clothing/head/warden/zavod/alt
	wardenhead["warden hat, idris"] = /obj/item/clothing/head/warden/idris
	wardenhead["warden hat, pmc"] = /obj/item/clothing/head/warden/pmc
	wardenhead["warden beret"] = /obj/item/clothing/head/beret/security/warden
	gear_tweaks += new /datum/gear_tweak/path(wardenhead)

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
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Operations Manager", "Hangar Technician", "Shaft Miner", "Xenoarchaeologist")

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

/datum/gear/head/hats
	display_name = "hat selection"
	description = "A selection of hats."
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/hats/New()
	..()
	var/list/hats = list()
	hats["hat, boatsman"] = /obj/item/clothing/head/boaterhat
	hats["hat, bowler"] = /obj/item/clothing/head/bowler
	hats["hat, fez"] = /obj/item/clothing/head/fez
	hats["hat, tophat"] = /obj/item/clothing/head/that
	hats["hat, feather trilby"] = /obj/item/clothing/head/feathertrilby
	hats["hat, striped black fedora"] = /obj/item/clothing/head/fedora
	hats["hat, black fedora"] = /obj/item/clothing/head/fedora/black
	hats["hat, brown fedora"] = /obj/item/clothing/head/fedora/brown
	hats["hat, dark brown fedora"] = /obj/item/clothing/head/fedora/brown/dark
	hats["hat, grey fedora"] = /obj/item/clothing/head/fedora/grey
	hats["hat, beaver"] = /obj/item/clothing/head/beaverhat
	hats["hat, cowboy"] = /obj/item/clothing/head/cowboy
	hats["hat, wide-brimmed cowboy"] = /obj/item/clothing/head/cowboy/wide
	hats["hat, sombrero"] = /obj/item/clothing/head/sombrero
	hats["hat, flatcap"] = /obj/item/clothing/head/flatcap
	gear_tweaks += new /datum/gear_tweak/path(hats)

/datum/gear/head/hats_colourable
	display_name = "hat selection (colourable)"
	description = "A selection of hats."
	path = /obj/item/clothing/head/flatcap/colourable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/hats_colourable/New()
	..()
	var/list/hats_colourable = list()
	hats_colourable["hat, flatcap"] = /obj/item/clothing/head/flatcap/colourable
	hats_colourable["hat, feather trilby"] = /obj/item/clothing/head/feathertrilby/colourable
	hats_colourable["hat, woolen"] = /obj/item/clothing/head/wool
	gear_tweaks += new /datum/gear_tweak/path(hats_colourable)

/datum/gear/head/hijab
	display_name = "hijab selection"
	path = /obj/item/clothing/head/hijab
	slot = slot_r_ear

/datum/gear/head/hijab/New()
	..()
	var/list/hijab = list()
	hijab["white hijab"] = /obj/item/clothing/head/hijab
	hijab["grey hijab"] = /obj/item/clothing/head/hijab/grey
	hijab["red hijab"] = /obj/item/clothing/head/hijab/red
	hijab["brown hijab"] = /obj/item/clothing/head/hijab/brown
	hijab["green hijab"] = /obj/item/clothing/head/hijab/green
	hijab["blue hijab"] = /obj/item/clothing/head/hijab/blue
	hijab["black hijab"] = /obj/item/clothing/head/hijab/black

	gear_tweaks += new /datum/gear_tweak/path(hijab)

/datum/gear/head/hijab_colorable
	display_name = "colorable hijab"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
	slot = slot_r_ear

/datum/gear/head/turban
	display_name = "turban selection"
	path = /obj/item/clothing/head/turban

/datum/gear/head/turban/New()
	..()
	var/list/turbans = list()
	turbans["black turban"] = /obj/item/clothing/head/turban
	turbans["blue turban"] = /obj/item/clothing/head/turban/blue
	turbans["green turban"] = /obj/item/clothing/head/turban/green
	turbans["grey turban"] = /obj/item/clothing/head/turban/grey
	turbans["orange turban"] = /obj/item/clothing/head/turban/orange
	turbans["purple turban"] = /obj/item/clothing/head/turban/purple
	turbans["red turban"] = /obj/item/clothing/head/turban/red
	turbans["white turban"] = /obj/item/clothing/head/turban/white
	turbans["yellow turban"] = /obj/item/clothing/head/turban/yellow

	gear_tweaks += new /datum/gear_tweak/path(turbans)

/datum/gear/head/turban_colourable
	display_name = "turban (colourable)"
	path = /obj/item/clothing/head/turban/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/surgical
	display_name = "surgical cap selection"
	path = /obj/item/clothing/head/surgery/pmc
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "First Responder", "Medical Intern", "Xenobiologist", "Research Director", "Investigator")

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

/datum/gear/head/headbando
	display_name = "basic headband"
	path = /obj/item/clothing/head/headbando
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beanie
	display_name = "beanie"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/nonla
	display_name = "non la hat"
	path = /obj/item/clothing/head/nonla
	origin_restriction = list(/singleton/origin_item/origin/earth, /singleton/origin_item/origin/new_hai_phong)
/datum/gear/head/konyang
	display_name = "gat"
	path = /obj/item/clothing/head/konyang

/datum/gear/head/hachimaki
	display_name = "konyanger hachimaki"
	path = /obj/item/clothing/head/hachimaki
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/iac
	display_name = "IAC headgear selection"
	description = "A selection of hats worn by Interstellar Aid Corps volunteers."
	path = /obj/item/clothing/head/softcap/iac
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "First Responder", "Medical Intern")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/iac/New()
	..()
	var/list/iac = list()
	iac["IAC cap"] = /obj/item/clothing/head/softcap/iac
	iac["IAC beret"] = /obj/item/clothing/head/beret/iac
	gear_tweaks += new /datum/gear_tweak/path(iac)

/datum/gear/head/circuitry
	display_name = "headwear, circuitry (empty)"
	path = /obj/item/clothing/head/circuitry

/datum/gear/head/tcfl
	display_name = "tcfl hat selection"
	path = /obj/item/clothing/head/beret/legion
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/tcfl/New()
	..()
	var/list/tcfl = list()
	tcfl["tcfl beret, dress"] = /obj/item/clothing/head/beret/legion
	tcfl["tcfl beret, field"] = /obj/item/clothing/head/beret/legion/field
	gear_tweaks += new /datum/gear_tweak/path(tcfl)

/datum/gear/head/padded_cap
	display_name = "padded cap"
	path = /obj/item/clothing/head/padded
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/himeo
	display_name = "himean cap"
	path = /obj/item/clothing/head/softcap/himeo
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/himeo, /singleton/origin_item/origin/ipc_himeo, /singleton/origin_item/origin/free_council)

/datum/gear/head/vysoka
	display_name = "vysokan fur cap selection"
	description = "A fur hat from Vysoka made of authentic ohdker fur."
	path = /obj/item/clothing/head/vysoka
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/vysoka, /singleton/origin_item/origin/ipc_vysoka)

/datum/gear/head/vysoka/New()
	..()
	var/list/vysoka = list()
	vysoka["fur cap"] = /obj/item/clothing/head/vysoka
	vysoka["fur cap, purple"] = /obj/item/clothing/head/vysoka/purple
	vysoka["fur cap, blue"] = /obj/item/clothing/head/vysoka/blue
	vysoka["fur cap, red"] = /obj/item/clothing/head/vysoka/red
	gear_tweaks += new /datum/gear_tweak/path(vysoka)

/datum/gear/head/joku
	display_name = "vysokan joku cap"
	description = "A warm-looking expensive cap made from fine, dyed dalakyhr fur."
	path = /obj/item/clothing/head/vysoka/joku
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/vysoka, /singleton/origin_item/origin/ipc_vysoka)

/datum/gear/head/joku/New()
	..()
	var/list/joku = list()
	joku["fancy cap"] = /obj/item/clothing/head/vysoka/joku
	joku["fancy cap, purple"] = /obj/item/clothing/head/vysoka/joku/purple
	joku["fancy cap, blue"] = /obj/item/clothing/head/vysoka/joku/blue
	joku["fancy cap, red"] = /obj/item/clothing/head/vysoka/joku/red
	gear_tweaks += new /datum/gear_tweak/path(joku)

/datum/gear/head/dainshu
	display_name = "vysokan dainshu feather"
	description = "The feather of a Vysokan dainshu, a domesticated flying beast."
	path = /obj/item/clothing/head/pin/dainshu
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/vysoka, /singleton/origin_item/origin/ipc_vysoka)

/datum/gear/head/buckethat
	display_name = "bucket hat"
	path = /obj/item/clothing/head/buckethat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/bridge_crew_cap_alt
	display_name = "san colettish bridge crew cap"
	path = /obj/item/clothing/head/caphat/bridge_crew/alt
	allowed_roles = list("Bridge Crew", "Captain", "Executive Officer")

/datum/gear/head/gadpathur
	display_name = "gadpathurian headgear selection"
	description = "A selection of headgear from Gadpathur."
	path = /obj/item/clothing/head/gadpathur
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/gear/head/gadpathur/New()
	..()
	var/list/gadpathur = list()
	gadpathur["gadpathurian sidecap"] = /obj/item/clothing/head/gadpathur
	gadpathur["gadpathurian beret"] = /obj/item/clothing/head/beret/gadpathur
	gadpathur["gadpathurian engineer beret"] = /obj/item/clothing/head/beret/gadpathur/engineer
	gadpathur["gadpathurian medical beret"] = /obj/item/clothing/head/beret/gadpathur/medical
	gadpathur["gadpathurian turban"] = /obj/item/clothing/head/turban/gadpathur
	gadpathur["gadpathurian patrol cap"] = /obj/item/clothing/head/ushanka/gadpathur
	gear_tweaks += new /datum/gear_tweak/path(gadpathur)

/datum/gear/head/dominia
	display_name = "fisanduhian ushanka"
	path = /obj/item/clothing/head/ushanka/dominia
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/dominia_consular
	display_name = "dominian consular cap"
	path = /obj/item/clothing/head/dominia
	allowed_roles = list("Consular Officer")

/datum/gear/head/hairnet
	display_name = "hairnet"
	path = /obj/item/clothing/head/hairnet
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/head/nyakas
	display_name = "visegradi nyakas"
	path = /obj/item/clothing/head/ushanka/nyakas
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/*
	Block Hair Adjustment
*/
var/datum/gear_tweak/hair_block/gear_tweak_hair_block = new()

/datum/gear_tweak/hair_block/get_contents(var/metadata)
	return "Blocks Hair: [metadata]"

/datum/gear_tweak/hair_block/get_default()
	return "Default"

/datum/gear_tweak/hair_block/get_metadata(var/user, var/metadata)
	return input(user, "Choose whether you want your headgear to block hair, or use the headgear's default.", "Hair Blocking", metadata) as anything in list("Yes", "No", "Default")

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
