/obj/item/organ/internal/augment/sightlights
	name = "ocular installed sightlights "
	desc = "Designed to assist medical personnel in darker areas or places experiencing periodic power issues, " \
		+ "Sightlights will allow one to be able to use their eyes as a flashlight."
	icon_state = "sightlights"
	organ_tag = BP_AUG_SIGHTLIGHTS
	parent_organ = BP_HEAD
	action_button_name = "Activate Ocular Installed Sightlights "
	action_button_icon = "sightlights"
	cooldown = 30
	activable = TRUE
	var/lights_on = FALSE

/obj/item/organ/internal/augment/sightlights/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	lights_on = !lights_on

	if(lights_on)
		set_light(5, 2, LIGHT_COLOR_TUNGSTEN, uv = 0, angle = LIGHT_WIDE)
	else
		set_light(0)

/obj/item/organ/internal/augment/sightlights/emp_act(severity)
	. = ..()
	set_light(0)

/obj/item/organ/internal/augment/sightlights/take_damage(var/amount, var/silent = 0)
	. = ..()
	set_light(0)

/obj/item/organ/internal/augment/sightlights/take_internal_damage(var/amount, var/silent = 0)
	. = ..()
	set_light(0)
