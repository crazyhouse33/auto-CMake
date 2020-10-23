# Configuring files as if it was the root directory
message ("Configuring files in /opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure:")
file(GLOB_RECURSE ALL_FILES * LIST_DIRECTORIES FALSE RELATIVE "/opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/root-mirror" CONFIGURE_DEPENDS)
FOREACH( SUB_FILE /opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/.CMakeLists.txt.swp;/opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/CMakeLists.txt;/opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/root-mirror/README.md)
	message("\tConfiguring /opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/CMakeLists.txt")

	configure_file(/opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/CMakeLists.txt "/opt/handCraftedUtilityShit/user_land_loader//opt/handCraftedUtilityShit/user_land_loader/build-helpers/configure/CMakeLists.txt")
ENDFOREACH()

