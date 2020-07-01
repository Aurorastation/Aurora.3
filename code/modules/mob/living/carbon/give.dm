/mob/living/carbon/human/verb/give(var/mob/living/target in view(1)-usr)
	set category = "IC"
	set name = "Give"

	if(use_check(target))
		to_chat(usr, span("warning", "[target.name] is in no condition to handle items!"))
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		I = usr.get_inactive_hand()
	if(!I)
		to_chat(usr, span("warning", "You don't have anything in your hands to give to \the [target]."))
		return

	if(alert(target,"[usr] wants to give you \a [I]. Will you accept it?",,"Yes","No") == "No")
		target.visible_message("<b>[target]</b> pushes [usr]'s hand away.")
		return

	if(!I)
		return

	if(!Adjacent(target))
		to_chat(usr, span("warning", "You need to stay in reaching distance while giving an object."))
		to_chat(target, span("warning", "\The [usr] moved too far away."))
		return

	if(I.loc != usr || (usr.l_hand != I && usr.r_hand != I))
		to_chat(usr, span("warning", "You need to keep the item in your hands."))
		to_chat(target, span("warning", "\The [usr] seems to have given up on passing \the [I] to you."))
		return

	if(target.r_hand != null && target.l_hand != null)
		to_chat(target, span("warning", "Your hands are full."))
		to_chat(usr, span("warning", "Their hands are full."))
		return

	if(usr.unEquip(I))
		I.on_give(usr, target)
		if(!QDELETED(I)) // if on_give deletes the item, we don't want runtimes below
			target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
			usr.visible_message("<b>[usr]</b> hands [target] \a [I].", span("notice", "You give \the [target] a [I]."))
