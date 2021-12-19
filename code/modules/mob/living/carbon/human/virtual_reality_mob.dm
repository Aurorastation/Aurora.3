//this human mob is to be used in virtual reality, typically in their own environment where they won't interact with the rest of the world

/mob/living/carbon/human/virtual_reality/death(gibbed)//the body is deleted when you die to simulate your virtual avatar being deleted
	..()
	qdel(src)