/obj/item/psychic_power
	name = "psychic power"
	icon = 'icons/obj/psychic_powers.dmi'
	flags = 0
	simulated = 1
	anchored = 1
	var/maintain_cost = 3
	var/mob/living/owner

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

/obj/item/psychic_power/get_storage_cost()
	return 5

/obj/item/psychic_power/attack_self(var/mob/user)
	sound_to(owner, 'sound/effects/psi/power_fail.ogg')
	user.drop_from_inventory(src)

/obj/item/psychic_power/dropped()
	..()
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
