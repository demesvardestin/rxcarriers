// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require chartkick
//= require_tree .


var config = {
    apiKey: "AIzaSyDQkXb8VqnUK4YhzPoGC7T59sn1Fv4-bLQ",
    authDomain: "dispenserx-85f34.firebaseapp.com",
    databaseURL: "https://dispenserx-85f34.firebaseio.com",
    projectId: "dispenserx-85f34",
    storageBucket: "dispenserx-85f34.appspot.com",
    messagingSenderId: "966953661548"
};
firebase.initializeApp(config);
var database = firebase.firestore();

// Verify authentication on page load //

// END AUTH VERIFICATION //

$(document).ready(function() {
    const pharmacy_id = $('#pharmacy_id').text();
    var requests = database.collection("requests").where('pharmacy_id', '==', parseInt(pharmacy_id));
    var docs = database.collection("requests");
    console.log(requests);
    requests.onSnapshot(function(allDocs) {
        allDocs.forEach(function(doc) {
            if (doc.data().driver != null) {
              $.get('/notifications?batch_id='+doc.data().batch_id, function(data) {
                  // Something happens here
                  $('#notificationsModalBody').html(data);
                  $('#alertCount').html(' <span class="badge badge-light">1</span>');
                  console.log('done!');
              });
              database.collection('completed').add({
                  pharmacy_name: doc.data().pharmacy_name,
                  pharmacy_address: doc.data().pharmacy_address,
                  pharmacy_phone: doc.data().pharmacy_phone,
                  pharmacy_id: doc.data().pharmacy_id,
                  total_mileage: doc.data().total_milage,
                  fare: doc.data().fare,
                  trip_duration: doc.data().trip_duration,
                  deliveries: doc.data().deliveries,
                  batch_id: doc.data().batch_id,
                  status: 'completed',
                  driver: doc.data().driver
              });
              docs.doc(doc.id).delete().then(function() {
                  console.log('Traversal Completed!');
              }).catch(function(error) {
                  console.log('Traversal Prevented. Error:' + error);
              });
            }
        });
    });
    
    // Clear all notifications //
    $('#dismissAll').on('click', function() {
        $('#notificationsModalBody').html(
            '<div class="notification-placeholder">' +
            '<h6 class="medium-gray font-14 text-center">No new notifications</h6>' +
            '</div>');
        $.get('/notifications/mark_as_read', function(data) {
            // Something can be done here
        });
    });
    
    function dismiss(elem) {
        var id = elem.id();
        $.get('/dismiss_notification?id='+parseInt(id), function(data) {
            
        });
    };
    
    $('.notification-tab').on('click', function() {
        $('#alertCount').html('');
    });
    
});