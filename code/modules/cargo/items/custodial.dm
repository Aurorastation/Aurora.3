/singleton/cargo_item/spacecleaner
	category = "custodial"
	name = "space cleaner"
	supplier = "blam"
	description = "BLAM!-brand non-foaming space cleaner! Perfect for those pesky stains."
	price = 12
	items = list(
		/obj/item/reagent_containers/spray/cleaner
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/basic_soap
	category = "custodial"
	name = "basic soap"
	supplier = "blam"
	description = "A basic bar of soap. It cleans, and does absolutely nothing else."
	price = 2
	items = list(
		/obj/item/soap
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/premium_soap
	category = "custodial"
	name = "random premium soaps (x3)"
	supplier = "blam"
	description = "A selection of premium random soaps, as part of a variety pack."
	price = 18
	items = list(
		/obj/random/soap
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 3

/singleton/cargo_item/trashbag
	category = "custodial"
	name = "trash bag (x3)"
	supplier = "blam"
	description = "Heavy duty polymer trash bags."
	price = 5
	items = list(
		/obj/item/storage/bag/trash
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 3

/singleton/cargo_item/lightreplacer
	category = "custodial"
	name = "light replacer"
	supplier = "blam"
	description = "A device to automatically replace lights. Refill with working lightbulbs or sheets of glass."
	price = 30
	items = list(
		/obj/item/device/lightreplacer
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/replacementlights_box
	category = "custodial"
	name = "box of replacement lights"
	supplier = "blam"
	description = "This box is shaped on the inside so that only light tubes and bulbs fit."
	price = 22
	items = list(
		/obj/item/storage/box/lights/mixed
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/wetfloorsign
	category = "custodial"
	name = "wet floor sign (x5)"
	supplier = "blam"
	description = "A resupply pack of wet floor signs."
	price = 6
	items = list(
		/obj/item/clothing/suit/caution
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/mop
	category = "custodial"
	name = "mop"
	supplier = "blam"
	description = "A cleaning utensil consisting of a fabric head attached to a stick."
	price = 12
	items = list(
		/obj/item/mop
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mopbucket
	category = "custodial"
	name = "mop bucket"
	supplier = "blam"
	description = "Fits onto a standard janitorial cart. Fill it with water, but don't forget a mop!"
	price = 8
	items = list(
		/obj/structure/mopbucket
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cleanergrenade
	category = "custodial"
	name = "cleaner grenade"
	supplier = "blam"
	description = "Space cleaner packaged into a wide area dispersal system for rapid and efficient cleaning of surfaces. Slippery."
	price = 50
	items = list(
		/obj/item/grenade/chem_grenade/cleaner
	)
	access = ACCESS_JANITOR
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/janitorial_cart
	category = "custodial"
	name = "custodial cart"
	supplier = "blam"
	description = "The ultimate in custodial carts. Has space for water, mops, signs, trash bags, and more."
	price = 190
	items = list(
		/obj/structure/cart/storage/janitorialcart
	)
	access = ACCESS_JANITOR
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
