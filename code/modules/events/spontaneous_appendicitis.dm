/datum/event/spontaneous_appendicitis
	no_fake = 1

/datum/event/spontaneous_appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		if((H.client && H.stat != DEAD) && (!player_is_antag(H.mind)))
			var/obj/item/organ/internal/appendix/A = H.internal_organs_by_name[BP_APPENDIX]
			if(!istype(A) || (A && A.inflamed && !(A.status & ORGAN_ROBOT)))
				continue
			A.inflamed = 1
			A.update_icon()
			break