/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(atom/A, params)
	if(control_disabled || stat)
		return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(stat)
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlMiddleClickOn(A)
		else
			MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK)) // alt and alt-gr (rightalt)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			AltClickSecondaryOn(A)
		else
			AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A)
		return

	if(control_disabled || !canClick())
		return

	if(multitool_mode && isobj(A))
		var/obj/O = A
		var/datum/component/multitool/MT = O.GetComponent(/datum/component/multitool)
		if(MT)
			MT.interact(ai_multi, src)
			return

	if(ai_camera.in_camera_mode)
		ai_camera.camera_mode_off()
		ai_camera.captureimage(A, usr)
		return

	/*
		AI restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
	else
	*/
	A.add_hiddenprint(src)
	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)
/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user as mob)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/ShiftClickOn(var/atom/A)
	if(!control_disabled && A.AIShiftClick(src))
		return
	..()

/mob/living/silicon/ai/CtrlClickOn(var/atom/A)
	if(!control_disabled && A.AICtrlClick(src))
		return
	..()

/mob/living/silicon/ai/AltClickOn(var/mob/living/silicon/user)
	if(!control_disabled && user.AIAltClick(src))
		return

/mob/living/silicon/ai/MiddleClickOn(var/atom/A)
	if(!control_disabled && A.AIMiddleClick(src))
		return
	..()

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/

/atom/proc/AICtrlShiftClick()
	return

/atom/proc/AIShiftClick(var/mob/user)
	return

/obj/machinery/door/airlock/AIShiftClick(var/mob/user)  // Opens and closes doors!
	open_interact(user, density)
	return TRUE

/atom/proc/AICtrlClick(mob/user)
	return

/obj/machinery/door/airlock/AICtrlClick(mob/user) // Bolts doors
	if(player_is_antag(user.mind))
		bolts_override(user, !locked, FALSE, player_is_antag(user.mind))
	else
		bolts_interact(user, !locked, FALSE, player_is_antag(user.mind))
	return TRUE

/obj/machinery/power/apc/AICtrlClick() // turns off/on APCs.
	toggle_breaker()
	return TRUE

/obj/machinery/turretid/AICtrlClick() //turns off/on Turrets
	enabled = !enabled
	updateTurrets()
	return TRUE

/atom/proc/AIAltClick(var/mob/living/silicon/user)
	return AltClick(user)

/obj/machinery/door/airlock/AIAltClick(var/mob/living/silicon/user) // Electrifies doors.
	var/antag = player_is_antag(user.mind)
	if(!antag && (electrified_until == 0))
		to_chat(user, SPAN_WARNING("Your programming prevents you from electrifying the door."))
		return FALSE
	else
		if(!electrified_until)
			// permanent shock
			electrify(-1, 1)
		else
			electrify(0)
	return TRUE

/obj/machinery/turretid/AIAltClick(var/mob/living/silicon/user) //toggles lethal on turrets
	lethal = !lethal
	updateTurrets()
	return TRUE

/atom/proc/AIMiddleClick(var/mob/living/silicon/user)
	return FALSE
//
// Override AdjacentQuick for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(var/turf/T)
	return (GLOB.cameranet && GLOB.cameranet.is_turf_visible(T))
