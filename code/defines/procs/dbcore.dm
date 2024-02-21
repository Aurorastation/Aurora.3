//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//cursors
#define Default_Cursor	0
#define Client_Cursor	1
#define Server_Cursor	2
//conversions
#define TEXT_CONV		1
#define RSC_FILE_CONV	2
#define NUMBER_CONV		3
//column flag values:
#define IS_NUMERIC		1
#define IS_BINARY		2
#define IS_NOT_NULL		4
#define IS_PRIMARY_KEY	8
#define IS_UNSIGNED		16
//types
#define TINYINT		1
#define SMALLINT	2
#define MEDIUMINT	3
#define INTEGER		4
#define BIGINT		5
#define DECIMAL		6
#define FLOAT		7
#define DOUBLE		8
#define DATE		9
#define DATETIME	10
#define TIMESTAMP	11
#define TIME		12
#define STRING		13
#define BLOB		14
// TODO: Investigate more recent type additions and see if I can handle them. - Nadrew

/DBConnection
	var/_db_con // This variable contains a reference to the actual database connection.
	var/con_dbi // This variable is a string containing the DBI MySQL requires.
	var/con_user // This variable contains the username data.
	var/con_password // This variable contains the password data.
	var/con_cursor // This contains the default database cursor data.
	var/con_server = ""
	var/con_port = 3306
	var/con_database = ""
	var/failed_connections = 0
	var/last_fail

GENERAL_PROTECT_DATUM(/DBConnection)

/DBConnection/New(server, port = 3306, database, username, password_handler, cursor_handler = Default_Cursor, dbi_handler)
	con_user = username
	con_password = password_handler
	con_cursor = cursor_handler
	con_server = server
	con_port = port
	con_database = database

	if (dbi_handler)
		con_dbi = dbi_handler
	else
		con_dbi = "dbi:mysql:[database]:[server]:[port]"

	_db_con = _dm_db_new_con()

/DBConnection/proc/Connect(dbi_handler = con_dbi, user_handler = con_user, password_handler = con_password, cursor_handler)
	if (!GLOB.config.sql_enabled)
		return 0
	if (!src)
		return 0
	cursor_handler = con_cursor
	if (!cursor_handler)
		cursor_handler = Default_Cursor
	return _dm_db_connect(_db_con, dbi_handler, user_handler, password_handler, cursor_handler, null)

/DBConnection/proc/Disconnect()
	return _dm_db_close(_db_con)

/DBConnection/proc/Reconnect()
	Disconnect()
	Connect()

/DBConnection/proc/IsConnected()
	if(!GLOB.config.sql_enabled)
		return 0
	var/success = _dm_db_is_connected(_db_con)
	return success

/DBConnection/proc/Quote(str)
	return _dm_db_quote(_db_con,str)

/DBConnection/proc/ErrorMsg()
	return _dm_db_error_msg(_db_con)

/DBConnection/proc/SelectDB(database_name, new_dbi)
	if (IsConnected())
		Disconnect()
	con_database = database_name
	return Connect(new_dbi ? new_dbi : "dbi:mysql:[database_name]:[con_server]:[con_port]", con_user, con_password)

/DBConnection/proc/NewQuery(sql_query, cursor_handler = con_cursor)
	return new/DBQuery(sql_query, src, cursor_handler)

/*
Takes a list of rows (each row being an associated list of column => value) and inserts them via a single mass query.
Rows missing columns present in other rows will resolve to SQL NULL
You are expected to do your own escaping of the data, and expected to provide your own quotes for strings.
The duplicate_key arg can be true to automatically generate this part of the query
	or set to a string that is appended to the end of the query
Ignore_errors instructes mysql to continue inserting rows if some of them have errors.
	the erroneous row(s) aren't inserted and there isn't really any way to know why or why errored
Delayed insert mode was removed in mysql 7 and only works with MyISAM type tables,
	It was included because it is still supported in mariadb.
	It does not work with duplicate_key and the mysql server ignores it in those cases
*/
/DBConnection/proc/MassInsert(table, list/rows, duplicate_key = FALSE, ignore_errors = FALSE, delayed = FALSE)
	if (!table || !rows || !istype(rows))
		return
	var/list/columns = list()
	var/list/sorted_rows = list()

	for (var/list/row in rows)
		var/list/sorted_row = list()
		sorted_row.len = columns.len
		for (var/column in row)
			var/idx = columns[column]
			if (!idx)
				idx = columns.len + 1
				columns[column] = idx
				sorted_row.len = columns.len

			sorted_row[idx] = row[column]
		sorted_rows[++sorted_rows.len] = sorted_row

	if (duplicate_key == TRUE)
		var/list/column_list = list()
		for (var/column in columns)
			column_list += "[column] = VALUES([column])"
		duplicate_key = "ON DUPLICATE KEY UPDATE [column_list.Join(", ")]\n"
	else if (duplicate_key == FALSE)
		duplicate_key = null

	if (ignore_errors)
		ignore_errors = " IGNORE"
	else
		ignore_errors = null

	if (delayed)
		delayed = " DELAYED"
	else
		delayed = null

	var/list/sqlrowlist = list()
	var/len = columns.len
	for (var/list/row in sorted_rows)
		if (length(row) != len)
			row.len = len
		for (var/value in row)
			if (value == null)
				value = "NULL"
		sqlrowlist += "([row.Join(", ")])"

	sqlrowlist = "	[sqlrowlist.Join(",\n	")]"
	var/DBQuery/Query = NewQuery("INSERT[delayed][ignore_errors] INTO [table]\n([columns.Join(", ")])\nVALUES\n[sqlrowlist]\n[duplicate_key]")

	return Query.Execute()

/DBQuery
	var/sql // The sql query being executed.
	var/default_cursor
	var/list/columns //list of DB Columns populated by Columns()
	var/list/conversions
	var/list/item[0]  //list of data values populated by NextRow()

	var/DBConnection/db_connection
	var/_db_query

/DBQuery/New(var/sql_query, var/DBConnection/connection_handler, var/cursor_handler)
	if (sql_query)
		sql = sql_query
	if (connection_handler)
		db_connection = connection_handler
	if (cursor_handler)
		default_cursor = cursor_handler
	_db_query = _dm_db_new_query()
	return ..()

/DBQuery/proc/Connect(var/DBConnection/connection_handler)
	db_connection = connection_handler

/DBQuery/proc/Execute(var/list/argument_list = null, var/pass_not_found = 0, sql_query = sql, cursor_handler = default_cursor)
	Close()

	if (argument_list)
		sql_query = parseArguments(sql_query, argument_list, pass_not_found)

	var/result = _dm_db_execute(_db_query, sql_query, db_connection._db_con, cursor_handler, null)

	var/error = ErrorMsg()
	if (error)
		log_sql("SQL Error: '[error]'")
		log_sql(" - during query: [sql_query]")
		// This is hacky and should probably be changed
		if (error == "MySQL server has gone away")
			log_game("MySQL connection drop detected, attempting to reconnect.")
			log_sql("MySQL connection drop detected, attempting to reconnect.")
			message_admins("MySQL connection drop detected, attempting to reconnect.")
			db_connection.Reconnect()

	return result

/DBQuery/proc/NextRow()
	return _dm_db_next_row(_db_query,item,conversions)

/DBQuery/proc/RowsAffected()
	return _dm_db_rows_affected(_db_query)

/DBQuery/proc/RowCount()
	return _dm_db_row_count(_db_query)

/DBQuery/proc/ErrorMsg()
	return _dm_db_error_msg(_db_query)

/DBQuery/proc/Columns()
	if (!columns)
		columns = _dm_db_columns(_db_query,/DBColumn)
	return columns

/DBQuery/proc/GetRowData()
	var/list/columns = Columns()
	var/list/results
	if (columns.len)
		results = list()
		for (var/C in columns)
			results += C
			var/DBColumn/cur_col = columns[C]
			results[C] = item[(cur_col.position+1)]
	return results

/DBQuery/proc/Close()
	item.len = 0
	columns = null
	conversions = null
	return _dm_db_close(_db_query)

/DBQuery/proc/Quote(str)
	return db_connection.Quote(str)

/DBQuery/proc/SetConversion(column,conversion)
	if (istext(column))
		column = columns.Find(column)
	if (!conversions)
		conversions = new/list(column)
	else if (conversions.len < column)
		conversions.len = column
	conversions[column] = conversion

/**
* Automatic query parsing. Works similarly to any SQL prepared statement system.
*
* You pass in here a query which has special argument markers (we use :marker: style),
* and a map of argument -> content. Note that in this map, the argument key should not
* contain the colon delimiters. So while it's :marker: in the query, in the args list,
* it would be list("marker" = somevar).
*
* The parser will then crawl the input query and replace any placeholders it finds
* with automatically sanitized values. Values can even be lists, at which point a
* MySQL list is generated: (VALUE1, VALUE2).
*
* @param	query_to_parse The query we will be parsing.
* @param	argument_list A map of markers associated with their values. Values can
* be numeric, strings, null, or lists of primitives. In case of null, MySQL NULL is
* used. In case of a list of primitives, a MySQL comma delimited list is used instead.
*
* @return	The parsed query upon success. null upon failure.
*/
/DBQuery/proc/parseArguments(var/query_to_parse = null, var/list/argument_list)
	if (!query_to_parse || !argument_list || !argument_list.len)
#ifdef UNIT_TEST
		log_world("ERROR: SQL ARGPARSE: Invalid arguments sent.")
#else
		log_sql("ERROR: SQL ARGPARSE: Invalid arguments sent.")
#endif
		return null

	var/parsed = ""
	var/list/cache = list()
	var/pos = 1
	var/search = 0
	var/curr_arg = ""

	// We crawl the key list first. This is required to properly notice missing
	// arguments/keys. Otherwise, list[non-key] will always result in null and
	// will thus be populated as NULL. Which is bad.
	for (var/key in argument_list)
		var/argument = argument_list[key]
		if (istext(argument))
			cache[key] = "[db_connection.Quote(argument)]"
		else if (isnum(argument))
			cache[key] = "[argument]"
		else if (istype(argument, /list))
			cache[key] = parse_db_lists(argument)
		else if (isnull(argument))
			cache[key] = "NULL"
		else
#ifdef UNIT_TEST
			log_world("ERROR: SQL ARGPARSE: Cannot identify argument! [key]. Argument: [argument]")
#else
			log_sql("ERROR: SQL ARGPARSE: Cannot identify argument! [key]. Argument: [argument]")
#endif
			return null

	while (1)
		search = findtext(query_to_parse, ":", pos)
		parsed += copytext(query_to_parse, pos, search)
		if (search)
			pos = search
			search = findtext(query_to_parse, ":", pos + 1)
			if (search)
				curr_arg = copytext(query_to_parse, pos + 1, search)
				if (cache[curr_arg])
					parsed += cache[curr_arg]
				else
#ifdef UNIT_TEST
					log_world("ERROR: SQL ARGPARSE: Unpopulated argument found in an SQL query.")
					log_world("ERROR: SQL ARGPARSE: [curr_arg]. Query: [query_to_parse]")
#else
					log_sql("SQL ARGPARSE: Unpopulated argument found in an SQL query.")
					log_sql("SQL ARGPARSE: [curr_arg]. Query: [query_to_parse]")
#endif
					return null

				pos = search + 1
				curr_arg = ""
				continue
			else
				parsed += copytext(query_to_parse, pos, search)

		break

	return parsed

/**
 * Generates a MySQL list from a list of primitives. Also escapes values.
 *
 * @param	argument The list of primitives we want to generate a MySQL list from.
 *
 * @return	A string representing the MySQL list if the parsing is successful.
 * "NULL", the MySQL null value, if parsing fails for some reason.
 */
/DBQuery/proc/parse_db_lists(var/list/argument)
	if (!argument || !istype(argument) || !argument.len)
		return "NULL"

	var/text = ""
	var/count = argument.len
	for (var/i = 1, i <= count, i++)
		if (isnum(argument[i]))
			text += "[argument[i]]"
		else
			text += db_connection.Quote(argument[i])

		if (i != count)
			text += ", "

	return "([text])"

/DBColumn
	var/name
	var/table
	var/position //1-based index into item data
	var/sql_type
	var/flags
	var/length
	var/max_length

/DBColumn/New(name_handler, table_handler, position_handler, type_handler, flag_handler, length_handler, max_length_handler)
	name = name_handler
	table = table_handler
	position = position_handler
	sql_type = type_handler
	flags = flag_handler
	length = length_handler
	max_length = max_length_handler
	return ..()


/DBColumn/proc/SqlTypeName(type_handler = sql_type)
	switch (type_handler)
		if (TINYINT)
			return "TINYINT"
		if (SMALLINT)
			return "SMALLINT"
		if (MEDIUMINT)
			return "MEDIUMINT"
		if (INTEGER)
			return "INTEGER"
		if (BIGINT)
			return "BIGINT"
		if (FLOAT)
			return "FLOAT"
		if (DOUBLE)
			return "DOUBLE"
		if (DATE)
			return "DATE"
		if (DATETIME)
			return "DATETIME"
		if (TIMESTAMP)
			return "TIMESTAMP"
		if (TIME)
			return "TIME"
		if (STRING)
			return "STRING"
		if (BLOB)
			return "BLOB"


#undef Default_Cursor
#undef Client_Cursor
#undef Server_Cursor
#undef TEXT_CONV
#undef RSC_FILE_CONV
#undef NUMBER_CONV
#undef IS_NUMERIC
#undef IS_BINARY
#undef IS_NOT_NULL
#undef IS_PRIMARY_KEY
#undef IS_UNSIGNED
#undef TINYINT
#undef SMALLINT
#undef MEDIUMINT
#undef INTEGER
#undef BIGINT
#undef DECIMAL
#undef FLOAT
#undef DOUBLE
#undef DATE
#undef DATETIME
#undef TIMESTAMP
#undef TIME
#undef STRING
#undef BLOB
