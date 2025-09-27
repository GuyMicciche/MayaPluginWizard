//
// Copyright (C) $year$ $username$
// 
// File: $safeprojectname$Cmd.cpp
//
// MEL Command: $safeprojectname$
//
// Author: Maya Plug-in Wizard 2.0 Reimplemented
//

#include "$safeprojectname$Cmd.h"

#include <maya/MGlobal.h>
#include <maya/MArgDatabase.h>

const MString $safeprojectname$Cmd::kCommandName("$username$$safeprojectname$");

/** 
*   Description:
*		implements the MEL $safeprojectname$ command.
*
*	Arguments:
*		args - the argument list that was passes to the command from MEL
*
*	Return Value:
*		MS::kSuccess - command succeeded
*		MS::kFailure - command failed (returning this value will cause the 
*                      MEL script that is being run to terminate unless the
*                      error is caught using a "catch" statement. 
**/
MStatus $safeprojectname$Cmd::doIt(const MArgList& args) {
	MStatus status;
	MArgDatabase argData(syntax(), args, &status);
	CHECK_MSTATUS_AND_RETURN_IT(status);

	/* Typically, the doIt() method only collects the infomation required
	to do/undo the action and then stores it in class members.  The 
	redo method is then called to do the actuall work.  This prevents
	code duplication. */
	return redoIt();
}

/**
*   Description:
*		implements redo for the MEL $safeprojectname$ command.
*
*		This method is called when the user has undone a command of this type
*		and then redoes it.  No arguments are passed in as all of the necessary
*		information is cached by the doIt method.
*
*	Return Value:
*		MS::kSuccess - command succeeded
*		MS::kFailure - redoIt failed.  this is a serious problem that will
*                      likely cause the undo queue to be purged
**/
MStatus $safeprojectname$Cmd::redoIt() {
	/* Since this class is derived off of MPxCommand, you can use the 
	inherited methods to return values and set error messages */
	setResult(MString(kCommandName) + " command executed!\n");

	return MS::kSuccess;
}

/**
*	Description:
*		implements undo for the MEL $safeprojectname$ command.  
*
*		This method is called to undo a previous command of this type.  The 
*		system should be returned to the exact state that it was it previous 
*		to this command being executed.  That includes the selection state.
*
*	Return Value:
*		MS::kSuccess - command succeeded
*		MS::kFailure - redoIt failed.  this is a serious problem that will
*                      likely cause the undo queue to be purged
**/
MStatus $safeprojectname$Cmd::undoIt() {
	/* You can also display information to the command window via MGlobal */
    MGlobal::displayInfo(MString(kCommandName) + " command undone!\n");

	return MS::kSuccess;
}

/**
*	Description:
*		this method exists to give Maya a way to create new objects
*       of this type. 
*
*	Return Value:
*		a new object of this type
**/
void* $safeprojectname$Cmd::creator() {
	return new $safeprojectname$Cmd();
}

/**
*	Description:
*		$safeprojectname$ constructor
**/
$safeprojectname$Cmd::$safeprojectname$Cmd() {}

/**
*	Description:
*		$safeprojectname$ destructor
**/
$safeprojectname$Cmd::~$safeprojectname$Cmd() {}

/**
*	Description:
*		this method tells Maya this command is undoable.  It is added to the 
*		undo queue if it is.
*
*	Return Value:
*		true if this command is undoable.
**/
bool $safeprojectname$Cmd::isUndoable() const {
	return true;
}
