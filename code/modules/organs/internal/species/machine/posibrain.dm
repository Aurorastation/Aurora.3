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

	action_button_name = "Neural Configuration"

	/// The type of 'robotic brain'. Must be a subtype of /obj/item/device/mmi/digital.
	var/robotic_brain_type = /obj/item/device/mmi/digital/posibrain
	/// The stored MMI object.
	var/obj/item/device/mmi/stored_mmi
	/// The cooldown between each 'patch'.
	var/patching_cooldown = 30 SECONDS
	/// The world.time of the last 'patch'.
	var/last_patch_time = 0
	/// Whether the synthetic's firewall is enabled or not. Boolean.
	var/firewall = TRUE

/obj/item/organ/internal/machine/posibrain/Initialize(mapload)
	stored_mmi = new robotic_brain_type(src)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(setup_brain)), 30)
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)

/obj/item/organ/internal/machine/posibrain/Destroy()
	QDEL_NULL(stored_mmi)
	return ..()

/obj/item/organ/internal/machine/posibrain/attack_self(mob/user)
	. = ..()
	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return


	open_neural_configuration(user)

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

/**
 * Generates a random hex number for cool hacking aesthetic.
 */
/obj/item/organ/internal/machine/posibrain/proc/generate_hex()
	var/hex = pick("A", "B", "C", "D", "E", "F") + "[rand(0, 999999)]"
	return hex

/**
 * Toggles the firewall on or off. In the future, can be overridden by things like viruses.
 */
/obj/item/organ/internal/machine/posibrain/proc/toggle_firewall()
	firewall = !firewall
	to_chat(owner, SPAN_MACHINE_WARNING("Internal firewall [firewall ? "enabled" : "disabled"]."))

/obj/item/organ/internal/machine/posibrain/process(seconds_per_tick)
	if(!owner)
		return

	// 150C
	if(owner.bodytemperature > 423)
		// placeholder values
		take_internal_damage(owner.bodytemperature / 4)

	if(damage)
		if(damage < max_damage * 0.25)
			if(last_patch_time < world.time + patching_cooldown)
				heal_damage(rand(1, 5))
				to_chat(owner, SPAN_MACHINE_WARNING("Neural pathway patch automatically applied to block [generate_hex()]."))
	..()

/obj/item/organ/internal/machine/posibrain/low_integrity_damage(integrity)
	var/damage_probability = get_integrity_damage_probability(integrity)
	if(prob(damage_probability))
		to_chat(owner, SPAN_MACHINE_WARNING("Neural pathway error located at block 0x[generate_hex()]."))
		take_internal_damage(4)
	. = ..()

/obj/item/organ/internal/machine/posibrain/medium_integrity_damage(integrity)
	var/damage_probability = get_integrity_damage_probability(integrity)
	if(prob(damage_probability))
		to_chat(owner, SPAN_MACHINE_DANGER("Irreversible damage detected. Warning: further damage may result in /#!&!@#!!°!2*#"))
	. = ..()

/obj/item/organ/internal/machine/posibrain/high_integrity_damage(integrity)
	var/damage_probability = get_integrity_damage_probability(integrity)
	if(prob(damage_probability))
		to_chat(owner, SPAN_MACHINE_DANGER(FONT_LARGE("You can feel your positronic begin to fragment...")))
		take_internal_damage(2)
	. = ..()

/obj/item/organ/internal/machine/posibrain/circuit
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	robotic_brain_type = /obj/item/device/mmi/digital/robot

/obj/item/organ/internal/machine/posibrain/terminator
	name = BP_BRAIN
	organ_tag = BP_BRAIN
	parent_organ = BP_CHEST
	vital = TRUE
	emp_coeff = 0.1
