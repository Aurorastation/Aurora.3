// --- Uncommon ---

STOCK_ITEM_UNCOMMON(shrooms, 2)
	if(prob(65))
		new /obj/item/seeds/glowshroom(L)
	if(prob(5))
		new /obj/item/seeds/ghostmushroomseed(L)
	if(prob(30))
		new /obj/item/seeds/amanitamycelium(L)

STOCK_ITEM_UNCOMMON(plasteel, 3)
	new /obj/item/stack/material/plasteel(L, rand(1,30))

STOCK_ITEM_UNCOMMON(silver, 2)
	new /obj/item/stack/material/silver(L, rand(5,30))

STOCK_ITEM_UNCOMMON(phoronsheets, 0.5)
	new /obj/item/stack/material/phoron(L, rand(5,20))

STOCK_ITEM_UNCOMMON(phoronglass, 0.5)
	new /obj/item/stack/material/glass/phoronglass(L, rand(10,20))

STOCK_ITEM_UNCOMMON(sandstone, 2)
	new /obj/item/stack/material/sandstone(L, 50)

STOCK_ITEM_UNCOMMON(marble, 2)
	new /obj/item/stack/material/marble(L, 50)

STOCK_ITEM_UNCOMMON(iron, 2)
	new /obj/item/stack/material/iron(L, 50)

STOCK_ITEM_UNCOMMON(other_mat, 0.5)
	var/obj/item/stack/material/M = pick(/obj/item/stack/material/osmium, /obj/item/stack/material/mhydrogen, /obj/item/stack/material/tritium, /obj/item/stack/material/bronze)
	new M(L, rand(1, 10))

STOCK_ITEM_UNCOMMON(flare, 2)
	new /obj/item/device/flashlight/flare(L)
	new /obj/item/device/flashlight/flare(L)
	if (prob(50))
		new /obj/random/glowstick(L)

STOCK_ITEM_UNCOMMON(implants, 1)
	if(prob(50))
		new /obj/item/storage/box/cdeathalarm_kit(L)
	else
		new /obj/item/storage/box/trackimp(L)

STOCK_ITEM_UNCOMMON(flashbang, 0.75)
	new /obj/item/storage/box/flashbangs(L)

STOCK_ITEM_UNCOMMON(stinger, 0.75)
	new /obj/item/storage/box/stingers(L)

STOCK_ITEM_UNCOMMON(arrest, 1)
	if(prob(60))
		new /obj/item/storage/box/handcuffs(L)
	else
		new /obj/item/device/holowarrant(L)

STOCK_ITEM_UNCOMMON(monkey, 2)
	if(prob(40))
		var/type = pick( \
			/obj/item/storage/box/monkeycubes/farwacubes, \
			/obj/item/storage/box/monkeycubes/stokcubes, \
			/obj/item/storage/box/monkeycubes/neaeracubes \
		)
		new type(L)
	else
		new /obj/item/storage/box/monkeycubes(L)

STOCK_ITEM_UNCOMMON(specialcrayon, 1.5)
	if(prob(50))
		new /obj/item/pen/crayon/mime(L)
	else
		new /obj/item/pen/crayon/rainbow(L)

STOCK_ITEM_UNCOMMON(contraband, 2)
	for(var/i in 1 to rand(1, 3))
		new /obj/random/contraband(L)

STOCK_ITEM_UNCOMMON(mediumcell, 3)
	for(var/i in 1 to rand(1,2))
		var/type = pick( \
			/obj/item/cell/super, \
			/obj/item/cell/potato, \
			/obj/item/cell/high \
		)
		new type(L)

STOCK_ITEM_UNCOMMON(chempack, 5)
	var/list/chems = GET_SINGLETON_SUBTYPE_MAP(/singleton/reagent/)
	var/list/exclusion = list(/singleton/reagent/drink, /singleton/reagent, /singleton/reagent/adminordrazine, /singleton/reagent/polysomnine/beer2, /singleton/reagent/azoth, /singleton/reagent/elixir,\
		/singleton/reagent/liquid_fire, /singleton/reagent/philosopher_stone, /singleton/reagent/toxin/undead, /singleton/reagent/love_potion, /singleton/reagent/shapesand, /singleton/reagent/usolve,\
		/singleton/reagent/sglue, /singleton/reagent/black_matter, /singleton/reagent/drugs/cocaine, /singleton/reagent/drugs/raskara_dust, /singleton/reagent/drugs/heroin, /singleton/reagent/drugs/joy, /singleton/reagent/toxin/stimm, /singleton/reagent/drugs/impedrezene, /singleton/reagent/bottle_lightning, /singleton/reagent/toxin/hylemnomil, /singleton/reagent/toxin/nanites, /singleton/reagent/nitroglycerin,
		/singleton/reagent/aslimetoxin, /singleton/reagent/sanasomnum, /singleton/reagent/rezadone, /singleton/reagent/kois/black, /singleton/reagent/toxin/carpotoxin)
	chems -= exclusion
	for (var/i in 1 to rand(2, 4))
		var/obj/item/reagent_containers/chem_disp_cartridge/C = new /obj/item/reagent_containers/chem_disp_cartridge(L)
		var/rname = pick(chems)
		//If we get a drink, reroll it once.
		//Should result in a higher chance of getting medicines and chemicals
		if (ispath(rname, /singleton/reagent/drink) || ispath(rname, /singleton/reagent/alcohol))
			rname = pick(chems)
		var/singleton/reagent/R = GET_SINGLETON(rname)
		C.reagents.add_reagent(rname, C.volume)
		C.setLabel(R.name)

STOCK_ITEM_UNCOMMON(robolimbs, 3)
	for(var/i in 1 to rand(1, 2))
		var/manuf = pick(GLOB.fabricator_robolimbs)
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
	for(var/i in 1 to rand(1, 2))
		var/type = pick(allboards)
		new type(L)

STOCK_ITEM_UNCOMMON(jetpack, 3)
	new /obj/item/tank/jetpack/void(L)
	if(prob(40))
		new /obj/item/tank/emergency_oxygen/double(L)

STOCK_ITEM_UNCOMMON(inhaler, 1)
	var/obj/item/reagent_containers/inhaler/I = pick(subtypesof(/obj/item/reagent_containers/inhaler))
	new I(L)

STOCK_ITEM_UNCOMMON(advwelder, 2)
	if(prob(5))
		new /obj/item/weldingtool/experimental(L)
	else
		new /obj/item/weldingtool/hugetank(L)

STOCK_ITEM_UNCOMMON(policebaton, 1.5)
	new /obj/item/melee/classic_baton(L)

STOCK_ITEM_UNCOMMON(stunbaton, 0.75) //batons spawn with no powercell
	var/obj/item/melee/baton/B = new /obj/item/melee/baton(L)
	if(B.bcell)
		QDEL_NULL(B.bcell)

	B.queue_icon_update()

STOCK_ITEM_UNCOMMON(firingpin, 3)
	new /obj/item/storage/box/firingpins(L)

STOCK_ITEM_UNCOMMON(watch, 3)
	new /obj/random/watches(L)

STOCK_ITEM_UNCOMMON(MMI, 1.5)
	new /obj/item/device/mmi(L)

STOCK_ITEM_UNCOMMON(voidsuit, 2)
	new /obj/random/voidsuit(L,1)

STOCK_ITEM_UNCOMMON(violin, 1)
	new /obj/item/device/synthesized_instrument/violin(L)

STOCK_ITEM_UNCOMMON(atmosfiresuit, 2)
	new /obj/item/clothing/head/hardhat/atmos(L)
	new /obj/item/clothing/suit/fire/atmos(L)

STOCK_ITEM_UNCOMMON(debugger, 2)
	new /obj/item/device/debugger(L)

STOCK_ITEM_UNCOMMON(surgerykit, 2.5)
	new /obj/item/storage/firstaid/surgery(L)

STOCK_ITEM_UNCOMMON(crimekit, 1)
	new /obj/item/storage/briefcase/crimekit(L)

STOCK_ITEM_UNCOMMON(carpet, 2)
	new /obj/item/stack/tile/carpet(L, 50)

STOCK_ITEM_UNCOMMON(gift, 4)
	new /obj/item/a_gift(L)

STOCK_ITEM_UNCOMMON(riotshield, 2)
	new /obj/item/shield/riot(L)
	if(prob(20))
		new /obj/item/shield/riot(L)

STOCK_ITEM_UNCOMMON(fireaxe, 1)
	new /obj/item/material/twohanded/fireaxe(L)

STOCK_ITEM_UNCOMMON(service, 2)
	new /obj/item/rfd/service(L)

STOCK_ITEM_UNCOMMON(robot, 2)
	var/list/bots = list(
		/mob/living/bot/cleanbot = 2,
		/mob/living/bot/medbot = 2,
		/mob/living/bot/farmbot = 1,
	)

	var/type = pickweight(bots)
	var/mob/living/bot/newbot = new type(L)
	newbot.on = FALSE	//Deactivated

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

STOCK_ITEM_UNCOMMON(laserpoint, 0.75)
	new /obj/item/device/laser_pointer(L)

STOCK_ITEM_UNCOMMON(manual, 2)
	var/list/booklist = subtypesof(/obj/item/book/manual)
	booklist -= /obj/item/book/manual/wiki //just this one. we want to keep the subtypes.
	booklist -= /obj/item/book/manual/nuclear //yeah no
	var/type = pick(booklist)
	new type(L)

STOCK_ITEM_UNCOMMON(spystuff, 0.75)
	if(prob(40))
		new /obj/item/device/radiojammer(L)
	else
		new /obj/item/clothing/glasses/night(L)

STOCK_ITEM_UNCOMMON(seeds, 1)
	for(var/i in 1 to rand(1, 3))
		var/obj/item/seeds/SP = pick(subtypesof(/obj/item/seeds) - /obj/item/seeds/cutting)
		new SP(L)

STOCK_ITEM_UNCOMMON(rped, 1)
	new /obj/item/storage/part_replacer(L)

STOCK_ITEM_UNCOMMON(briefcase, 2)
	var/list/briefcases = list(
		/obj/item/storage/briefcase = 1,
		/obj/item/storage/briefcase/real = 0.8,
		/obj/item/storage/briefcase/black = 0.8,
		/obj/item/storage/briefcase/aluminium = 0.5,
		/obj/item/storage/briefcase/nt = 0.5
	)

	var/type = pickweight(briefcases)
	new type(L)

STOCK_ITEM_UNCOMMON(blade, 1.2)
	var/list/blades = list(
		/obj/item/material/knife/butterfly = 1,
		/obj/item/material/knife/butterfly/switchblade = 1,
		/obj/item/material/hook = 1.5,
		/obj/item/material/knife/ritual = 1.5,
		/obj/item/material/hatchet/butch = 1,
		/obj/item/material/hatchet = 1.5,
		/obj/item/material/hatchet/unathiknife = 0.75,
		/obj/item/material/knife/tacknife = 1,
		/obj/item/material/knife/bayonet = 0.5
	)

	var/type = pickweight(blades)
	new type(L)

STOCK_ITEM_UNCOMMON(laserscalpel, 1.3)
	new /obj/item/surgery/scalpel/laser(L)

STOCK_ITEM_UNCOMMON(electropack, 1)
	new /obj/item/device/radio/electropack(L)

STOCK_ITEM_UNCOMMON(randomhide, 0.5)
	var/obj/item/stack/material/animalhide/spawn_hide = pick(typesof(/obj/item/stack/material/animalhide))
	new spawn_hide(L, rand(5, 50))

STOCK_ITEM_UNCOMMON(hoodie, 1)
	new /obj/random/hoodie(L)

STOCK_ITEM_UNCOMMON(bang, 0.5)
	var/obj/item/gun/bang/B = pick(subtypesof(/obj/item/gun/bang))
	new B(L)

STOCK_ITEM_UNCOMMON(cookingoil, 1)
	var/turf/T = get_turf(L)
	if(!turf_clear(T))
		for(var/turf/U in range(T,1))
			if(turf_clear(U))
				T = U
				break
	new /obj/structure/reagent_dispensers/cookingoil(T)

STOCK_ITEM_UNCOMMON(coin, 1.3)
	new /obj/random/coin(L)
	if(prob(20))
		new /obj/random/coin(L)

STOCK_ITEM_UNCOMMON(plushie, 1)
	new /obj/random/plushie(L)

STOCK_ITEM_UNCOMMON(flag, 1)
	new /obj/random/random_flag(L)

STOCK_ITEM_UNCOMMON(apiary, 1)
	new /obj/item/bee_pack(L)
	if(prob(75))
		new /obj/item/bee_net(L)
	if(prob(60))
		new /obj/item/bee_smoker(L)
	if(prob(30))
		new /obj/item/honey_frame(L)

STOCK_ITEM_UNCOMMON(wristbound, 0.5)
	var/list/possible_wristbounds = list()
	for(var/thing in subtypesof(/obj/item/modular_computer/handheld/wristbound/preset))
		var/obj/item/modular_computer/handheld/wristbound/preset/P = thing
		if(initial(P.hidden))
			continue
		possible_wristbounds += P
	var/wristbound_type = pick(possible_wristbounds)
	new wristbound_type(L)

STOCK_ITEM_UNCOMMON(pops, 0.5)
	if(prob(85))
		new /obj/item/storage/box/snappops(L)
	else if (prob(25))
		new /obj/item/storage/box/snappops/syndi(L)
	else
		new /obj/item/storage/box/partypopper(L)

STOCK_ITEM_UNCOMMON(collectable_headwear, 0.5)
	var/type = pick(subtypesof(/obj/item/clothing/head/collectable))
	new type(L)

STOCK_ITEM_UNCOMMON(pickaxes, 1)
	var/list/pickaxe_type = list(
		/obj/item/pickaxe = 10,
		/obj/item/pickaxe/hammer = 1,
		/obj/item/pickaxe/silver = 2,
		/obj/item/pickaxe/drill = 5,
		/obj/item/pickaxe/gold = 0.5,
		/obj/item/pickaxe/diamond = 0.25,
		/obj/item/pickaxe/brush = 1,
		/obj/item/pickaxe/hand = 2
		)
	var/type = pickweight(pickaxe_type)
	new type(L)

STOCK_ITEM_UNCOMMON(alt_glasses, 1)
	var/list/glasses = list(/obj/item/clothing/glasses/regular/circle,
			/obj/item/clothing/glasses/regular/jamjar,
			/obj/item/clothing/glasses/threedglasses,
			/obj/item/clothing/glasses/regular/hipster,
			/obj/item/clothing/glasses/regular/scanners)
	var/type = pick(glasses)
	new type(L)

STOCK_ITEM_UNCOMMON(gumballs, 3)
	new /obj/item/glass_jar/gumball(L)

STOCK_ITEM_UNCOMMON(googly, 0.75)
	new /obj/item/storage/box/googly(L)

STOCK_ITEM_UNCOMMON(wizarddressup, 1)
	new /obj/random/wizard_dressup(L)

STOCK_ITEM_UNCOMMON(nothing, 0)
	// no-op
