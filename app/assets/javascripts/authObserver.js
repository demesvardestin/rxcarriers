// $( document ).on('turbolinks:load', function() {
//     // Add auth state listener for layout changes
//     firebase.auth().onAuthStateChanged(firebaseUser => {
//         if (firebaseUser) {
            
//             //redirect user from unauthorized pages
//             if (window.location.href.includes('login')) {
//                 window.location.replace('/courier/profile?cid='+firebaseUser.uid);
//             }
            
//             // Grab user object
//             const user = database.collection('/drivers').doc(firebaseUser.uid);
//             console.log('user logged in');
            
//             var url_string = window.location.href;
//             var url = new URL(url_string);
//             var c = url.searchParams.get("cid");
//             console.log(c);
            
//             if (c != firebaseUser.uid) {
//                 $('.container').remove();
//             }
            
//             if (c != firebaseUser.uid || c.length === 0) {
//                 // window.location.replace('/courier/profile?cid='+firebaseUser.uid);
//             }
            
//             // Set layout
//             $('.pharmacy-signup').remove();
//             $('.main-nav').remove();
//             $('.driver-nav').show();
//             $('.footer').hide();
            
//             // Bank details
//             user.get().then(e => {
                
//                 if (e.data().stripeToken != null) {
//                     $('#bankOnFile').show();
//                 } else {
//                     $('#bankForm').show();
//                 }
//             }).catch(e => {
//                 console.log(e);
//             });
            
//             var db = database.collection('drivers');
//             db.where('status', '==', 'online').get()
//             .then(function(docs) {
//                     console.log('starting...');
//                     docs.forEach(function(doc) {
//                         console.log(doc.data());
//                         var startPos;
//                         var geoSuccess = function(position) {
//                             startPos = position;
//                             db.doc(doc.id).set({
//                                 latLong: [startPos.coords.latitude, startPos.coords.longitude]
//                             }, {merge: true}).then(function(success) {
//                                 console.log('location updated!');
//                             }).catch(function(failure) {
//                                 console.log('failed to update location! error: ' + failure);
//                             });
//                         };
//                         navigator.geolocation.watchPosition(geoSuccess);
//                     });
//             });
            
//         } else {
//             console.log('user logged out');
            
//             // redirect to unauthorize page when not logged in
//             if (window.location.href.includes('courier/')) {
//                 window.location.replace('/unauthorized');
//             }
            
//             $('.profile').html(`
//                 <button class="btn btn-info background-transparent"
//                 style="padding: 10px; padding-left: 20px; padding-right: 20px; box-shadow: none; border: 1px solid #e1e1e2;">
//                 <a href="/" class="theme-blue background-transparent 
//                 no-underline">Home</a></button>`);
//             $('.nav-toggler-driver').html(`
//                 <a href="/" class="theme-blue background-transparent 
//                 no-underline">Home</a>`)
//             .css({'padding':'10px', 'padding-left':'20px', 'padding-right':'20px'});
//             $('#profile-page').remove();
//         }
//     });
// });