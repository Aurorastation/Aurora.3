/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/resomi/New(var/new_loc)
	h_style = "Resomi Plumage"
	..(new_loc, "Resomi")

/mob/living/carbon/human/skrell/New(var/new_loc)
	h_style = "Skrell Male Tentacles"
	..(new_loc, "Skrell")

/mob/living/carbon/human/tajaran/New(var/new_loc)
	h_style = "Tajaran Ears"
	..(new_loc, "Tajara")

/mob/living/carbon/human/unathi/New(var/new_loc)
	h_style = "Unathi Horns"
	..(new_loc, "Unathi")

/mob/living/carbon/human/vox/New(var/new_loc)
	h_style = "Short Vox Quills"
	..(new_loc, "Vox")

/mob/living/carbon/human/voxarmalis/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Vox Armalis")

/mob/living/carbon/human/diona/New(var/new_loc)
	..(new_loc, "Diona")
	src.gender = NEUTER

/mob/living/carbon/human/machine/New(var/new_loc)
	h_style = "blue IPC screen"
	..(new_loc, "Machine")

/mob/living/carbon/human/monkey
	mob_size = 2.6//Based on howler monkey, rough real world equivilant to on-mob sprite size

/mob/living/carbon/human/monkey/New(var/new_loc)
	..(new_loc, "Monkey")

/mob/living/carbon/human/farwa
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/farwa/New(var/new_loc)
	..(new_loc, "Farwa")

/mob/living/carbon/human/neaera
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/neaera/New(var/new_loc)
	..(new_loc, "Neaera")

/mob/living/carbon/human/stok
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/neaera/New(var/new_loc)
	..(new_loc, "Neaera")

/mob/living/carbon/human/bug
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/bug/New(var/new_loc)
	..(new_loc, "V'krexi")
	src.gender = FEMALE

/mob/living/carbon/human/type_a/New(var/new_loc)
	..(new_loc, "Vaurca Worker")
	src.gender = NEUTER

/mob/living/carbon/human/type_b/New(var/new_loc)
	..(new_loc, "Vaurca Warrior")
	src.gender = NEUTER

/mob/living/carbon/human/type_c/New(var/new_loc)
	..(new_loc, "Vaurca Breeder")
	src.gender = FEMALE

/mob/living/carbon/human/type_c
	mob_size = 30 //same size as moghes lizard