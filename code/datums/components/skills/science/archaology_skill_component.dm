/datum/action/trapfinding
	name = "Survey for Traps"
	action_type = 6
	procname = "survey_traps"
	button_icon = 'icons/hud/action_buttons/organs.dmi'
	button_icon_state = "hunterseye"
	/// Last world.time the ability was triggered.
	var/last_use = 0
	/// Base cooldown between surveys.
	var/cooldown = 6 SECONDS
	/// List of active client highlight images currently displayed to the owner.
	var/list/image/active_highlights = list()
	/// Timer ID for clearing active highlights.
	var/clear_timer_id = null

/datum/action/trapfinding/Destroy()
	clear_highlights()
	return ..()

/datum/action/trapfinding/proc/clear_highlights()
	if(clear_timer_id)
		deltimer(clear_timer_id)
		clear_timer_id = null
	if(owner?.client && length(active_highlights))
		owner.client.images -= active_highlights
	active_highlights.Cut()

/datum/action/trapfinding/proc/create_trap_highlight(atom/trap_atom, turf/trap_turf, icon/custom_icon, custom_icon_state)
	var/image/highlight = image(custom_icon ? custom_icon : trap_atom.icon, trap_turf, custom_icon_state ? custom_icon_state : trap_atom.icon_state, UNDER_HUD_LAYER, trap_atom.dir)
	highlight.plane = HUD_PLANE
	highlight.appearance_flags = KEEP_APART | RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	highlight.color = "#ff3333"
	highlight.alpha = 215
	highlight.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/image/ping = image('icons/obj/item/scanner.dmi', trap_turf, "signal_overlay", UNDER_HUD_LAYER)
	ping.plane = HUD_PLANE
	ping.appearance_flags = KEEP_APART | RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	ping.color = "#ff3333"
	ping.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	highlight.overlays += ping
	return highlight

/datum/action/trapfinding/proc/survey_traps()
	if(!owner || !owner.client)
		return
	if(owner.stat || owner.stunned || owner.incapacitated() || owner.blinded)
		to_chat(owner, SPAN_WARNING("You are in no condition to survey the area for traps."))
		return

	var/arch_skill = GET_SKILL_LEVEL(owner, ARCHAOLOGY_SKILL_COMPONENT)
	if(arch_skill < SKILL_LEVEL_TRAINED)
		return

	var/effective_cooldown = (arch_skill >= SKILL_LEVEL_PROFESSIONAL) ? 4 SECONDS : cooldown
	if(last_use && (world.time < last_use + effective_cooldown))
		to_chat(owner, SPAN_WARNING("You need a moment to refocus before surveying the terrain again."))
		return

	last_use = world.time
	clear_highlights()

	var/scan_range = (arch_skill >= SKILL_LEVEL_PROFESSIONAL) ? world.view : 5
	var/highlight_duration = (arch_skill >= SKILL_LEVEL_PROFESSIONAL) ? 12 SECONDS : 8 SECONDS
	var/list/found_names = list()
	var/revealed_hidden = 0

	for(var/turf/T in view(scan_range, owner))
		for(var/atom/A in T.contents)
			if(istype(A, /obj/item/landmine))
				var/obj/item/landmine/M = A
				if(!M.deployed && !istype(M, /obj/item/landmine/frag/door_rigging))
					continue
				if(M.deactivated)
					continue
				if(M.layer == ABOVE_TILE_LAYER)
					M.layer = initial(M.layer)
					revealed_hidden++
				active_highlights += create_trap_highlight(M, T)
				found_names += M.name

			else if(istype(A, /obj/structure/pit))
				var/obj/structure/pit/P = A
				var/obj/item/landmine/buried_mine = locate(/obj/item/landmine) in P.contents
				if(buried_mine && !P.open)
					if(P.invisibility > 0)
						P.set_invisibility(0)
						revealed_hidden++
					active_highlights += create_trap_highlight(buried_mine, T, 'icons/obj/item/landmine/mine.dmi', "landmine_on")
					found_names += "buried [buried_mine.name]"

			else if(istype(A, /obj/item/trap))
				var/obj/item/trap/TR = A
				if(!TR.deployed && !istype(TR, /obj/item/trap/jagged_rock))
					continue
				if(TR.invisibility > 0)
					TR.invisibility = 0
					revealed_hidden++
				active_highlights += create_trap_highlight(TR, T)
				found_names += TR.name

			else if(istype(A, /obj/structure/sarcophagus))
				var/obj/structure/sarcophagus/S = A
				if(S.booby_trapped && !S.open)
					active_highlights += create_trap_highlight(S, T)
					found_names += "booby-trapped [S.name]"

	if(length(active_highlights))
		owner.client.images += active_highlights
		clear_timer_id = addtimer(CALLBACK(src, PROC_REF(clear_highlights)), highlight_duration, TIMER_UNIQUE | TIMER_STOPPABLE)
		var/reveal_msg = revealed_hidden ? " and uncover [revealed_hidden] camouflaged trap\s" : ""
		if(arch_skill >= SKILL_LEVEL_PROFESSIONAL)
			to_chat(owner, SPAN_WARNING("Your expert survey picks out [length(active_highlights)] hazard\s nearby[reveal_msg]: [english_list(found_names)]."))
		else
			to_chat(owner, SPAN_WARNING("Your trained eyes pick out [length(active_highlights)] hazard\s in the surrounding area[reveal_msg]!"))
	else
		to_chat(owner, SPAN_NOTICE("You carefully scan the surrounding terrain and spot no concealed traps or mines."))

/**
 * Component used for the Xenoarchaeology skill.
 * Governs excavation speed and safety, geological intuition when mining,
 * xenoarchaeological instrument and lab machine efficiency, relic/anomaly handling, and trapfinding.
 */
/datum/component/skill/archaology
	/// Action button granted at Trained+ for surveying and highlighting nearby traps.
	var/datum/action/trapfinding/trapfinding_action

/datum/component/skill/archaology/Initialize(level)
	. = ..()
	if(!parent)
		return

	if(skill_level >= SKILL_LEVEL_TRAINED)
		trapfinding_action = new /datum/action/trapfinding()
		trapfinding_action.SetTarget(trapfinding_action)
		trapfinding_action.Grant(parent)
		RegisterSignal(parent, COMSIG_MOB_AFTER_LOGIN, PROC_REF(setup_action_button), override = TRUE)

/datum/component/skill/archaology/Destroy(force)
	if(!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_MOB_AFTER_LOGIN)
	trapfinding_action?.Remove(parent)
	QDEL_NULL(trapfinding_action)
	return ..()

/datum/component/skill/archaology/proc/setup_action_button()
	astype(parent, /mob)?.update_action_buttons()

/**
 * Returns the digging/measuring time multiplier for a mob based on their Xenoarchaeology skill.
 */
/proc/get_xenoarch_dig_multiplier(mob/user)
	if(!user)
		return 1
	switch(GET_SKILL_LEVEL(user, ARCHAOLOGY_SKILL_COMPONENT))
		if(SKILL_LEVEL_FAMILIAR)
			return 0.85
		if(SKILL_LEVEL_TRAINED)
			return 0.7
		if(SKILL_LEVEL_PROFESSIONAL)
			return 0.5
	return 1

/**
 * Checks whether a living mob's Xenoarchaeology trapfinding instincts allow them to spot and avoid
 * stepping on a floor trap or landmine at the last moment.
 */
/proc/try_xenoarch_trap_evasion(mob/living/L, atom/trap, reveal_trap = FALSE)
	if(!istype(L) || L.lying || L.stat)
		return FALSE
	var/arch_skill = GET_SKILL_LEVEL(L, ARCHAOLOGY_SKILL_COMPONENT)
	if(arch_skill <= SKILL_LEVEL_UNFAMILIAR)
		return FALSE

	var/evade_chance = 0
	if(L.m_intent == M_WALK)
		switch(arch_skill)
			if(SKILL_LEVEL_FAMILIAR)
				evade_chance = 25
			if(SKILL_LEVEL_TRAINED)
				evade_chance = 60
			if(SKILL_LEVEL_PROFESSIONAL)
				evade_chance = 90
	else
		switch(arch_skill)
			if(SKILL_LEVEL_TRAINED)
				evade_chance = 25
			if(SKILL_LEVEL_PROFESSIONAL)
				evade_chance = 50

	if(evade_chance && prob(evade_chance))
		if(reveal_trap && trap.invisibility > 0)
			trap.invisibility = 0
		if(istype(trap, /obj/item/landmine) && trap.layer == ABOVE_TILE_LAYER)
			trap.layer = initial(trap.layer)
		to_chat(L, SPAN_WARNING("You spot \the [trap] beneath your feet at the last second and avoid triggering it!"))
		return TRUE
	return FALSE


