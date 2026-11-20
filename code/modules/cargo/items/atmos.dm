/singleton/cargo_item/oxygentank
	category = "atmos"
	name = "oxygen tank"
	supplier = "hephaestus"
	description = "A man-portable tank containing oxygen, the precious gas of life. Unless you're Vaurca, in which case it's pure poison."
	price = 80
	items = list(
		/obj/item/tank/oxygen
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emergencyoxygentank
	category = "atmos"
	name = "emergency oxygen tank"
	supplier = "hephaestus"
	description = "A compact oxygen tank intended for short-term emergency use."
	price = 20
	items = list(
		/obj/item/tank/emergency_oxygen
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/phorontank
	category = "atmos"
	name = "phoron tank"
	supplier = "nanotrasen"
	description = "A man-portable tank containing phoron, pure poison. Unless you're Vaurca, in which case it's the precious gas of life."
	price = 1200
	items = list(
		/obj/item/tank/phoron
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hydrogentank
	category = "atmos"
	name = "hydrogen tank"
	supplier = "hephaestus"
	description = "A man-portable tank containing hydrogen. Do not inhale. Warning: extremely flammable."
	price = 45
	items = list(
		/obj/item/tank/hydrogen
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/portable_air_pump
	category = "atmos"
	name = "portable air pump"
	supplier = "hephaestus"
	description = "Used to fill or drain rooms without differentiating between gasses. NOTE: Does not come pre-filled. Air sold separately."
	price = 130
	items = list(
		/obj/structure/machinery/portable_atmospherics/powered/pump
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/portable_air_scrubber
	category = "atmos"
	name = "portable air scrubber"
	supplier = "hephaestus"
	description = "Scrubs contaminants from the local atmosphere or the connected portable tank."
	price = 150
	items = list(
		/obj/structure/machinery/portable_atmospherics/powered/scrubber
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/canister_air
	category = "atmos"
	name = "Canister (Air)"
	supplier = "hephaestus"
	description = "Holds a nitrogen-oxygen mixture of breathable air. Has a built-in valve to allow for filling portable tanks."
	price = 180
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/air
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_3he
	category = "atmos"
	name = "Canister (Helium-3)"
	supplier = "hephaestus"
	description = "Holds Helium-3 gas, a valuable fusion fuel. Has a built-in valve to allow for filling portable tanks."
	price = 3800
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/heliumfuel
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_co2
	category = "atmos"
	name = "Canister (CO2)"
	supplier = "hephaestus"
	description = "Holds heavy CO2 gas, whatever that is. Has a built-in valve to allow for filling portable tanks."
	price = 300
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/carbon_dioxide
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_h2
	category = "atmos"
	name = "Canister (Hydrogen)"
	supplier = "hephaestus"
	description = "Holds flammable hydrogen. Has a built-in valve to allow for filling portable tanks."
	price = 350
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/hydrogen
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_he
	category = "atmos"
	name = "Canister (Helium)"
	supplier = "hephaestus"
	description = "Holds voice-changing helium. Has a built-in valve to allow for filling portable tanks."
	price = 320
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/helium
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_n2
	category = "atmos"
	name = "Canister (Nitrogen)"
	supplier = "hephaestus"
	description = "Holds inert nitrogen. Has a built-in valve to allow for filling portable tanks."
	price = 320
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/nitrogen
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_n2o
	category = "atmos"
	name = "Canister (Nitrous Oxide)"
	supplier = "hephaestus"
	description = "Holds sleepy nitrous oxide. Has a built-in valve to allow for filling portable tanks."
	price = 650
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/sleeping_agent
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_o2
	category = "atmos"
	name = "Canister (Oxygen)"
	supplier = "hephaestus"
	description = "Holds precious oxygen. Has a built-in valve to allow for filling portable tanks."
	price = 450
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/oxygen
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_phoron
	category = "atmos"
	name = "Canister (Phoron)"
	supplier = "nanotrasen"
	description = "Holds valuable phoron gas. Has a built-in valve to allow for filling portable tanks."
	price = 5500
	items = list(
		/obj/structure/machinery/portable_atmospherics/canister/phoron
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pipedispenser
	category = "atmos"
	name = "pipe dispenser"
	supplier = "hephaestus"
	description = "It dispenses pipes, no idea how though."
	price = 90
	items = list(
		/obj/structure/machinery/pipedispenser/orderable
	)
	access = list(/datum/access/engine::id)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/rpd
	category = "atmos"
	name = "Rapid Fabrication Device P-Class"
	supplier = "hephaestus"
	description = "A heavily modified RFD, modified to construct pipes and piping accessories."
	price = 45
	items = list(
		/obj/item/rfd/piping
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmosvoidsuit
	category = "atmos"
	name = "atmospherics voidsuit"
	supplier = "hephaestus"
	description = "A special suit that protects against hazardous, low pressure environments. Has unmatched thermal protection and minor radiation protection."
	price = 800
	items = list(
		/obj/item/clothing/suit/space/void/atmos
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmosphericsvoidsuithelmet
	category = "atmos"
	name = "atmospherics voidsuit helmet"
	supplier = "hephaestus"
	description = "A special helmet designed for work in a hazardous, low pressure environments. Has unmatched thermal and minor radiation protection."
	price = 500
	items = list(
		/obj/item/clothing/head/helmet/space/void/atmos
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/firesuit
	category = "atmos"
	name = "firesuit"
	supplier = "hephaestus"
	description = "A suit that protects against fire and heat."
	price = 45
	items = list(
		/obj/item/clothing/suit/fire
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmosfiresuit
	category = "atmos"
	name = "atmospheric technician firesuit"
	supplier = "hephaestus"
	description = "A suit that protects against fire and heat, designed for atmospheric technicians."
	price = 70
	items = list(
		/obj/item/clothing/suit/fire/atmos
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmosfirehelmet
	category = "atmos"
	name = "atmospheric firefighter helmet"
	supplier = "hephaestus"
	description = "A firefighter's helmet that keeps the wearer protected from heat and fire."
	price = 30
	items = list(
		/obj/item/clothing/head/hardhat/atmos
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/gasanalyzer
	category = "atmos"
	name = "gas analyzer"
	supplier = "hephaestus"
	description = "A handheld environmental scanner that reports current gas levels."
	price = 25
	items = list(
		/obj/item/analyzer
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pipepainter
	category = "atmos"
	name = "pipe painter"
	supplier = "hephaestus"
	description = "A tool for changing the color of pipes."
	price = 30
	items = list(
		/obj/item/pipe_painter
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmostechbelt
	category = "atmos"
	name = "atmospherics utility belt"
	supplier = "hephaestus"
	description = "A utility belt stocked with the tools an atmospheric technician needs."
	price = 75
	items = list(
		/obj/item/storage/belt/utility/atmostech
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/magboots
	category = "atmos"
	name = "magboots"
	supplier = "hephaestus"
	description = "Magnetic boots that keep the wearer attached to a surface during extravehicular activity. They fit over other footwear."
	price = 300
	items = list(
		/obj/item/clothing/shoes/magboots
	)
	access = list(/datum/access/engine::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/breathmask
	category = "atmos"
	name = "breath mask"
	supplier = "hephaestus"
	description = "A close-fitting mask that can be connected to an air supply."
	price = 8
	items = list(
		/obj/item/clothing/mask/breath
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/gasmask
	category = "atmos"
	name = "gas mask"
	supplier = "hephaestus"
	description = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	price = 15
	items = list(
		/obj/item/clothing/mask/gas
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/spaceac
	category = "atmos"
	name = "space air conditioner"
	supplier = "nanotrasen"
	description = "Made by Space Amish using traditional space techniques, this A/C unit can heat or cool a room to your liking."
	price = 150
	items = list(
		/obj/structure/machinery/space_heater
	)
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1
