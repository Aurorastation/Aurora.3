/obj/item/organ/internal/heart/skrell
	icon = 'icons/obj/organs/skrell_organs.dmi'

/obj/item/organ/internal/lungs/skrell
	icon = 'icons/obj/organs/skrell_organs.dmi'

/obj/item/organ/internal/kidneys/skrell
	icon = 'icons/obj/organs/skrell_organs.dmi'

/obj/item/organ/internal/eyes/skrell
	icon = 'icons/obj/organs/skrell_organs.dmi'

/obj/item/organ/internal/liver/skrell
	icon = 'icons/obj/organs/skrell_organs.dmi'

/obj/item/organ/internal/brain/skrell
	icon = 'icons/obj/organs/skrell_organs.dmi'

/obj/item/organ/external/head/skrell
	var/obj/item/storage/internal/skrell/storage
	action_button_name = "Headtail Pocket"

/obj/item/organ/external/head/skrell/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, .proc/setup_storage), 3 SECONDS)

/obj/item/organ/external/head/skrell/proc/setup_storage()
	storage = new /obj/item/storage/internal/skrell(src)
	if(owner)
		storage.color = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
	refresh_action_button()

/obj/item/organ/external/head/skrell/refresh_action_button()
	. = ..()
	if(. && storage)
		action.button_icon_state = storage.icon_state
		action.button_icon_color = storage.color
		if(action.button)
			action.button.update_icon()

/obj/item/organ/external/head/skrell/removed()
	. = ..()
	for(var/thing in storage)
		storage.remove_from_storage(thing, get_turf(src))

/obj/item/organ/external/head/skrell/attack_self(mob/user)
	storage.open(user)

/obj/item/organ/internal/heart/skrell/neaera

/obj/item/organ/internal/lungs/skrell/neaera

/obj/item/organ/internal/kidneys/skrell/neaera

/obj/item/organ/internal/eyes/skrell/neaera

/obj/item/organ/internal/liver/skrell/neaera

/obj/item/organ/internal/brain/skrell/neaera