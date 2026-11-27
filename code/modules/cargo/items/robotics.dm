/singleton/cargo_item/cleanbot
	category = "robotics"
	name = "Cleanbot"
	supplier = "hephaestus"
	description = "A little cleaning robot, consisting of a bucket, a proximity sensor, and a prosthetic arm. It looks excited to clean!"
	price = 175
	items = list(
		/mob/living/bot/cleanbot
	)
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
		/obj/item/mmi/digital/posibrain
	)
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	access = list(/datum/access/robotics::id)
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
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/robotanalyzer
	category = "robotics"
	name = "cyborg analyzer"
	supplier = "hephaestus"
	description = "A handheld scanner used to diagnose damage to cyborgs and prosthetic limbs."
	price = 150
	items = list(
		/obj/item/robotanalyzer
	)
	access = list(/datum/access/robotics::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/aicard
	category = "robotics"
	name = "intelliCard"
	supplier = "hephaestus"
	description = "A portable storage device used to safely transport an artificial intelligence."
	price = 1000
	items = list(
		/obj/item/aicard
	)
	access = list(/datum/access/robotics::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/autakhlimbs
	category = "robotics"
	name = "autakh limbs"
	supplier = "hephaestus"
	description = "A box with various autakh limbs."
	price = 1000
	items = list(
		/obj/item/organ/external/hand/right/autakh/tool,
		/obj/item/organ/external/hand/right/autakh/tool/mining,
		/obj/item/organ/external/hand/right/autakh/medical
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/pkus_exosuit_parts
	category = "robotics"
	name = "ADEPT P'kus-3 exosuit parts"
	supplier = "zharkov"
	description = "Unprepared P'kus-3 parts discounted through ADEPT, the Hadii Institute's joint exosuit program with the SCC. A machinist must still install the internal components."
	price = 3000
	items = list(
		/obj/item/mech_component/manipulators/pra_egg,
		/obj/item/mech_component/propulsion/pra_egg,
		/obj/item/mech_component/sensors/pra_egg,
		/obj/item/mech_component/chassis/pra_egg
	)
	access = list(/datum/access/robotics::id)
	container_type = "crate"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pkus_exosuit_parts_heavy
	category = "robotics"
	name = "ADEPT armored P'kus-3 exosuit parts"
	supplier = "zharkov"
	description = "Unprepared armored P'kus-3 parts discounted through ADEPT, the Hadii Institute's joint exosuit program with the SCC. A machinist must still install the internal components."
	price = 5000
	items = list(
		/obj/item/mech_component/manipulators/pra_egg/armored,
		/obj/item/mech_component/propulsion/pra_egg,
		/obj/item/mech_component/sensors/pra_egg/armored,
		/obj/item/mech_component/chassis/pra_egg/armored/nuclear
	)
	access = list(/datum/access/robotics::id)
	container_type = "crate"
	groupable = FALSE
	spawn_amount = 1
