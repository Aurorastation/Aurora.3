/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/list/part = null // Order of args is important for installing robolimbs.
	var/sabotaged = 0 //Emagging limbs can have repercussions when installed as prosthetics.
	var/model_info
	var/linked_frame = SPECIES_IPC_UNBRANDED
	dir = SOUTH

/obj/item/robot_parts/set_dir()
	return

/obj/item/robot_parts/New(var/newloc, var/model)
	..(newloc)
	if(model_info && model)
		model_info = model
		var/datum/robolimb/R = all_robolimbs[model]
		if(R)
			name = "[R.company] robot [initial(name)]"
			desc = "[R.desc]"
			linked_frame = R.linked_frame
			if(icon_state in icon_states(R.icon))
				icon = R.icon
	else
		name = "robot [initial(name)]"

/obj/item/robot_parts/examine(mob/user, distance)
	. = ..()
	if(Adjacent(user))
		report_missing_parts(user)

/obj/item/robot_parts/proc/report_missing_parts(var/mob/user)
	return

/obj/item/robot_parts/l_arm
	name = "left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	part = list(BP_L_ARM, BP_L_HAND)
	model_info = TRUE

/obj/item/robot_parts/r_arm
	name = "right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	part = list(BP_R_ARM, BP_R_HAND)
	model_info = TRUE

/obj/item/robot_parts/l_leg
	name = "left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	part = list(BP_L_LEG, BP_L_FOOT)
	model_info = TRUE

/obj/item/robot_parts/r_leg
	name = "right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	part = list(BP_R_LEG, BP_R_FOOT)
	model_info = TRUE

/obj/item/robot_parts/chest
	name = "torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	part = list(BP_GROIN, BP_CHEST)
	var/wires = 0
	var/obj/item/cell/cell = null

/obj/item/robot_parts/head
	name = "head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	part = list(BP_HEAD)
	var/obj/item/device/flash/left_flash = null
	var/obj/item/device/flash/right_flash = null
	var/law_manager = TRUE

/obj/item/robot_parts/robot_suit
	name = "endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	var/obj/item/robot_parts/l_arm/l_arm = null
	var/obj/item/robot_parts/r_arm/r_arm = null
	var/obj/item/robot_parts/l_leg/l_leg = null
	var/obj/item/robot_parts/r_leg/r_leg = null
	var/obj/item/robot_parts/chest/chest = null
	var/obj/item/robot_parts/head/head = null
	var/created_name = ""

/obj/item/robot_parts/robot_suit/Initialize()
	. = ..()
	update_icon()

/obj/item/robot_parts/robot_suit/report_missing_parts(var/mob/user)
	if(!head)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional head.")))
	if(!chest)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional chest.")))
	if(!l_arm)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional left arm.")))
	if(!r_arm)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional right arm.")))
	if(!l_leg)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional left leg.")))
	if(!r_leg)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional right leg.")))

/obj/item/robot_parts/robot_suit/equipped/Initialize()
	. = ..()
	l_leg = new /obj/item/robot_parts/l_leg(src)
	r_leg = new /obj/item/robot_parts/r_leg(src)
	l_arm = new /obj/item/robot_parts/l_arm(src)
	r_arm = new /obj/item/robot_parts/r_arm(src)
	update_icon()

/obj/item/robot_parts/robot_suit/update_icon()
	cut_overlays()
	if(l_arm)
		add_overlay("l_arm+o")
	if(r_arm)
		add_overlay("r_arm+o")
	if(chest)
		add_overlay("chest+o")
	if(l_leg)
		add_overlay("l_leg+o")
	if(r_leg)
		add_overlay("r_leg+o")
	if(head)
		add_overlay("head+o")

/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(l_arm && r_arm)
		if(l_leg && r_leg)
			if(chest && head)
				feedback_inc("cyborg_frames_built",1)
				return TRUE
	return FALSE

/obj/item/robot_parts/robot_suit/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/robot_parts/l_leg))
		if(l_leg)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [l_leg] installed."))
			return
		user.drop_from_inventory(W, src)
		l_leg = W
		update_icon()
		return

	if(istype(W, /obj/item/robot_parts/r_leg))
		if(r_leg)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [r_leg] installed."))
			return
		user.drop_from_inventory(W, src)
		r_leg = W
		update_icon()
		return

	if(istype(W, /obj/item/robot_parts/l_arm))
		if(l_arm)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [l_arm] installed."))
			return
		user.drop_from_inventory(W, src)
		l_arm = W
		update_icon()
		return

	if(istype(W, /obj/item/robot_parts/r_arm))
		if(r_arm)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [r_arm] installed."))
			return
		user.drop_from_inventory(W, src)
		r_arm = W
		update_icon()
		return

	if(istype(W, /obj/item/robot_parts/chest))
		if(chest)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [chest] installed."))
			return
		var/obj/item/robot_parts/chest/C = W
		if(C.wires && C.cell)
			user.drop_from_inventory(W, src)
			chest = W
			update_icon()
		else if(!C.wires)
			to_chat(user, SPAN_WARNING("You need to attach wires to it first!"))
		else
			to_chat(user, SPAN_WARNING("You need to attach a cell to it first!"))
		return

	if(istype(W, /obj/item/robot_parts/head))
		if(head)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [head] installed."))
			return
		var/obj/item/robot_parts/head/H = W
		if(H.right_flash && H.left_flash)
			user.drop_from_inventory(W, src)
			head = W
			update_icon()
		else
			to_chat(user, SPAN_WARNING("You need to attach a flash to it first!"))
		return

	if(istype(W, /obj/item/device/mmi/shell))
		var/obj/item/device/mmi/shell/M = W
		if(check_completion())
			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot/shell(get_turf(src), TRUE)
			if(!O)
				return

			user.drop_from_inventory(M, O)
			O.mmi = M
			O.invisibility = 0
			O.custom_name = "Ai shell"

			O.job = "AI Shell"
			O.cell = chest.cell
			O.cell.forceMove(O)
			W.forceMove(O) 
			
			if(O.cell)
				var/datum/robot_component/cell_component = O.components["power cell"]
				cell_component.wrapped = O.cell
				cell_component.installed = TRUE

			qdel(src)
		else
			to_chat(user, SPAN_WARNING("\The [W] can only be inserted after everything else is installed."))
		return

	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!isturf(loc))
				to_chat(user, SPAN_WARNING("You can't put \the [W] in, the frame has to be standing on the ground to be perfectly precise."))
				return
			if(!M.ready_for_use(user))
				return

			if(!head.law_manager)
				if(!is_alien_whitelisted(M.brainmob, SPECIES_IPC) && config.usealienwhitelist)
					to_chat(user, SPAN_WARNING("\The [W] does not seem to fit. (The player lacks the appropriate whitelist.)"))
					return

				if(!M.can_be_ipc)
					to_chat(user, SPAN_WARNING("There's no way that would fit in an IPC chassis!"))
					return

				var/mob/living/carbon/human/new_shell = new(get_turf(src), chest.linked_frame)
				// replace the IPC's microbattery cell with the one that was in the robot chest
				var/obj/item/organ/internal/cell/C = new_shell.internal_organs_by_name[BP_CELL]
				C.replace_cell(chest.cell)
				//so people won't mess around with the chassis until it is deleted
				forceMove(new_shell)
				M.brainmob.mind.transfer_to(new_shell)
				qdel(M)
				new_shell.add_language(LANGUAGE_EAL)
				var/newname = sanitizeSafe(input(new_shell, "Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
				if(!newname)
					var/datum/language/L = all_languages[new_shell.species.default_language]
					newname = L.get_random_name()
				new_shell.real_name = newname
				new_shell.name = new_shell.real_name
				var/obj/item/organ/internal/mmi_holder/posibrain/P = new_shell.internal_organs_by_name[BP_BRAIN]
				P.setup_brain()
				new_shell.change_appearance(APPEARANCE_ALL_HAIR | APPEARANCE_SKIN | APPEARANCE_EYE_COLOR, new_shell)
				qdel(src)
				return

			else
				if(jobban_isbanned(M.brainmob, "Cyborg"))
					to_chat(user, SPAN_WARNING("\The [W] does not seem to fit. (The player has been banned from playing this role)"))
					return

				var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(src), TRUE)
				if(!O)
					return

				user.drop_from_inventory(M, O)
				O.mmi = W
				O.invisibility = 0
				O.custom_name = created_name
				O.updatename("Default")

				M.brainmob.mind.transfer_to(O)

				O.job = "Cyborg"
				O.cell = chest.cell
				O.cell.forceMove(O)
				W.forceMove(O) //Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

				// Since we "magically" installed a cell, we also have to update the correct component.
				if(O.cell)
					var/datum/robot_component/cell_component = O.components["power cell"]
					cell_component.wrapped = O.cell
					cell_component.installed = TRUE

				feedback_inc("cyborg_birth", 1)
				callHook("borgify", list(O))
				O.Namepick()
				qdel(src)
		else
			to_chat(user, SPAN_WARNING("\The [W] can only be inserted after everything else is installed."))
		return

	if(W.ispen())
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return

	return ..()

/obj/item/robot_parts/chest/report_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking a functional cell.")))
	if(!wires)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking wiring.")))

/obj/item/robot_parts/chest/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [cell] inserted."))
			return
		else
			user.drop_from_inventory(W, src)
			cell = W
			to_chat(user, SPAN_NOTICE("You insert \the [src]."))
		return
	if(W.iscoil())
		if(wires)
			to_chat(user, SPAN_WARNING("\The [src] is already wired up correctly."))
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			wires = TRUE
			to_chat(user, SPAN_NOTICE("You wire up \the [src]."))
		return
	return ..()

/obj/item/robot_parts/head/report_missing_parts(var/mob/user)
	var/law_manager_msg = "Its lawing circuits are <b>[law_manager ? "enabled" : "disabled"]</b>."
	to_chat(user, SPAN_NOTICE(law_manager_msg))
	if(!left_flash)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking its left flash.")))
	if(!right_flash)
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is lacking its right flash.")))

/obj/item/robot_parts/head/attackby(obj/item/W, mob/user)
	..()
	if(W.ismultitool())
		if(law_manager)
			to_chat(user, SPAN_NOTICE("You disable the lawing circuits on \the [src]."))
			law_manager = FALSE
		else
			to_chat(user, SPAN_NOTICE("You enable the lawing circuits on \the [src]."))
			law_manager = TRUE

	if(istype(W, /obj/item/device/flash))
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(istype(R.module_active, /obj/item/device/flash))
				to_chat(user, SPAN_WARNING("You cannot detach your own flash and install it into \the [src]."))
				return
			else
				add_flashes(W,user)
		else
			add_flashes(W,user)
	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, SPAN_NOTICE("You install some manipulators and modify the head, creating a functional spider-bot!"))
		new /mob/living/simple_animal/spiderbot(get_turf(src))
		user.drop_from_inventory(W, get_turf(user))
		qdel(W)
		qdel(src)
		return
	return

/obj/item/robot_parts/head/proc/add_flashes(obj/item/W, mob/user) //Made into a seperate proc to avoid copypasta
	if(left_flash && right_flash)
		to_chat(user, SPAN_WARNING("\The [src] already has both its flashes installed."))
		return
	else if(left_flash)
		user.drop_from_inventory(W, src)
		right_flash = W
		to_chat(user, SPAN_NOTICE("You install the flash into the left socket."))
	else
		user.drop_from_inventory(W, src)
		left_flash = W
		to_chat(user, SPAN_NOTICE("You install the flash into the right socket."))

/obj/item/robot_parts/emag_act(var/remaining_charges, var/mob/user)
	if(sabotaged)
		to_chat(user, SPAN_WARNING("\The [src] is already sabotaged!"))
	else
		to_chat(user, SPAN_NOTICE("You short out \the [src]'s safeties."))
		sabotaged = TRUE
		return TRUE

//branded chest, to be used in ipc ressurection

/obj/item/robot_parts/chest/bishop
	name = "Bishop cybernetics torso"
	model_info = TRUE
	linked_frame = SPECIES_IPC_BISHOP

/obj/item/robot_parts/chest/hephaestus
	name = "Hephaestus industries torso"
	linked_frame = SPECIES_IPC_G2

/obj/item/robot_parts/chest/zenghu
	name = "Zeng-Hu pharmaceuticals torso"
	linked_frame = SPECIES_IPC_ZENGHU

/obj/item/robot_parts/chest/synthskin
	name = "Human synthskin torso"
	linked_frame = SPECIES_IPC_SHELL

/obj/item/robot_parts/chest/xion
	name = "Xion manufacturing group torso"
	linked_frame = SPECIES_IPC_XION

/obj/item/robot_parts/chest/ipc
	name = "Hephaestus integrated torso"
	linked_frame = SPECIES_IPC

/obj/item/robot_parts/chest/industrial
	name = "Hephaestus industrial torso"
	linked_frame = SPECIES_IPC_G1
