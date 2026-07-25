/obj/item/organ/internal/augment/smes_induction_link
	name = "SMES induction link"
	desc = "A miniaturized, superconductive energy storage (SMES) cell utilizing phoronic magnet coils installed in the user's palms. " \
		+ "The SMES feeds into an induction link, which can wirelessly charge the cell of a held object. It has NanoTrasen Corporation branding."
	action_button_name = "Induction Charge"
	action_button_icon = "combipen"
	activable = TRUE
	organ_tag = BP_AUG_SMES_INDUCTOR
	parent_organ = BP_R_HAND
	cooldown = 10 MINUTES
	/// String used for messages.
	var/hand_string = "right hand"
	/// Hand slot to check.
	var/hand_slot = slot_r_hand
	/// Amount to transfer (in Kilojoules)
	var/transfer_amount = 4000.0 / 3.0 // 1/3rd of a standard laser rifle cell.

/obj/item/organ/internal/augment/smes_induction_link/left
	parent_organ = BP_L_HAND
	hand_slot = slot_l_hand
	hand_string = "left hand"

/obj/item/organ/internal/augment/smes_induction_link/attack_self(mob/user)
	. = ..()
	if (!. || !user)
		return
	var/obj/item/target = user.get_equipped_item(hand_slot)
	if (!istype(target))
		to_chat(user, SPAN_WARNING("You have nothing in your [hand_string] to charge!"))
		return

	var/obj/item/cell/obj_cell = target.get_cell()
	if(!istype(obj_cell))
		to_chat(user, SPAN_WARNING("\The [target] doesn't contain a cell!"))
		return
	if(obj_cell.fully_charged())
		to_chat(user, SPAN_WARNING("\The [obj_cell] is already fully charged!"))
		return

	var/charge_amount = min(obj_cell.maxcharge - obj_cell.charge, transfer_amount)
	obj_cell.give(charge_amount)
	user.visible_message("otherMessage", SPAN_NOTICE("You transmit [charge_amount] units of power to \the [target] from your [src]."))
