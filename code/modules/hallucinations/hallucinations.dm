#define NO_THOUGHT 1	//Hallucinated thoughts will not occur on this hallucination's end()
#define NO_EMOTE 2		//User will not emote to others when this hallucination ends
#define HEARING_DEPENDENT 4	//deaf characters will not experience this hallucination

//Power Defines
#define HAL_POWER_LOW 30
#define HAL_POWER_MED 50
#define HAL_POWER_HIGH 70

/datum/hallucination
	var/mob/living/carbon/holder	//Who is hallucinating?
	var/allow_duplicates = TRUE		//This is set to false for hallucinations with long durations or ones we do not want repeated for a time
	var/duration = 10				//how long before we call end()
	var/min_power = 0 				//mobs only get this hallucination at this threshold
	var/max_power = INFINITY		//mobs don't get this hallucination if it's above this threshold. Used to weed out more common ones if you're super fucked up
	var/special_flags				//Any special flags, defined above

/datum/hallucination/proc/start()

/datum/hallucination/proc/end()
	if(holder)
		if(!(special_flags & NO_THOUGHT))
			holder.hallucination_thought()
		if(!(special_flags & NO_EMOTE))
			hallucination_emote(holder)		//Always a chance to involuntarily emote to others as if on drugs
		holder.hallucinations -= src
	qdel(src)

//Used to verify if a hallucination can be added to the list of candidates
/datum/hallucination/proc/can_affect(mob/living/carbon/C)
	if(!C.client)
		return FALSE
	if(!allow_duplicates && (locate(type) in C.hallucinations))
		return FALSE
	if(min_power > C.hallucination || max_power < C.hallucination)
		return FALSE
	if((special_flags & HEARING_DEPENDENT) && (C.disabilities & DEAF))
		return FALSE
	return TRUE

/datum/hallucination/Destroy()
	holder = null
	return ..()

//The actual kickoff to each effect
/datum/hallucination/proc/activate()
	if(!holder || !holder.client)
		return
	holder.hallucinations += src
	start()
	addtimer(CALLBACK(src, .proc/end), duration)

//You emoting to others involuntarily. This happens mostly in end()
/datum/hallucination/proc/hallucination_emote()	
	if(prob(min(holder.hallucination - 5, 80)) && !holder.stat)
		var/chosen_emote = pick(SShallucinations.hal_emote)
		if(prob(10))										//You are aware of it in this instance
			holder.visible_message("<B>[holder]</B> [chosen_emote]")
		else
			for(var/mob/M in oviewers(world.view, holder))	//Only shows to others, not you; you're not aware of what you're doing. Could prompt others to ask if you're okay, and lead to confusion.
				to_chat(M, "<B>[holder]</B> [chosen_emote]")
