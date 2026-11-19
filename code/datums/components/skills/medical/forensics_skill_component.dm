/**
 * Action button for toggling Noir Vision at Professional Forensics skill level.
 */
/datum/action/noir_mode
	name = "Noir Vision"
	action_type = 6 // AB_CALL_SELF
	procname = "toggle_noir"
	check_flags = 8 // AB_CHECK_ALIVE
	button_icon = 'icons/hud/action_buttons/actions.dmi'
	button_icon_state = "genetic_view"
	background_icon_state = "bg_default"

/datum/action/noir_mode/proc/toggle_noir()
	var/datum/component/skill/forensics/forensics = owner?.GetComponent(FORENSICS_SKILL_COMPONENT)
	if (!forensics)
		return
	forensics.toggle_noir_mode()

/**
 * Component used for the Forensics Skill.
 * Governs evidence gathering speed and contamination risk, forensic lab equipment efficiency,
 * autopsy and mass spectrometer operation, close-up forensic examination of corpses and objects,
 * and the Noir Mode active ability at Professional level.
 */
/datum/component/skill/forensics
	/// Chance for an Unfamiliar character to botch or contaminate a sample when using forensic collection kits or swabs.
	var/unfamiliar_botch_chance = 30
	/// Action button used to toggle Noir Mode at Professional rank.
	var/datum/action/noir_mode/noir_action
	/// Whether Noir Mode is currently active.
	var/noir_active = FALSE
	/// Client images currently highlighting blood and bullet casings while Noir Mode is active.
	var/list/image/noir_images = list()

/datum/component/skill/forensics/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_MOB_EXAMINATE, PROC_REF(handle_examine), override = TRUE)
	RegisterSignal(parent, COMSIG_FORENSICS_COLLECT_SAMPLE, PROC_REF(handle_collect_sample), override = TRUE)
	RegisterSignal(parent, COMSIG_FORENSICS_USE_MICROSCOPE, PROC_REF(handle_use_microscope), override = TRUE)
	RegisterSignal(parent, COMSIG_FORENSICS_USE_DNASCANNER, PROC_REF(handle_use_dnascanner), override = TRUE)
	RegisterSignal(parent, COMSIG_FORENSICS_USE_AUTOPSY, PROC_REF(handle_use_autopsy), override = TRUE)
	RegisterSignal(parent, COMSIG_FORENSICS_USE_SPECTROMETER, PROC_REF(handle_use_spectrometer), override = TRUE)

	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		noir_action = new()
		noir_action.SetTarget(noir_action)
		noir_action.Grant(parent)
		RegisterSignal(parent, COMSIG_MOB_AFTER_LOGIN, PROC_REF(setup_action_button), override = TRUE)
		RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout), override = TRUE)

/datum/component/skill/forensics/Destroy(force)
	if (!parent)
		return ..()

	disable_noir_mode(silent = TRUE)
	UnregisterSignal(parent, COMSIG_MOB_EXAMINATE)
	UnregisterSignal(parent, COMSIG_FORENSICS_COLLECT_SAMPLE)
	UnregisterSignal(parent, COMSIG_FORENSICS_USE_MICROSCOPE)
	UnregisterSignal(parent, COMSIG_FORENSICS_USE_DNASCANNER)
	UnregisterSignal(parent, COMSIG_FORENSICS_USE_AUTOPSY)
	UnregisterSignal(parent, COMSIG_FORENSICS_USE_SPECTROMETER)
	UnregisterSignal(parent, COMSIG_MOB_AFTER_LOGIN)
	UnregisterSignal(parent, COMSIG_MOB_LOGOUT)
	noir_action?.Remove(parent)
	QDEL_NULL(noir_action)
	return ..()

/datum/component/skill/forensics/proc/setup_action_button()
	SIGNAL_HANDLER
	noir_action?.Grant(parent)
	if (noir_active)
		update_noir_highlights()

/datum/component/skill/forensics/proc/on_mob_logout()
	SIGNAL_HANDLER
	clear_noir_highlights()

/datum/component/skill/forensics/proc/toggle_noir_mode()
	if (skill_level < SKILL_LEVEL_PROFESSIONAL)
		return
	if (noir_active)
		disable_noir_mode()
	else
		enable_noir_mode()

/datum/component/skill/forensics/proc/enable_noir_mode()
	var/mob/living/user = parent
	if (!istype(user) || user.stat == DEAD)
		return

	noir_active = TRUE
	user.add_client_color(/datum/client_color/noir)
	if (noir_action)
		noir_action.background_icon_state = "bg_mime"
		noir_action.button?.update_icon()

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved), override = TRUE)
	START_PROCESSING(SSprocessing, src)
	update_noir_highlights()
	to_chat(user, SPAN_NOTICE("<i>The colors of the world fade into stark monochrome. Only the crimson of spilled blood and the brass glint of spent casings stand out in the gloom...</i>"))

/datum/component/skill/forensics/proc/disable_noir_mode(silent = FALSE)
	if (!noir_active)
		return

	noir_active = FALSE
	STOP_PROCESSING(SSprocessing, src)
	clear_noir_highlights()

	if (parent)
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
		var/mob/user = parent
		if (istype(user))
			user.remove_client_color(/datum/client_color/noir)
			if (!silent)
				to_chat(user, SPAN_NOTICE("<i>Color slowly bleeds back into your surroundings as you relax your forensic focus.</i>"))

	if (noir_action)
		noir_action.background_icon_state = "bg_default"
		noir_action.button?.update_icon()

/datum/component/skill/forensics/proc/on_parent_moved()
	SIGNAL_HANDLER
	if (noir_active)
		update_noir_highlights()

/datum/component/skill/forensics/process()
	if (!noir_active)
		return PROCESS_KILL
	var/mob/living/user = parent
	if (!istype(user) || user.stat == DEAD)
		disable_noir_mode(silent = TRUE)
		return PROCESS_KILL
	update_noir_highlights()

/datum/component/skill/forensics/proc/clear_noir_highlights()
	if (!length(noir_images))
		return
	var/mob/user = parent
	if (istype(user) && user.client)
		user.client.images -= noir_images
	noir_images.Cut()

/datum/component/skill/forensics/proc/update_noir_highlights()
	clear_noir_highlights()
	if (!noir_active)
		return

	var/mob/user = parent
	if (!istype(user) || !user.client)
		return

	var/view_range = user.client.view ? user.client.view : world.view
	for (var/turf/T in view(view_range, user))
		for (var/atom/movable/A as anything in T.contents)
			if (A.invisibility > user.see_invisible || A.alpha <= 0)
				continue

			if (istype(A, /obj/effect/decal/cleanable/blood) || istype(A, /obj/effect/rune))
				var/image/I = create_noir_highlight_image(A, "#ff1111cc")
				noir_images += I
			else if (istype(A, /obj/item/ammo_casing) || istype(A, /obj/item/ammo_pile))
				var/image/I = create_noir_highlight_image(A, "#ffcc00ee")
				noir_images += I
			else if (istype(A, /obj/item))
				var/obj/item/item = A
				if (LAZYLEN(item.blood_DNA))
					var/image/I = create_noir_highlight_image(item, "#dd1111cc")
					noir_images += I
			else if (isliving(A))
				add_mob_noir_blood_highlights(A)

	if (length(noir_images))
		user.client.images += noir_images

/datum/component/skill/forensics/proc/create_noir_highlight_image(atom/movable/A, outline_color)
	var/image/I = image(icon = A.icon, loc = A, icon_state = A.icon_state, layer = A.layer)
	I.plane = ABOVE_GAME_PLANE
	I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR | RESET_COLOR
	I.color = A.color
	if (length(A.overlays))
		I.overlays = A.overlays
	if (length(A.filters))
		I.filters = A.filters
	if (outline_color)
		I.filters += filter(type = "outline", size = 0.5, color = outline_color)
	return I

/datum/component/skill/forensics/proc/create_noir_blood_mask_image(mob/living/L, icon_file, state_name, stain_color)
	var/image/I = image(icon = icon_file, loc = L, icon_state = state_name, layer = L.layer + 0.01)
	I.plane = ABOVE_GAME_PLANE
	I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR | RESET_COLOR
	I.color = stain_color ? stain_color : COLOR_HUMAN_BLOOD
	I.filters += filter(type = "outline", size = 1, color = "#ff1111cc")
	return I

/datum/component/skill/forensics/proc/add_mob_noir_blood_highlights(mob/living/L)
	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		if (H.cloaked || !H.species?.blood_mask)
			return

		var/mask_icon = H.species.blood_mask

		// Bloody uniform
		if (H.check_draw_underclothing() && LAZYLEN(H.w_uniform.blood_DNA))
			noir_images += create_noir_blood_mask_image(H, mask_icon, "uniformblood", H.w_uniform.blood_color)

		// Bloody pants
		if (H.check_draw_pants() && LAZYLEN(H.pants.blood_DNA))
			noir_images += create_noir_blood_mask_image(H, mask_icon, "pantsblood", H.pants.blood_color)

		// Bloody hands or gloves
		if (H.check_draw_gloves())
			if (LAZYLEN(H.gloves.blood_DNA))
				noir_images += create_noir_blood_mask_image(H, mask_icon, "bloodyhands", H.gloves.blood_color)
		else if (LAZYLEN(H.blood_DNA))
			noir_images += create_noir_blood_mask_image(H, mask_icon, "bloodyhands", H.hand_blood_color)

		// Bloody shoes or bare feet
		if (H.check_draw_shoes())
			if (LAZYLEN(H.shoes.blood_DNA))
				for (var/limb_tag in list(BP_L_FOOT, BP_R_FOOT))
					var/obj/item/organ/external/E = H.get_organ(limb_tag)
					if (E && !E.is_stump())
						noir_images += create_noir_blood_mask_image(H, mask_icon, "shoeblood_[E.limb_name]", H.shoes.blood_color)
		else if (H.footprint_color)
			for (var/limb_tag in list(BP_L_FOOT, BP_R_FOOT))
				var/obj/item/organ/external/E = H.get_organ(limb_tag)
				if (E && !E.is_stump())
					noir_images += create_noir_blood_mask_image(H, mask_icon, "shoeblood_[E.limb_name]", H.footprint_color)

		// Bloody outer suit / coat / armor
		if (H.wear_suit && LAZYLEN(H.wear_suit.blood_DNA))
			var/obj/item/clothing/suit/S = H.wear_suit
			var/overlay_type = istype(S) ? S.blood_overlay_type : "suit"
			noir_images += create_noir_blood_mask_image(H, mask_icon, "[overlay_type]blood", H.wear_suit.blood_color)

		// Bloody face mask
		if (H.check_draw_mask() && LAZYLEN(H.wear_mask.blood_DNA))
			var/obj/item/clothing/mask/M = H.wear_mask
			if (!istype(M) || M.has_blood_overlay)
				noir_images += create_noir_blood_mask_image(H, mask_icon, "maskblood", H.wear_mask.blood_color)

		// Bloody headgear / helmet
		if (H.head && LAZYLEN(H.head.blood_DNA))
			noir_images += create_noir_blood_mask_image(H, mask_icon, "helmetblood", H.head.blood_color)

		// Bloody wounds / damage overlays on the character's body
		var/list/damage_overlays = H.overlays_raw[MOB_DAMAGE_LAYER]
		if (LAZYLEN(damage_overlays))
			for (var/icon/DI as anything in damage_overlays)
				var/image/I = image(icon = DI, loc = H, layer = H.layer + 0.01)
				I.plane = ABOVE_GAME_PLANE
				I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR | RESET_COLOR
				noir_images += I
		return

	if (isanimal(L))
		var/mob/living/simple_animal/SA = L
		if (SA.blood_overlay)
			var/image/I = image(icon = SA.blood_overlay.icon, loc = SA, icon_state = SA.blood_overlay.icon_state, layer = SA.layer + 0.01)
			I.plane = ABOVE_GAME_PLANE
			I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR | RESET_COLOR
			I.color = SA.blood_overlay.color
			I.filters += filter(type = "outline", size = 1, color = "#ff1111cc")
			noir_images += I

/datum/component/skill/forensics/proc/handle_examine(mob/user, atom/target, distance, is_adjacent)
	SIGNAL_HANDLER
	if (!is_adjacent || skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	// Corpse examination for time of death and apparent cause indicators
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		if (H.isSynthetic())
			return
		if ((H.stat == DEAD || (H.status_flags & FAKEDEATH)) && H.timeofdeath)
			if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
				var/list/cause_hints = list()
				if (H.getBruteLoss() > 50)
					cause_hints += "severe physical trauma"
				if (H.getFireLoss() > 50)
					cause_hints += "severe burns"
				if (H.getToxLoss() > 50)
					cause_hints += "systemic toxin or organ failure"
				if (H.getOxyLoss() > 50)
					cause_hints += "asphyxiation or oxygen deprivation"
				if ((H.should_have_organ(BP_HEART)) && H.get_blood_volume() < BLOOD_VOLUME_SURVIVE)
					cause_hints += "exsanguination"
				var/cause_text = length(cause_hints) ? " Signs point to [english_list(cause_hints)]." : ""
				to_chat(user, SPAN_NOTICE("<b>Forensic assessment:</b> Estimated time of death is <b>[worldtime2text(H.timeofdeath)]</b>.[cause_text]"))
				user.playsound_local(null, pick('sound/effects/clue1.ogg', 'sound/effects/clue2.ogg'), 50, FALSE)
			else
				var/elapsed = world.time - H.timeofdeath
				var/tod_estimate
				if (elapsed < 5 MINUTES)
					tod_estimate = "very recently (less than 5 minutes ago)"
				else if (elapsed <= 15 MINUTES)
					tod_estimate = "roughly 5 to 15 minutes ago"
				else
					tod_estimate = "over 15 minutes ago"
				to_chat(user, SPAN_NOTICE("<b>Forensic assessment:</b> Based on body cooling and lividity, [H.get_pronoun("he")] died <b>[tod_estimate]</b>."))
		return

	// Close-up object/structure inspection for forensic traces (Trained+)
	if (skill_level < SKILL_LEVEL_TRAINED || !istype(target) || isturf(target) || isarea(target))
		return

	var/list/traces = list()
	var/print_count = LAZYLEN(target.fingerprints)
	var/fiber_count = LAZYLEN(target.suit_fibers)
	var/gsr_count = 0
	if (istype(target, /obj/item/clothing))
		var/obj/item/clothing/C = target
		gsr_count = LAZYLEN(C.gunshot_residue)

	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		if (print_count)
			traces += "<b>[print_count]</b> distinct set[print_count == 1 ? "" : "s"] of fingerprints"
		if (fiber_count)
			traces += "<b>[fiber_count]</b> distinct fiber sample[fiber_count == 1 ? "" : "s"]"
		if (gsr_count)
			traces += "<b>[gsr_count]</b> caliber trace[gsr_count == 1 ? "" : "s"] of gunshot residue"
	else
		if (print_count)
			traces += "faint fingerprint smudges"
		if (fiber_count)
			traces += "snagged cloth fibers"
		if (gsr_count)
			traces += "traces of gunshot residue"

	if (length(traces))
		to_chat(user, SPAN_NOTICE("Your forensic training reveals [english_list(traces)] on \the [target]."))
		if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
			user.playsound_local(null, pick('sound/effects/clue1.ogg', 'sound/effects/clue2.ogg'), 50, FALSE)

/datum/component/skill/forensics/proc/handle_collect_sample(mob/user, atom/target, delay, preserve_evidence, reconstruct_prints, botch_sample)
	SIGNAL_HANDLER
	switch (skill_level)
		if (SKILL_LEVEL_UNFAMILIAR)
			*delay = 4 SECONDS
			if (preserve_evidence)
				*preserve_evidence = FALSE
			if (reconstruct_prints)
				*reconstruct_prints = FALSE
			if (botch_sample && prob(unfamiliar_botch_chance))
				*botch_sample = TRUE
		if (SKILL_LEVEL_FAMILIAR)
			*delay = 2.5 SECONDS
			if (preserve_evidence)
				*preserve_evidence = FALSE
			if (reconstruct_prints)
				*reconstruct_prints = FALSE
			if (botch_sample)
				*botch_sample = FALSE
		if (SKILL_LEVEL_TRAINED)
			*delay = 1.5 SECONDS
			if (preserve_evidence)
				*preserve_evidence = TRUE
			if (reconstruct_prints)
				*reconstruct_prints = FALSE
			if (botch_sample)
				*botch_sample = FALSE
		if (SKILL_LEVEL_PROFESSIONAL)
			*delay = 0.75 SECONDS
			if (preserve_evidence)
				*preserve_evidence = TRUE
			if (reconstruct_prints)
				*reconstruct_prints = TRUE
			if (botch_sample)
				*botch_sample = FALSE

/datum/component/skill/forensics/proc/handle_use_microscope(mob/user, obj/structure/machinery/microscope/microscope, cancelled, delay)
	SIGNAL_HANDLER
	if (cancelled)
		return

	switch (skill_level)
		if (SKILL_LEVEL_UNFAMILIAR)
			*cancelled = TRUE
			to_chat(user, SPAN_WARNING("You have no idea how to focus or calibrate \the [microscope]."))
		if (SKILL_LEVEL_FAMILIAR)
			*delay = 3.5 SECONDS
		if (SKILL_LEVEL_TRAINED)
			*delay = 2.5 SECONDS
		if (SKILL_LEVEL_PROFESSIONAL)
			*delay = 1 SECOND

/datum/component/skill/forensics/proc/handle_use_dnascanner(mob/user, obj/structure/machinery/dnaforensics/scanner, rate_multiplier)
	SIGNAL_HANDLER
	switch (skill_level)
		if (SKILL_LEVEL_UNFAMILIAR)
			*rate_multiplier = 0.5
		if (SKILL_LEVEL_FAMILIAR)
			*rate_multiplier = 1
		if (SKILL_LEVEL_TRAINED)
			*rate_multiplier = 1.5
		if (SKILL_LEVEL_PROFESSIONAL)
			*rate_multiplier = 2

/datum/component/skill/forensics/proc/handle_use_autopsy(mob/user, mob/living/carbon/human/target, obj/item/organ/external/limb, cancelled, require_open_limb)
	SIGNAL_HANDLER
	if (cancelled)
		return

	if (skill_level <= SKILL_LEVEL_UNFAMILIAR)
		*cancelled = TRUE
		to_chat(user, SPAN_WARNING("You don't know how to operate \the [target ? "autopsy scanner" : "scanner"] or interpret its wound readouts."))
		return

	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*require_open_limb = FALSE

/datum/component/skill/forensics/proc/handle_use_spectrometer(mob/user, obj/item/mass_spectrometer/scanner, show_details)
	SIGNAL_HANDLER
	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*show_details = TRUE

