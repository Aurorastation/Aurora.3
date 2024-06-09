/mob/living/simple_animal/hostile/commanded/vaurca_retainer
	name = "vaurca retainer"
	short_name = "retainer"
	desc = "AA Type Workers, also called Retainers, are small and fill similar roles to that of maintenance drones. They are all exclusively Bound and deal with the more trivial repairs to ships, systems, and structures utilized by the various Hives as well as fulfilling extremely simple jobs such as the transportation of small objects. "

	icon = 'icons/mob/npc/vaurca_retainer.dmi'
	icon_state = "vaurca_retainer"
	icon_living = "vaurca_retainer"
	icon_dead = "vaurca_retainer"
	blood_type = COLOR_VAURCA_BLOOD

	health = 75
	maxHealth = 75

	stop_automated_movement_when_pulled = 1 //so people can drag the bug around
	density = 1

	speak_chance = 1
	turns_per_move = 7
	destroy_surroundings = FALSE

	speak = list("Khzz!", "Zhkhk.", "Khhozz.","Zhhhk!")
	speak_emote = list("chitters", "shuffles in place", "moves its claws")
	emote_hear = list("tilts its head and chitters")
	sad_emote = list("chitters lowly")
	emote_sounds = list('sound/voice/chitter1.ogg', 'sound/voice/chitter2.ogg', 'sound/voice/chitter3.ogg')

	attacktext = "harmlessly bitten"
	attack_sound = 'sound/weapons/bite.ogg'
	var/storage_type = /obj/item/storage/toolbox/bike_storage/retainer
	var/obj/item/storage/storage_compartment

	mob_size = 5
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	hunger_enabled = 1 //so you can feed your dog or something
	max_nutrition = 120

	known_commands = list("stay", "stop", "follow")

	destroy_surroundings = FALSE
	attack_emote = "clacks its claws at"
	attacktext = "harmlessly chomped"

	butchering_products = list(/obj/item/reagent_containers/food/snacks/meat/bug = 2)

/mob/living/simple_animal/hostile/commanded/vaurca_retainer/Initialize()
	. = ..()
	if(storage_type)
		storage_compartment = new storage_type(src)

/mob/living/simple_animal/hostile/commanded/vaurca_retainer/verb/befriend()
	set name = "Befriend Retainer"
	set category = "IC"
	set src in view(1)

	if(!master)
		var/mob/living/carbon/human/H = usr
		if(istype(H))
			master = usr
			audible_emote("[pick(emote_hear)].",0)
			playsound(src,'sound/voice/chitter1.ogg',100, 1)
			. = 1
	else if(usr == master)
		. = 1 //already friends, but show success anyways

	else
		to_chat(usr, SPAN_NOTICE("[src] ignores you."))

	return

/mob/living/simple_animal/hostile/commanded/vaurca_retainer/MouseDrop(atom/over)
	if(usr == over && ishuman(over))
		var/mob/living/carbon/human/H = over
		storage_compartment.open(H)

/obj/item/storage/toolbox/bike_storage/retainer
	name = "retainer storage"
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 16
