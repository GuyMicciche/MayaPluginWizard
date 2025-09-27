//
// Copyright (C) $year$ $username$
// 
// File: $safeprojectname$Node.cpp
//
// Dependency Graph Node: $safeprojectname$
//
// Author: Maya Plug-in Wizard 2.0 Reimplemented
//

#include "$safeprojectname$Node.h"

#include <maya/MPlug.h>
#include <maya/MDataBlock.h>
#include <maya/MDataHandle.h>
#include <maya/MGlobal.h>
#include <maya/MFnDependencyNode.h>

/* You MUST change this to a unique value!!!  The id is a 32bit value used
to identify this type of node in the binary file format. */
#error change the following to a unique value and then erase this line 
const MString $safeprojectname$Node::kTypeName("$username$$safeprojectname$");
const MTypeId $safeprojectname$Node::kTypeId(0x009000011);
const MString $safeprojectname$Node::kDrawClassification("drawdb/geometry/$username$$safeprojectname$");
const MString $safeprojectname$Node::kRegistrantId("$username$$safeprojectname$NodePlugin");

// Example attributes
MObject $safeprojectname$Node::aInput;
MObject $safeprojectname$Node::aOutput;

$safeprojectname$Node::$safeprojectname$Node() {}
$safeprojectname$Node::~$safeprojectname$Node() {}

/**
*	Description:
*		This method exists to give Maya a way to create new objects
*       of this type.
*
*	Return Value:
*		a new object of this type
**/
void* $safeprojectname$Node::creator() {
	return new $safeprojectname$Node();
}

 /**
 *	Description:
 *		This method is called once, after the node has been created.
 * 		It is used to perform any additional initialization required
 *		by the node.
 **/
void $safeprojectname$Node::postConstructor()
{
	MFnDependencyNode nodeFn(thisMObject());
	nodeFn.setName(kTypeName + "Shape#");
}

/**
//	Description:
//		This method computes the value of the given output plug based
//		on the values of the input attributes.
//
//	Arguments:
//		plug - the plug to compute
//		data - object that provides access to the attributes for this node
**/
MStatus $safeprojectname$Node::compute(const MPlug& plug, MDataBlock& dataBlock) {
	MStatus returnStatus;
 
	/* Check which output attribute we have been asked to compute.  If this 
	node doesn't know how to compute it, we must return 
	MS::kUnknownParameter. */
	if(plug == aOutput)	{
		/* Get a handle to the input attribute that we will need for the
		computation.  If the value is being supplied via a connection 
		in the dependency graph, then this call will cause all upstream  
		connections to be evaluated so that the correct value is supplied. */
		MDataHandle inputData = dataBlock.inputValue(aInput, &returnStatus);
		CHECK_MSTATUS_AND_RETURN_IT(returnStatus);

		// Read the input value from the handle.
		float result = inputData.asFloat();

		/* Get a handle to the output attribute.  This is similar to the
		"inputValue" call above except that no dependency graph 
		computation will be done as a result of this call. */
		MDataHandle outputHandle = dataBlock.outputValue(aOutput, &returnStatus);
		CHECK_MSTATUS_AND_RETURN_IT(returnStatus);
		// This just copies the input value through to the output.  
		outputHandle.set(result);
		/* Mark the destination plug as being clean.  This will prevent the
		dependency graph from repeating this calculation until an input 
		of this node changes. */
		dataBlock.setClean(plug);

		return MS::kSuccess;
	} 

	return MS::kUnknownParameter;
}

/**
*	Description:
*		This method is called to create and initialize all of the attributes
*       and attribute dependencies for this node type.  This is only called 
*		once when the node type is registered with Maya.
*
*	Return Values:
*		MS::kSuccess
*		MS::kFailure
**/
MStatus $safeprojectname$Node::initialize() {
	// Defaults:
	// keyable == false (not keyable)
	// storable == true (stored in file)
	// readable == true (can read)
	// writable == true (can write)
	// Add distance attribute explicitly in the template, will show even if non-writable

	/* This sample creates a single input float attribute and a single
	output float attribute. */
	MStatus status;
	MFnNumericAttribute nAttr;

	aInput = nAttr.create("input", "in", MFnNumericData::kFloat, 0.0);
	CHECK_MSTATUS_AND_RETURN_IT(status);	
 	nAttr.setStorable(true); // Attribute will be written to files when this type of node is stored
	nAttr.setKeyable(true);// Attribute is keyable and will show up in the channel box
	addAttribute(aInput);

	aOutput = nAttr.create("output", "out", MFnNumericData::kFloat, 0.0);
	CHECK_MSTATUS_AND_RETURN_IT(status);	
	nAttr.setWritable(false); // Attribute is read-only because it is an output attribute	
	nAttr.setStorable(false); // Attribute will not be written to files when this type of node is stored
	addAttribute(aOutput);

	/* Set up a dependency between the input and the output.  This will cause
	the output to be marked dirty when the input changes.  The output will
	then be recomputed the next time the value of the output is requested. */
	attributeAffects(aInput, aOutput);

	return MS::kSuccess;
}
