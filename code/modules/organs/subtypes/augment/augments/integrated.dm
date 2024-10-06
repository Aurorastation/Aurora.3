/obj/item/organ/internal/augment/tool/integrated
	name = "retractable toolset"
	icon_state = "augment-tool"
	action_button_name = "Deploy Tool"
	action_button_icon = "augment-tool"
	parent_organ = BP_R_HAND
	organ_tag = BP_AUG_TOOL
	cooldown = 1
	/// What tools the implant has
	var/list/obj/item/tools
	/// Do we have an active tool or not?
	var/using_tool = FALSE

/obj/item/organ/internal/augment/tool/integrated/surgical
	name = "retractable surgical toolset"
	action_button_name = "Deploy Surgical Tool"
	tools = list(
		"scalpel" = /obj/item/surgery/scalpel,
		"hemostat" = /obj/item/surgery/hemostat,
		"retractor" = /obj/item/surgery/retractor,
		"cautery" = /obj/item/surgery/cautery
		)

/obj/item/organ/internal/augment/tool/integrated/attack_self(var/mob/user)
	if(using_tool)
		..()
		using_tool = FALSE
		return
	var/tool = RADIAL_INPUT(user, tools)
	if(tool)
		using_tool = TRUE
		augment_type = tools[tool]
		..()

/obj/item/organ/internal/augment/tool/integrated/surgical/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand
