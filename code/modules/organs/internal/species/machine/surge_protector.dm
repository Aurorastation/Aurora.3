/obj/item/organ/internal/machine/surge
	name = "surge preventor"
	desc = "A small device that give immunity to EMP for few pulses."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_surge_protector"
	organ_tag = BP_SURGE_PROTECTOR
	parent_organ = BP_CHEST
	vital = FALSE
	robotic_sprite = FALSE

	relative_size = 30

	var/surge_left = 0
	var/broken = 0

/obj/item/organ/internal/machine/surge/Initialize()
	if(!surge_left && !broken)
		surge_left = rand(2, 5)
	robotize()
	. = ..()

/obj/item/organ/internal/machine/surge/advanced
	name = "advanced surge preventor"
	var/max_charges = 5
	var/stage_ticker = 0
	var/stage_interval = 250

/obj/item/organ/internal/machine/surge/advanced/process()
	..()

	if(!owner)
		return

	if(surge_left >= max_charges)
		return

	if(stage_ticker < stage_interval)
		stage_ticker += 2

	if(stage_ticker >= stage_interval)
		surge_left += 1
		stage_interval += 250
