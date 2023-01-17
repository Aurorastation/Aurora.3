/obj/item/organ/internal/eyes/night
	name = "light sensitive eyes"
	desc = "A pair of Tajaran eyes accustomed to the low light conditions of Adhomai."
	icon = 'icons/obj/organs/tajara_organs.dmi'
	action_button_name = "Activate Low Light Vision"
	default_action_type = /datum/action/item_action/organ/night_eyes
	relative_size = 8
	var/night_vision = FALSE
	var/datum/client_color/vision_color = /datum/client_color/monochrome
	var/datum/client_color/vision_mechanical_color = /datum/client_color/monochrome
	var/eye_emote = "'s eyes dilate!"
	var/allowed_model = PROSTHETIC_TESLA //what robotic model allows this eyes to use the night vision

/obj/item/organ/internal/eyes/night/Destroy()
	disable_night_vision()
	. = ..()

/obj/item/organ/internal/eyes/night/removed(var/mob/living/carbon/human/target)
	. = ..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/replaced()
	. = ..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/attack_self(var/mob/user)
	. = ..()
	if(owner.last_special > world.time)
		return

	if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
		return

	if(is_broken())
		return

	if(status & ORGAN_ROBOT)
		if(!robotic_check())
			return

	if(!night_vision)
		enable_night_vision()
	else
		disable_night_vision()

	owner.last_special = world.time + 20

/obj/item/organ/internal/eyes/night/proc/robotic_check(var/mob/user)
	if(robotize_type == allowed_model)
		return TRUE
	else
		return FALSE

/obj/item/organ/internal/eyes/night/take_damage(var/amount, var/silent = 0)
	. = ..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/take_internal_damage(var/amount, var/silent = 0)
	..()
	disable_night_vision()

/obj/item/organ/internal/eyes/night/flash_act()
	if(!owner)
		return

	if(night_vision)
		to_chat(owner, SPAN_WARNING("Your eyes burn with the intense light of the flash!"))
		owner.Weaken(5)
		disable_night_vision()
		owner.last_special = world.time + 100

/obj/item/organ/internal/eyes/night/proc/can_change_invisible()
	if(owner.client && ((owner.client.view != world.view) || (owner.client.pixel_x != 0) || (owner.client.pixel_y != 0))) //using binoculars
		return FALSE
	if(owner.machine && owner.machine.check_eye(owner) >= 0 && owner.client.eye != owner) //using cameras
		return FALSE
	return TRUE

/obj/item/organ/internal/eyes/night/proc/enable_night_vision()
	if(!owner)
		return
	if(night_vision)
		return
	var/show_message = TRUE
	for(var/obj/item/protection in list(owner.head, owner.wear_mask, owner.glasses))
		if((protection && (protection.body_parts_covered & EYES)))
			show_message = FALSE
			break
	if(show_message && eye_emote)
		owner.visible_message("<b>[owner]</b>[eye_emote]")

	night_vision = TRUE
	if(can_change_invisible())
		owner.set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	if(status & ORGAN_ROBOT)
		if(vision_mechanical_color)
			owner.add_client_color(vision_mechanical_color)
	else
		if(vision_color)
			owner.add_client_color(vision_color)

/obj/item/organ/internal/eyes/night/proc/disable_night_vision()
	if(!owner)
		return
	if(!night_vision)
		return
	night_vision = FALSE
	if(can_change_invisible())
		owner.set_see_invisible(SEE_INVISIBLE_LIVING)
	if(status & ORGAN_ROBOT)
		if(vision_mechanical_color)
			owner.remove_client_color(vision_mechanical_color)
	else
		if(vision_color)
			owner.remove_client_color(vision_color)

/obj/item/organ/internal/stomach/tajara
	name = "reinforced stomach"
	desc = "A Tajara stomach adapted to help the body conserve energy during digestion."
	icon = 'icons/obj/organs/tajara_organs.dmi'
	stomach_volume = 80

/obj/item/organ/internal/lungs/tajara
	name = "insulated lungs"
	desc = "A pair of Tajaran lungs that help preserve the warmth of the air while breathing."
	icon = 'icons/obj/organs/tajara_organs.dmi'

/obj/item/organ/internal/liver/tajara
	desc = "An alien liver capable of filtering Adhomian toxins and chemicals."
	icon = 'icons/obj/organs/tajara_organs.dmi'

/obj/item/organ/internal/heart/tajara
	desc = "A robust heart capable of helping to preserve body temperature through blood circulation."
	icon = 'icons/obj/organs/tajara_organs.dmi'

/obj/item/organ/internal/heart/tajara/tesla_body
	on_mob_icon = 'icons/mob/human_races/tesla_body_augments.dmi'

/obj/item/organ/internal/kidneys/tajara
	desc = "Alien kidneys adapted to the Tajaran physiology."
	icon = 'icons/obj/organs/tajara_organs.dmi'

/obj/item/organ/internal/brain/tajara
	icon = 'icons/obj/organs/tajara_organs.dmi'

/obj/item/organ/internal/appendix/tajara
	name = "fat reservoir"
	icon = 'icons/obj/organs/tajara_organs.dmi'
	desc = "An Adhomian organ that stores fat and nutrients for the winter."
	possible_modifications = list("Normal","Assisted","Mechanical", "Removed")
