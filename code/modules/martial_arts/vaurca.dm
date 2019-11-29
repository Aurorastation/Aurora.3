#define PIERCING_STRIKE "DHH"
#define SWIFT_BITE "DDG"
#define CRUSHING_JAWS "HHDG"

/datum/martial_art/vkutet
	name = "Vk'utet"
	help_verb = /datum/martial_art/vkutet/proc/vkutet_help

/datum/martial_art/vkutet/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,PIERCING_STRIKE))
		streak = ""
		piercing_strike(A,D)
		return 1
	if(findtext(streak,SWIFT_BITE))
		streak = ""
		swift_bite(A,D)
		return 1
	if(findtext(streak,CRUSHING_JAWS))
		streak = ""
		crushing_jaws(A,D)
		return 1
	return 0

/datum/martial_art/vkutet/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	D.grabbedby(A,1)
	return 1

/datum/martial_art/vkutet/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/vkutet/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/vkutet/proc/piercing_strike(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!isvaurca(A))
		return 0
	A.do_attack_animation(D)
	var/atk_verb = pick("slices", "pinches", "chops", "bites", "claws")
	D.visible_message("<span class='danger'>[A] [atk_verb] [D]!</span>", \
					  "<span class='danger'>[A] [atk_verb] you!</span>")
	D.apply_damage(rand(5,15), BRUTE, sharp = TRUE)
	playsound(get_turf(D), 'sound/weapons/slash.ogg', 25, 1, -1)

	return 1

/datum/martial_art/vkutet/proc/swift_bite(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.grabbedby(A,1)
	if(istype(A.get_active_hand(),/obj/item/grab))
		var/obj/item/grab/G = A.get_active_hand()
		if(G && G.affecting == D)
			G.state = GRAB_AGGRESSIVE
			D.visible_message("<span class='danger'>[A] gets a strong grip on [D]!</span>")
			if(isvaurca(A))
				A.bugbite()
				qdel(G)
	return 1

/datum/martial_art/vkutet/proc/crushing_jaws(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!isvaurca(A))
		return 0
	D.grabbedby(A,1)
	if(istype(A.get_active_hand(),/obj/item/grab))
		var/obj/item/grab/G = A.get_active_hand()
		if(G && G.affecting == D)
			var/armor_block = D.run_armor_check(null, "melee")
			A.visible_message("<span class='warning'>[A] crushes [D] with its mandibles!</span>")
			D.apply_damage(30, BRUTE, null, armor_block)
			D.apply_effect(6, WEAKEN, armor_block)
			qdel(G)
	return 1

/datum/martial_art/vkutet/proc/vkutet_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Vk'utet."
	set category = "Vk'utet"

	to_chat(usr, "<b><i>You chitter deeply and remember the indoctrination...</i></b>")
	to_chat(usr, "<span class='notice'>Piercing Strike</span>: Disarm Harm Harm. Slashes your victim, bypassing their armor and causing bleeding.")
	to_chat(usr, "<span class='notice'>Swift Bite</span>: Disarm Disarm Grab. Quickly grabs your victim and bites them with your mandibles.")
	to_chat(usr, "<span class='notice'>Crushing Jaws</span>: Harm Harm Disarm Grab. Grabs your victim and violently crushes them with your mandibles, inflicting heavy damage.")

/obj/item/martial_manual/vaurca
	name = "vk'utet data disk"
	desc = "A data disk containing information about the vaurca fighting technice know as Vk'utet."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "harddisk"
	martial_art = /datum/martial_art/vkutet