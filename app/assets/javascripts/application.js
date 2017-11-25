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
//= require signature-pad
//= require jquery.signaturepad
//= require flashcanvas
//= require json2
//= require_tree .

var init_batch_lookup;

init_batch_lookup = function(){
    $('#batch-lookup-form').on('ajax:before', function(event, data, status){
        show_spinner();
    });
    $('#batch-lookup-form').on('ajax:after', function(event, data, status){
        hide_spinner();
    });
    $('#batch-lookup-form').on('ajax:success', function(event, data, status){
        $('#batch-card-container').hide();
        $('#spinner').hide();
        $('#batch-lookup').replaceWith(data);
        init_batch_lookup();
    });
    $('#batch-lookup-form').on('ajax:error', function(event, xhr, status, error){
        $('#batch-card-container').replaceWith('');
        $('#batch-not-found').replaceWith('batch was not found.');
    });
}
$(document).ready(function() {
    init_batch_lookup();
})
var hide_spinner = function(){
    $('#spinner').hide();
}
var show_spinner = function(){
    $('#spinner').show();
}
