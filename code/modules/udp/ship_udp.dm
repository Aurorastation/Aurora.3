/**
* Copyright (c) 2017 "Werner Maisl"
*
* This file is part of Aurora.3
* Aurora.3 is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/
/*

	@===================================@
	|                                   |
	|    Guide to UDP Data Shipping     |
	|                                   |
	@===================================@

	The prerequisite for using this is rustg compiled with the udp_shipper feature.

	Rustg's rustg_udp_send function is used to send data.
*/

/**
 * Sends data via UDP.
 *
 * addr must be formatted as "ip:port".
 * data must be a string to be sent.
 */
/proc/send_udp_data(addr, data)
#ifdef RUST_G
#	ifndef rustg_udp_send
#		error rustg_udp_send macro is not defined for rustg.
#	endif // rustg_udp_send

	if (!addr || !data)
		return "Not enough args."

	. = rustg_udp_send(addr, data)

	if (.)
		log_world("ERROR: UDP Sender error: [.]")

#else
	return
#endif // RUST_G

/proc/send_gelf_log(short_message="", long_message="", level = 5, category="", additional_data=list())
	if (!GLOB.config)
		return "Configuration not loaded."
	if (!GLOB.config.logsettings["log_gelf_enabled"])
		return "Gelf logging not enabled."
	var/list/log_data = list()
	log_data["version"] = "1.1"
	log_data["host"] = world.name
	log_data["short_message"] = html_encode(short_message)
	log_data["long_message"] = html_encode(long_message)
	log_data["level"] = level
	log_data["_category"] = category
	log_data["_game_id"] = GLOB.round_id

	log_data.Add(additional_data)
	var/gelf_log = json_encode(log_data)
	return send_udp_data(GLOB.config.logsettings["log_gelf_addr"], gelf_log)
