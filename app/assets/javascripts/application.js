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
$('.main-page-card').fadeIn();
$( document ).on('turbolinks:load', function() {
    // if current_pharmacy, get pharmacy id
    if (document.getElementById("sound") != null) {
        document.getElementById("sound").innerHTML='';
    }
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
        $.get('/dismiss_all_notifications');
    });
    
    $('.nav-item').on('click', e => {
        $('SOURCE#pingMP3').remove();
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
        $('#v-pills-home').html(`
            <div class="row">
                <div class="col-md-12 text-center">
                    <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-blue"></i>
                </div>
            </div>
        `);
    });
    
    function updateRxDob(elem) {
        var rx = elem.id;
        var dob = document.getElementById('editRxField-'+rx).value;
        $('.updateRxBtn-'+rx).css('opacity', '0.6');
        $('.updateRxBtn-'+rx).html('Updating...');
        $('#updateRxDobModalBody-'+rx).html(`
            <div class="row">
                <div class="col-md-12 text-center">
                    <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-blue"></i>
                </div>
                <div class="col-md-12 text-center">
                    <h6 class="font-14">Updating rx</h6>
                </div>
            </div>
        `);
        $.get('/update_rx_dob?dob='+dob+'&rx='+rx, function(data) {
            $('#updateRxDobModalBody-'+rx).html(`
                <div class="row">
                    <div class="col-md-12 text-center">
                        <i class="fa fa-check-circle theme-green font-40"></i>
                    </div>
                    <div class="col-md-12 text-center">
                        <h6 class="font-14">birth year added!</h6>
                    </div>
                    <div class="col-md-12 text-center">
                        <button class="btn btn-info transaction-buttons" id="`+rx+`"
                        onclick="clearRxUpdate(this)"><i class="fa fa-times-circle"></i> Clear</button>
                    </div>
                </div>
            `);
            $('.updateRxBtn-'+rx).css('opacity', '1');
            $('.updateRxBtn-'+rx).html('<i class="fa fa-check-circle"></i> Update');
        });
    }
    
    function clearRxUpdate(elem) {
        var rx = elem.id;
        $('#updateRxDobModalBody-'+rx).html(`
            <div class="row">
                <div class="col-md-12" style="padding-bottom: 10px;">
                    <h6 class="font-14 theme-blue">If the following rx exists, confirm the birth year (from your records)</h6>
                    <h6 class="font-14 theme-yellow text-center add-padding-top bold">Rx #<span id="rxSpan">`+rx+`</span></h6>
                </div>
                <div class="col-md-6 offset-md-3">
                    <input type="text" class="form-control font-14" id="editRxField-`+rx+`" placeholder="birth year (format: yyyy)">
                </div>
            </div>
        `);
    }
    
});