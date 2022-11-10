/mob/living/carbon/verb/give(var/mob/living/target in view(1)-usr)
	set category = "IC"
	set name = "Give"

	do_give(target)

/mob/living/carbon/proc/do_give(var/mob/living/carbon/human/target)
	if(use_check(target))
		to_chat(usr, SPAN_WARNING("[target.name] is in no condition to handle items!"))
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		I = usr.get_inactive_hand()
	if(!I)
		to_chat(usr, SPAN_WARNING("You don't have anything in your hands to give to \the [target]."))
		return
	
	if(I.too_heavy_to_throw())
		to_chat(src, SPAN_WARNING("You can barely lift \the [I] up, how do you expect to hand it over to someone?"))
		return FALSE

	usr.visible_message(SPAN_NOTICE("\The [usr] holds out \the [I] to \the [target]."), SPAN_NOTICE("You hold out \the [I] to \the [target], waiting for them to accept it."))

	if(alert(target,"[usr] wants to give you \a [I]. Will you accept it?",,"Yes","No") == "No")
		target.visible_message("<b>[target]</b> pushes [usr]'s hand away.")
		return

	if(!I)
		return

	if(!Adjacent(target))
		to_chat(usr, SPAN_WARNING("You need to stay in reaching distance while giving an object."))
		to_chat(target, SPAN_WARNING("\The [usr] moved too far away."))
		return

	if(I.loc != usr || (usr.l_hand != I && usr.r_hand != I))
		to_chat(usr, SPAN_WARNING("You need to keep the item in your hands."))
		to_chat(target, SPAN_WARNING("\The [usr] seems to have given up on passing \the [I] to you."))
		return

	if(target.r_hand != null && target.l_hand != null)
		to_chat(target, SPAN_WARNING("Your hands are full."))
		to_chat(usr, SPAN_WARNING("Their hands are full."))
		return

	if(usr.unEquip(I))
		I.on_give(usr, target)
		if(!QDELETED(I)) // if on_give deletes the item, we don't want runtimes below
			target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
			usr.visible_message("<b>[usr]</b> hands [target] \a [I].", SPAN_NOTICE("You give \the [target] a [I]."))