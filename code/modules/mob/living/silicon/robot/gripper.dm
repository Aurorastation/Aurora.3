//Simple borg hand.
//Limited use.
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"

	flags = NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/frame,
		/obj/item/device/assembly,//Primarily for making improved cameras, but opens many possibilities
		)

	var/obj/item/wrapped = null // Item currently being held.

	var/force_holder = null //
	var/justdropped = 0//When set to 1, the gripper has just dropped its item, and should not attempt to trigger anything

	..()
	if (wrapped)
		user << span("notice", "It is holding \the [wrapped]")
	else
		user << "It is empty."


	if (!G || !G.wrapped)//The object must have been lost
		return 0

	//The object left the gripper but it still exists. Maybe placed on a table
	if (G.wrapped.loc != G)
		//Reset the force and then remove our reference to it
		G.wrapped.force = G.force_holder
		G.wrapped = null
		G.force_holder = null
		G.update_icon()
		return 0

	return 1



	//This function returns 1 if we successfully took the item, or 0 if it was invalid. This information is useful to the caller
	if (!wrapped)
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				if (feedback)
					user << "You collect \the [I]."
				I.loc = src
				wrapped = I
				update_icon()
				return 1
		if (feedback)
			user << "<span class='danger'>Your gripper cannot hold \the [I].</span>"
		return 0
	if (feedback)
		user << "<span class='danger'>Your gripper is already holding \the [wrapped].</span>"
	return 0

	overlays.Cut()//Dummy object will be picked up by garbage collection
	if (wrapped && wrapped.icon)


		var/obj/dummy = new //We create a dummy object which looks like the gripped item, to use as an overlay
		dummy.icon = wrapped.icon
		dummy.icon_state = wrapped.icon_state
		dummy.overlays = wrapped.overlays
		dummy.layer = 20
		dummy.pixel_y = -8
		overlays += dummy

		var/image/I = image(icon, src, icon_state)//Overlaying ourselves ontop of the thing.
		I.layer = 20
		overlays += I
		//Layering overlays seems faster than blending the images


	if(wrapped)
		.=wrapped.attack_self(user)
		update_icon()
		return
	return ..()

	if(wrapped)
		.=wrapped.AltClick(user)
		update_icon()
	return ..()


	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Robot Commands"

	drop(get_turf(src))

	if(wrapped && wrapped.loc == src)
		wrapped.forceMove(target)
	wrapped = null
	update_icon()
	return 1

	if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
		force_holder = wrapped.force
		wrapped.force = 0.0
		wrapped.attack(M,user)
		if(QDELETED(wrapped))
			wrapped = null
		return 1
	else// mob interactions
		switch (user.a_intent)
			if ("help")
				user.visible_message("[user] [pick("boops", "squeezes", "pokes", "prods", "strokes", "bonks")] [M] with the [src]")
			if ("harm")
				M.attack_generic(user,user.mob_size,"crushed")//about 16 dmg for a cyborg
				//Attack generic does a visible message so we dont need one here
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*3)
				playsound(user, 'sound/effects/attackblob.ogg', 60, 1)
				//Slow,powerful attack for borgs. No spamclicking
	return 0

	if (wrapped)
		var/resolved = wrapped.attackby(O,user)
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)//We pass along things targeting the gripper, to objects inside the gripper. So that we can draw chemicals from held beakers for instance
	return


	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.

	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break

	if(wrapped) //Already have an item.
		return//This is handled in /mob/living/silicon/robot/GripperClickOn

		for (var/obj/item/C in target.contents)
			if (grip_item(C, user, 0))
				user << "You grab the [C] from inside the [target.name]."
				return
		user << "There is nothing inside the box that your gripper can collect"
		return

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		grip_item(target, user)

	else if (!justdropped)
		target.attack_ai(user)

	justdropped = 0







/*
	//Definitions of gripper subtypes
*/

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(
	)

	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		)

	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/device/mmi,
		/obj/item/robot_parts,
		/obj/item/borg/upgrade,
		/obj/item/device/flash, //to build borgs,
		/obj/item/organ/brain, //to insert into MMIs,
		/obj/item/stack/cable_coil, //again, for borg building,
		/obj/item/slime_extract,
		/obj/item/device/assembly,//For building bots and similar complex R&D devices
		/obj/item/device/healthanalyzer,//For building medibots
		/obj/item/device/analyzer/plant_analyzer,//For farmbot construction
		)

	name = "chemistry gripper"
	icon_state = "gripper-sci"
	desc = "A specialised grasping tool designed for working in chemistry and pharmaceutical labs"

	can_hold = list(
		/obj/item/stack/material/phoron
		)

	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(
		/obj/item/seeds,
		/obj/item/trash,
		)


	return

	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(
		/obj/item/stack/material
		)
