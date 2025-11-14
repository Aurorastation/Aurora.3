
// ------------------- base/parent type

ABSTRACT_TYPE(/singleton/role)
	/// The role's name.
	var/name = "Generic Goon"
	/// The role's description. It should contain the information on what it's supposed to do.
	var/desc = "Your job is to be a generic goon in this scenario. Nothing special."
	/// The /obj/outfit this role equips you with.
	var/outfit = /obj/outfit/admin/generic

// ------------------- generic subtypes

/singleton/role/generic_crew
	name = "Generic Worker"
	desc = "You are some basic crew or worker. You have just some clothes, a jacket, and a bag."
	outfit = /obj/outfit/admin/generic

/singleton/role/generic_engineer
	name = "Generic Engineer"
	desc = "You are some engineer. You have engineer tools, perhaps a hardhat, or a reflective hazard vest."
	outfit = /obj/outfit/admin/generic/engineer

/singleton/role/generic_research
	name = "Generic Researcher"
	desc = "You are some researcher. You have a labcoat, perhaps safety goggles."
	outfit = /obj/outfit/admin/generic/science

/singleton/role/generic_medical
	name = "Generic Medical Practitioner"
	desc = "You are some medical practicioner, a physician, or paramedic. You have a first aid kit, and a full medical belt."
	outfit = /obj/outfit/admin/generic/medical

/singleton/role/generic_security
	name = "Generic Security Guard"
	desc = "You are some security guard or officer. You have a full security belt, and perhaps a plate carrier."
	outfit = /obj/outfit/admin/generic/security

/singleton/role/generic_miner
	name = "Generic Miner"
	desc = "You are some miner. You have mining tools, a KA, and a lantern."
	outfit = /obj/outfit/admin/generic/mining

/singleton/role/generic_business
	name = "Generic Businessperson"
	desc = "You are some businessperson, dressed in a nice suit, with a wallet full of cash."
	outfit = /obj/outfit/admin/generic/business

/singleton/role/generic_mercenary
	name = "Generic Mercenary"
	desc = "You are some mercenary, dressed all tacticool, with a plate carrier and helmet, 9mm pistol with a few mags, and zipties."
	outfit = /obj/outfit/admin/generic/mercenary
