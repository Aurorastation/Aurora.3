/obj/item/organ/internal/augment/sightlights
	name = "offbrand ocular sightlights"
	desc = "Designed to assist personnel in darker areas or places experiencing periodic power issues, Zeng-Hu sightlights will allow one to be able to use their eyes as a flashlight. Later SCC-mediated negotiation loosened the augment's patent restrictions, allowing offbrand manufacture and use of lesser models by other members of the Chainlink."
	icon_state = "m2eyes"
	action_button_name = "Activate Ocular Installed Sightlights "
	action_button_icon = "sightlights"
	activable = TRUE
	organ_tag = BP_AUG_SIGHTLIGHTS
	parent_organ = BP_HEAD
	cooldown = 30

	var/lights_on = FALSE
	var/lights_color = LIGHT_COLOR_TUNGSTEN
	var/lights_range = 4
	var/lights_intensity = 2

/obj/item/organ/internal/augment/sightlights/zenghu
	name = "Zeng-Hu ocular sightlights"
	desc = "Designed to assist Zeng-Hu medical personnel in darker areas or places experiencing periodic power issues, sightlights will allow one to be able to use their eyes as a flashlight. These are the original high-spec models available exclusively through Zeng-Hu."
	icon_state = "sightlights"
	lights_color = "#e9dfea" // Pale violet, very Zeng-Hu.
	lights_range = 6
	lights_intensity = 2

/obj/item/organ/internal/augment/sightlights/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	lights_on = !lights_on

	if(lights_on)
		set_light(lights_range, lights_intensity, lights_color, uv = 0, angle = LIGHT_WIDE)
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
