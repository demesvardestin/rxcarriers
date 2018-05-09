$( document ).on('turbolinks:load', function() {
    const key = 'BNiq2vVEYf5MdCKMFhXLvICGnUz8Q_xQNjoBXTM3ex4FCYPr2tZU1-Jw2vrlGlNMToU9zfNlACW8rrbqYvwM5tw';
    console.log(window.vapidPublicKey);
    // const priv_ = 'SfjzRhYk6vNcVTEMw2ZTJo8Zh16b7c1oZvfXwRUX5ag';
    Notification.requestPermission(function(status) {
        console.log('Notification permission status:', status);
    });
    
    if ('serviceWorker' in navigator) {
        console.log('Service Worker and Push is supported');
        navigator.serviceWorker.register('/javascripts/sw.js', {scope: '/javascripts/'})
        .then(function(reg) {
            console.log('service worker registered!');
        });
    }
    
    $('#enablePush').on('click', e => {
        $('#enablePush').css('opacity', '0.7').html('Enabling notifications...');
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            const key_ = urlB64ToUint8Array(key);
            reg.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey: key_
            }).then(function(sub) {
                console.log('Endpoint URL: ', sub.endpoint);
                console.log(key_);
                $('#notificationDiv').html(`
                    <div class="card-body text-center">
                        <h6 class="weighted font-14">Push notifications enabled.</h6>
                        <h6 class="weighted font-14">No live deliveries at this time</h6>
                    </div>` + JSON.stringify(sub) +
                    `
                        <button class="btn btn-danger" id="disablePush">
                            Disable push notification
                        </button>
                `);
                $.get('/store_push_endpoint', { sub: sub.toJSON() });
                console.log('endpoint stored!');
                window.location.replace("/");
            }).catch(function(e) {
                if (Notification.permission === 'denied') {
                  console.warn('Permission for notifications was denied');
                } else {
                  console.error('Unable to subscribe to push', e);
                }
            });
        }).catch(function(error) {
            console.log(error);
        });
    });
    
    $('#enablePharmacyPush').on('click', e => {
        $('#enablePharmacyPush').css('opacity', '0.7').html('Enabling notifications...');
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            const key_ = urlB64ToUint8Array(key);
            reg.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey: key_
            }).then(function(sub) {
                console.log('Endpoint URL: ', sub.endpoint);
                console.log(key_);
                $('#notificationPharmacyDiv').html(`
                    <div class="card-body text-center">
                        <h6 class="weighted font-14">Push notifications enabled.</h6>
                        <h6 class="weighted font-14">No live deliveries at this time</h6>
                    </div>` + JSON.stringify(sub) +
                    `
                        <button class="btn btn-danger" id="disablePharmacyPush">
                            Disable push notification
                        </button>
                `);
                $.get('/store_pharma_push_endpoint', { sub: sub.toJSON() });
                console.log('endpoint stored!');
                // window.location.replace("/");
            }).catch(function(e) {
                if (Notification.permission === 'denied') {
                  console.warn('Permission for notifications was denied');
                } else {
                  console.error('Unable to subscribe to push', e);
                }
            });
        }).catch(function(error) {
            console.log(error);
        });
    });
    
    $('#disablePush').on('click', e => {
        $('#disablePush').css('opacity', '0.7').html('Disabling notifications...');
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            const key_ = urlB64ToUint8Array(key);
            reg.pushManager.getSubscription().then(function(subscription) {
                subscription.unsubscribe().then(function(successful) {
                    console.log(key_);
                    $('#notificationDiv').html(`
                        <button class="btn btn-light" id="enablePush">
                            Enable push notification
                        </button>
                    `);
                    console.log("Unsubscribed!");
                    $.get('/unsubscribe');
                    window.location.replace("/");
                }).catch(function(e) {
                    console.error('Unable to unsubscribe user. Error: '+e);
                });
            }).catch(function(error) {
                console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    });
    
    $('#disablePharmacyPush').on('click', e => {
        $('#disablePharmacyPush').css('opacity', '0.7').html('Disabling notifications...');
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            const key_ = urlB64ToUint8Array(key);
            reg.pushManager.getSubscription().then(function(subscription) {
                subscription.unsubscribe().then(function(successful) {
                    console.log(key_);
                    $('#notificationPharmacyDiv').html(`
                        <button class="btn btn-light" id="enablePharmacyPush">
                            Enable push notification
                        </button>
                    `);
                    console.log("Unsubscribed!");
                    $.get('/unsubscribe');
                    window.location.replace("/");
                }).catch(function(e) {
                    console.error('Unable to unsubscribe user. Error: '+e);
                });
            }).catch(function(error) {
                console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    });
    
    $('#sendNotification').on('click', e => {
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            var text = $('#sendNotification').attr('text');
            var batch = $('#sendNotification').attr('batch');
            var data = {
                "details": text,
                "batch": batch,
            };
            console.log(data);
            $.get('/push', { data: data });
        })
        .catch(function(error) {
            console.log('Service worker registration failed, error:', error);
        });
        
        self.addEventListener('notificationclick', function(event) {
            console.log('Clicked: '+event);
        });
    });
});