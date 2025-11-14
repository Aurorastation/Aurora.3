/singleton/cargo_item/cleanbot
	category = "robotics"
	name = "Cleanbot"
	supplier = "hephaestus"
	description = "A little cleaning robot, consisting of a bucket, a proximity sensor, and a prosthetic arm. It looks excited to clean!"
	price = 175
	items = list(
		/mob/living/bot/cleanbot
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/farmbot
	category = "robotics"
	name = "Farmbot"
	supplier = "hephaestus"
	description = "The botanist's best friend. Various farming equipment seems haphazardly attached to it."
	price = 220
	items = list(
		/mob/living/bot/farmbot
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medibot
	category = "robotics"
	name = "Medibot"
	supplier = "nanotrasen"
	description = "A little medical robot. He looks somewhat underwhelmed."
	price = 400
	items = list(
		/mob/living/bot/medbot
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/positronicbrain
	category = "robotics"
	name = "positronic brain"
	supplier = "hephaestus"
	description = "An IPC-grade inactivated positronic brain fresh off the factory line. These sentient, enigmatic computers are the brains of advanced synthetics across the galaxy."
	price = 8450
	items = list(
		/obj/item/device/mmi/digital/posibrain
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_baseline
	category = "robotics"
	name = "Torso - Baseline"
	supplier = "hephaestus"
	description = "A torso for a baseline frame IPC."
	price = 3200
	items = list(
		/obj/item/robot_parts/chest/ipc
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1


/singleton/cargo_item/torso_bishop
	category = "robotics"
	name = "Torso - Bishop Cybernetics"
	supplier = "bishop"
	description = "A bishop cybernetics torso."
	price = 4000
	items = list(
		/obj/item/robot_parts/chest/bishop
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_g1
	category = "robotics"
	name = "Torso - Hephaestus G1 Industrial Frame"
	supplier = "hephaestus"
	description = "A torso for a Hephaestus G1 Industrial Frame."
	price = 3500
	items = list(
		/obj/item/robot_parts/chest/industrial
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_g2
	category = "robotics"
	name = "Torso - Hephaestus G2 Industrial Frame"
	supplier = "hephaestus"
	description = "A torso for a Hephaestus G2 Industrial Frame."
	price = 5000
	items = list(
		/obj/item/robot_parts/chest/hephaestus
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_heph
	category = "robotics"
	name = "Torso - Hephaestus Integrated"
	supplier = "hephaestus"
	description = "A torso for a Hephaestus Integrated Frame."
	price = 3000
	items = list(
		/obj/item/robot_parts/chest/ipc
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_synthskin
	category = "robotics"
	name = "Torso - Synthskin"
	supplier = "zeng_hu"
	description = "A synthskin torso."
	price = 9000
	items = list(
		/obj/item/robot_parts/chest/synthskin
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_xion
	category = "robotics"
	name = "Torso - Xion Manufacturing"
	supplier = "xion"
	description = "A Xion Manufacturing torso."
	price = 4500
	items = list(
		/obj/item/robot_parts/chest/xion
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/torso_zenghu
	category = "robotics"
	name = "Torso - Zeng - Hu Pharmaceuticals"
	supplier = "zeng_hu"
	description = "A Zeng - Hu Pharmaceuticals torso."
	price = 3000
	items = list(
		/obj/item/robot_parts/chest/zenghu
	)
	access = ACCESS_ROBOTICS
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/nanopaste
	category = "robotics"
	name = "nanopaste"
	supplier = "zeng_hu"
	description = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	price = 750
	items = list(
		/obj/item/stack/nanopaste
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
