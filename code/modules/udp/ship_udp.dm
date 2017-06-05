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

	You can easily send UDP Data via the UDPSHipper.dll

	Simply use the call() function to call the udp shipper DLL and enter your details!

	The first bit of code needed will always be the same, You will never have to touch this, Copy-pasta all you like:

			call("UDPShipper.dll", "send_udp_data")

	Well thats the first part, the harder part is to input the details into DLL. Lets do that now! The syntax to add arguments to the post request is:

			call("UDPShipper.dll", "send_udp_data")(DestinationIP, DestinationPort, Data)

	DLL Written by Arrow768
*/

/*
 * A generic proc for sending udp request with the aforementioned .DLL files.
 * Expected arg structure:
 * 1st arg			- the destination ip
 * 2nd arg			- the destination port
 * 3rd arg			- The Data to send
 *
 * @return int		- Error code
 * -1 indicates proc or library failure.
 *
 */
/proc/send_udp_data()
    if (args.len < 3)
        return -1

    var/result = call("UDPShipper.dll", "send_udp_data")(arglist(args))

    return result

/proc/send_gelf_log(short_message="", long_message="", level = 5, category="", additional_data=list())
    if (!config)
        return 100
    if (!config.log_gelf_enabled)
        return 101
    var/list/log_data = list()
    log_data["version"] = "1.1"
    log_data["host"] = world.name
    log_data["short_message"] = html_encode(short_message)
    log_data["long_message"] = html_encode(long_message)
    log_data["level"] = level
    log_data["_category"] = category
    log_data["_game_id"] = game_id

    log_data.Add(additional_data)
    var/gelf_log = json_encode(log_data)
    return send_udp_data(config.log_gelf_ip,config.log_gelf_port,gelf_log)

/obj/item/device/udp_debugger
    name = "udp_debugger"
    desc = "Used to debug UDP Data sent to the log server."
    icon = 'icons/obj/hacktool.dmi'
    icon_state = "hacktool-g"
    force = 5.0
    w_class = 2.0
    throwforce = 5.0
    throw_range = 15
    throw_speed = 3
    desc = "You can use this to debug sending udp logs to the log server"

/obj/item/device/udp_debugger/proc/raw(ip=config.log_gelf_ip,port=config.log_gelf_port,data="RAW Test String")
    return send_udp_data(ip,port,data)

/obj/item/device/udp_debugger/proc/gelf(short_message="", long_message="", level = 1)
    return send_gelf_log(short_message, long_message, level)
