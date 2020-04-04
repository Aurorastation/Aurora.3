var/global/list/robot_modules = list(
	"Service" 		= /obj/item/robot_module/clerical/butler,
	"Clerical" 		= /obj/item/robot_module/clerical/general,
	"Research" 		= /obj/item/robot_module/research,
	"Mining" 		= /obj/item/robot_module/miner,
	"Rescue" 		= /obj/item/robot_module/medical/rescue,
	"Medical" 		= /obj/item/robot_module/medical/general,
	"Combat" 		= /obj/item/robot_module/combat,
	"Engineering"	= /obj/item/robot_module/engineering/general,
	"Construction"	= /obj/item/robot_module/engineering/construction,
	"Custodial" 	= /obj/item/robot_module/janitor
	)

/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	w_class = 100.0
	item_state = "electronic"
	flags = CONDUCT
	var/channels = list()
	var/networks = list()
	var/languages = list(							//Any listed language will be understandable. Any set to TRUE will be speakable
					LANGUAGE_SOL_COMMON =  TRUE,
					LANGUAGE_TRADEBAND =   TRUE,
					LANGUAGE_UNATHI =      FALSE,
					LANGUAGE_SIIK_MAAS =   FALSE,
					LANGUAGE_SKRELLIAN =   FALSE,
					LANGUAGE_GUTTER =      TRUE,
					LANGUAGE_VAURCESE =    FALSE,
					LANGUAGE_ROOTSONG =    FALSE,
					LANGUAGE_SIGN =        FALSE,
					LANGUAGE_SIGN_TAJARA = FALSE,
					LANGUAGE_SIIK_TAJR =   FALSE,
					LANGUAGE_AZAZIBA =     FALSE,
					LANGUAGE_DELVAHII =    FALSE,
					LANGUAGE_YA_SSA =      FALSE
					)
	var/sprites = list()
	var/can_be_pushed = TRUE
	var/no_slip = FALSE
	var/list/modules = list()
	var/list/datum/matter_synth/synths = list()
	var/obj/item/emag
	var/obj/item/malf_AI_module
	var/obj/item/borg/upgrade/jetpack
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/robot_module/New(var/mob/living/silicon/robot/R)
	..()
	R.module = src

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()

	R.set_module_sprites(sprites)
	R.icon_selected = FALSE
	R.icon_selection_tries = -1
	R.choose_icon()

	for(var/obj/item/I in modules)
		I.canremove = FALSE

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()
	R.set_module_sprites(list("Default" = "robot"))
	R.icon_selected = FALSE
	R.icon_selection_tries = -1
	R.choose_icon()

/obj/item/robot_module/Destroy()
	for(var/module in modules)
		qdel(module)
	for(var/synth in synths)
		qdel(synth)
	modules.Cut()
	synths.Cut()
	QDEL_NULL(emag)
	QDEL_NULL(jetpack)
	QDEL_NULL(malf_AI_module)
	return ..()

/obj/item/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	if(synths)
		for(var/datum/matter_synth/S in synths)
			S.emp_act(severity)
	..()
	return

/obj/item/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
	var/obj/item/extinguisher/E = locate() in src.modules
	var/obj/item/device/flash/F = locate() in src.modules
	if(F)
		if(F.broken)
			F.broken = FALSE
			F.times_used = 0
			F.icon_state = "flash"
		else if(F.times_used)
			F.times_used--

	if(E?.reagents.total_volume < E.reagents.maximum_volume)
		E.reagents.add_reagent("monoammoniumphosphate", E.max_water * 0.2)

	if(!synths?.len)
		return

	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		R.add_language(original_language, original_languages[original_language])
	original_languages.Cut()

/obj/item/robot_module/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/robot_module/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	R.verbs |= subsystems

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	R.verbs -= subsystems

/obj/item/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

/obj/item/robot_module/medical
	name = "medical robot module"
	channels = list("Medical" = TRUE)
	networks = list(NETWORK_MEDICAL)
	can_be_pushed = FALSE
	sprites = list(
			"Basic" = "robotmedi",
			"Landmate" = "landmatemedi",
			"Treadmate" = "treadmatemedi",
			"Treadhead" = "treadheadmedi",
			"Industrial" = "heavymedi",
			"Toileto-tron" = "toiletbotmedi",
			"Heph-Droid" = "droidrecolormedi",
			"HD-MAD" = "mcspizzytronmedi",
			"SD-MAD" = "floatspizzytronmedi",
			"Arachnotronic" = "arachnotronicmedi",
			"TC-Drone" = "dronerecolormedi",
			"Unbranded-MAD" = "offfloatspizzytronmedi",
			"Unbranded-Android" = "droid",
			)

/obj/item/robot_module/medical/general/New()
	..()
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/reagent_containers/borghypo/medical(src)
	src.modules += new /obj/item/surgery/scalpel(src)
	src.modules += new /obj/item/surgery/hemostat(src)
	src.modules += new /obj/item/surgery/retractor(src)
	src.modules += new /obj/item/surgery/cautery(src)
	src.modules += new /obj/item/surgery/bonegel(src)
	src.modules += new /obj/item/surgery/FixOVein(src)
	src.modules += new /obj/item/surgery/bonesetter(src)
	src.modules += new /obj/item/surgery/circular_saw(src)
	src.modules += new /obj/item/surgery/surgicaldrill(src)
	src.modules += new /obj/item/gripper/chemistry(src)
	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/autopsy_scanner(src)
	src.modules += new /obj/item/device/breath_analyzer(src)
	src.emag = new /obj/item/reagent_containers/hypospray/cmo(src)
	src.emag.reagents.add_reagent("wulumunusha", 30)
	src.emag.name = "Wulumunusha Hypospray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000)
	synths += medicine

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	N.uses_charge = TRUE
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	B.uses_charge = TRUE
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	src.modules += N
	src.modules += B

/obj/item/robot_module/medical/general/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(src.emag)
		var/obj/item/reagent_containers/hypospray/cmo/PS = src.emag
		PS.reagents.add_reagent("wulumunusha", 2 * amount)
	..()

/obj/item/robot_module/medical/rescue
	name = "rescue robot module"
	sprites = list(
			"Basic" = "robotmedi",
			"Landmate" = "landmatemedi",
			"Treadmate" = "treadmatemedi",
			"Treadhead" = "treadheadmedi",
			"Industrial" = "heavymedi",
			"Toileto-tron" = "toiletbotmedi",
			"Heph-Droid" = "droidrecolormedi",
			"HD-MAD" = "mcspizzytronmedi",
			"SD-MAD" = "floatspizzytronmedi",
			"Arachnotronic" = "arachnotronicmedi",
			"TC-Drone" = "dronerecolormedi",
			"Unbranded-MAD" = "offfloatspizzytronmedi",
			"Unbranded-Android" = "droid",
			)

	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/medical/rescue/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/device/breath_analyzer(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/reagent_containers/borghypo/rescue(src)
	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/extinguisher/mini(src)
	src.modules += new /obj/item/inflatable_dispenser(src) // Allows usage of inflatables. Since they are basically robotic alternative to EMTs, they should probably have them.
	src.modules += new /obj/item/device/gps(src) // for coordinating with medical suit health sensors console
	src.emag = new /obj/item/reagent_containers/hypospray/cmo(src)
	src.emag.reagents.add_reagent("wulumunusha", 30)
	src.emag.name = "Wulumunusha Hypospray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/ointment/O = new /obj/item/stack/medical/ointment(src)
	var/obj/item/stack/medical/bruise_pack/B = new /obj/item/stack/medical/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = TRUE
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	B.uses_charge = TRUE
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	S.uses_charge = TRUE
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	src.modules += O
	src.modules += B
	src.modules += S

/obj/item/robot_module/medical/rescue/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(src.emag)
		var/obj/item/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("wulumunusha", 2 * amount)
	..()

/obj/item/robot_module/engineering
	name = "engineering robot module"
	channels = list("Engineering" = TRUE)
	networks = list(NETWORK_ENGINEERING)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)
	sprites = list(
			"Basic" = "robotengi",
			"Landmate" = "landmateengi",
			"Treadmate" = "treadmateengi",
			"Treadhead" = "treadheadengi",
			"Industrial" = "heavyengi",
			"Toileto-tron" = "toiletbotengi",
			"Heph-Droid" = "droidrecolorengi",
			"HD-MAD" = "mcspizzytronengi",
			"SD-MAD" = "floatspizzytronengi",
			"Arachnotronic" = "arachnotronicengi",
			"TC-Drone" = "dronerecolorengi",
			"Unbranded-MAD" = "offfloatspizzytronengi",
			"Unbranded-Android" = "droid",
			)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/engineering/construction
	name = "construction robot module"
	no_slip = TRUE

/obj/item/robot_module/engineering/construction/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/powerdrill(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/rfd/construction/borg(src)
	src.modules += new /obj/item/screwdriver/robotic(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/weldingtool/experimental(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/device/t_scanner(src) // to check underfloor wiring
	src.modules += new /obj/item/device/analyzer(src) // to check air pressure in the area
	src.modules += new /obj/item/device/lightreplacer(src) // to install lightning in the area
	src.modules += new /obj/item/device/floor_painter(src)// to make america great again (c)
	src.modules += new /obj/item/inflatable_dispenser(src) // to stop those pesky humans being entering the zone
	src.modules += new /obj/item/pickaxe/borgdrill(src) // as station is being located at the rock terrain, which is presumed to be digged out to clear the area for new rooms
	src.emag = new /obj/item/gun/energy/plasmacutter/mounted(src)
	src.malf_AI_module += new /obj/item/rfd/transformer(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(80000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(40000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(60000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(60)
	synths += metal
	synths += plasteel
	synths += glass
	synths += wire

	var/obj/item/stack/material/cyborg/steel/M = new /obj/item/stack/material/cyborg/steel(src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/material/cyborg/plasteel/S = new /obj/item/stack/material/cyborg/plasteel(src)
	S.synths = list(plasteel)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new /obj/item/stack/material/cyborg/glass/reinforced(src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/floor/cyborg/FT = new /obj/item/stack/tile/floor/cyborg(src) // to add floor over the metal rods lattice
	FT.synths = list(metal)
	src.modules += FT

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src) // Let there be light electric said and after that did cut the wire
	C.synths = list(wire)
	src.modules += C

/obj/item/robot_module/engineering/general/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/powerdrill(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/weldingtool/largetank(src)
	src.modules += new /obj/item/screwdriver/robotic(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/wirecutters/robotic(src)
	src.modules += new /obj/item/device/multitool/robotic(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/taperoll/engineering(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/device/floor_painter(src)
	src.modules += new /obj/item/inflatable_dispenser(src)
	src.emag = new /obj/item/melee/baton/robot/arm(src)
	src.malf_AI_module += new /obj/item/rfd/transformer(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(60000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(45)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(20000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(15000)
	synths += metal
	synths += glass
	synths += plasteel
	synths += wire
	synths += wood
	synths += plastic

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new /obj/item/stack/material/cyborg/glass/reinforced(src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/material/cyborg/plasteel/PL = new /obj/item/stack/material/cyborg/plasteel(src)
	PL.synths = list(plasteel)
	src.modules += PL

	var/obj/item/stack/material/cyborg/wood/W = new /obj/item/stack/material/cyborg/wood(src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PS = new /obj/item/stack/material/cyborg/plastic(src)
	PS.synths = list(plastic)
	src.modules += PS

	var/obj/item/stack/tile/wood/cyborg/FWT = new /obj/item/stack/tile/wood/cyborg(src)
	FWT.synths = list(wood)
	src.modules += FWT

	var/obj/item/stack/tile/floor_white/cyborg/FTW = new /obj/item/stack/tile/floor_white/cyborg(src)
	FTW.synths = list(plastic)
	src.modules += FTW

	var/obj/item/stack/tile/floor_freezer/cyborg/FTF = new /obj/item/stack/tile/floor_freezer/cyborg(src)
	FTF.synths = list(plastic)
	src.modules += FTF

	var/obj/item/stack/tile/floor_dark/cyborg/FTD = new /obj/item/stack/tile/floor_dark/cyborg(src)
	FTD.synths = list(plasteel)
	src.modules += FTD

/obj/item/robot_module/janitor
	name = "custodial robot module"
	channels = list("Service" = TRUE)
	networks = list(NETWORK_SERVICE)
	sprites = list(
			"Basic" = "robotjani",
			"Landmate" = "landmatejani",
			"Treadmate" = "treadmatejani",
			"Treadhead" = "treadheadjani",
			"Industrial" = "heavyjani",
			"Toileto-tron" = "toiletbotjani",
			"Heph-Droid" = "droidrecolorjani",
			"HD-MAD" = "mcspizzytronjani",
			"SD-MAD" = "floatspizzytronjani",
			"Arachnotronic" = "arachnotronicjani",
			"TC-Drone" = "dronerecolorjani",
			"Unbranded-MAD" = "offfloatspizzytronjani",
			"Unbranded-Android" = "droid",
			)

/obj/item/robot_module/janitor/New()
	..()
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/soap/nanotrasen(src)
	src.modules += new /obj/item/storage/bag/trash(src)
	src.modules += new /obj/item/mop(src)
	src.modules += new /obj/item/device/lightreplacer/advanced(src)
	src.modules += new /obj/item/reagent_containers/glass/bucket(src) // a hydroponist's bucket
	src.modules += new /obj/item/matter_decompiler(src) // free drone remains for all
	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("lube", 250)
	src.emag.name = "Lube spray"

/obj/item/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

/obj/item/robot_module/clerical
	name = "service robot module"
	channels = list("Service" = TRUE)
	networks = list(NETWORK_SERVICE)
	languages = list(
					LANGUAGE_SOL_COMMON =  TRUE,
					LANGUAGE_TRADEBAND =   TRUE,
					LANGUAGE_UNATHI =      TRUE,
					LANGUAGE_SIIK_MAAS =   TRUE,
					LANGUAGE_SKRELLIAN =   TRUE,
					LANGUAGE_GUTTER =      TRUE,
					LANGUAGE_VAURCESE =    FALSE,
					LANGUAGE_ROOTSONG =    TRUE,
					LANGUAGE_SIGN =        FALSE,
					LANGUAGE_SIGN_TAJARA = FALSE,
					LANGUAGE_SIIK_TAJR =   FALSE,
					LANGUAGE_AZAZIBA =     FALSE,
					LANGUAGE_DELVAHII =    FALSE,
					LANGUAGE_YA_SSA =      FALSE
					)

	sprites = list(
			"Basic" = "robotserv",
			"Landmate" = "landmateserv",
			"Treadmate" = "treadmateserv",
			"Treadhead" = "treadheadserv",
			"Industrial" = "heavysci",
			"Toileto-tron" = "toiletbotserv",
			"Heph-Droid" = "droidrecolorserv",
			"HD-MAD" = "mcspizzytronserv",
			"SD-MAD" = "floatspizzytronserv",
			"Arachnotronic" = "arachnotronicserv",
			"TC-Drone" = "dronerecolorserv",
			"Unbranded-MAD" = "offfloatspizzytronserv",
			"Unbranded-Android" = "droid",
			  	)

/obj/item/robot_module/clerical/butler/New()
	..()
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/gripper/service(src)
	src.modules += new /obj/item/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/material/minihoe(src)
	src.modules += new /obj/item/material/hatchet(src)
	src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/storage/bag/plants(src)
	src.modules += new /obj/item/robot_harvester(src)
	src.modules += new /obj/item/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/material/knife(src)
	src.modules += new /obj/item/soap(src) // a cheap bar of soap
	src.modules += new /obj/item/reagent_containers/glass/rag(src) // a rag for.. yeah.. the primary tool of bartender

	var/obj/item/rfd/service/M = new /obj/item/rfd/service(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = TRUE
	src.modules += L

	src.modules += new /obj/item/tray/robotray(src)
	src.modules += new /obj/item/reagent_containers/borghypo/service(src)
	src.emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/R = new /datum/reagents(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"

/obj/item/robot_module/clerical/general
	name = "clerical robot module"

/obj/item/robot_module/clerical/general/New()
	..()
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/pen/robopen(src)
	src.modules += new /obj/item/form_printer(src)
	src.modules += new /obj/item/gripper/paperwork(src)
	src.modules += new /obj/item/hand_labeler(src)
	src.modules += new /obj/item/tape_roll(src) //allows it to place flyers
	src.modules += new /obj/item/device/nanoquikpay(src)
	src.emag = new /obj/item/stamp/chameleon(src)

/obj/item/robot_module/miner
	name = "miner robot module"
	channels = list("Supply" = TRUE)
	networks = list(NETWORK_MINE)
	sprites = list(
			"Basic" = "robotmine",
			"Landmate" = "landmatemine",
			"Treadmate" = "treadmatemine",
			"Treadhead" = "treadheadmine",
			"Industrial" = "heavymine",
			"Toileto-tron" = "toiletbotmine",
			"Heph-Droid" = "droidrecolormine",
			"HD-MAD" = "mcspizzytronmine",
			"SD-MAD" = "floatspizzytronmine",
			"Arachnotronic" = "arachnotronicmine",
			"TC-Drone" = "dronerecolormine",
			"Unbranded-MAD" = "offfloatspizzytronmine",
			"Unbranded-Android" = "droid",
			)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/miner/New()
	..()
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/screwdriver/robotic(src)
	src.modules += new /obj/item/storage/bag/ore(src)
	src.modules += new /obj/item/pickaxe/borgdrill(src)
	src.modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/gripper/miner(src)
	src.modules += new /obj/item/mining_scanner(src)
	src.modules += new /obj/item/device/gps/mining(src) // for locating itself in the deep space
	src.modules += new /obj/item/gun/custom_ka/cyborg(src)
	src.emag = new /obj/item/gun/energy/plasmacutter/mounted(src)

/obj/item/robot_module/research
	name = "research module"
	channels = list("Science" = TRUE)
	networks = list(NETWORK_RESEARCH)
	sprites = list(
			"Basic" = "robotjani",
			"Landmate" = "landmatejani",
			"Treadmate" = "treadmatejani",
			"Treadhead" = "treadheadsci",
			"Industrial" = "heavysci",
			"Toileto-tron" = "toiletbotsci",
			"Heph-Droid" = "droidrecolorsci",
			"HD-MAD" = "mcspizzytronsci",
			"SD-MAD" = "floatspizzytronsci",
			"Arachnotronic" = "arachnotronicsci",
			"TC-Drone" = "dronerecolorsci",
			"Unbranded-MAD" = "offfloatspizzytronsci",
			"Unbranded-Android" = "droid",
			)

/obj/item/robot_module/research/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/portable_destructive_analyzer(src)
	src.modules += new /obj/item/gripper/research(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/robotanalyzer(src)
	src.modules += new /obj/item/card/robot(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/screwdriver(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/surgery/scalpel(src)
	src.modules += new /obj/item/surgery/circular_saw(src)
	src.modules += new /obj/item/extinguisher/mini(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/gripper/chemistry(src)
	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/storage/bag/plants(src)
	src.modules += new /obj/item/pen/robopen(src)
	src.emag = new /obj/item/hand_tele(src)

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = TRUE
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

/obj/item/robot_module/syndicate
	name = "syndicate robot module"
	languages = list(
					LANGUAGE_SOL_COMMON =  TRUE,
					LANGUAGE_TRADEBAND =   TRUE,
					LANGUAGE_UNATHI =      TRUE,
					LANGUAGE_SIIK_MAAS =   TRUE,
					LANGUAGE_SKRELLIAN =   TRUE,
					LANGUAGE_GUTTER =      TRUE,
					LANGUAGE_VAURCESE =    FALSE,
					LANGUAGE_ROOTSONG =    TRUE,
					LANGUAGE_SIGN =        FALSE,
					LANGUAGE_SIGN_TAJARA = FALSE,
					LANGUAGE_SIIK_TAJR =   FALSE,
					LANGUAGE_AZAZIBA =     FALSE,
					LANGUAGE_DELVAHII =    FALSE,
					LANGUAGE_YA_SSA =      FALSE
					)

	sprites = list(
					"Bloodhound" = "syndie_bloodhound",
					"Treadhound" = "syndie_treadhound",
					"HD-MAD" = "mcspizzytronsyndi",
					"Industrial" = "heavysyndi",
					"Heph-Android" = "droid",
					"Arachnotronic" = "arachnotronicsyndi",
					"Toileto-tron" = "syndi-medi",
					)

/obj/item/robot_module/syndicate/New(var/mob/living/silicon/robot/R)
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/melee/energy/sword(src)
	src.modules += new /obj/item/gun/energy/mountedsmg(src)
	src.modules += new /obj/item/gun/energy/net/mounted(src)
	src.modules += new /obj/item/gun/launcher/grenade/cyborg(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/robot_emag(src)
	src.modules += new /obj/item/handcuffs/cyborg(src)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/combat
	name = "combat robot module"
	channels = list("Security" = TRUE)
	networks = list(NETWORK_SECURITY)
	sprites = list("Roller" = "droid-combat")
	can_be_pushed = FALSE
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/combat/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/sec(src)
	src.modules += new /obj/item/gun/energy/laser/mounted(src)
	src.modules += new /obj/item/melee/hammer/powered(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.emag = new /obj/item/gun/energy/lasercannon/mounted(src)

/obj/item/robot_module/drone
	name = "drone module"
	no_slip = TRUE
	networks = list(NETWORK_ENGINEERING)

/obj/item/robot_module/drone/New(var/mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/weldingtool(src)
	src.modules += new /obj/item/screwdriver/robotic(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/wirecutters/robotic(src)
	src.modules += new /obj/item/device/multitool/robotic(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/soap(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/device/floor_painter(src)

	robot.internals = new /obj/item/tank/jetpack/carbondioxide(src)
	src.modules += robot.internals

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(25000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(25000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(4000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(2000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(15)
	synths += metal
	synths += glass
	synths += wood
	synths += plastic
	synths += wire

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/P = new (src)
	P.synths = list(plastic)
	src.modules += P

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	channels = list("Engineering" = TRUE)
	languages = list()

/obj/item/robot_module/drone/construction/New()
	..()
	src.modules += new /obj/item/rfd/construction/borg(src)

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()
	return

/obj/item/robot_module/mining_drone
	name = "mining drone module"
	no_slip = TRUE
	networks = list(NETWORK_MINE)

/obj/item/robot_module/mining_drone/proc/set_up_default(var/mob/living/silicon/robot/R, var/drill = TRUE)
	modules += new /obj/item/device/flash(src)
	modules += new /obj/item/borg/sight/material(src)
	if(drill)
		modules += new /obj/item/pickaxe/drill(src)
	modules += new /obj/item/storage/bag/ore/drone(src)
	modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	modules += new /obj/item/gripper/miner(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/mining_scanner(src)
	modules += new /obj/item/device/gps/mining(src)
	modules += new /obj/item/tank/jetpack/carbondioxide(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(20000)
	synths += metal
	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	modules += rods

	emag = new /obj/item/gun/energy/plasmacutter/mounted(src)
	emag.name = "Mounted Plasma Cutter"

/obj/item/robot_module/mining_drone/basic/New(mob/living/silicon/robot/robot)
	..()
	set_up_default(src)

/obj/item/robot_module/mining_drone/drill/New(mob/living/silicon/robot/robot)
	..()
	set_up_default(src, FALSE)
	modules += new /obj/item/pickaxe/jackhammer(src)

/obj/item/robot_module/mining_drone/ka/New(mob/living/silicon/robot/robot)
	..()
	set_up_default(src)
	modules += new /obj/item/gun/custom_ka/cyborg(src)

/obj/item/robot_module/mining_drone/drillandka/New(mob/living/silicon/robot/robot)
	..()
	set_up_default(src, FALSE)
	modules += new /obj/item/pickaxe/jackhammer(src)
	modules += new /obj/item/gun/custom_ka/cyborg(src)

/obj/item/robot_module/bluespace
	name = "bluespace robot module"
	languages = list(
					LANGUAGE_TCB =         TRUE,
					LANGUAGE_GUTTER =      TRUE,
					LANGUAGE_SIGN =        TRUE,
					LANGUAGE_TRADEBAND =   TRUE,
					LANGUAGE_UNATHI =      TRUE,
					LANGUAGE_AZAZIBA =     TRUE,
					LANGUAGE_SIIK_MAAS =   TRUE,
					LANGUAGE_SIIK_TAJR =   TRUE,
					LANGUAGE_SIGN_TAJARA = TRUE,
					LANGUAGE_SKRELLIAN =   TRUE,
					LANGUAGE_SOL_COMMON =  TRUE,
					LANGUAGE_ROOTSONG =    TRUE,
					LANGUAGE_VAURCA =      TRUE,
					LANGUAGE_ROBOT =       TRUE,
					LANGUAGE_DRONE =       TRUE,
					LANGUAGE_EAL =         TRUE,
					LANGUAGE_VOX =         TRUE,
					LANGUAGE_CHANGELING =  TRUE,
					LANGUAGE_BORER =       TRUE
					)
	channels = list(
		"Service" =       TRUE,
		"Supply" =        TRUE,
		"Science" =       TRUE,
		"Security" =      TRUE,
		"Engineering" =   TRUE,
		"Medical" =       TRUE,
		"Command" =       TRUE,
		"Response Team" = TRUE,
		"AI Private" =    TRUE
		)
	sprites = list("Roller" = "droid-combat") //TMP // temp my left nut
	can_be_pushed = FALSE

/obj/item/robot_module/bluespace/New(var/mob/living/silicon/robot/R)
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/borg/sight/hud/sec(src)
	src.modules += new /obj/item/rfd/construction/borg/infinite(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/weldingtool/largetank(src)
	src.modules += new /obj/item/screwdriver/robotic(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/crowbar/robotic(src)
	src.modules += new /obj/item/wirecutters/robotic(src)
	src.modules += new /obj/item/device/multitool/robotic(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/inflatable_dispenser(src)
	// Medical
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/reagent_containers/borghypo/medical(src)
	src.modules += new /obj/item/surgery/scalpel(src)
	src.modules += new /obj/item/surgery/hemostat(src)
	src.modules += new /obj/item/surgery/retractor(src)
	src.modules += new /obj/item/surgery/cautery(src)
	src.modules += new /obj/item/surgery/bonegel(src)
	src.modules += new /obj/item/surgery/FixOVein(src)
	src.modules += new /obj/item/surgery/bonesetter(src)
	src.modules += new /obj/item/surgery/circular_saw(src)
	src.modules += new /obj/item/surgery/surgicaldrill(src)
	src.modules += new /obj/item/gripper/chemistry(src)
	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/reagent_containers/borghypo/rescue(src)
	src.modules += new /obj/item/roller_holder(src)
	// Security
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/melee/hammer/powered(src)
	src.modules += new /obj/item/gun/energy/lasercannon/mounted/cyborg/overclocked(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	// BST
	src.modules += new/obj/item/card/id/bst(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(60000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(45)
	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000)
	synths += metal
	synths += glass
	synths += plasteel
	synths += wire
	synths += medicine

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/RO = new /obj/item/stack/rods/cyborg(src)
	RO.synths = list(metal)
	src.modules += RO

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/material/cyborg/plasteel/PL = new (src)
	PL.synths = list(plasteel)
	src.modules += PL

	var/obj/item/stack/tile/floor_dark/cyborg/FTD = new (src)
	FTD.synths = list(plasteel)
	src.modules += FTD

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	src.modules += N
	src.modules += B

/obj/item/robot_module/bluespace/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/melee/baton/robot/B = locate() in src.modules
	if(B?.bcell)
		B.bcell.give(amount)
	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()