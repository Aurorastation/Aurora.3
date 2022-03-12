/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

/mob/living/silicon/robot/ClickOn(var/atom/A, var/params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(stat || lock_charge || weakened || stunned || paralysis)
		return

	if(!canClick())
		return

	face_atom(A) // change direction to face what you clicked on

	if(ai_camera.in_camera_mode)
		ai_camera.camera_mode_off()
		if(is_component_functioning("camera"))
			ai_camera.captureimage(A, usr)
		else
			to_chat(src, SPAN_DANGER("Your camera isn't functional."))
		return

	var/obj/item/W = get_active_hand()

	// Cyborgs have no range-checking unless there is item use
	if(!W || isrobot(A.loc.loc))
		A.add_hiddenprint(src)
		A.attack_robot(src)
		return

	// buckled_to cannot prevent machine interlinking but stops arm movement
	if(buckled_to)
		return

	if(W == A)
		W.attack_self(src)
		return

	// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc in contents)
	if(A == loc || (A in loc) || (A in contents))
		// No adjacency checks

		var/resolved = A.attackby(W,src)
		if(!resolved)
			W.afterattack(A,src,1,params)
		return

	if(!isturf(loc))
		return

	// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc && isturf(A.loc.loc))
	if(isturf(A) || isturf(A.loc))
		if(A.Adjacent(src)) // see adjacent.dm
			var/resolved = W.resolve_attackby(A, src, params)
			if(!resolved)
				W.afterattack(A, src, 1, params)
		else
			W.afterattack(A, src, 0, params)
	return

//Middle click cycles through selected modules.
/mob/living/silicon/robot/MiddleClickOn(var/atom/A)
	cycle_modules()
	return

//Give cyborgs hotkey clicks without breaking existing uses of hotkey clicks
// for non-doors/apcs
/mob/living/silicon/robot/CtrlShiftClickOn(var/atom/A)
	A.BorgCtrlShiftClick(src)

/mob/living/silicon/robot/ShiftClickOn(var/atom/A)
	A.BorgShiftClick(src)

/mob/living/silicon/robot/CtrlClickOn(var/atom/A)
	A.BorgCtrlClick(src)

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	var/doClickAction = 1
	if (istype(module_active, /obj/item))
		var/obj/item/I = module_active
		doClickAction = I.alt_attack(A,src)

	if (doClickAction)
		A.BorgAltClick(src)



/atom/proc/BorgCtrlShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick()
	AICtrlShiftClick()

/atom/proc/BorgShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick()  // Opens and closes doors! Forwards to AI code.
	AIShiftClick()


/atom/proc/BorgCtrlClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick(mob/user) // Bolts doors. Forwards to AI code.
	AICtrlClick(user)

/obj/machinery/power/apc/BorgCtrlClick() // turns off/on APCs. Forwards to AI code.
	AICtrlClick()

/obj/machinery/turretid/BorgCtrlClick() //turret control on/off. Forwards to AI code.
	AICtrlClick()

/atom/proc/BorgAltClick(var/mob/living/silicon/robot/user)
	AltClick(user)
	return

/obj/machinery/door/airlock/BorgAltClick() // Eletrifies doors. Forwards to AI code.
	AIAltClick()

/obj/machinery/turretid/BorgAltClick() //turret lethal on/off. Forwards to AI code.
	AIAltClick()

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
*/
/mob/living/silicon/robot/UnarmedAttack(atom/A)
	A.attack_robot(src)
/mob/living/silicon/robot/RangedAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user)
	attack_ai(user)
	return