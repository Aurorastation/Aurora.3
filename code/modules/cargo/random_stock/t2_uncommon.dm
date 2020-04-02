// --- Uncommon ---

STOCK_ITEM_UNCOMMON(glowshrooms, 2)
	new /obj/item/seeds/glowshroom(L)
	new /obj/item/seeds/glowshroom(L)
	new /obj/item/seeds/glowshroom(L)

STOCK_ITEM_UNCOMMON(plasteel, 3)
	new /obj/item/stack/material/plasteel(L, rand(1,30))

STOCK_ITEM_UNCOMMON(silver, 2)
	new /obj/item/stack/material/silver(L, rand(5,30))

STOCK_ITEM_UNCOMMON(phoronglass, 2)
	new /obj/item/stack/material/glass/phoronglass(L, 50)

STOCK_ITEM_UNCOMMON(sandstone, 2)
	new /obj/item/stack/material/sandstone(L, 50)

STOCK_ITEM_UNCOMMON(marble, 2)
	new /obj/item/stack/material/marble(L, 50)

STOCK_ITEM_UNCOMMON(iron, 2)
	new /obj/item/stack/material/iron(L, 50)

STOCK_ITEM_UNCOMMON(flare, 2)
	new /obj/item/device/flashlight/flare(L)
	new /obj/item/device/flashlight/flare(L)
	if (prob(50))
		new /obj/random/glowstick(L)

STOCK_ITEM_UNCOMMON(deathalarm, 2)
	new /obj/item/storage/box/cdeathalarm_kit(L)

STOCK_ITEM_UNCOMMON(trackimp, 1)
	new /obj/item/storage/box/trackimp(L)

STOCK_ITEM_UNCOMMON(flashbang, 0.75)
	new /obj/item/storage/box/flashbangs(L)

STOCK_ITEM_UNCOMMON(cuffs, 1)
	new /obj/item/storage/box/handcuffs(L)

STOCK_ITEM_UNCOMMON(monkey, 2)
	if (prob(40))
		var/type = pick( \
			/obj/item/storage/box/monkeycubes/farwacubes, \
			/obj/item/storage/box/monkeycubes/stokcubes, \
			/obj/item/storage/box/monkeycubes/neaeracubes \
		)
		new type(L)
	else
		new /obj/item/storage/box/monkeycubes(L)

STOCK_ITEM_UNCOMMON(specialcrayon, 1.5)
	if (prob(50))
		new /obj/item/pen/crayon/mime(L)
	else
		new /obj/item/pen/crayon/rainbow(L)

STOCK_ITEM_UNCOMMON(contraband, 2)
	for (var/i in 1 to rand(1,8))
		new /obj/random/contraband(L)

STOCK_ITEM_UNCOMMON(mediumcell, 3)
	for (var/i in 1 to rand(1,2))
		var/type = pick( \
			/obj/item/cell/super, \
			/obj/item/cell/potato, \
			/obj/item/cell/high \
		)
		new type(L)

STOCK_ITEM_UNCOMMON(chempack, 5)
	var/list/chems = SSchemistry.chemical_reagents.Copy()
	var/list/exclusion = list("drink", "reagent", "adminordrazine", "beer2", "azoth", "elixir_life", "liquid_fire", "philosopher_stone", "undead_ichor", "love", "shapesand", "usolve",\
							 "sglue", "black_matter", "lightning", "trioxin", "phoron_salt", "nanites", "nitroglycerin")
	chems -= exclusion
	for (var/i in 1 to rand(2, 6))
		var/obj/item/reagent_containers/chem_disp_cartridge/C = new /obj/item/reagent_containers/chem_disp_cartridge(L)
		var/rname = pick(chems)
		var/datum/reagent/R = SSchemistry.chemical_reagents[rname]

		//If we get a drink, reroll it once.
		//Should result in a higher chance of getting medicines and chemicals
		if (istype(R, /datum/reagent/drink) || istype(R, /datum/reagent/alcohol/ethanol))
			rname = pick(chems)
			R = SSchemistry.chemical_reagents[rname]
		C.reagents.add_reagent(rname, C.volume)
		C.setLabel(R.name)

STOCK_ITEM_UNCOMMON(robolimbs, 3)
	for (var/i in 1 to rand(2, 5))
		var/manuf = pick(chargen_robolimbs)
		var/type = pick( \
			/obj/item/robot_parts/l_arm, \
			/obj/item/robot_parts/r_arm, \
			/obj/item/robot_parts/l_leg, \
			/obj/item/robot_parts/r_leg \
		)
		new type(L, manuf)

STOCK_ITEM_UNCOMMON(circuitboards, 3)
	var/list/allboards = subtypesof(/obj/item/circuitboard)
	var/list/exclusion = list(
		/obj/item/circuitboard/unary_atmos,
		/obj/item/circuitboard/telecomms
	)
	exclusion += typesof(/obj/item/circuitboard/mecha)

	allboards -= exclusion
	for (var/i in 1 to rand(2, 5))
		var/type = pick(allboards)
		new type(L)

STOCK_ITEM_UNCOMMON(jetpack, 3)
	new /obj/item/tank/jetpack/void(L)
	new /obj/item/tank/emergency_oxygen/double(L)

STOCK_ITEM_UNCOMMON(xenocostume, 1)
	new /obj/item/clothing/suit/xenos(L)
	new /obj/item/clothing/head/xenos(L)

STOCK_ITEM_UNCOMMON(inhaler, 1)
	log_debug("Unimplemented item inhaler.")

STOCK_ITEM_UNCOMMON(advwelder, 2)
	new /obj/item/weldingtool/hugetank(L)

STOCK_ITEM_UNCOMMON(sord, 1)
	new /obj/item/sord(L)

STOCK_ITEM_UNCOMMON(policebaton, 1.5)
	new /obj/item/melee/classic_baton(L)

STOCK_ITEM_UNCOMMON(stunbaton, 0.75) //batons spawn with no powercell
	var/obj/item/melee/baton/B = new /obj/item/melee/baton(L)
	if (B.bcell)
		QDEL_NULL(B.bcell)

	B.queue_icon_update()

STOCK_ITEM_UNCOMMON(firingpin, 3)
	new /obj/item/storage/box/firingpins(L)

STOCK_ITEM_UNCOMMON(watches, 3)
	new /obj/item/clothing/gloves/watch(L)
	new /obj/item/clothing/gloves/watch(L)
	new /obj/item/clothing/gloves/watch(L)

STOCK_ITEM_UNCOMMON(MMI, 1.5)
	new /obj/item/device/mmi(L)

STOCK_ITEM_UNCOMMON(voidsuit, 2)
	new /obj/random/voidsuit(L,1)

STOCK_ITEM_UNCOMMON(nightvision, 2)
	new /obj/item/clothing/glasses/night(L)

STOCK_ITEM_UNCOMMON(violin, 2)
	new /obj/item/device/violin(L)

STOCK_ITEM_UNCOMMON(atmosfiresuit, 2)
	new /obj/item/clothing/head/hardhat/red/atmos(L)
	new /obj/item/clothing/suit/fire/atmos(L)

STOCK_ITEM_UNCOMMON(pdacart, 3)
	for (var/i in 1 to rand(1, 4))
		new /obj/random/pda_cart(L)

STOCK_ITEM_UNCOMMON(debugger, 2)
	new /obj/item/device/debugger(L)//No idea what this thing does, or if it works at all

STOCK_ITEM_UNCOMMON(surgerykit, 2.5)
	new /obj/item/storage/firstaid/surgery(L)

STOCK_ITEM_UNCOMMON(crimekit, 1)
	new /obj/item/storage/briefcase/crimekit(L)

STOCK_ITEM_UNCOMMON(carpet, 2)
	new /obj/item/stack/tile/carpet(L, 50)

STOCK_ITEM_UNCOMMON(gift, 4)
	new /obj/item/a_gift(L)

STOCK_ITEM_UNCOMMON(coatrack, 1)
	var/turf/T = get_turf(L)
	if (!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break
	new /obj/structure/coatrack(T)

STOCK_ITEM_UNCOMMON(riotshield, 2)
	new /obj/item/shield/riot(L)
	if (prob(60))
		new /obj/item/shield/riot(L)

STOCK_ITEM_UNCOMMON(fireaxe, 1)
	new /obj/item/material/twohanded/fireaxe(L)

STOCK_ITEM_UNCOMMON(service, 2)
	new /obj/item/rfd/service(L)

STOCK_ITEM_UNCOMMON(robot, 2)
	var/list/bots = list(
		/mob/living/bot/cleanbot = 2,
		/mob/living/bot/secbot = 0.7,
		/mob/living/bot/medbot = 2,
		/mob/living/bot/floorbot = 2.5,
		/mob/living/bot/farmbot = 1,
		/mob/living/bot/secbot/ed209 = 0.3
	)

	var/type = pickweight(bots)
	if (type == /mob/living/bot/secbot/ed209)//ED is large and should spawn on the floor
		L = get_turf(L)
		if (!turf_clear(L))
			for (var/turf/U in range(L,1))
				if (turf_clear(U))
					L = U
					break

	var/mob/living/bot/newbot = new type(L)
	newbot.on = FALSE	//Deactivated
	if (prob(10))
		newbot.emag_act(9999, null)

STOCK_ITEM_UNCOMMON(taperoll, 1)
	// ???

STOCK_ITEM_UNCOMMON(headset, 2)
	var/list/sets = list(
		/obj/item/device/radio/headset/headset_eng = 1,
		/obj/item/device/radio/headset/headset_rob = 0.4,
		/obj/item/device/radio/headset/headset_med = 1,
		/obj/item/device/radio/headset/headset_sci = 0.8,
		/obj/item/device/radio/headset/headset_medsci = 0.4,
		/obj/item/device/radio/headset/headset_cargo = 1,
		/obj/item/device/radio/headset/headset_service = 1
	)

	var/type = pickweight(sets)
	new type(L)

STOCK_ITEM_UNCOMMON(bat, 1.2)
	new /obj/item/material/twohanded/baseballbat(L)

STOCK_ITEM_UNCOMMON(scythe, 0.75)
	new /obj/item/material/scythe(L)

STOCK_ITEM_UNCOMMON(manual, 2)
	var/type = pick( \
		/obj/item/book/manual/excavation, \
		/obj/item/book/manual/mass_spectrometry, \
		/obj/item/book/manual/anomaly_spectroscopy, \
		/obj/item/book/manual/materials_chemistry_analysis, \
		/obj/item/book/manual/anomaly_testing, \
		/obj/item/book/manual/stasis, \
		/obj/item/book/manual/engineering_particle_accelerator, \
		/obj/item/book/manual/supermatter_engine, \
		/obj/item/book/manual/engineering_singularity_safety, \
		/obj/item/book/manual/medical_cloning, \
		/obj/item/book/manual/ripley_build_and_repair, \
		/obj/item/book/manual/research_and_development, \
		/obj/item/book/manual/robotics_cyborgs, \
		/obj/item/book/manual/medical_diagnostics_manual, \
		/obj/item/book/manual/chef_recipes, \
		/obj/item/book/manual/barman_recipes, \
		/obj/item/book/manual/detective, \
		/obj/item/book/manual/atmospipes, \
		/obj/item/book/manual/evaguide \
	)

	new type(L)

STOCK_ITEM_UNCOMMON(jammer, 2)
	new /obj/item/device/radiojammer(L)

STOCK_ITEM_UNCOMMON(rped, 2)
	new /obj/item/storage/part_replacer(L)

STOCK_ITEM_UNCOMMON(briefcase, 2)
	if (prob(20))
		new /obj/item/storage/secure/briefcase(L)
	else
		new /obj/item/storage/briefcase(L)

STOCK_ITEM_UNCOMMON(blade, 1.2)
	var/list/blades = list(
		/obj/item/material/knife/butterfly = 1,
		/obj/item/material/knife/butterfly/switchblade = 1,
		/obj/item/material/hook = 1.5,
		/obj/item/material/knife/ritual = 1.5,
		/obj/item/material/hatchet/butch = 1,
		/obj/item/material/hatchet = 1.5,
		/obj/item/material/hatchet/unathiknife = 0.75,
		/obj/item/material/knife/tacknife = 1
	)

	var/type = pickweight(blades)
	new type(L)

STOCK_ITEM_UNCOMMON(laserscalpel, 1.3)
	var/list/lasers = list(
		/obj/item/surgery/scalpel/laser1 = 3,
		/obj/item/surgery/scalpel/laser2 = 2,
		/obj/item/surgery/scalpel/laser3 = 1
	)
	var/type = pickweight(lasers)
	new type(L)

STOCK_ITEM_UNCOMMON(electropack, 1)
	new /obj/item/device/radio/electropack(L)

	if (istype(L, /obj/structure/closet/crate) && prob(40))
		var/obj/structure/closet/crate/cr = L
		cr.rigged = TRUE
		//Boobytrapped crate, will electrocute when you attempt to open it
		//Can be disarmed with wirecutters or ignored with insulated gloves

STOCK_ITEM_UNCOMMON(monkeyhide, 0.5)
	new /obj/item/stack/material/animalhide/monkey(L, 50)

STOCK_ITEM_UNCOMMON(cathide, 0.5)
	new /obj/item/stack/material/animalhide/cat(L, 50)

STOCK_ITEM_UNCOMMON(corgihide, 0.5)
	new /obj/item/stack/material/animalhide/corgi(L, 50)

STOCK_ITEM_UNCOMMON(lizardhide, 0.5)
	new /obj/item/stack/material/animalhide/lizard(L, 50)

STOCK_ITEM_UNCOMMON(hoodie, 0.5)
	new /obj/random/hoodie(L)

STOCK_ITEM_UNCOMMON(cookingoil, 1)
	var/turf/T = get_turf(L)
	if (!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break
	new /obj/structure/reagent_dispensers/cookingoil(T)

STOCK_ITEM_UNCOMMON(coin, 1.3)
	new /obj/random/coin(L)

STOCK_ITEM_UNCOMMON(nothing, 0)
	// no-op