//printArray(camMarkers);

// Situation, a system constellation of a specific family issue case is made with artefacts by a representative.
// Arteffects (characters) with qr code are detected in front of the Raspberry Pi model 3B 
// with camera module v2.
// The application uses the Zxing qr code library and example multipleQRCodeReader and the GLCapture method 
// from the OpenCV for processing library. This library works slightly different with the rendering of an image
// therfor the createGraphics method is taken out of the multipleQRCodeReader code.
// 
// The next step is to setup the perspective of the user e.g. create an image from the system constellation.
// Three classess are constructed, character, role and namegiver.
// The character has the information of the artefact like position, identifier and roles[].
// The role has the information as known by the representative: name, timestamp and namegiver.
// The namegiver had the information of the representative: organisation, representative_name[] and organisation_tools[].
