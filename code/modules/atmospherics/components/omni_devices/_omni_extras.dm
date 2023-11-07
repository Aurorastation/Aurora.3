//--------------------------------------------
// Omni device port types
//--------------------------------------------
#define ATM_NONE	0
#define ATM_INPUT	1
#define ATM_OUTPUT	2

#define ATM_O2		3	//Oxygen
#define ATM_N2		4	//Nitrogen
#define ATM_CO2		5	//Carbon Dioxide
#define ATM_P		6	//Phoron
#define ATM_N2O		7	//Nitrous Oxide
#define ATM_H		8	//Hydrogen
#define ATM_2H		9	//Deuterium
#define ATM_3H		10	//Tritium
#define ATM_HE		11	//Helium
#define ATM_B		12	//Boron
#define ATM_SO2		13	//Sulfur Dioxide
#define ATM_NO2		14	//Nitrogen Dioxide
#define ATM_CL2		15	//Chlorine
#define ATM_H2O 	16	//Steam

//--------------------------------------------
// Omni port datum
//
// Used by omni devices to manage connections
//  to other atmospheric objects.
//--------------------------------------------
/datum/omni_port
	var/obj/machinery/atmospherics/omni/master
	var/dir
	var/update = 1
	var/mode = 0
	var/concentration = 0
	var/con_lock = 0
	var/transfer_moles = 0
	var/datum/gas_mixture/air
	var/obj/machinery/atmospherics/node
	var/datum/pipe_network/network

/datum/omni_port/New(var/obj/machinery/atmospherics/omni/M, var/direction = NORTH)
	..()
	dir = direction
	if(istype(M))
		master = M
	air = new
	air.volume = 200

/datum/omni_port/proc/connect()
	if(node)
		return
	master.atmos_init()
	master.build_network()
	if(node)
		node.atmos_init()
		node.build_network()

/datum/omni_port/proc/disconnect()
	if(node)
		node.disconnect(master)
		master.disconnect(node)


//--------------------------------------------
// Need to find somewhere else for these
//--------------------------------------------

//returns a text string based on the direction flag input
// if capitalize is true, it will return the string capitalized
// otherwise it will return the direction string in lower case
/proc/dir_name(var/dir, var/capitalize = 0)
	var/string = null
	switch(dir)
		if(NORTH)
			string = "North"
		if(SOUTH)
			string = "South"
		if(EAST)
			string = "East"
		if(WEST)
			string = "West"

	if(!capitalize && string)
		string = lowertext(string)

	return string

//returns a direction flag based on the string passed to it
// case insensitive
/proc/dir_flag(var/dir)
	dir = lowertext(dir)
	switch(dir)
		if("north")
			return NORTH
		if("south")
			return SOUTH
		if("east")
			return EAST
		if("west")
			return WEST
		else
			return FALSE

/proc/mode_to_gasid(var/mode)
	switch(mode)
		if(ATM_O2)
			return GAS_OXYGEN
		if(ATM_N2)
			return GAS_NITROGEN
		if(ATM_CO2)
			return GAS_CO2
		if(ATM_P)
			return GAS_PHORON
		if(ATM_N2O)
			return GAS_N2O
		if(ATM_H)
			return GAS_HYDROGEN
		if(ATM_2H)
			return GAS_DEUTERIUM
		if(ATM_3H)
			return GAS_TRITIUM
		if(ATM_HE)
			return GAS_HELIUM
		if(ATM_B)
			return GAS_BORON
		if(ATM_SO2)
			return GAS_SULFUR
		if(ATM_NO2)
			return GAS_NO2
		if(ATM_CL2)
			return GAS_CHLORINE
		if(ATM_H2O)
			return GAS_STEAM
		else
			return null
