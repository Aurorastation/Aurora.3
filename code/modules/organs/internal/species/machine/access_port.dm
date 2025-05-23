/obj/item/organ/internal/machine/access_port
	name = "universal access port"
	desc = "A slot built into nearly all synthetics for universal access to information such as diagnostics or internal processes."
	organ_tag = BP_ACCESS_PORT
	parent_organ = BP_HEAD

	action_button_name = "Extend Cable"

	/// Our access cable, which can be extended to connect into things.
	var/obj/item/access_cable/access_cable
	/// The internal port. This is where things get connected to to retrieve information or do effects.
	var/obj/item/internal_port

/obj/item/organ/internal/machine/access_port/Initialize()
	. = ..()
	access_cable = new(src, src)

/obj/item/organ/internal/machine/access_port/attack_self(mob/user)
	. = ..()
	if(owner.last_special > world.time)
		return

	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return

	if(access_cable)
		to_chat(user, SPAN_WARNING("Your access cable is already extended!"))

	// it's an organ, should never be not human type
	var/mob/living/carbon/human/synth = user
	if(synth.get_active_hand())
		to_chat(synth, SPAN_WARNING("You need a free hand to retrieve your universal access cable!"))
		return

	synth.visible_message(SPAN_NOTICE("[synth] extends their universal access cable from their neck."), SPAN_NOTICE("You retrieve your universal access cable from your neck."))
	access_cable = new(get_turf(synth), synth)
	synth.put_in_any_hand_if_possible(access_cable)

	synth.last_special = world.time

/obj/item/organ/internal/machine/access_port/proc/insert_item(obj/item/jack)
	if(internal_port)
		crash_with("Insert_item with [jack] on access port called with [internal_port] already present!")

	internal_port = jack
	jack.forceMove(src)
	RegisterSignal(internal_port, COMSIG_QDELETING, PROC_REF(clear_port))
	to_chat(owner, SPAN_MACHINE_WARNING("Internal firewall notice: [internal_port] inserted into access port."))

/obj/item/organ/internal/machine/access_port/proc/clear_port()
	internal_port = null

/obj/item/access_cable
	name = "external access cable"
	desc = "A cable with universal access pins at its end. This is meant for jacking into synthetics to access their data."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"

	/// Where this cable is extending from.
	var/atom/movable/source
	/// Where this cable is attached to.
	var/atom/movable/target
	/// The beam connecting us to the source.
	var/datum/beam/cable
	/// The range this cable has. Past this range, it will disconnect.
	var/range = 3

/obj/item/access_cable/Initialize(mapload, atom/movable/new_source)
	. = ..()
	if(!source)
		crash_with("Access cable spawned without a source: [x] [y] [z]")

	source = new_source

/obj/item/access_cable/Destroy()
	source = null
	target = null
	QDEL_NULL(cable)
	return ..()

/obj/item/access_cable/proc/extend()
	cable = new(source, src, beam_icon_state = "cable", time = -1, maxdistance = range)

/obj/item/access_cable/proc/retract()
	source.visible_message(SPAN_NOTICE("\The [src] retracts into [source]!"))
	qdel(src)

/obj/item/access_cable/attack_self(mob/user, modifiers)
	if(isipc(user))
		var/mob/living/carbon/human/synth = user
		var/obj/item/organ/internal/machine/access_port/access_port = synth.internal_organs_by_name[BP_ACCESS_PORT]
		if(!access_port)
			to_chat(synth, SPAN_WARNING("Where's your access port?!"))
			return ..()

		if(access_port.get_integrity() <= IPC_INTEGRITY_THRESHOLD_MEDIUM)
			synth.visible_message(SPAN_WARNING("[synth] tries to jam \the [src] back into their access port..."), SPAN_WARNING("You try to jam your [src] back into your access port..."))
			if(do_after(synth, 3 SECONDS))
				retract()


/obj/item/access_cable/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(ishuman(target) && proximity_flag)
		var/mob/living/carbon/human/human = target
		if(!isipc(human))
			to_chat(user, SPAN_WARNING("Where are you planning to put that...?"))
			return

		var/obj/item/organ/internal/machine/access_port/access_port = human.internal_organs_by_name[BP_ACCESS_PORT]
		if(!access_port)
			to_chat(user, SPAN_WARNING("[human] does not have an access port!"))
			return

		if(access_port.is_broken())
			to_chat(user, SPAN_WARNING("[human]'s access port is completely broken! There's no way you can jack into it!"))
			return

		if(access_port.internal_port)
			to_chat(user, SPAN_WARNING("The access port is already occupied by [access_port.internal_port]!"))
			return

		if(!human.incapacitated(INCAPACITATION_FORCELYING|INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_BUCKLED_PARTIALLY) && (user != human))
			var/request = tgui_alert(human, "[user] would like to access your access port. Allow them?", "Access Port", list("Yes", "No"))
			if(request != "Yes")
				human.visible_message(SPAN_NOTICE("[human] pushes away [user]'s [src]."))
				return

		if(user != human)
			user.visible_message(SPAN_WARNING("[user] tries to jack \the [src] into [human]'s access port..."))
			if(!do_mob(user, human, 3 SECONDS))
				return
			user.visible_message(SPAN_WARNING("[user] jacks \the [src] into [human]'s access port!"))

		else
			user.visible_message(SPAN_WARNING("[user] jacks \the [src] into their access port!"), SPAN_WARNING("You jack \the [src] into your access port!"))

		access_port.insert_item(src)
