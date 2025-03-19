/obj/item/psychic_power/psiblade
	name = "psionic blade"
	force = 15
	sharp = 1
	edge = TRUE
	maintain_cost = 1
	icon_state = "psiblade_short"
	hitsound = 'sound/weapons/psisword.ogg'

/obj/item/psychic_power/psiblade/Initialize()
	. = ..()
	switch(owner.psi.get_rank())
		if(PSI_RANK_SENSITIVE)
			force = 25
			armor_penetration = 10
		if(PSI_RANK_HARMONIOUS)
			force = 31
			armor_penetration = 20
		if(PSI_RANK_APEX)
			force = 33
			armor_penetration = 30
			icon_state = "psiblade_long"
		if(PSI_RANK_LIMITLESS)
			force = 40
			armor_penetration = 40
			icon_state = "psiblade_long"

/obj/item/psychic_power/psiblade/dropped(mob/user)
	. = ..()
	playsound(loc, 'sound/effects/psi/power_fail.ogg', 30, 1)
	QDEL_IN(src, 1)
