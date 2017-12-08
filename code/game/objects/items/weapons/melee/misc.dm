	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	name = "chainsword"
	desc = "A deadly chainsaw in the shape of a sword."
	icon_state = "chainswordoff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = 4
	sharp = 1
	edge = 1
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	var/active = 0
	can_embed = 0//A chainsword can slice through flesh and bone, and the direction can be reversed if it ever did get stuck

	active= !active
	if(active)
		user << span("notice", "\The [src] rumbles to life.")
		force = 35
		icon_state = "chainswordon"
		slot_flags = null
	else
		user << span("notice", "\The [src] slowly powers down.")
		force = initial(force)
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		slot_flags = initial(slot_flags)
	user.regenerate_icons()

/*
	viewers(user) << "<span class='danger'>[user] is slicing \himself apart with the [src.name]! It looks like \he's trying to commit suicide.</span>"
	return (BRUTELOSS|OXYLOSS)
*/

//This is essentially a crowbar and a baseball bat in one.
	name = "kneebreaker hammer"
	desc = "A heavy hammer made of plasteel, the other end could be used to pry open doors."
	icon = 'icons/obj/kneehammer.dmi'
	icon_state = "kneehammer"
	item_state = "kneehammer"
	contained_sprite = 1
	slot_flags = SLOT_BELT
	force = 20
	throwforce = 15.0
	throw_speed = 5
	throw_range = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 2)


	name = "powered hammer"
	desc = "A heavily modified plasteel hammer, it seems to be powered by a robust hydraulic system."
	icon = 'icons/obj/kneehammer.dmi'
	icon_state = "hammeron"
	item_state = "hammeron"
	origin_tech = list(TECH_MATERIAL = 5, TECH_ILLEGAL = 2, TECH_COMBAT = 3)
	var/on = TRUE

	if(on)
		icon_state = "hammeron"
		item_state = "hammeron"
	else
		icon_state = "hammeroff"
		item_state = "hammeroff"

	..()
	if(prob(25))
		if(!on)
			user << "<span class='warning'>\The [src] buzzes!</span>"
			return
		user.visible_message("<span class='danger'>\The [user] slams \the [target] away with \the [src]!</span>")
		var/T = get_turf(user)
		spark(T, 3, alldirs)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.apply_effect(2, WEAKEN)
		on = FALSE
		update_icon()
		addtimer(CALLBACK(src, .proc/rearm), 45 SECONDS)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(R.cell)
				R.cell.use(150)

	src.visible_message("<span class='notice'>\The [src] hisses lowly.</span>")
	on = TRUE
	update_icon()