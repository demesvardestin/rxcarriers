$( document ).on('turbolinks:load', function() {
    const key = 'BKZPPLlOQmgaKAdnJd0ecmY92fB4_0jqJ8PktJqC5rjT9h_arlyzHvzpFBmowIJdnOLgU625bIPw_aA7NdEiej8';
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
        console.log('clicked');
        $('#enablePush').css('opacity', '0.7').html('Enabling...');
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            const key_ = urlB64ToUint8Array(key);
            reg.pushManager.subscribe({
                userVisibleOnly: true,
                // applicationServerKey: key_
            }).then(function(sub) {
                console.log('Endpoint URL: ', sub.endpoint);
                console.log(key_);
                $.get('/store_push_endpoint', { sub: sub.toJSON() });
                $('#enablePush').css('opacity', '1').html('<input type="radio" name="enable" autocomplete="off"> <span id="enableText">Enabled</span>');
                document.getElementById('disablePush').removeAttribute('checked');
                document.getElementById('enablePush').setAttribute('checked', 'true');
                document.getElementById('disablePush').classList.remove('active');
                document.getElementById('enablePush').classList.add('active');
                $('#disableText').html('Disable');
                console.log('endpoint stored!');
                toastr["success"]('Desktop notifications enabled!');
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
        $('#disablePush').css('opacity', '0.7').html('Disabling...');
        navigator.serviceWorker.getRegistration('/javascripts/sw.js')
        .then(function(reg) {
            const key_ = urlB64ToUint8Array(key);
            reg.pushManager.getSubscription().then(function(subscription) {
                subscription.unsubscribe().then(function(successful) {
                    console.log(key_);
                    $.get('/unsubscribe');
                    $('#disablePush').css('opacity', '1').html('<input type="radio" name="disable" autocomplete="off"> <span id="disableText">Disabled</span>');
                    $('#enableText').html('Enable');
                    document.getElementById('enablePush').removeAttribute('checked');
                    document.getElementById('disablePush').setAttribute('checked', 'true');
                    document.getElementById('enablePush').classList.remove('active');
                    document.getElementById('disablePush').classList.add('active');
                    console.log("Unsubscribed!");
                    toastr["warning"]("Desktop notifications have been disabled. Customer order notifications will no longer appear in real-time!");
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