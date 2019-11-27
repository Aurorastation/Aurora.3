/mob/living/carbon/human
	var/mob/living/carbon/human/vr_mob = null // Where is our actual brain currently?

// Handles saving of the original mob and assigning the new mob
/mob/living/carbon/human/proc/mind_swap(var/mob/living/carbon/human/M, var/mob/living/carbon/human/target)
	// Ensure the original mob gets saved before we do anything
	if(M.client)
		M.client.holder.original_mob = M
	else
		return

	var/ckey = M.ckey
	M.vr_mob = target
	target.ckey = ckey
	M.ckey = "@[ckey]"
	target.verbs += /mob/living/carbon/human/proc/body_return

	to_chat(target, span("notice", "Connection established, system suite active and calibrated."))
	to_chat(target, span("warning", "To exit this mode, use the \"Return to Body\" verb in the IC tab."))

/mob/living/carbon/human/proc/body_return()
	set name = "Return to Body"
	set category = "IC"

	if(src.vr_mob)
		src.ckey = src.vr_mob.ckey
		src.vr_mob.ckey = null
		src.vr_mob = null
		to_chat(src, span("notice", "System exited safely, we hope you enjoyed your stay."))
	else if(src.client.holder.original_mob)
		var/mob/living/carbon/human/original = src.client.holder.original_mob
		original.ckey = src.ckey
		original.vr_mob = null
		src.ckey = null
		to_chat(original, span("notice", "System exited safely, we hope you enjoyed your stay."))
	else
		to_chat(src, span("danger", "Interface error, you cannot exit the system at this time."))
		to_chat(src, span("warning", "Ahelp to get back into your body, a bug has occurred."))