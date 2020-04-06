//Simple borg hand.
//Limited use.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"

	flags = NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/cell,
		/obj/item/firealarm_electronics,
		/obj/item/airalarm_electronics,
		/obj/item/airlock_electronics,
		/obj/item/tracker_electronics,
		/obj/item/module/power_control,
		/obj/item/stock_parts,
		/obj/item/frame,
		/obj/item/camera_assembly,
		/obj/item/tank,
		/obj/item/circuitboard,
		/obj/item/smes_coil,
		/obj/item/device/assembly,//Primarily for making improved cameras, but opens many possibilities
		/obj/item/computer_hardware,
		/obj/item/pipe
		)

	var/obj/item/wrapped

	var/force_holder
	var/just_dropped = FALSE //When set to 1, the gripper has just dropped its item, and should not attempt to trigger anything

/obj/item/gripper/examine(var/mob/user)
	..()
	if(wrapped)
		to_chat(user, span("notice", "It is holding \the [wrapped]"))

/proc/grippersafety(var/obj/item/gripper/G)
	if(!G || !G.wrapped)//The object must have been lost
		return FALSE
	//The object left the gripper but it still exists. Maybe placed on a table
	if(G.wrapped.loc != G)
		//Reset the force and then remove our reference to it
		G.wrapped.force = G.force_holder
		G.wrapped = null
		G.force_holder = null
		G.update_icon()
		return FALSE
	return TRUE

/obj/item/gripper/proc/grip_item(var/obj/item/I, var/mob/user, var/feedback = 1)
	//This function returns 1 if we successfully took the item, or 0 if it was invalid. This information is useful to the caller
	if(!wrapped)
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				if(feedback)
					to_chat(user, SPAN_NOTICE("You collect \the [I]."))
				I.forceMove(src)
				wrapped = I
				update_icon()
				return TRUE
		if(feedback)
			to_chat(user, SPAN_WARNING("Your gripper cannot hold \the [I]."))
		return FALSE
	if(feedback)
		to_chat(user, SPAN_WARNING("Your gripper is already holding \the [wrapped]."))
	return FALSE

/obj/item/gripper/update_icon()
	underlays.Cut()
	if(wrapped && wrapped.icon)
		var/mutable_appearance/MA = new(wrapped)
		MA.layer = FLOAT_LAYER
		MA.pixel_y = -8

		underlays += MA

/obj/item/gripper/attack_self(mob/user)
	if(wrapped)
		. = wrapped.attack_self(user)
		update_icon()
		return
	return ..()

/obj/item/gripper/AltClick(mob/user)
	if(wrapped)
		. = wrapped.AltClick(user)
		update_icon()
	return ..()

/obj/item/gripper/verb/drop_item()
	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Robot Commands"

	drop(get_turf(src))

/obj/item/gripper/proc/drop(var/atom/target)
	if(wrapped?.loc == src)
		wrapped.forceMove(target)
	wrapped = null
	update_icon()
	return TRUE

/obj/item/gripper/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(wrapped) //The force of the wrapped obj gets set to zero during the attack() and afterattack().
		force_holder = wrapped.force
		wrapped.force = 0.0
		wrapped.attack(M,user)
		if(QDELETED(wrapped))
			wrapped = null
		return TRUE
	else // mob interactions
		switch(user.a_intent)
			if("help")
				user.visible_message("\The [user] [pick("boops", "squeezes", "pokes", "prods", "strokes", "bonks")] \the [M] with \the [src]")
			if("harm")
				M.attack_generic(user, user.mob_size, "crushed")//about 16 dmg for a cyborg
				//Attack generic does a visible message so we dont need one here
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 3)
				playsound(user, 'sound/effects/attackblob.ogg', 60, 1)
				//Slow,powerful attack for borgs. No spamclicking
	return FALSE

/obj/item/gripper/attackby(obj/item/O, mob/user)
	if(wrapped)
		var/resolved = wrapped.attackby(O,user)
		if(!resolved && wrapped && O)
			O.afterattack(wrapped, user ,1)//We pass along things targeting the gripper, to objects inside the gripper. So that we can draw chemicals from held beakers for instance
	return

/obj/item/gripper/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.
	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break
	if(wrapped) //Already have an item.
		return //This is handled in /mob/living/silicon/robot/GripperClickOn
	else if(istype(target, /obj/item/storage) && !istype(target, /obj/item/storage/pill_bottle) && !istype(target, /obj/item/storage/secure))
		for(var/obj/item/C in target.contents)
			if(grip_item(C, user, 0))
				to_chat(user, SPAN_NOTICE("You grab \the [C] from inside \the [target.name]."))
				return
		to_chat(user, SPAN_NOTICE("There is nothing inside the box that your gripper can collect."))
		return
	else if(istype(target, /obj/item)) //Check that we're not pocketing a mob.
		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return
		grip_item(target, user)
	else if (!just_dropped)
		target.attack_ai(user)
	just_dropped = FALSE

/*
	//Definitions of gripper subtypes
*/

// VEEEEERY limited version for mining borgs. Basically only for swapping cells, upgrading the drills, and upgrading custom KAs.
/obj/item/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(
		/obj/item/cell,
		/obj/item/stock_parts,
		/obj/item/custom_ka_upgrade
	)

/obj/item/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/clipboard,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/card/id,
		/obj/item/book,
		/obj/item/newspaper,
		/obj/item/stamp,
		/obj/item/ducttape
		)

/obj/item/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/cell,
		/obj/item/stock_parts,
		/obj/item/device/mmi,
		/obj/item/robot_parts,
		/obj/item/borg/upgrade,
		/obj/item/device/flash, //to build borgs,
		/obj/item/organ/internal/brain, //to insert into MMIs,
		/obj/item/stack/cable_coil, //again, for borg building,
		/obj/item/circuitboard,
		/obj/item/slime_extract,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food/snacks/monkeycube,
		/obj/item/device/assembly,//For building bots and similar complex R&D devices
		/obj/item/device/healthanalyzer,//For building medibots
		/obj/item/disk,
		/obj/item/device/analyzer/plant_analyzer,//For farmbot construction
		/obj/item/material/minihoe,//Farmbots and xenoflora
		/obj/item/computer_hardware,
		/obj/item/slimesteroid,
		/obj/item/slimesteroid2
		)

/obj/item/gripper/chemistry //A gripper designed for chemistry, to allow borgs to work efficiently in the lab
	name = "medical gripper"
	icon_state = "gripper-sci"
	desc = "A specialised grasping tool designed for working in medical treatment facilities and pharmaceutical labs."

	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food/snacks/monkeycube,
		/obj/item/organ,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/spray,
		/obj/item/storage/pill_bottle,
		/obj/item/hand_labeler,
		/obj/item/virusdish,
		/obj/item/paper,
		/obj/item/stack/material/phoron,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/food/drinks/sillycup,
		/obj/item/reagent_containers/food/drinks/medcup
		)

/obj/item/gripper/service //Used to handle food, drinks, and seeds.
	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food,
		/obj/item/seeds,
		/obj/item/grown,
		/obj/item/trash,
		/obj/item/reagent_containers/cooking_container,
		/obj/item/material/kitchen
		)

/obj/item/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/gripper/no_use/attack_self(mob/user)
	return

/obj/item/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet holder"
	desc = "A specialized holding device, designed to hold sheets of material or tiling."
	icon_state = "gripper-sheet"

	can_hold = list(
		/obj/item/stack/material,
		/obj/item/stack/tile
		)
