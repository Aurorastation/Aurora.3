var/global/datum/controller/subsystem/ai_obfuscation/SSai_obfuscation

/datum/controller/subsystem/ai_obfuscation
	name = "AI Obfuscation"
	flags = SS_NO_FIRE

	var/list/image/obfuscation_images = list()

/datum/controller/subsystem/ai_obfuscation/New()
	NEW_SS_GLOBAL(SSai_obfuscation)

/datum/controller/subsystem/ai_obfuscation/proc/add_obfuscation_image(var/image/added_image)
	if(!istype(added_image))
		return
	obfuscation_images += added_image

	for(var/ai in ai_list)
		var/mob/living/silicon/ai/A = ai
		if(A.client)
			A.client.images += added_image

/datum/controller/subsystem/ai_obfuscation/proc/remove_obfuscation_image(var/image/removed_image)
	if(!istype(removed_image))
		return
	obfuscation_images -= removed_image

	for(var/ai in ai_list)
		var/mob/living/silicon/ai/A = ai
		if(A.client)
			A.client.images -= removed_image

/datum/controller/subsystem/ai_obfuscation/proc/get_obfuscation_images()
	return obfuscation_images