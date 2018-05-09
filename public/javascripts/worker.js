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
        clients.openWindow('http://www.example.com');
        notification.close();
    }
});