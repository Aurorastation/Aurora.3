//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

var/list/all_supply_groups = list("Operations","Security","Hospitality","Engineering","Atmospherics","Medical","Reagents","Reagent Cartridges","Science","Hydroponics", "Supply", "Miscellaneous")

/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/amount = null
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/group = "Operations"

/datum/supply_packs/New()
	manifest += "<ul>"
	for(var/path in contains)
		if(!path || !ispath(path, /atom))
			continue
		var/atom/O = path
		manifest += "<li>[initial(O.name)]</li>"
	manifest += "</ul>"

/datum/supply_packs/specialops
	name = "Special Ops supplies"
	contains = list(/obj/item/storage/box/emps,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/pen/reagent/paralysis,
					/obj/item/grenade/chem_grenade/incendiary)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "crate"
	group = "Security"
	hidden = 1

/datum/supply_packs/randomised/illegalguns
	name = "Illegal weapons crate"
	num_contained = 2
	contains = list(/obj/item/gun/projectile/automatic/mini_uzi,
					/obj/item/gun/projectile/shotgun/pump/rifle,
					/obj/item/gun/projectile/silenced,
					/obj/item/gun/projectile/pirate,
					/obj/item/gun/projectile/revolver/derringer,
					/obj/item/gun/projectile/dragunov,
					/obj/item/gun/energy/retro)
	cost = 120
	containertype = /obj/structure/closet/crate
	containername = "crate"
	contraband = 1
	group = "Security"

/datum/supply_packs/forensics
	name = "Auxiliary forensic tools"
	contains = list(/obj/item/forensics/sample_kit,
					/obj/item/forensics/sample_kit/powder,
					/obj/item/storage/box/swabs,
					/obj/item/storage/box/swabs,
					/obj/item/storage/box/swabs,
					/obj/item/storage/box/slides,
					/obj/item/reagent_containers/spray/luminol,
					/obj/item/device/uv_light)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Auxiliary forensic tools"
	group = "Security"

/datum/supply_packs/food
	name = "Kitchen supply crate"
	contains = list(/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/spacespice,
					/obj/item/reagent_containers/food/condiment/peppermill,
					/obj/item/reagent_containers/food/condiment/saltshaker,
					/obj/item/reagent_containers/food/condiment/enzyme,
					/obj/item/reagent_containers/food/drinks/milk,
					/obj/item/reagent_containers/food/drinks/milk,
					/obj/item/reagent_containers/food/drinks/soymilk,
					/obj/item/reagent_containers/food/drinks/soymilk,
					/obj/item/storage/fancy/egg_box,
					/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/reagent_containers/food/snacks/meat)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "Food crate"
	group = "Supply"

/datum/supply_packs/monkey
	name = "Monkey crate"
	contains = list (/obj/item/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Monkey crate"
	group = "Hydroponics"

/datum/supply_packs/farwa
	name = "Farwa crate"
	contains = list (/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Farwa crate"
	group = "Hydroponics"

/datum/supply_packs/skrell
	name = "Neaera crate"
	contains = list (/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Neaera crate"
	group = "Hydroponics"

/datum/supply_packs/stok
	name = "Stok crate"
	contains = list (/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Stok crate"
	group = "Hydroponics"

/datum/supply_packs/beanbagammo
	name = "Beanbag shells"
	contains = list(/obj/item/ammo_magazine/shotgun/beanbag,
					/obj/item/ammo_magazine/shotgun/beanbag,
					/obj/item/ammo_magazine/shotgun/beanbag)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Beanbag shells"
	group = "Security"

/datum/supply_packs/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Toner cartridges"
	group = "Supply"

/datum/supply_packs/party
	name = "Party equipment"
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/reagent_containers/food/drinks/shaker,
					/obj/item/reagent_containers/food/drinks/flask/barflask,
					/obj/item/reagent_containers/food/drinks/bottle/patron,
					/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
					/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine,
					/obj/item/storage/fancy/cigarettes/dromedaryco,
					/obj/item/lipstick/random,
					/obj/item/reagent_containers/food/drinks/bottle/small/ale,
					/obj/item/reagent_containers/food/drinks/bottle/small/ale,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Party equipment"
	group = "Hospitality"

/datum/supply_packs/lasertag
	name = "Lasertag equipment"
	contains = list(/obj/item/gun/energy/lasertag/red,
					/obj/item/clothing/suit/redtag,
					/obj/item/gun/energy/lasertag/blue,
					/obj/item/clothing/suit/bluetag)
	containertype = /obj/structure/closet
	containername = "Lasertag Closet"
	group = "Hospitality"
	cost = 20

/datum/supply_packs/internals
	name = "Internals crate"
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/tank/air)
	cost = 10
	containertype = /obj/structure/closet/crate/internals
	containername = "Internals crate"
	group = "Atmospherics"

/datum/supply_packs/evacuation
	name = "Emergency equipment"
	contains = list(/obj/item/storage/toolbox/emergency,
					/obj/item/storage/toolbox/emergency,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/tank/emergency_oxygen/engi,
					/obj/item/tank/emergency_oxygen/engi,
					/obj/item/tank/emergency_oxygen/engi,
					/obj/item/tank/emergency_oxygen/engi,
			 		/obj/item/clothing/suit/space/emergency,
			 		/obj/item/clothing/suit/space/emergency,
			 		/obj/item/clothing/suit/space/emergency,
			 		/obj/item/clothing/suit/space/emergency,
					/obj/item/clothing/head/helmet/space/emergency,
					/obj/item/clothing/head/helmet/space/emergency,
					/obj/item/clothing/head/helmet/space/emergency,
					/obj/item/clothing/head/helmet/space/emergency,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas)
	cost = 45
	containertype = /obj/structure/closet/crate/internals
	containername = "Emergency crate"
	group = "Atmospherics"




/datum/supply_packs/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/storage/briefcase/inflatable,
					/obj/item/storage/briefcase/inflatable,
					/obj/item/storage/briefcase/inflatable)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Inflatable Barrier Crate"
	group = "Atmospherics"

/datum/supply_packs/janitor
	name = "Janitorial supplies"
	contains = list(/obj/item/reagent_containers/glass/bucket,
					/obj/item/mop,
					/obj/item/caution,
					/obj/item/caution,
					/obj/item/caution,
					/obj/item/caution,
					/obj/item/storage/bag/trash,
					/obj/item/device/lightreplacer,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/reagent_containers/glass/rag,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/structure/mopbucket)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Janitorial supplies"
	group = "Supply"

/datum/supply_packs/lightbulbs
	name = "Replacement lights"
	contains = list(/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement lights"
	group = "Engineering"

/datum/supply_packs/wizard
	name = "Wizard costume"
	contains = list(/obj/item/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Wizard costume crate"
	group = "Miscellaneous"

/datum/supply_packs/mule
	name = "MULEbot Crate"
	contains = list(/obj/machinery/bot/mulebot)
	cost = 20
	containertype = /obj/structure/largecrate/mule
	containername = "MULEbot Crate"
	group = "Operations"

/datum/supply_packs/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	cost = 45
	containertype = /obj/structure/largecrate
	containername = "Cargo Train Tug Crate"
	group = "Operations"

/datum/supply_packs/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "Cargo Train Trolley Crate"
	group = "Operations"

/datum/supply_packs/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "Corgi Crate"
	group = "Hydroponics"

/datum/supply_packs/hydroponics // -- Skie
	name = "Hydroponics Supply Crate"
	contains = list(/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/material/hatchet,
					/obj/item/material/minihoe,
					/obj/item/device/analyzer/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron,
					/obj/item/material/minihoe,
					/obj/item/storage/box/botanydisk
					) // Updated with new things
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics crate"
	access = access_hydroponics
	group = "Hydroponics"

//farm animals - useless and annoying, but potentially a good source of food
/datum/supply_packs/cow
	name = "Cow crate"
	cost = 30
	containertype = /obj/structure/largecrate/animal/cow
	containername = "Cow crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/goat
	name = "Goat crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/goat
	containername = "Goat crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/chicken
	name = "Chicken crate"
	cost = 20
	containertype = /obj/structure/largecrate/animal/chick
	containername = "Chicken crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/seeds
	name = "Seeds crate"
	contains = list(/obj/item/seeds/chiliseed,
					/obj/item/seeds/berryseed,
					/obj/item/seeds/cornseed,
					/obj/item/seeds/eggplantseed,
					/obj/item/seeds/tomatoseed,
					/obj/item/seeds/appleseed,
					/obj/item/seeds/soyaseed,
					/obj/item/seeds/wheatseed,
					/obj/item/seeds/carrotseed,
					/obj/item/seeds/harebell,
					/obj/item/seeds/lemonseed,
					/obj/item/seeds/orangeseed,
					/obj/item/seeds/grassseed,
					/obj/item/seeds/sunflowerseed,
					/obj/item/seeds/chantermycelium,
					/obj/item/seeds/potatoseed,
					/obj/item/seeds/sugarcaneseed)
	cost = 10
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Seeds crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/weedcontrol
	name = "Weed control crate"
	contains = list(/obj/item/material/hatchet,
					/obj/item/material/hatchet,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/grenade/chem_grenade/antiweed,
					/obj/item/grenade/chem_grenade/antiweed)
	cost = 25
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Weed control crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/exoticseeds
	name = "Exotic seeds crate"
	contains = list(/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/libertymycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/random,
					/obj/item/seeds/kudzuseed)
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Exotic Seeds crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/medical
	name = "Medical crate"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/adv,
					/obj/item/reagent_containers/glass/bottle/antitoxin,
					/obj/item/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/reagent_containers/glass/bottle/stoxin,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/autoinjectors)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "Medical crate"
	group = "Medical"

/datum/supply_packs/bloodpack
	name = "BloodPack crate"
	contains = list(/obj/item/storage/box/bloodpacks,
                    /obj/item/storage/box/bloodpacks,
                    /obj/item/storage/box/bloodpacks)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "BloodPack crate"
	group = "Medical"

/datum/supply_packs/bodybag
	name = "Body bag crate"
	contains = list(/obj/item/storage/box/bodybags,
                    /obj/item/storage/box/bodybags,
                    /obj/item/storage/box/bodybags)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "Body bag crate"
	group = "Medical"

/datum/supply_packs/cryobag
	name = "Statis bag crate"
	contains = list(/obj/item/bodybag/cryobag,
				    /obj/item/bodybag/cryobag,
	    			/obj/item/bodybag/cryobag)
	cost = 50
	containertype = /obj/structure/closet/crate/medical
	containername = "Stasis bag crate"
	group = "Medical"

/datum/supply_packs/virus
	name = "Virus sample crate"
/*	contains = list(/obj/item/reagent_containers/glass/bottle/flu_virion,
					/obj/item/reagent_containers/glass/bottle/cold,
					/obj/item/reagent_containers/glass/bottle/epiglottis_virion,
					/obj/item/reagent_containers/glass/bottle/liver_enhance_virion,
					/obj/item/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/reagent_containers/glass/bottle/magnitis,
					/obj/item/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/reagent_containers/glass/bottle/brainrot,
					/obj/item/reagent_containers/glass/bottle/hullucigen_virion,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/glass/bottle/mutagen)*/
	contains = list(/obj/item/virusdish/random,
					/obj/item/virusdish/random,
					/obj/item/virusdish/random,
					/obj/item/virusdish/random)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Virus sample crate"
	access = access_cmo
	group = "Science"

/datum/supply_packs/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/material/steel)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"
	group = "Engineering"

/datum/supply_packs/metal200
	name = "Bulk metal crate"
	contains = list(/obj/item/stack/material/steel, /obj/item/stack/material/steel, /obj/item/stack/material/steel,/obj/item/stack/material/steel)
	amount = 50
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "Bulk metal crate"
	group = "Engineering"

/datum/supply_packs/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/material/glass)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"
	group = "Engineering"

/datum/supply_packs/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"
	group = "Engineering"

/datum/supply_packs/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/item/stack/material/plastic)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Plastic sheets crate"
	group = "Engineering"

/datum/supply_packs/smescoil
	name = "Superconducting Magnetic Coil"
	contains = list(/obj/item/smes_coil)
	cost = 75
	containertype = /obj/structure/closet/crate
	containername = "Superconducting Magnetic Coil crate"
	group = "Engineering"

/datum/supply_packs/electrical
	name = "Electrical maintenance crate"
	contains = list(/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/clothing/gloves/yellow,
					/obj/item/clothing/gloves/yellow,
					/obj/item/cell,
					/obj/item/cell,
					/obj/item/cell/high,
					/obj/item/cell/high)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Electrical maintenance crate"
	group = "Engineering"

/datum/supply_packs/mechanical
	name = "Mechanical maintenance crate"
	contains = list(/obj/item/storage/belt/utility/full,
					/obj/item/storage/belt/utility/full,
					/obj/item/storage/belt/utility/full,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Mechanical maintenance crate"
	group = "Engineering"

/datum/supply_packs/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"
	group = "Hydroponics"

/datum/supply_packs/fueltank
	name = "Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"
	group = "Engineering"

/datum/supply_packs/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"
	group = "Science"

/datum/supply_packs/solar
	name = "Solar Pack crate"
	contains  = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly, // 21 Solar Assemblies. 1 Extra for the controller,
					/obj/item/circuitboard/solar_control,
					/obj/item/tracker_electronics,
					/obj/item/paper/solar)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Solar pack crate"
	group = "Engineering"

/datum/supply_packs/engine
	name = "Emitter crate"
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Emitter crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/engine/field_gen
	name = "Field Generator crate"
	contains = list(/obj/machinery/field_generator,
					/obj/machinery/field_generator)
	containertype = /obj/structure/closet/crate/secure
	containername = "Field Generator crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/engine/sing_gen
	name = "Singularity Generator crate"
	contains = list(/obj/machinery/the_singularitygen)
	containertype = /obj/structure/closet/crate/secure
	containername = "Singularity Generator crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/engine/collector
	name = "Collector crate"
	contains = list(/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector)
	containername = "Collector crate"
	group = "Engineering"

/datum/supply_packs/engine/PA
	name = "Particle Accelerator crate"
	cost = 40
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	containertype = /obj/structure/closet/crate/secure
	containername = "Particle Accelerator crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(/obj/item/book/manual/ripley_build_and_repair,
					/obj/item/circuitboard/mecha/ripley/main, //TEMPORARY due to lack of circuitboard printer,
					/obj/item/circuitboard/mecha/ripley/peripherals) //TEMPORARY due to lack of circuitboard printer
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics
	group = "Science"

/datum/supply_packs/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(/obj/item/circuitboard/mecha/odysseus/peripherals, //TEMPORARY due to lack of circuitboard printer,
					/obj/item/circuitboard/mecha/odysseus/main) //TEMPORARY due to lack of circuitboard printer
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\"Odysseus\" Circuit Crate"
	access = access_robotics
	group = "Science"

/datum/supply_packs/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	containertype = /obj/structure/largecrate/hoverpod
	containername = "Hoverpod Crate"
	group = "Operations"

/datum/supply_packs/robotics
	name = "Robotics assembly crate"
	contains = list(/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/storage/toolbox/electrical,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/cell/high,
					/obj/item/cell/high)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robotics assembly"
	access = access_robotics
	group = "Engineering"

/datum/supply_packs/phoron
	name = "Phoron assembly crate"
	contains = list(/obj/item/tank/phoron,
					/obj/item/tank/phoron,
					/obj/item/tank/phoron,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Phoron assembly crate"
	access = access_tox_storage
	group = "Science"

/datum/supply_packs/weapons
	name = "Weapons crate"
	contains = list(/obj/item/gun/energy/rifle/laser,
					/obj/item/gun/energy/rifle/laser,
					/obj/item/gun/projectile/sec,
					/obj/item/gun/projectile/sec,
					/obj/item/ammo_magazine/c45m,
					/obj/item/ammo_magazine/c45m)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = access_security
	group = "Security"

/datum/supply_packs/nonlethals
	name = "Nonlethal Weapons crate"
	contains = list(/obj/item/melee/baton,
					/obj/item/melee/baton,
					/obj/item/gun/energy/taser,
					/obj/item/gun/energy/taser,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/flashbangs,
					/obj/item/ammo_magazine/tranq,
					/obj/item/storage/box/zipties)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = access_security
	group = "Security"

/datum/supply_packs/flareguns
	name = "Flare guns crate"
	contains = list(/obj/item/gun/projectile/sec/flash,
					/obj/item/ammo_magazine/c45m/flash,
					/obj/item/gun/projectile/shotgun/doublebarrel/flare,
					/obj/item/storage/box/flashshells)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Flare gun crate"
	access = access_security
	group = "Security"

/datum/supply_packs/randomised/armor
	num_contained = 5
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest/security,
					/obj/item/clothing/suit/storage/vest/detective,
					/obj/item/clothing/suit/storage/vest/hos,
					/obj/item/clothing/suit/storage/vest/pcrc,
					/obj/item/clothing/suit/storage/vest/warden,
					/obj/item/clothing/suit/storage/vest/officer,
					/obj/item/clothing/suit/storage/vest)

	name = "Armor crate"
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor crate"
	access = access_security
	group = "Security"


/datum/supply_packs/riot
	name = "Riot gear crate"
	contains = list(/obj/item/melee/baton,
					/obj/item/melee/baton,
					/obj/item/melee/baton,
					/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/handcuffs,
					/obj/item/handcuffs,
					/obj/item/handcuffs,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas,
					/obj/item/storage/box/beanbags,
					/obj/item/storage/box/handcuffs)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Riot gear crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/energyweapons
	name = "Energy weapons crate"
	contains = list(/obj/item/gun/energy/rifle/laser,
					/obj/item/gun/energy/rifle/laser,
					/obj/item/gun/energy/rifle/laser)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "energy weapons crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/shotgun
	name = "Shotgun crate"
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/head/helmet/ballistic,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun/shell,
					/obj/item/gun/projectile/shotgun/pump/combat,
					/obj/item/gun/projectile/shotgun/pump/combat)
	cost = 65
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/head/helmet/ablative,
					/obj/item/gun/energy/sniperrifle,
					/obj/item/gun/energy/sniperrifle)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy marksman crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/shotgunammo
	name = "Ballistic ammunition crate"
	contains = list(/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun/shell,
					/obj/item/ammo_magazine/shotgun/shell,
					/obj/item/ammo_magazine/shotgun/incendiary)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic ammunition crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/ionweapons
	name = "Electromagnetic weapons crate"
	contains = list(/obj/item/gun/energy/ionrifle,
					/obj/item/gun/energy/ionrifle,
					/obj/item/ammo_magazine/shotgun/emp,
					/obj/item/storage/box/emps)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "electromagnetic weapons crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/randomised/automatic
	name = "Automatic weapon crate"
	num_contained = 2
	contains = list(/obj/item/gun/projectile/automatic/wt550,
					/obj/item/gun/projectile/automatic/rifle/z8)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/randomised/autoammo
	name = "Automatic weapon ammunition crate"
	num_contained = 6
	contains = list(/obj/item/ammo_magazine/mc9mmt,
					/obj/item/ammo_magazine/mc9mmt/rubber,
					/obj/item/ammo_magazine/a556)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon ammunition crate"
	access = access_armory
	group = "Security"

/*
/datum/supply_packs/loyalty
	name = "Loyalty implant crate"
	contains = list (/obj/item/storage/lockbox/loyalty)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Loyalty implant crate"
	access = access_armory
	group = "Security"
*/

/datum/supply_packs/expenergy
	name = "Experimental energy gear crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/head/helmet/ablative,
					/obj/item/gun/energy/gun,
					/obj/item/gun/energy/gun)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental energy gear crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/exparmor
	name = "Experimental armor crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,,
					/obj/item/clothing/head/helmet/ablative,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/head/helmet/ballistic,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental armor crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/securitybarriers
	name = "Security barrier crate"
	contains = list(/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Security barrier crate"
	group = "Security"

/datum/supply_packs/securitybarriers
	name = "Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "wall shield generators crate"
	access = access_teleporter
	group = "Security"

/datum/supply_packs/randomised
	var/num_contained = 4 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	name = "Collectable hat crate!"
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Collectable hats crate! Brought to you by Bass.inc!"
	group = "Miscellaneous"

/datum/supply_packs/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()

/datum/supply_packs/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(/obj/item/storage/fancy/crayons,
	/obj/item/device/camera,
	/obj/item/device/camera_film,
	/obj/item/device/camera_film,
	/obj/item/storage/photo_album,
	/obj/item/packageWrap,
	/obj/item/reagent_containers/glass/paint/red,
	/obj/item/reagent_containers/glass/paint/green,
	/obj/item/reagent_containers/glass/paint/blue,
	/obj/item/reagent_containers/glass/paint/yellow,
	/obj/item/reagent_containers/glass/paint/purple,
	/obj/item/reagent_containers/glass/paint/black,
	/obj/item/reagent_containers/glass/paint/white,
	/obj/item/contraband/poster,
	/obj/item/wrapping_paper,
	/obj/item/wrapping_paper,
	/obj/item/wrapping_paper)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Arts and Crafts crate"
	group = "Operations"


/datum/supply_packs/randomised/contraband
	num_contained = 5
	contains = list(/obj/item/seeds/bloodtomatoseed,
					/obj/item/storage/pill_bottle/zoom,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/reagent_containers/food/drinks/bottle/pwine)

	name = "Contraband crate"
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Unlabeled crate"
	contraband = 1
	group = "Operations"

/datum/supply_packs/boxes
	name = "Empty boxes"
	contains = list(/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box,
	/obj/item/storage/box)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Empty box crate"
	group = "Supply"

/datum/supply_packs/surgery
	name = "Surgery crate"
	contains = list(/obj/item/cautery,
					/obj/item/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/FixOVein,
					/obj/item/hemostat,
					/obj/item/scalpel,
					/obj/item/bonegel,
					/obj/item/retractor,
					/obj/item/bonesetter,
					/obj/item/circular_saw)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Surgery crate"
	access = access_medical
	group = "Medical"

/datum/supply_packs/sterile
	name = "Sterile equipment crate"
	contains = list(/obj/item/clothing/under/rank/medical/green,
					/obj/item/clothing/under/rank/medical/green,
					/obj/item/clothing/head/surgery/green,
					/obj/item/clothing/head/surgery/green,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/storage/belt/medical,
					/obj/item/storage/belt/medical,
					/obj/item/storage/belt/medical)
	cost = 15
	containertype = "/obj/structure/closet/crate"
	containername = "Sterile equipment crate"
	group = "Medical"

/datum/supply_packs/beer
	contains = list(/obj/structure/reagent_dispensers/beerkeg)
	name = "Beer Keg"
	cost = 10
	containertype = /obj/structure/largecrate
	containername = "Beer Crate"
	group = "Hospitality"

/datum/supply_packs/xuizi
	contains = list(/obj/structure/reagent_dispensers/xuizikeg)
	name = "Xuizi Juice Keg"
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "Xuizi Juice Crate"
	group = "Hospitality"

/datum/supply_packs/randomised/pizza
	num_contained = 5
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	name = "Surprise pack of five pizzas"
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "Pizza crate"
	group = "Hospitality"

/datum/supply_packs/randomised/costume
	num_contained = 2
	contains = list(/obj/item/clothing/suit/pirate,
					/obj/item/clothing/suit/judgerobe,
					/obj/item/clothing/accessory/wcoat,
					/obj/item/clothing/suit/hastur,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/suit/imperium_monk,
					/obj/item/clothing/suit/ianshirt,
					/obj/item/clothing/under/gimmick/rank/captain/suit,
					/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/under/rank/mailman,
					/obj/item/clothing/under/dress/dress_saloon,
					/obj/item/clothing/accessory/suspenders,
					/obj/item/clothing/suit/storage/toggle/labcoat/mad,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
					/obj/item/clothing/under/owl,
					/obj/item/clothing/under/waiter,
					/obj/item/clothing/under/gladiator,
					/obj/item/clothing/under/soviet,
					/obj/item/clothing/under/scratch,
					/obj/item/clothing/under/wedding/bride_white,
					/obj/item/clothing/suit/chef,
					/obj/item/clothing/suit/apron/overalls,
					/obj/item/clothing/under/redcoat,
					/obj/item/clothing/under/kilt)
	name = "Costumes crate"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Actor Costumes"
	group = "Miscellaneous"

/datum/supply_packs/formal_wear
	contains = list(/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/that,
					/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket,
					/obj/item/clothing/suit/storage/lawyer/purpjacket,
					/obj/item/clothing/under/suit_jacket,
					/obj/item/clothing/under/suit_jacket/female,
					/obj/item/clothing/under/suit_jacket/really_black,
					/obj/item/clothing/under/suit_jacket/red,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/suit/wcoat)
	name = "Formalwear closet"
	cost = 30
	containertype = /obj/structure/closet
	containername = "Formalwear for the best occasions."
	group = "Miscellaneous"

/datum/supply_packs/randomised/card_packs
	num_contained = 5
	contains = list(/obj/item/pack/cardemon,
					/obj/item/pack/spaceball,
					/obj/item/deck/holder)
	name = "Trading Card Crate"
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "cards crate"
	group = "Miscellaneous"

/datum/supply_packs/shield_gen
	contains = list(/obj/item/circuitboard/shield_gen)
	name = "Bubble shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "bubble shield generator circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/shield_gen_ex
	contains = list(/obj/item/circuitboard/shield_gen_ex)
	name = "Hull shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "hull shield generator circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/shield_cap
	contains = list(/obj/item/circuitboard/shield_cap)
	name = "Bubble shield capacitor circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "shield capacitor circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/smbig
	name = "Supermatter Core"
	contains = list(/obj/machinery/power/supermatter)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Supermatter crate (CAUTION)"
	group = "Engineering"
	access = access_ce


/* /datum/supply_packs/smsmall // Currently nonfunctional, waiting on virgil
	name = "Supermatter Shard"
	contains = list(/obj/machinery/power/supermatter/shard)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Supermatter shard crate (CAUTION)"
	access = access_ce
	group = "Engineering" */

/datum/supply_packs/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "EFTPOS crate"
	group = "Miscellaneous"

/datum/supply_packs/teg
	contains = list(/obj/machinery/power/generator)
	name = "Mark I Thermoelectric Generator"
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Mk1 TEG crate"
	group = "Engineering"
	access = access_engine

/datum/supply_packs/circulator
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	name = "Binary atmospheric circulator"
	cost = 60
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Atmospheric circulator crate"
	group = "Engineering"
	access = access_engine

/datum/supply_packs/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Pipe Dispenser Crate"
	group = "Engineering"
	access = access_atmospherics

/datum/supply_packs/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Disposal Dispenser Crate"
	group = "Engineering"
	access = access_atmospherics

/datum/supply_packs/bee_keeper
	name = "Beekeeping crate"
	contains = list(/obj/item/beehive_assembly,
					/obj/item/bee_smoker,
					/obj/item/bee_net,
					/obj/item/bee_net,
					/obj/item/clothing/suit/bio_suit/general,//beekeeping suit
					/obj/item/clothing/head/bio_hood/general,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/bee_pack,
					/obj/machinery/honey_extractor,
					/obj/item/book/manual/hydroponics_beekeeping)
	cost = 40
	containertype = /obj/structure/largecrate
	containername = "Beekeeping crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/aliengloves
	name = "Non-Human Glove Kit"
	contains = list(/obj/item/clothing/gloves/yellow/specialt,
					/obj/item/clothing/gloves/yellow/specialt,
					/obj/item/clothing/gloves/yellow/specialt,
					/obj/item/clothing/gloves/yellow/specialu,
					/obj/item/clothing/gloves/yellow/specialu,
					/obj/item/clothing/gloves/yellow/specialu)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "speciality gloves kit"
	group = "Supply"

/datum/supply_packs/alienmedicalgloves
	name = "Non-Human Sterile Glove Kit"
	contains = list(/obj/item/clothing/gloves/latex/unathi,
					/obj/item/clothing/gloves/latex/unathi,
					/obj/item/clothing/gloves/latex/unathi,
					/obj/item/clothing/gloves/latex/tajara,
					/obj/item/clothing/gloves/latex/tajara,
					/obj/item/clothing/gloves/latex/tajara)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "speciality sterile gloves kit"
	group = "Medical"

/datum/supply_packs/cardboard_sheets
	contains = list(/obj/item/stack/material/cardboard)
	name = "50 cardboard sheets"
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Cardboard sheets crate"
	group = "Miscellaneous"

/datum/supply_packs/bureaucracy
	contains = list(/obj/item/clipboard,
					 /obj/item/clipboard,
					 /obj/item/pen/red,
					 /obj/item/pen/blue,
					 /obj/item/pen/blue,
					 /obj/item/device/camera_film,
					 /obj/item/folder/blue,
					 /obj/item/folder/red,
					 /obj/item/folder/yellow,
					 /obj/item/hand_labeler,
					 /obj/item/tape_roll,
					 /obj/structure/filingcabinet/chestdrawer{anchored = 0},
					 /obj/item/paper_bin)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Office supplies crate"
	group = "Supply"

/datum/supply_packs/radsuit
	contains = list(/obj/item/clothing/suit/radiation,
					/obj/item/clothing/suit/radiation,
					/obj/item/clothing/suit/radiation,
					/obj/item/clothing/head/radiation,
					/obj/item/clothing/head/radiation,
					/obj/item/clothing/head/radiation)
	name = "Radiation suits package"
	cost = 20
	containertype = /obj/structure/closet/radiation
	containername = "Radiation suit locker"
	group = "Engineering"

/datum/supply_packs/tactical
	name = "Tactical suits"
	containertype = /obj/structure/closet/crate/secure
	containername = "Tactical Suit Locker"
	cost = 45
	group = "Security"
	access = access_armory
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/sunglasses/sechud/tactical,
					/obj/item/storage/belt/security/tactical,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/gloves/black,
					/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/sunglasses/sechud/tactical,
					/obj/item/storage/belt/security/tactical,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/gloves/black)

/datum/supply_packs/carpet
	name = "Imported carpet"
	containertype = /obj/structure/closet
	containername = "Imported carpet crate"
	cost = 15
	group = "Miscellaneous"
	contains = list(/obj/item/stack/tile/carpet)
	amount = 50

/datum/supply_packs/hydrotray
	name = "Empty hydroponics tray"
	cost = 10
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics tray crate"
	group = "Hydroponics"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0})
	access = access_hydroponics

/datum/supply_packs/canister_empty
	name = "Empty gas canister"
	cost = 7
	containername = "Empty gas canister crate"
	containertype = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister)
	group = "Atmospherics"

/datum/supply_packs/canister_air
	name = "Air canister"
	cost = 10
	containername = "Air canister crate"
	containertype = /obj/structure/largecrate
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/air)

/datum/supply_packs/canister_oxygen
	name = "Oxygen canister"
	cost = 15
	containername = "Oxygen canister crate"
	containertype = /obj/structure/largecrate
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)

/datum/supply_packs/canister_nitrogen
	name = "Nitrogen canister"
	cost = 10
	containername = "Nitrogen canister crate"
	containertype = /obj/structure/largecrate
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)

/datum/supply_packs/canister_phoron
	name = "Phoron gas canister"
	cost = 60
	containername = "Phoron gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)

/datum/supply_packs/canister_sleeping_agent
	name = "N2O gas canister"
	cost = 40
	containername = "N2O gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)

/datum/supply_packs/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	cost = 40
	containername = "CO2 canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)

/datum/supply_packs/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	cost = 45
	containername = "P.A.C.M.A.N. Portable Generator Construction Kit"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"
	access = access_tech_storage
	contains = list(/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/circuitboard/pacman)

/datum/supply_packs/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	cost = 55
	containername = "Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"
	access = access_tech_storage
	contains = list(/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/circuitboard/pacman/super)

/datum/supply_packs/witch
	name = "Witch costume"
	containername = "Witch costume"
	containertype = /obj/structure/closet
	cost = 20
	contains = list(/obj/item/clothing/suit/wizrobe/marisa/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/marisa/fake,
					/obj/item/staff/broom)
	group = "Miscellaneous"

/datum/supply_packs/randomised/costume_hats
	name = "Costume hats"
	containername = "Actor hats crate"
	containertype = /obj/structure/closet
	cost = 10
	num_contained = 2
	contains = list(/obj/item/clothing/head/redcoat,
					/obj/item/clothing/head/mailman,
					/obj/item/clothing/head/plaguedoctorhat,
					/obj/item/clothing/head/pirate,
					/obj/item/clothing/head/hasturhood,
					/obj/item/clothing/head/powdered_wig,
					/obj/item/clothing/head/hairflower,
					/obj/item/clothing/mask/gas/owl_mask,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/head/helmet/gladiator,
					/obj/item/clothing/head/ushanka)
	group = "Miscellaneous"

/datum/supply_packs/randomised/webbing
	name = "Webbing crate"
	num_contained = 1
	contains = list(/obj/item/clothing/accessory/holster,
					/obj/item/clothing/accessory/storage/brown_vest,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/clothing/accessory/storage)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Webbing crate"
	group = "Operations"

/datum/supply_packs/spare_pda
	name = "Spare PDAs"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Spare PDA crate"
	group = "Supply"
	contains = list(/obj/item/device/pda,
					/obj/item/device/pda,
					/obj/item/device/pda)

/datum/supply_packs/randomised/dresses
	name = "Womens formal dress locker"
	containername = "Pretty dress locker"
	containertype = /obj/structure/closet
	cost = 15
	num_contained = 1
	contains = list(/obj/item/clothing/under/wedding/bride_orange,
					/obj/item/clothing/under/wedding/bride_purple,
					/obj/item/clothing/under/wedding/bride_blue,
					/obj/item/clothing/under/wedding/bride_red,
					/obj/item/clothing/under/wedding/bride_white,
					/obj/item/clothing/under/sundress,
					/obj/item/clothing/under/dress/dress_green,
					/obj/item/clothing/under/dress/dress_pink,
					/obj/item/clothing/under/dress/dress_orange,
					/obj/item/clothing/under/dress/dress_yellow,
					/obj/item/clothing/under/dress/dress_saloon)
	group = "Miscellaneous"

/datum/supply_packs/painters
	name = "Station Painting Supplies"
	cost = 10
	containername = "station painting supplies crate"
	containertype = /obj/structure/closet/crate
	group = "Engineering"
	contains = list(/obj/item/device/pipe_painter,
					/obj/item/device/pipe_painter,
					/obj/item/device/floor_painter,
					/obj/item/device/floor_painter)

/datum/supply_packs/bluespacerelay
	name = "Emergency Bluespace Relay Assembly Kit"
	cost = 75
	containername = "emergency bluespace relay assembly kit"
	containertype = /obj/structure/closet/crate
	group = "Engineering"
	contains = list(/obj/item/circuitboard/bluespacerelay,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/subspace/filter,
					/obj/item/stock_parts/subspace/crystal,
					/obj/item/storage/toolbox/electrical)

/datum/supply_packs/randomised/exosuit_mod
	num_contained = 1
	contains = list(
		/obj/item/device/kit/paint/ripley,
		/obj/item/device/kit/paint/ripley/death,
		/obj/item/device/kit/paint/ripley/flames_red,
		/obj/item/device/kit/paint/ripley/flames_blue
		)
	name = "Random APLU modkit"
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "heavy crate"
	group = "Miscellaneous"

/datum/supply_packs/randomised/exosuit_mod/durand
	contains = list(
		/obj/item/device/kit/paint/durand,
		/obj/item/device/kit/paint/durand/seraph,
		/obj/item/device/kit/paint/durand/phazon
		)
	name = "Random Durand exosuit modkit"

/datum/supply_packs/randomised/exosuit_mod/gygax
	contains = list(
		/obj/item/device/kit/paint/gygax,
		/obj/item/device/kit/paint/gygax/darkgygax,
		/obj/item/device/kit/paint/gygax/recitence
		)
	name = "Random Gygax exosuit modkit"

/datum/supply_packs/jukebox
	name = "Jukebox"
	contains = list(/obj/machinery/media/jukebox/)
	cost = 200
	containertype = /obj/structure/largecrate
	containername = "jukebox Crate"
	group = "Hospitality"

//voidsuit crates

/datum/supply_packs/voidsuitcrate_eng
	name = "Engineering Voidsuit Crate"
	contains = list(/obj/item/clothing/head/helmet/space/void/engineering,
					/obj/item/clothing/suit/space/void/engineering)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "engineer voidsuit kit"
	access = access_engine_equip
	group = "Engineering"

/datum/supply_packs/voidsuitcrate_sec
	name = "Security Voidsuit Crate"
	contains = list(/obj/item/clothing/head/helmet/space/void/security,
					/obj/item/clothing/suit/space/void/security)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "security voidsuit kit"
	access = access_security
	group = "Security"

/datum/supply_packs/voidsuitcrate_med
	name = "Medical Voidsuit Crate"
	contains = list(/obj/item/clothing/head/helmet/space/void/medical,
					/obj/item/clothing/suit/space/void/medical)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "medical voidsuit kit"
	access = access_medical
	group = "Medical"

/datum/supply_packs/voidsuitcrate_atmos
	name = "Atmospherics Voidsuit Crate"
	contains = list(/obj/item/clothing/head/helmet/space/void/atmos,
					/obj/item/clothing/suit/space/void/atmos)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "atmospherics voidsuit kit"
	access = access_atmospherics
	group = "Atmospherics"

/datum/supply_packs/voidsuitcrate_minin
	name = "Mining Voidsuit Crate"
	contains = list(/obj/item/clothing/head/helmet/space/void/mining,
					/obj/item/clothing/suit/space/void/mining)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "mining voidsuit kit"
	access = access_mining
	group = "Supply"

//maglocks crates

/datum/supply_packs/maglocks_engineering
	name = "Engineering Magnetic Lock Crate"
	contains = list(/obj/item/device/magnetic_lock/engineering,
					/obj/item/device/magnetic_lock/engineering,
					/obj/item/device/magnetic_lock/engineering)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "engineering magnetic locks"
	access = access_engine_equip
	group = "Engineering"

/datum/supply_packs/maglocks_security
	name = "Security Magnetic Lock Crate"
	contains = list(/obj/item/device/magnetic_lock/security,
					/obj/item/device/magnetic_lock/security,
					/obj/item/device/magnetic_lock/security)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "security magnetic locks"
	access = access_security
	group = "Security"

/datum/supply_packs/randomised/glowsticks
	name = "Glowsticks crate"
	num_contained = 4
	contains = list(/obj/item/device/flashlight/glowstick,
					/obj/item/device/flashlight/glowstick/red,
					/obj/item/device/flashlight/glowstick/blue,
					/obj/item/device/flashlight/glowstick/orange,
					/obj/item/device/flashlight/glowstick/yellow)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "glowsticks crate"
	group = "Operations"

/datum/supply_packs/spessbike
	name = "Space-bike Crate"
	contains = list(/obj/vehicle/bike)
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "Space-bike Crate"
	contraband = 1
	group = "Operations"

/datum/supply_packs/ipc_tag_pack
	name = "IPC/Shell Tag Implanter Crate"
	contains = list(/obj/item/implanter/ipc_tag,
					/obj/item/implanter/ipc_tag,
					/obj/item/implanter/ipc_tag
					)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "IPC/Shell tag implanters"
	group = "Security"

/datum/supply_packs/ame_ctrl
	name = "Antimatter Reactor Control Unit"
	contains = list(
		/obj/machinery/power/am_control_unit
	)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/large
	containername = "antimatter reactor control unit kit"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/ame_section
	name = "Antimatter Reactor Shielding Kit"
	contains = list(
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container,
		/obj/item/device/am_shielding_container
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "antimatter reactor shielding (9x) crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/ame_fuel
	name = "Antimatter Reactor Fuel"
	contains = list(
		/obj/item/am_containment
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/bin
	containername = "antimatter fuel container"
	group = "Engineering"
	access = access_engine

/datum/supply_packs/hoist
	name = "Hoist Crate"
	contains = list(
		/obj/item/hoist_kit,
		/obj/item/hoist_kit,
		/obj/item/hoist_kit
	)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "hoist crate"
	group = "Engineering"
