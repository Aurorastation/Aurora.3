/obj/machinery/stasis_bed
	name = "lifeform stasis unit"
	desc = "A not so comfortable looking bed with some nozzles at the top and bottom. It will keep someone in stasis."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "stasis"
	anchored = TRUE

	buckle_lying = TRUE
	can_buckle = list(/mob/living/carbon/human)

	idle_power_usage = 40
	active_power_usage = 340

	var/mob/living/carbon/human/occupant

	var/stasis_enabled = FALSE
	var/chilled_occupant = FALSE
	var/last_stasis_sound = FALSE
	var/stasis_can_toggle = 0

	/// The amount of Stasis Value that this machine provides to an occupant.
	var/stasis_power = 10

	/**
	 * The type of stasis this machine provides to an occupant.
	 * Two identical stasis source names do not stack.
	 */
	var/stasis_source_name = "Stasis Bed"

	component_types = list(
		/obj/item/circuitboard/stasis_bed,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/console_screen
	)

/obj/machinery/stasis_bed/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can alt-click this to toggle it on or off."
	. += "Applies a [stasis_power]x stasis effect to any living creature buckled to an active stasis unit."
	. += "This causes effects such as bleeding and brain damage to accumulate [stasis_power]x slower."

/obj/machinery/stasis_bed/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>scanning modules</b> increase the unit's stasis strength."
	. += "Upgraded <b>capacitors</b> increase the unit's stasis strength."

/obj/machinery/stasis_bed/Initialize(mapload, d, populate_components)
	. = ..()
	update_icon()

/obj/machinery/stasis_bed/attackby(obj/item/attacking_item, mob/user)
	if(default_part_replacement(user, attacking_item))
		return TRUE
	else if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	else if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	return ..()

/obj/machinery/stasis_bed/RefreshParts()
	..()
	var/scanner_rating = 0
	var/capacitor_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(isscanner(P))
			scan_rating += P.rating
		else if (iscapacitor(P))
			capacitor_rating += P.rating

	 stasis_power = initial(stasis_power) * scanner_rating * capacitor_rating / 4

/obj/machinery/stasis_bed/proc/play_power_sound()
	var/_running = stasis_running()
	if(last_stasis_sound != _running)
		var/sound_freq = rand(5120, 8800)
		if(_running)
			playsound(src, 'sound/machines/synth_yes.ogg', 50, TRUE, frequency = sound_freq)
		else
			playsound(src, 'sound/machines/synth_no.ogg', 50, TRUE, frequency = sound_freq)
		last_stasis_sound = _running

/obj/machinery/stasis_bed/AltClick(mob/user)
	if((world.time >= stasis_can_toggle) && !use_check_and_message(user) && !(stat & (NOPOWER|BROKEN)))
		stasis_enabled = !stasis_enabled
		stasis_can_toggle = world.time + 5 SECONDS
		playsound(src, 'sound/machines/click.ogg', 60, TRUE)
		user.visible_message(SPAN_NOTICE("\The [src] [stasis_enabled ? "powers on" : "shuts down"]."), \
					SPAN_NOTICE("You [stasis_enabled ? "power on" : "shut down"] \the [src]."), \
					SPAN_NOTICE("You hear a nearby machine [stasis_enabled ? "power on" : "shut down"]."))
		play_power_sound()
		update_icon()

/obj/machinery/stasis_bed/Exited(atom/movable/AM, atom/newloc)
	if(AM == occupant)
		var/mob/living/L = AM
		thaw_occupant(L)
	. = ..()

/obj/machinery/stasis_bed/proc/stasis_running()
	return stasis_enabled && !(stat & (NOPOWER|BROKEN))

/obj/machinery/stasis_bed/update_icon()
	ClearOverlays()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]_broken"
		return ..()
	icon_state = initial(icon_state)
	if(panel_open || (stat & MAINT))
		AddOverlays("stasis_maintenance")
	if(stasis_running())
		AddOverlays("stasis_on")

/obj/machinery/stasis_bed/power_change()
	. = ..()
	play_power_sound()

/obj/machinery/stasis_bed/proc/chill_occupant(mob/living/target)
	if(target != occupant)
		return
	if(!stasis_running())
		return

	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 2, frequency = rand(24750, 26550))
	target.ExtinguishMobCompletely()
	update_use_power(POWER_USE_ACTIVE)
	chilled_occupant = TRUE

/obj/machinery/stasis_bed/proc/thaw_occupant(mob/living/target)
	if(target != occupant)
		return

	update_use_power(POWER_USE_IDLE)
	occupant = null
	chilled_occupant = FALSE

/obj/machinery/stasis_bed/post_buckle(mob/living/carbon/human/H)
	if(H.buckled_to == src)
		occupant = H
		if(stasis_running())
			chill_occupant(H)
	else
		thaw_occupant(H)
	update_icon()

/obj/machinery/stasis_bed/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!occupant)
		update_use_power(POWER_USE_IDLE)
		return

	if(!chilled_occupant)
		chill_occupant(occupant)

	occupant.SetStasis(stasis_power, stasis_source_name)
