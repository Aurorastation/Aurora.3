//Made KAs
/obj/item/gun/custom_ka/frame01
	name = "compact kinetic accelerator frame"
	build_name = "compact"
	icon_state = "frame01"
	item_state = "compact"
	desc = "A very minimal kinetic accelerator frame that holds cheap and inexpensive parts."
	w_class = 3
	capacity_increase = 3
	mod_limit_increase = 2
	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1)

/obj/item/gun/custom_ka/frame02
	name = "light kinetic accelerator frame"
	build_name = "light"
	icon_state = "frame02"
	item_state = "light"
	desc = "A lightweight kinetic accelerator frame that holds standard issue parts."
	w_class = 3
	recoil_increase = -1
	capacity_increase = 5
	mod_limit_increase = 3
	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 3)

/obj/item/gun/custom_ka/frame03
	name = "medium kinetic accelerator frame"
	build_name = "medium"
	icon_state = "frame03"
	item_state = "medium"
	desc = "A more durable and robust kinetic accelerator frame that allows the installation of advanced parts."
	w_class = 4
	recoil_increase = -2
	capacity_increase = 7
	mod_limit_increase = 4
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)

/obj/item/gun/custom_ka/frame04
	name = "heavy kinetic accelerator frame"
	build_name = "heavy"
	icon_state = "frame04"
	item_state = "heavy"
	desc = "A very high-tech kinetic accelerator frame that is compatable with the more experimental kinetic accelerator parts. Requires two hands to fire."
	w_class = 5
	recoil_increase = -5
	capacity_increase = 9
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 5)
	require_wield = TRUE

/obj/item/gun/custom_ka/frame05
	name = "tactical kinetic accelerator frame"
	build_name = "tactical"
	icon_state = "frame05"
	item_state = "tactical"
	desc = "An incredibly robust and experimental kinetic accelerator frame that has has the ability to hold top of the line kinetic accelerator parts and chips. Requires two hands to fire."
	w_class = 5
	recoil_increase = -6
	capacity_increase = 10
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)
	require_wield = TRUE

/obj/item/gun/custom_ka/cyborg
	name = "cyborg kinetic accelerator"
	build_name = "cyborg compatible"
	icon_state = "frame_cyborg"
	desc = "A kinetic accelerator frame meant for cyborgs. Uses a cyborg's internal charge as power."
	w_class = 5
	recoil_increase = -10 //Cyborgs are STRONG
	capacity_increase = 100
	mod_limit_increase = 100
	origin_tech = list()
	can_disassemble_cell = FALSE

	installed_cell = /obj/item/custom_ka_upgrade/cells/cyborg
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel01

/obj/item/gun/custom_ka/frameA
	name = "vented kinetic accelerator frame"
	build_name = "vented"
	icon_state = "frameA"
	item_state = "compact"
	w_class = 3
	desc = "A very specialized kinetic accelerator frame that can hold moderately powerful parts, however it contains special heat sink technology that allows the weapon to fire faster."
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)
	damage_increase = 0
	firedelay_increase = -0.125 SECONDS //How long it takes for the weapon to fire, in deciseconds.
	range_increase = 1
	recoil_increase = -2
	cost_increase = 0
	capacity_increase = 7
	mod_limit_increase = 4
	aoe_increase = 0

/obj/item/gun/custom_ka/frameB
	name = "ultra heavy kinetic accelerator frame"
	build_name = "ultra heavy"
	icon_state = "frameB"
	item_state = "ultra"
	desc = "A massive kinetic accelerator frame intended for unathi miners who don't mind carrying the extra weight. It's size and built in power core allows for a significant power and range increase. Requires two hands to fire."
	w_class = 5
	damage_increase = 10
	range_increase = 3
	recoil_increase = -5
	capacity_increase = 100 //Fit anything
	mod_limit_increase = 100 //Fit anything
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)
	require_wield = TRUE
	slot_flags = 0

/obj/item/gun/custom_ka/frameC
	name = "vaurca kinetic accelerator frame"
	build_name = "vaurca"
	icon_state = "frameC"
	item_state = "heavy"
	desc = "An advanced kinetic accelerator frame designed for vaurca graspers. Boasts increased recoil reduction and a lightweight alloy."
	w_class = 4
	recoil_increase = -10
	capacity_increase = 9
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 5)

/obj/item/gun/custom_ka/frameD
	name = "burst fire kinetic accelerator frame"
	build_name = "burst-fire"
	icon_state = "frameD"
	item_state = "heavy"
	desc = "A disgustingly bulky kinetic accelerator frame that supports a 3 round burstfire. You just can't seem to hold it right. Requires two hands to fire and pump."
	firedelay_increase = (2*3)
	w_class = 5
	recoil_increase = -3
	capacity_increase = 10
	mod_limit_increase = 5
	burst = 3
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)
	require_wield = TRUE

/obj/item/gun/custom_ka/frameE
	name = "large kinetic accelerator frame"
	build_name = "large"
	icon_state = "frameE"
	item_state = "tactical"
	desc = "An incredibly large kinetic accelerator frame that's meant to absorb a ton of recoil per shot while carrying large additions. Requires two hands to fire."
	w_class = 5
	recoil_increase = -20
	capacity_increase = 100 //Fit anything
	mod_limit_increase = 100 //Fit anything
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)
	require_wield = TRUE

/obj/item/gun/custom_ka/frameF
	name = "long kinetic accelerator frame"
	build_name = "long"
	icon_state = "frameF"
	item_state = "tactical"
	desc = "A lightweight long kinetic accelerator frame with increase stability and range support, at the cost of reduced firerate. Requires two hands to fire."
	w_class = 5
	recoil_increase = -8
	range_increase = 5
	capacity_increase = 7
	mod_limit_increase = 4
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)
	require_wield = TRUE

//Built KAs

/obj/item/gun/custom_ka/frame01/prebuilt
	name = "class E kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell01
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel01
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/gun/custom_ka/frame02/prebuilt
	name = "class D kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell02
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/firerate

/obj/item/gun/custom_ka/frame03/prebuilt
	name = "class C kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell03
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel03
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/gun/custom_ka/frame04/prebuilt
	name = "class B kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell04
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel04
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/effeciency

/obj/item/gun/custom_ka/frame04/illegal
	name = "illegal kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/illegal
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/illegal

/obj/item/gun/custom_ka/frame05/prebuilt
	name = "class A kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell05
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel05
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/damage

/obj/item/gun/custom_ka/frame01/illegal
	name = "illegal kinetic accelerator"
	installed_cell = /obj/item/custom_ka_upgrade/cells/illegal
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/illegal
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/illegal

/obj/item/gun/custom_ka/frameA/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/kinetic_charging
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02_alt

/obj/item/gun/custom_ka/frameB/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/loader
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/phoron

/obj/item/gun/custom_ka/frameC/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell03
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel03

/obj/item/gun/custom_ka/frameD/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell03
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel04

/obj/item/gun/custom_ka/frameE/prebuilt //ADMIN SPAWN ONLY
	installed_cell = /obj/item/custom_ka_upgrade/cells/loader/uranium
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/supermatter

/obj/item/gun/custom_ka/frameF/prebuilt01
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell04
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/damage

/obj/item/gun/custom_ka/frameF/prebuilt02
	installed_cell = /obj/item/custom_ka_upgrade/cells/loader/hydrogen
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel04
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/capacity