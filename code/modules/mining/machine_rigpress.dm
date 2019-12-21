/obj/machinery/mineral/rigpress
	name = "hardsuit module press"
	desc = "This machine converts certain items permanently into hardsuit modules."
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

		if(istype(W, /obj/item/clothing/glasses/material) || istype (W,/obj/item/clothing/glasses/meson))
			outcome_path = /obj/item/rig_module/vision/meson

		if(istype(W, /obj/item/tank/jetpack))
			outcome_path = /obj/item/rig_module/maneuvering_jets

		if(istype(W, /obj/item/mining_scanner))
			outcome_path = /obj/item/rig_module/device/orescanner

		if(istype(W, /obj/item/pickaxe/drill))
			outcome_path = /obj/item/rig_module/device/basicdrill

		if(istype(W, /obj/item/gun/energy/plasmacutter))
			outcome_path = /obj/item/rig_module/mounted/plasmacutter

		if(istype(W, /obj/item/pickaxe/diamond))
			outcome_path = /obj/item/rig_module/device/drill

		if(istype(W, /obj/item/gun/energy/vaurca/thermaldrill))
			outcome_path = /obj/item/rig_module/mounted/thermalldrill

		if(!outcome_path)
			..()
			return

		to_chat(user, "<span class='notice'>You start feeding [W] into \the [src]</span>")
		if(do_after(user,30))
			src.visible_message("<span class='notice'>\The [src] begins to print out a modsuit.</span>")
			pressing = 1
			update_icon()
			use_power(500)
			qdel(W)
			spawn(300)
				ping( "\The [src] pings, \"Module successfuly produced!\"" )

				new outcome_path(src.loc)

				use_power(500)
				pressing = 0
				update_icon()

	else
		..()