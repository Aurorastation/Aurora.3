/singleton/grab/normal/kill
	name = "strangle"
	downgrade = /singleton/grab/normal/neck
	shift = 0
	point_blank_mult = 2
	damage_stage = 3
	grab_flags = GRAB_STOP_MOVE | GRAB_REVERSE_FACING | GRAB_SHARE_TILE | GRAB_FORCE_HARM | GRAB_RESTRAINS | GRAB_DOWNGRADE_ACT | GRAB_DOWNGRADE_MOVE
	grab_text_state = "kill"
	grab_color = "#E80000"
	grab_special_state = "grab_flash"
	break_chance_table = list(5, 20, 40, 80, 100)

	action_verb = "strangling"

/singleton/grab/normal/kill/process_effect(var/obj/item/grab/G)
	var/mob/living/grabbed = G.get_grabbed_mob()
	if(!istype(grabbed))
		return

	grabbed.drop_held_items()
	grabbed.adjustOxyLoss(1)
	grabbed.stuttering = max(grabbed.stuttering, 5)
	grabbed.Weaken(5)
	var/datum/species/grabbed_species = grabbed.get_species()
	if(!HAS_TRAIT(grabbed, TRAIT_NO_BREATHE) || (grabbed_species && !(grabbed_species.flags & NO_BREATHE)))
		grabbed.losebreath += 3
