// Computer file types script, used by NTSL2++

/datum/computer_file/script
	var/code = ""			// Stored data in string format.
	filetype = "NTS"
	var/block_size = 1500

/datum/computer_file/script/clone()
	var/datum/computer_file/script/temp = ..()
	temp.code = code
	return temp

/datum/computer_file/script/proc/calculate_size()
	size = max(1, round(length(code) / block_size))