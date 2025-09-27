#pragma once

#ifndef $safeprojectname$Cmd_H
#define $safeprojectname$Cmd_H
//
// Copyright (C) $year$ $username$
// 
// File: $safeprojectname$Cmd.h
//
// MEL Command: $safeprojectname$
//
// Author: Maya Plug-in Wizard 2.0 Reimplemented
//

#include <maya/MPxCommand.h>

class MArgList;

class $safeprojectname$Cmd : public MPxCommand {
private:
    // Store the data you will need to undo the command here

public:
    $safeprojectname$Cmd();
	virtual ~$safeprojectname$Cmd();

	static const MString kCommandName;

	MStatus doIt(const MArgList&);
	MStatus redoIt();
	MStatus undoIt();
	bool isUndoable() const;

	static void* creator();
};

#endif
