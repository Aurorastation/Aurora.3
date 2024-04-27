/**
 * Debug verb for our custom UDP module, generally used for gelf logging
 */
/client/proc/rustg_send_udp()
	set name = "RUSTG Send UDP"
	set category = "Debug"
	set desc = "Sends an UDP text packet using our rust_g custom module."
	var/destination = input(usr, "Address in ip:port format.", "Address", null)
	var/message = input(usr, "Message to send.", "Message", null)

	if(destination && message)
		rustg_udp_send(destination, message)
