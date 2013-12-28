

macro(merged_files_build _allinone_name _list)
	set(_file_list ${_allinone_name}_files)
	set(_file_const ${CMAKE_CURRENT_BINARY_DIR}/${_allinone_name}_const.cpp)
	set(_file_touched ${CMAKE_CURRENT_BINARY_DIR}/${_allinone_name}_touched.cpp)

	# don't touch existing or non-empty file,
	# so a cmake re-run doesn't touch all created files
	set(_rebuild_file_const 0)
	if (NOT EXISTS ${_file_const})
		set(_rebuild_file_const 1)
	else()
		FILE(READ ${_file_const} _file_content)
		if (NOT _file_content)
			set(_rebuild_file_const 1)
		endif()
	endif()

	set(_rebuild_file_touched 0)
	if (NOT EXISTS ${_file_touched})
		set(_rebuild_file_touched 1)
	else()
		FILE(READ ${_file_touched} _file_content)
		if (NOT _file_content)
			set(_rebuild_file_touched 1)
		endif()
	endif()

	if (merged_files_rebuild)
		set(_rebuild_file_const 1)
		set(_rebuild_file_touched 1)
	endif()

	if (_rebuild_file_const)
		file(WRITE  ${_file_const} "// autogenerated file \n//\n")
		file(APPEND ${_file_const} "//    * clear or delete this file to build it again by cmake \n//\n\n")
	endif()

	if (_rebuild_file_touched)
		file(WRITE  ${_file_touched} "// autogenerated file \n//\n")
		file(APPEND ${_file_touched} "//    * clear or delete this file to build it again by cmake \n//\n")
		file(APPEND ${_file_touched} "//    * don't touch this file \n//\n\n")
		file(APPEND ${_file_touched} "#define DONT_INCLUDE_CONST_FILES\n")
		file(APPEND ${_file_touched} "#include \"${_file_const}\"\n\n\n")
	endif()

	set(${_file_list} ${_file_const} ${_file_touched})

	foreach (_current_FILE ${${_list}})
		get_filename_component(_abs_FILE ${_current_FILE} ABSOLUTE)

		GET_FILENAME_COMPONENT(_file_name ${_abs_FILE} NAME_WE)
		STRING(REGEX REPLACE "-" "_" _file_name "${_file_name}")
		set(__macro_name ${_file_name}___ASSUME_CONST)

		if (_rebuild_file_const)
			file(APPEND ${_file_const}  "#define ${__macro_name}\n")
			file(APPEND ${_file_const}  "#if defined(${__macro_name}) && !defined(DONT_INCLUDE_CONST_FILES)\n")
			file(APPEND ${_file_const}  "#include \"${_abs_FILE}\"\n")
			file(APPEND ${_file_const}  "#endif\n\n")
		endif()

		if (_rebuild_file_touched)
			file(APPEND ${_file_touched}  "#ifndef ${__macro_name}\n")
			file(APPEND ${_file_touched}  "#include \"${_abs_FILE}\"\n")
			file(APPEND ${_file_touched}  "#endif\n\n")
		endif()
	endforeach (_current_FILE)
endmacro()






