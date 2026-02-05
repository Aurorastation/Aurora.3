GLOBAL_DATUM(actors, /datum/antagonist/actor)

/datum/antagonist/actor
	id = MODE_ACTOR
	role_text = "Actor"
	role_text_plural = "Actors"
	welcome_text = "You are an actor. Your role is to provide an interesting roleplay scenario for the crew. You may use your scenario's guidelines, or \
					agree with everyone else to play something different. Your creativity is the limit! Remember that you are an antagonist, and so you have \
					all the freedoms an antagonist does."
	faction = "actor"
	landmark_id = "ActorSpawnLandmark"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_NO_FLAVORTEXT
	hard_cap = 10
	hard_cap_round = 15
	initial_spawn_req = 2 // Needs to be set to 2 to allow it to show as a group antag on the lobby setup screen.

	bantype = "actor"

	faction_verbs = list(
		/mob/living/carbon/human/proc/odyssey_panel
	)

/datum/antagonist/actor/New()
	..()
	GLOB.actors = src

/datum/antagonist/actor/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	if(SSodyssey?.scenario)
		player.preEquipOutfit(SSodyssey.scenario.default_outfit, FALSE)
		player.equipOutfit(SSodyssey.scenario.default_outfit, FALSE)

	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	return TRUE

/obj/effect/landmark/actor_spawn
	name = "ActorSpawnLandmark"

/mob/living/carbon/human/proc/odyssey_panel()
	set name = "Odyssey Panel"
	set category = "Actor"

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr
	if(H.incapacitated())
		return

	SSodyssey.ui_interact(H)

