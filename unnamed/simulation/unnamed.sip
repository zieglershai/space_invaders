set_global_assignment -entity "unnamed" -library "lib_unnamed" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "unnamed" -library "lib_unnamed" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "unnamed" -library "lib_unnamed" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_unnamed" -name SPD_FILE [file join $::quartus(sip_path) "../unnamed.spd"]
set_global_assignment -library "lib_unnamed" -name MISC_FILE [file join $::quartus(sip_path) "../../unnamed.qsys"]

set_global_assignment -library "lib_unnamed" -name MISC_FILE [file join $::quartus(sip_path) "unnamed.v"]
set_global_assignment -library "lib_unnamed" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_util.v"]
set_global_assignment -library "lib_unnamed" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash.v"]
set_global_assignment -library "lib_unnamed" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_data_controller.v"]
set_global_assignment -library "lib_unnamed" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_csr_controller.v"]
