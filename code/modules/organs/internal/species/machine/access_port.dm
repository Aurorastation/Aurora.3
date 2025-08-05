/obj/item/organ/internal/machine/access_port
	name = "universal access port"
	desc = "A slot built into nearly all synthetics for universal access to information such as diagnostics or internal processes."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_port"
	organ_tag = BP_ACCESS_PORT
	parent_organ = BP_HEAD

	action_button_name = "Extend or Retract Cable"

	relative_size = 15

	/// Our access cable, which can be extended to connect into things.
	var/obj/item/access_cable/access_cable = /obj/item/access_cable/synthetic
	/// The internal port. This is where things get connected to to retrieve information or do effects.
	var/obj/item/internal_port

/obj/item/organ/internal/machine/access_port/Initialize()
	. = ..()
	access_cable = new access_cable(src, src, owner)
	RegisterSignal(access_cable, COMSIG_QDELETING, PROC_REF(clear_cable))
	add_verb(owner, /mob/living/carbon/human/proc/access_cable)

/obj/item/organ/internal/machine/access_port/Destroy()
	QDEL_NULL(access_cable)
	QDEL_NULL(internal_port)
	return ..()

/obj/item/organ/internal/machine/access_port/replaced(mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	add_verb(owner, /mob/living/carbon/human/proc/access_cable)

/obj/item/organ/internal/machine/access_port/removed(mob/living/carbon/human/target, mob/living/user)
	remove_verb(owner, /mob/living/carbon/human/proc/access_cable)
	. = ..()

/obj/item/organ/internal/machine/access_port/attack_self(mob/user)
	. = ..()
	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return

	if(!access_cable)
		to_chat(user, SPAN_WARNING("You don't have an access cable anymore!"))
		return

	// it's an organ, should never be not human type
	var/mob/living/carbon/human/synth = user
	if(synth.get_active_hand())
		to_chat(synth, SPAN_WARNING("You need a free hand to retrieve your universal access cable!"))
		return

	if(access_cable.loc != src)
		// not sure how NOT having a target and being here would work, but it's a fallback just in case things bug out
		if(access_cable.target)
			visible_message(SPAN_NOTICE("[owner] disconnects their [access_cable] from \the [access_cable.target]."))
			access_cable.target.remove_cable(access_cable)
		access_cable.clear_cable_full()
		access_cable.forceMove(src)
		return

	if(get_integrity() < 75)
		to_chat(user, SPAN_WARNING("You struggle to pry the cable out of the damaged port..."))
		if(!do_after(user, 2 SECONDS))
			return

	synth.visible_message(SPAN_NOTICE("[synth] extends their universal access cable from their neck."), SPAN_NOTICE("You retrieve your universal access cable from your neck."))
	synth.put_in_active_hand(access_cable)

/**
 * This proc is called whenever anything is inserted into the internal port.
 */
/obj/item/organ/internal/machine/access_port/proc/insert_item(obj/item/jack)
	SIGNAL_HANDLER
	if(internal_port)
		crash_with("Insert_item with [jack] on access port called with [internal_port] of [owner] already present!")

	internal_port = jack
	jack.dropInto(src)
	RegisterSignal(internal_port, COMSIG_QDELETING, PROC_REF(clear_port))
	to_chat(owner, SPAN_MACHINE_WARNING("Internal firewall notice: [internal_port] inserted into [src]."))

/**
 * This proc is called whenever the access cable is, for some reason, qdeleted (like with an explosion).
 */
/obj/item/organ/internal/machine/access_port/proc/clear_cable()
	SIGNAL_HANDLER
	if(!access_cable)
		return

	UnregisterSignal(access_cable, COMSIG_QDELETING)
	access_cable = null
	to_chat(owner, SPAN_WARNING("You lose contact with your access cable!"))

/**
 * This proc is called whenever the internal access port is emptied of whatever was in there previously.
 */
/obj/item/organ/internal/machine/access_port/proc/clear_port()
	if(!internal_port)
		return

	if(istype(internal_port, /obj/item/access_cable))
		var/obj/item/access_cable/ejected_cable = internal_port
		ejected_cable.target = null

	UnregisterSignal(internal_port, COMSIG_QDELETING)
	internal_port = null

/obj/item/organ/internal/machine/access_port/insert_cable(obj/item/access_cable/cable, mob/user)
	. = ..()
	insert_item(cable)

/obj/item/organ/internal/machine/access_port/cable_interact(obj/item/access_cable/cable, mob/user)
	var/obj/item/organ/internal/machine/internal_diagnostics/diagnostics_unit = owner.internal_organs_by_name[BP_DIAGNOSTICS_SUITE]
	if(!diagnostics_unit)
		to_chat(user, SPAN_WARNING("There is no diagnostics unit!"))
		return

	var/obj/item/organ/internal/machine/posibrain/posibrain = owner.internal_organs_by_name[BP_BRAIN]
	if(istype(posibrain))
		if(posibrain.firewall)
			to_chat(user, SPAN_MACHINE_WARNING("Firewall block detected. Aborting."))
			to_chat(diagnostics_unit.owner, SPAN_MACHINE_WARNING("Your firewall has blocked an unrecognized access attempt."))
			return

	diagnostics_unit.open_diagnostics(user)

/obj/item/access_cable
	name = "external access cable"
	desc = "A cable with universal access pins at its end. This is meant for jacking into synthetics to access their data."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "cable"
	pickup_sound = 'sound/species/synthetic/access_cable_out.ogg'

	/// Where this cable is extending from.
	var/obj/source
	///The actual source of the /datum/beam coming from the cable.
	var/atom/movable/beam_source
	/// Where this cable is attached to.
	var/obj/target
	/// The actual target of the /datum/beam coming from the cable.
	var/atom/movable/beam_target
	/// The beam connecting us to the source.
	var/datum/beam/cable
	/// The range this cable has. Past this range, it will disconnect.
	var/range = 3

/obj/item/access_cable/Initialize(mapload, atom/movable/new_source, atom/movable/override_beam_source)
	. = ..()
	if(!new_source)
		crash_with("Access cable spawned without a source: [x] [y] [z]")

	source = new_source
	if(override_beam_source)
		beam_source = override_beam_source
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_retract_range), TRUE)

/obj/item/access_cable/Destroy()
	source = null
	target = null
	beam_target = null
	beam_source = null
	if(cable)
		cable.End()
		QDEL_NULL(cable)
	return ..()

/**
 * When the cable is actually taken out of an object and thus is shown in world.
 * The parameters here might be different from the source/target variables on the cable itself.
 * For example, the source of a synthetic access cable is the power port, although that's physically inside a human mob and so we can't draw a beam to it.
 * We have to draw a beam from the human in that case.
 */
/obj/item/access_cable/proc/create_cable(var/atom/new_source, var/atom/new_target)
	clear_cable_visuals()
	beam_source = new_source
	beam_target = new_target
	RegisterSignal(beam_source, COMSIG_MOVABLE_MOVED, PROC_REF(check_retract_range), TRUE)
	RegisterSignal(beam_target, COMSIG_MOVABLE_MOVED, PROC_REF(check_retract_range), TRUE)
	cable = new(beam_source, beam_target, beam_icon_state = "cable", time = -1, maxdistance = range + 1)
	cable.Start()

/obj/item/access_cable/dropped(mob/user)
	. = ..()
	clear_cable_visuals()
	create_cable(beam_source, src)

/obj/item/access_cable/pickup(mob/user)
	. = ..()
	clear_cable_visuals()

/**
 * Signal handler.
 * If the cable moves beyond its range, automatically retract it.
 */
/obj/item/access_cable/proc/check_retract_range()
	SIGNAL_HANDLER
	if(source == loc)
		return

	if(get_dist(source, src) > range)
		retract()

/**
 * Automatically drop the cable and then retract it to the parent.
 */
/obj/item/access_cable/proc/retract()
	visible_message(SPAN_NOTICE("\The [src] automatically retracts into \the [source]!"))
	forceMove(source)
	clear_cable_full()

/**
 * Retracts the cable back into the parent object.
 */
/obj/item/access_cable/proc/clear_cable_full()
	if(beam_source)
		UnregisterSignal(beam_source, COMSIG_MOVABLE_MOVED)

	if(target)
		target.remove_cable(src)
	target = null
	clear_cable_visuals()

/**
 * Only clears the cable visuals (so, just the beam).
 */
/obj/item/access_cable/proc/clear_cable_visuals()
	if(beam_target)
		UnregisterSignal(beam_target, COMSIG_MOVABLE_MOVED)

	beam_target = null
	if(cable)
		cable.End()
		QDEL_NULL(cable)

/obj/item/access_cable/proc/target_interact(mob/user)
	if(!target || !user)
		return

	target.cable_interact(src, user)

/obj/item/access_cable/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(ishuman(target_mob))
		var/mob/living/carbon/human/human = target_mob
		if(!isipc(human))
			to_chat(user, SPAN_WARNING("Where are you planning to put that...?"))
			return

		var/obj/item/organ/internal/machine/access_port/access_port = human.internal_organs_by_name[BP_ACCESS_PORT]
		if(!access_port)
			to_chat(user, SPAN_WARNING("[human] does not have an access port!"))
			return

		if(access_port.access_cable == src)
			to_chat(user, SPAN_WARNING("You can't put your own cable into your own access port, as funny as it would be."))
			return

		if(access_port.is_broken())
			to_chat(user, SPAN_WARNING("[human]'s access port is completely broken! There's no way you can jack into it!"))
			return

		if(access_port.internal_port)
			to_chat(user, SPAN_WARNING("The access port is already occupied by [access_port.internal_port]!"))
			return

		if(user != human)
			if(human.client && !human.incapacitated(INCAPACITATION_FORCELYING|INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_BUCKLED_PARTIALLY))
				var/request = tgui_alert(human, "[user] would like to access your access port. Allow them?", "Access Port", list("Yes", "No"))
				if(request != "Yes")
					human.visible_message(SPAN_NOTICE("[human] pushes away [user]'s [src]."))
					return

			user.visible_message(SPAN_WARNING("[user] tries to jack \the [src] into [human]'s access port..."))
			if(!do_mob(user, human, 2 SECONDS))
				return
			user.visible_message(SPAN_WARNING("[user] jacks \the [src] into [human]'s access port!"))

		else
			user.visible_message(SPAN_WARNING("[user] jacks \the [src] into their access port!"), SPAN_WARNING("You jack \the [src] into your access port!"))

		create_cable(beam_source, human)
		access_port.insert_cable(src, user)
	else
		. = ..()

/obj/item/access_cable/synthetic
	name = "universal access cable"
	desc = "A cable with universal access pins at its end. This particular access cable comes with most synthetics' access ports for quick access to electronics, firewalls, or other synthetics' diagnostics systems."

/obj/item/access_cable/synthetic/mechanics_hints()
	. = ..()
	. += "To retract this cable into your port, <span class='notice'>activate it in-hand."

/obj/item/access_cable/synthetic/attack_self(mob/user, modifiers)
	if(isipc(user))
		var/mob/living/carbon/human/synth = user
		var/obj/item/organ/internal/machine/access_port/access_port = synth.internal_organs_by_name[BP_ACCESS_PORT]
		if(!access_port)
			to_chat(synth, SPAN_WARNING("Where's your access port?!"))
			return ..()

		if(access_port.is_broken())
			to_chat(synth, SPAN_WARNING("Your access port is completely broken! It won't go in!"))
			return ..()

		if(access_port.get_integrity() <= IPC_INTEGRITY_THRESHOLD_MEDIUM)
			synth.visible_message(SPAN_WARNING("[synth] tries to jam [synth.get_pronoun("his")] access cable back into their access port..."), SPAN_WARNING("You try to jam your access cable back into your access port..."))
			if(!do_after(synth, 3 SECONDS))
				return ..()

		synth.visible_message(SPAN_NOTICE("[synth] retracts [synth.get_pronoun("his")] access cable back into their access port."), SPAN_NOTICE("You retract your access cable back into your access port."))
		synth.drop_from_inventory(src, get_turf(src))
		forceMove(access_port)
		clear_cable_full()
		playsound(user, 'sound/species/synthetic/access_cable_in.ogg', 50)

/mob/living/carbon/human/proc/access_cable()
	set name = "Access Cable"
	set category = "Object"

	if(!isipc(src))
		return

	var/obj/item/organ/internal/machine/access_port/access_port = internal_organs_by_name[BP_ACCESS_PORT]
	if(!access_port)
		to_chat(src, SPAN_WARNING("Where's your access port?!"))
		return

	if(access_port.is_broken())
		to_chat(src, SPAN_WARNING("Your access port's only feedback is crackling static and jumbled code!"))
		return

	var/obj/item/access_cable/access_cable = access_port.access_cable
	if(!access_cable)
		to_chat(src, SPAN_WARNING("Your access cable is missing!"))
		return

	if(!access_cable.target)
		to_chat(src, SPAN_WARNING("You need to connect your cable to something first!"))
		return

	access_cable.target_interact(src)
