/singleton/cargo_item/glasssheets
	category = "engineering"
	name = "glass sheets"
	supplier = "hephaestus"
	description = "50 sheets of glass."
	price = 275
	items = list(
		/obj/item/stack/material/glass/full
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/plasteelsheets
	category = "engineering"
	name = "plasteel sheets"
	supplier = "hephaestus"
	description = "50 sheets of plasteel."
	price = 700
	items = list(
		/obj/item/stack/material/plasteel/full
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/plasticsheets
	category = "engineering"
	name = "plastic sheets"
	supplier = "hephaestus"
	description = "50 sheets of plastic."
	price = 250
	items = list(
		/obj/item/stack/material/plastic/full
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/steelsheets
	category = "engineering"
	name = "steel sheets"
	supplier = "hephaestus"
	description = "50 sheets of steel."
	price = 400
	items = list(
		/obj/item/stack/material/steel/full
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/woodplanks
	category = "engineering"
	name = "wood planks"
	supplier = "hephaestus"
	description = "50 planks of wood."
	price = 350
	items = list(
		/obj/item/stack/material/wood/full
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/phoronsheets
	category = "engineering"
	name = "phoron crystals"
	supplier = "hephaestus"
	description = "A bunch of 50 phoron crystals. Highly valuable."
	price = 2200
	items = list(
		/obj/item/stack/material/phoron/full
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/cardboardsheets
	category = "engineering"
	name = "cardboard sheets"
	supplier = "orion"
	description = "50 sheets of cardboard."
	price = 50
	items = list(
		/obj/item/stack/material/cardboard/full
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/carpet
	category = "engineering"
	name = "carpet (x10)"
	supplier = "hephaestus"
	description = "Ten carpet sheets. It is the same size as a normal floor tile!"
	price = 350
	items = list(
		/obj/item/stack/tile/carpet
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 10

/singleton/cargo_item/antifuelgrenade
	category = "engineering"
	name = "antifuel grenade"
	supplier = "hephaestus"
	description = "This grenade is loaded with a foaming antifuel compound -- the twenty-fifth century standard for eliminating industrial spills."
	price = 250
	items = list(
		/obj/item/grenade/chem_grenade/antifuel
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/brownwebbingvest
	category = "engineering"
	name = "brown webbing vest"
	supplier = "hephaestus"
	description = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	price = 83
	items = list(
		/obj/item/clothing/accessory/storage/brown_vest
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/circuitboard_bubbleshield
	category = "engineering"
	name = "circuit board (bubble shield generator)"
	supplier = "hephaestus"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/shield_gen
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/circuitboard_hullshield
	category = "engineering"
	name = "circuit board (hull shield generator)"
	supplier = "hephaestus"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/shield_gen_ex
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/circuitboard_shieldcapacitor
	category = "engineering"
	name = "circuit board (shield capacitor)"
	supplier = "hephaestus"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/shield_cap
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/circuitboard_solarcontrol
	category = "engineering"
	name = "circuit board (solar control console)"
	supplier = "hephaestus"
	description = "Looks like a circuit. Probably is."
	price = 1500
	items = list(
		/obj/item/circuitboard/solar_control
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/coolanttank
	category = "engineering"
	name = "coolant tank"
	supplier = "hephaestus"
	description = "A tank of industrial coolant."
	price = 45
	items = list(
		/obj/structure/reagent_dispensers/coolanttank
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/disposalpipedispenser
	category = "engineering"
	name = "Disposal Pipe Dispenser"
	supplier = "hephaestus"
	description = "It dispenses bigger pipes for things to travel through. No, the pipes aren't green."
	price = 150
	items = list(
		/obj/machinery/pipedispenser/disposal/orderable
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/toolbox
	category = "engineering"
	name = "mechanical toolbox"
	supplier = "hephaestus"
	description = "Danger. Very robust."
	price = 200
	items = list(
		/obj/item/storage/toolbox/mechanical
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/electricaltoolbox
	category = "engineering"
	name = "electrical toolbox"
	supplier = "hephaestus"
	description = "Danger. Very robust."
	price = 200
	items = list(
		/obj/item/storage/toolbox/electrical
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emergencytoolbox
	category = "engineering"
	name = "emergency toolbox"
	supplier = "hephaestus"
	description = "Danger. Very robust."
	price = 120
	items = list(
		/obj/item/storage/toolbox/emergency
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emaccelerationchamber
	category = "engineering"
	name = "EM Acceleration Chamber"
	supplier = "hephaestus"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/fuel_chamber
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emcontainmentgridcenter
	category = "engineering"
	name = "EM Containment Grid Center"
	supplier = "hephaestus"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/particle_emitter/center
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emcontainmentgridleft
	category = "engineering"
	name = "EM Containment Grid Left"
	supplier = "hephaestus"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/particle_emitter/left
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emcontainmentgridright
	category = "engineering"
	name = "EM Containment Grid Right"
	supplier = "hephaestus"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/particle_emitter/right
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emergencybluespacerelaycircuit
	category = "engineering"
	name = "emergency bluespace relay circuit"
	supplier = "hephaestus"
	description = "Looks like a circuit. Probably is."
	price = 3000
	items = list(
		/obj/item/circuitboard/bluespacerelay
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emitter
	category = "engineering"
	name = "emitter"
	supplier = "hephaestus"
	description = "It is a heavy duty industrial laser."
	price = 1500
	items = list(
		/obj/machinery/power/emitter
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/doorlock_engineering
	category = "engineering"
	name = "engineering magnetic door lock - engineering"
	supplier = "hephaestus"
	description = "A large, ID locked device used for completely locking down airlocks. It is painted with Engineering colors."
	price = 135
	items = list(
		/obj/item/device/magnetic_lock/engineering
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/engineeringvoidsuit
	category = "engineering"
	name = "engineering voidsuit"
	supplier = "hephaestus"
	description = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	price = 1200
	items = list(
		/obj/item/clothing/suit/space/void/engineering
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/engineeringvoidsuithelmet
	category = "engineering"
	name = "engineering voidsuit helmet"
	supplier = "hephaestus"
	description = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	price = 850
	items = list(
		/obj/item/clothing/head/helmet/space/void/engineering
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fieldgenerator
	category = "engineering"
	name = "Field Generator"
	supplier = "hephaestus"
	description = "A large thermal battery that projects a high amount of energy when powered."
	price = 1500
	items = list(
		/obj/machinery/field_generator
	)
	access = ACCESS_ARMORY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fireaxe
	category = "engineering"
	name = "fireaxe"
	supplier = "hephaestus"
	description = "The fire axe is a wooden handled axe with a heavy steel head intended for firefighting use."
	price = 1500
	items = list(
		/obj/item/material/twohanded/fireaxe
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fueltank
	category = "engineering"
	name = "fuel tank"
	supplier = "hephaestus"
	description = "A tank filled with welding fuel."
	price = 45
	items = list(
		/obj/structure/reagent_dispensers/fueltank
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/gasmask
	category = "engineering"
	name = "gas mask"
	supplier = "hephaestus"
	description = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	price = 75
	items = list(
		/obj/item/clothing/mask/gas
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

	spawn_amount = 1

/singleton/cargo_item/hardhat
	category = "engineering"
	name = "hard hat"
	supplier = "hephaestus"
	description = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	price = 35
	items = list(
		/obj/item/clothing/head/hardhat
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hazardvest
	category = "engineering"
	name = "hazard vest"
	supplier = "hephaestus"
	description = "A high-visibility vest used in work zones."
	price = 90
	items = list(
		/obj/item/clothing/suit/storage/hazardvest
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toolbelt
	category = "engineering"
	name = "full toolbelt"
	supplier = "hephaestus"
	description = "A toolbelt, filled with basic mechanics' tools."
	price = 500
	items = list(
		/obj/item/storage/belt/utility/full
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/highcapacitypowercell
	category = "engineering"
	name = "high-capacity power cell"
	supplier = "hephaestus"
	description = "A high-capacity rechargable electrochemical power cell."
	price = 240
	items = list(
		/obj/item/cell/high
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/powercell
	category = "engineering"
	name = "power cell"
	supplier = "hephaestus"
	description = "A rechargable electrochemical power cell."
	price = 90
	items = list(
		/obj/item/cell
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hoistkit
	category = "engineering"
	name = "hoist kit"
	supplier = "hephaestus"
	description = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	price = 225
	items = list(
		/obj/item/hoist_kit
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/inflatablebarrierbox
	category = "engineering"
	name = "inflatable barrier box"
	supplier = "hephaestus"
	description = "Contains inflatable walls and doors."
	price = 360
	items = list(
		/obj/item/storage/bag/inflatable
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/insulatedgloves
	category = "engineering"
	name = "insulated gloves"
	supplier = "hephaestus"
	description = "These gloves will protect the wearer from electric shock."
	price = 450
	items = list(
		/obj/item/clothing/gloves/yellow
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tajaranelectricalgloves
	category = "engineering"
	name = "tajaran electrical gloves"
	supplier = "hephaestus"
	description = "These gloves will protect the wearer from electric shock. Made special for Tajaran use."
	price = 450
	items = list(
		/obj/item/clothing/gloves/yellow/specialt
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/unathielectricalgloves
	category = "engineering"
	name = "unathi electrical gloves"
	supplier = "hephaestus"
	description = "These gloves will protect the wearer from electric shock. Made special for Unathi use."
	price = 450
	items = list(
		/obj/item/clothing/gloves/yellow/specialu
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/packagedantimatterreactorsection
	category = "engineering"
	name = "packaged antimatter reactor section"
	supplier = "eckharts"
	description = "A section of antimatter reactor shielding. Do not eat."
	price = 1000
	items = list(
		/obj/item/device/am_shielding_container
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/debugger
	category = "engineering"
	name = "Debugger"
	supplier = "hephaestus"
	description = "Used to debug electronic equipment."
	price = 50
	items = list(
		/obj/item/device/debugger
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/paintgun
	category = "engineering"
	name = "paint gun"
	supplier = "hephaestus"
	description = "Useful for designating areas and pissing off coworkers."
	price = 135
	items = list(
		/obj/item/device/paint_sprayer
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/particleacceleratorcontrolcomputer
	category = "engineering"
	name = "Particle Accelerator Control Computer"
	supplier = "hephaestus"
	description = "This controls the density of the particles."
	price = 1500
	items = list(
		/obj/machinery/particle_accelerator/control_box
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/particlefocusingemlens
	category = "engineering"
	name = "Particle Focusing EM Lens"
	supplier = "hephaestus"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/power_box
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/portableladder
	category = "engineering"
	name = "portable ladder"
	supplier = "hephaestus"
	description = "A lightweight deployable ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	price = 200
	items = list(
		/obj/item/ladder_mobile
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/radiationhood
	category = "engineering"
	name = "radiation Hood"
	supplier = "hephaestus"
	description = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation."
	price = 375
	items = list(
		/obj/item/clothing/head/radiation
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/radiationsuit
	category = "engineering"
	name = "radiation suit"
	supplier = "hephaestus"
	description = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	price = 675
	items = list(
		/obj/item/clothing/suit/radiation
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/researchshuttleconsoleboard
	category = "engineering"
	name = "research shuttle console board"
	supplier = "hephaestus"
	description = "A replacement board for the research shuttle console, in case the original console is destroyed."
	price = 500
	items = list(
		/obj/item/circuitboard/research_shuttle
	)
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/singularitygenerator
	category = "engineering"
	name = "singularity generator"
	supplier = "hephaestus"
	description = "Used to generate a Singularity. It is not adviced to use this on the asteroid."
	price = 20000
	items = list(
		/obj/machinery/the_singularitygen
	)
	access = ACCESS_HEADS
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/superconductivemagneticcoil
	category = "engineering"
	name = "superconductive magnetic coil"
	supplier = "hephaestus"
	description = "Standard superconductive magnetic coil with average capacity and I/O rating."
	price = 1800
	items = list(
		/obj/item/smes_coil
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/supermattercore
	category = "engineering"
	name = "supermatter crystal"
	supplier = "hephaestus"
	description = "An unstable, radioactive crystal that forms the power source of several experimental ships and stations. Extremely dangerous."
	price = 30000
	items = list(
		/obj/machinery/power/supermatter
	)
	access = ACCESS_CAPTAIN
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/thermoelectricgenerator
	category = "engineering"
	name = "thermoelectric generator kit"
	supplier = "hephaestus"
	description = "A kit that comes with a thermoelectric generator and two circulators that attach to it. For usage in high-power energy generation."
	price = 7500
	items = list(
		/obj/machinery/power/generator,
		/obj/machinery/atmospherics/binary/circulator,
		/obj/machinery/atmospherics/binary/circulator
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/solarpanelassembly
	category = "engineering"
	name = "solar panel assembly"
	supplier = "hephaestus"
	description = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker."
	price = 1020
	items = list(
		/obj/item/solar_assembly
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/trackerelectronics
	category = "engineering"
	name = "tracker electronics"
	supplier = "hephaestus"
	description = "Electronic guidance systems for a solar array."
	price = 225
	items = list(
		/obj/item/tracker_electronics
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/watertank
	category = "engineering"
	name = "watertank"
	supplier = "hephaestus"
	description = "A tank filled with water."
	price = 45
	items = list(
		/obj/structure/reagent_dispensers/watertank
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/weldinghelmet
	category = "engineering"
	name = "welding helmet"
	supplier = "hephaestus"
	description = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	price = 225
	items = list(
		/obj/item/clothing/head/welding
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/antimattercontainmentjar
	category = "engineering"
	name = "antimatter containment jar"
	supplier = "eckharts"
	description = "Holds antimatter. Warranty void if exposed to matter."
	price = 1000
	items = list(
		/obj/item/am_containment
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/antimattercontrolunit
	category = "engineering"
	name = "antimatter control unit"
	supplier = "eckharts"
	description = "The control unit for an antimatter reactor. Probably safe."
	price = 5500
	items = list(
		/obj/machinery/power/am_control_unit
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/alphaparticlegenerationarray
	category = "engineering"
	name = "Alpha Particle Generation Array"
	supplier = "hephaestus"
	description = "Part of a Particle Accelerator."
	price = 3000
	items = list(
		/obj/structure/particle_accelerator/end_cap
	)
	access = ACCESS_CE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
