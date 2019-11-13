//////////////////////Scrying orb//////////////////////

/obj/item/scrying
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

/obj/item/scrying/attack_self(mob/living/user as mob)
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/E = H.get_eyes(no_synthetic = TRUE)
			if (!E)
				to_chat(user, "<span class='notice'>You stare deep into the abyss... and nothing happens. What a letdown.</span>")
				return

			to_chat(user, "<span class='warning'>You stare deep into the abyss... and the abyss stares back.</span>")
			sleep(10)
			to_chat(user, "<span class='warning'>Your [E.name] fill with painful light, and you feel a sharp burning sensation in your head!</span>")
			user.custom_emote(2, "screams in horror!")
			playsound(user, 'sound/hallucinations/far_noise.ogg', 40, 1)
			user.drop_item()
			user.visible_message("<span class='danger'>Ashes pour out of [user]'s eye sockets!</span>")
			new /obj/effect/decal/cleanable/ash(get_turf(user))
			E.removed(user)
			qdel(E)
			H.adjustBrainLoss(50, 55)
			H.hallucination += 20
			return
	else
		to_chat(user, "<span class='info'>You can see... everything!</span>")
		visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

		user.teleop = user.ghostize(1)
		announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
		return

/obj/item/melee/energy/wizard
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

/obj/item/melee/energy/wizard/activate(mob/living/user)
	..()
	icon_state = "runesword1"
	item_state = "runesword1"
	to_chat(user, "<span class='notice'>\The [src] surges to life!.</span>")

/obj/item/melee/energy/wizard/deactivate(mob/living/user)
	..()
	icon_state = "runesword0"
	item_state = "runesword0"
	to_chat(user, "<span class='notice'>\The [src] slowly dies out.</span>")

/obj/item/melee/energy/wizard/attack(mob/living/M, mob/living/user, var/target_zone)
	if(user.is_wizard())
		return ..()

	var/zone = (user.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, "<span class='danger'>The sword refuses you as its true wielder, slashing your [affecting.name] instead!</span>")

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

/obj/item/material/twohanded/spear/bone
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
	create_reagents(120)
	reagents.add_reagent("undead_ichor", 120)

/obj/item/phylactery/Destroy()
	to_chat(lich, "<span class='danger'>Your phylactery was destroyed, your soul is cast into the abyss as your immortality vanishes away!</span>")
	world_phylactery -= src
	lich = null
	return ..()

/obj/item/phylactery/examine(mob/user)
	..(user)
	if(!lich)
		to_chat(user, "The heart is inert.")
	else
		to_chat(user, "The heart is pulsing slowly.")

/obj/item/phylactery/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/nullrod))
		src.visible_message("\The [src] twists violently and explodes!")
		gibs(src.loc)
		qdel(src)
		return

/obj/item/phylactery/pickup(mob/living/user as mob)
	..()
	if(!user.is_wizard() && src.lich)
		to_chat(user, "<span class='warning'>As you pick up \the [src], you feel a wave of dread wash over you.</span>")
		for(var/obj/machinery/light/P in view(7, user))
			P.flicker(1)


//magic poppet
/obj/item/poppet
	name = "poppet"
	desc = "A rustic doll with a vague humanoid shape."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "poppet"
	w_class = 2
	var/datum/weakref/target = null
	var/countenance = null //what species does it looks like?
	var/cooldown_time = 120
	var/cooldown = 0

/obj/item/poppet/Destroy()
	if(target)
		to_chat(target, "<span class='notice'>The strange presence vanishes away...</span>")
	return ..()

/obj/item/poppet/examine(mob/user)
	..(user)
	if(countenance)
		to_chat(user, "<span class='notice'>It is modeled after a [countenance].</span>")

/obj/item/poppet/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity)
		return

	if(A.blood_DNA)
		var/marked = pick(A.blood_DNA)

		for(var/mob/living/carbon/human/H in mob_list)
			if(H.dna.unique_enzymes == marked)
				target = WEAKREF(H)
				countenance = H.dna.species
				to_chat(H, "<span class='cult'>You feel a strange presence looming over you.</span>")


/obj/item/poppet/attack_self(mob/user as mob)
	var/mob/living/carbon/human/H = target.resolve()
	if(H && cooldown < world.time)
		var/target_zone = user.zone_sel.selecting

		if(target_zone == "mouth")
			var/voice =  sanitize(input(user, "What would you like the victim to say", "Poppet", null)  as text)
			H.say(voice)
			log_and_message_admins("forced [H] to say [voice] with a poppet", user)

		if(target_zone == "eyes")
			to_chat(user, "<span class='notice'>You cover \the [src]'s eyes.</span>")
			to_chat(H, "<span class='warning'>Your vision is covered by a shadow!</span>")
			H.eye_blind = 3
			H.eye_blurry = 5

		if(target_zone == "r_leg" || target_zone == "l_leg")
			to_chat(user, "<span class='notice'>You move \the [src]'s legs around.</span>")
			if(H.canmove && !H.restrained() && !(istype(H.loc, /turf/space)))
				step(H, pick(cardinal))

		if(target_zone == "l_hand" || target_zone == "l_arm")
			to_chat(user, "<span class='notice'>You twist \the [src]'s left arm.</span>")
			H.drop_l_hand()

		if(target_zone == "r_hand" || target_zone == "r_arm")
			to_chat(user, "<span class='notice'>You twist \the [src]'s right arm..</span>")
			H.drop_r_hand()

		if(target_zone == "head")
			to_chat(user, "<span class='notice'>You smack \the [src]'s head with your hand.</span>")
			H.confused += 10
			H.stuttering += 5
			to_chat(H, "<span class='danger'>You suddenly feel as if your head was hit by something!</span>")
			playsound(get_turf(H), "punch", 50, 1, -1)

		cooldown = world.time + cooldown_time

/obj/item/poppet/attackby(obj/item/W as obj, mob/user as mob)
	var/mob/living/carbon/human/H = target.resolve()
	if(H && cooldown < world.time)
		var/target_zone = user.zone_sel.selecting

		if(isflamesource(W))
			fire_act()

		if(istype(W, /obj/item/melee/baton))
			H.electrocute_act(W.force * 2, W, def_zone = target_zone)
			playsound(get_turf(H), 'sound/weapons/Egloves.ogg', 50, 1, -1)

		if(istype(W, /obj/item/device/flashlight))
			to_chat(H, "<span class='warning'>You direct \the [W] towards \the [src]'s eyes!</span>")
			playsound(get_turf(H), 'sound/items/flashlight.ogg', 50, 1, -1)
			flick("flash", H.flash)
			H.eye_blurry = 5

		if(W.iscoil())
			to_chat(H, "<span class='warning'>You strangle \the [src] with \the [W]!</span>")
			H.silent += 10
			playsound(get_turf(H), 'sound/effects/noosed.ogg', 50, 1, -1)
			if(!(H.species.flags & NO_BREATHE))
				H.emote("me", 1, "gasps for air!")
				H.losebreath += 5

		if(istype(W, /obj/item/bikehorn))
			playsound(get_turf(H), 'sound/items/bikehorn.ogg', 50, 1, -1)

		if(W.edge)
			to_chat(H, "<span class='warning'>You stab \the [src] with \the [W]!</span>")
			H.apply_damage(2, BRUTE, target_zone, edge = TRUE)
			playsound(get_turf(H), 'sound/weapons/bladeslice.ogg', 50, 1, -1)
			if(H.can_feel_pain())
				var/obj/item/organ/external/organ = H.get_organ(target_zone)
				to_chat(H, "<span class='danger'>You feel a stabbing pain in your [organ.name]!</span>")


		cooldown = world.time + cooldown_time

/obj/item/poppet/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.throw_at(get_edge_target_turf(H,pick(alldirs)), 5, 1)

/obj/item/poppet/emp_act(severity)
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.emp_act(severity)
		playsound(get_turf(H), 'sound/effects/EMPulse.ogg', 50, 1, -1)

/obj/item/poppet/ex_act(severity)
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.ex_act(severity)

/obj/item/poppet/tesla_act(var/power)
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.electrocute_act(power, src)

/obj/item/poppet/bullet_act(var/obj/item/projectile/Proj)
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.apply_damage(Proj.damage, HALLOSS)

/obj/item/poppet/fire_act()
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.adjust_fire_stacks(2)
		H.IgniteMob()
		to_chat(H, "<span class='danger'>You suddenly burst into flames!!</span>")

/obj/item/poppet/crush_act()
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		to_chat(H, "<span class='danger'>You feel an outworldly force crushing you!</span>")
		H.adjustBruteLoss(35)
		H.apply_effect(6, WEAKEN)
	qdel(src)