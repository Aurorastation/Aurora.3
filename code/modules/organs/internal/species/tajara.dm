/obj/item/organ/internal/eyes/night
	name = "light sensitive eyes"
	desc = "Tajaran eyes adapted to low light conditions of Adhomai."
	icon_state = "tajaran_eyes"
	action_button_name = "Activate Low Light Vision"
	var/night_vision = FALSE

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
		action.button_icon_state = "augment"
		if(action.button)
			action.button.update_icon()

/obj/item/organ/internal/eyes/night/attack_self(var/mob/user)
	. = ..()
	if(owner.last_special > world.time)
		return

	if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
		return

	if(is_broken())
		return

	if((status & ORGAN_ROBOT))
		return

	if(!night_vision)
		enable_night_vision()
	else
		disable_night_vision()

	owner.last_special = world.time + 20

/obj/item/organ/internal/eyes/night/flash_act()
	if(!owner)
		return

	to_chat(owner, "<span class='warning'>Your eyes burn with the intense light of the flash!</span>")
	owner.Weaken(5)
	disable_night_vision()
	owner.last_special = world.time + 100

/obj/item/organ/internal/eyes/night/proc/enable_night_vision()
	if(!owner)
		return
	if(night_vision)
		return
	night_vision = TRUE
	owner.stop_sight_update = TRUE
	owner.see_invisible = SEE_INVISIBLE_NOLIGHTING
	owner.add_client_color(/datum/client_color/monochrome)
	owner.regenerate_icons()

/obj/item/organ/internal/eyes/night/proc/disable_night_vision()
	if(!owner)
		return
	if(!night_vision)
		return
	night_vision = FALSE
	owner.stop_sight_update = FALSE
	owner.remove_client_color(/datum/client_color/monochrome)
	owner.regenerate_icons()

/obj/item/organ/internal/stomach/tajara
	name = "reinforced stomach"
	desc = "A robust stomach adapted to aid in the conservation of energy by the body."
	icon_state = "tajaran_stomach"
	stomach_volume = 80

/obj/item/organ/internal/lungs/tajara
	name = "insulated lungs"
	desc = "Tajaran lungs adapted to handle the cold air of Adhomai."
	icon_state = "tajaran_lungs"

/obj/item/organ/internal/liver/tajara
	desc = "An alien liver adapted to handle Adhomian toxins and other chemicals."
	icon_state = "tajaran_liver"

/obj/item/organ/internal/heart/tajara
	desc = "A robust heart adapted to aid in the conservation of body temperature."
	icon_state = "tajaran_heart"

/obj/item/organ/internal/kidneys/tajara
	desc = "Alien kidneys adapted to the Tajaran physiology."
	icon_state = "tajaran_kidneys"

/obj/item/organ/internal/brain/tajara
	icon_state = "tajaran_brain"