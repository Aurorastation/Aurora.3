/obj/item/weapon/gun/custom_ka/frame01
	name = "compact kinetic accelerator frame"
	build_name = "compact"
	icon_state = "frame01"
	w_class = 3
	capacity_increase = 3
	mod_limit_increase = 2
	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1)
	slot_flags = SLOT_BELT

/obj/item/weapon/gun/custom_ka/frame02
	name = "light kinetic accelerator frame"
	build_name = "light"
	icon_state = "frame02"
	w_class = 3
	recoil_increase = -1
	capacity_increase = 5
	mod_limit_increase = 3
	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 3)

/obj/item/weapon/gun/custom_ka/frame03
	name = "medium kinetic accelerator frame"
	build_name = "medium"
	icon_state = "frame03"
	w_class = 4
	recoil_increase = -2
	capacity_increase = 7
	mod_limit_increase = 4
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)

/obj/item/weapon/gun/custom_ka/frame04
	name = "heavy kinetic accelerator frame"
	build_name = "heavy"
	icon_state = "frame04"
	w_class = 5
	recoil_increase = -5
	capacity_increase = 9
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 5)

/obj/item/weapon/gun/custom_ka/frame05
	name = "tactical kinetic accelerator frame"
	build_name = "tactical"
	icon_state = "frame05"
	w_class = 5
	recoil_increase = -6
	capacity_increase = 10
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)

/obj/item/weapon/gun/custom_ka/cyborg
	name = "cyborg kinetic accelerator frame"
	build_name = "cyborg compatible"
	icon_state = "frame_cyborg"
	w_class = 5
	recoil_increase = -10 //Cyborgs are STRONG
	capacity_increase = 100
	mod_limit_increase = 100
	origin_tech = list()
	can_disassemble_cell = FALSE

	installed_cell = /obj/item/custom_ka_upgrade/cells/cyborg
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel01

/obj/item/weapon/gun/custom_ka/frame01/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell01
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel01
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/weapon/gun/custom_ka/frame02/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell02
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/firerate

/obj/item/weapon/gun/custom_ka/frame03/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell03
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel03
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/weapon/gun/custom_ka/frame04/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell04
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel04
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/effeciency

/obj/item/weapon/gun/custom_ka/frame04/illegal
	installed_cell = /obj/item/custom_ka_upgrade/cells/illegal
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/illegal

/obj/item/weapon/gun/custom_ka/frame05/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell05
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel05
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/damage

/obj/item/weapon/gun/custom_ka/frame01/illegal
	installed_cell = /obj/item/custom_ka_upgrade/cells/illegal
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/illegal
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/illegal
