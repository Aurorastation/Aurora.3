/spell/contract/reward
	name = "Extinguish Contractee"
	desc = "A spell that extinguishes your contractee from flames."

	charge_max = 300
	cooldown_min = 100

	hud_state = "wiz_jaunt_old"

/spell/contract/reward/cast(mob/living/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	if(target.on_fire && target.fire_stacks > 0)
		to_chat(target, "<span class='notice'>Magical energies surround you, putting out all your flames.</span>")
		target.ExtinguishMobCompletely()