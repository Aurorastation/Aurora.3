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

		if(target_zone == BP_MOUTH)
			var/voice =  sanitize(input(user, "What would you like the victim to say", "Poppet", null)  as text)
			H.say(voice)
			log_and_message_admins("forced [H] to say [voice] with a poppet", user)

		if(target_zone == BP_EYES)
			to_chat(user, "<span class='notice'>You cover \the [src]'s eyes.</span>")
			to_chat(H, "<span class='warning'>Your vision is covered by a shadow!</span>")
			H.eye_blind = 3
			H.eye_blurry = 5

		if(target_zone == BP_R_LEG || target_zone == BP_L_LEG)
			to_chat(user, "<span class='notice'>You move \the [src]'s legs around.</span>")
			if(H.canmove && !H.restrained() && !(istype(H.loc, /turf/space)))
				step(H, pick(cardinal))

		if(target_zone == BP_L_HAND || target_zone == BP_L_ARM)
			to_chat(user, "<span class='notice'>You twist \the [src]'s left arm.</span>")
			H.drop_l_hand()

		if(target_zone == BP_R_HAND || target_zone == BP_R_ARM)
			to_chat(user, "<span class='notice'>You twist \the [src]'s right arm..</span>")
			H.drop_r_hand()

		if(target_zone == BP_HEAD)
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
		H.apply_damage(Proj.damage, PAIN)

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