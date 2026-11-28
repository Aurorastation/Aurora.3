/// Element used by the Butcher's Instinct quirk to increase meat and part yields when butchering.
/datum/element/butcher_instinct
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Extra base meat yielded when butchering.
	var/meat_bonus = 1
	/// Extra butchering bonus parts yielded.
	var/part_bonus = 1

/datum/element/butcher_instinct/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_GET_BUTCHERING_MODIFIERS, PROC_REF(modify_butchering))

/datum/element/butcher_instinct/Detach(datum/target)
	UnregisterSignal(target, COMSIG_GET_BUTCHERING_MODIFIERS)
	return ..()

/datum/element/butcher_instinct/proc/modify_butchering(owner, mob/living/simple_animal/target, base_meat_amount, butchering_bonus)
	SIGNAL_HANDLER
	*base_meat_amount = *base_meat_amount + meat_bonus
	*butchering_bonus = *butchering_bonus + part_bonus
