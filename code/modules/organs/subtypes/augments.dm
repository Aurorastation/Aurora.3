/obj/item/organ/augment
	name = "aug"
	icon = 'icons/obj/surgery.dmi'

	robotic = 2

	emp_coeff = 1

	var/online = 0
	var/list/install_locations = list()

/obj/item/organ/augment/refresh_action_button()
	. = ..()
	if(.)
		if(!online)
			return

/obj/item/organ/augment/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!online)
			return

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		if(is_broken())
			to_chat(owner, "<span class='danger'>\The [src] is too damaged to be used!</span>")
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

/obj/item/organ/augment/process()
	..()
	if(!online)
		return

/////////////////
//TOOL AUGMENTS// - they spawn a tool when they operate
/////////////////

/obj/item/organ/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	var/augment_type = /obj/item/combitool/robotic

/obj/item/organ/augment/tool/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "digitool"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.get_active_hand())
			to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
			return

		owner.last_special = world.time + 100
		var/obj/item/M = new augment_type(owner)
		owner.put_in_active_hand(M)
		owner.visible_message("<span class='notice'>\The [M] slides out of \the [owner]'s [src].</span>","<span class='notice'>You deploy \the [M]!</span>")