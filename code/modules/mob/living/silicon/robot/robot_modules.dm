var/global/list/robot_modules = list(
	"Standard"		= /obj/item/weapon/robot_module/standard,
	"Service" 		= /obj/item/weapon/robot_module/clerical/butler,
	"Clerical" 		= /obj/item/weapon/robot_module/clerical/general,
	"Research" 		= /obj/item/weapon/robot_module/research,
	"Mining" 		= /obj/item/weapon/robot_module/miner,
	"Rescue" 		= /obj/item/weapon/robot_module/medical/rescue,
	"Medical" 		= /obj/item/weapon/robot_module/medical/general,
	"Security" 		= /obj/item/weapon/robot_module/security/general,
	"Combat" 		= /obj/item/weapon/robot_module/combat,
	"Engineering"	= /obj/item/weapon/robot_module/engineering/general,
	"Construction"	= /obj/item/weapon/robot_module/engineering/construction,
	"Custodial" 	= /obj/item/weapon/robot_module/janitor
	)

/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	flags = CONDUCT
	var/channels = list()
	var/networks = list()
	var/languages = list(							//Any listed language will be understandable. Any set to 1 will be speakable
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 0,
					LANGUAGE_SIIK_MAAS = 0,
					LANGUAGE_SKRELLIAN = 0,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_VAURCESE = 0,
					LANGUAGE_ROOTSONG = 0,
					LANGUAGE_SIGN = 0,
					LANGUAGE_SIGN_TAJARA = 0,
					LANGUAGE_SIIK_TAJR = 0,
					LANGUAGE_AZAZIBA = 0
					)
	var/sprites = list()
	var/can_be_pushed = 1
	var/no_slip = 0
	var/list/modules = list()
	var/list/datum/matter_synth/synths = list()
	var/obj/item/emag = null
	var/obj/item/malfAImodule = null
	var/obj/item/borg/upgrade/jetpack = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/weapon/robot_module/New(var/mob/living/silicon/robot/R)
	..()
	R.module = src

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()

	R.set_module_sprites(sprites)
	R.icon_selected = 0
	R.icon_selection_tries = -1
	R.choose_icon()

	for(var/obj/item/I in modules)
		I.canremove = 0

/obj/item/weapon/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()
	R.set_module_sprites(list("Default" = "robot"))
	R.icon_selected = 0
	R.icon_selection_tries = -1
	R.choose_icon()

/obj/item/weapon/robot_module/Destroy()
	for(var/module in modules)
		qdel(module)
	for(var/synth in synths)
		qdel(synth)
	modules.Cut()
	synths.Cut()
	qdel(emag)
	qdel(jetpack)
	qdel(malfAImodule)
	emag = null
	malfAImodule = null
	jetpack = null
	return ..()

/obj/item/weapon/robot_module/emp_act(severity)
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

/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F)
		if(F.broken)
			F.broken = 0
			F.times_used = 0
			F.icon_state = "flash"
		else if(F.times_used)
			F.times_used--

	if(!synths || !synths.len)
		return

	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/weapon/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/weapon/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/weapon/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		R.add_language(original_language, original_languages[original_language])
	original_languages.Cut()

/obj/item/weapon/robot_module/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/weapon/robot_module/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/weapon/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	R.verbs |= subsystems

/obj/item/weapon/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	R.verbs -= subsystems

/obj/item/weapon/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/weapon/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

/obj/item/weapon/robot_module/standard
	name = "standard robot module"
	sprites = list(	"Basic" = "robot",
					"Android" = "droid",
					"Default" = "robot_old",
					"Sleek" = "sleekstandard",
					"Drone" = "drone-standard",
					"Spider" = "spider"
				  )

/obj/item/weapon/robot_module/standard/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/melee/baton/loaded(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.emag = new /obj/item/weapon/melee/energy/sword(src)


/obj/item/weapon/robot_module/medical
	name = "medical robot module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	sprites = list(
				"Basic" = "robotmedi",
				"Classic" = "medbot",
				"Heavy" = "heavymed",
				"Needles" = "medicalrobot",
				"Standard" = "surgeon",
				"Advanced Droid - Medical" = "droid-medical",
				"Advanced Droid - Chemistry" = "droid-chemistry",
				"Drone - Medical" = "drone-surgery",
				"Drone - Chemistry" = "drone-chemistry",
				"Sleek - Medical" = "sleekmedic",
				"Sleek - Chemistry" = "sleekchemistry"
				)

/obj/item/weapon/robot_module/medical/general
	name = "medical robot module"

/obj/item/weapon/robot_module/medical/general/New()
	..()
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/medical(src)
	src.modules += new /obj/item/weapon/scalpel(src)
	src.modules += new /obj/item/weapon/hemostat(src)
	src.modules += new /obj/item/weapon/retractor(src)
	src.modules += new /obj/item/weapon/cautery(src)
	src.modules += new /obj/item/weapon/bonegel(src)
	src.modules += new /obj/item/weapon/FixOVein(src)
	src.modules += new /obj/item/weapon/bonesetter(src)
	src.modules += new /obj/item/weapon/circular_saw(src)
	src.modules += new /obj/item/weapon/surgicaldrill(src)
	src.modules += new /obj/item/weapon/gripper/chemistry(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/weapon/autopsy_scanner(src) // an autopsy scanner
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000)
	synths += medicine

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


/obj/item/weapon/robot_module/medical/general/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)
	..()

/obj/item/weapon/robot_module/medical/rescue
	name = "rescue robot module"
	sprites = list(
			"Basic" = "robotmedi",
			"Classic" = "medbot",
			"Standard" = "surgeon",
			"Advanced Droid" = "droid-rescue",
			"Sleek" = "sleekrescue",
			"Needles" = "medicalrobot",
			"Drone" = "drone-medical",
			"Heavy" = "heavymed"
			)

	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/weapon/robot_module/medical/rescue/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/rescue(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/weapon/extinguisher/mini(src)
	src.modules += new /obj/item/weapon/inflatable_dispenser(src) // Allows usage of inflatables. Since they are basically robotic alternative to EMTs, they should probably have them.
	src.modules += new /obj/item/device/gps(src) // for coordinating with medical suit health sensors console
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/ointment/O = new /obj/item/stack/medical/ointment(src)
	var/obj/item/stack/medical/bruise_pack/B = new /obj/item/stack/medical/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	src.modules += O
	src.modules += B
	src.modules += S


/obj/item/weapon/robot_module/medical/rescue/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)

	..()


/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)
	sprites = list(
					"Basic" = "robotengi",
					"Antique" = "engineerrobot",
					"Landmate" = "landmate",
					"Landmate - Treaded" = "engiborg+tread",
					"Drone" = "drone-engineer",
					"Android" = "droid",
					"Classic" = "engineering",
					"Sleek" = "sleekengineer",
					"Spider" = "spidereng",
					"Plated" = "ceborg",
					"Heavy" = "heavyeng"
					)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/weapon/robot_module/engineering/construction
	name = "construction robot module"
	no_slip = 1

/obj/item/weapon/robot_module/engineering/construction/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/rcd/borg(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/weldingtool/experimental(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/device/t_scanner(src) // to check underfloor wiring
	src.modules += new /obj/item/device/analyzer(src) // to check air pressure in the area
	src.modules += new /obj/item/device/lightreplacer(src) // to install lightning in the area
	src.modules += new /obj/item/device/floor_painter(src)// to make america great again (c)
	src.modules += new /obj/item/weapon/inflatable_dispenser(src) // to stop those pesky humans being entering the zone
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src) // as station is being located at the rock terrain, which is presumed to be digged out to clear the area for new rooms
	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	src.malfAImodule += new /obj/item/weapon/rtf(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(80000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(40000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(60000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(60)
	synths += metal
	synths += plasteel
	synths += glass
	synths += wire

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/material/cyborg/plasteel/S = new (src)
	S.synths = list(plasteel)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/floor/cyborg/FT = new /obj/item/stack/tile/floor/cyborg(src) // to add floor over the metal rods lattice
	FT.synths = list(metal)
	src.modules += FT

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src) // Let there be light electric said and after that did cut the wire
	C.synths = list(wire)
	src.modules += C

/obj/item/weapon/robot_module/engineering/general/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/weldingtool/largetank(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/wirecutters(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/taperoll/engineering(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/device/floor_painter(src)
	src.modules += new /obj/item/weapon/inflatable_dispenser(src)
	src.emag = new /obj/item/weapon/melee/baton/robot/arm(src)

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

	var/obj/item/weapon/matter_decompiler/MD = new /obj/item/weapon/matter_decompiler(src)
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

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/material/cyborg/plasteel/PL = new (src)
	PL.synths = list(plasteel)
	src.modules += PL

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PS = new (src)
	PS.synths = list(plastic)
	src.modules += PS

	var/obj/item/stack/tile/wood/cyborg/FWT = new (src)
	FWT.synths = list(wood)
	src.modules += FWT

	var/obj/item/stack/tile/floor_white/cyborg/FTW = new (src)
	FTW.synths = list(plastic)
	src.modules += FTW

	var/obj/item/stack/tile/floor_freezer/cyborg/FTF = new (src)
	FTF.synths = list(plastic)
	src.modules += FTF

	var/obj/item/stack/tile/floor_dark/cyborg/FTD = new (src)
	FTD.synths = list(plasteel)
	src.modules += FTD

/obj/item/weapon/robot_module/security
	name = "security robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler,/obj/item/robot_parts/robot_component/jetpack)

/obj/item/weapon/robot_module/security/general
	sprites = list(
					"Basic" = "robotsecy",
					"Sleek" = "sleeksecurity",
					"Black Knight" = "securityrobot",
					"Bloodhound" = "bloodhound",
					"Bloodhound - Treaded" = "treadhound",
					"Drone" = "drone-sec",
					"Classic" = "secborg",
					"Spider" = "spidersec",
					"Heavy" = "heavysec"
				)

/obj/item/weapon/robot_module/security/general/New()
	..()
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/sec(src)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg(src)
	src.modules += new /obj/item/taperoll/police(src)
	src.modules += new /obj/item/device/holowarrant(src)
	src.modules += new /obj/item/weapon/book/manual/security_space_law(src) // book of security space law
	src.emag = new /obj/item/weapon/gun/energy/laser/mounted(src)

/obj/item/weapon/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/weapon/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0
	var/obj/item/weapon/melee/baton/robot/B = locate() in src.modules
	if(B && B.bcell)
		B.bcell.give(amount)

/obj/item/weapon/robot_module/janitor
	name = "custodial robot module"
	channels = list("Service" = 1)
	networks = list(NETWORK_SERVICE)
	sprites = list(
					"Basic" = "robotjani",
					"Mopbot"  = "janitorrobot",
					"Mop Gear Rex" = "mopgearrex",
					"Drone" = "drone-janitor",
					"Classic" = "janbot2",
					"Buffer" = "mechaduster",
					"Sleek" = "sleekjanitor"
					)

/obj/item/weapon/robot_module/janitor/New()
	..()
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/soap/nanotrasen(src)
	src.modules += new /obj/item/weapon/storage/bag/trash(src)
	src.modules += new /obj/item/weapon/mop(src)
	src.modules += new /obj/item/device/lightreplacer/advanced(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/bucket(src) // a hydroponist's bucket
	src.modules += new /obj/item/weapon/matter_decompiler(src) // free drone remains for all
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("lube", 250)
	src.emag.name = "Lube spray"

/obj/item/weapon/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

/obj/item/weapon/robot_module/clerical
	name = "service robot module"
	channels = list("Service" = 1)
	networks = list(NETWORK_SERVICE)
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 1,
					LANGUAGE_SIIK_MAAS = 1,
					LANGUAGE_SKRELLIAN = 1,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_ROOTSONG = 1
					)

	sprites = list(	"Waitress" = "service",
					"Kent" = "toiletbot",
					"Bro" = "brobot",
					"Rich" = "maximillion",
					"Basic" = "robotserv",
					"Drone - Service" = "drone-service",
					"Drone - Hydro" = "drone-hydro",
					"Classic" = "service2",
					"Gardener" = "botany",
					"Mobile Bar" = "heavyserv",
					"Sleek" = "sleekservice"
				  	)

/obj/item/weapon/robot_module/clerical/butler


/obj/item/weapon/robot_module/clerical/butler/New()
	..()
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/gripper/service(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/weapon/material/minihoe(src)
	src.modules += new /obj/item/weapon/material/hatchet(src)
	src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/weapon/storage/bag/plants(src)
	src.modules += new /obj/item/weapon/robot_harvester(src)
	src.modules += new /obj/item/weapon/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/weapon/material/knife(src)
	src.modules += new /obj/item/weapon/soap(src) // a cheap bar of soap
	src.modules += new /obj/item/weapon/reagent_containers/glass/rag(src) // a rag for.. yeah.. the primary tool of bartender

	var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)

	var/obj/item/weapon/flame/lighter/zippo/L = new /obj/item/weapon/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/weapon/tray/robotray(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/service(src)
	src.emag = new /obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/R = new/datum/reagents(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"

/obj/item/weapon/robot_module/clerical/general
	name = "clerical robot module"

/obj/item/weapon/robot_module/clerical/general/New()
	..()
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/pen/robopen(src)
	src.modules += new /obj/item/weapon/form_printer(src)
	src.modules += new /obj/item/weapon/gripper/paperwork(src)
	src.modules += new /obj/item/weapon/hand_labeler(src)
	src.modules += new /obj/item/weapon/tape_roll(src) //allows it to place flyers
	src.modules += new /obj/item/weapon/stamp/denied(src) //why was this even a emagged item before smh
	src.emag = new /obj/item/weapon/stamp/chameleon(src)


/obj/item/weapon/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

/obj/item/weapon/robot_module/miner
	name = "miner robot module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	sprites = list(
					"Basic" = "robotmine",
					"Advanced Droid" = "droid-miner",
					"Sleek" = "sleekminer",
					"Treadhead" = "miner",
					"Drone" = "drone-miner",
					"Classic" = "miner_old",
					"Heavy" = "heavymine",
					"Spider" = "spidermining"
				)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/weapon/robot_module/miner/New()
	..()
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)
	src.modules += new /obj/item/device/gps/mining(src) // for locating itself in the deep space
	src.modules += new /obj/item/weapon/gun/custom_ka/cyborg(src)
	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)

/obj/item/weapon/robot_module/research
	name = "research module"
	channels = list("Science" = 1)
	networks = list(NETWORK_RESEARCH)
	sprites = list(
					"Droid" = "droid-science",
					"Drone" = "drone-science",
					"Classic" = "robotjani",
					"Sleek" = "sleekscience",
					"Heavy" = "heavysci"
					)

/obj/item/weapon/robot_module/research/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/portable_destructive_analyzer(src)
	src.modules += new /obj/item/weapon/gripper/research(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/robotanalyzer(src)
	src.modules += new /obj/item/weapon/card/robot(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/scalpel(src)
	src.modules += new /obj/item/weapon/circular_saw(src)
	src.modules += new /obj/item/weapon/extinguisher/mini(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/weapon/gripper/chemistry(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/weapon/storage/bag/plants(src)
	src.modules += new /obj/item/weapon/pen/robopen(src)
	src.emag = new /obj/item/weapon/hand_tele(src)

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

/obj/item/weapon/robot_module/syndicate
	name = "syndicate robot module"
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 1,
					LANGUAGE_SIIK_MAAS = 1,
					LANGUAGE_SKRELLIAN = 1,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_ROOTSONG = 1
					)

	sprites = list(
					"Bloodhound" = "syndie_bloodhound",
					"Treadhound" = "syndie_treadhound",
					"Precision" = "syndi-medi",
					"Heavy" = "syndi-heavy",
					"Artillery" = "spidersyndi"
					)

/obj/item/weapon/robot_module/syndicate/New(var/mob/living/silicon/robot/R)
	..()
	loc = R
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/weapon/melee/energy/sword(src)
	src.modules += new /obj/item/weapon/gun/energy/mountedsmg(src)
	src.modules += new /obj/item/weapon/gun/energy/net/mounted(src)
	src.modules += new /obj/item/weapon/gun/launcher/grenade/cyborg(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/robot_emag(src)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

	return

/obj/item/weapon/robot_module/combat
	name = "combat robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	sprites = list("Roller" = "droid-combat")
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

/obj/item/weapon/robot_module/combat/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/sec(src)
	src.modules += new /obj/item/weapon/gun/energy/laser/mounted(src)
	src.modules += new /obj/item/weapon/melee/hammer/powered(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.emag = new /obj/item/weapon/gun/energy/lasercannon/mounted(src)

/obj/item/weapon/robot_module/drone
	name = "drone module"
	no_slip = 1
	networks = list(NETWORK_ENGINEERING)

/obj/item/weapon/robot_module/drone/New(var/mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/weapon/weldingtool(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/wirecutters(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/soap(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/device/floor_painter(src)

	robot.internals = new/obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += robot.internals

	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	src.emag.name = "Plasma Cutter"

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

	var/obj/item/weapon/matter_decompiler/MD = new /obj/item/weapon/matter_decompiler(src)
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

/obj/item/weapon/robot_module/drone/construction
	name = "construction drone module"
	channels = list("Engineering" = 1)
	languages = list()

/obj/item/weapon/robot_module/drone/construction/New()
	..()
	src.modules += new /obj/item/weapon/rcd/borg(src)

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()
	return

/obj/item/weapon/robot_module/mining_drone
	name = "mining drone module"
	no_slip = 1
	networks = list(NETWORK_MINE)

/obj/item/weapon/robot_module/mining_drone/basic/New(var/mob/living/silicon/robot/robot)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/pickaxe/drill(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)

	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	src.emag.name = "Mounted Plasma Cutter"
	..()

/obj/item/weapon/robot_module/mining_drone/drill/New(var/mob/living/silicon/robot/robot)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/storage/bag/ore/drone(src)
	src.modules += new /obj/item/weapon/pickaxe/jackhammer(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)

	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	src.emag.name = "Mounted Plasma Cutter"
	..()

/obj/item/weapon/robot_module/mining_drone/ka/New(var/mob/living/silicon/robot/robot)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/storage/bag/ore/drone(src)
	src.modules += new /obj/item/weapon/gun/custom_ka/cyborg(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)

	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	src.emag.name = "Mounted Plasma Cutter"
	..()

/obj/item/weapon/robot_module/mining_drone/drillandka/New(var/mob/living/silicon/robot/robot)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/storage/bag/ore/drone(src)
	src.modules += new /obj/item/weapon/gun/custom_ka/cyborg(src)
	src.modules += new /obj/item/weapon/pickaxe/jackhammer(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)

	src.emag = new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	src.emag.name = "Mounted Plasma Cutter"
	..()

/obj/item/weapon/robot_module/hunter_seeker
	name = "hunter seeker robot module"
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 1,
					LANGUAGE_SIIK_MAAS = 1,
					LANGUAGE_SKRELLIAN = 1,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_ROOTSONG = 1,
					LANGUAGE_TERMINATOR = 1
					)

	sprites = list(
					"Hunter Seeker" = "hunter_seeker"
					)

/obj/item/weapon/robot_module/hunter_seeker/New(var/mob/living/silicon/robot/R)
	..()
	loc = R
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/weapon/gun/energy/net/mounted(src)
	src.modules += new /obj/item/weapon/gun/energy/mountedcannon(src)
	src.modules += new /obj/item/weapon/melee/energy/glaive(src)
	src.modules += new /obj/item/weapon/crowbar/robotic(src)
	src.modules += new /obj/item/weapon/wrench/robotic(src)
	src.modules += new /obj/item/weapon/screwdriver/robotic(src)
	src.modules += new /obj/item/device/multitool/robotic(src)
	src.modules += new /obj/item/weapon/wirecutters/robotic(src)
	src.modules += new /obj/item/weapon/weldingtool/robotic(src)
	supported_upgrades = list(/obj/item/robot_parts/robot_component/jetpack)

	return