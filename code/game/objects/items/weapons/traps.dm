/obj/item/trap
	name = "mechanical trap"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/item/traps/traps.dmi'
	icon_state = "beartrap"
	randpixel = 0
	center_of_mass = null
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 18750)
	can_buckle = list(/mob/living)

	update_icon_on_init = TRUE

	/// This boolean indicates that the trap is deployed and ready to trap a mob. It can only be deployed after being secured.
	var/deployed = FALSE

	/// This boolean determines whether the trap will unanchor itself after being disarmed
	var/unsecure_on_disarm = TRUE

	/// Time in deciseconds needed to escape from the trap
	var/time_to_escape = 1 MINUTE

	/// When the trap triggers and does damage, this will be the armor penetration value
	var/activated_armor_penetration = 0

/obj/item/trap/Initialize()
	. = ..()
	update_icon()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/trap/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += get_trap_examine_text(user, distance, is_adjacent, infix, suffix)

/obj/item/trap/proc/get_trap_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = list()
	if(buckled)
		. += SPAN_NOTICE("You can free the creature inside the trap by clicking on it.")
	else if(deployed)
		. += SPAN_NOTICE("You can disarm the trap by clicking on it.")
	else
		. += SPAN_NOTICE("You can deploy the trap by using it in-hand.")

/obj/item/trap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/trap/attack_self(mob/user)
	..()
	if(!deployed && can_use(user))
		if(deploy(user))
			user.drop_from_inventory(src)
			anchored = TRUE

/obj/item/trap/proc/deploy(mob/user)
	user.visible_message("[SPAN_BOLD("[user]")] starts deploying \the [src]...", SPAN_NOTICE("You begin deploying \the [src]!"), SPAN_WARNING("You hear the slow creaking of a spring."))

	if(do_after(user, 5 SECONDS))
		user.visible_message("[SPAN_BOLD("[user]")] deploys \the [src].", SPAN_WARNING("You deploy \the [src]!"), SPAN_WARNING("You hear a latch click loudly."))
		deployed = TRUE
		update_icon()
		return TRUE

	return FALSE

/obj/item/trap/user_unbuckle(mob/user)
	if(!buckled || !can_use(user))
		return

	user.visible_message("[SPAN_BOLD("[user]")] begins freeing \the [buckled] from \the [src]...", SPAN_NOTICE("You carefully begin to free \the [buckled] from \the [src]..."), SPAN_NOTICE("You hear metal creaking."))

	if(do_after(user, time_to_escape))
		user.visible_message("[SPAN_BOLD("[user]")] frees \the [buckled] from \the [src].", SPAN_NOTICE("You free \the [buckled] from \the [src]."))
		unbuckle()
		anchored = FALSE

/obj/item/trap/attack_hand(mob/user)
	if(can_use(user))
		if(buckled)
			user_unbuckle(user)
			return
		else if(deployed)
			disarm_trap(user)
			return
	..()

/obj/item/trap/proc/disarm_trap(var/mob/user)
	user.visible_message("[SPAN_BOLD("[user]")] starts disarming \the [src]...", SPAN_NOTICE("You begin disarming \the [src]..."), SPAN_WARNING("You hear a latch click followed by the slow creaking of a spring."))
	if(do_after(user, 6 SECONDS))
		user.visible_message("[SPAN_BOLD("[user]")] disarms \the [src]!", SPAN_NOTICE("You disarm \the [src]!"))
		deployed = FALSE
		if(unsecure_on_disarm)
			anchored = FALSE
		update_icon()

/obj/item/trap/proc/attack_mob(mob/living/L)
	var/target_zone = L.lying ? ran_zone() : pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	var/success = L.apply_damage(30, DAMAGE_BRUTE, target_zone, used_weapon = src, armor_pen = activated_armor_penetration)
	if(!success)
		return FALSE

	L.visible_message(SPAN_DANGER("\The [L] steps on \the [src]!"), FONT_LARGE(SPAN_DANGER("You step on \the [src]!")), SPAN_WARNING("<b>You hear a loud metallic snap!</b>"))

	var/did_trap = TRUE
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/external/limb = H.get_organ(check_zone(target_zone))
		if(!limb || limb.is_stump()) // oops, we took the limb clean off
			did_trap = FALSE

	if(did_trap)
		//trap the victim in place
		buckle(L)

	deployed = FALSE
	to_chat(L, FONT_LARGE(SPAN_DANGER("The steel jaws of \the [src] bite into you, [did_trap ? "trapping you in place" : "cleaving your limb clean off"]!")))
	playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, TRUE) //Really loud snapping sound

	if (istype(L, /mob/living/simple_animal/hostile/bear))
		var/mob/living/simple_animal/hostile/bear/bear = L
		bear.anger += 15//traps make bears really angry
		bear.instant_aggro()

	if(!buckled)
		anchored = FALSE
		deployed = FALSE

/obj/item/trap/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(ishuman(arrived))
		var/mob/living/carbon/human/H = arrived
		if(H.shoes?.item_flags & ITEM_FLAG_LIGHT_STEP)
			return
	if(deployed && isliving(arrived))
		var/mob/living/L = arrived
		if(L.pass_flags & PASSTABLE)
			return
		INVOKE_ASYNC(src, PROC_REF(attack_mob), L)
		update_icon()
		shake_animation()

/obj/item/trap/update_icon()
	icon_state = "[initial(icon_state)][deployed]"


/*
##################
	Subtypes
##################
*/

/**
 * # Sharpened trap
 *
 * This device has an even higher chance of penetrating armor and locking foes in place
 */
/obj/item/trap/sharpened
	name = "sharpened mechanical trap"
	desc_antag = "This device has an even higher chance of penetrating armor and locking foes in place."
	activated_armor_penetration = 100

/**
 * # Tripwire trap
 *
 * A trap that makes you fall over
 */
/obj/item/trap/tripwire
	name = "tripwire trap"
	desc = "A piece of cable coil strung between two metal rods. Low-tech, but reliable."
	icon_state = "tripwire"
	color = COLOR_RED
	layer = UNDERDOOR // so you can't cover it with items

/obj/item/trap/tripwire/Initialize(mapload, var/new_cable_color)
	. = ..()
	if(!new_cable_color)
		new_cable_color = COLOR_RED
	color = new_cable_color

/obj/item/trap/tripwire/update_icon()
	underlays = null
	icon_state = "[initial(icon_state)][deployed]"
	var/image/I = image(icon, null, "[icon_state]_base")
	I.appearance_flags = RESET_COLOR
	underlays = list(I)

/obj/item/trap/tripwire/deploy(mob/user)
	user.visible_message(SPAN_WARNING("\The [user] starts to deploy \the [src]."), SPAN_WARNING("You begin deploying \the [src]!"))
	if(do_after(user, 5 SECONDS))
		user.visible_message(SPAN_WARNING("\The [user] deploys \the [src]."), SPAN_WARNING("You deploy \the [src]!"))
		deployed = TRUE
		update_icon()
		return TRUE
	return FALSE

/obj/item/trap/tripwire/disarm_trap(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] starts to take \the [src] down..."), SPAN_NOTICE("You begin taking \the [src] down..."), SPAN_WARNING("You hear a latch click followed by the slow creaking of a spring."))
	if(do_after(user, 6 SECONDS))
		deployed = FALSE
		if(unsecure_on_disarm)
			anchored = FALSE
		update_icon()

/obj/item/trap/tripwire/attack_mob(mob/living/L)
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	if(!H.organs_by_name[BP_L_LEG] && !H.organs_by_name[BP_R_LEG]) // tripwires are triggered by shin, so if you don't have legs, assume you fly or crawl
		return

	if(!L.lying && (L.m_intent == M_RUN) || prob(5))
		L.visible_message(SPAN_DANGER("\The [L] trips over \the [src]!"), FONT_LARGE(SPAN_DANGER("You trip over \the [src]!")))
		L.Weaken(3)

/**
 * # Punji trap
 *
 * A trap that damages and gives an infection to the victim, can have a message attached
 */
/obj/item/trap/punji
	name = "punji trap"
	desc = "An horrendous trap."
	icon = 'icons/obj/item/traps/punji.dmi'
	icon_state = "punji"
	var/message = null

/obj/item/trap/punji/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(deployed && isliving(arrived))
		var/mob/living/L = arrived
		attack_mob(L)
		update_icon()

/obj/item/trap/punji/attack_mob(mob/living/L)

	//Reveal the trap, if not already visible
	hide(FALSE)

	//Select a target zone
	var/target_zone
	if(L.lying)
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_L_HAND, BP_L_ARM, BP_R_HAND, BP_R_ARM)
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	//Try to apply the damage
	var/success = L.apply_damage(50, DAMAGE_BRUTE, target_zone, used_weapon = src, armor_pen = activated_armor_penetration)

	//If successfully applied, give the message
	if(success)

		//Show the leftover message, if any, after a little
		addtimer(CALLBACK(src, PROC_REF(reveal_message), L), 3 SECONDS)

		//Give a simple message and return if it's not a human
		if(!ishuman(L))
			L.visible_message(SPAN_DANGER("[L] steps on \the [src]!"))
			return

		var/mob/living/carbon/human/human = L
		var/obj/item/organ/organ = human.get_organ(target_zone)

		human.visible_message(SPAN_DANGER("\The [human] steps on \the [src]!"),
								SPAN_WARNING(FONT_LARGE(SPAN_DANGER("You step on \the [src], feel your body fall, and something sharp penetrate your [organ.name]!"))),
								SPAN_WARNING("<b>You feel your body fall, and something sharp penetrate your [organ.name]!</b>"))

		//If it's a human and not an IPC, apply an infection
		//We are returning early before this step in case something isn't a human, so this should be fine not to catch borgs/bot/exosuits/whatever
		if(!isipc(L))

			//If it's a Vaurca, there's a chance the spear wouldn't go in deep enough to apply an infection
			//You're still damaged by falling on it though, which happens above, but at least you're spared the infection
			//Glory to your carapace
			if(isvaurca(L) && prob(50))
				return

			organ.germ_level += INFECTION_LEVEL_TWO

/obj/item/trap/punji/proc/reveal_message(mob/living/victim)
	if(!message)
		return

	//If the mob moved away and/or no longer sees the trap, do not show the message
	if(!(src in oview(world.view, victim)))
		return

	victim.visible_message(SPAN_ALERT("You notice something written on a plate inside the trap: <br>")+SPAN_BAD(message))

/obj/item/trap/punji/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(src.message && distance < 3)
		. += SPAN_ALERT("You notice something written on a plate inside the trap:")
		. += SPAN_BAD(message)

/obj/item/trap/punji/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set desc = "Hide the trap under the cover."
	set category = "Object"

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	to_chat(usr, SPAN_NOTICE("You begin hiding the trap..."))
	if(!do_after(usr, 15 SECONDS))
		return

	hide(TRUE)
	to_chat(usr, SPAN_ALERT("You hide \the [src], remember where you left it or suffer the very same warcrime you wanted to inflict!"))

/obj/item/trap/punji/verb/set_message()
	set src in oview(1)
	set name = "Set Message"
	set desc = "Set a message for the victim of the trap."
	set category = "Object"

	if(src.message)
		to_chat(usr, SPAN_NOTICE("There is already a carved message inside the trap, can't make more..."))
		return

	var/added_message = tgui_input_text(usr, "Leave your message here...", "Punji trap message", multiline = TRUE, encode = FALSE)

	if(added_message)
		to_chat(usr, SPAN_NOTICE("You begin carving the message inside the trap..."))
		if(do_after(usr, 10 SECONDS))
			src.message = strip_html_readd_newlines(added_message)

/obj/item/trap/punji/deployed
	deployed = TRUE
	anchored = TRUE

/**
 * # Animal trap
 *
 * Used to catch small animals like rats, lizards, and chicks
 */
/obj/item/trap/animal
	name = "small trap"
	desc = "A small mechanical trap that's used to catch small animals like rats, lizards, and chicks."
	icon_state = "small"
	throwforce = 2
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1750)
	health = 100
	can_astar_pass = CANASTARPASS_ALWAYS_PROC
	time_to_escape = 3 MINUTES
	unsecure_on_disarm = FALSE

	/// Whether someone is actively breaking out of this trap
	var/breakout = FALSE

	/// The time in deciseconds between shakes when a user is trying to escape
	var/shake_time = 5 SECONDS

	/// The world.time of when the last breakout shake callback happened successfully
	var/last_shake = 0

	/// When a mob of this size crosses over the active trap, it'll be caught
	var/max_mob_size = MOB_MINISCULE

	/// When deconstructed, it will return these materials
	var/list/resources = list(/obj/item/stack/rods = 6)

	/// A weakref to the mob currently held inside the trap
	var/datum/weakref/captured = null

/obj/item/trap/animal/get_trap_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = list()
	if(captured)
		var/mob/captured_mob = captured.resolve()
		if(captured_mob)
			. += SPAN_NOTICE("You can free the creature inside by right clicking the trap and selecting \"Release Animal\".")
	if(deployed)
		. += SPAN_NOTICE("You can disarm the trap by clicking on it, or by right clicking the trap and selecting \"Deploy / Undeploy Trap\".")
	else if(anchored)
		. += get_securing_text(secure = FALSE)
		if(!captured)
			. += SPAN_NOTICE("You can deploy the trap by clicking on it, or by right clicking the trap and selecting \"Deploy / Undeploy Trap\".")
	else
		. += get_securing_text(secure = TRUE)
	. += SPAN_NOTICE("The trap can be deconstructed with a welding tool.")

/obj/item/trap/animal/proc/get_securing_text(var/secure = TRUE)
	if(secure)
		return SPAN_NOTICE("You can secure the trap by using a screwdriver on it. This will anchor it to the floor, and ready it for deployment.")
	return SPAN_NOTICE("You can unsecure the trap by using a screwdriver on it. This will unanchor it from the floor, allowing it to be moved.")

/obj/item/trap/animal/mouse_drop_receive(atom/dropped, mob/user, params)
	var/mob/living/capturing_mob = dropped
	if(!istype(capturing_mob))
		return

	if(captured)
		to_chat(user, SPAN_WARNING("\The [src] is already full!"))
		return

	if(capturing_mob.mob_size > max_mob_size)
		to_chat(user, SPAN_WARNING("[capturing_mob] won't fit in there!"))
		return

	if(!do_mob(user, capturing_mob, 3 SECONDS, needhand = FALSE))
		return

	capture(capturing_mob)

/obj/item/trap/animal/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(!deployed || !anchored)
		return

	if(captured) // just in case but this shouldn't happen
		return

	capture(arrived)

/obj/item/trap/animal/proc/capture(var/atom/movable/movable_atom, var/msg = 1)
	if(!isliving(movable_atom))
		return

	var/mob/living/capturing_mob = movable_atom
	if(capturing_mob.mob_size > max_mob_size)
		return

	if(msg)
		capturing_mob.visible_message(SPAN_DANGER("[capturing_mob] enters \the [src], and it snaps shut with a clatter!"), SPAN_DANGER("You enter \the [src], and it snaps shut with a clatter!"), SPAN_DANGER("You hear a loud metallic snap!"))

	if(capturing_mob.loc != loc)
		capturing_mob.forceMove(loc)

	captured = WEAKREF(capturing_mob)
	INVOKE_ASYNC(src, PROC_REF(buckle), capturing_mob)
	layer = capturing_mob.layer + 0.1

	playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)

	deployed = FALSE

	shake_animation()
	update_icon()

/obj/item/trap/animal/proc/can_breakout()
	if(deployed || !captured)
		return FALSE // Trap-door is open, no one is captured.
	if(breakout)
		return FALSE //Already breaking out.
	return TRUE

/obj/item/trap/animal/proc/breakout_callback(var/mob/living/escapee)
	if (QDELETED(escapee))
		return FALSE

	if ((world.time - last_shake) > 5 SECONDS)
		playsound(loc, 'sound/effects/grillehit.ogg', 100, TRUE)
		shake_animation()
		last_shake = world.time

	return TRUE

// If we are stuck, and need to get out
/obj/item/trap/animal/user_unbuckle(var/mob/living/escapee)
	if (!can_breakout())
		return

	escapee.next_move = world.time + 1 SECOND
	escapee.last_special = world.time + 1 SECOND

	to_chat(escapee, SPAN_WARNING("You begin to shake and bump the lock of \the [src]. (this will take about [time_to_escape / 600] minutes)."))
	visible_message(SPAN_DANGER("\The [src] begins to shake violently! Something is attempting to escape it!"))

	if (!do_after(escapee, time_to_escape, src, extra_checks = CALLBACK(src, PROC_REF(breakout_callback), escapee)))
		breakout = FALSE
		return

	breakout = FALSE
	to_chat(escapee, SPAN_WARNING("You successfully break out!"))
	visible_message(SPAN_DANGER("\The [escapee] successfully breaks out of \the [src]!"))
	playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)

	release()

/obj/item/trap/animal/CollidedWith(atom/bumped_atom)
	if(deployed)
		Crossed(bumped_atom)
		return
	return ..()

/obj/item/trap/animal/verb/deploy_trap()
	set src in orange(1)
	set category = "Object"
	set name = "Deploy / Undeploy Trap"

	if(use_check_and_message(usr))
		return

	if(!can_use(usr))
		to_chat(usr, SPAN_WARNING("You cannot use \the [src]."))
		return

	if(deployed)
		if(captured)
			to_chat(usr, SPAN_WARNING("\The [src] already has something inside!"))
			return

		disarm_trap(usr)
	else
		if(!anchored)
			to_chat(usr, SPAN_WARNING("\The [src] needs to be secured first!"))
			return

		if(captured)
			to_chat(usr, SPAN_WARNING("\The [src] already has something inside!"))
			return

		deploy(usr)

/obj/item/trap/animal/verb/release_animal()
	set src in orange(1)
	set category = "Object"
	set name = "Release Animal"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))
		return

	var/mob/captured_mob = captured ? captured.resolve() : null

	if(captured_mob)
		if(tgui_alert(usr, "Do you want to open the cage and free \the [captured_mob]?", src.name, list("Yes", "No")) == "No")
			return

		if(!can_use(usr))
			to_chat(usr, SPAN_WARNING("You cannot use \the [src]."))
			return

		if(usr == captured_mob)
			to_chat(usr, SPAN_WARNING("You can't open \the [src] from the inside! You'll need to force it open."))
			return

		var/adj = src.Adjacent(usr)
		if(!adj)
			attack_self(src)
			return

		release(usr)

/obj/item/trap/animal/crush_act()
	if(captured)
		var/datum/L = captured ? captured.resolve() : null
		if(L && isliving(L))
			var/mob/living/LL = L
			LL.gib()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/item/trap/animal/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if (health <= 0)
		if(captured)
			release()
		new /obj/item/stack/material/steel(get_turf(src))
		qdel(src)

/obj/item/trap/animal/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	var/mob/living/captured_mob = captured ? captured.resolve() : null
	if(captured_mob)
		captured_mob.bullet_act(arglist(args))

/obj/item/trap/animal/proc/release(var/mob/user, var/turf/target)
	if(!target)
		target = src.loc
	if(user)
		visible_message(SPAN_NOTICE("[user] opens \the [src]."))

	var/mob/captured_mob = captured ? captured.resolve() : null
	if (!captured_mob)
		captured = null
		return

	var/msg
	if (isliving(captured_mob))
		var/mob/living/living_mob = captured_mob
		msg = SPAN_WARNING("[living_mob] runs out of \the [src].")

	unbuckle()
	captured = null
	visible_message(msg)
	shake_animation()
	update_icon()
	layer = initial(layer)

/obj/item/trap/animal/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/grab = attacking_item
		var/mob/living/capturing_mob = grab.affecting

		if (grab.state == GRAB_PASSIVE || grab.state == GRAB_UPGRADING)
			to_chat(user, SPAN_NOTICE("You need a better grip on \the [capturing_mob]!"))
			return

		user.visible_message("[SPAN_BOLD("[user]")] starts putting \the [capturing_mob] into \the [src].", SPAN_NOTICE("You start putting \the [capturing_mob] into \the [src]."))

		if(capturing_mob.mob_size > max_mob_size)
			to_chat(user, SPAN_WARNING("\The [capturing_mob] won't fit in there!"))
			return

		if (do_mob(user, capturing_mob, 3 SECONDS, needhand = FALSE))
			if(captured?.resolve())
				return
			capture(capturing_mob)

	else if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [WT] is off!"))
			return

		user.visible_message(SPAN_NOTICE("[user] is trying to slice \the [src] open!"), SPAN_NOTICE("You are trying to slice \the [src] open!"))

		if(WT.use_tool(src, user, 6 SECONDS, volume = 50))
			if(WT.use(2, user))
				user.visible_message(SPAN_NOTICE("[user] slices \the [src] open!"), SPAN_NOTICE("You slice \the [src] open!"))
				for(var/resource_path in resources)
					new resource_path(loc, resources[resource_path])
				release(user)
				qdel(src)

	else if(attacking_item.isscrewdriver())
		var/turf/T = get_turf(src)
		if(!T)
			to_chat(user, SPAN_WARNING("There is nothing to secure \the [src] to!"))
			return

		user.visible_message("[SPAN_BOLD("[user]")] starts [anchored ? "un" : "" ]securing \the [src]...", SPAN_NOTICE("You start [anchored ? "un" : "" ]securing \the [src]..."))

		if(attacking_item.use_tool(src, user, 3 SECONDS, volume = 50))
			density = !density
			anchored = !anchored
			if(!anchored)
				deployed = FALSE
			user.visible_message("[SPAN_BOLD("[user]")] [anchored ? "" : "un" ]secures \the [src]!", SPAN_NOTICE("You [anchored ? "" : "un" ]secure \the [src]!"))
			update_icon()

	else
		..()

/obj/item/trap/animal/Move()
	..()
	if(captured)
		var/datum/M = captured.resolve()
		if(isliving(M))
			var/mob/living/L = M
			if(L && buckled.buckled_to == src)
				L.forceMove(loc)
			else if(L)
				captured = null
		else
			captured = null

/obj/item/trap/animal/attack_hand(mob/user)
	if(user.loc == src || captured)
		return

	if(deployed)
		disarm_trap(user)
	else if(anchored)
		deploy(user)
	else
		..()

/obj/item/trap/animal/proc/pass_without_trace(var/mob/user, var/chance_to_trigger = 0)
	user.visible_message("[SPAN_BOLD("[user]")] tries moving around \the [src] without triggering it.", SPAN_NOTICE("You try to carefully move around \the [src] without triggering it."))
	if(do_after(user, 2 SECONDS, src))
		if(chance_to_trigger && prob(chance_to_trigger))
			user.forceMove(loc)
			user.visible_message(SPAN_WARNING("[user] accidentally triggers \the [src]!"), SPAN_WARNING("You accidentally trigger \the [src]!"))
			capture(user)
		else
			user.forceMove(loc)
			user.visible_message("[SPAN_BOLD("[user]")] successfully moves around \the [src] without triggering it.", SPAN_NOTICE("You successfully move around \the [src] without triggering it."))

/obj/item/trap/animal/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(!isliving(user) || !src.Adjacent(user))
		return

	if(captured)
		pass_without_trace(user) // It's full
		return

	else if(iscarbon(user))
		pass_without_trace(user)
		return

	return ..()

/obj/item/trap/animal/attack_self(mob/user)
	if(!can_use(user))
		to_chat(user, SPAN_WARNING("You cannot use \the [src]."))
		return

	if(captured)
		release(user, user.loc)

/obj/item/trap/animal/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!deployed)
		return

	if(captured) // It is full
		return

	if(isliving(target_mob))
		var/mob/living/capturing_mob = target_mob
		if(capturing_mob.mob_size > max_mob_size)
			to_chat(user, SPAN_WARNING("\The [capturing_mob] doesn't fit in \the [src]!"))
			return
		user.visible_message(SPAN_WARNING("[user] traps \the [capturing_mob] inside of \the [src]."), SPAN_WARNING("You trap [capturing_mob] inside of the \the [src]!"), SPAN_DANGER("You hear a loud metallic snap!"))
		capture(capturing_mob, FALSE)
	else
		..()

/obj/item/trap/animal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/item/trap/animal/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	return TRUE


/**
 * # Animal trap (Medium)
 *
 * Used to catch medium animals like cats, monkeys, nymphs, and wayward maintenance drones
 */
/obj/item/trap/animal/medium
	name = "medium trap"
	desc = "A medium mechanical trap that is used to catch moderately-sized animals like cats, monkeys, nymphs, and wayward maintenance drones."
	icon_state = "medium"
	throwforce = 4
	force = 11
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5750)

	max_mob_size = MOB_SMALL
	resources = list(/obj/item/stack/rods = 12)

/**
 * # Animal trap (Large)
 *
 * Used to catch larger animals, from spiders and dogs to bears and even larger mammals
 */
/obj/item/trap/animal/large
	name = "large trap"
	desc = "A large mechanical trap that is used to catch larger animals, from spiders and dogs to bears and even larger mammals."
	icon_state = "large"
	throwforce = 6
	force = 10
	w_class = 6
	density = TRUE
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 15750)

	max_mob_size = 20
	resources = list(/obj/item/stack/rods = 12, /obj/item/stack/material/steel = 4)

/obj/item/trap/animal/large/get_securing_text(var/secure = TRUE)
	if(secure)
		return SPAN_NOTICE("You can secure the trap by using a wrench on it. This will anchor it to the floor, and ready it for deployment.")
	return SPAN_NOTICE("You can unsecure the trap by using a wrench on it. This will unanchor it from the floor, allowing it to be moved.")

/obj/item/trap/animal/large/attack_hand(mob/user)
	if(user == buckled)
		return
	else if(!anchored)
		to_chat(user, SPAN_WARNING("You need to anchor \the [src] first!"))
	else if(captured)
		to_chat(user, SPAN_WARNING("You can't deploy \the [src] with something caught!"))
	else
		..()

/obj/item/trap/animal/large/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		var/turf/T = get_turf(src)
		if(!T)
			to_chat(user, SPAN_WARNING("There is nothing to secure \the [src] to!"))
			return

		if(anchored && deployed)
			to_chat(user, SPAN_WARNING("You can't do that while \the [src] is deployed! Undeploy it first."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins [anchored ? "un" : "" ]securing \the [src]!"),
								SPAN_NOTICE("You begin [anchored ? "un" : "" ]securing \the [src]!"))

		if(attacking_item.use_tool(src, user, 30, volume = 50))
			anchored = !anchored
			user.visible_message(SPAN_NOTICE("[user] [anchored ? "" : "un" ]secures \the [src]!"),
								SPAN_NOTICE("You [anchored ? "" : "un" ]secure \the [src]!"))

	else if(attacking_item.isscrewdriver())
		// Unlike smaller traps, screwdriver shouldn't work on this.
		return
	else
		..()

/obj/item/trap/animal/large/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(captured)
		to_chat(user, SPAN_WARNING("The trap door's down, you can't get through there!"))
		return

	if(!src.Adjacent(user))
		return

	if(!ishuman(user))
		..()
		return

	var/trigger_chance = 0
	if(user.a_intent == I_HELP)
		trigger_chance = 100
	else if(user.a_intent != I_HURT)
		trigger_chance = 50

	pass_without_trace(user, trigger_chance)

/obj/item/trap/animal/large/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(deployed)
		return TRUE

	if(mover?.movement_type & PHASING)
		return TRUE

	return FALSE

/obj/item/large_trap_foundation
	name = "large trap foundation"
	desc = "A metal foundation for large trap, it is missing metals rods to hold the prey."
	icon = 'icons/obj/item/traps/traps.dmi'
	icon_state = "large_foundation"
	throwforce = 4
	force = 11
	w_class = WEIGHT_CLASS_HUGE

/obj/item/large_trap_foundation/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("\The [src] can be turned into a large trap by attaching twelve metal rods to it.")

/obj/item/large_trap_foundation/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/rods))
		var/obj/item/stack/rods/O = attacking_item
		if(O.get_amount() >= 12)
			user.visible_message("[SPAN_BOLD("[user]")] starts adding metal bars to \the [src]...", SPAN_NOTICE("You start adding metal bars to \the [src]..."))

			if (!do_after(user, 2 SECONDS, src))
				return
			O.use(12)

			var/obj/item/trap/animal/large/new_trap = new /obj/item/trap/animal/large(src.loc)
			user.visible_message("[SPAN_BOLD("[user]")] finishes constructing \the [new_trap].", SPAN_NOTICE("You finish constructing \the [new_trap]."))

			qdel(src)
			return
		else
			to_chat(user, SPAN_WARNING("You need at least twelve rods to complete \the [src]."))
			return
	else if(istype(attacking_item, /obj/item/screwdriver))
		return
	else
		..()
