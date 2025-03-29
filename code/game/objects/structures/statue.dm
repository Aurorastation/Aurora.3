/obj/structure/rredouane_statue
	name = "\improper Rredouane statue"
	desc = "A statue of Rredouane, the Ma'ta'ke deity of valor, triumph, and victory."
	icon = 'icons/obj/statue.dmi'
	icon_state = "rredouane"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER

//Unathi statues
/obj/structure/unathi_pillar
	name = "pillar"
	desc = "An ancient and weathered sandstone pillar. It is covered in what looks like Sinta'Azaziba writing."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "pillar"
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE

/obj/structure/unathi_pillar/mador
	desc = "An ancient and weathered granite pillar. It is inscribed with symbols of an unknown language."
	icon_state = "mador_pillar"

/obj/structure/unathi_statue
	name = "ancient statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "statue"
	anchored = TRUE
	density = TRUE

/obj/structure/unathi_statue/warrior
	name = "warrior statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi. This one is armored, and wields a war scythe."
	icon_state = "warriorstatue_left"

/obj/structure/unathi_statue/warrior/right
	icon_state = "warriorstatue_right"

/obj/structure/unathi_statue/crown
	name = "crowned statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi. This one is robed, and wears a crown upon its head."
	icon_state = "crownstatue"

/obj/structure/unathi_statue/robe
	name = "robed statue"
	desc = "An ancient and crumbling sandstone statue of an Unathi. This one is clad in a humble robe and hood, and bears no weapons."
	icon_state = "robestatue"

/obj/structure/unathi_statue/mador
	desc = "An ancient and crumbling granite statue of an Unathi, worn away by time."
	icon_state = "mador_statue"

/obj/structure/unathi_statue/mador/armored
	name = "armored statue"
	desc = "An ancient and crumbling granite statue of an Unathi clad in strange and bulky armor."
	icon_state = "mador_statue_armored"

/obj/structure/unathi_statue/mador/warrior
	name = "warrior statue"
	desc = "An ancient and crumbling granite statue of an Unathi. This one is armored, and wields a trident."
	icon_state = "mador_statue_warrior_left"

/obj/structure/unathi_statue/mador/warrior/right
	icon_state = "mador_statue_warrior_right"

//Kowloon's statue
/obj/structure/kowloon_statue
	name = "Lady of Stone Sculpture"
	desc = "A sculpture and fish pond depicting the Lady of Stone, a personification of Konyang itself."
	desc_extended = "The Lady of Stone as character in Konyang culture first appeared two decades after initial colonization, in 2328.\
	The first depictions of her were limestone sculptures in the Renaissance style. The character is often depicted as a woman,\
	iterating on mother nature or gaia. Depictions quickly evolved as other artists adopted the subject. Today, depictions of the Lady\
	are split between traditional and casual classification. Traditional depictions are statues in that original style done in limestone,\
	marble, or any other white stone. Casual depictions contain all other depictions, including paintings, written word, plays, and music.\
	The Lady of Stone's popularity skyrocketed after the planet seceded from the Solarian Alliance."
	icon = 'icons/obj/kowloon_statue.dmi'
	icon_state = "kowloon_statue"
	density = TRUE
	anchored = TRUE
	can_be_unanchored = FALSE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/collision_object
	name = "filler"
	desc = "It stops people from walking into things. Its an invisible wall."
	icon = 'icons/obj/structure/urban/cars.dmi'
	icon_state = "blank"
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE
