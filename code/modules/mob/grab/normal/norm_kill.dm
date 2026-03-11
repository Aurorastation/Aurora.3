/singleton/grab/normal/kill
	name = "strangle"
	downgrade = /singleton/grab/normal/neck
	shift = 0
	point_blank_mult = 2
	damage_stage = 3
	grab_flags = GRAB_STOP_MOVE | GRAB_REVERSE_FACING | GRAB_SHARE_TILE | GRAB_FORCE_HARM | GRAB_RESTRAINS | GRAB_DOWNGRADE_ACT | GRAB_DOWNGRADE_MOVE | GRAB_CAN_KILL | GRAB_FORCE_STAND
	grab_text_state = "kill"
	grab_color = "#E80000"
	grab_special_state = "grab_flash"
	break_chance_table = list(5, 20, 40, 80, 100)

	action_verb = "strangling"

	var/strangling = FALSE

/singleton/grab/normal/kill/process_effect(var/obj/item/grab/G)
	var/mob/living/grabbed = G.get_grabbed_mob()
	if(!istype(grabbed))
		strangling = FALSE
		return
	if(strangling)
		return

	grabbed.drop_held_items()
	grabbed.Stun(3)
	grabbed.stuttering = max(grabbed.stuttering, 5)
	grabbed.Weaken(7)
	var/datum/species/grabbed_species = grabbed.get_species(TRUE)
	if(!HAS_TRAIT(grabbed, TRAIT_NO_BREATHE) || (grabbed_species && !(grabbed_species.flags & NO_BREATHE)))
		grabbed.losebreath += max(grabbed.losebreath + 3, 5)
		grabbed.adjustOxyLoss(3)
		strangling = TRUE
		if(grabbed.stat == CONSCIOUS && do_mob(G.grabber, grabbed, 15 SECONDS))
			strangling = FALSE
			grabbed.visible_message(SPAN_WARNING("[grabbed] falls unconscious..."), FONT_LARGE(SPAN_DANGER("The world goes dark as you fall unconscious...")))
			grabbed.Paralyse(20)
	else if(istype(grabbed, /mob/living/simple_animal) && grabbed.stat != DEAD)
		grabbed.health -= 1
