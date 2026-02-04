/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0


/**
 * Before anything else, defer these calls to a per-mobtype handler.  This allows us to
 * remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.
 *
 * Alternately, you could hardcode every mob's variation in a flat [/mob/proc/ClickOn] proc; however,
 * that's a lot of code duplication and is hard to maintain.
 *
 * Note that this proc can be overridden, and is in the case of screen objects.
 */
/atom/Click(location, control, params)
	if(flags_1 & INITIALIZED_1)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)

		//Aurora snowflake click handler system
		var/datum/click_handler/click_handler = usr.GetClickHandler()
		click_handler.OnClick(src, params)

/atom/DblClick(location,control,params)
	if(flags_1 & INITIALIZED_1)
		//Aurora snowflake click handler system
		var/datum/click_handler/click_handler = usr.GetClickHandler()
		click_handler.OnDblClick(src, params)

		//Why god why
		if(istype(usr.machine, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/console = usr.machine
			console.jump_on_click(usr,src)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	if(flags_1 & INITIALIZED_1)
		usr.MouseWheelOn(src, delta_x, delta_y, params)

/**
 * Standard mob ClickOn()
 * Handles exceptions: middle click, modified clicks, mech actions
 *
 * After that, mostly just check your state, check whether you're holding an item,
 * check whether you're adjacent to the target, then pass off the click to whoever
 * is receiving it.
 * The most common are:
 * * [mob/proc/UnarmedAttack] (atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
 * * [atom/proc/attackby] (item,user) - used only when adjacent
 * * [obj/item/proc/afterattack] (atom,user,adjacent,params) - used both ranged and adjacent
 * * [mob/proc/RangedAttack] (atom,modifiers) - used only ranged, only used for tk and laser eyes but could be changed
 */
/mob/proc/ClickOn(atom/A, params)
	if(world.time <= next_click) // Hard check, before anything else, to avoid crashing
		return
	next_click = world.time + 1

	var/list/modifiers = params2list(params)

	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

	/* START Aurora snowflake */

	if(istype(loc, /mob/living/heavy_vehicle) && !(A in src.contents))
		var/mob/living/heavy_vehicle/M = loc
		return M.ClickOn(A, params, src)

	// pAI handling
	if(istype(loc.loc, /mob/living/bot))
		var/mob/living/bot/B = loc.loc
		if(!B.on)
			to_chat(src, SPAN_WARNING("\The [B] isn't turned on!"))
			return
		return B.ClickOn(A, params)

	/* END Aurora snowflake */

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

	if(stat || paralysis || stunned || weakened) // In TG it's if(INCAPACITATED_IGNORING(src, INCAPABLE_RESTRAINTS|INCAPABLE_STASIS))
		return

	face_atom(A) // change direction to face what you clicked on

	/* START Aurora snowflake */
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		RightClickOn(A)
		return TRUE
	/* END Aurora snowflake */

	if(!canClick()) // in the year 2000...
		return

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode && (isturf(A) || isturf(A.loc)) && throw_item(A))
		trigger_aiming(TARGET_CAN_CLICK)
		throw_mode_off()
		return TRUE

	var/obj/item/W = get_active_hand()

	if(W == A)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			W.attack_self_secondary(src, modifiers)
			/* START Aurora snowflake */
			trigger_aiming(TARGET_CAN_CLICK)
			if(hand)
				update_inv_l_hand(FALSE)
			else
				update_inv_r_hand(FALSE)
			/* END Aurora snowflake */
			return
		else
			W.attack_self(src, modifiers)
			/* START Aurora snowflake */
			trigger_aiming(TARGET_CAN_CLICK)
			if(hand)
				update_inv_l_hand(FALSE)
			else
				update_inv_r_hand(FALSE)
			/* END Aurora snowflake */
			return


	/* START AURORA SNOWFLAKE CODE */

	//Atoms on your person
	// A is your location but is not a turf; or is on you (backpack); or is on something on you (box in backpack); sdepth is needed here because contents depth does not equate inventory storage depth.
	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		if(W)
			var/resolved = W.resolve_attackby(A, src, params)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1 indicates adjacency
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, TRUE, modifiers)

		trigger_aiming(TARGET_CAN_CLICK)
		return 1

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in something on a turf (pen in a box); but not something in something on a turf (pen in a box in a backpack)
	sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src) || (W && W.attack_can_reach(src, A, W.reach)) ) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = W.resolve_attackby(A,src, params)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params) // 1: clicking something Adjacent
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, TRUE, modifiers)

			trigger_aiming(TARGET_CAN_CLICK)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A, src, 0, params) // 0: not Adjacent
			else
				RangedAttack(A, params)

			trigger_aiming(TARGET_CAN_CLICK)
	return 1

	/* END AURORA SNOWFLAKE CODE */

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(GLOB.config.no_click_cooldown || next_move <= world.time)
		return 1
	return 0

/// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return

/**
 * UnarmedAttack: The higest level of mob click chain discounting click itself.
 *
 * This handles, just "clicking on something" without an item. It translates
 * into [atom/proc/attack_hand], [atom/proc/attack_animal] etc.
 *
 * Note: proximity_flag here is used to distinguish between normal usage (flag=1),
 * and usage when clicking on things telekinetically (flag=0).  This proc will
 * not be called at ranged except with telekinesis.
 *
 * proximity_flag is not currently passed to attack_hand, and is instead used
 * in human click code to allow glove touches only at melee range.
 *
 * modifiers is a lazy list of click modifiers this attack had,
 * used for figuring out different properties of the click, mostly right vs left and such.
 */

/mob/proc/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	return

/mob/living/UnarmedAttack(var/atom/A, var/proximity_flag)
	if(!(GAME_STATE & RUNLEVELS_PLAYING))
		to_chat(src, "You cannot attack people before the game has started.")
		return FALSE

	if(stat)
		return FALSE

	if(check_sting(src, A))
		return FALSE

	return 1

/**
 * Ranged unarmed attack:
 *
 * This currently is just a default for all mobs, involving
 * laser eyes and telekinesis.  You could easily add exceptions
 * for things like ranged glove touches, spitting alien acid/neurotoxin,
 * animals lunging, etc.
 */
/mob/proc/RangedAttack(atom/A, modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, A, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

	if((mutations & LASER_EYES) && a_intent == I_HURT)
		LaserEyes(A, modifiers) // moved into a proc below
		return
	A.attack_ranged(src, modifiers)

/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/**
 * Middle click
 * Mainly used for swapping hands
 */
/mob/proc/MiddleClickOn(atom/A, params)
	. = SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, A, params)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	if(A.handle_middle_mouse_click(src))
		return
	swap_hand()

/mob/living/carbon/human/MiddleClickOn(atom/A, params)
	if(species.handle_middle_mouse_click(src, A))
		return
	return ..()

/**
 * Shift click
 * For most mobs, examine.
 * This is overridden in ai.dm
 */
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	SEND_SIGNAL(src, COMSIG_SHIFT_CLICKED_ON, user)
	var/flags = SEND_SIGNAL(user, COMSIG_CLICK_SHIFT, src)
	if(flags & COMSIG_MOB_CANCEL_CLICKON)
		return
	if(user.can_examine() || flags & COMPONENT_ALLOW_EXAMINATE)
		examinate(user, src)

/mob/proc/ShiftMiddleClickOn(atom/A)
	src.pointed(A)
	return

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(var/mob/user)
	var/turf/T = get_turf(src)
	if(!T || !user.TurfAdjacent(T))
		return FALSE
	if(T && (isturf(loc) || isturf(src)) && user.TurfAdjacent(T))
		user.set_listed_turf(T)

/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/mob/proc/RightClickOn(atom/A)
	A.RightClick(src)

/atom/proc/RightClick(mob/user)
	return

///Main proc for secondary alt click
/mob/proc/AltClickSecondaryOn(atom/target)
	base_click_alt_secondary(target)

/**
 * ### Base proc for alt click interaction right click.
 *
 * If you wish to add custom `click_alt_secondary` behavior for a single type, use that proc.
 */
/mob/proc/base_click_alt_secondary(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	//Hook on the mob to intercept the click
	if(SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON_SECONDARY, target) & COMSIG_MOB_CANCEL_CLICKON)
		return

	//Hook on the atom to intercept the click
	if(SEND_SIGNAL(target, COMSIG_CLICK_ALT_SECONDARY, src) & COMPONENT_CANCEL_CLICK_ALT_SECONDARY)
		return

	// If it has a custom click_alt_secondary then do that
	//if(can_perform_action(target, target.interaction_flags_click | SILENT_ADJACENCY))
	target.click_alt_secondary(src)

/**
 * ## Custom alt click secondary interaction
 * Override this to change default alt right click behavior.
 *
 * ### Guard clauses
 * Consider adding `interaction_flags_click` before adding unique guard clauses.
 **/
/atom/proc/click_alt_secondary(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return NONE

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A, params)
	return

/mob/living/LaserEyes(atom/A, params)
	setClickCooldown(4)
	var/turf/T = get_turf(src)
	src.visible_message(SPAN_DANGER("\The [src]'s eyes flare with ruby light!"))
	fire_projectile(/obj/projectile/beam, T, 'sound/weapons/wave.ogg', firer = src)

/mob/living/carbon/human/LaserEyes(atom/A, params)
	if(nutrition <= 0)
		to_chat(src, SPAN_WARNING("You're out of energy!  You need food!"))
		return
	..()
	adjustNutritionLoss(rand(1,5))
	handle_regular_hud_updates()

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A, var/force_face = FALSE)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y

	var/direction
	if (loc == A.loc && A.atom_flags & ATOM_FLAG_CHECKS_BORDER)
		direction = A.dir
	else if (!dx && !dy)
		return
	else if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST

	if(direction != dir)
		facedir(direction, force_face)

GLOBAL_LIST(click_catchers)

/atom/movable/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER-7,CENTER-7"

/atom/movable/screen/click_catcher/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE

/proc/create_click_catcher()
	. = list()
	for(var/i = 0, i<15, i++)
		for(var/j = 0, j<15, j++)
			var/atom/movable/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC

/atom/movable/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, MIDDLE_CLICK) && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/click_turf = parse_caught_click_modifiers(modifiers, get_turf(usr.client ? usr.client.eye : usr), usr.client)
		if (click_turf)
			modifiers["catcher"] = TRUE
			click_turf.Click(click_turf, control, list2params(modifiers))
	. = 1

/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)

// Suppress the mouse macros
/client/var/has_mouse_macro_warning
/mob/proc/LogMouseMacro(verbused, params)
	if(!client)
		return
	if(!client.has_mouse_macro_warning) // Log once
		log_admin("[key_name(usr)] attempted to use a mouse macro: [verbused] [params]")
/mob/verb/ClickSubstitute(params as command_text)
	set hidden = 1
	set name = ".click"
	LogMouseMacro(".click", params)
/mob/verb/DblClickSubstitute(params as command_text)
	set hidden = 1
	set name = ".dblclick"
	LogMouseMacro(".dblclick", params)
/mob/verb/MouseSubstitute(params as command_text)
	set hidden = 1
	set name = ".mouse"
	LogMouseMacro(".mouse", params)
