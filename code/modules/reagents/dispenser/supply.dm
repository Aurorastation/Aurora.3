/datum/supply_packs/chemistry_dispenser
	name = "Reagent dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "reagent dispenser crate"
	group = "Reagents"

/datum/supply_packs/beer_dispenser
	name = "Booze dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_alc{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "booze dispenser crate"
	group = "Reagents"

/datum/supply_packs/soda_dispenser
	name = "Soda dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_soft{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "soda dispenser crate"
	group = "Reagents"

/datum/supply_packs/coffee_machine
	name = "Coffee machine"
	contains = list(
			/obj/machinery/chemical_dispenser/coffee{anchored = 0}
		)
	cost = 30
	containertype = /obj/structure/largecrate
	containername = "coffee machine crate"
	group = "Hospitality"

datum/supply_packs/dispenser_cartridges/coffee_beans
	name = "Coffee beans"
	containername = "coffee beans crate"
	containertype = /obj/structure/closet/crate
	cost = 15
	contains = list(
	)
	group = "Hospitality"

/datum/supply_packs/reagents
	name = "Chemistry dispenser refill"
	contains = list(
		)
	cost = 150
	containertype = /obj/structure/closet/crate/secure
	containername = "chemical crate"
	access = list(access_chemistry)
	group = "Reagents"

/datum/supply_packs/alcohol_reagents
	name = "Bar alcoholic dispenser refill"
	contains = list(
		)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "alcoholic drinks crate"
	access = list(access_bar)
	group = "Reagents"

/datum/supply_packs/softdrink_reagents
	name = "Bar soft drink dispenser refill"
	contains = list(
		)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "soft drinks crate"
	group = "Reagents"

/datum/supply_packs/dispenser_cartridges
	name = "Empty dispenser cartridges"
	contains = list(
		)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "dispenser cartridge crate"
	group = "Reagents"

#define SEC_PACK(_tname, _type, _name, _cname, _cost, _access)\
	datum/supply_packs/dispenser_cartridges{\
		_tname {\
			name = _name ;\
			containername = _cname ;\
			containertype = /obj/structure/closet/crate/secure;\
			access = list( _access );\
			cost = _cost ;\
			contains = list( _type , _type );\
			group = "Reagent Cartridges"\
		}\
	}
#define PACK(_tname, _type, _name, _cname, _cost)\
	datum/supply_packs/dispenser_cartridges{\
		_tname {\
			name = _name ;\
			containername = _cname ;\
			containertype = /obj/structure/closet/crate;\
			cost = _cost ;\
			contains = list( _type , _type );\
			group = "Reagent Cartridges"\
		}\
	}

// Chemistry-restricted (raw reagents excluding sugar/water)
//      Datum path  Contents type                                                       Supply pack name                  Container name                         Cost  Container access

// Bar-restricted (alcoholic drinks)
//      Datum path Contents type                                                     Supply pack name             Container name                    Cost  Container access

// Unrestricted (water, sugar, non-alcoholic drinks)
//  Datum path   Contents type                                                       Supply pack name                        Container name                                          Cost

#undef SEC_PACK
#undef PACK
