/singleton/cargo_item/miningvoidsuit
	category = "mining"
	name = "mining voidsuit"
	supplier = "nanotrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	price = 1200
	items = list(
		/obj/item/clothing/suit/space/void/mining
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/miningvoidsuithelmet
	category = "mining"
	name = "mining voidsuit helmet"
	supplier = "nanotrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	price = 850
	items = list(
		/obj/item/clothing/head/helmet/space/void/mining
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classakineticaccelerator
	category = "mining"
	name = "Class A Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a tactical KA frame, an experimental core KA power converter, a recoil reloading KA cell, and a upgrade chip - damage increase."
	price = 7999
	items = list(
		/obj/item/gun/custom_ka/frame05/prebuilt
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classbkineticaccelerator
	category = "mining"
	name = "Class B Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a heavy KA frame, a planet core KA power converter, a uranium recharging KA cell, and a upgrade chip - efficiency increase."
	price = 5599
	items = list(
		/obj/item/gun/custom_ka/frame04/prebuilt
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classckineticaccelerator
	category = "mining"
	name = "Class C Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a medium KA frame, a meteor core KA power converter, a kinetic KA cell, and a upgrade chip - focusing."
	price = 3299
	items = list(
		/obj/item/gun/custom_ka/frame03/prebuilt
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classdkineticaccelerator
	category = "mining"
	name = "Class D Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a light KA frame, a professional core KA power converter, an advanced pump recharging KA cell, and a upgrade chip - firedelay increase."
	price = 2299
	items = list(
		/obj/item/gun/custom_ka/frame02/prebuilt
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classekineticaccelerator
	category = "mining"
	name = "Class E Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a compact KA frame, a standard core KA power converter, a pump recharging KA cell, and a upgrade chip - focusing."
	price = 1499
	items = list(
		/obj/item/gun/custom_ka/frame01/prebuilt
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/industrialminingdrill
	category = "mining"
	name = "mining drill"
	supplier = "hephaestus"
	description = "A large industrial drill. Its bore does not penetrate deep enough to access the sublevels."
	price = 4000
	items = list(
		/obj/machinery/mining/drill,
		/obj/machinery/mining/brace,
		/obj/machinery/mining/brace
	)
	access = ACCESS_MINING
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/orebox
	category = "mining"
	name = "ore box"
	supplier = "hephaestus"
	description = "Contains a box for storing ore."
	price = 250
	items = list(
		/obj/structure/ore_box
	)
	access = 0
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1
