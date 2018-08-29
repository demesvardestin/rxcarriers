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
  var padding = '='.repeat((4 - base64String.length % 4) % 4);
  var base64 = (base64String + padding)
    .replace(/\-/g, '+')
    .replace(/_/g, '/');

  var rawData = window.atob(base64);
  var outputArray = new Uint8Array(rawData.length);

  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}
$('.main-page-card').fadeIn();
$( document ).on('turbolinks:load', function() {
    // if current_pharmacy, get pharmacy id
    // var audio = new Audio('/sounds/ping.mp3');
    // audio.play();
    if (document.getElementById("sound") != null) {
        document.getElementById("sound").innerHTML='';
    }
    var pharmacy_id = $('#pharmacy_id').text();
    
    // set variables for firebase requests collections reference
    var requests = database.collection("requests").where('pharmacy_id', '==', parseInt(pharmacy_id))
    .where('status', '==', 'accepted');
    var docs = database.collection("requests");
    
    // parse url for parameters
    var url_string = window.location.href;
    var url = new URL(url_string);
    
    $('.nav-item').on('click', function() {
        $('SOURCE#pingMP3').remove();
    });
    
    $('#updateProfile').on('submit', function() {
        $('#v-pills-home').html(`
            <div class="row">
                <div class="col-md-12 text-center">
                    <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-blue"></i>
                </div>
            </div>
        `);
    });
    
});