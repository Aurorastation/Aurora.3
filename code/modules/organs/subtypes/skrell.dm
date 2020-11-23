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

/obj/item/storage/internal/skrell
	name = "headtail storage"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "skrell_headpocket"
	storage_slots = 1
	max_storage_space = 2
	max_w_class = ITEMSIZE_SMALL
	use_sound = null
	action_button_name = "Headtail Pocket"

/obj/item/storage/internal/skrell/Initialize()
	. = ..()
	name = initial(name)

/obj/item/storage/internal/skrell/attack_self(mob/user)
	open(user)