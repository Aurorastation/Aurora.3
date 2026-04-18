/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = BP_GROIN
	organ_tag = BP_APPENDIX
	possible_modifications = list ("Normal","Removed")

	/**
	 * The amount of seconds that have passed since starting an appendicitis event.
	 * This number is set initially to 1 by the event, and increments by 1 each real life second.
	 * While its at 0, no appendix calculations are performed.
	 */
	var/inflamed = 0

	/// The amount of pain to take per second while in stage 1 of appendicitis.
	var/stage_one_pain_per_second = 1

	/// The amount of pain to take per second while in stage 2 of appendicitis.
	var/stage_two_pain_per_second = 1.5

	/// The amount of damage an appendix takes per second while in stage 2 of appendicitis.
	var/stage_two_organ_damage_per_second = 0.006

/obj/item/organ/internal/appendix/update_icon()
	..()
	if(inflamed)
		icon_state = "[icon_state]inflamed"
		name = "inflamed [name]"

/obj/item/organ/internal/appendix/process(seconds_per_tick)
	..()
	if(!owner || !inflamed || !BP_IS_ROBOTIC(src))
		return

	if(owner.stasis_value > 0)
		// Decrease the effective tickrate when in stasis.
		// Basically, you die of appendicitis slower while in stasis.
		seconds_per_tick /= owner.stasis_value

	var/can_feel_pain = ORGAN_CAN_FEEL_PAIN(src)
	inflamed += seconds_per_tick

	if(can_feel_pain)
		if(prob(5))
			owner.custom_pain("You feel a stinging pain in your abdomen!")
			owner.visible_message("<B>\The [owner]</B> winces slightly.")
		var/obj/item/organ/external/O = owner.get_organ(parent_organ)
		if(O)
			O.add_pain(stage_one_pain_per_second * seconds_per_tick)
	if(inflamed > 400)
		take_internal_damage(stage_two_organ_damage_per_second * seconds_per_tick)
		if(can_feel_pain)
			if(prob(3))
				owner.visible_message("<B>\The [owner]</B> winces painfully.")
			var/obj/item/organ/external/O = owner.get_organ(parent_organ)
			if(O)
				O.add_pain(stage_two_pain_per_second * seconds_per_tick)
		owner.adjustToxLoss(1)
	if(inflamed > 800 && prob(1))
		germ_level += rand(2,6)
		owner.vomit()
	if(inflamed > 1200 && prob(1))
		if(can_feel_pain)
			owner.custom_pain("You feel a stinging pain in your abdomen!")
			owner.Weaken(10)

		var/obj/item/organ/external/E = owner.get_organ(parent_organ)
		E.sever_artery()
		E.germ_level = max(INFECTION_LEVEL_TWO, E.germ_level)
		owner.adjustToxLoss(25)
		removed()
		qdel(src)
