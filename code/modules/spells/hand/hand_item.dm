/*much like grab this item is used primarily for the utility it provides.
Basically: I can use it to target things where I click. I can then pass these targets to a spell and target things not using a list.
*/

/obj/item/weapon/magic_hand
	name = "power fist"
	icon = 'icons/mob/screen1.dmi'
	flags = 0
	abstract = 1
	w_class = 5.0
	icon_state = "spell"
	var/next_spell_time = 0
	var/spell/hand/hand_spell
	var/casts = 0
	var/duration
	force = 0

/obj/item/weapon/magic_hand/New(var/turf/location, var/spell/hand/S, mob/living/user)
	hand_spell = S
	name = "[name] ([hand_spell.name])"
	casts = hand_spell.casts
	icon = hand_spell.hand_icon
	icon_state = hand_spell.hand_state
	duration = hand_spell.duration
	if(hand_spell.casts == 0) //if casts is predefined, use that instead
		if(hand_spell.power_level > 0 && hand_spell.psybrain)
			casts = round(hand_spell.psybrain.power_level/hand_spell.power_level) //Ex: at power level 5 you gain 5 casts of a 1st level spell, but only 1 cast of a 5th level spell
		else
			casts = -1 //You can cast a cantrip infinitely within its duration.
	if(hand_spell.lightful)
		set_light(2,1,hand_spell.lightful_c)
	addtimer(CALLBACK(user, /mob/.proc/drop_from_inventory, src), duration SECONDS)

/obj/item/weapon/magic_hand/attack()
	..()

/obj/item/weapon/magic_hand/afterattack(atom/A, mob/living/user)
	if(!hand_spell) //no spell? Die.
		user.drop_from_inventory(src)

	if(!hand_spell.valid_target(A,user))
		return
	if(world.time < next_spell_time)
		user << "<span class='warning'>The spell isn't ready yet!</span>"
		return

	if(hand_spell.cast_hand(A,user))
		next_spell_time = world.time + hand_spell.spell_delay
		casts--
		if(hand_spell.move_delay)
			user.setMoveCooldown(hand_spell.move_delay)
		if(hand_spell.click_delay)
			user.setClickCooldown(hand_spell.move_delay)
		if(!casts)
			user.drop_from_inventory(src)
			return
		if(casts > 0)
			user << "[casts]/[hand_spell.casts] charges left."

/obj/item/weapon/magic_hand/throw_at() //no throwing pls
	usr.drop_from_inventory(src)

/obj/item/weapon/magic_hand/dropped() //gets deleted on drop
	loc = null
	qdel(src)

/obj/item/weapon/magic_hand/Destroy() //better save than sorry.
	hand_spell = null
	return ..()