/**
 * The base type for nearly all physical objects in SS13

 * Lots and lots of functionality lives here, although in general we are striving to move
 * as much as possible to the components/elements system
 */

/atom

	/// pass_flags that we are. If any of this matches a pass_flag on a moving thing, by default, we let them through.
	var/pass_flags_self = NONE

	///First atom flags var
	var/flags_1 = NONE
	///Intearaction flags
	var/interaction_flags_atom = NONE

	var/flags_ricochet = NONE

	///When a projectile tries to ricochet off this atom, the projectile ricochet chance is multiplied by this
	var/receive_ricochet_chance_mod = 1
	///When a projectile ricochets off this atom, it deals the normal damage * this modifier to this atom
	var/receive_ricochet_damage_coeff = 0.33

	var/update_icon_on_init	= FALSE // Default to 'no'.

	layer = TURF_LAYER
	appearance_flags = DEFAULT_APPEARANCE_FLAGS

	var/level = 2
	var/atom_flags = 0
	var/init_flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/list/other_DNA
	var/other_DNA_type = null
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = 1 // Filter for actions. Used by lighting overlays.
	var/fluorescent // Shows up under a UV light.

	var/explosion_resistance

	/// Chemistry.
	var/datum/reagents/reagents = null
	var/list/reagents_to_add
	var/list/reagent_data

	var/gfi_layer_rotation = GFI_ROTATION_DEFAULT

	/// Extra Descriptions
	/// Regular text about the atom's extended description, if any exists.
	var/desc_extended = null
	/// Blue text (SPAN_NOTICE()), informing the user about how to use the item or about game controls.
	var/desc_info = null
	/// Blue text (SPAN_NOTICE()), informing the user about how to assemble or disassemble the item.
	var/desc_build = null
	/// Blue text (SPAN_NOTICE()), informing the user about what upgrades the item has and what they do.
	/// Format desc_upgrade = "This object/item/machine/structure/etc has the following upgrades available:"
	/// Currently only supports machines, see "code\game\machinery\machinery.dm" for example.
	var/desc_upgrade = null
	/// Red text (SPAN_ALERT()), informing the user about how they can use an object to antagonize.
	var/desc_antag = null

	/* SSicon_update VARS */

	///When was the last time (in `world.time`) that the icon of this atom was updated via `SSicon_update`
	var/tmp/last_icon_update = null

	///If the atom is currently queued to have it's icon updated in `SSicon_update`
	var/tmp/icon_update_queued = FALSE

	///Delay to apply before updating the icon in `SSicon_update`
	var/icon_update_delay = null

	/// How this atom should react to having its astar blocking checked
	var/can_astar_pass = CANASTARPASS_DENSITY

	/// This atom's cache of non-protected overlays, used for normal icon additions. Do not manipulate directly- See SSoverlays.
	var/list/atom_overlay_cache

	/// This atom's cache of overlays that can only be removed explicitly, like C4. Do not manipulate directly- See SSoverlays.
	var/list/atom_protected_overlay_cache

/atom/Destroy(force)
	if(opacity)
		updateVisibility(src)

	if(reagents)
		QDEL_NULL(reagents)

	// Checking length(overlays) before cutting has significant speed benefits
	if(length(overlays))
		overlays.Cut()

	if(light)
		QDEL_NULL(light)

	if(length(light_sources))
		light_sources.Cut()

	if(smoothing_flags & SMOOTH_QUEUED)
		SSicon_smooth.remove_from_queues(src)

	//We're being destroyed, no need to update the icon
	if(icon_update_queued)
		SSicon_update.remove_from_queue(src)

	if(length(atom_overlay_cache))
		LAZYCLEARLIST(atom_overlay_cache)

	if(length(atom_protected_overlay_cache))
		LAZYCLEARLIST(atom_protected_overlay_cache)

	orbiters = null // The component is attached to us normaly and will be deleted elsewhere

	. = ..()

/atom/proc/handle_ricochet(obj/projectile/ricocheting_projectile)
	var/turf/p_turf = get_turf(ricocheting_projectile)
	var/face_direction = get_dir(src, p_turf) || get_dir(src, ricocheting_projectile)
	var/face_angle = dir2angle(face_direction)
	var/incidence_s = GET_ANGLE_OF_INCIDENCE(face_angle, (ricocheting_projectile.Angle + 180))
	var/a_incidence_s = abs(incidence_s)
	if(a_incidence_s > 90 && a_incidence_s < 270)
		return FALSE
	// if((ricocheting_projectile.armor_flag in list(BULLET, BOMB)) && ricocheting_projectile.ricochet_incidence_leeway)
	// 	if((a_incidence_s < 90 && a_incidence_s < 90 - ricocheting_projectile.ricochet_incidence_leeway) || (a_incidence_s > 270 && a_incidence_s -270 > ricocheting_projectile.ricochet_incidence_leeway))
	// 		return FALSE
	var/new_angle_s = SIMPLIFY_DEGREES(face_angle + incidence_s)
	ricocheting_projectile.set_angle(new_angle_s)
	return TRUE

///Purpose: Determines if the object (or airflow) can pass this atom.
///Called by: Movement, airflow.
///Inputs: The moving atom (optional), target turf, "height" and air group
///Outputs: Boolean if can pass.
///**Please stop using this proc, use the `pass_flags_self` flags to determine what can pass unless you literally have no other choice**
/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	//I have condensed TG's `CanAllowThrough()` into this proc
	if(mover) //Because some procs send null as a mover
		if(mover.movement_type & PHASING)
			return TRUE
		if(mover.pass_flags & pass_flags_self)
			return TRUE
		if(mover.throwing && (pass_flags_self & LETPASSTHROW))
			return TRUE

	return (!density || !height || air_group)

/**
 * An atom we are buckled or is contained within us has tried to move
 */
/atom/proc/relaymove(mob/living/user, direction)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(SEND_SIGNAL(src, COMSIG_ATOM_RELAYMOVE, user, direction) & COMSIG_BLOCK_RELAYMOVE)
		return
	return


/**
 * An atom has entered this atom's contents
 *
 * Default behaviour is to send the [COMSIG_ATOM_ENTERED]
 *
 * Aurora note: old_locs is not populated currently, and will always be null
 */
/atom/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, arrived, old_loc, old_locs)
	SEND_SIGNAL(arrived, COMSIG_ATOM_ENTERING, src, old_loc, old_locs)

	//Observables event, Aurora snowflake code
	GLOB.entered_event.raise_event(src, arrived, old_loc)

/**
 * An atom is attempting to exit this atom's contents
 *
 * Default behaviour is to send the [COMSIG_ATOM_EXIT]
 */
/atom/Exit(atom/movable/leaving, direction)
	// Don't call `..()` here, otherwise `Uncross()` gets called.
	// See the doc comment on `Uncross()` to learn why this is bad.

	if(SEND_SIGNAL(src, COMSIG_ATOM_EXIT, leaving, direction) & COMPONENT_ATOM_BLOCK_EXIT)
		return FALSE

	//Observables event, Aurora snowflake code
	GLOB.exited_event.raise_event(src, leaving, get_step_towards(src, direction))

	return TRUE

/**
 * An atom has exited this atom's contents
 *
 * Default behaviour is to send the [COMSIG_ATOM_EXITED]
 */
/atom/Exited(atom/movable/gone, direction)
	SEND_SIGNAL(src, COMSIG_ATOM_EXITED, gone, direction)

/**
 * Returns true if this atom has gravity for the passed in turf
 *
 * Sends signals [COMSIG_ATOM_HAS_GRAVITY] and [COMSIG_TURF_HAS_GRAVITY], both can force gravity with
 * the forced gravity var.
 *
 * micro-optimized to hell because this proc is very hot, being called several times per movement every movement.
 *
 * This is slightly different from TG's version due to Aurora reasons.
 */
/atom/proc/has_gravity(turf/gravity_turf)
	if(!isturf(gravity_turf))
		gravity_turf = get_turf(src)

		if(!gravity_turf)//no gravity in nullspace
			return FALSE

	var/list/forced_gravity = list()
	SEND_SIGNAL(src, COMSIG_ATOM_HAS_GRAVITY, gravity_turf, forced_gravity)
	SEND_SIGNAL(gravity_turf, COMSIG_TURF_HAS_GRAVITY, src, forced_gravity)
	if(length(forced_gravity))
		var/positive_grav = max(forced_gravity)
		var/negative_grav = min(min(forced_gravity), 0) //negative grav needs to be below or equal to 0

		//our gravity is sum of the most massive positive and negative numbers returned by the signal
		//so that adding two forced_gravity elements with an effect size of 1 each doesnt add to 2 gravity
		//but negative force gravity effects can cancel out positive ones

		return (positive_grav + negative_grav)

	var/area/turf_area = gravity_turf.loc

	return turf_area.has_gravity()

/**
 * This proc is used for telling whether something can pass by this atom in a given direction, for use by the pathfinding system.
 *
 * Trying to generate one long path across the station will call this proc on every single object on every single tile that we're seeing if we can move through, likely
 * multiple times per tile since we're likely checking if we can access said tile from multiple directions, so keep these as lightweight as possible.
 *
 * For turfs this will only be used if pathing_pass_method is TURF_PATHING_PASS_PROC
 *
 * Arguments:
 * * to_dir - What direction we're trying to move in, relevant for things like directional windows that only block movement in certain directions
 * * pass_info - Datum that stores info about the thing that's trying to pass us
 *
 * IMPORTANT NOTE: /turf/proc/LinkBlockedWithAccess assumes that overrides of CanAStarPass will always return true if density is FALSE
 * If this is NOT you, ensure you edit your can_astar_pass variable. Check __DEFINES/path.dm
 **/
/atom/proc/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(pass_info.pass_flags & pass_flags_self)
		return TRUE
	. = !density

/// Adds the client to hovers.
/atom/MouseEntered(location, control, params)
	SSmouse_entered.hovers[usr.client] = src

/// Fired whenever this atom is the most recent to be hovered over in the tick.
/// Preferred over MouseEntered if you do not need information such as the position of the mouse.
/// Especially because this is deferred over a tick, do not trust that `client` is not null.
/atom/proc/on_mouse_enter(client/client)
	SHOULD_NOT_SLEEP(TRUE)

	var/mob/user = client?.mob
	LOG_DEBUG("<b>on_mouse_enter user is [user]</b>")
	if (isnull(user))
		return

	SEND_SIGNAL(user, COMSIG_ATOM_MOUSE_ENTERED, src)

	// Screentips
	var/datum/hud/active_hud = user.hud_used
	LOG_DEBUG("active hud: [active_hud]")
	if(!active_hud)
		return

	var/lmb_rmb_line = ""
	var/ctrl_lmb_ctrl_rmb_line = ""
	var/alt_lmb_alt_rmb_line = ""
	var/shift_lmb_ctrl_shift_lmb_line = ""
	var/extra_lines = 0
	var/extra_context = ""
	var/used_name = name

	if(isliving(user) || isEye(user) || (isghost(user) && isstoryteller(user)))
		var/obj/item/held_item = user.get_active_hand()

		/*
		if (MOB_HAS_SCREENTIPS_NAME_OVERRIDE)
			var/list/returned_name = list(used_name)

			var/name_override_returns = SEND_SIGNAL(user, COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, returned_name, held_item, src)
			if (name_override_returns & SCREENTIP_NAME_SET)
				used_name = returned_name[1]
		*/
		if (flags_1 & HAS_CONTEXTUAL_SCREENTIPS_1 || held_item?.item_flags & ITEM_HAS_CONTEXTUAL_SCREENTIPS)
			LOG_DEBUG("detected contextual screentips")
			var/list/context = list()

			var/contextual_screentip_returns = \
				SEND_SIGNAL(src, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, context, held_item, user) \
				| (held_item && SEND_SIGNAL(held_item, COMSIG_ITEM_REQUESTING_CONTEXT_FOR_TARGET, context, src, user))

			if (contextual_screentip_returns & CONTEXTUAL_SCREENTIP_SET)
				var/screentip_images = active_hud.screentip_images
				// LMB and RMB on one line...
				var/lmb_text = build_context(context, SCREENTIP_CONTEXT_LMB, screentip_images)
				var/rmb_text = build_context(context, SCREENTIP_CONTEXT_RMB, screentip_images)

				if (lmb_text != "")
					lmb_rmb_line = lmb_text
					if (rmb_text != "")
						lmb_rmb_line += " | [rmb_text]"
				else if (rmb_text != "")
					lmb_rmb_line = rmb_text

				// Ctrl-LMB, Ctrl-RMB on one line...
				if (lmb_rmb_line != "")
					lmb_rmb_line += "<br>"
					extra_lines++
				if (SCREENTIP_CONTEXT_CTRL_LMB in context)
					ctrl_lmb_ctrl_rmb_line += build_context(context, SCREENTIP_CONTEXT_CTRL_LMB, screentip_images)

				if (SCREENTIP_CONTEXT_CTRL_RMB in context)
					if (ctrl_lmb_ctrl_rmb_line != "")
						ctrl_lmb_ctrl_rmb_line += " | "
					ctrl_lmb_ctrl_rmb_line += build_context(context, SCREENTIP_CONTEXT_CTRL_RMB, screentip_images)

				// Alt-LMB, Alt-RMB on one line...
				if (ctrl_lmb_ctrl_rmb_line != "")
					ctrl_lmb_ctrl_rmb_line += "<br>"
					extra_lines++
				if (SCREENTIP_CONTEXT_ALT_LMB in context)
					alt_lmb_alt_rmb_line += build_context(context, SCREENTIP_CONTEXT_ALT_LMB, screentip_images)
				if (SCREENTIP_CONTEXT_ALT_RMB in context)
					if (alt_lmb_alt_rmb_line != "")
						alt_lmb_alt_rmb_line += " | "
					alt_lmb_alt_rmb_line += build_context(context, SCREENTIP_CONTEXT_ALT_RMB, screentip_images)

				// Shift-LMB, Ctrl-Shift-LMB on one line...
				if (alt_lmb_alt_rmb_line != "")
					alt_lmb_alt_rmb_line += "<br>"
					extra_lines++
				if (SCREENTIP_CONTEXT_SHIFT_LMB in context)
					shift_lmb_ctrl_shift_lmb_line += build_context(context, SCREENTIP_CONTEXT_SHIFT_LMB, screentip_images)
				if (SCREENTIP_CONTEXT_CTRL_SHIFT_LMB in context)
					if (shift_lmb_ctrl_shift_lmb_line != "")
						shift_lmb_ctrl_shift_lmb_line += " | "
					shift_lmb_ctrl_shift_lmb_line += build_context(context, SCREENTIP_CONTEXT_CTRL_SHIFT_LMB, screentip_images)

				if (shift_lmb_ctrl_shift_lmb_line != "")
					extra_lines++

				if(extra_lines)
					extra_context = "<br><span class='subcontext'>[lmb_rmb_line][ctrl_lmb_ctrl_rmb_line][alt_lmb_alt_rmb_line][shift_lmb_ctrl_shift_lmb_line]</span>"

	var/new_maptext

	LOG_DEBUG("extra content [extra_context]")
	if (extra_context == "")
		new_maptext = ""
	else
		//We inline a MAPTEXT() here, because there's no good way to statically add to a string like this
		new_maptext += "<span class='context' style='text-align: center; color: [active_hud.screentip_color]'>[used_name][extra_context]</span>"
		LOG_DEBUG("<b>new maptext:</b> [new_maptext]")
/*
	if (length(used_name) * 10 > active_hud.screentip_text.maptext_width)
		INVOKE_ASYNC(src, PROC_REF(set_hover_maptext), client, active_hud, new_maptext)
		return
*/
	active_hud.screentip_text.maptext = "TEST"
	active_hud.screentip_text.screen_loc = "LEFT,TOP-3"
	active_hud.screentip_text.maptext_y = 10 - (extra_lines > 0 ? 11 + 9 * (extra_lines - 1): 0)
	active_hud.screentip_text.maptext_x = 0 - (extra_lines > 0 ? 11 + 9 * (extra_lines - 1): 0)

/*
/atom/proc/set_hover_maptext(client/client, datum/hud/active_hud, new_maptext)
	var/map_height
	WXH_TO_HEIGHT(client.MeasureText(new_maptext, null, active_hud.screentip_text.maptext_width), map_height)
	active_hud.screentip_text.maptext = new_maptext
	active_hud.screentip_text.maptext_y = 26 - map_height
*/
////////////////////////////////////////////////////////////////
/*
	var/msg = tgui_input_text(usr, "Insert the screen message you want to send.", "Local Screen Text")
	if(!msg)
		return

	var/big_text = tgui_alert(src, "Do you want big or normal text?", "Local Screen Text", list("Big", "Normal"))
	var/text_type = /atom/movable/screen/text/screen_text
	if(big_text == "Big")
		text_type = /atom/movable/screen/text/screen_text/command_order

	for(var/mob/M in message_mobs)
		if(M.client)
			M.play_screen_text(msg,text_type, COLOR_RED)
	log_admin("LocalScreenText: [key_name(usr)] : [msg]")
	message_admins(SPAN_NOTICE("Local Screen Text: [key_name_admin(usr)] : [msg]"), 1)
	feedback_add_details("admin_verb", "LSTX") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	*/
