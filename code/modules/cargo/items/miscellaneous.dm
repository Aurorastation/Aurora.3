/singleton/cargo_item/auto_chisel
	category = "miscellaneous"
	name = "auto-chisel"
	supplier = "nanotrasen"
	description = "With an integrated AI chip and hair-trigger precision, this baby makes sculpting almost automatic!"
	price = 125
	items = list(
		/obj/item/autochisel
	)
	access = 0
	container_type = CARGO_CRATE
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sculptingblock
	category = "miscellaneous"
	name = "sculpting block"
	supplier = "nanotrasen"
	description = "A finely chiselled sculpting block, it is ready to be your canvas."
	price = 750
	items = list(
		/obj/structure/sculpting_block
	)
	access = 0
	container_type = CARGO_BOX
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/spaceac
	category = "miscellaneous"
	name = "space air conditioner"
	supplier = "nanotrasen"
	description = "Made by Space Amish using traditional space techniques, this A/C unit can heat or cool a room to your liking."
	price = 150
	items = list(
		/obj/machinery/space_heater
	)
	access = 0
	container_type = CARGO_BOX
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/camping_set
	category = "miscellaneous"
	name = "camping set"
	supplier = "orion"
	description = "A set of camping supplies for two. For your lovely getaway to paradise. Or hell, whichever is your fancy. Contains a tent, two sleeping bags, two folding chairs and a folding table."
	price = 500
	items = list(
		/obj/item/tent,
		/obj/item/sleeping_bag,
		/obj/item/sleeping_bag,
		/obj/item/material/stool/chair/folding/camping,
		/obj/item/material/stool/chair/folding/camping,
		/obj/item/material/folding_table,
	)
	access = 0
	container_type = CARGO_BOX
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/sleeping_bag
	category = "miscellaneous"
	name = "sleeping bag"
	supplier = "orion"
	description = "A sleeping bag, for sleeping in. Great for a night under the stars."
	price = 12.50
	items = list(
		/obj/item/sleeping_bag,
	)
	access = 0
	container_type = CARGO_CRATE
	groupable = TRUE
	spawn_amount = 1
