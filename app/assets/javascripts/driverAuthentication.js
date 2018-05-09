// $( document ).on('turbolinks:load', function() {
    
//     // Get elements
//     const loggedInNav = document.getElementById('logged-in-nav');
//     const loggedOutNav = document.getElementById('logged-out-nav');
//     const name = document.getElementById('signup-name');
//     const signupEmail = document.getElementById('signup-email');
//     const signupPassword = document.getElementById('signup-password');
//     const email = document.getElementById('login-email');
//     const password = document.getElementById('login-password');
//     const loginBtn = document.getElementById('loginBtn');
//     const logoutBtn = document.getElementById('logOutBtn');
//     const signUpBtn = document.getElementById('signupBtn');
//     const createAccount = document.getElementById('createAccount');
//     const signIn = document.getElementById('logIntoAccount');
    
//     const currentUser = firebase.auth().currentUser;
    
//     // AUTHENTICATION //
    
//     if (loginBtn) {
//         // On login click
//         loginBtn.addEventListener('click', e => {
            
//             // Animations
//             $('#loginBtn').css('opacity', '0.5')
//             .text('Logging you in...');
            
//             // Grab element values
//             const emailValue = email.value;
//             const passwordValue = password.value;
//             const auth = firebase.auth();
            
//             // Grab auth promise
//             auth.signInWithEmailAndPassword(emailValue, passwordValue)
//             .then(e => {
//                 console.log(e);
//                 window.location.replace('/get_user?cid='+e.uid)
//                 // window.history.pushState("somethign", "Courier Account", "/courier/profile");
//                 // window.history.pushState({"html":'',"pageTitle":'Courier Account'}, '/courier/profile');
//             })
//             .catch(e => {
//                 console.log(e.message);
//                 $('#loginBtn').css('opacity', '1')
//                 .text('Login');
//                 $('#alertMessage').text(e.message);
//                 $('#authAlert').fadeIn(1000, function() {
//                     $('#authAlert').fadeOut(2000);
//                 });
//             });
            
//         });
//     }
    
//     if (logoutBtn) {
//         // On logout click
//         logoutBtn.addEventListener('click', e => {
            
//             // Animations
//             $('#logOutBtn').css('opacity', '0.5')
//             .text('Logging out...');
//             firebase.auth().signOut();
//             $('.driver-nav').remove();
//             $('.courier-container').remove();
//             window.location.href = '/couriers/authentication';
//         });
//     }
    
//     if (signUpBtn) {
//         // On signup click
//         signUpBtn.addEventListener('click', e => {
            
//             // Animations
//             $('#logged-in-nav').hide();
//             $('#main-row').hide();
//             $('#signupBtn').css('opacity', '0.5')
//             .text('Creating your account...');
            
//             // Grab element values
//             const nameValue = name.value;
//             const emailValue = signupEmail.value;
//             const passwordValue = signupPassword.value;
//             const auth = firebase.auth();
            
//             // Grab auth promise
//             auth.createUserWithEmailAndPassword(emailValue, passwordValue)
//             .then(e => {
//                 e.displayName = nameValue;
//                 const uid = e.uid;
//                 updateUser(uid, emailValue, nameValue);
//                 window.location.replace('/onboarding/address?cid='+e.uid);
//             })
//             .catch(e => {
//                 console.log(e.message);
//                 $('#signupBtn').css('opacity', '1')
//                 .text('Register');
//                 $('#alertMessage0').text(e.message);
//                 $('#authAlert0').fadeIn(1000, function() {
//                     $('#authAlert0').fadeOut(4000);
//                 });
//             });
//         });
//     }
    
//     // On create account click
//     if (createAccount) {
//         createAccount.addEventListener('click', e => {
//             $('#logged-out-row').hide();
//             $('#logged-out-row-0').fadeIn();
//         });
//     }
    
//     if (signIn) {  
//         // On sign into account click
//         signIn.addEventListener('click', e => {
//             $('#logged-out-row-0').hide();
//             $('#logged-out-row').fadeIn();
//         });
//     }
    
//     function updateUser(uid, email, name, number=null, car=[], address=null, date=null, photo=null) {
//         var params = {
//             id: uid,
//             name: name,
//             address: address,
//             phoneNumber: number,
//             email: email,
//             car: car,
//             date: date,
//             profilePictureUrl: photo,
//             status: 'offline',
//             verified: false
//         };
//         database.collection('/drivers').doc(uid).set(params, {merge: true});
//     }
// });
