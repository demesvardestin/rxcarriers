// var canvas = document.getElementById("canvas");
// console.log(canvas);

// var signaturePad = new SignaturePad(canvas);

// // Returns signature image as data URL (see https://mdn.io/todataurl for the list of possible parameters)
// signaturePad.toDataURL(); // save image as PNG
// signaturePad.toDataURL("image/jpeg"); // save image as JPEG
// signaturePad.toDataURL("image/svg+xml"); // save image as SVG

// // Draws signature image from data URL.
// // NOTE: This method does not populate internal data structure that represents drawn signature. Thus, after using #fromDataURL, #toData won't work properly.
// signaturePad.fromDataURL("data:image/png;base64,iVBORw0K...");

// // Returns signature image as an array of point groups
// const data = signaturePad.toData();

// // Draws signature image from an array of point groups
// signaturePad.fromData(data);

// // Clears the canvas
// signaturePad.clear();

// // Returns true if canvas is empty, otherwise returns false
// signaturePad.isEmpty();

// // Unbinds all event handlers
// signaturePad.off();

// // Rebinds all event handlers
// signaturePad.on();