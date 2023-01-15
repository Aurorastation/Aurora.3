/obj/item/inductive_charger
	name = "inductive charger"
	desc = "A phoron-enhanced induction charger hooked up to its attached stationbound's internal cell."
	desc_extended = "Harnessing the energy potential found in phoron structures, NanoTrasen engineers have created a portable device capable of highly efficient wireless charging. The expense and limit of energy output of using this method of charging prevents it from being used on a large scale, being far outclassed by Phoron-Supermatter charging systems."
	desc_info = "Click on an adjacent object that contains or is a power cell to attempt to find and charge it. After a successful charge, the inductive charger recharge in a few minutes. The amount transfered can be adjusted by alt clicking it."
	icon = 'icons/obj/item/tools/inductive_charger.dmi'
	icon_state = "inductive_charger"
	item_state = "inductive_charger"
	flags = HELDMAPTEXT
	contained_sprite = TRUE
	var/is_in_use = FALSE
	var/ready_to_use = TRUE
	var/recharge_time = 300
	var/transfer_rate = 5000
	var/efficiency_mod = 0.9
	maptext_x = 3
	maptext_y = 2

/obj/item/inductive_charger/set_initial_maptext()
	held_maptext = SMALL_FONTS(7, "Ready")

/obj/item/inductive_charger/AltClick(mob/user)
	. = ..()
	var/set_rate = input(user, "How much do you want to transfer per use? (Limit: 1 - 5000)", "Induction Transfer Rate", 5000) as num
	if(set_rate > 5000)
		set_rate = 5000
	else if(set_rate < 1)
		set_rate = 1
	transfer_rate = set_rate
	to_chat(user, SPAN_NOTICE("You set the transfer rate of \the [src] to [transfer_rate]."))

/obj/item/inductive_charger/get_cell()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		return R.get_cell()
	return null

/obj/item/inductive_charger/attack(mob/living/M, mob/living/user, target_zone)
	return

/obj/item/inductive_charger/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(is_in_use)
		to_chat(user, SPAN_WARNING("You're already using \the [src]!"))
		return

	if(!proximity_flag)
		to_chat(user, SPAN_WARNING("You need to be adjacent to the target to charge it!"))
		return

	var/obj/item/cell/C = get_cell()
	if(!istype(C))
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a cell connected to it!"))
		return

	if(!ready_to_use)
		to_chat(user, SPAN_WARNING("\The [src] is still gathering charge!"))
		return

	is_in_use = TRUE
	user.visible_message("<b>[user]</b> begins waving \the [src] around \the [target]...", SPAN_NOTICE("You prepare to wirelessly charge \the [target]..."), range = 3)
	if(!do_after(user, 50, TRUE, target))
		is_in_use = FALSE
		return
	is_in_use = FALSE
	if(C.charge < 1000)
		to_chat(user, SPAN_WARNING("You have no spare charge in your internal cell to give!"))
		return

	if(isobj(target) || isliving(target))
		var/obj/item/cell/obj_cell = target.get_cell()
		if(!istype(obj_cell))
			to_chat(user, SPAN_WARNING("\The [target] doesn't contain a cell!"))
			return
		if(obj_cell.fully_charged())
			to_chat(user, SPAN_WARNING("\The [obj_cell] is already fully charged!"))
			return
		var/charge_amount = min(obj_cell.maxcharge - obj_cell.charge, transfer_rate)
		var/charge_value = C.use(charge_amount / efficiency_mod) * efficiency_mod
		obj_cell.give(charge_value)
		message_and_use(user, "<b>[user]</b> holds \the [src] over \the [target], topping up [target.get_pronoun("his")] battery.", SPAN_NOTICE("You wirelessly transmit [charge_value] units of power to \the [target], using [charge_value / efficiency_mod] units of internal cell power."))
	else
		to_chat(user, SPAN_WARNING("\The [src] cannot be used on \the [target]!"))

/obj/item/inductive_charger/proc/message_and_use(mob/user, var/others_message, var/self_message)
	user.visible_message(others_message, self_message, range = 3)
	addtimer(CALLBACK(src, .proc/recharge), recharge_time)
	ready_to_use = FALSE
	check_maptext(SMALL_FONTS(6, "Charge"))

/obj/item/inductive_charger/proc/recharge()
	ready_to_use = TRUE
	check_maptext(SMALL_FONTS(7, "Ready"))

/obj/item/inductive_charger/handheld
	desc = "A handheld phoron-enhanced induction charger, capable of wirelessly charging cells at a reduced efficiency. This one is painted in science colors."
	icon_state = "inductive_charger_sci"
	item_state = "inductive_charger_sci"
	efficiency_mod = 0.8 // less efficient than the stationbound version
	var/obj/item/cell/cell = /obj/item/cell/high/empty

/obj/item/inductive_charger/handheld/Initialize()
	. = ..()
	if(ispath(cell))
		cell = new cell(src)

/obj/item/inductive_charger/handheld/examine(mob/user, distance)
	. = ..()
	if(cell)
		to_chat(user, SPAN_NOTICE("Cell Charge: [cell.percent()]%"))

/obj/item/inductive_charger/handheld/get_cell()
	return cell

/obj/item/inductive_charger/handheld/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell inserted."))
			return TRUE
		user.drop_from_inventory(I, src)
		to_chat(user, SPAN_NOTICE("You put \the [I] into \the [src]."))
		cell = I
		return TRUE
	if(I.isscrewdriver())
		if(!cell)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a cell inserted."))
			return TRUE
		user.put_in_hands(cell)
		to_chat(user, SPAN_NOTICE("You remove \the [cell] from \the [src]."))
		cell = null
		return TRUE
	return ..()

/obj/item/inductive_charger/handheld/engineering
	desc = "A handheld phoron-enhanced induction charger, capable of wirelessly charging cells at a reduced efficiency. This one is painted in engineering colors."
	icon_state = "inductive_charger_eng"
	item_state = "inductive_charger_eng"
