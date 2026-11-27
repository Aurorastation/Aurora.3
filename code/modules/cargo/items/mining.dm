/singleton/cargo_item/miningvoidsuit
	category = "mining"
	name = "mining voidsuit"
	supplier = "nanotrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	price = 800
	items = list(
		/obj/item/clothing/suit/space/void/mining
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/miningvoidsuithelmet
	category = "mining"
	name = "mining voidsuit helmet"
	supplier = "nanotrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	price = 500
	items = list(
		/obj/item/clothing/head/helmet/space/void/mining
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classakineticaccelerator
	category = "mining"
	name = "Class A Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a tactical KA frame, an experimental core KA power converter, a recoil reloading KA cell, and an upgrade chip - damage increase."
	price = 3200
	items = list(
		/obj/item/gun/custom_ka/frame05/prebuilt
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classbkineticaccelerator
	category = "mining"
	name = "Class B Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a heavy KA frame, a planet core KA power converter, a uranium recharging KA cell, and an upgrade chip - efficiency increase."
	price = 2850
	items = list(
		/obj/item/gun/custom_ka/frame04/prebuilt
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classckineticaccelerator
	category = "mining"
	name = "Class C Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a medium KA frame, a meteor core KA power converter, a kinetic KA cell, and an upgrade chip - focusing."
	price = 2200
	items = list(
		/obj/item/gun/custom_ka/frame03/prebuilt
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classdkineticaccelerator
	category = "mining"
	name = "Class D Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a light KA frame, a professional core KA power converter, an advanced pump recharging KA cell, and an upgrade chip - firedelay increase."
	price = 1850
	items = list(
		/obj/item/gun/custom_ka/frame02/prebuilt
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/classekineticaccelerator
	category = "mining"
	name = "Class E Kinetic Accelerator"
	supplier = "hephaestus"
	description = "Contains a compact KA frame, a standard core KA power converter, a pump recharging KA cell, and an upgrade chip - focusing."
	price = 1400
	items = list(
		/obj/item/gun/custom_ka/frame01/prebuilt
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/industrialminingdrill
	category = "mining"
	name = "mining drill"
	supplier = "hephaestus"
	description = "A large industrial drill. Its bore does not penetrate deep enough to access the sublevels."
	price = 5000
	items = list(
		/obj/structure/machinery/mining/drill,
		/obj/structure/machinery/mining/brace,
		/obj/structure/machinery/mining/brace
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/orebox
	category = "mining"
	name = "ore box"
	supplier = "hephaestus"
	description = "Contains a box for storing ore."
	price = 150
	items = list(
		/obj/structure/ore_box
	)
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pickaxe
	category = "mining"
	name = "pickaxe"
	supplier = "nanotrasen"
	description = "The most basic of mining implements."
	price = 20
	items = list(
		/obj/item/pickaxe
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/handdrill
	category = "mining"
	name = "mining drill (handheld)"
	supplier = "nanotrasen"
	description = "A handheld drill for piercing through rock walls. Can dig sand as well."
	price = 95
	items = list(
		/obj/item/pickaxe/drill
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/jackhammer
	category = "mining"
	name = "sonic jackhammer"
	supplier = "nanotrasen"
	description = "Cracks rocks with sonic blasts."
	price = 220
	items = list(
		/obj/item/pickaxe/jackhammer
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/miningsledgehammer
	category = "mining"
	name = "sledgehammer"
	supplier = "nanotrasen"
	description = "A mining hammer made of reinforced metal."
	price = 45
	items = list(
		/obj/item/pickaxe/hammer
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/shovel
	category = "mining"
	name = "shovel"
	supplier = "nanotrasen"
	description = "A large tool for digging and moving dirt."
	price = 12
	items = list(
		/obj/item/shovel
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/spade
	category = "mining"
	name = "spade"
	supplier = "nanotrasen"
	description = "A small tool for digging and moving dirt."
	price = 8
	items = list(
		/obj/item/shovel/spade
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/miningsatchel
	category = "mining"
	name = "mining satchel"
	supplier = "nanotrasen"
	description = "A satchel for storing and transporting ore."
	price = 25
	items = list(
		/obj/item/storage/bag/ore
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/resonator
	category = "mining"
	name = "resonator"
	supplier = "nanotrasen"
	description = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. More effective in a vacuum."
	price = 180
	items = list(
		/obj/item/resonator
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/deeporescanner
	category = "mining"
	name = "deep ore scanner"
	supplier = "nanotrasen"
	description = "A handheld device used to locate ore deep underground."
	price = 150
	items = list(
		/obj/item/mining_scanner
	)
	access = list(/datum/access/mining::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mininggps
	category = "mining"
	name = "mining GPS"
	supplier = "nanotrasen"
	description = "A GPS unit tagged for mining teams."
	price = 60
	items = list(
		/obj/item/gps/mining
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
