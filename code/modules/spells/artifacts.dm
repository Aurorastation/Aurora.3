//////////////////////Scrying orb//////////////////////

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/living/user as mob)
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/E = H.get_eyes(no_synthetic = TRUE)
			if (!E)
				user << "<span class='notice'>You stare deep into the abyss... and nothing happens. What a letdown.</span>"
				return

			user << "<span class='warning'>You stare deep into the abyss... and the abyss stares back.</span>"
			sleep(10)
			user << "<span class='warning'>Your [E.name] fill with painful light, and you feel a sharp burning sensation in your head!</span>"
			user.custom_emote(2, "screams in horror!")
			playsound(user, 'sound/hallucinations/far_noise.ogg', 40, 1)
			user.drop_item()
			user.visible_message("<span class='danger'>Ashes pour out of [user]'s eye sockets!</span>")
			new /obj/effect/decal/cleanable/ash(get_turf(user))
			E.removed(user)
			qdel(E)
			H.adjustBrainLoss(50)
			H.hallucination += 20
			return
	else
		user << "<span class='info'>You can see... everything!</span>"
		visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

		user.teleop = user.ghostize(1)
		announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
		return

/obj/item/weapon/melee/energy/wizard
	name = "rune sword"
	desc = "A large sword engraved with arcane markings, it seems to reverberate with unearthly powers."
	icon = 'icons/obj/sword.dmi'
	icon_state = "runesword0"
	item_state = "runesword0"
	contained_sprite = 1
	active_force = 40
	active_throwforce = 40
	active_w_class = 5
	force = 20
	throwforce = 30
	throw_speed = 5
	throw_range = 10
	w_class = 5
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 8)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = 1
	edge = 1
	base_reflectchance = 60
	base_block_chance = 60
	can_block_bullets = 1
	shield_power = 150

/obj/item/weapon/melee/energy/wizard/activate(mob/living/user)
	..()
	icon_state = "runesword1"
	item_state = "runesword1"
	user << "<span class='notice'>\The [src] surges to life!.</span>"

/obj/item/weapon/melee/energy/wizard/deactivate(mob/living/user)
	..()
	icon_state = "runesword0"
	item_state = "runesword0"
	user << "<span class='notice'>\The [src] slowly dies out.</span>"

/obj/item/weapon/melee/energy/wizard/attack(mob/living/M, mob/living/user, var/target_zone)
	if(user.is_wizard())
		return ..()

	var/zone = (user.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		user << "<span class='danger'>The sword refuses you as its true wielder, slashing your [affecting.name] instead!</span>"

	user.apply_damage(active_force, BRUTE, zone, 0, sharp=1, edge=1)

	user.drop_from_inventory(src)

	return 1

//skeleton weapons and armor

/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A rudimentary armor made of bones of several creatures."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "bonearmor"
	item_state = "bonearmor"
	contained_sprite = 1
	species_restricted = list("Skeleton")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/bone
	name = "bone helmet"
	desc = "A rudimentary helmet made of some dead creature."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "skull"
	item_state = "skull"
	contained_sprite = 1
	species_restricted = list("Skeleton")
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/weapon/material/twohanded/spear/bone
	desc = "A spear crafted with bones of some long forgotten creature."
	default_material = "cursed bone"

//lich phylactery

/obj/item/phylactery
	name = "phylactery"
	desc = "A twisted mummified heart."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "cursedheart-off"
	origin_tech = list(TECH_BLUESPACE = 8, TECH_MATERIAL = 8, TECH_BIO = 8)
	w_class = 5
	light_color = "#6633CC"
	light_power = 3
	light_range = 4

	var/lich = null

/obj/item/phylactery/Initialize()
	. = ..()
	world_phylactery += src
	create_reagents(30)
	reagents.add_reagent("undead_ichor", 30)

/obj/item/phylactery/Destroy()
	lich << "<span class='danger'>Your phylactery was destroyed, your soul is cast into the abyss as your immortality vanishes away!</span>"
	world_phylactery -= src
	lich = null
	return ..()

/obj/item/phylactery/examine(mob/user)
	..(user)
	if(!lich)
		user << "The heart is inert."
	else
		user << "The heart is pulsing slowly."

/obj/item/phylactery/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/weapon/nullrod))
		src.visible_message("\The [src] twists violently and explodes!")
		gibs(src.loc)
		qdel(src)
		return

//philosopher's stone artifacts
/obj/item/enchantment
	name = "enchantment rune"
	desc = "A blank rune."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	var/product
	var/list/factor_paths

/obj/item/enchantment/attackby(var/obj/item/I, var/mob/user)
	..()

	if(!product || !factor_paths.len)
		return

	if(is_type_in_list(I, factor_paths))
		user << "<span class='notice'>You stroke [I] with [src] carefully and with reverance...</span>"

		if(locate(product in world))
			user << "<span class='warning'>...and nothing happens. The heavens are silent.</span>"
			return

		new product(get_turf(user))
		user.visible_message(\
			"<span class='danger'>With thunderous acclaim [user] is delivered a sacred tool from the sacrifice of [I]!</span>",\
			"<span class='danger'>You sacrifice [I] and are delivered a sacred tool!</span>",\
			"<span class='danger'>You hear a peal of thunder!</span>"\
		)
		playsound(user, 'sound/magic/lightningbolt.ogg', 40, 1)
		qdel(I)
		qdel(src)
		return

/obj/item/enchantment/azoth
	name = "blessed enchantment rune"
	desc = "A scroll marked with an ancient rune for blessed protection. On the reverse side is a glyph representing a shield."
	icon_state = "azoth"
	product = /obj/item/weapon/shield/aegis
	factor_paths = list(/obj/item/weapon/shield)

/obj/item/weapon/shield/aegis
	name = "Aegis"
	desc = "Said to have been carried in ancient times by Perseus, the Aegis has not lost is reflective sheen over the ages. Raise it high to unleash a regenerative war cry."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "aegis"
	force = 10.0
	throwforce = 15.0
	w_class = 4.0
	slot_flags = SLOT_BACK
	attack_verb = list("shoved", "bashed")
	var/damage_soak = 0

/obj/item/weapon/shield/aegis/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))

		if(istype(damage_source, /obj/item/projectile))
			var/obj/item/projectile/P = damage_source
			damage_soak += damage

			if(P.starting)
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				// Find a turf near or on the original location to bounce to
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, user)

				return PROJECTILE_CONTINUE // complete projectile permutation
			else
				user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
				return 1

		else if(prob(base_block_chance))
			damage_soak += damage
			user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
			return 1

/obj/item/weapon/shield/aegis/attack_self(mob/living/user as mob)
	if(damage_soak)
		user.visible_message(\
			"<span class='danger'>[user] raises [src] high with a mighty yell!</span>",\
			"<span class='danger'>You raise [src] high and feel your wounds regenerate!</span>"\
		)
		user.adjustBruteLoss(damage_soak/-2)
		user.adjustFireLoss(damage_soak/-2)
		damage_soak = 0
	else
		user << "<span class='warning'>[src] is dry of its regenerative energies.</span>"
	add_fingerprint(user)
	return

/obj/item/enchantment/elixir
	name = "divine enchantment rune"
	desc = "A scroll marked with an ancient rune for divine wealth. On the reverse side is a glyph representing a chalice."
	icon_state = "elixir"
	product = /obj/item/weapon/reagent_containers/glass/cornucopia
	factor_paths = list(/obj/item/weapon/reagent_containers, /obj/item/weapon/reagent_containers/food/drinks)

/obj/item/weapon/reagent_containers/glass/cornucopia
	name = "Horn of Plenty"
	desc = "In some cultures it is known as the Cornucopia. Fill it with any reagent and it will never run dry. Whisper to it its power word to empty it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "cornucopia"

/obj/item/weapon/reagent_containers/glass/cornucopia/attack_self()
	usr << "<span class='notice'>You whisper to [src] its power word, and it drains itself dry.</span>"
	reagents.remove_reagent(reagents, reagents.total_volume)

/obj/item/weapon/reagent_containers/glass/cornucopia/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		user << "<span class='notice'>[target] is empty.</span>"
		return 1

	if(reagents && !reagents.get_free_space())
		user << "<span class='notice'>[src] is full.</span>"
		return 1

	var/trans = target.reagents.add_reagent(reagents, amount_per_transfer_from_this)
	user << "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>"
	return 1

/obj/item/weapon/reagent_containers/glass/cornucopia/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(!reagents || !reagents.total_volume)
		user << "<span class='notice'>[src] is empty.</span>"
		return 1

	if(target.reagents && !target.reagents.get_free_space())
		user << "<span class='notice'>[target] is full.</span>"
		return 1



	var/contained = reagentlist()
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to splash [target.name] ([target.key]). Reagents: [contained]</font>")
	msg_admin_attack("[user.name] ([user.ckey]) splashed [target.name] ([target.key]) with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

	user.visible_message("<span class='danger'>[target] has been splashed with something by [user]!</span>", "<span class = 'notice'>You splash the solution onto [target].</span>")
	target.reagents.add_reagent(reagents, reagents.total_volume)

	if (istype(target, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = target
		R.spark_system.queue()

	return 1

/obj/item/weapon/reagent_containers/glass/cornucopia/standard_feed_mob(var/mob/user, var/mob/target) // This goes into attack
	if(!istype(target))
		return 0

	if(!reagents || !reagents.total_volume)
		user << "<span class='notice'>\The [src] is empty.</span>"
		return 1

	//var/types = target.find_type()
	var/mob/living/carbon/human/H
	if(istype(target, /mob/living/carbon/human))
		H = target

	if(target == user)
		if(istype(user, /mob/living/carbon/human))
			H = user
			if(!H.check_has_mouth())
				user << "Where do you intend to put \the [src]? You don't have a mouth!"
				return 1
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				user << "<span class='warning'>\The [blocked] is in the way!</span>"
				return

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things
		self_feed_message(user)
		target.reagents.add_reagent(reagents, amount_per_transfer_from_this)
		feed_sound(user)
		return 1
	else
		if(istype(target, /mob/living/carbon/human))
			H = target
			if(!H.check_has_mouth())
				user << "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!"
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				user << "<span class='warning'>\The [blocked] is in the way!</span>"
				return

		other_feed_message_start(user, target)

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!do_mob(user, target))
			return

		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [name] by [target.name] ([target.ckey]). Reagents: [contained]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(target)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

		target.reagents.add_reagent(reagents, amount_per_transfer_from_this)
		feed_sound(user)
		return 1

/obj/item/weapon/reagent_containers/glass/cornucopia/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
	if(!target.is_open_container() && istype(target, /obj/item/weapon/reagent_containers))
		user << "<span class='notice'>\The [target] is closed.</span>"
		return 1
	// Otherwise don't care about splashing.
	else if(!target.is_open_container())
		return 0

	if(!reagents || !reagents.total_volume)
		user << "<span class='notice'>[src] is empty.</span>"
		return 1

	if(!target.reagents.get_free_space())
		user << "<span class='notice'>[target] is full.</span>"
		return 1

	var/trans = target.reagents.add_reagent(reagents, amount_per_transfer_from_this)
	user << "<span class='notice'>You transfer [trans] units of the solution to [target].</span>"
	return 1


/obj/item/enchantment/fire
	name = "infernal enchantment rune"
	desc = "A scroll marked with an ancient rune for infernal wrath. On the reverse side is a glyph representing a sword."
	icon_state = "fire"
	product = /obj/item/weapon/material/twohanded/zweihander/gotterdammerung
	factor_paths = list(/obj/item/weapon/melee, /obj/item/weapon/material/sword, /obj/item/weapon/material/twohanded/baseballbat, /obj/item/weapon/material/twohanded/zweihander)

/obj/item/weapon/material/twohanded/zweihander/gotterdammerung
	icon = 'icons/obj/wizard.dmi'
	icon_state = "Gotterdammerung"
	base_icon = "flammenschwert"
	name = "flammenschwert"
	desc = "The mighty flamberge said to be wielded by the ancient jotunn Surtr during the end of days, Ragnarok. Its undulating blade burns bright with the flames of Muspell."
	force = 40
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_wielded = 1
	unwielded_force_divisor = 1
	thrown_force_divisor = 0.75
	edge = 1
	sharp = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	default_material = "steel"
	wielded_ap = 60
	unwielded_ap = 20
	light_color = "#ED9200"
	light_power = 1
	light_range = 4

/obj/item/weapon/material/twohanded/zweihander/gotterdammerung/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(1400, 30)
		return

/obj/item/weapon/material/twohanded/zweihander/gotterdammerung/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.apply_effect(rand(4,12),INCINERATE)

/obj/item/enchantment/singularity
	name = "chaos enchantment rune"
	desc = "A scroll marked with an ancient rune for chaos. On the reverse side is a glyph representing a playing card."
	icon_state = "singularity"
	product = /obj/item/weapon/singularity_deck
	factor_paths = list(/obj/item/weapon/deck, /obj/item/weapon/deck)

/obj/item/weapon/singularity_deck
	icon = 'icons/obj/wizard.dmi'
	icon_state = "chaos_card"
	name = "Deck of Many Things"
	desc = "A deck of many things, much good and much bad. Pick a card, any card - fate is not a trifle to be toyed with."
	var/list/faces = list("The Fool","The Magician","The High Priestess","The Empress","The Emperor","The Hierophant","The Lovers","The Chariot","Strength","The Hermit","Wheel of Fortune",\
		"Justice","The Hanged Man","Death","Temperance","The Devil","The Tower","The Star","The Moon","The Sun","Judgment","The World", "Wands", "Pentacles", "Cups", "Swords")

/*/obj/item/weapon/singularity_deck/attack_self(mob/user as mob)
	if(faces.len)
		user.visible_message("<span class='notice'>[user] draws a card from \the [src]. </span>", \
							 "<span class='notice'>You draw a card from \the [src]. . . </span>")
		var/current_face = pick(faces)
		faces.Remove(current_face)
		switch(current_face)
			if("The Fool")
			if("The Magician"
			if("The High Priestess")
			if("The Empress")
			if("The Emperor")
			if("The Hierophant")
			if("The Lovers")
			if("The Chariot")
			if("Strength")
			if("The Hermit")
			if("Wheel of Fortune")
			if("Justice")
			if("The Hanged Man")
			if("Death")
			if("Temperance")
			if("The Devil")
			if("The Tower")
			if("The Star")
			if("The Moon")
			if("The Sun")
			if("Judgment")
			if("The World")
			if("Wands")
			if("Pentacles")
			if("Cups")
			if("Swords")
	else
		user << "<span class='notice'>The deck is empty!</span>"
		qdel(src)*/

/obj/item/enchantment/estus
	name = "luminous enchantment rune"
	desc = "A scroll marked with an ancient rune for luminous brilliance. On the reverse side is a glyph representing a spear."
	icon_state = "estus"
	product = /obj/item/weapon/sunlight_scroll
	factor_paths = list(/obj/item/weapon/material/twohanded/spear)

/obj/item/weapon/sunlight_scroll
	icon = 'icons/obj/wizard.dmi'
	icon_state = "sunlight_scroll"
	name = "Scroll of Sunlight Spear"
	desc = "Upon the parchment is the legend of the sunlight spear, a myth of dubious origin. With it, summon forth a tangible beam of grossly incandescent sunlight."
	w_class = 2

/obj/item/weapon/sunlight_scroll/attack_self(mob/user as mob)
	user.visible_message(\
		"<span class='danger'>[user] summons from the air a sunlight spear!</span>",\
		"<span class='warning'>You summon the sunlight spear!</span>",\
		"<span class='danger'>You hear a hum of electricity!</span>"\
	)
	playsound(user, 'sound/magic/lightning_chargeup.ogg', 40, 1)
	qdel(src)
	var/obj/item/weapon/sunlight_spear/S
	if(user.l_hand && istype(user.l_hand,/obj/item/weapon/sunlight_spear))
		S = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/weapon/sunlight_spear))
		S = user.r_hand
	else
		S = new(get_turf(src))
		user.put_in_hands(S)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.throw_mode_on()

/obj/item/weapon/sunlight_spear
	icon = 'icons/obj/wizard.dmi'
	icon_state = "sunlight_spear"
	name = "sunlight spear"
	desc = "A javelin of tangible light, humming with energy and heat."
	w_class = 2
	force = 10
	throwforce = 20
	throw_speed = 10
	throw_range = 30
	damtype = "fire"

/obj/item/weapon/sunlight_spear/Initialize()
	..()
	QDEL_IN(src, 30 SECONDS) //meant to throw it, not stab with it

/obj/item/weapon/sunlight_spear/Destroy()
	playsound(user, 'sound/magic/lightningbolt.ogg', 20, 1)
	..()

/obj/item/weapon/sunlight_spear/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.apply_effect(2,INCINERATE)
		L.electrocute_act(10, tesla_shock = 1)
		if(L.find_type() & TYPE_WEIRD)
			L.apply_effect(2,INCINERATE)
			L.adjustFireLoss(5)

/obj/item/weapon/sunlight_spear/throw_at()
	..()
	var/obj/item/weapon/sunlight_scroll/S
	if(user.l_hand && istype(user.l_hand,/obj/item/weapon/sunlight_scroll))
		S = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/weapon/sunlight_scroll))
		S = user.r_hand
	else
		S = new(get_turf(src))
		user.put_in_hands(S)

/obj/item/weapon/sunlight_spear/throw_impact(atom/hit_atom)
	..()
	explosion(hit_atom, -1, 0, 2)
	playsound(user, 'sound/magic/lightningbolt.ogg', 60, 1)

	for(var/obj/structure/closet/L in hear(1, get_turf(hit_atom)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				bang(get_turf(src), M)

	for(var/mob/living/carbon/M in hear(1, get_turf(hit_atom)))
		bang(get_turf(src), M)

	for(var/obj/effect/blob/B in hear(2,get_turf(hit_atom)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(hit_atom))+1))
		B.health -= damage
		B.update_icon()

	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.apply_effect(4,INCINERATE)
		L.electrocute_act(20, tesla_shock = 1)
		if(L.find_type() & TYPE_WEIRD)
			L.apply_effect(4,INCINERATE)
			L.adjustFireLoss(10)
	qdel(src)

/obj/item/weapon/sunlight_spear/proc/bang(var/turf/T , var/mob/living/carbon/M)					// Added a new proc called 'bang' that takes a location and a person to be banged.
	if (locate(/obj/item/weapon/cloaking_device, M))			// Called during the loop that bangs people in lockers/containers and when banging
		for(var/obj/item/weapon/cloaking_device/S in M)			// people in normal view.  Could theroetically be called during other explosions.
			S.active = 0										// -- Polymorph
			S.icon_state = "shield0"

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(istype(M:l_ear, /obj/item/clothing/ears/earmuffs) || istype(M:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(HULK in M.mutations)
				ear_safety += 1
			if(istype(M:head, /obj/item/clothing/head/helmet))
				ear_safety += 1

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		flick("e_flash", M.flash)
		M.Stun(1)
		M.Weaken(5)
			//Vaurca damage 15/01/16
		var/mob/living/carbon/human/H = M
		if(isvaurca(H))
			var/obj/item/organ/eyes/E = H.get_eyes()
			if(!E)
				return
			usr << span("alert", "Your eyes burn with the intense light of the flash!.")
			E.damage += rand(10, 11)
			if(E.damage > 12)
				M.eye_blurry += rand(3,6)
			if (E.damage >= E.min_broken_damage)
				M.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				M.eye_blind = 5
				M.eye_blurry = 5
				M.disabilities |= NEARSIGHTED
				spawn(100)
					M.disabilities &= ~NEARSIGHTED



//Now applying sound
	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(ear_safety > 0)
			M.Stun(1)
		else
			M.Stun(5)
			M.Weaken(1)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		if(!ear_safety)
			M << sound('sound/weapons/flash_ring.ogg',0,1,0,100)
			M.Stun(4)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety)
		M.Stun(2)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if (E && E.damage >= E.min_bruised_damage)
			M << "<span class='danger'>Your eyes start to burn badly!</span>"
			if (E.damage >= E.min_broken_damage)
				M << "<span class='danger'>You can't see anything!</span>"
	if (M.ear_damage >= 15)
		M << "<span class='danger'>Your ears start to ring badly!</span>"
		if (prob(M.ear_damage - 10 + 5))
			M << "<span class='danger'>You can't hear anything!</span>"
			M.sdisabilities |= DEAF
	else
		if (M.ear_damage >= 5)
			M << "<span class='danger'>Your ears start to ring!</span>"
	M.update_icons()