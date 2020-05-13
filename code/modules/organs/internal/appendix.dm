/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = BP_GROIN
	organ_tag = "appendix"

/obj/item/organ/internal/appendix/removed()
	if(owner)
		var/inflamed = 0
		for(var/datum/disease/appendicitis/appendicitis in owner.viruses)
			inflamed = 1
			appendicitis.cure()
			owner.resistances += appendicitis
		if(inflamed)
			icon_state = "appendixinflamed"
			name = "inflamed appendix"
	..()