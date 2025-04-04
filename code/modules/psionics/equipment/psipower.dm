/obj/item/psychic_power
	name = "psychic power"
	icon = 'icons/obj/psychic_powers.dmi'
	atom_flags = 0
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	var/maintain_cost = 3
	var/mob/living/owner
	w_class = WEIGHT_CLASS_NO_CONTAINER

/obj/item/psychic_power/New(var/mob/living/_owner)
	owner = _owner
	if(!istype(owner))
		qdel(src)
		return
	START_PROCESSING(SSprocessing, src)
	..()

/obj/item/psychic_power/Destroy()
	if(istype(owner) && owner.psi)
		LAZYREMOVE(owner.psi.manifested_items, src)
		UNSETEMPTY(owner.psi.manifested_items)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/psychic_power/attack_self(var/mob/user)
	sound_to(owner, 'sound/effects/psi/power_fail.ogg')
	user.drop_from_inventory(src)

/obj/item/psychic_power/dropped()
	..()
	QDEL_IN(src, 1)

/obj/item/psychic_power/on_give()
	qdel(src)

/obj/item/psychic_power/process()
	if(istype(owner))
		owner.psi.spend_power(maintain_cost)
	if(!owner || loc != owner || (owner.l_hand != src && owner.r_hand != src))
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		else
			qdel(src)

/obj/item/psychic_power/damage_flags()
	. = ..()
	. |= DAMAGE_FLAG_PSIONIC
