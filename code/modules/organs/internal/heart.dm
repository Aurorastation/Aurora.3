/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = BP_HEART
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	robotic_name = "circulatory pump"
	robotic_sprite = "heart-prosthetic"

/obj/item/organ/internal/heart/process()
	//Check if we're on lifesupport, and whether or not organs should be processing.
	if(owner && owner.isonlifesupport())
		return 1
	else
		return 0