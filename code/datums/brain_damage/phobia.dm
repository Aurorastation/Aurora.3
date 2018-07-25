/datum/brain_trauma/organic/mild/phobia
	name = "Phobia"
	desc = "Patient is unreasonably afraid of something."
	scan_desc = "phobia"
	gain_text = ""
	lose_text = ""

/datum/brain_trauma/organic/mild/phobia/New(mob/living/carbon/C, _permanent, specific_type)
	..()
	gain_text = "<span class='warning'>You start finding [trigger_type] very unnerving...</span>"
	lose_text = "<span class='notice'>You no longer feel afraid of [trigger_type].</span>"
	scan_desc += " of [trigger_type]"

/datum/brain_trauma/organic/mild/phobia/on_gain(atom/reason, trigger_word)
	special_check = world.time + 120
	var/reaction = rand(1,4)
	owner.emote("scream")
	switch(reaction)
		if(1)
			to_chat(owner, "<span class='warning'>You are paralyzed with fear!</span>")
			owner.Stun(15)
			owner.Jitter(15)
		if(2)
			owner.Jitter(5)
			owner.say("AAARRRGGGH!!")
			if(reason)
				owner.pointed(reason)
		if(3)
			to_chat(owner, "<span class='warning'>You shut your eyes in terror!</span>")
			owner.Jitter(5)
			owner.eye_blind += 10
		if(4)
			owner.dizziness += 10
			owner.confused += 10
			owner.Jitter(10)
			owner.stuttering += 10