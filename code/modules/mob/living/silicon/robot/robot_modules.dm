var/global/list/robot_modules = list(
	"Service" 		= /obj/item/robot_module/service/butler,
	"Clerical" 		= /obj/item/robot_module/service/general,
	"Research" 		= /obj/item/robot_module/research,
	"Mining" 		= /obj/item/robot_module/miner,
	"Rescue" 		= /obj/item/robot_module/medical/rescue,
	"Medical" 		= /obj/item/robot_module/medical/general,
	"Engineering"	= /obj/item/robot_module/engineering/general,
	"Construction"	= /obj/item/robot_module/engineering/construction,
	"Custodial" 	= /obj/item/robot_module/janitor
)

/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	w_class = ITEMSIZE_IMMENSE
	item_state = "electronic"
	flags = CONDUCT
	var/channels = list()
	var/networks = list()
	var/languages = list( // Any listed language will be understandable. Any set to TRUE will be speakable
		LANGUAGE_SOL_COMMON =  TRUE,
		LANGUAGE_ELYRAN_STANDARD = TRUE,
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
	var/specialized_access_type = /datum/job/assistant // an job we take access from. Used to mirror job's IDs for specific borg modules.

/obj/item/robot_module/Initialize(mapload, var/mob/living/silicon/robot/R)
	. = ..()

	R.module = src

	modules += new /obj/item/inductive_charger(src)

	add_camera_networks(R)
	handle_languages(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()

	R.set_module_sprites(sprites)
	R.icon_selected = FALSE
	R.choose_icon()

/obj/item/robot_module/proc/handle_languages(var/mob/living/silicon/robot/R)
	return

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()
	R.set_module_sprites(list("Default" = "robot"))
	R.icon_selected = FALSE
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
	var/obj/item/extinguisher/E = locate() in modules
	var/obj/item/device/flash/F = locate() in modules
	if(F)
		if(F.broken)
			F.broken = FALSE
			F.times_used = 0
			F.icon_state = "flash"
		else if(F.times_used)
			F.times_used--

	if(E.reagents && (REAGENTS_FREE_SPACE(E.reagents) > 0))
		E.reagents.add_reagent(/decl/reagent/toxin/fertilizer/monoammoniumphosphate, E.max_water * 0.2)

	if(!synths.len)
		return

	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

	for(var/obj/item/stack/SM in modules)
		SM.update_icon()

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
	channels = list(CHANNEL_MEDICAL = TRUE)
	networks = list(NETWORK_MEDICAL)
	can_be_pushed = FALSE
	sprites = list(
		"Basic" = 	       list(ROBOT_CHASSIS = "robot_medi", ROBOT_PANEL = "robot_medi", ROBOT_EYES = "robot"),
		"Landmate" =       list(ROBOT_CHASSIS = "landmate_medi", ROBOT_PANEL = "landmate_medi", ROBOT_EYES = "landmate"),
		"Treadmate" =      list(ROBOT_CHASSIS = "treadmate_medi", ROBOT_PANEL = "treadmate_medi", ROBOT_EYES = "treadmate"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_medi", ROBOT_PANEL = "treadhead_medi", ROBOT_EYES = "treadhead"),
		"Spiffy" = 	   	   list(ROBOT_CHASSIS = "mcspizzy_medi", ROBOT_PANEL = "mcspizzy_medi", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_medi", ROBOT_PANEL = "tauceti_medi", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_medi", ROBOT_PANEL = "sputnik_medi", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_medi", ROBOT_PANEL = "kent_medi", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_medi", ROBOT_PANEL = "wide_medi", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_medi", ROBOT_PANEL = "cricket_medi", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_medi", ROBOT_PANEL = "quaddex_medi", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_medi", ROBOT_PANEL = "arthrodroid_medi", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_medi", ROBOT_PANEL = "spiderbot_medi", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_medi", ROBOT_PANEL = "heavy_medi", ROBOT_EYES = "heavy_medi"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_medi", ROBOT_PANEL = "positron03_medi", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_medi", ROBOT_PANEL = "plantasonic_medi", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_medi", ROBOT_PANEL = "coolermaster_medi", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_medi", ROBOT_PANEL = "phage_medi", ROBOT_EYES = "phage")
	)
	specialized_access_type = /datum/job/doctor

/obj/item/robot_module/medical/general/Initialize()
	. = ..()
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/reagent_containers/hypospray/borghypo/medical(src)
	modules += new /obj/item/surgery/scalpel(src)
	modules += new /obj/item/surgery/hemostat(src)
	modules += new /obj/item/surgery/retractor(src)
	modules += new /obj/item/surgery/cautery(src)
	modules += new /obj/item/surgery/bone_gel(src)
	modules += new /obj/item/surgery/fix_o_vein(src)
	modules += new /obj/item/surgery/bonesetter(src)
	modules += new /obj/item/surgery/circular_saw(src)
	modules += new /obj/item/surgery/surgicaldrill(src)
	modules += new /obj/item/gripper/chemistry(src)
	modules += new /obj/item/reagent_containers/dropper/cyborg_pipette(src)
	modules += new /obj/item/roller_holder(src)
	modules += new /obj/item/reagent_containers/syringe(src)
	modules += new /obj/item/device/reagent_scanner/adv(src)
	modules += new /obj/item/device/mass_spectrometer(src)
	modules += new /obj/item/autopsy_scanner(src)
	modules += new /obj/item/device/breath_analyzer(src)
	modules += new /obj/item/taperoll/medical(src)
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	emag = new /obj/item/reagent_containers/hypospray/cmo(src)
	emag.reagents.add_reagent(/decl/reagent/wulumunusha, 30)
	emag.name = "Wulumunusha Hypospray"

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
	modules += N
	modules += B

/obj/item/robot_module/medical/general/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/reagent_containers/hypospray/cmo/PS = emag
		PS.reagents.add_reagent(/decl/reagent/wulumunusha, 2 * amount)
	..()

/obj/item/robot_module/medical/rescue
	name = "rescue robot module"
	specialized_access_type = /datum/job/med_tech
// If anyone wants to make custom rescue robot sprites, be my guest.

/obj/item/robot_module/medical/rescue/Initialize()
	. = ..()
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/device/reagent_scanner/adv(src)
	modules += new /obj/item/device/mass_spectrometer(src)
	modules += new /obj/item/device/breath_analyzer(src)
	modules += new /obj/item/roller_holder(src)
	modules += new /obj/item/reagent_containers/hypospray/borghypo/rescue(src)
	modules += new /obj/item/reagent_containers/dropper/cyborg_pipette(src)
	modules += new /obj/item/reagent_containers/syringe(src)
	modules += new /obj/item/gripper/chemistry(src)
	modules += new /obj/item/tank/jetpack/carbondioxide/synthetic(src)
	modules += new /obj/item/borg/rescue/mobility(src)
	modules += new /obj/item/taperoll/medical(src)
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	modules += new /obj/item/gripper/paperwork(src)
	emag = new /obj/item/reagent_containers/hypospray/cmo(src)
	emag.reagents.add_reagent(/decl/reagent/wulumunusha, 30)
	emag.name = "Wulumunusha Hypospray"

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
	modules += O
	modules += B
	modules += S

/obj/item/robot_module/medical/rescue/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent(/decl/reagent/wulumunusha, 2 * amount)
	..()

/obj/item/robot_module/engineering
	name = "engineering robot module"
	channels = list(CHANNEL_ENGINEERING = TRUE)
	networks = list(NETWORK_ENGINEERING)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)
	sprites = list(
		"Basic" =          list(ROBOT_CHASSIS = "robot_engi", ROBOT_PANEL = "robot", ROBOT_EYES = "robot"),
		"Landmate" =       list(ROBOT_CHASSIS = "landmate_engi", ROBOT_PANEL = "landmate", ROBOT_EYES = "landmate"),
		"Treadmate" =      list(ROBOT_CHASSIS = "treadmate_engi", ROBOT_PANEL = "treadmate", ROBOT_EYES = "treadmate"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_engi", ROBOT_PANEL = "treadhead", ROBOT_EYES = "treadhead"),
		"Spiffy" =         list(ROBOT_CHASSIS = "mcspizzy_engi", ROBOT_PANEL = "mcspizzy", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_engi", ROBOT_PANEL = "tauceti", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_engi", ROBOT_PANEL = "sputnik", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_engi", ROBOT_PANEL = "kent", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_engi", ROBOT_PANEL = "wide", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_engi", ROBOT_PANEL = "cricket", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_engi", ROBOT_PANEL = "quaddex", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_engi", ROBOT_PANEL = "arthrodroid", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_engi", ROBOT_PANEL = "spiderbot", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_engi",  ROBOT_PANEL = "heavy", ROBOT_EYES = "heavy_engi"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_engi", ROBOT_PANEL = "positron03", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_engi", ROBOT_PANEL = "plantasonic", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_engi", ROBOT_PANEL = "coolermaster", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_engi", ROBOT_PANEL = "phage", ROBOT_EYES = "phage")
	)
	specialized_access_type = /datum/job/engineer

/obj/item/robot_module/engineering/construction
	name = "construction robot module"
	no_slip = TRUE

/obj/item/robot_module/engineering/construction/Initialize()
	. = ..()
	modules += new /obj/item/powerdrill(src)
	modules += new /obj/item/rfd/construction/borg(src)
	modules += new /obj/item/rfd/piping/borg(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/weldingtool/experimental(src)
	modules += new /obj/item/device/pipe_painter(src)
	modules += new /obj/item/gripper/no_use/loader(src)
	modules += new /obj/item/gripper(src)
	modules += new /obj/item/device/t_scanner(src) // to check underfloor wiring
	modules += new /obj/item/device/analyzer(src) // to check air pressure in the area
	modules += new /obj/item/device/lightreplacer(src) // to install lightning in the area
	modules += new /obj/item/device/floor_painter(src)// to make america great again (c)
	modules += new /obj/item/pickaxe/borgdrill(src) // as station is being located at the rock terrain, which is presumed to be digged out to clear the area for new rooms
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	modules += new /obj/item/pen/robopen(src) // Pen for renaming doors
	emag = new /obj/item/gun/energy/plasmacutter/mounted(src)
	malf_AI_module += new /obj/item/rfd/transformer(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(80000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(40000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(60000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(60)
	var/datum/matter_synth/cloth = new /datum/matter_synth/cloth(50000)
	synths += metal
	synths += plasteel
	synths += glass
	synths += wire
	synths += cloth

	var/obj/item/stack/material/cyborg/steel/M = new /obj/item/stack/material/cyborg/steel(src)
	M.synths = list(metal)
	modules += M

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	modules += rods

	var/obj/item/stack/material/cyborg/plasteel/S = new /obj/item/stack/material/cyborg/plasteel(src)
	S.synths = list(plasteel)
	modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new /obj/item/stack/material/cyborg/glass/reinforced(src)
	RG.synths = list(metal, glass)
	modules += RG

	var/obj/item/stack/material/cyborg/cloth/CL = new /obj/item/stack/material/cyborg/cloth(src)
	CL.synths = list(cloth)
	modules += CL

	var/obj/item/stack/tile/floor/cyborg/FT = new /obj/item/stack/tile/floor/cyborg(src) // to add floor over the metal rods lattice
	FT.synths = list(metal)
	modules += FT

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src) // Let there be light electric said and after that did cut the wire
	C.synths = list(wire)
	modules += C

/obj/item/robot_module/engineering/general/Initialize()
	. = ..()
	modules += new /obj/item/powerdrill(src)
	modules += new /obj/item/weldingtool/largetank(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/wirecutters/robotic(src)
	modules += new /obj/item/device/multitool/robotic(src)
	modules += new /obj/item/rfd/piping/borg(src)
	modules += new /obj/item/device/t_scanner(src)
	modules += new /obj/item/device/analyzer(src)
	modules += new /obj/item/gripper(src)
	modules += new /obj/item/gripper/no_use/loader(src)
	modules += new /obj/item/device/lightreplacer(src)
	modules += new /obj/item/device/pipe_painter(src)
	modules += new /obj/item/device/floor_painter(src)
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	modules += new /obj/item/pen/robopen(src) // Pen for renaming doors
	emag = new /obj/item/melee/baton/robot/arm(src)
	malf_AI_module += new /obj/item/rfd/transformer(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(60000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(45)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(20000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(15000)
	var/datum/matter_synth/cloth = new /datum/matter_synth/cloth(50000)
	synths += metal
	synths += glass
	synths += plasteel
	synths += wire
	synths += wood
	synths += plastic
	synths += cloth

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	modules += G

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	modules += rods

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new /obj/item/stack/material/cyborg/glass/reinforced(src)
	RG.synths = list(metal, glass)
	modules += RG

	var/obj/item/stack/material/cyborg/plasteel/PL = new /obj/item/stack/material/cyborg/plasteel(src)
	PL.synths = list(plasteel)
	modules += PL

	var/obj/item/stack/material/cyborg/wood/W = new /obj/item/stack/material/cyborg/wood(src)
	W.synths = list(wood)
	modules += W

	var/obj/item/stack/material/cyborg/plastic/PS = new /obj/item/stack/material/cyborg/plastic(src)
	PS.synths = list(plastic)
	modules += PS

	var/obj/item/stack/material/cyborg/cloth/CL = new /obj/item/stack/material/cyborg/cloth(src)
	CL.synths = list(cloth)
	modules += CL

	var/obj/item/stack/tile/wood/cyborg/FWT = new /obj/item/stack/tile/wood/cyborg(src)
	FWT.synths = list(wood)
	modules += FWT

	var/obj/item/stack/tile/floor_white/cyborg/FTW = new /obj/item/stack/tile/floor_white/cyborg(src)
	FTW.synths = list(plastic)
	modules += FTW

	var/obj/item/stack/tile/floor_freezer/cyborg/FTF = new /obj/item/stack/tile/floor_freezer/cyborg(src)
	FTF.synths = list(plastic)
	modules += FTF

	var/obj/item/stack/tile/floor_dark/cyborg/FTD = new /obj/item/stack/tile/floor_dark/cyborg(src)
	FTD.synths = list(plasteel)
	modules += FTD

/obj/item/robot_module/janitor
	name = "custodial robot module"
	channels = list(CHANNEL_SERVICE = TRUE)
	networks = list(NETWORK_SERVICE)
	sprites = list(
		"Basic" =          list(ROBOT_CHASSIS = "robot_jani", ROBOT_PANEL = "robot", ROBOT_EYES = "robot"),
		"Landmate" =       list(ROBOT_CHASSIS = "landmate_jani", ROBOT_PANEL = "landmate", ROBOT_EYES = "landmate"),
		"Treadmate" =      list(ROBOT_CHASSIS = "treadmate_jani", ROBOT_PANEL = "treadmate", ROBOT_EYES = "treadmate"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_jani", ROBOT_PANEL = "treadhead", ROBOT_EYES = "treadhead"),
		"Spiffy" =         list(ROBOT_CHASSIS = "mcspizzy_jani", ROBOT_PANEL = "mcspizzy", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_jani", ROBOT_PANEL = "tauceti", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_jani", ROBOT_PANEL = "sputnik", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_jani", ROBOT_PANEL = "kent", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_jani", ROBOT_PANEL = "wide", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_jani", ROBOT_PANEL = "cricket", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_jani", ROBOT_PANEL = "quaddex", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_jani", ROBOT_PANEL = "arthrodroid", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_jani", ROBOT_PANEL = "spiderbot", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_jani",  ROBOT_PANEL = "heavy_jani", ROBOT_EYES = "heavy_jani"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_jani", ROBOT_PANEL = "positron03", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_jani", ROBOT_PANEL = "plantasonic", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_jani", ROBOT_PANEL = "coolermaster", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_jani", ROBOT_PANEL = "phage", ROBOT_EYES = "phage")
	)

	var/mopping = FALSE
	specialized_access_type = /datum/job/janitor

/obj/item/robot_module/janitor/Initialize()
	. = ..()
	modules += new /obj/item/soap/drone(src)
	modules += new /obj/item/storage/bag/trash(src)
	modules += new /obj/item/mop(src)
	modules += new /obj/item/device/lightreplacer/advanced(src)
	modules += new /obj/item/reagent_containers/glass/bucket(src) // a hydroponist's bucket
	modules += new /obj/item/matter_decompiler(src) // free drone remains for all
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	emag = new /obj/item/reagent_containers/spray(src)
	emag.reagents.add_reagent(/decl/reagent/lube, 250)
	emag.name = "Lube spray"

/obj/item/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in modules
	LR.Charge(R, amount)
	if(emag)
		var/obj/item/reagent_containers/spray/S = emag
		S.reagents.add_reagent(/decl/reagent/lube, 2 * amount)

/obj/item/robot_module/service
	name = "service robot module"
	channels = list(CHANNEL_SERVICE = TRUE)
	networks = list(NETWORK_SERVICE)
	languages = list(
		LANGUAGE_SOL_COMMON =  TRUE,
		LANGUAGE_ELYRAN_STANDARD = TRUE,
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
		"Basic" =          list(ROBOT_CHASSIS = "robot_serv", ROBOT_PANEL = "robot", ROBOT_EYES = "robot"),
		"Landmate" =       list(ROBOT_CHASSIS = "landmate_serv", ROBOT_PANEL = "landmate", ROBOT_EYES = "landmate"),
		"Treadmate" =      list(ROBOT_CHASSIS = "treadmate_serv", ROBOT_PANEL = "treadmate", ROBOT_EYES = "treadmate"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_serv", ROBOT_PANEL = "treadhead", ROBOT_EYES = "treadhead"),
		"Spiffy" =         list(ROBOT_CHASSIS = "mcspizzy_serv", ROBOT_PANEL = "mcspizzy", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_serv", ROBOT_PANEL = "tauceti", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_serv", ROBOT_PANEL = "sputnik", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_serv", ROBOT_PANEL = "kent", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_serv", ROBOT_PANEL = "wide", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_serv", ROBOT_PANEL = "cricket", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_serv", ROBOT_PANEL = "quaddex", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_serv", ROBOT_PANEL = "arthrodroid", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_serv", ROBOT_PANEL = "spiderbot", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_serv",  ROBOT_PANEL = "heavy_serv", ROBOT_EYES = "heavy_serv"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_serv", ROBOT_PANEL = "positron03", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_serv", ROBOT_PANEL = "plantasonic", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_serv", ROBOT_PANEL = "coolermaster", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_serv", ROBOT_PANEL = "phage", ROBOT_EYES = "phage")
	)

	specialized_access_type = /datum/job/janitor

/obj/item/robot_module/service/butler/Initialize()
	. = ..()
	modules += new /obj/item/gripper/service(src)
	modules += new /obj/item/reagent_containers/glass/bucket(src)
	modules += new /obj/item/material/minihoe(src)
	modules += new /obj/item/material/hatchet(src)
	modules += new /obj/item/device/analyzer/plant_analyzer(src)
	modules += new /obj/item/storage/bag/plants(src)
	modules += new /obj/item/robot_harvester(src)
	modules += new /obj/item/material/kitchen/rollingpin(src)
	modules += new /obj/item/material/knife(src)
	modules += new /obj/item/soap/drone(src)
	modules += new /obj/item/pen/robopen(src)
	modules += new /obj/item/form_printer(src)
	modules += new /obj/item/gripper/paperwork(src)
	modules += new /obj/item/device/hand_labeler(src)
	modules += new /obj/item/tape_roll(src) //allows it to place flyers
	modules += new /obj/item/device/nanoquikpay(src)
	modules += new /obj/item/reagent_containers/glass/rag(src) // a rag for.. yeah.. the primary tool of bartender
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.

	var/obj/item/rfd/service/M = new /obj/item/rfd/service(src)
	M.stored_matter = 30
	modules += M

	modules += new /obj/item/reagent_containers/dropper/cyborg_pipette(src)

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = TRUE
	modules += L

	modules += new /obj/item/tray/robotray(src)
	modules += new /obj/item/reagent_containers/hypospray/borghypo/service(src)
	emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/RG = new /datum/reagents(50)
	emag.reagents = RG
	RG.my_atom = emag
	RG.add_reagent(/decl/reagent/polysomnine/beer2, 50)
	emag.name = "Mickey Finn's Special Brew"

/obj/item/robot_module/service/general
	name = "clerical robot module"
	channels = list(CHANNEL_SUPPLY = TRUE, CHANNEL_COMMAND = TRUE)
	networks = list(NETWORK_MINE)

/obj/item/robot_module/service/general/Initialize()
	. = ..()
	modules += new /obj/item/pen/robopen(src)
	modules += new /obj/item/form_printer(src)
	modules += new /obj/item/gripper/paperwork(src)
	modules += new /obj/item/device/hand_labeler(src)
	modules += new /obj/item/device/destTagger(src)
	modules += new /obj/item/stamp(src)
	modules += new /obj/item/stamp/denied(src)
	modules += new /obj/item/tape_roll(src) //allows it to place flyers
	modules += new /obj/item/device/nanoquikpay(src)
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/taperoll/police(src)
	modules += new /obj/item/paper_scanner(src) //TODO: Add functionality to allow for scanned paperwork to show up in internal computer
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	emag = new /obj/item/stamp/chameleon(src)

/obj/item/robot_module/miner
	name = "miner robot module"
	channels = list(CHANNEL_SUPPLY = TRUE)
	networks = list(NETWORK_MINE)
	sprites = list(
		"Basic" =          list(ROBOT_CHASSIS = "robot_mine", ROBOT_PANEL = "robot", ROBOT_EYES = "robot"),
		"Landmate" =       list(ROBOT_CHASSIS = "landmate_mine", ROBOT_PANEL = "landmate", ROBOT_EYES = "landmate"),
		"Treadmate" =      list(ROBOT_CHASSIS = "treadmate_mine", ROBOT_PANEL = "treadmate", ROBOT_EYES = "treadmate"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_mine", ROBOT_PANEL = "treadhead", ROBOT_EYES = "treadhead"),
		"Spiffy" =         list(ROBOT_CHASSIS = "mcspizzy_mine", ROBOT_PANEL = "mcspizzy", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_mine", ROBOT_PANEL = "tauceti", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_mine", ROBOT_PANEL = "sputnik", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_mine", ROBOT_PANEL = "kent", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_mine", ROBOT_PANEL = "wide", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_mine", ROBOT_PANEL = "cricket", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_mine", ROBOT_PANEL = "quaddex", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_mine", ROBOT_PANEL = "arthrodroid", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_mine", ROBOT_PANEL = "spiderbot", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_mine",  ROBOT_PANEL = "heavy_mine", ROBOT_EYES = "heavy_mine"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_mine", ROBOT_PANEL = "positron03", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_mine", ROBOT_PANEL = "plantasonic", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_mine", ROBOT_PANEL = "coolermaster", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_mine", ROBOT_PANEL = "phage", ROBOT_EYES = "phage")
	)

	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/miner/Initialize()
	. = ..()
	modules += new /obj/item/storage/bag/ore(src)
	modules += new /obj/item/pickaxe/borgdrill(src)
	modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	modules += new /obj/item/gripper/miner(src)
	modules += new /obj/item/rfd/mining(src)
	modules += new /obj/item/ore_detector(src)
	modules += new /obj/item/mining_scanner(src)
	modules += new /obj/item/ore_radar(src)
	modules += new /obj/item/gripper/paperwork(src) // for Yield Declarations
	modules += new /obj/item/device/gps/mining(src) // for locating itself in the deep space
	modules += new /obj/item/gun/custom_ka/cyborg(src)
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/storage/part_replacer(src)
	modules += new /obj/item/tank/jetpack/carbondioxide/synthetic(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(80000)
	synths += metal

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	modules += rods

	var/obj/item/stack/flag/purple/borg/F = new /obj/item/stack/flag/purple/borg(src)
	F.synths = list(metal)
	modules += F

	emag = new /obj/item/gun/energy/plasmacutter/mounted(src)

/obj/item/robot_module/research
	name = "research module"
	channels = list(
		CHANNEL_SCIENCE = TRUE,
		CHANNEL_SUPPLY  = TRUE
	)
	networks = list(NETWORK_RESEARCH)
	sprites = list(
		"Basic" =          list(ROBOT_CHASSIS = "robot_sci", ROBOT_PANEL = "robot", ROBOT_EYES = "robot"),
		"Landmate" =       list(ROBOT_CHASSIS = "landmate_sci", ROBOT_PANEL = "landmate", ROBOT_EYES = "landmate"),
		"Treadmate" =      list(ROBOT_CHASSIS = "treadmate_sci", ROBOT_PANEL = "treadmate", ROBOT_EYES = "treadmate"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_sci", ROBOT_PANEL = "treadhead", ROBOT_EYES = "treadhead"),
		"Spiffy" =         list(ROBOT_CHASSIS = "mcspizzy_sci", ROBOT_PANEL = "mcspizzy", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_sci", ROBOT_PANEL = "tauceti", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_sci", ROBOT_PANEL = "sputnik", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_sci", ROBOT_PANEL = "kent", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_sci", ROBOT_PANEL = "wide", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_sci", ROBOT_PANEL = "cricket", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_sci", ROBOT_PANEL = "quaddex", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_sci", ROBOT_PANEL = "arthrodroid", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_sci", ROBOT_PANEL = "spiderbot", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_sci",  ROBOT_PANEL = "heavy_sci", ROBOT_EYES = "heavy_sci"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_sci", ROBOT_PANEL = "positron03", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_sci", ROBOT_PANEL = "plantasonic", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_sci", ROBOT_PANEL = "coolermaster", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_sci", ROBOT_PANEL = "phage", ROBOT_EYES = "phage")
	)

/obj/item/robot_module/research/Initialize()
	. = ..()
	modules += new /obj/item/portable_destructive_analyzer(src)
	modules += new /obj/item/gripper/research(src)
	modules += new /obj/item/robot_harvester(src)
	modules += new /obj/item/gripper/no_use/loader(src)
	modules += new /obj/item/device/robotanalyzer(src)
	modules += new /obj/item/card/robot(src)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire(15)
	synths += wire
	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

	modules += new /obj/item/weldingtool/experimental(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/screwdriver(src)
	modules += new /obj/item/wirecutters/robotic(src)
	modules += new /obj/item/surgery/scalpel(src)
	modules += new /obj/item/surgery/circular_saw(src)
	modules += new /obj/item/reagent_containers/syringe(src)
	modules += new /obj/item/gripper/chemistry(src)
	modules += new /obj/item/reagent_containers/dropper/cyborg_pipette(src)
	modules += new /obj/item/device/reagent_scanner/adv(src)
	modules += new /obj/item/storage/bag/plants(src)
	modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	modules += new /obj/item/extinguisher(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	modules += new /obj/item/pen/robopen(src) // Pen for renaming robots
	modules += new /obj/item/storage/part_replacer(src)
	modules += new /obj/item/device/multitool/robotic(src) // To enable them to connect machines that require multitools e.g. tech-processors
	emag = new /obj/item/hand_tele(src)

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = TRUE
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	modules += N

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(15000)
	synths += metal

	var/obj/item/stack/material/cyborg/steel/M = new /obj/item/stack/material/cyborg/steel(src)
	M.synths = list(metal)
	modules += M

/obj/item/robot_module/combat
	name = "combat robot module"
	languages = list(
		LANGUAGE_SOL_COMMON =  TRUE,
		LANGUAGE_ELYRAN_STANDARD = TRUE,
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
		"Basic" = 	       list(ROBOT_CHASSIS = "robot_syndi", ROBOT_PANEL = "robot_syndi", ROBOT_EYES = "robot"),
		"Bloodhound" =     list(ROBOT_CHASSIS = "bloodhound_syndi", ROBOT_PANEL = "bloodhound_syndi", ROBOT_EYES = "bloodhound"),
		"Treadhound" =     list(ROBOT_CHASSIS = "treadhound_syndi", ROBOT_PANEL = "treadhound_syndi", ROBOT_EYES = "treadhound"),
		"Treadhead" =      list(ROBOT_CHASSIS = "treadhead_syndi", ROBOT_PANEL = "treadhead_syndi", ROBOT_EYES = "treadhead"),
		"Spiffy" = 	   	   list(ROBOT_CHASSIS = "mcspizzy_syndi", ROBOT_PANEL = "mcspizzy_syndi", ROBOT_EYES = "mcspizzy"),
		"Tau-Ceti Drone" = list(ROBOT_CHASSIS = "tauceti_syndi", ROBOT_PANEL = "tauceti_syndi", ROBOT_EYES = "tauceti"),
		"Sputnik" =        list(ROBOT_CHASSIS = "sputnik_syndi", ROBOT_PANEL = "sputnik_syndi", ROBOT_EYES = "sputnik"),
		"Kent" =           list(ROBOT_CHASSIS = "kent_syndi", ROBOT_PANEL = "kent_syndi", ROBOT_EYES = "kent"),
		"Wide" =           list(ROBOT_CHASSIS = "wide_syndi", ROBOT_PANEL = "wide_syndi", ROBOT_EYES = "wide"),
		"Cricket" =        list(ROBOT_CHASSIS = "cricket_syndi", ROBOT_PANEL = "cricket_syndi", ROBOT_EYES = "cricket"),
		"Quad-Dex" =       list(ROBOT_CHASSIS = "quaddex_syndi", ROBOT_PANEL = "quaddex_syndi", ROBOT_EYES = "quaddex"),
		"Arthrodroid" =    list(ROBOT_CHASSIS = "arthrodroid_syndi", ROBOT_PANEL = "arthrodroid_syndi", ROBOT_EYES = "arthrodroid"),
		"Spiderbot" =      list(ROBOT_CHASSIS = "spiderbot_syndi", ROBOT_PANEL = "spiderbot_syndi", ROBOT_EYES = "spiderbot"),
		"Heavy" =          list(ROBOT_CHASSIS = "heavy_syndi", ROBOT_PANEL = "heavy_syndi", ROBOT_EYES = "heavy_syndi"),
		"Positron 03" =    list(ROBOT_CHASSIS = "positron03_syndi", ROBOT_PANEL = "positron03_syndi", ROBOT_EYES = "positron03"),
		"Plantasonic" =    list(ROBOT_CHASSIS = "plantasonic_syndi", ROBOT_PANEL = "plantasonic_syndi", ROBOT_EYES = "plantasonic"),
		"Cooler Master" =  list(ROBOT_CHASSIS = "coolermaster_syndi", ROBOT_PANEL = "coolermaster_syndi", ROBOT_EYES = "coolermaster"),
		"Phage" =          list(ROBOT_CHASSIS = "phage_syndi", ROBOT_PANEL = "phage_syndi", ROBOT_EYES = "phage")
	)


/obj/item/robot_module/combat/Initialize(mapload, mob/living/silicon/robot/R)
	. = ..()

	R.faction = "syndicate" // prevents viscerators from attacking us

	modules += new /obj/item/borg/sight/thermal(src)
	modules += new /obj/item/melee/energy/sword(src)
	modules += new /obj/item/gun/energy/mountedsmg(src)
	modules += new /obj/item/gun/energy/net/mounted(src)
	modules += new /obj/item/gun/launcher/grenade/cyborg(src)
	modules += new /obj/item/robot_emag(src)
	modules += new /obj/item/handcuffs/cyborg(src)
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/extinguisher(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	modules += new /obj/item/roller_holder(src)
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/reagent_containers/hypospray/borghypo/medical(src)
	modules += new /obj/item/plastique/cyborg(src)
	modules += new /obj/item/grenade/smokebomb/cyborg(src)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

	if(R.radio)
		R.radio.recalculateChannels()

/obj/item/robot_module/military
	name = "military robot module"
	channels = list(CHANNEL_SECURITY = TRUE)
	networks = list(NETWORK_SECURITY)
	sprites = list(
		"Roller" = list(ROBOT_CHASSIS = "droid-combat", ROBOT_PANEL = "heavy_syndi", ROBOT_EYES = "droid-combat"),
		"Squats" = list(ROBOT_CHASSIS = "squats", ROBOT_PANEL = "heavy_syndi", ROBOT_EYES = "squats")
		)
	can_be_pushed = FALSE
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/robot_module/military/Initialize()
	. = ..()
	modules += new /obj/item/gun/energy/laser/mounted(src)
	modules += new /obj/item/melee/hammer/powered(src)
	modules += new /obj/item/borg/combat/shield(src)
	modules += new /obj/item/borg/combat/mobility(src)
	modules += new /obj/item/handcuffs/cyborg(src)
	modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	modules += new /obj/item/extinguisher(src) // For navigating space and/or low grav, and just being useful.
	modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.
	emag = new /obj/item/gun/energy/lasercannon/mounted(src)

/obj/item/robot_module/drone
	name = "drone module"
	no_slip = TRUE
	networks = list(NETWORK_ENGINEERING)

/obj/item/robot_module/drone/Initialize(mapload, mob/living/silicon/robot/robot)
	. = ..()
	modules += new /obj/item/weldingtool/robotic(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/crowbar/robotic(src)
	modules += new /obj/item/wirecutters/robotic(src)
	modules += new /obj/item/device/multitool/robotic(src)
	modules += new /obj/item/taperoll/engineering(src)
	modules += new /obj/item/device/lightreplacer(src)
	modules += new /obj/item/soap/drone(src)
	modules += new /obj/item/extinguisher(src)
	modules += new /obj/item/device/pipe_painter(src)
	modules += new /obj/item/device/floor_painter(src)
	modules += new /obj/item/device/t_scanner(src)
	modules += new /obj/item/gripper/multi_purpose(src)
	modules += new /obj/item/gripper/no_use/loader(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(25000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(25000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(10000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(10000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(30)
	var/datum/matter_synth/cloth = new /datum/matter_synth/cloth(30000)
	synths += metal
	synths += glass
	synths += wood
	synths += plastic
	synths += wire
	synths += cloth

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	modules += G

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	modules += RG

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	modules += W

	var/obj/item/stack/material/cyborg/plastic/P = new (src)
	P.synths = list(plastic)
	modules += P

	var/obj/item/stack/material/cyborg/cloth/CL = new /obj/item/stack/material/cyborg/cloth(src)
	CL.synths = list(cloth)
	modules += CL

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	modules += S

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	modules += WT

	modules += new /obj/item/tank/jetpack/carbondioxide/synthetic(src)
	modules += new /obj/item/inflatable_dispenser(src)
	modules += new /obj/item/rfd/piping/borg(src) // putting this here so it's next to the RFD-C on construction drones

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	return ..()

/obj/item/robot_module/drone/handle_languages(var/mob/living/silicon/robot/R)
	R.languages = list()
	R.speech_synthesizer_langs = list()
	for(var/language in languages)
		languages[language] = FALSE
	languages[LANGUAGE_DRONE] = TRUE
	languages[LANGUAGE_LOCAL_DRONE] = TRUE

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	channels = list(CHANNEL_ENGINEERING = TRUE)

/obj/item/robot_module/drone/construction/Initialize()
	. = ..()
	modules += new /obj/item/rfd/construction/borg(src)
	modules += new /obj/item/pickaxe/drill(src)

/obj/item/robot_module/drone/construction/matriarch
	name = "matriarch drone module"

/obj/item/robot_module/mining_drone
	name = "mining drone module"
	no_slip = TRUE
	channels = list(CHANNEL_SUPPLY = TRUE)
	networks = list(NETWORK_MINE)

/obj/item/robot_module/mining_drone/Initialize(mapload, mob/living/silicon/robot/R)
	. = ..()
	set_up_default(R)

/obj/item/robot_module/mining_drone/handle_languages(var/mob/living/silicon/robot/R)
	R.languages = list()
	R.speech_synthesizer_langs = list()
	for(var/language in languages)
		languages[language] = FALSE
	languages[LANGUAGE_DRONE] = TRUE
	languages[LANGUAGE_LOCAL_DRONE] = TRUE

/obj/item/robot_module/mining_drone/proc/set_up_default(var/mob/living/silicon/robot/R, var/has_drill = TRUE)
	modules += new /obj/item/device/flash(src)
	if(has_drill)
		modules += new /obj/item/pickaxe/drill(src)
	modules += new /obj/item/storage/bag/ore/drone(src)
	modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	modules += new /obj/item/gripper/miner(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/mining_scanner(src)
	modules += new /obj/item/device/gps/mining(src)
	modules += new /obj/item/tank/jetpack/carbondioxide(src)
	modules += new /obj/item/rfd/mining(src)
	modules += new /obj/item/tethering_device(src)
	modules += new /obj/item/ore_detector(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(20000)
	synths += metal

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	modules += rods

	var/obj/item/stack/flag/purple/borg/beacons = new /obj/item/stack/flag/purple/borg(src)
	beacons.synths = list(metal)
	modules += beacons

	emag = new /obj/item/gun/energy/plasmacutter/mounted(src)
	emag.name = "Mounted Plasma Cutter"

/obj/item/robot_module/mining_drone/drill/set_up_default(mob/living/silicon/robot/R)
	..(R, FALSE)
	modules += new /obj/item/pickaxe/jackhammer(src)

/obj/item/robot_module/mining_drone/ka/set_up_default(mob/living/silicon/robot/R)
	..(R)
	modules += new /obj/item/gun/custom_ka/cyborg(src)

/obj/item/robot_module/mining_drone/drillandka/set_up_default(mob/living/silicon/robot/R)
	..(R, FALSE)
	modules += new /obj/item/pickaxe/jackhammer(src)
	modules += new /obj/item/gun/custom_ka/cyborg(src)

/obj/item/robot_module/bluespace
	name = "bluespace robot module"
	languages = list(
		LANGUAGE_TCB =             TRUE,
		LANGUAGE_ELYRAN_STANDARD = TRUE,
		LANGUAGE_GUTTER =          TRUE,
		LANGUAGE_SIGN =            TRUE,
		LANGUAGE_TRADEBAND =       TRUE,
		LANGUAGE_UNATHI =          TRUE,
		LANGUAGE_AZAZIBA =         TRUE,
		LANGUAGE_SIIK_MAAS =       TRUE,
		LANGUAGE_SIIK_TAJR =       TRUE,
		LANGUAGE_SIGN_TAJARA =     TRUE,
		LANGUAGE_SKRELLIAN =       TRUE,
		LANGUAGE_SOL_COMMON =      TRUE,
		LANGUAGE_ROOTSONG =        TRUE,
		LANGUAGE_VAURCA =          TRUE,
		LANGUAGE_ROBOT =           TRUE,
		LANGUAGE_DRONE =           TRUE,
		LANGUAGE_EAL =             TRUE,
		LANGUAGE_CHANGELING =      TRUE,
		LANGUAGE_BORER =           TRUE
	)
	channels = list(
		CHANNEL_SERVICE =       TRUE,
		CHANNEL_SUPPLY =        TRUE,
		CHANNEL_SCIENCE =       TRUE,
		CHANNEL_SECURITY =      TRUE,
		CHANNEL_ENGINEERING =   TRUE,
		CHANNEL_MEDICAL =       TRUE,
		CHANNEL_COMMAND =       TRUE,
		CHANNEL_RESPONSE_TEAM = TRUE,
		CHANNEL_AI_PRIVATE =    TRUE
	)
	sprites = list("Roller" = list(ROBOT_CHASSIS = "droid-combat", ROBOT_PANEL = "heavy_syndi", ROBOT_EYES = "droid-combat")) //TMP // temp my left nut // temp my right nut
	can_be_pushed = FALSE

/obj/item/robot_module/bluespace/Initialize(mapload, mob/living/silicon/robot/R)
	. = ..()
	modules += new /obj/item/device/flash(src)
	modules += new /obj/item/borg/sight/meson(src)
	modules += new /obj/item/rfd/construction/borg/infinite(src)
	modules += new /obj/item/extinguisher(src)
	modules += new /obj/item/weldingtool/largetank(src)
	modules += new /obj/item/screwdriver/robotic(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/crowbar/robotic(src)
	modules += new /obj/item/wirecutters/robotic(src)
	modules += new /obj/item/device/multitool/robotic(src)
	modules += new /obj/item/device/t_scanner(src)
	modules += new /obj/item/device/analyzer(src)
	modules += new /obj/item/gripper(src)
	modules += new /obj/item/gripper/no_use/loader(src)
	modules += new /obj/item/device/lightreplacer(src)
	modules += new /obj/item/inflatable_dispenser(src)
	// Medical
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/reagent_containers/hypospray/borghypo/medical(src)
	modules += new /obj/item/surgery/scalpel(src)
	modules += new /obj/item/surgery/hemostat(src)
	modules += new /obj/item/surgery/retractor(src)
	modules += new /obj/item/surgery/cautery(src)
	modules += new /obj/item/surgery/bone_gel(src)
	modules += new /obj/item/surgery/fix_o_vein(src)
	modules += new /obj/item/surgery/bonesetter(src)
	modules += new /obj/item/surgery/circular_saw(src)
	modules += new /obj/item/surgery/surgicaldrill(src)
	modules += new /obj/item/gripper/chemistry(src)
	modules += new /obj/item/reagent_containers/dropper/cyborg_pipette(src)
	modules += new /obj/item/reagent_containers/syringe(src)
	modules += new /obj/item/reagent_containers/hypospray/borghypo/rescue(src)
	modules += new /obj/item/roller_holder(src)
	// Security
	modules += new /obj/item/handcuffs/cyborg(src)
	modules += new /obj/item/melee/baton/robot(src)
	modules += new /obj/item/melee/hammer/powered(src)
	modules += new /obj/item/gun/energy/lasercannon/mounted/cyborg/overclocked(src)
	modules += new /obj/item/borg/combat/shield(src)
	modules += new /obj/item/borg/combat/mobility(src)
	// BST
	modules += new/obj/item/card/id/bst(src)

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
	modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	modules += G

	var/obj/item/stack/rods/cyborg/RO = new /obj/item/stack/rods/cyborg(src)
	RO.synths = list(metal)
	modules += RO

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	modules += RG

	var/obj/item/stack/material/cyborg/plasteel/PL = new (src)
	PL.synths = list(plasteel)
	modules += PL

	var/obj/item/stack/tile/floor_dark/cyborg/FTD = new (src)
	FTD.synths = list(plasteel)
	modules += FTD

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	modules += N
	modules += B

/obj/item/robot_module/bluespace/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/melee/baton/robot/B = locate() in modules
	if(B?.bcell)
		B.bcell.give(amount)
	var/obj/item/reagent_containers/syringe/S = locate() in modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()