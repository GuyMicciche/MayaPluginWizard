//
// Copyright (C) $year$ $username$
// 
// File: $safeprojectname$Main.cpp
//
// Author: Maya Plug-in Wizard 2.0 Reimplemented
//

#include "$safeprojectname$Cmd.h"

#include <maya/MFnPlugin.h>

const char* kVendor = "$username$";
const char* kVersion = "1.0.0";
const char* kRequiredApiVersion = "Any";

/**
*	Description:
*		this method is called when the plug-in is loaded into Maya.  It 
*		registers all of the services that this plug-in provides with 
*		Maya.
*
*	Arguments:
*		obj - a handle to the plug-in object (use MFnPlugin to access it)
**/
MStatus initializePlugin(MObject plugin) {
	MStatus status;
	MFnPlugin fnPlugin(plugin, kVendor, kVersion, kRequiredApiVersion, &status);

	status = fnPlugin.registerCommand(
		$safeprojectname$Cmd::kCommandName,
		$safeprojectname$Cmd::creator
	);
	CHECK_MSTATUS_AND_RETURN_IT(status);

	return status;
}

/**
*	Description:
*		this method is called when the plug-in is unloaded from Maya. It
*		deregisters all of the services that it was providing.
*
*	Arguments:
*		obj - a handle to the plug-in object (use MFnPlugin to access it)
**/
MStatus uninitializePlugin(MObject plugin) {
	MStatus status;
	MFnPlugin fnPlugin(plugin, kVendor, kVersion, kRequiredApiVersion, &status);

	status = fnPlugin.deregisterCommand($safeprojectname$Cmd::kCommandName);
	CHECK_MSTATUS_AND_RETURN_IT(status);

	return status;
}
