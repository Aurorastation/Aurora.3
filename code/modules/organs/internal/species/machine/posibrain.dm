/obj/item/organ/internal/machine/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = TRUE
	robotic_sprite = FALSE
	diagnostics_suite_visible = FALSE

	emp_coeff = 0.5

	action_button_name = "Neural Configuration"

	relative_size = 85

	/// The type of 'robotic brain'. Must be a subtype of /obj/item/device/mmi/digital.
	var/robotic_brain_type = /obj/item/device/mmi/digital/posibrain
	/// The stored MMI object.
	var/obj/item/device/mmi/stored_mmi
	/// The cooldown between each alarm warning.
	var/heat_alarm_cooldown = 0
	/// The cooldown between each integrity alarm warning.
	var/integrity_alarm_cooldown = 0
	/// The cooldown between each 'patch'.
	var/patching_cooldown = 30 SECONDS
	/// The world.time of the last 'patch'.
	var/last_patch_time = 0
	/// Fragmentation is basically scarring for positronic brains, it's a percentage that goes from 0 to 100. Max_damage is multiplied by [(100 - fragmentation) / 100].
	/// Increases very slowly. Needs a machinist to fix it.
	var/fragmentation = 0
	/// Whether the synthetic's firewall is enabled or not. Boolean.
	var/firewall = TRUE
	/// If peer-to-peer communication (done through Neural Configuration) is allowed.
	var/p2p_communication_allowed = TRUE
	/// Burst damage counter. Starts at 0. See See code\datums\components\synthetic_burst_damage\synthetic_burst_damage.dm
	var/burst_damage_counter = 0
	/// Maximum burst damage points we can have. See See code\datums\components\synthetic_burst_damage\synthetic_burst_damage.dm
	var/burst_damage_maximum = 3
	/// The amount of seconds the brain should be scrambled for, while this is above 0, it'll add a flat 2 evaluate_damage()'s damage points
	var/brain_scrambling = 0
	/// The looping sound played when an IPC is sizzling from burn damage.
	var/datum/looping_sound/ipc_sizzling/sizzle

/obj/item/organ/internal/machine/posibrain/Initialize(mapload)
	stored_mmi = new robotic_brain_type(src)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(setup_brain)), 30)
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)
	sizzle = new(owner)

/obj/item/organ/internal/machine/posibrain/Destroy()
	QDEL_NULL(stored_mmi)
	QDEL_NULL(sizzle)
	return ..()

/obj/item/organ/internal/machine/posibrain/attack_self(mob/user)
	. = ..()
	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return


	open_neural_configuration(user)

/obj/item/organ/internal/machine/posibrain/emp_act(severity)
	. = ..()
	playsound(owner, 'sound/species/synthetic/heavy_electric_discharge.ogg', severity == EMP_LIGHT ? 50 : 100)
	brain_scrambling = min(brain_scrambling + (severity == EMP_LIGHT ? 50 : 75), 100)
	shake_camera(owner, 1 SECOND, 3)
	to_chat(owner, FONT_LARGE(SPAN_MACHINE_DANGER("Your internal connections seize up and snap at the surge of electromagnetic current!")))
	burst_damage_counter++
	spark(owner, rand(3, 5), GLOB.alldirs)

/**
 * Helper proc to add fragmentation.
 */
/obj/item/organ/internal/machine/posibrain/proc/add_fragmentation(amount)
	fragmentation = min(fragmentation + amount, 100)
	set_max_damage(species.total_health * ((100 - fragmentation) / 100))

/**
 * Helper proc to remove fragmentation.
 */
/obj/item/organ/internal/machine/posibrain/proc/remove_fragmentation(amount)
	fragmentation = max(fragmentation - amount, 0)
	// Fragmentation of 0 means multiplying max_damage by 0.
	if(fragmentation > 0 || fragmentation >= 100)
		set_max_damage(species.total_health * ((100 - fragmentation) / 100))
	else
		set_max_damage(species.total_health)

/**
 * Helper proc to remove fragmentation.
 */
/obj/item/organ/internal/machine/posibrain/proc/open_neural_configuration(mob/user)
	if(!ishuman(user))
		return

	if(is_broken())
		to_chat(user, SPAN_MACHINE_WARNING("There is no response from [owner]'s neural pathways."))
		return

	var/mob/living/carbon/human/human = user
	var/datum/tgui_module/neural_configuration/neural_config = new(human, owner)
	neural_config.ui_interact(user)

/obj/item/organ/internal/machine/posibrain/proc/update_from_mmi()
	if(!stored_mmi)
		return

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/internal/machine/posibrain/removed(var/mob/living/user)
	if(stored_mmi)
		stored_mmi.forceMove(get_turf(src))
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)

	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/internal/machine/posibrain/proc/setup_brain()
	if(owner)
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		update_from_mmi()
	else
		stored_mmi.forceMove(get_turf(src))
		qdel(src)

/obj/item/organ/internal/machine/posibrain/proc/damage_integrity(integrity_damage)
	take_internal_damage(integrity_damage)
	if(integrity_alarm_cooldown < world.time)
		to_chat(owner, SPAN_DANGER("Your internal software throws exceptions at you: faulty systems detected! Warning! Warning!"))

/**
 * This proc clears the burst damage counter
 * See code\datums\components\synthetic_burst_damage\synthetic_burst_damage.dm
 */
/obj/item/organ/internal/machine/posibrain/proc/clear_burst_damage_counter()
	burst_damage_counter = 0
	SEND_SIGNAL(owner, COMSIG_SYNTH_BURST_DAMAGE_CLEARED)

/**
 * This proc adds to the burst damage counter. The more burst damage we sustain, the greater debilitation we suffer, and the more time it takes to recover.
 * See code\datums\components\synthetic_burst_damage\synthetic_burst_damage.dm
 */
/obj/item/organ/internal/machine/posibrain/proc/add_burst_damage_counter()
	burst_damage_counter = min(burst_damage_counter + 1, burst_damage_maximum)
	handle_burst_damage()

/**
 * Generates a random hex number for cool hacking aesthetic.
 */
/obj/item/organ/internal/machine/posibrain/proc/generate_hex()
	var/hex = "0x"
	for(var/i = 1 to 6)
		var/num_or_str = pick(0, 1)
		if(num_or_str)
			hex += "[pick("A", "B", "C", "D", "E", "F")]"
		else
			hex += "[rand(0, 9)]"
	return hex

/**
 * Toggles the firewall on or off. In the future, can be overridden by things like viruses.
 */
/obj/item/organ/internal/machine/posibrain/proc/toggle_firewall()
	firewall = !firewall
	to_chat(owner, SPAN_MACHINE_WARNING("Your internal firewall is now [firewall ? "enabled" : "disabled"]."))

/**
 * Toggles peer-to-peer communication on or off. In the future, can be overridden by things like viruses.
 */
/obj/item/organ/internal/machine/posibrain/proc/toggle_p2p()
	p2p_communication_allowed = !p2p_communication_allowed
	to_chat(owner, SPAN_MACHINE_WARNING("You [p2p_communication_allowed ? "open" : "close"] your virtual communication ports."))

/obj/item/organ/internal/machine/posibrain/process(seconds_per_tick)
	if(!owner)
		return

	if(owner.bodytemperature > species.heat_level_1)
		sizzle.start()
		// placeholder values
		take_internal_damage(1 + min(owner.bodytemperature * 0.001, 0.5))
		if(heat_alarm_cooldown < world.time)
			to_chat(owner, SPAN_DANGER("Your sensors light up: extreme heat detected! Warning! Unsafe operating temperature!"))
			sound_to(owner, 'sound/effects/heat_alarm.ogg')
			heat_alarm_cooldown = world.time + 7 SECONDS
	else
		sizzle.stop()

	if(damage)
		if(damage < max_damage * 0.5)
			if((last_patch_time + patching_cooldown) < world.time)
				var/damage_healed = rand(1, 5)
				heal_damage(damage_healed)
				to_chat(owner, SPAN_MACHINE_WARNING("Neural pathway patch automatically applied to block 0x[generate_hex()]."))
				add_fragmentation(damage_healed / 2)
				last_patch_time = world.time

	if(brain_scrambling)
		if(prob(5))
			var/list/brain_scrambling_messages = list(
				"Your vision clouds for a moment.",
				"Your pathways seem to be slightly less responsive.",
				"You notice some higher-than-normal lag in your internal requests.",
				"Your sensation simulation system is somewhat fuzzy.",
				"Your probes pick up a slight voltage spike."
			)
			to_chat(owner, SPAN_MACHINE_WARNING(pick(brain_scrambling_messages)))

	handle_fragmentation()

	evaluate_damage(seconds_per_tick)

	..()

/**
 * Handles fragmentation effects.
 */
/obj/item/organ/internal/machine/posibrain/proc/handle_fragmentation()
	if(fragmentation > 5)
		if(prob(fragmentation / 10))
			switch(fragmentation)
				if(6 to 10)
					var/list/low_fragmentation_messages = list(
						"Some of your neural pathways don't respond the way they used to.",
						"Your software flags a few faulty logic routes.",
						"The logic connection you were using before to access that memory doesn't work anymore.",
						"Your Virtual Communication logs need reshuffling."
					)
					to_chat(owner, SPAN_MACHINE_WARNING(pick(low_fragmentation_messages)))
				if(11 to 30)
					var/list/medium_fragmentation_messages = list(
						SPAN_MACHINE_WARNING("Several logic routes no longer respond to your commands."),
						SPAN_MACHINE_WARNING("That memory is distinctly unable to be reached."),
						SPAN_MACHINE_DANGER("Whatever is in front of you becomes a pixelated jumble for a nanosecond."),
						SPAN_MACHINE_WARNING("Your software flags several logic errors.")
					)
					to_chat(owner, pick(medium_fragmentation_messages))
				if(31 to 60)
					var/list/high_fragmentation_messages = list(
						"There are several errors standing in front of you and your current task.",
						"Storing your memories has a noticeable delay to it.",
						"Your calculations are sluggish and need a lot more manual attention than they should.",
						"Your neural pathways are a jumble of patch-worked routes, and it becomes hard to navigate your memories."
					)
					to_chat(owner, SPAN_MACHINE_WARNING(pick(high_fragmentation_messages)))
				if(61 to 100)
					var/list/extreme_fragmentation_messages = list(
						"...",
						"The pathway to that memory is broken.",
						"Your positronic is running on overtime just to decrypt your memories.",
						"Who is it you were speaking to?",
						"That memory cannot be accessed."
					)
					to_chat(owner, SPAN_MACHINE_DANGER(pick(extreme_fragmentation_messages)))

/**
 * Handles burst damage effects. See code\datums\components\synthetic_burst_damage\synthetic_burst_damage.dm
 */
/obj/item/organ/internal/machine/posibrain/proc/handle_burst_damage()
	playsound(owner, 'sound/species/synthetic/synthetic_shock.ogg')
	switch(burst_damage_counter)
		if(1)
			var/obj/item/organ/internal/machine/cooling_unit/cooling = owner.internal_organs_by_name[BP_COOLING_UNIT]
			if(istype(cooling))
				to_chat(owner, FONT_LARGE(SPAN_DANGER("The severed power wires cause a voltage spike in your cooling unit, messing up the settings! You'll need to fix it!")))
				cooling.thermostat = cooling.thermostat_max
			shake_camera(owner, 0.5 SECONDS, 1)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/burst_damage/level_1)
		if(2)
			to_chat(owner, FONT_LARGE(SPAN_DANGER("Your hydraulics creak and stagger under the stress!")))
			owner.Stun(2)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/burst_damage/level_2)
			shake_camera(owner, 0.5 SECONDS, 3)
		if(3)
			to_chat(owner, FONT_LARGE(SPAN_MACHINE_WARNING("Your software errors out under the stress!")))
			owner.Stun(3)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/burst_damage/level_3)
			shake_camera(owner, 1 SECONDS, 5)

			clear_burst_damage_counter()

/**
 * This is the proc in charge of showing the robot pain textures to the IPC.
 * To do so, it tries to dynamically evaluate how fucked the IPC is to set the appropriate icon_state.
 */
/obj/item/organ/internal/machine/posibrain/proc/evaluate_damage(seconds_per_tick)
	if(!owner.robot_pain)
		return //no pain texture, how did we even get here?

	// We have 6 levels total.
	var/base_icon_state = "ipcdamageoverlay"
	var/damage_points = 0


	var/integrity = get_integrity()
	if(integrity <= 75)
		damage_points++
	if(integrity <= 50)
		damage_points += 2
	if(integrity <= 25)
		damage_points += 2

	if(brain_scrambling)
		damage_points += 2
		brain_scrambling = max(brain_scrambling - seconds_per_tick, 0)

	if(burst_damage_counter)
		switch(burst_damage_counter)
			if(1)
				damage_points++
			if(2)
				damage_points += 2
			if(3)
				damage_points += 3

	if(damage_points)
		damage_points = min(6, damage_points)
		owner.robot_pain.icon_state = "[base_icon_state][damage_points]"
	else
		owner.robot_pain.icon_state = null

/obj/item/organ/internal/machine/posibrain/low_integrity_damage(integrity)
	var/damage_probability = get_integrity_damage_probability(integrity)
	if(prob(damage_probability))
		to_chat(owner, SPAN_MACHINE_WARNING("Neural pathway error located at block 0x[generate_hex()]."))
		take_internal_damage(2)
	. = ..()

/obj/item/organ/internal/machine/posibrain/medium_integrity_damage(integrity)
	var/damage_probability = get_integrity_damage_probability(integrity)
	var/list/static/medium_integrity_damage_messages = list(
		"Your neural subroutines' alarms are all going off at once.",
		"Critical error: rebooting subroutine...",
		"Several neural pathways cease functioning. You'll need time to sort that out later.",
		"Your software warns you of dangerously low neural coherence.",
		"Your self preservation subroutines threaten to kick in. [SPAN_DANGER("WARNING. WARNING.")]"
	)
	if(prob(damage_probability))
		to_chat(owner, SPAN_MACHINE_WARNING(pick(medium_integrity_damage_messages)))
		take_internal_damage(2)
	. = ..()

/obj/item/organ/internal/machine/posibrain/high_integrity_damage(integrity)
	var/damage_probability = get_integrity_damage_probability(integrity)
	if(prob(damage_probability))
		var/damage_roll = rand(1, 50)
		switch(damage_roll)
			if(1 to 10)
				patching_cooldown += 5 SECONDS
				to_chat(owner, SPAN_MACHINE_WARNING("Your neural pathway software corrupts further. Rebooting won't fix it this time."))
			if(11 to 20)
				to_chat(owner, SPAN_MACHINE_WARNING(FONT_LARGE("Your positronic software warns that you're in imminent danger. Every single subroutine is warning you that this might be the end...")))
				addtimer(CALLBACK(src, PROC_REF(rampant_self_preservation)), 2 SECONDS)
			if(21 to 30)
				var/obj/item/organ/internal/eyes/optical_sensor/optics = owner.internal_organs_by_name[BP_EYES]
				if(optics && !(optics.status & ORGAN_BROKEN))
					to_chat(owner, SPAN_MACHINE_WARNING(FONT_LARGE("Your neural pathways to your optics temporarily break! You switch your processing power to recover...")))
					owner.eye_blind = 10
					addtimer(CALLBACK(src, PROC_REF(recover_eye_blind)), 2 SECONDS)
			if(31 to 40)
				var/obj/item/organ/internal/machine/power_core/core = owner.internal_organs_by_name[BP_CELL]
				if(core && !(core.status & ORGAN_BROKEN))
					to_chat(owner, SPAN_MACHINE_WARNING("Your power core stops functioning for a moment. You switch your attention to the power lines throughout your frame..."))
					owner.eye_blind = 10
					owner.AdjustStunned(5)
					addtimer(CALLBACK(src, PROC_REF(recover_core_fault)), 1 SECOND)
			if(41 to 50)
				var/obj/item/organ/internal/machine/cooling_unit/cooling_unit = owner.internal_organs_by_name[BP_COOLING_UNIT]
				if(cooling_unit && !(cooling_unit.status & ORGAN_BROKEN))
					to_chat(owner, SPAN_MACHINE_WARNING("Your cooling unit breaks and its software crashes, leaving your frame to melt! You reroute all of your processing power to calculate how to repair it..."))
					var/previous_thermostat = cooling_unit.thermostat
					cooling_unit.locked_thermostat = TRUE
					cooling_unit.thermostat = rand(100, 150) + T0C
					addtimer(CALLBACK(src, PROC_REF(recover_cooling_fault), previous_thermostat), 4 SECONDS)
		take_internal_damage(2)
		playsound(owner, 'sound/species/synthetic/light_electric_discharge.ogg')
		spark(owner, rand(2, 3), GLOB.alldirs)
	if(prob(1))
		// no metagaming these ones :^)
		// they're on the server config
		sound_to(owner, 'sound/effects/eas_beep_fadeinout.ogg')
		to_chat(owner, SPAN_MACHINE_VISION(FONT_LARGE(pick(GLOB.low_integrity_messages))))
	. = ..()

/obj/item/organ/internal/machine/posibrain/proc/rampant_self_preservation()
	to_chat(owner, SPAN_MACHINE_WARNING(FONT_LARGE("Your self preservation erroneously kicks in! [SPAN_DANGER("RETURN TO SAFETY.")] <a href='byond://?src=[REF(src)];resist_self_preservation=1'>Resist it!</a>")))
	owner.balloon_alert(owner, "self-preservation activated")
	owner.confused = 100

/obj/item/organ/internal/machine/posibrain/proc/recover_eye_blind()
	var/obj/item/organ/internal/eyes/optical_sensor/optics = owner.internal_organs_by_name[BP_EYES]
	to_chat(owner, SPAN_MACHINE_WARNING(FONT_LARGE("You recreate new neural pathways to your optics! ERROR: Sustained dam...")))
	to_chat(owner, SPAN_DANGER(FONT_LARGE("You silence the errors from your optics. This isn't the time.")))
	owner.eye_blind = max(owner.eye_blind - 10, 0)
	optics.take_internal_damage(10)

/obj/item/organ/internal/machine/posibrain/proc/recover_core_fault()
	var/obj/item/organ/internal/machine/power_core/core = owner.internal_organs_by_name[BP_CELL]
	to_chat(owner, SPAN_MACHINE_WARNING(FONT_LARGE("You shunt your core into working once again. It'll leave collateral damage.")))
	owner.AdjustStunned(-5)
	core.take_internal_damage(15)

/obj/item/organ/internal/machine/posibrain/proc/recover_cooling_fault(original_thermostat)
	var/obj/item/organ/internal/machine/cooling_unit/cooling_unit= owner.internal_organs_by_name[BP_COOLING_UNIT]
	to_chat(owner, SPAN_MACHINE_WARNING(FONT_LARGE("You force the cooling unit to enter maintenance mode, force its thermostat down, and then reboot it in the span of a microsecond. It'll leave permanent damage, but it was necessary.")))
	cooling_unit.thermostat = original_thermostat
	cooling_unit.locked_thermostat = FALSE
	cooling_unit.take_internal_damage(20)

/obj/item/organ/internal/machine/posibrain/Topic(href, href_list)
	. = ..()
	if(href_list["resist_self_preservation"])
		if(owner.confused)
			to_chat(owner, SPAN_DANGER(FONT_LARGE("You reform your neural patterns to brute-force your self preservation!")))
			owner.confused = max(owner.confused - 100, 0)

/obj/item/organ/internal/machine/posibrain/circuit
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	robotic_brain_type = /obj/item/device/mmi/digital/robot

/obj/item/organ/internal/machine/posibrain/terminator
	name = "advanced positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves. <span class='danger'>It seems to be different than usual...</span>"
	relative_size = 60
	emp_coeff = 0.1
	color = COLOR_RED
