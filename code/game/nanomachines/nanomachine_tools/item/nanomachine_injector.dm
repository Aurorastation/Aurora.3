/obj/item/nanomachine_injector
	name = "nanomachine injector"
	var/name_label
	desc = "A device with a sharp needle at the end, used to inject a colony of nanomachines into a humanoid."
	desc_fluff = "A cooperation between all the SCC companies, this device is actually one of the lowest tech of all the nanomachine applicators. Who would have guessed."

	icon = 'icons/obj/contained_items/tools/nanomachine_injector.dmi'
	icon_state = "nanomachine_injector"
	item_state = "nanomachine_injector"
	contained_sprite = TRUE

	var/spent = FALSE
	var/list/preloaded_programs

/obj/item/nanomachine_injector/Initialize()
	. = ..()
	if(name_label)
		name_unlabel = name
		name = "[name] ([name_label])"
		verbs += /atom/proc/remove_label
	update_icon()

/obj/item/nanomachine_injector/attack(mob/living/carbon/human/H, mob/living/user, target_zone)
	if(spent)
		to_chat(user, SPAN_WARNING("\The [src] is spent!"))
		return
	if(!ishuman(H))
		to_chat(user, SPAN_WARNING("\The [src] only works on humanoids!"))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<b>[user]</b> is trying to inject \the [H] with \the [src]...", SPAN_NOTICE("You begin lining up the needle to \the [H]..."))
	if(do_mob(user, H, 2 SECONDS))
		user.visible_message("<b>[user]</b> injects \the [H] with \the [src].", SPAN_NOTICE("You inject \the [H] with \the [src]."))
		user.do_attack_animation(H, src)
		H.add_nanomachines(preloaded_programs)
		spent = TRUE
		update_icon()

/obj/item/nanomachine_injector/update_icon()
	icon_state = "[initial(icon_state)][!spent]"

// debug injector
/obj/item/nanomachine_injector/armstrong
	name_label = "Armstrong"
	preloaded_programs = list(/decl/nanomachine_effect/nanomachines_son)