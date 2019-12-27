#define BLOOD_REGEN_PER_SEC   0.07
#define STAMINA_REGEN_PER_SEC 5

// Unathi Blood Regeneration organ
/obj/item/organ/internal/suphreans
	name = "suphreans"
	icon_state = "generic"
	desc = "An organ that exists within Sinta'Unathi that grants them enhanced blood regeneration. It is found near the liver."
	gender = PLURAL
	organ_tag = BP_SUPHREANS
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 6
	toxin_type = CE_HEPATOTOXIC
	var/last_process

/obj/item/organ/internal/suphreans/process()
	..()
	if(!owner)
		return
	owner.add_blood_simple(BLOOD_REGEN_PER_SEC * ((world.time - last_process) / 10))
	last_process = world.time

// Unathi Stamina Regeneration organ
/obj/item/organ/internal/throktids
	name = "throktids"
	icon_state = "generic"
	desc = "An organ that exists within Sinta'Unathi that grants them enhanced stamina regeneration. It is found near the kidneys."
	gender = PLURAL
	organ_tag = BP_THROKTIDS
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 6
	toxin_type = CE_NEPHROTOXIC
	var/last_process

/obj/item/organ/internal/throktids/process()
	..()
	if(!owner)
		return
	owner.stamina = min(owner.stamina + (STAMINA_REGEN_PER_SEC * ((world.time - last_process) / 10)), owner.species.stamina)
	last_process = world.time