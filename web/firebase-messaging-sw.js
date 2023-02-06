importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

/*Update with yours config*/
const firebaseConfig = {
    apiKey: "AIzaSyBNsWU6g_Rtvctqs7VEzCx3FATJdHlpvxk",
    authDomain: "agromash-message.firebaseapp.com",
    projectId: "agromash-message",
    storageBucket: "agromash-message.appspot.com",
    messagingSenderId: "446932448926",
    appId: "1:446932448926:web:384716a49e7c78be0b6d8f",
    measurementId: "G-HK9Z89WQP5"
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

/*messaging.onMessage((payload) => {
console.log('Message received. ', payload);*/
messaging.onBackgroundMessage(function (payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});