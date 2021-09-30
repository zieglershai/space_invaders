set_global_assignment -entity "my_ROM" -library "lib_my_ROM" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "my_ROM" -library "lib_my_ROM" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "my_ROM" -library "lib_my_ROM" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_my_ROM" -name SPD_FILE [file join $::quartus(sip_path) "../my_ROM.spd"]
set_global_assignment -library "lib_my_ROM" -name MISC_FILE [file join $::quartus(sip_path) "../../my_ROM.qsys"]

set_global_assignment -library "lib_my_ROM" -name MISC_FILE [file join $::quartus(sip_path) "my_ROM.v"]
set_global_assignment -library "lib_my_ROM" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_util.v"]
set_global_assignment -library "lib_my_ROM" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash.v"]
set_global_assignment -library "lib_my_ROM" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_data_controller.v"]
