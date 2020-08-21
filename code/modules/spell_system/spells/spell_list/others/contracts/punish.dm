/spell/contract/punish
	name = "Punish Contractee"
	desc = "A spell that sets your contracted victim ablaze."

	charge_max = 300
	cooldown_min = 100

	hud_state = "gen_immolate"

/spell/contract/punish/cast(mob/living/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	to_chat(target, SPAN_DANGER("Magical energies surround you, immolating you in a furious fashion!"))
	target.IgniteMob(15)
