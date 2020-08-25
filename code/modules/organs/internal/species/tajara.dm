/obj/item/organ/internal/eyes/night
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
	glowy_eyes = TRUE
	owner.regenerate_icons()

/obj/item/organ/internal/eyes/night/proc/disable_night_vision()
	if(!owner)
		return
	if(!night_vision)
		return
	night_vision = FALSE
	owner.stop_sight_update = FALSE
	owner.remove_client_color(/datum/client_color/monochrome)
	glowy_eyes = FALSE
	owner.regenerate_icons()