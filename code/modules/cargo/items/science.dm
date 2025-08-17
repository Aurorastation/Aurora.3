/singleton/cargo_item/stokcubebox
	category = "science"
	name = "stok cube box"
	supplier = "nanotrasen"
	description = "Drymate brand stok cubes, shipped from Moghes. Just add water!"
	price = 250
	items = list(
		/obj/item/storage/box/monkeycubes/stokcubes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/vkrexicubebox
	category = "science"
	name = "vkrexi cube box"
	supplier = "nanotrasen"
	description = "Drymate brand vkrexi cubes. Just add water!"
	price = 250
	items = list(
		/obj/item/storage/box/monkeycubes/vkrexicubes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/farwacubebox
	category = "science"
	name = "farwa cube box"
	supplier = "nanotrasen"
	description = "Drymate brand farwa cubes, shipped from Adhomai. Just add water!"
	price = 250
	items = list(
		/obj/item/storage/box/monkeycubes/farwacubes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/monkeycubebox
	category = "science"
	name = "monkey cube box"
	supplier = "nanotrasen"
	description = "Drymate brand monkey cubes. Just add water!"
	price = 250
	items = list(
		/obj/item/storage/box/monkeycubes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/neaeracubebox
	category = "science"
	name = "neaera cube box"
	supplier = "nanotrasen"
	description = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	price = 250
	items = list(
		/obj/item/storage/box/monkeycubes/neaeracubes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
/singleton/cargo_item/hazmathood
	category = "science"
	name = "hazmat hood"
	supplier = "nanotrasen"
	description = "This hood protects against biological hazards."
	price = 165
	items = list(
		/obj/item/clothing/head/hazmat/general
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hazmatsuit
	category = "science"
	name = "hazmat suit"
	supplier = "nanotrasen"
	description = "This suit protects against biological hazards."
	price = 200
	items = list(
		/obj/item/clothing/suit/hazmat/general
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mindshieldfiringpin
	category = "science"
	name = "mindshield firing pin"
	supplier = "nanotrasen"
	description = "This implant - locked firing pin authorizes the weapon for only mindshield-implanted users."
	price = 800
	items = list(
		/obj/item/device/firing_pin/implant/loyalty
	)
	access = ACCESS_HEADS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/protohuman
	category = "science"
	name = "Proto-Human"
	supplier = "zeng_hu"
	description = "A human body, vat-grown and artificially raised without a functional brain. The everyman's relatively-ethical solution to organ harvesting."
	price = 7200
	items = list(
		/mob/living/carbon/human
	)
	access = ACCESS_RESEARCH
	container_type = "bodybag"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/proto_skrell
	category = "science"
	name = "Proto-Skrell"
	supplier = "zeng_hu"
	description = "A Skrell body, vat-grown and artificially raised without a functional brain. The everyman's relatively-ethical solution to organ harvesting."
	price = 9100
	items = list(
		/mob/living/carbon/human/skrell
	)
	access = ACCESS_RESEARCH
	container_type = "bodybag"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/proto_tajara
	category = "science"
	name = "Proto-Tajara"
	supplier = "zeng_hu"
	description = "A Tajara body, vat-grown and artificially raised without a functional brain. The everyman's relatively-ethical solution to organ harvesting."
	price = 7450
	items = list(
		/mob/living/carbon/human/tajaran
	)
	access = ACCESS_RESEARCH
	container_type = "bodybag"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/proto_unathi
	category = "science"
	name = "Proto-Unathi"
	supplier = "zeng_hu"
	description = "An Unathi body, vat-grown and artificially raised without a functional brain. The everyman's relatively-ethical solution to organ harvesting."
	price = 7800
	items = list(
		/mob/living/carbon/human/unathi
	)
	access = ACCESS_RESEARCH
	container_type = "bodybag"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/blankvaurcadrone
	category = "science"
	name = "Surplus Vaurca Drone"
	supplier = "zora"
	description = "A surplus Vaurca drone body with functioning organs but a defective brain. Thousands of these are thrown at the wayside every day. The everyman's relatively-ethical solution to organ harvesting."
	price = 500
	items = list(
		/mob/living/carbon/human/type_a/cargo
	)
	access = ACCESS_RESEARCH
	container_type = "bodybag"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/proximitysensor
	category = "science"
	name = "proximity sensor"
	supplier = "nanotrasen"
	description = "Used for scanning and alerting when someone enters a certain proximity."
	price = 35
	items = list(
		/obj/item/device/assembly/prox_sensor
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/testrange_firingpin
	category = "science"
	name = "test - range firing pin"
	supplier = "nanotrasen"
	description = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	price = 200
	items = list(
		/obj/item/device/firing_pin/test_range
	)
	access = ACCESS_RESEARCH
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/timer
	category = "science"
	name = "timer"
	supplier = "nanotrasen"
	description = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	price = 22
	items = list(
		/obj/item/device/assembly/timer
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/igniter
	category = "science"
	name = "igniter"
	supplier = "nanotrasen"
	description = "A small electronic device able to ignite combustable substances."
	price = 23
	items = list(
		/obj/item/device/assembly/igniter
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
