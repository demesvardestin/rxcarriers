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
        clients.openWindow('https://udemy-class-demo07.c9users.io/customers?batch_id='
                            + notification.tag+'&driver_id=' +
                            notification.data.pharmacy_id+'&accepted=true');
        notification.close();
    }
});

self.addEventListener('push', function(e) {
  var options = {
    body: 'This notification was generated from a push!',
    icon: 'images/example.png',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: '2'
    },
    actions: [
      {action: 'explore', title: 'Explore this new world',
        icon: 'images/checkmark.png'},
      {action: 'close', title: 'Close',
        icon: 'images/xmark.png'},
    ]
  };
  e.waitUntil(
    self.registration.showNotification('Hello world!', options)
  );
});