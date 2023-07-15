/mob/living/simple_animal/capybara
	name = "capybara"
	real_name = "capybara"
	desc = "A brown capybara, being relaxed as usual."
	desc_extended = "Capybaras, or as they are also known as \"coconut dogs\" (despite them not having anything in common with dogs or coconuts for that matter) are an invasive species originally from Sol,\
	later prospering on Biesel. Some way or another, whereever humans went Capybaras were brought along, for their meat and hides. Their survival tactics consist of being so relaxed and uninvested in anything,\
	that they appear just too uninteresting for predators."
	icon = 'icons/mob/npc/coconut_dog.dmi'
	icon_state = "coconut"
	icon_living = "coconut"
	icon_dead = "coconut_dead"
	icon_rest = "coconut_rest"
	can_nap = TRUE
	speak = list("Squeek.", "Squeeeeeeeeek!")
	speak_emote = list("squeeks", "grunts")
	emote_hear = list("squeeks", "grunts", "yawns")
	emote_see = list("vibes", "sniffs around", "looks around", "flops it's ears")
	speak_chance = 1
	turns_per_move = 10
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "punches"
	mob_size = 5

/mob/living/simple_animal/capybara/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == I_HELP && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] pets [src].</span>","<span class='notice'>You eagerly pet [src].</span>")
		Weaken(30)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(	"[src] doesn't even look at you.",
											"[src] is not disturbed in it's relaxation.",
											"[src] looks at you with a satisfied look.",
											"[src] accepted it's fate to receive pets.")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/capybara/examine(mob/user)
	..()
	if(stat == DEAD)
		to_chat(user, "How can someone kill such a friendly creature?")
