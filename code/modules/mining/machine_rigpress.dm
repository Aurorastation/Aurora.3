/obj/machinery/mineral/rigpress
	name = "RIG module press"
	desc = "This machine converts certain items permanently into RIG modules."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50
	var/pressing

/obj/machinery/mineral/rigpress/update_icon()
	if(pressing)
		icon_state = "coinpress1"
	else
		icon_state = "coinpress0"

/obj/machinery/mineral/rigpress/attackby(obj/item/W, mob/user)
	if(!pressing)
		var/outcome_path
		var/list/kinetic_mods = list()
		var/kineticaccelerator
		if(istype(W, /obj/item/clothing/glasses/material))
			outcome_path = /obj/item/rig_module/vision/meson

		if(istype(W, /obj/item/weapon/tank/jetpack))
			outcome_path = /obj/item/rig_module/maneuvering_jets

		if(istype(W, /obj/item/weapon/mining_scanner))
			outcome_path = /obj/item/rig_module/device/orescanner

		if(istype(W, /obj/item/weapon/pickaxe/drill))
			outcome_path = /obj/item/rig_module/device/basicdrill

		if(istype(W, /obj/item/weapon/gun/energy/kinetic_accelerator))
			outcome_path = /obj/item/rig_module/mounted/kinetic_accelerator
			var/obj/item/weapon/gun/energy/kinetic_accelerator/KA = W
			kineticaccelerator = 1
			for(var/obj/item/borg/upgrade/modkit/kmod in KA.modkits)
				kinetic_mods += kmod

		if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
			outcome_path = /obj/item/rig_module/mounted/plasmacutter

		if(istype(W, /obj/item/weapon/pickaxe/diamond))
			outcome_path = /obj/item/rig_module/device/drill

		if(istype(W, /obj/item/weapon/gun/energy/vaurca/thermaldrill))
			outcome_path = /obj/item/rig_module/mounted/thermalldrill

		if(!outcome_path)
			return

		user << "<span class='notice'>You start feeding [W] into \the [src]</span>"
		if(do_after(user,30))
			src.visible_message("<span class='notice'>\The [src] begins to print out a modsuit.</span>")
			pressing = 1
			update_icon()
			use_power(500)
			qdel(W)
			spawn(300)
				ping( "\The [src] pings, \"Module successfuly produced!\"" )
				if(kineticaccelerator)
					var/obj/item/rig_module/mounted/kinetic_accelerator/KA = new /obj/item/rig_module/mounted/kinetic_accelerator(src.loc)
					var/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg/KGUN = KA.gun
					for(var/obj/item/borg/upgrade/modkit/kmod in kinetic_mods)
						KGUN.modkits += kmod
				else
					new outcome_path(src.loc)
				use_power(500)
				pressing = 0
				update_icon()
	..()
