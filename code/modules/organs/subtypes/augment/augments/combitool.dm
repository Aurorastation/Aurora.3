/obj/item/organ/internal/augment/tool/combitool
	name = "retractable combitool"
	icon_state = "augment-tool"
	action_button_name = "Deploy Combitool"
	action_button_icon = "augment-tool"
	parent_organ = BP_R_HAND
	organ_tag = BP_AUG_TOOL
	augment_type = /obj/item/combitool/robotic

/obj/item/organ/internal/augment/tool/integrated/surgical
	name = "retractable surgical combitool"
	icon_state = "augment-tool"
	action_button_name = "Deploy Surgical Combitool"
	action_button_icon = "augment-tool"
	parent_organ = BP_R_HAND
	organ_tag = BP_AUG_TOOL
	var/list/tools = list(
		"scalpel" = /obj/item/surgery/scalpel/integrated,
		"hemostat" = /obj/item/surgery/hemostat/integrated,
		"retractor" = /obj/item/surgery/retractor/integrated,
		"cautery" = /obj/item/surgery/cautery/integrated
		)
	var/using_tool = FALSE

/obj/item/organ/internal/augment/tool/integrated/attack_self(var/mob/user)
	if(using_tool)
		..()
		using_tool = FALSE
		return 1
	var/tool = RADIAL_INPUT(user, tools)
	if(tool)
		using_tool = TRUE
		augment_type = tools[tool]
		..()
	return 1

/obj/item/organ/internal/augment/tool/combitool/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/integrated/surgical/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand
