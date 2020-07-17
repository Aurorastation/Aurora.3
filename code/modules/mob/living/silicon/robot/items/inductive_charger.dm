/obj/item/inductive_charger
	name = "inductive charger"
	desc = "A phoron-enhanced induction charger hooked up to its attached stationbound's internal cell."
	desc_fluff = "Harnessing the energy potential found in phoron structures, Nanotrasen engineers have created a portable device capable of highly efficient wireless charging. The expense and limit of energy output of using this method of charging prevents it from being used on a large scale, being far outclassed by Phoron-Supermatter charging systems."
	desc_info = "Click on an adjacent object that contains or is a power cell to attempt to find and charge it. After a successful charge, the inductive charger recharge in a few minutes. The amount transfered can be adjusted by alt clicking it."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "inductive_charger"
	var/ready_to_use = TRUE
	var/recharge_time = 300
	var/transfer_rate = 5000
	var/efficiency_mod = 0.9
	maptext_x = 3
	maptext_y = 2

/obj/item/inductive_charger/Initialize()
	. = ..()
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/inductive_charger/AltClick(mob/user)
	. = ..()
	var/set_rate = input(user, "How much do you want to transfer per use? (Limit: 1 - 5000)", "Induction Transfer Rate", 5000) as num
	if(set_rate > 5000)
		set_rate = 5000
	else if(set_rate < 1)
		set_rate = 1
	transfer_rate = set_rate
	to_chat(user, SPAN_NOTICE("You set the transfer rate of \the [src] to [transfer_rate]."))

/obj/item/inductive_charger/attack(mob/living/M, mob/living/user, target_zone)
	return

/obj/item/inductive_charger/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/mob/living/silicon/robot/R = user
	if(!istype(R))
		to_chat(user, SPAN_WARNING("Only cyborgs can use this!"))
		return
	if(!ready_to_use)
		to_chat(user, SPAN_WARNING("\The [src] is still gathering charge!"))
		return

	user.visible_message("<b>[user]</b> begins waving \the [src] around \the [target]...", SPAN_NOTICE("You prepare to wirelessly charge \the [target]..."), range = 3)
	if(!do_after(user, 50, TRUE, target))
		return
	if(R.cell.charge < 1000)
		to_chat(user, SPAN_WARNING("You have no spare charge in your internal cell to give!"))
		return

	if(isipc(target))
		var/mob/living/carbon/human/IPC = target
		if(IPC.nutrition == IPC.max_nutrition)
			to_chat(user, SPAN_WARNING("\The [IPC] is already fully charged!"))
			return
		var/charge_amount = min(IPC.max_nutrition - IPC.nutrition, transfer_rate)
		var/charge_value = R.cell.use(charge_amount / efficiency_mod) * efficiency_mod
		IPC.nutrition = min(IPC.max_nutrition, charge_value)
		message_and_use(user, "<b>[user]</b> holds \the [src] over \the [IPC], topping up their battery.", SPAN_NOTICE("You wirelessly transmit [charge_value] units of power to \the [IPC], using [charge_value / efficiency_mod] of internal cell power."))
	else if(isobj(target))
		var/obj/item/cell/C
		if(istype(target, /obj/item/cell))
			C = target
		else
			C = locate() in target
		if(!C)
			to_chat(user, SPAN_WARNING("\The [target] doesn't contain a cell, or it's buried too deep for you to reach!"))
			return
		if(C.fully_charged())
			to_chat(user, SPAN_WARNING("\The [C] is already fully charged!"))
			return
		var/charge_amount = min(C.maxcharge - C.charge, transfer_rate)
		var/charge_value = R.cell.use(charge_amount / efficiency_mod) * efficiency_mod
		C.give(charge_value)
		message_and_use(user, "<b>[user]</b> holds \the [src] over \the [target], topping up its battery.", SPAN_NOTICE("You wirelessly transmit [charge_value] units of power to \the [target], using [charge_value / efficiency_mod] of internal cell power."))
	else
		to_chat(user, SPAN_WARNING("\The [src] cannot be used on \the [target]!"))

/obj/item/inductive_charger/proc/message_and_use(mob/user, var/others_message, var/self_message)
	user.visible_message(others_message, self_message, range = 3)
	addtimer(CALLBACK(src, .proc/recharge), recharge_time)
	ready_to_use = FALSE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 6px;\">Charge</span>"

/obj/item/inductive_charger/proc/recharge()
	ready_to_use = TRUE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"