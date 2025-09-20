/datum/gear/drugs_meds
	display_name = "matchbox"
	path = /obj/item/storage/box/fancy/matches
	sort_category = "Drugs and Medicines"

/datum/gear/drugs_meds/zippo
	display_name = "zippo lighter selection"
	path = /obj/item/flame/lighter/zippo

/datum/gear/drugs_meds/zippo/New()
	..()
	var/list/zippolighters = list()
	zippolighters["regular zippo"] = /obj/item/flame/lighter/zippo
	zippolighters["nanotrasen zippo"] = /obj/item/flame/lighter/zippo/nt
	zippolighters["black zippo"] = /obj/item/flame/lighter/zippo/black
	zippolighters["black cross zippo"] = /obj/item/flame/lighter/zippo/black/cross
	zippolighters["golden zippo"] = /obj/item/flame/lighter/zippo/gold
	zippolighters["royal zippo"] = /obj/item/flame/lighter/zippo/royal
	zippolighters["dominian zippo"] = /obj/item/flame/lighter/zippo/dominia
	zippolighters["fisanduhian zippo"] = /obj/item/flame/lighter/zippo/fisanduh
	zippolighters["coalition zippo"] = /obj/item/flame/lighter/zippo/coalition
	zippolighters["solarian zippo"] = /obj/item/flame/lighter/zippo/sol
	zippolighters["biesellite zippo"] = /obj/item/flame/lighter/zippo/tcfl
	zippolighters["himeo zippo"] = /obj/item/flame/lighter/zippo/himeo
	zippolighters["san colettish zippo"] = /obj/item/flame/lighter/zippo/sancolette
	zippolighters["europan zippo"] = /obj/item/flame/lighter/zippo/europa
	zippolighters["gadpathurian zippo"] = /obj/item/flame/lighter/zippo/gadpathur
	zippolighters["luceian zippo"] = /obj/item/flame/lighter/zippo/luceian
	zippolighters["asoral jet lighter"] = /obj/item/flame/lighter/zippo/asoral
	zippolighters["nralakk zippo"] = /obj/item/flame/lighter/zippo/nralakk
	zippolighters["callistean lighter"] = /obj/item/flame/lighter/callisto
	gear_tweaks += new /datum/gear_tweak/path(zippolighters)

/datum/gear/drugs_meds/lighter
	display_name = "cheap lighter"
	path = /obj/item/flame/lighter/colourable
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/drugs_meds/cigarcase
	display_name = "cigar case"
	path = /obj/item/storage/box/fancy/cigarettes/cigar
	cost = 2

/datum/gear/drugs_meds/cigarettes
	display_name = "cigarette packet selection"
	description = "A selection of cigarette packets."
	path = /obj/item/storage/box/fancy/cigarettes
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/drugs_meds/cigarettes/New()
	..()
	var/list/cigarettes = list()
	cigarettes["Laissez-Faires cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/rugged
	cigarettes["Trans-Stellar Duty Free cigarette packet"] = /obj/item/storage/box/fancy/cigarettes
	cigarettes["DromedaryCo cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/dromedaryco
	cigarettes["Nico-Tine cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/nicotine
	cigarettes["Working Tajara cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/pra
	cigarettes["Shastar Leaves cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/dpra
	cigarettes["Royal Choice cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/nka
	cigarettes["Eriuyushi Sunset cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/federation
	cigarettes["Xaqixal Dyn Fields cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/dyn
	cigarettes["Natural Vysokan Soothsayer oracle cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/oracle
	cigarettes["Ha'zana Corsair Afterburners cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/koko
	gear_tweaks += new /datum/gear_tweak/path(cigarettes)

/datum/gear/drugs_meds/chew
	display_name = "chewing tobacco selection"
	description = "A selection of chewing tobacco."
	path = /obj/item/storage/chewables/tobacco
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/drugs_meds/chew/New()
	..()
	var/list/chews = list()
	chews["Rredouane Cuts chewing tobacco"] = /obj/item/storage/chewables/tobacco/bad
	chews["Mendell Smooth chewing tobacco"] = /obj/item/storage/chewables/tobacco
	chews["Taba-Kamu chewing tobacco"] = /obj/item/storage/chewables/tobacco/fine
	chews["Leviathan Chew chewing tobacco"] = /obj/item/storage/chewables/tobacco/federation
	chews["Weibi's Breeze chewing tobacco"] = /obj/item/storage/chewables/tobacco/dyn
	chews["box of Nico-Tine gum"] = /obj/item/storage/box/fancy/chewables/tobacco/nico
	chews["Ha'zana chewing koko"] = /obj/item/storage/chewables/tobacco/koko
	gear_tweaks += new /datum/gear_tweak/path(chews)

/datum/gear/drugs_meds/leaves
	display_name = "smokable leaf selection"
	description = "A selection of smokable leaves."
	path = /obj/item/storage/chewables/rollable
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/drugs_meds/leaves/New()
	..()
	var/list/leaves = list()
	leaves["S'th Kasavakh tobacco leaves"] = /obj/item/storage/chewables/rollable/unathi
	leaves["Agyre Lake tobacco leaves"] = /obj/item/storage/chewables/rollable
	leaves["Excelsior Epsilon tobacco leaves"] = /obj/item/storage/chewables/rollable/fine
	leaves["Golden Sol tobacco leaves"] = /obj/item/storage/chewables/rollable/nico
	leaves["Vysokan Plains oracle leaves"] = /obj/item/storage/chewables/rollable/oracle
	leaves["Velhalktai Marathon oracle leaves"] = /obj/item/storage/chewables/rollable/vedamor
	gear_tweaks += new /datum/gear_tweak/path(leaves)

/datum/gear/drugs_meds/pipe
	display_name = "pipe selection"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/drugs_meds/pipe/New()
	..()
	var/list/pipe = list()
	pipe["smoking pipe"] = /obj/item/clothing/mask/smokable/pipe
	pipe["smoking pipe, corn"] = /obj/item/clothing/mask/smokable/pipe/cobpipe
	gear_tweaks += new /datum/gear_tweak/path(pipe)

/datum/gear/drugs_meds/bonepipe
	display_name = "Europan bone pipe"
	path = /obj/item/clothing/mask/smokable/pipe/bonepipe
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/drugs_meds/cigfilters
	display_name = "cigarette filters"
	path = /obj/item/storage/cigfilters

/datum/gear/drugs_meds/cigpaper
	display_name = "cigarette paper selection"
	description = "A selection of cigarette papers."
	path = /obj/item/storage/box/fancy/cigpaper

/datum/gear/drugs_meds/cigpaper/New()
	..()
	var/list/cigpaper = list()
	cigpaper["Callistean Classic cigarette paper"] = /obj/item/storage/box/fancy/cigpaper
	cigpaper["Trident cigarette paper"] = /obj/item/storage/box/fancy/cigpaper/fine
	gear_tweaks += new /datum/gear_tweak/path(cigpaper)

/datum/gear/drugs_meds/ecig
	display_name = "electronic cigarette selection"
	description = "A selection of electronic cigarettes."
	path = /obj/item/clothing/mask/smokable/ecig

/datum/gear/drugs_meds/ecig/New()
	..()
	var/list/ecig = list()
	ecig["cheap electronic cigarette"] = /obj/item/clothing/mask/smokable/ecig/simple
	ecig["ordinary electronic cigarette"] = /obj/item/clothing/mask/smokable/ecig/util
	ecig["deluxe electronic cigarette"] = /obj/item/clothing/mask/smokable/ecig/deluxe
	gear_tweaks += new /datum/gear_tweak/path(ecig)

/datum/gear/drugs_meds/cigarettecase //loadout list for cigarette cases. add new custom one's here
	display_name = "cigarette cases selection"
	description = "A selection of empty cigarette cases."
	path = /obj/item/storage/box/fancy/cigarettes/case

/datum/gear/drugs_meds/cigarettecase/New()
	..()
	var/list/cigarettecase = list()
	cigarettecase["cigarette case"] = /obj/item/storage/box/fancy/cigarettes/case
	cigarettecase["cigarette case, decorated"] = /obj/item/storage/box/fancy/cigarettes/case/mus
	cigarettecase["cigarette case, sol"] = /obj/item/storage/box/fancy/cigarettes/case/sol
	cigarettecase["cigarette case, biesel"] = /obj/item/storage/box/fancy/cigarettes/case/tc
	gear_tweaks += new /datum/gear_tweak/path(cigarettecase)

/datum/gear/drugs_meds/psych_meds
	display_name = "psychiatric medicine selection"
	description = "A selection of prescription psychiatric medications. NOTICE: most of these are considered contraband if possessed without the relevant prescription noted in your medical records."
	path = /obj/item/reagent_containers/pill

/datum/gear/drugs_meds/psych_meds/New()
	..()
	var/list/psych_meds = list()
	psych_meds["Emoxanyl pills"] = /obj/item/storage/pill_bottle/emoxanyl
	psych_meds["Minaphobin pills"] = /obj/item/storage/pill_bottle/minaphobin/small
	psych_meds["Neurostabin pills"] = /obj/item/storage/pill_bottle/neurostabin
	psych_meds["Orastabin pills"] = /obj/item/storage/pill_bottle/orastabin
	psych_meds["Parvosil pills"] = /obj/item/storage/pill_bottle/parvosil
	psych_meds["Corophenidate pills"] = /obj/item/storage/pill_bottle/corophenidate
	gear_tweaks += new /datum/gear_tweak/path(psych_meds)

/datum/gear/drugs_meds/otc
	display_name = "OTC medicine selection"
	description = "A selection of over-the-counter medicines that do not require a prescription to carry."
	path = /obj/item/reagent_containers/pill

/datum/gear/drugs_meds/otc/New()
	..()
	var/list/otc = list()
	otc["Antidexafen pills"] = /obj/item/storage/pill_bottle/antidexafen
	otc["Vitamin supplement pills"] = /obj/item/storage/pill_bottle/vitamin
	otc["Cetahydramine pills"] = /obj/item/storage/pill_bottle/cetahydramine
	otc["Caffeine pills"] = /obj/item/storage/pill_bottle/caffeine
	otc["Nicotine pills"] = /obj/item/storage/pill_bottle/nicotine
	gear_tweaks += new /datum/gear_tweak/path(otc)

/datum/gear/drugs_meds/legal_rec
	display_name = "recreational drug selection"
	description = "A selection of recreational drugs that are legal to use in the Republic of Biesel. NOTICE: Even though these drugs are legal, your boss might not approve of you using them on-duty, and they may be illegal to carry in some foreign nations."
	path = /obj/item/reagent_containers/pill

/datum/gear/drugs_meds/legal_rec/New()
	..()
	var/list/legal_rec = list()
	legal_rec["Mercury Monolithium Sucrose inhaler"] = /obj/item/storage/box/mms_inhaler
	legal_rec["Dried ambrosia leaves"] = /obj/item/storage/box/ambrosia
	legal_rec["Dried reishi"] = /obj/item/storage/box/reishi
	legal_rec["Dried wulumunusha"] = /obj/item/storage/box/wulumunusha
	legal_rec["Colorspace pills"] = /obj/item/storage/pill_bottle/colorspace
	legal_rec["Snowflake pills"] = /obj/item/storage/pill_bottle/snowflake
	legal_rec["Psilocybin pills"] = /obj/item/storage/pill_bottle/psilocybin
	legal_rec["Wulumunusha extract bottle"] = /obj/item/reagent_containers/food/condiment/wulumunusha
	legal_rec["Ambrosia extract bottle"] = /obj/item/reagent_containers/food/condiment/ambrosia
	gear_tweaks += new /datum/gear_tweak/path(legal_rec)
