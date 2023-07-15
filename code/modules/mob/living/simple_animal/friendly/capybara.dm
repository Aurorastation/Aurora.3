/mob/living/simple_animal/capybara
	name = "capybara"
	real_name = "capybara"
	desc = "A brown capybara, or a \"coconut dog\", being relaxed as usual."
	icon = 'icons/mob/npc/coconut_dog.dmi'
	icon_state = "coconut"
	icon_living = "coconut"
	icon_dead = "coconut_dead"
	icon_rest = "coconut_rest"
	can_nap = 1
	speak = list("Squeek.", "Squeeeeeeeeek!")
	speak_emote = list("squeeks", "grunts")
	emote_hear = list("squeeks", "grunts", "yawns")
	emote_see = list("vibes", "sniffs around", "looks around", "flops it's ears")
	speak_chance = 1
	turns_per_move = 0.5
	min_oxy = 16
	minbodytemp = 223
	maxbodytemp = 323
	max_nutrition = 80
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "punches"
	mob_size = 7

/mob/living/simple_animal/capybara/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == I_HELP && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] pets [src].</span>","<span class='notice'>You eagerly pet [src].</span>")
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(	"[src] looks content.",
											"[src] is not disturbed in its relaxation.",
											"[src] looks at you with a satisfied look.",
											"[src] has accepted its fate to receive pets.")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/capybara/examine(mob/user)
	..()
	if(stat == DEAD)
		to_chat(user, "How can someone kill such a friendly creature?")
