//Look Sir, free crabs!
/datum/ai_holder/simple_animal/passive/crab
	wander = FALSE
	var/next_crab_move = 0

/datum/ai_holder/simple_animal/passive/crab/handle_special_tactic()
	var/mob/living/simple_animal/crab/crab = holder
	crab.regenerate_icons()

/datum/ai_holder/simple_animal/passive/crab/handle_special_strategical()
	if(stance != AI_STANCE_IDLE || world.time < next_crab_move || !holder.AICanMove())
		return
	holder.AIMove(get_step(holder, pick(EAST, WEST)))
	next_crab_move = world.time + 5 SECONDS

/mob/living/simple_animal/crab
	ai_holder_type = /datum/ai_holder/simple_animal/passive/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"
	mob_size = MOB_SMALL
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/crabmeat
	organ_names = list("head", "carapace")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	stop_automated_movement = 1
	friendly = "pinches"
	hunger_enabled = 0
	var/obj/item/inventory_head
	var/obj/item/inventory_mask
	possession_candidate = 1
