// $( document ).on('turbolinks:load', function() {
//     const currentUser = firebase.auth().currentUser;
//     if (currentUser) {
//         const uid = currentUser.uid;
//     }
//     const stripe = Stripe('pk_test_r46MnQQ9cxjMadPDwXrxHRgm');
//     const elements = stripe.elements();
    
//     const routing_number = document.getElementById('bank-routing');
//     const account_number = document.getElementById('bank-account');
//     const holder_name = document.getElementById('bank-holder-name');
    
//     $('#editDriverBank').on('click', e => {
//         $('#editDriverBank').html('Saving...');
//         stripe.createToken('bank_account', {
//             country: 'us',
//             currency: 'usd',
//             routing_number: routing_number.value,
//             account_number: account_number.value,
//             account_holder_name: holder_name.value,
//             account_holder_type: 'individual',
//         }).then( f => {
            
//             // Save token to database
//             $.get('/update_courier_bank?bank_token='+f.token.id, g => {
//                 console.log(g);
//                 $('#updateAlertMessageBank').text('Bank details updated!');
//                 $('#updateAlertBank').fadeIn('fast', function() {
//                     $('#updateAlertBank').fadeOut(3000);
//                 });
//                 routing_number.value = '';
//                 account_number.value = '';
//                 holder_name.value = '';
//                 $('#bankForm').hide();
//                 $('#bankOnFile').show();
//                 $('#editDriverBank').html('<i class="fa fa-check-circle" id="saveBankLoader"></i> Save Details');
//             });
            
//         }).catch( f => {
//             console.log(f);
//         });
//     });
// });