//	combo refence since wrestling uses a different format to sleeping carp and plasma fist.
//	Clinch "G"
//	Suplex "GD"
//	Advanced grab "G"

/datum/martial_art/wrestling
	name = "Wrestling"
	help_verb = /datum/martial_art/wrestling/proc/wrestling_help

/datum/martial_art/wrestling/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.grabbedby(A,1)
	var/obj/item/grab/G = A.get_active_hand()
	if(G && prob(50))
		G.state = GRAB_AGGRESSIVE
		D.visible_message("<span class='danger'>[A] has [D] in a clinch!</span>")
	else
		D.visible_message("<span class='danger'>[A] fails to get [D] in a clinch!</span>")
	return 1


/datum/martial_art/wrestling/proc/Suplex(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)

	D.visible_message("<span class='danger'>[A] suplexes [D]!</span>")
	D.forceMove(A.loc)
	D.apply_damage(30, BRUTE)
	D.apply_effect(6, WEAKEN)
	add_logs(A, D, "suplexed")

	A.SpinAnimation(10,1)

	D.SpinAnimation(10,1)
	spawn(3)
		A.apply_effect(4, WEAKEN)
	return

/datum/martial_art/wrestling/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(istype(A.get_inactive_hand(),/obj/item/grab))
		var/obj/item/grab/G = A.get_inactive_hand()
		if(G.affecting == D)
			Suplex(A,D)
			return 1
	harm_act(A,D)
	return 1

/datum/martial_art/wrestling/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.grabbedby(A,1)
	D.visible_message("<span class='danger'>[A] holds [D] down!</span>")
	var/obj/item/organ/external/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	D.apply_damage(40, PAIN, affecting)
	return 1

/datum/martial_art/wrestling/proc/wrestling_help()
	set name = "Recall Wrestling"
	set desc = "Remember how to wrestle."
	set category = "Abilities"

	to_chat(usr, "<b><i>You flex your muscles and have a revelation...</i></b>")
	to_chat(usr, "<span class='notice'>Clinch</span>: Grab. Passively gives you a chance to immediately aggressively grab someone. Not always successful.")
	to_chat(usr, "<span class='notice'>Suplex</span>: Disarm someone you are grabbing. Suplexes your target to the floor. Greatly injures them and leaves both you and your target on the floor.")
	to_chat(usr, "<span class='notice'>Advanced grab</span>: Grab. Passively causes pain when grabbing someone.")

/obj/item/martial_manual/wrestling
	name = "wrestling manual"
	desc = "A manual designated to teach the user about the art of wrestling."
	martial_art = /datum/martial_art/wrestling
