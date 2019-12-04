/datum/brain_trauma/corruption
	var/last_message

/datum/brain_trauma/corruption/ten
	name = "corruption_ten"
	desc = "Patient is showing signs of very unusual brain activity."
	scan_desc = "Unknown anomaly detected in patients brain. Severity: slight."
	gain_text = "<span class='notice'>You seem to have developed a slight, but very persistent headache.</span>"
	lose_text = "<span class='notice'>Everything feels normal again.</span>"

	var/list/messages = list(

	"You feel a light pain in your head.",
	"You feel another headache coming on.",
	"You feel a throbbing pain right behind your eyes.",
	"Your eyes feel dry and itchy, as if you haven't slept in days",
	"Did you hear something? Must have been the wind.",

	)

/datum/brain_trauma/corruption/ten/on_life()
	if(world.time - last_message > 300) // at least 5 min cooldown between messages
		if(prob(10)) //10% chance to get the message after cooldown is up
			to_chat(owner, span("notice", "[pick(messages)]")) //pick one of the messages and send as notice
	..()