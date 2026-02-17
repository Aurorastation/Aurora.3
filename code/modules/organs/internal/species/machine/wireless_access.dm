/obj/item/organ/internal/machine/wireless_access
	name = "wireless access point"
	desc = "A module that allows a Bishop frame to wirelessly access machines that it is authorized to interact with."
	organ_tag = BP_WIRELESS_ACCESS
	parent_organ = BP_HEAD
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_wireless_access"

	action_button_name = "Access Internal Computer"

	max_damage = 20 //frail
	relative_size = 20

	/// This frame's internal PDA.
	var/obj/item/modular_computer/handheld/pda/synthetic_internal/internal_pda

/obj/item/organ/internal/machine/wireless_access/Initialize()
	. = ..()
	internal_pda = new(src)

/obj/item/organ/internal/machine/wireless_access/Destroy()
	QDEL_NULL(internal_pda)
	return ..()

/obj/item/organ/internal/machine/wireless_access/attack_self(var/mob/user)
	. = ..()
	if(!internal_pda)
		return

	if(owner.last_special > world.time)
		return

	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return

	internal_pda.attack_self(user)

/**
 * This proc is called whenever the IPC clicks the terminal to interact with it.
 * It is called before the interaction is a success.
 * If it returns TRUE, the IPC will interact with the machine.
 * Otherwise, it will not.
 */
/obj/item/organ/internal/machine/wireless_access/proc/access_terminal(obj/terminal)
	if(is_broken())
		return FALSE
	return TRUE

/obj/item/organ/internal/machine/wireless_access/process()
	. = ..()
	var/obj/item/organ/internal/machine/power_core/microbattery = owner.internal_organs_by_name[BP_CELL]
	if(microbattery)
		var/obj/item/cell/pda_cell = internal_pda.battery_module.get_cell()
		if(pda_cell?.percent() < 95)
			pda_cell.give((pda_cell.maxcharge * 0.1))
			// There would be some bonkers power usage if we did 1:1 cell usage.
			microbattery.use(pda_cell.maxcharge * 0.05)

/obj/item/modular_computer/handheld/pda/synthetic_internal
	name = "internal computer"
	desc = "An internal computer with an NtOS operating system."

	/// The access point organ that this PDA is tied to.
	var/obj/item/organ/internal/machine/wireless_access/access_point

/obj/item/modular_computer/handheld/pda/synthetic_internal/Initialize()
	. = ..()
	if(istype(loc, /obj/item/organ/internal/machine/wireless_access))
		var/obj/item/organ/internal/machine/wireless_access/potential_access_point = loc
		if(potential_access_point.owner)
			access_point = potential_access_point
		else
			crash_with("Something terrible happened in synthetic internal PDA init! Loc: [loc]")

/obj/item/modular_computer/handheld/pda/synthetic_internal/Destroy()
	if(access_point)
		access_point.internal_pda = null
		access_point = null
	return ..()

/obj/item/modular_computer/handheld/pda/synthetic_internal/ui_status(mob/user, datum/ui_state/state)
	if(loc == access_point)
		if(!access_point.is_broken())
			return UI_INTERACTIVE
		else
			to_chat(user, SPAN_WARNING("Your internal PDA is not responding to your queries."))
	return UI_CLOSE
