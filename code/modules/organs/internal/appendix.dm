/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = BP_GROIN
	organ_tag = BP_APPENDIX
	possible_modifications = list ("Normal","Removed")
	var/inflamed = 0

/obj/item/organ/internal/appendix/update_icon()
	..()
	if(inflamed)
		icon_state = "[icon_state]inflamed"
		name = "inflamed [name]"

/obj/item/organ/internal/appendix/process()
	..()
	if(inflamed && owner && !BP_IS_ROBOTIC(src))
		var/can_feel_pain = ORGAN_CAN_FEEL_PAIN(src)
		inflamed++
		if(prob(5))
			if(can_feel_pain)
				owner.custom_pain("You feel a stinging pain in your abdomen!")
				owner.visible_message("<B>\The [owner]</B> winces slightly.")
				var/obj/item/organ/external/O = owner.get_organ(parent_organ)
				if(O)
					O.add_pain(10)
		if(inflamed > 200)
			if(prob(3))
				take_internal_damage(0.1)
				if(can_feel_pain)
					owner.visible_message("<B>\The [owner]</B> winces painfully.")
					var/obj/item/organ/external/O = owner.get_organ(parent_organ)
					if(O)
						O.add_pain(25)
				owner.adjustToxLoss(1)
		if(inflamed > 400)
			if(prob(1))
				germ_level += rand(2,6)
				owner.vomit()
		if(inflamed > 600)
			if(prob(1))
				if(can_feel_pain)
					owner.custom_pain("You feel a stinging pain in your abdomen!")
					owner.Weaken(10)

				var/obj/item/organ/external/E = owner.get_organ(parent_organ)
				E.sever_artery()
				E.germ_level = max(INFECTION_LEVEL_TWO, E.germ_level)
				owner.adjustToxLoss(25)
				removed()
				qdel(src)
