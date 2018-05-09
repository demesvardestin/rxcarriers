self.addEventListener('install', function(event) {
    // Perform some task
    console.log('Installed!');
});

self.addEventListener('activate', function(event) {
    // Perform some task
    console.log('Activated!');
});

self.addEventListener('notificationclick', function(e) {
    var notification = e.notification;
    var primaryKey = notification.data.primaryKey;
    var action = e.action;
    
    if (action === 'Close') {
        notification.close();
    } else {
        console.log(e);
        clients.openWindow('https://udemy-class-demo07.c9users.io/accept_request?batch_id='
                            + notification.data.batch_id + '&driver_id=' +
                            notification.data.driver + '&pharmacy_id=' +
                            notification.data.pharmacy_id+'&accepted=true');
        notification.close();
    }
});

self.addEventListener('push', function(e) {
  console.log(e);
  var options = {
    body: e.data.json().details,
    icon: '/javascripts/pharmacy.png',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: '2',
      batch_id: e.data.json().batch,
      driver: e.data.json.driver
    },
    actions: [
      {action: 'accept', title: 'Accept',
        icon: '/javascripts/checked.png'},
      {action: 'Close', title: 'Deny',
        icon: '/javascripts/cancel.png'},
    ]
  };
  e.waitUntil(
    self.registration.showNotification('New delivery request!', options)
  );
});