/datum/species/procyn
    name = "Procyn"
    short_name = "proy"
    name_plural = "Procyoni"
    meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/proy
    holder_type = null//No icon yet
    icobase = 'icons/mob/human_races/r_proy.dmi'
    deform = 'icons/mob/human_races/r_proy.dmi'

    inherent_verbs = list(
        /mob/living/carbon/human/proc/leap,
        /mob/living/proc/hide,
        /mob/living/proc/ventcrawl
        )

    tail = null
    eyes = "blank_eyes"
    greater_form = null
    default_language = "Procyianoi"
    language = LANGUAGE_PROY
    hud_type = /datum/hud_data
    siemens_coefficient = 0.2
    gluttonous = 1
    stamina	=	190			  // Its a garbage rodent, they are fast ok?
    sprint_speed_factor = 3.2
    darksight = 7
    death_message = "whimpers faintly before falling to the ground, their eyes dead and lifeless..."
    halloss_message = "slumps to the ground, too weak to continue fighting."
    list/heat_discomfort_strings = list(
        "Your blood feels like its boiling.",
        "You feel uncomfortably warm.",
        "Your fur feels hot as the sun."
        )
    list/cold_discomfort_strings = list(
        "You shiver in the cold.",
        "Your flesh is ice to the touch."
        )
    cold_level_1 = 50
    cold_level_2 = -1
    cold_level_3 = -1
    brute_mod = 1.8
    oxy_mod = 0.8
    burn_mod = 1.3
    fall_mod = 0
    slowdown = -1
    has_fine_manipulation = 1
    natural_climbing = 1
    mob_size = 7
    climb_coeff = 0.35
    breakcuffs = list(MALE)
    hazard_low_pressure = -100
    spawn_flags = CAN_JOIN | IS_WHITELISTED