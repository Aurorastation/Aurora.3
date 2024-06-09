//magic poppet
/obj/item/poppet
	name = "poppet"
	desc = "A rustic doll with a vague humanoid shape."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "poppet"
	w_class = ITEMSIZE_SMALL
	var/datum/weakref/target = null
	var/countenance = null //what species does it looks like?
	var/cooldown_time = 120
	var/cooldown = 0

/obj/item/poppet/Destroy()
	if(target)
		to_chat(target, SPAN_NOTICE("The strange presence vanishes away..."))
	return ..()

/obj/item/poppet/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(countenance)
		. += SPAN_NOTICE("It is modeled after a [countenance].")

/obj/item/poppet/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity)
		return

	if(A.blood_DNA)
		var/marked = pick(A.blood_DNA)

		for(var/mob/living/carbon/human/H in GLOB.mob_list)
			if(H.dna.unique_enzymes == marked)
				target = WEAKREF(H)
				countenance = H.dna.species
				to_chat(H, SPAN_CULT("You feel a strange presence looming over you."))


/obj/item/poppet/attack_self(mob/user as mob)
	var/mob/living/carbon/human/H = target.resolve()
	if(H && cooldown < world.time)
		var/target_zone = user.zone_sel.selecting

		if(target_zone == BP_MOUTH)
			var/voice =  sanitize(input(user, "What would you like the victim to say", "Poppet", null)  as text)
			H.say(voice)
			log_and_message_admins("forced [H] to say [voice] with a poppet", user)

		if(target_zone == BP_EYES)
			to_chat(user, SPAN_NOTICE("You cover \the [src]'s eyes."))
			to_chat(H, SPAN_WARNING("Your vision is covered by a shadow!"))
			H.eye_blind = 3
			H.eye_blurry = 5

		if(target_zone == BP_R_LEG || target_zone == BP_L_LEG)
			to_chat(user, SPAN_NOTICE("You move \the [src]'s legs around."))
			if(H.canmove && !H.restrained() && !(istype(H.loc, /turf/space)))
				step(H, pick(GLOB.cardinal))

		if(target_zone == BP_L_HAND || target_zone == BP_L_ARM)
			to_chat(user, SPAN_NOTICE("You twist \the [src]'s left arm."))
			H.drop_l_hand()

		if(target_zone == BP_R_HAND || target_zone == BP_R_ARM)
			to_chat(user, SPAN_NOTICE("You twist \the [src]'s right arm.."))
			H.drop_r_hand()

		if(target_zone == BP_HEAD)
			to_chat(user, SPAN_NOTICE("You smack \the [src]'s head with your hand."))
			H.confused += 10
			H.stuttering += 5
			to_chat(H, SPAN_DANGER("You suddenly feel as if your head was hit by something!"))
			playsound(get_turf(H), /singleton/sound_category/punch_sound, 50, 1, -1)

		cooldown = world.time + cooldown_time

/obj/item/poppet/attackby(obj/item/attacking_item, mob/user)
	var/mob/living/carbon/human/H = target.resolve()
	if(H && cooldown < world.time)
		cooldown = world.time + cooldown_time
		var/target_zone = user.zone_sel.selecting

		if(attacking_item.isFlameSource())
			fire_act()
			return TRUE

		if(istype(attacking_item, /obj/item/melee/baton))
			H.electrocute_act(attacking_item.force * 2, attacking_item, def_zone = target_zone)
			playsound(get_turf(H), 'sound/weapons/Egloves.ogg', 50, 1, -1)
			return TRUE

		if(istype(attacking_item, /obj/item/device/flashlight))
			to_chat(H, SPAN_WARNING("You direct \the [attacking_item] towards \the [src]'s eyes!"))
			playsound(get_turf(H), 'sound/items/flashlight.ogg', 50, 1, -1)
			H.flash_act()
			return TRUE

		if(attacking_item.iscoil())
			to_chat(H, SPAN_WARNING("You strangle \the [src] with \the [attacking_item]!"))
			H.silent += 10
			playsound(get_turf(H), 'sound/effects/noosed.ogg', 50, 1, -1)
			if(!(H.species.flags & NO_BREATHE))
				H.visible_message("<b>[H]</b> gasps for air!")
				H.losebreath += 5
			return TRUE

		if(istype(attacking_item, /obj/item/bikehorn))
			playsound(get_turf(H), 'sound/items/bikehorn.ogg', 50, 1, -1)
			return TRUE

		if(attacking_item.edge)
			to_chat(H, SPAN_WARNING("You stab \the [src] with \the [attacking_item]!"))
			H.apply_damage(2, DAMAGE_BRUTE, target_zone, damage_flags = DAMAGE_FLAG_EDGE)
			playsound(get_turf(H), 'sound/weapons/bladeslice.ogg', 50, 1, -1)
			if(H.can_feel_pain())
				var/obj/item/organ/external/organ = H.get_organ(target_zone)
				to_chat(H, SPAN_DANGER("You feel a stabbing pain in your [organ.name]!"))
			return TRUE

/obj/item/poppet/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.throw_at(get_edge_target_turf(H,pick(GLOB.alldirs)), 5, 1)

/obj/item/poppet/emp_act(severity)
	. = ..()

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
		H.apply_damage(Proj.damage, DAMAGE_PAIN)

/obj/item/poppet/fire_act(exposed_temperature, exposed_volume)
	. = ..()

	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		H.adjust_fire_stacks(2)
		H.IgniteMob()
		to_chat(H, SPAN_DANGER("You suddenly burst into flames!!"))

/obj/item/poppet/crush_act()
	var/mob/living/carbon/human/H = target.resolve()
	if(H)
		to_chat(H, SPAN_DANGER("You feel an outworldly force crushing you!"))
		H.adjustBruteLoss(35)
		H.apply_effect(6, WEAKEN)
	qdel(src)
