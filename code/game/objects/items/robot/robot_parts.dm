/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	slot_flags = SLOT_BELT
	var/construction_time = 100
	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL=20000,"glass"=5000)
	var/list/part = null
	var/sabotaged = 0 //Emagging limbs can have repercussions when installed as prosthetics.
	var/model_info = null

/obj/item/robot_parts/proc/attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
	user << "\red This is not used to construct robots."


/obj/item/robot_parts/proc/move_into_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
	user.drop_item()
	src.loc = assembly
	assembly.updateicon()


/obj/item/robot_parts/l_arm
	name = "robot left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	construction_time = 200
	construction_cost = list(DEFAULT_WALL_MATERIAL=18000)
	part = list("l_arm","l_hand")
	model_info=1
	attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
		if(assembly.l_arm)
			return
		assembly.l_arm = src
		move_into_robot(user,assembly)


/obj/item/robot_parts/r_arm
	name = "robot right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	construction_time = 200
	construction_cost = list(DEFAULT_WALL_MATERIAL=18000)
	part = list("r_arm","r_hand")
	model_info=1
	attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
		if(assembly.r_arm)
			return
		assembly.r_arm = src
		move_into_robot(user,assembly)

/obj/item/robot_parts/l_leg
	name = "robot left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	construction_time = 200
	construction_cost = list(DEFAULT_WALL_MATERIAL=15000)
	part = list("l_leg","l_foot")
	model_info=1
	attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
		if(assembly.l_leg)
			return
		assembly.l_leg = src
		move_into_robot(user,assembly)


/obj/item/robot_parts/r_leg
	name = "robot right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	construction_time = 200
	construction_cost = list(DEFAULT_WALL_MATERIAL=15000)
	part = list("r_leg","r_foot")
	model_info=1
	attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
		if(assembly.r_leg)
			return
		assembly.r_leg = src
		move_into_robot(user,assembly)


/obj/item/robot_parts/chest
	name = "robot torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	construction_time = 350
	construction_cost = list(DEFAULT_WALL_MATERIAL=40000)
	var/wires = 0.0
	var/obj/item/weapon/cell/cell = null
	attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
		if(assembly.chest)
			return
		if(!(src.wires && src.cell))
			if (!src.wires)
				user << "\blue You need to attach wires to it first!"
			if (!src.cell)
				user << "\blue You need to attach a cell to it first!"
			return
		assembly.chest = src
		move_into_robot(user,assembly)


/obj/item/robot_parts/head
	name = "robot head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	construction_time = 350
	construction_cost = list(DEFAULT_WALL_MATERIAL=25000)
	var/obj/item/robot_parts/robot_component/camera/camera = null
	var/obj/item/robot_parts/robot_component/law_computer/law_computer = null
	attach_to_robot(mob/user as mob, obj/item/robot_parts/robot_suit/assembly as obj)
		if(assembly.head)
			return
		if(!src.camera)
			user << "\blue You need to attach a camera to it first!"
			return
		assembly.head = src
		move_into_robot(user,assembly)


/obj/item/robot_parts/robot_suit
	name = "robot endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	construction_time = 500
	construction_cost = list(DEFAULT_WALL_MATERIAL=50000)
	var/obj/item/robot_parts/l_arm/l_arm = null
	var/obj/item/robot_parts/r_arm/r_arm = null
	var/obj/item/robot_parts/l_leg/l_leg = null
	var/obj/item/robot_parts/r_leg/r_leg = null
	var/obj/item/robot_parts/chest/chest = null
	var/obj/item/robot_parts/head/head = null
	var/created_name = ""

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	if(src.l_arm)
		src.overlays += "l_arm+o"
	if(src.r_arm)
		src.overlays += "r_arm+o"
	if(src.chest)
		src.overlays += "chest+o"
	if(src.l_leg)
		src.overlays += "l_leg+o"
	if(src.r_leg)
		src.overlays += "r_leg+o"
	if(src.head)
		src.overlays += "head+o"


/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				feedback_inc("cyborg_frames_built",1)
				return 1
	return 0


/obj/item/robot_parts/robot_suit/proc/allowed_to_build(mob/user as mob, obj/item/device/mmi/brain as obj)
	if(!check_completion()) // not complete? not allowed
		return 0
	if(!check_allowed_to_install_brain(user,brain)) // not allowed to put the brain in there
		return 0
	if(src.head.law_computer) // Ok they are what are we making?
		if(!jobban_isbanned(brain.brainmob, "Cyborg")) // Are you banned?
			return "BORG"
	else //Ok IPC then
		if(is_alien_whitelisted(brain.brainmob, "Machine")) // They still need a whitelist! Scopes.
			return "IPC"
	return 0


/obj/item/robot_parts/robot_suit/proc/check_allowed_to_install_brain(mob/user as mob, obj/item/device/mmi/brain as obj)
	if(!istype(loc,/turf))
		user << "\red You can't put the [brain] in, the frame has to be standing on the ground to be perfectly precise."
		return
	if(!brain.brainmob)
		user << "\red Sticking an empty [brain] into the frame would sort of defeat the purpose."
		return
	if(!brain.brainmob.key)
		var/ghost_can_reenter = 0
		if(brain.brainmob.mind)
			for(var/mob/dead/observer/G in player_list)
				if(G.can_reenter_corpse && G.mind == brain.brainmob.mind)
					ghost_can_reenter = 1
					break
		if(!ghost_can_reenter)
			user << "<span class='notice'>The [brain] is completely unresponsive; there's no point.</span>"
			return
	if(brain.brainmob.stat == DEAD)
		user << "\red Sticking a dead [brain] into the frame would sort of defeat the purpose."
		return
	return TRUE


/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)
	..()
	// HANDLE ED209 ASSEMBLY
	if(istype(W, /obj/item/stack/material/steel) && !l_arm && !r_arm && !l_leg && !r_leg && !chest && !head)
		var/obj/item/weapon/secbot_assembly/ed209_assembly/B = new /obj/item/weapon/secbot_assembly/ed209_assembly
		B.loc = get_turf(src)
		user << "You armed the robot frame"
		W:use(1)
		if (user.get_inactive_hand()==src)
			user.put_in_inactive_hand(B)
		qdel(src)
	// HANDLE RENAME
	if (istype(W, /obj/item/weapon/pen))
		var/t = sanitizeName(user, "Enter new robot name", src.name, src.created_name, MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t
	// HANDLE PART ASSEMBLY
	if(istype(W,/obj/item/robot_parts))
		var/obj/item/robot_parts/part = W
		part.attach_to_robot(user,src)
		return
	// Handle PART REMOVAL
	if(istype(W, /obj/item/weapon/crowbar))
		switch(user.zone_sel.selecting)
			if("head")
				if(head)
					head.loc = loc
					head = null
			if("chest")
				if(chest)
					chest.loc = loc
					chest = null
			if("l_arm","l_hand")
				if(l_arm)
					l_arm.loc = loc
					l_arm = null
			if("r_arm","r_hand")
				if(r_arm)
					r_arm.loc = loc
					r_arm = null
			if("l_leg","l_foot")
				if(l_leg)
					l_leg.loc = loc
					l_leg = null
			if("r_leg","r_foot")
				if(r_leg)
					r_leg.loc = loc
					r_leg = null
		updateicon()
		return
	// HANDLE ROBOT CREATION
	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/brain = W
		switch(allowed_to_build(user,brain)) // we are allowed to build this robot
			if("BORG") // do we have a law computer? If so, we're making a standard robot
				user.drop_item() // We only drop it if it's compatible
				create_robot(brain)
				return
			if("IPC")
				user.drop_item() // We only drop it if it's compatible
				create_shell(brain)
				return
		user << "The frame refuses to intergate with [brain]"
		return

/obj/item/robot_parts/robot_suit/proc/create_robot(obj/item/device/mmi/brain as obj)
	var/mob/living/silicon/robot/new_robot = new(get_turf(loc), unfinished = 1)
	if(!new_robot) // something has gone poorly
		return
	// move the brain
	new_robot.mmi = brain
	new_robot.invisibility = 0
	new_robot.custom_name = created_name
	new_robot.updatename("Default")
	brain.brainmob.mind.transfer_to(new_robot) // shove that mob in the mmi
	if(new_robot.mind && new_robot.mind.special_role)
		new_robot.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
	new_robot.job = "Cyborg"
	new_robot.cell = chest.cell
	new_robot.cell.loc = new_robot
	brain.loc = new_robot //Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.
	if(new_robot.cell) // Since we "magically" installed a cell, we also have to update the correct component.
		var/datum/robot_component/cell_component = new_robot.components["power cell"]
		cell_component.wrapped = new_robot.cell
		cell_component.installed = 1
	feedback_inc("cyborg_birth",1)
	new_robot.Namepick()
	qdel(src)


/obj/item/robot_parts/robot_suit/proc/create_shell(obj/item/device/mmi/brain as obj)
	var/mob/living/carbon/human/new_shell = new(src.loc, "Machine")
	brain.brainmob.mind.transfer_to(new_shell) // transfer brain
	var/obj/item/organ/brain/robot/brain_item=new_shell.internal_organs_by_name["brain"] // put the brain in the head
	brain_item.machine_brain_type=brain.machine_brain_type
	new_shell.real_name=brain.brainmob.real_name
	give_option_to_rename(new_shell)
	qdel(brain)
	qdel(src)

proc/give_option_to_rename(var/mob/living/carbon/human/new_shell)
	spawn(0)
		var/newname
		newname = input(new_shell,"You are a newly created humanoid robot. Enter a name.", "Name change","") as text
		if (newname != "")
			new_shell.fully_replace_character_name(new_shell.real_name,newname)


/obj/item/robot_parts/chest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/cell))
		if(src.cell)
			user << "\blue You have already inserted a cell!"
			return
		else
			user.drop_item()
			W.loc = src
			src.cell = W
			user << "\blue You insert the cell!"
	if(istype(W, /obj/item/stack/cable_coil))
		if(src.wires)
			user << "\blue You have already inserted wire!"
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			src.wires = 1.0
			user << "\blue You insert the wire!"
	return


/obj/item/robot_parts/head/attack_hand(mob/user)
	var/obj/item/inactive_item = user.get_inactive_hand()
	if (src==inactive_item) // if we are clicking on this in our hand
		if(src.law_computer)
			src.law_computer.add_fingerprint(user)
			user.put_in_active_hand(src.law_computer)
			user << "You carefully remove \the [src.law_computer] from the head."
			src.law_computer = null
			return
		else if(src.camera)
			src.camera.add_fingerprint(user)
			user.put_in_active_hand(src.camera)
			user << "You carefully remove \the [src.camera] from the head."
			src.camera = null
			return
	return ..()


/obj/item/robot_parts/head/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/flash))
		user << "\red Why are you trying to put a weapon into a robots head? (use a camera component)" // should warn people who have done it the other way
	if(istype(W, /obj/item/robot_parts/robot_component/camera))
		if(src.camera)
			user << "\red You have already inserted the camera!"
			return
		else
			user.drop_item()
			W.loc = src
			src.camera = W
			user << "\blue You carefully insert the camera into the camera socket."
	else if(istype(W, /obj/item/robot_parts/robot_component/law_computer))
		if(src.law_computer)
			user << "\red You have already inserted a law computer!"
			return
		else
			user.drop_item()
			W.loc = src
			src.law_computer = W
			user << "\blue You carefully insert the law computer into the robots head. This will slave the robot to the station AI."
	else if(istype(W, /obj/item/weapon/stock_parts/manipulator))
		user << "\blue You install some manipulators and modify the head, creating a functional spider-bot!"
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		user.drop_item()
		qdel(W)
		qdel(src)
		return
	return


/obj/item/robot_parts/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/card/emag))
		if(sabotaged)
			user << "\red [src] is already sabotaged!"
		else
			user << "\red You slide [W] into the dataport on [src] and short out the safeties."
			sabotaged = 1
		return
	..()
