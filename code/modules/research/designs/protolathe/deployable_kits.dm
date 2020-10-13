/datum/design/item/deployable_kit
	p_category = "Deployable Kit Designs"

/datum/design/item/deployable_kit/mech_chair
	name = "Remote Mech Centre"
	desc = "A deployable kit of a remote mech chair, capable of listening in to standard remote mech networks."
	req_tech = list('programming':4,'engineering':4,'materials':4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_SILVER = 750, MATERIAL_URANIUM = 250)
	build_path = /obj/item/deployable_kit/remote_mech

/datum/design/item/deployable_kit/mech_chair/brig
	name = "Remote Penal Mech Centre"
	desc = "A deployable kit of a remote mech chair, capable of listening in to penal remote mech networks."
	build_path = /obj/item/deployable_kit/remote_mech/brig