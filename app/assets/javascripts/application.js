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
//= require toastr
//= require_tree .


// configure firebase
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
var storage = firebase.storage();
function urlB64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/\-/g, '+')
    .replace(/_/g, '/');

  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);

  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

$( document ).on('turbolinks:load', function() {
    // if current_pharmacy, get pharmacy id
    const pharmacy_id = $('#pharmacy_id').text();
    
    // set variables for firebase requests collections reference
    var requests = database.collection("requests").where('pharmacy_id', '==', parseInt(pharmacy_id))
    .where('status', '==', 'accepted');
    var docs = database.collection("requests");
    
    // parse url for parameters
    var url_string = window.location.href;
    var url = new URL(url_string);
    
    // Clear all notifications //
    $('#dismissAll').on('click', function() {
        $('#notificationsModalBody').html(
            '<div class="notification-placeholder">' +
            '<h6 class="medium-gray font-14 text-center">No new notifications</h6>' +
            '</div>'
        );
    });
    
    // dismiss notification on click
    function dismiss(elem) {
        var id = elem.id();
        $.get('/dismiss_notification?id='+parseInt(id));
    }
    
    $('.notification-tab').on('click', function() {
        $('#alertCount').html('');
    });
    
    // mark batch as picked up
    function checkStatus(elem) {
      var id = elem.batch;
      $.get('/mark_picked?id='+id, function(data) {
        $('.mark-picked'+id).html('Batch picked up!');
        console.log('Batch picked up!');
      });
    }
    
    $('.nav-link-edit').on('click', function() {
        $('#card-body-details').html();
        $('.spinner-row').show();
    });
    
    $('#updateProfile').on('submit', e => {
        $('#v-pills-home').html('<i class="fa fa-circle-o-notch theme-blue fa-spin fa-3x fa-fw"></i>')
    });
    
});