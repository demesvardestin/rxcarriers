    // // Show loader //
    // $('.loader-row').show();
    
    // // Grab request_id of current batch //
    // var req_id = "<%= current_batch.request_id if current_batch.request_id != nil %>";
    // console.log(req_id);
    
    // // Hide request card if request not yet sent //
    // if (!req_id) {
    //     $('#driverRequested').hide();
    // }
    
    // // SET SNAPSHOT TO WATCH DELIVERY CHANGES //
    // database.collection("deliveries")
    //     .where('pharmacy_id', '==', pharmacy_id)
    //     .where('batch_id', '==', batch_id)
    //     .onSnapshot(function(doc) {
    //         console.log(doc.docs.length);
    //         if (doc.docs.length > 0){
    //             $('.loader-row').hide();
    //             $('.request-driver').fadeIn()
    //             populateDeliveryDiv();
    //             $('#all-deliveries').css('padding-bottom', '10px');
    //             $('#all-deliveries').fadeIn();
    //         } else if (doc.docs.length == 10) {
    //             $('#addDelivery').hide();
    //         } else {
    //             $('.loader-row').hide();
    //             $('.request-driver').hide();
    //             $('#deliveries').html('');
    //             $('#all-deliveries').hide();
    //             $('#placeholder').fadeIn();
    //         }
    // });
    
    // // SET SNAPSHOT TO WATCH CURRENT REQUEST CHANGES //
    // if (req_id) {
    //     $('.fa-times-circle').css('opacity', '0.3');
    //     database.collection("requests").doc(req_id)
    //         .onSnapshot(function(doc) {
    //             checkRequestStatus();
    //     });
    // }
    
    // // Calculate mileage and duration //
    // function calculateMileage() {
    //     var deliveries = [pharmacy_address];
    //     var mileage = 0;
    //     var time = 0;
    //     var service = new google.maps.DistanceMatrixService;
    //     var i = 0;
    //     database.collection("deliveries")
    //     .where('pharmacy_id', '==', pharmacy_id)
    //     .where('batch_id', '==', batch_id)
    //     .get().then(function(docs) {
    //         // For each delivery, calculate mileage and time and update doc //
    //         docs.forEach(function(doc) {
    //             current_address = doc.data().recipient_address;
    //             service.getDistanceMatrix({
    //                 origins: [deliveries[i]],
    //                 destinations: [current_address],
    //                 travelMode: 'DRIVING',
    //                 unitSystem: google.maps.UnitSystem.IMPERIAL,
    //                 avoidHighways: false,
    //                 avoidTolls: false
    //             }, function(response, status) {
    //                 if (status !== 'OK') {
    //                     console.log('error found with status: ' + status);
    //                 } else {
    //                     console.log(response);
    //                     mileage += (parseFloat(response.rows[0].elements[0].distance.text));
    //                     time += response.rows[0].elements[0].duration.value;
    //                     // Update request doc //
    //                     writeToRequest(mileage, time);
    //                 }
    //             });
    //             deliveries.push(current_address);
    //             i = i + 1;
    //         });
    //     });
    // };
    
    // // Create a delivery and reset form for next delivery //
    // function createDelivery(name, address, phone, copay=null, delivery_time=null) {
    //     database.collection('deliveries').add({
    //         recipient_name: name,
    //         recipient_address: address,
    //         recipient_phone: phone,
    //         recipient_copay: copay,
    //         pharmacy_id: pharmacy_id,
    //         pharmacy_name: pharmacy_name,
    //         batch_id: batch_id,
    //         delivery_time: delivery_time
    //     }).then(function() {
    //         // Call function to reset form //
    //         clearInputs();
    //     });
    // };
    
    // // Remove delivery function. Button will only be functional if request_id is
    // // present.
    // function removeDelivery(elem) {
    //     var id = elem.attributes[2].value;
    //     var request_id = req_id;
    //     if (!request_id) {
    //         database.collection('deliveries').doc(id).delete().then(function() {
    //             console.log("Document successfully deleted!");
    //         }).catch(function(error) {
    //             console.error("Error removing document: ", error);
    //         });
    //     } else {
    //         console.log('You have already requested a courier for this batch.');
    //         return;
    //     }
    // };
    
    // // calculate fare total //
    // function calculateFare(mileage, duration) {
    //     var base_fare = 15;
    //     var per_mile = 1.00;
    //     var per_minute = 0.10;
    //     var total = base_fare + (per_mile*mileage) + (per_minute*duration);
    //     return total;
    // };
    
    // // Request driver functionality //
    // function requestDriver() {
    //     $('#requestLoading').show();
    //     $('#driverRequested').show();
    //     database.collection('requests/').add({
    //         pharmacy_name: pharmacy_name,
    //         pharmacy_address: pharmacy_address,
    //         pharmacy_phone: pharmacy_number,
    //         total_milage: 0.0,
    //         fare: 0.0,
    //         trip_duration: 0.0,
    //         deliveries: [],
    //         batch_id: batch_id,
    //         accepted: false,
    //         driver: null
    //     }).then(function(data) {
    //         console.log(data.id);
    //         // submit firebase-generated id to postgres database and calculate
    //         // mileage
    //         submitToDatabase(data.id);
    //         calculateMileage();
    //         $('#requestStatus').html('Pending');
    //         $('#requestLoading').hide();
    //     }).catch(function(error) {
    //         console.log(error);
    //         $('#requestLoading').hide();
    //         $('#requestError').show();
    //     });
    // };
    
    // // Update request...merge to avoid overwriting previous data //
    // function writeToRequest(miles, time_in_seconds) {
    //     database.collection('requests')
    //         .doc(req_id)
    //         .set({
    //             total_milage: miles.toFixed(2),
    //             trip_duration: time_in_seconds,
    //             fare: calculateFare(miles, (time_in_seconds/60)).toFixed(2)
    //         }, { merge: true })
    //         .then(function() {
    //             console.log('Firebase merge successful!');
    //         }).catch(function(error) {
    //             console.log('Firebase merge unsuccessful due to: ' + error);
    //         })
    //     console.log(miles, time_in_seconds, calculateFare(miles, (time_in_seconds/60)));
    // };
    
    // // create hidden form and submit to database //
    // function submitToDatabase(id, batch_id) {
    //     var form = document.createElement('form');
    //     var input = document.createElement('input');
    //     var input1 = document.createElement('input');
    //     form.setAttribute('action', '/update_batch');
    //     form.setAttribute('method', 'get');
    //     form.setAttribute('id', 'setRequestId');
    //     input.setAttribute('name', 'request_id');
    //     input.setAttribute('value', id.toString());
    //     input1.setAttribute('name', 'batch_id');
    //     input1.setAttribute('value', batch_id.toString());
    //     document.body.appendChild(form);
    //     form.appendChild(input)
    //     .appendChild(input1);
    //     form.submit();
    // };
    
    // // Convert data to minutes //
    // function toMin(time_in_seconds) {
    //     return parseFloat(time_in_seconds/60);
    // };
    
    // // Check request status //
    // function checkRequestStatus() {
    //     if (req_id) {
    //         database.collection('requests')
    //         .doc(req_id)
    //         .get()
    //         .then(function(query) {
    //             console.log(query.data());
    //             $('#driverRequested').fadeIn();
    //             if (query.data().accepted == false) {
    //                 $('#requestPending').show();
    //                 $('#requestDetails').html(
    //                     '<div class="row">' +
    //                     '<div class="col-md-4 offset-md-3">' +
    //                     '<span class="font-13 medium-gray">Est. Mileage:</span>' +
    //                     '</div>' +
    //                     '<div class="col-md-4">' +
    //                     '<span class="font-13 theme-blue">' +
    //                     query.data().total_milage +
    //                     '</span>' +
    //                     '</div>' +
    //                     '</div>' +
    //                     '<div class="row">' +
    //                     '<div class="col-md-4 offset-md-3">' +
    //                     '<span class="font-13 medium-gray">Est. Cost:</span>' +
    //                     '</div>' +
    //                     '<div class="col-md-4">' +
    //                     '<span class="font-13 theme-blue">' +
    //                     '$' + query.data().fare +
    //                     '</span>' +
    //                     '</div>' +
    //                     '</div>' +
    //                     '<div class="row">' +
    //                     '<div class="col-md-4 offset-md-3">' +
    //                     '<span class="font-13 medium-gray">Est. Duration:</span>' +
    //                     '</div>' +
    //                     '<div class="col-md-4">' +
    //                     '<span class="font-13 theme-blue">' +
    //                     toMin(query.data().trip_duration).toFixed(2) + 'mns' +
    //                     '</span>' +
    //                     '</div>' +
    //                     '</div>'
    //                 )
    //             } else {
    //                 $('#requestAcepted').show();
    //             }
    //         });
    //     }
    // };
    
    // // Put content in delivery div //
    // function populateDeliveryDiv() {
    //     database.collection('deliveries/')
    //     .where('pharmacy_id', '==', pharmacy_id)
    //     .where('batch_id', '==', batch_id)
    //     .get()
    //     .then(function(querySnapshot) {
    //         $('#placeholder').hide();
    //         $('placeholder-fail').hide();
    //         $('#all-deliveries').show();
    //         $('#deliveries').html('');
    //         querySnapshot.forEach(function(doc) {
    //             var id = doc.id.toString();
    //             $('#deliveries').append(
    //                 '<div id="delivery' + doc.id.toString() +
    //                 '" class="col-md-12 table-content" name="' + id + '">'+
    //                 '<div class="row">' +
    //                 '<div class="col-md-3 no-right-padding" >' +
    //                     '<span>'+ doc.data().recipient_name + '</span>' +
    //                 '</div>' +
    //                 '<div class="col-md-4 no-horizontal-padding">' +
    //                     '<span>'+ doc.data().recipient_address + '</span>' +
    //                 '</div>' +
    //                 '<div class="col-md-2 no-horizontal-padding">' +
    //                     '<span>'+ doc.data().recipient_phone + '</span>' +
    //                 '</div>' +
    //                 '<div class="col-md-1 no-horizontal-padding">' +
    //                     doc.data().recipient_copay + 
    //                 '</div>' +
    //                 '<div class="col-md-1 no-horizontal-padding">' +
    //                     doc.data().delivery_time + 
    //                 '</div>' +
    //                 '<div class="col-md-1 no-horizontal-padding">' +
    //                 '<button class="btn btn-warning removeDelivery"' +
    //                 'onclick="removeDelivery(this)"'+
    //                 'id="' + id + '"' +
    //                 '><i class="fa fa-times-circle font-10 theme-blue"></i></button>' + 
    //                 '</div>' +
    //                 '</div></div>'
    //             );
    //         });
    //     });
    // };
    
    // // add listener to patient addition form //
    // document.getElementById('addPatient').addEventListener('submit', function(event) {
    //     event.preventDefault();
    //     var name = document.getElementById('patient-full-name').value;
    //     var address = document.getElementById('patient-address').value;
    //     var phone = document.getElementById('patient-number').value;
    //     var copay = document.getElementById('patient-copay').value;
    //     var medications = document.getElementById('patient-medications').value;
    //     var delivery = document.getElementById('delivery-time').value;;
    //     console.log(name, address, phone, copay, medications);
    //     $('.patient-form').hide();
    //     $('.loader-row').show();
        
    //     createDelivery(name, address, phone, copay, delivery);
    // });
    
    // document.getElementById('returnToBatchesList').addEventListener('click', function() {
    //     $('#main').fadeOut();
    //     $('.loader-row').show();
    // });
    
    // // clear form //
    // function clearInputs() {
    //     document.getElementById('addPatient').reset();
    //     $('.loader-row').hide();
    //     $('.patient-form').show();
    // };
    
    // // END FIREBASE //