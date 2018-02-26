// Perform search using dom manipulation instead of DB Queries

window.onkeyup = keyup;

var inputTextValue;
var batches = document.getElementsByClassName('batches-row');
var count = 0;

function keyup(e) {
    inputTextValue = e.target.value.toLowerCase();
    if (e.keyCode == 13) {
        count = 0;
        $('.spinner-row').show();
        $('.batch-card-container').css('padding-top', '20px');
        for (i=0;i<batches.length;i++) {
            var id = batches[i].attributes[3].value
            $('#' + id.toString()).hide();
            var value1 = batches[i].attributes[1].value.toLowerCase();
            var value2 = batches[i].attributes[2].value.toLowerCase();
            if (value1.includes(inputTextValue) || value2.includes(inputTextValue)) {
                $('.search-error').hide();
                $('#' + id.toString()).show();
            } else {
                count = count + 1;
                console.log(count)
            }
        }
        
        $('.spinner-row').hide();
        
        if (count == batches.length) {
            $('.search-error').css('padding-top', '20px');
            $('.search-error').show();
        }
    }
};

$('#batch-search-input').on('click', function() {
    $('#batch-search-input').animate({width: '80%'});
});

$('#express-yes').on('click', function() {
    $('#submit-button').hide();
    $('#patient-form').fadeIn();
});

$('#express-no').on('click', function() {
    $('#submit-button').show();
    $('#patient-form').fadeOut();
});

$('#show-patient-search').on('click', function() {
    $('#patient-search').show();
});

function populate() {
    $('#patient-full-name').value = $('#option1').attributes[2].value;
    $('#patient-number').value = $('.option1').attributes[3].value;
    $('#patient-address').value = $('.option1').attributes[2].value;
    $('#patient-copay').value = $('.option1').attributes[4].value;
    console.log($('.option1').attributes[3].value);
};