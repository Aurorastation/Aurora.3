#define STRONG_BITE "HHH"

/datum/martial_art/zombie
	name = "Zombie"
	help_verb = /datum/martial_art/zombie/proc/zombie_help
	no_guns = TRUE
	no_guns_message = "A zombie cannot use a gun."

/datum/martial_art/zombie/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak, STRONG_BITE))
		streak = ""
		strong_bite(A, D)
		return TRUE
	return FALSE

/datum/martial_art/zombie/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H", D)
	if(check_streak(A, D))
		return TRUE
	basic_hit(A, D)
	return TRUE

/datum/martial_art/zombie/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	addtimer(CALLBACK(src, .proc/check_grab, A), 5) // grabs don't appear instantly, so we need to wait a bit

/datum/martial_art/zombie/proc/check_grab(var/mob/living/carbon/human/A)
	var/obj/item/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE
		G.icon_state = "grabbed1"
		G.hud.icon_state = "reinforce1"

/datum/martial_art/zombie/proc/strong_bite(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	var/atk_verb = pick("chomps", "bites")
	D.visible_message(SPAN_DANGER("[A] [atk_verb] down hard on [D]!"), SPAN_DANGER("[A] [atk_verb] down hard on you!"))
	D.apply_damage(rand(5, 10), BRUTE, damage_flags = DAM_SHARP)
	playsound(get_turf(D), 'sound/weapons/slash.ogg', 25, 1, -1)
	return TRUE

/datum/martial_art/zombie/proc/zombie_help()
	set name = "Recall Zombie Combat"
	set desc = "Remember the martial techniques of the zombie horde."
	set category = "Abilities"

	to_chat(usr, "<b><i>You moan inside yourself, grasping knowledge unknown to the living...</i></b>")
	to_chat(usr, "<span class='notice'>Strong Bite</span>: Harm Harm Harm. Delivers a strong bite to your foe, piercing through any armor they may have.")
	to_chat(usr, "<span class='notice'>Strong Grip</span>: Grab. While weak, your ravenous lust for living flesh allows you to instantly get an aggressive grab on anyone you catch.")

#undef STRONG_BITE