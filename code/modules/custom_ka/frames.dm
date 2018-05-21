/obj/item/weapon/gun/custom_ka
	name = "kinetic accelerator assembly"
	desc = "A kinetic accelerator assembly."
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	item_state = "kineticgun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = 3
	origin_tech = list(TECH_COMBAT = 1)

	burst = 1
	fire_delay = 6 	//delay after shooting before the gun can be used again
	burst_delay = 2	//delay between shots, if firing in bursts
	move_delay = 1
	fire_sound = 'sound/weapons/Gunshot.ogg'
	fire_sound_text = "gunshot"
	recoil = 0		//screen shake
	silenced = 0
	muzzle_flash = 3
	accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	scoped_accuracy = null
	burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	dispersion = list(0)
	reliability = 100

	pin = /obj/item/device/firing_pin

	sel_mode = 1 //index of the currently selected mode
	firemodes = list()

	//wielding information
	fire_delay_wielded = 0
	recoil_wielded = 0
	accuracy_wielded = 0
	wielded = 0
	needspin = TRUE

	//Custom stuff
	var/obj/item/custom_ka_upgrade/cells/installed_cell
	var/obj/item/custom_ka_upgrade/barrels/installed_barrel
	var/obj/item/custom_ka_upgrade/upgrade_chips/installed_upgrade_chip

/obj/item/weapon/gun/custom_ka/update_icon()
	. = ..()
	cut_overlays()

	if(installed_upgrade_chip)
		add_overlay(installed_upgrade_chip.icon_state)

	if(installed_cell)
		add_overlay(installed_cell.icon_state)

	if(installed_barrel)
		add_overlay(installed_barrel.icon_state)


/obj/item/weapon/gun/custom_ka/attackby(var/obj/item/I as obj, var/mob/user as mob)

	if(istype(I,/obj/item/custom_ka_upgrade/cells))
		if(installed_cell)
			user << "There is already \an [installed_cell] installed."
		else
			var/obj/item/custom_ka_upgrade/cells/tempvar = I
			installed_cell = tempvar
	else if(istype(I,/obj/item/custom_ka_upgrade/barrels))
		if(installed_barrel)
			user << "There is already \an [installed_barrel] installed."
		else
			var/obj/item/custom_ka_upgrade/barrels/tempvar = I
			installed_barrel = tempvar
	else if(istype(I,/obj/item/custom_ka_upgrade/upgrade_chips))
		if(!installed_cell || !installed_barrel)
			user << "A barrel and a cell need to be installed before you install the [I]"
		else if(installed_upgrade_chip)
			user << "There is already \an [installed_upgrade_chip] installed."
		else
			var/obj/item/custom_ka_upgrade/upgrade_chips/tempvar = I
			installed_upgrade_chip = tempvar

	. = ..()

/obj/item/weapon/gun/custom_ka/frame01
	icon_state = "frame01"

/obj/item/weapon/gun/custom_ka/frame02
	icon_state = "frame02"

/obj/item/weapon/gun/custom_ka/frame03
	icon_state = "frame03"

/obj/item/weapon/gun/custom_ka/frame04
	icon_state = "frame04"

/obj/item/weapon/gun/custom_ka/frame05
	icon_state = "frame05"

/obj/item/custom_ka_upgrade
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	var/damage_increase = 0
	var/recoil_increase = 0
	var/cost_increase = 0
	var/cell_increase = 0
	var/capacity_increase = 0
	var/mod_limit_increase = 0
