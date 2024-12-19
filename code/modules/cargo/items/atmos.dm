/singleton/cargo_item/oxygentank
	category = "atmos"
	name = "oxygen tank"
	supplier = "hephaestus"
	description = "A man-portable tank containing oxygen, the precious gas of life. Unless you're Vaurca, in which case it's pure poison."
	price = 85
	items = list(
		/obj/item/tank/oxygen
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/phorontank
	category = "atmos"
	name = "phoron tank"
	supplier = "nanotrasen"
	description = "A man-portable tank containing phoron, pure poison. Unless you're Vaurca, in which case it's the precious gas of life."
	price = 750
	items = list(
		/obj/item/tank/phoron
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hydrogentank
	category = "atmos"
	name = "hydrogen tank"
	supplier = "hephaestus"
	description = "A man-portable tank containing hydrogen. Do not inhale. Warning: extremely flammable."
	price = 150
	items = list(
		/obj/item/tank/hydrogen
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/portable_air_pump
	category = "atmos"
	name = "portable air pump"
	supplier = "hephaestus"
	description = "Used to fill or drain rooms without differentiating between gasses. NOTE: Does not come pre-filled. Air sold separately."
	price = 750
	items = list(
		/obj/machinery/portable_atmospherics/powered/pump
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/portable_air_scrubber
	category = "atmos"
	name = "portable air scrubber"
	supplier = "hephaestus"
	description = "Scrubs contaminants from the local atmosphere or the connected portable tank."
	price = 850
	items = list(
		/obj/machinery/portable_atmospherics/powered/scrubber
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/canister_air
	category = "atmos"
	name = "Canister (Air)"
	supplier = "hephaestus"
	description = "Holds nitrogen-oxygen breatheable air. Has a built-in valve to allow for filling portable tanks."
	price = 1100
	items = list(
		/obj/machinery/portable_atmospherics/canister/air
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_bo
	category = "atmos"
	name = "Canister (Boron)"
	supplier = "hephaestus"
	description = "Holds boron gas. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/boron
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_co2
	category = "atmos"
	name = "Canister (CO2)"
	supplier = "hephaestus"
	description = "Holds heavy CO2 gas. Has a built-in valve to allow for filling portable tanks."
	price = 800
	items = list(
		/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_h2
	category = "atmos"
	name = "Canister (Hydrogen)"
	supplier = "hephaestus"
	description = "Holds flammable hydrogen. Has a built-in valve to allow for filling portable tanks."
	price = 800
	items = list(
		/obj/machinery/portable_atmospherics/canister/hydrogen
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_he
	category = "atmos"
	name = "Canister (Helium)"
	supplier = "hephaestus"
	description = "Holds voice-changing helium. Has a built-in valve to allow for filling portable tanks."
	price = 800
	items = list(
		/obj/machinery/portable_atmospherics/canister/helium
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_n2
	category = "atmos"
	name = "Canister (Nitrogen)"
	supplier = "hephaestus"
	description = "Holds inert nitrogen. Has a built-in valve to allow for filling portable tanks."
	price = 1000
	items = list(
		/obj/machinery/portable_atmospherics/canister/nitrogen
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_n2o
	category = "atmos"
	name = "Canister (Nitrous Oxide)"
	supplier = "hephaestus"
	description = "Holds sleepy nitrous oxide. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/sleeping_agent
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_o2
	category = "atmos"
	name = "Canister (Oxygen)"
	supplier = "hephaestus"
	description = "Holds precious oxygen. Has a built-in valve to allow for filling portable tanks."
	price = 1500
	items = list(
		/obj/machinery/portable_atmospherics/canister/oxygen
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/canister_phoron
	category = "atmos"
	name = "Canister (Phoron)"
	supplier = "nanotrasen"
	description = "Holds valuable phoron gas. Has a built-in valve to allow for filling portable tanks."
	price = 5000
	items = list(
		/obj/machinery/portable_atmospherics/canister/phoron
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pipedispenser
	category = "atmos"
	name = "pipe dispenser"
	supplier = "hephaestus"
	description = "It dispenses pipes, no idea how though."
	price = 500
	items = list(
		/obj/machinery/pipedispenser/orderable
	)
	access = ACCESS_ENGINE
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pipepainter
	category = "atmos"
	name = "pipe painter"
	supplier = "hephaestus"
	description = "Its said that green pipes are safe to travel through."
	price = 135
	items = list(
		/obj/item/device/pipe_painter
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/rpd
	category = "atmos"
	name = "Rapid Fabrication Device P-Class"
	supplier = "hephaestus"
	description = "A heavily modified RFD, modified to construct pipes and piping accessories."
	price = 255
	items = list(
		/obj/item/rfd/piping
	)
	access = ACCESS_ENGINE
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmosvoidsuit
	category = "atmos"
	name = "atmospherics voidsuit"
	supplier = "hephaestus"
	description = "A special suit that protects against hazardous, low pressure environments. Has unmatched thermal protection and minor radiation."
	price = 1200
	items = list(
		/obj/item/clothing/suit/space/void/atmos
	)
	access = ACCESS_ATMOSPHERICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/atmosphericsvoidsuithelmet
	category = "atmos"
	name = "atmospherics voidsuit helmet"
	supplier = "hephaestus"
	description = "A special helmet designed for work in a hazardous, low pressure environments. Has unmatched thermal and minor radiation protect."
	price = 850
	items = list(
		/obj/item/clothing/head/helmet/space/void/atmos
	)
	access = ACCESS_ATMOSPHERICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
