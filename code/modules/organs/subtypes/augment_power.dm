/obj/item/organ/internal/augment/power
	name = BP_AUG_POWER
	desc = "The central power source for all augments within a system."
	parent_organ = BP_CHEST
	organ_tag = BP_AUG_POWER
	activable = FALSE
	var/cell_type = /obj/item/cell
	var/obj/item/cell/cell

/obj/item/organ/internal/augment/power/Initialize()
	. = ..()
	cell = new cell_type(src)

/obj/item/organ/internal/augment/power/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/organ/internal/augment/power/use_charge(var/drain_amount)
	if(cell.check_charge(drain_amount))
		cell.use(drain_amount)
		return TRUE
	return FALSE

/obj/item/organ/internal/augment/power/add_charge(var/charge_amount)
	cell.give(charge_amount)
	return TRUE

/obj/item/organ/internal/augment/power/replaced(mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	RegisterSignal(target, COMSIG_MOB_STAT, PROC_REF(handle_stat))

/obj/item/organ/internal/augment/power/removed(mob/living/carbon/human/target, mob/living/user)
	. = ..()
	UnregisterSignal(target, COMSIG_MOB_STAT)

/obj/item/organ/internal/augment/power/proc/handle_stat(var/mob/user, var/list/stat_data)
	stat_data["Internal Power Supply"] = cell ? cell.charge : "NO CELL!"
