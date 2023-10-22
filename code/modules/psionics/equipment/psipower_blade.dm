/obj/item/psychic_power/psiblade
	name = "psionic blade"
	force = 10
	sharp = 1
	edge = TRUE
	maintain_cost = 1
	icon_state = "psiblade_short"
	hitsound = 'sound/weapons/psisword.ogg'

/obj/item/psychic_power/psiblade/Initialize()
	. = ..()
	switch(owner.psi.get_rank())
		if(PSI_RANK_SENSITIVE)
			force = 20
			armor_penetration = 10
		if(PSI_RANK_HARMONIOUS)
			force = 25
			armor_penetration = 20
		if(PSI_RANK_APEX)
			force = 30
			armor_penetration = 30
			icon_state = "psiblade_long"

/obj/item/psychic_power/psiblade/dropped(var/mob/living/user)
	. = ..()
	playsound(loc, 'sound/effects/psi/power_fail.ogg', 30, 1)
	QDEL_IN(src, 1)
