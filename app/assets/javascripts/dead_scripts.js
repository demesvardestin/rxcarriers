// var patientFormCounter = 0;
//     var patientForms = document.getElementsByClassName('pf');
//     var formElements = document.getElementsByClassName('delivery-sequence');
//     var formParents = document.getElementsByClassName('patient-form');
//     var rmPatients = document.getElementsByClassName('remove-patient');
//     var length = patientForms.length
//     $('.add-patient').on('click', function() {
//         patientFormCounter += 1;
//         id = patientFormCounter - 1;
//         current_ = patientForms[id]
        
//         if (patientForms.length > 0) {
//             quot = length - patientForms.length
//             id = id - quot;
//         }
        
//         if (id == 9 || patientFormCounter == 10) {
//             patientFormCounter = 0;
//             $('.add-patient').hide();
//             console.log(patientFormCounter);
//             return;
//         }
//         formElements[id].attributes[1].value = 'delivery-sequence'+id;
//         formParents[id].attributes[1].value = 'patient-form'+id;
//         rmPatients[id].attributes[0].value = 'remove-patient'+id;
//         $('#remove-patient' + id).html('<a class="font-13 rmPat theme-blue"' + 'id="rmPat' + id + '" onclick="removePatient(' + id + ')">Remove Delivery</a>');
//         $('.pf'+id.toString()).show();
//         patientForms.pop(current_);
//     });
    
//     $('#express-no').on('click', function() {
//         $('#submit-button').show();
//         $('#patient-form').hide();
//     });
    
//     $('#show-patient-search').on('click', function() {
//         $('#patient-search').show();
//     });