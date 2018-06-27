/var/datum/controller/subsystem/records/SSrecords

/datum/controller/subsystem/records
    name = "Records"
    flags = SS_NO_FIRE

    var/list/records
    var/list/records_locked
    var/list/excluded_fields

/datum/controller/subsystem/records/New()
    records = list()
    records_locked = list()
    excluded_fields = list()
    NEW_SS_GLOBAL(SSrecords)
    var/datum/D = new()
    for(var/v in D.vars)
        excluded_fields += v

/datum/controller/subsystem/records/proc/generate_record(var/mob/living/carbon/human/H)
    if(H.mind && SSjobs.ShouldCreateRecords(H.mind))
        var/datum/record/general/r = new(H)
        //Locked Data
        var/datum/record/general/l = r.Copy(new /datum/record/general/locked(H))
        records_locked += l
        add_record(r)

/datum/controller/subsystem/records/proc/add_record(var/datum/record/general/record)
    if(istype(record))
        records[record["id"]] = record

/datum/controller/subsystem/records/proc/remove_record(var/datum/record/general/record)
    records -= record
    qdel(record)

/datum/controller/subsystem/records/proc/remove_record_by_field(var/field, var/value, var/record_type = RECORD_GENERAL)
    remove_record(find_record(field, value, record_type))

/datum/controller/subsystem/records/proc/find_record(var/field, var/value, var/record_type = RECORD_GENERAL)
    if(field in excluded_fields)
        return
    var/searchedList = records
    if(record_type & RECORD_LOCKED)
        searchedList = records_locked
    for(var/datum/record/general/r in searchedList)
        if(record_type & RECORD_GENERAL)
            if(r.vars[field] == value)
                return r
        if(record_type & RECORD_MEDICAL)
            if(r.medical.vars[field] == value)
                return r
        if(record_type & RECORD_SECURITY)
            if(r.security.vars[field] == value)
                return r

/datum/controller/subsystem/records/proc/build_records()
    set waitfor = FALSE
    for(var/mob/living/carbon/human/H in player_list)
        generate_record(H)

/proc/GetAssignment(var/mob/living/carbon/human/H)
    if(H.mind.role_alt_title)
        return H.mind.role_alt_title
    else if(H.mind.assigned_role)
        return H.mind.assigned_role
    else if(H.job)
        return H.job
    else
        return "Unassigned"

/proc/generate_record_id()
    return add_zero(num2hex(rand(1, 65535)), 4)