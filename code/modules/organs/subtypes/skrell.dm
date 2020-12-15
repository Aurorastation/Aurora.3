/obj/item/organ/internal/heart/skrell
	icon_state = "skrell_heart-on"
	dead_icon = "skrell_heart-off"

/obj/item/organ/internal/lungs/skrell
	icon_state = "lungs_skrell"

/obj/item/organ/internal/kidneys/skrell
	icon_state = "kidney_skrell"

/obj/item/organ/internal/eyes/skrell
	icon_state = "eyes_skrell"

/obj/item/organ/internal/liver/skrell
	icon_state = "liver_skrell"

/obj/item/organ/internal/brain/skrell
	icon_state = "brain_skrell"

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