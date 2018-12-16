/spell/targeted/mindcontrol
	name = "Mind Bend"
	desc = "Bend the mind and soul of a mortal to serve your purposes, making them your slave. You will need some way to hold them still during the process, however."
	feedback = "MB"
	school = "cleric"
	charge_max = 10000
	spell_flags = SELECTABLE | NEEDSCLOTHES
	invocation = "In'gs'oc"
	invocation_type = SpI_SHOUT
	range = 1
	max_targets = 1

	cast_sound = 'sound/magic/Charge.ogg'

	hud_state = "rend_mind"

	holder_var_type = "brainloss"
	holder_var_amount = 15

	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/mindcontrol/cast(list/targets, mob/user)
	..()
	for(var/mob/living/target in targets)
		var/mob/living/carbon/human/H = target

		if(H.stat == DEAD || (H.status_flags & FAKEDEATH))
			user << "<span class='warning'>\The [H] is dead!</span>"
			return FALSE

		if(is_special_character(H))
			user << "<span class='warning'>\The [H]'s mind is too strong to be affected by this spell!</span>"
			return FALSE

		if(!H.mind || !H.key)
			user << "<span class='warning'>\The [H] is mindless!</span>"
			return FALSE

		var/obj/item/organ/brain/F = H.internal_organs_by_name["brain"]

		if(isnull(F))
			user << "<span class='warning'>\The [H] is brainless!</span>"
			return FALSE

		for (var/obj/item/weapon/implant/loyalty/I in H)
			if (I.implanted)
				src << "<span class='warning'>[H]'s mind is shielded against your powers!</span>"
				return FALSE

		user.visible_message("<span class='danger'>\The [user] seizes the head of \the [H] in both hands...</span>")
		user << "<span class='warning'>You invade the mind of \the [H]!</span>"
		H << "<span class='danger'>Your mind is invaded by the presence of \the [user]! They are trying to make you a slave!</span>"

		if(!do_after(user, H.stat == CONSCIOUS ? 80 : 40, target, 0, 1))
			user << "<span class='warning'>Your concentration is broken!</span>"
			return FALSE

		F.lobotomize()

		if(wizards.add_antagonist_mind(target.mind,1,"Wizard Slave","<b>You are a slave to \the [user], obey them at all costs!</b>"))
			user << "<span class='danger'>You sear through \the [H]'s mind, reshaping as you see fit and leaving them subservient to your will!</span>"
			H.mind.assigned_role = "Wizard Slave"
			H << "<span class='danger'>Your defenses have eroded away and \the [user] has made you their mindslave.</span>"
			H.faction = "Space Wizard"
			wizards.add_antagonist_mind(H.mind,1)

			return TRUE
