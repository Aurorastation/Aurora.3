

/datum/controller/subsystem/ntsl2/proc/new_program_computer(var/computer)
    var/res = send("new_program", list(ref = "\ref[computer]", type = "Computer"))
    if(res)
        var/datum/ntsl2_program/computer/P = new(res)
        programs += P
        return P
    return FALSE

/datum/ntsl2_program/computer
    name = "NTSL2++ interpreter"

/datum/ntsl2_program/computer/proc/get_buffer()
    return SSntsl2.send("get_buffer", list(id = id))

/datum/ntsl2_program/computer/proc/handle_topic(var/topic)
    if(copytext(topic, 1, 2) == "?")
        var/data = input("", "Enter Data")
        SSntsl2.send("topic", list(id = id, topic = copytext(topic, 2), data = data))
    else
        SSntsl2.send("topic", list(id = id, topic = topic))
