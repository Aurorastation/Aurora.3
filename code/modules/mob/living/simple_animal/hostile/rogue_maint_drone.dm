/mob/living/simple_animal/hostile/rogue_drone
	name = "maintenance drone"
	desc = "A small robot. It looks angry."
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	blood_type = COLOR_OIL
	speak = list("Removing organic waste.", "Pest control in progress.", "Engaging self-preservation protocols.", "Moving to eject unauthorized personnel.")
	speak_emote = list("blares", "buzzes", "beeps")
	speak_chance = 1
	universal_speak = FALSE
	density = FALSE
	health = 50
	maxHealth = 50
	melee_damage_lower = 5
	melee_damage_upper = 8
	armor_penetration = 5
	attacktext = "sliced"
	faction = "silicon"
	min_oxy = 0
	minbodytemp = 0
	speed = 4
	mob_size = MOB_TINY
	var/image/eye_overlay

	psi_pingable = FALSE

/mob/living/simple_animal/hostile/rogue_drone/Initialize()
	. = ..()
	name = "[initial(name)] ([rand(100, 999)])"
	eye_overlay = image(icon, "[icon_state]-eyes_emag", layer = EFFECTS_ABOVE_LIGHTING_LAYER)
	eye_overlay.appearance_flags = KEEP_APART
	add_overlay(eye_overlay)

/mob/living/simple_animal/hostile/rogue_drone/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(.)
		if(istype(mover, /mob/living/simple_animal/hostile/rogue_drone))
			return FALSE

/mob/living/simple_animal/hostile/rogue_drone/death()
	..(null, "blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/rogue_drone/validator_living(var/mob/living/L, var/atom/current)
	. = ..()
	if(.)
		if(issilicon(L))
			return FALSE
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.isSynthetic() && !H.isShell())
				return FALSE
			if(istype(H.head, /obj/item/holder/drone))
				return FALSE
			if(istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg))
				return FALSE
