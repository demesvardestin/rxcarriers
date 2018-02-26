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