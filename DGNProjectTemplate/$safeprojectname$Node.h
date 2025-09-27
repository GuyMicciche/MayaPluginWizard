#ifndef $safeprojectname$Node_H
#define $safeprojectname$Node_H
//
// Copyright (C) $year$ $username$
// 
// File: $safeprojectname$Node.h
//
// Dependency Graph Node: $safeprojectname$
//
// Author: Maya Plug-in Wizard 2.0 Reimplemented
//

#include <maya/MPxNode.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MTypeId.h> 

 
class $safeprojectname$Node : public MPxNode {
public:
	$safeprojectname$Node();
	virtual ~$safeprojectname$Node();
	virtual void postConstructor();
	static void* creator();
	virtual MStatus compute(const MPlug& plug, MDataBlock& dataBlock) override;
	static MStatus initialize();

	/* The typeid is a unique 32bit identifier that describes this node.
	It is used to save and retrieve nodes of this type from the binary
	file format.  If it is not unique, it will cause file IO problems. */
	static const MString kTypeName;
	static const MTypeId kTypeId;
	static const MString kDrawClassification;
	static const MString kRegistrantId;

	/* There needs to be a MObject handle declared for each attribute that
	the node will have.  These handles are needed for getting and setting
	the values later. */
	static MObject aInput;		                // Example input attribute
	static MObject aOutput;		                // Example output attribute
};

#endif
