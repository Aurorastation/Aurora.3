/obj/item/crowbar/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/wrench/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/screwdriver/robotic
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "screwdriver"
	build_from_parts = FALSE

/obj/item/device/multitool/robotic
	icon = 'icons/obj/robot_items.dmi'

/obj/item/wirecutters/robotic
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "wirecutters"
	build_from_parts = FALSE

/obj/item/weldingtool/robotic
	icon = 'icons/obj/robot_items.dmi'
	change_icons = FALSE

/obj/item/soap/drone
	name = "integrated soap"
	desc = "An advanced bar of soap that connects to an internal reservoir of a custodial bot, allowing it to stay wet for longer periods of time."
	capacity = 50

/obj/item/robot_teleporter
	name = "integrated bluespace phase-shift projector"
	desc = "A highly advanced piece of alien technology allowing for short-range teleportation."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "anomaly_core"
	maptext_x = 3
	maptext_y = 2
	///how much power it takes to activate
	var/power_cost = 1000
	///whether the teleporter is on cooldown
	var/ready_to_use = TRUE
	///how long the user has to wait between teleports
	var/recharge_time = 30 SECONDS
	///the time when recharging will be done. used to display the loading bar on examine
	var/when_recharge = 0

/obj/item/robot_teleporter/get_cell()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		return R.get_cell()

/obj/item/robot_teleporter/examine(mob/user, distance)
	. = ..()
	if(!ready_to_use && isrobot(user))
		to_chat(user, SPAN_NOTICE("Charging: [num2loadingbar(world.time / when_recharge)]"))

/obj/item/robot_teleporter/set_initial_maptext()
	held_maptext = SMALL_FONTS(7, "Ready")

/obj/item/robot_teleporter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!ready_to_use)
		to_chat(user, SPAN_WARNING("\The [src] isn't ready to use yet!"))
		return
	var/turf/T = get_turf(target)
	if(!T)
		to_chat(user, SPAN_WARNING("Something has gone terribly wrong while choosing a target, please try again somewhere else!"))
		return
	if(T.density || T.contains_dense_objects())
		to_chat(user, SPAN_WARNING("You cannot teleport to a location with solid objects!"))
		return
	if(isAdminLevel(T.z))
		to_chat(user, SPAN_WARNING("You cannot use the device on this Z-level."))
		return
	var/obj/item/cell/C = get_cell()
	if(!istype(C))
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a power supply!"))
		return
	if(C.charge < 1000)
		to_chat(user, SPAN_WARNING("You have no spare charge in your internal cell to give!"))
		return

	C.use(1000)
	user.visible_message("<b>[user]</b> blinks into nothingness!", SPAN_NOTICE("You jump into the nothing."))
	user.forceMove(T)
	spark(user, 3, GLOB.alldirs)
	user.visible_message("<b>[user]</b> appears out of thin air!", SPAN_NOTICE("You successfully step into your destination."))
	use()

/obj/item/robot_teleporter/use()
	ready_to_use = FALSE
	addtimer(CALLBACK(src, PROC_REF(recharge)), recharge_time)
	check_maptext(SMALL_FONTS(6, "Charge"))
	when_recharge = world.time + recharge_time

/obj/item/robot_teleporter/proc/recharge()
	ready_to_use = TRUE
	check_maptext(SMALL_FONTS(7, "Ready"))
