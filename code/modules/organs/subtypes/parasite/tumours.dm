/obj/item/organ/internal/parasite/benign_tumour
	name = "benign tumour"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "tumour"
	dead_icon = "tumour"

	organ_tag = BP_TUMOUR_NONSPREADING
	parent_organ = BP_CHEST
	subtle = 1

	drug_resistance = 1

	max_stage = 3
	stage_interval = 300 //~5 minutes minutes/stage

	origin_tech = list(TECH_BIO = 2)

/obj/item/organ/internal/parasite/benign_tumour/proc/generate_name()
	if(parent_organ)
		switch(parent_organ)
			if(BP_CHEST)
				name = "benign chest lipoma"
			if(BP_GROIN)
				name = "benign abdominal tumour"
			if(BP_HEAD)
				name = "benign skull cavity tumour"
			if(BP_L_ARM)
				name = "benign lipoma (left arm)"
			if(BP_R_ARM)
				name = "benign lipoma (right arm)"
			if(BP_L_HAND)
				name = "benign chondroma (left hand)"
			if(BP_R_HAND)
				name = "benign chondroma (right hand)"
			if(BP_L_LEG)
				name = "benign lipoma (left leg)"
			if(BP_R_LEG)
				name = "benign lipoma (right leg)"
			if(BP_L_FOOT)
				name = "benign plantar fibroma (left foot)"
			if(BP_R_FOOT)
				name = "benign plantar fibroma (right foot)"

/obj/item/organ/internal/parasite/benign_tumour/process(seconds_per_tick)
	..()
	if(!owner)
		return
	if(LAZYACCESS(owner.chem_doses, /singleton/reagent/ryetalyn))  //10u will treat most tumours, 20u will nuke fully developed tumours
		recession = 20
	if(SPT_PROB(2, seconds_per_tick))
		owner.adjustNutritionLoss(5)
	if(stage >= 2)  //after ~5 minutes
		if(SPT_PROB(5, seconds_per_tick))
			owner.adjustHalLoss(10*stage)

/obj/item/organ/internal/parasite/malignant_tumour
	name = "malignant tumour"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "tumour"
	dead_icon = "tumour"

	organ_tag = BP_TUMOUR_SPREADING
	parent_organ = BP_CHEST
	subtle = 1

	drug_resistance = 1

	max_stage = 4
	stage_interval = 300 //~5 minutes minutes/stage

	origin_tech = list(TECH_BIO = 3)

	egg = /singleton/reagent/toxin/malignant_tumour_cells

/obj/item/organ/internal/parasite/malignant_tumour/proc/generate_name()
	if(parent_organ)
		switch(parent_organ)
			if(BP_CHEST)
				name = "malignant chest wall sarcoma"
			if(BP_GROIN)
				name = "gastric cancer"
			if(BP_HEAD)
				name = "malignant brain tumour"
			if(BP_L_ARM)
				name = "malignant melanoma (left arm)"
			if(BP_R_ARM)
				name = "malignant melanoma (right arm)"
			if(BP_L_HAND)
				name = "malignant chondrosarcoma (left hand)"
			if(BP_R_HAND)
				name = "malignant chondrosarcoma (right hand)"
			if(BP_L_LEG)
				name = "malignant melanoma (left leg)"
			if(BP_R_LEG)
				name = "malignant melanoma (right leg)"
			if(BP_L_FOOT)
				name = "malignant chondrosarcoma (left foot)"
			if(BP_R_FOOT)
				name = "malignant chondrosarcoma (right foot)"

/obj/item/organ/internal/parasite/malignant_tumour/process(seconds_per_tick)
	..()
	if(!owner)
		return
	if(LAZYACCESS(owner.chem_doses, /singleton/reagent/ryetalyn)) //10u will treat most tumours, 20u will nuke fully developed tumours
		recession = 20
	if(SPT_PROB(5, seconds_per_tick))
		owner.adjustNutritionLoss(5)
		if(SPT_PROB(5, seconds_per_tick))
			owner.adjustHalLoss((10*stage)/2)
	if(stage >= 2)  //after ~5 minutes
		switch(parent_organ)
			if(BP_HEAD)
				owner.confused = min(owner.confused + (stage*2), 10)
				owner.slurring = min(owner.slurring + (stage*2), 50)
				if(SPT_PROB(5, seconds_per_tick))
					to_chat(owner, SPAN_WARNING(pick("You struggle to remember the last several moments.", "You smell something funny.", "You taste something funny.", "You can't figure out how to properly string words together.", "What was I just doing?")))
					owner.emote("drool")
			if(BP_CHEST)
				if(SPT_PROB(3, seconds_per_tick))
					to_chat(owner, SPAN_WARNING(pick("You feel a tightness in your chest.", "You feel a little lightheaded.", "You need to take larger breaths than normal.")))
					owner.emote(pick("cough", "gasp"))
			if(BP_GROIN)
				if(SPT_PROB(3, seconds_per_tick))
					to_chat(owner, SPAN_WARNING(pick("You feel a sharp pain in your gut.", "You feel a little bloated.")))
					owner.visible_message("<b>[owner]</b> winces slightly.")
					owner.delayed_vomit()
			else
				if(SPT_PROB(stage*2, seconds_per_tick))
					to_chat(owner, SPAN_WARNING("You feel very lethargic."))
	if(stage >= 3) //after ~10 minutes
		for(var/obj/item/organ/internal/O in owner.internal_organs)
			if(O.parent_organ == parent_organ)
				if(BP_IS_ROBOTIC(O))
					continue
				if(SPT_PROB(stage*stage, seconds_per_tick))
					O.damage = min(O.damage+stage, O.max_damage)

	if(stage >= 4) //after 15 minutes
		if(SPT_PROB(3, seconds_per_tick))
			owner.reagents.add_reagent(egg, 2) //malignant cells breaking off, enter circulatory/lymphatic nodes to spread
