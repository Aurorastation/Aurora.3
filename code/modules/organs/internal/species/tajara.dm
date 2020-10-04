/obj/item/organ/internal/eyes/night
	name = "light sensitive eyes"
	desc = "A pair of Tajaran eyes accustomed to the low light conditions of Adhomai."
	icon_state = "tajaran_eyes"
	action_button_name = "Activate Low Light Vision"
	relative_size = 8
	var/night_vision = FALSE
	var/datum/client_color/vision_color = /datum/client_color/monochrome
	var/eye_emote = "'s eyes dilate!"

/obj/item/organ/internal/eyes/night/Destroy()
	disable_night_vision()
	. = ..()

/obj/item/organ/internal/eyes/night/removed(var/mob/living/carbon/human/target)
	. = ..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/replaced()
	. = ..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "night_eyes"
		if(action.button)
			action.button.update_icon()

/obj/item/organ/internal/eyes/night/attack_self(var/mob/user)
	. = ..()
	if(owner.last_special > world.time)
		return

	if(use_check(user, USE_ALLOW_NON_ADJACENT))
		return

	if(is_broken())
		return

	if(status & ORGAN_ROBOT)
		return

	if(!night_vision)
		enable_night_vision()
	else
		disable_night_vision()

	owner.last_special = world.time + 20

/obj/item/organ/internal/eyes/night/take_damage(var/amount, var/silent = 0)
	..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/take_internal_damage(var/amount, var/silent = 0)
	..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/flash_act()
	if(!owner)
		return

	to_chat(owner, SPAN_WARNING("Your eyes burn with the intense light of the flash!"))
	owner.Weaken(5)
	disable_night_vision()
	owner.last_special = world.time + 100

/obj/item/organ/internal/eyes/night/proc/enable_night_vision()
	if(!owner)
		return
	if(night_vision)
		return
	var/show_message = TRUE
	for(var/obj/item/protection in list(owner.head, owner.wear_mask, owner.glasses))
		if((protection && (protection.body_parts_covered & EYES)))
			break
			show_message = FALSE
	if(show_message && eye_emote)
		owner.emote("me", 1, eye_emote)

	night_vision = TRUE
	owner.stop_sight_update = TRUE
	owner.see_invisible = SEE_INVISIBLE_NOLIGHTING
	owner.add_client_color(vision_color)

/obj/item/organ/internal/eyes/night/proc/disable_night_vision()
	if(!owner)
		return
	if(!night_vision)
		return
	night_vision = FALSE
	owner.stop_sight_update = FALSE
	owner.remove_client_color(vision_color)

/obj/item/organ/internal/stomach/tajara
	name = "reinforced stomach"
	desc = "A Tajara stomach adapted to help the body conserve energy during digestion."
	icon_state = "tajaran_stomach"
	stomach_volume = 80

/obj/item/organ/internal/lungs/tajara
	name = "insulated lungs"
	desc = "A pair of Tajaran lungs that help preserve the warmth of the air while breathing."
	icon_state = "tajaran_lungs"

/obj/item/organ/internal/liver/tajara
	desc = "An alien liver capable of filtering Adhomian toxins and chemicals."
	icon_state = "tajaran_liver"

/obj/item/organ/internal/heart/tajara
	desc = "A robust heart capable of helping to preserve body temperature through blood circulation."
	icon_state = "tajaran_heart"
	dead_icon = "tajaran_heart"

/obj/item/organ/internal/kidneys/tajara
	desc = "Alien kidneys adapted to the Tajaran physiology."
	icon_state = "tajaran_kidneys"

/obj/item/organ/internal/brain/tajara
	icon_state = "tajaran_brain"

/obj/item/organ/internal/appendix/tajara
	name = "fat reservoir"
	icon_state = "tajaran_appendix"
	desc = "An Adhomian organ that stores fat and nutrients for the winter."
