// LIBRARIES
import "@fortawesome/fontawesome-pro/js/all";
import css from "../css/app.css"
import "phoenix_html"
import M from "./materialize";
import flatpickr from 'flatpickr'
import Vue from 'vue/dist/vue.esm.browser'; // THIS NEEDS TO BE CHANGED TO PROD VERSION HOWEVER UNKNOWN ERROR - MAYBE REMOVE VUE
// import Chart from 'chart.js';



// CUSTOM
import Elements from "./elements"
import User from "./user"
import People from "./people"
import Role from "./role";
import Calendar from "./calendar"
import Document from "./document"
import Visa from "./visa"
import Notes from "./notes"
import Tasks from "./tasks"
import Squads from "./squads"
import Performance from "./performance"

// SOCKETS
import socket from "./socket"
// import Dashboard from "./dashboard";
import Profile from "./profile";

document.addEventListener('DOMContentLoaded', function () {
    
    Elements.initLayoutTemplate(M);
    Role.setupRoleForm();
    Calendar.attachFlatpickrDOB(flatpickr);
    Calendar.attachFlatpickrExpiryDate(flatpickr, window.location.pathname.split("/")[3]);
    Calendar.attachFlatpickrIssuedDate(flatpickr);
    Calendar.attachFlatpickrEventDate(flatpickr);
    Calendar.attachFlatpickrDueDate(flatpickr);
    Calendar.attachFlatpickrPerformanceDate(flatpickr);
    Document.setupDocumentForm(M);
    Visa.setupVisaForm(M);
    User.setupUserForm(M);
    Performance.form_setup(M);


    // Calendar.attachFlatpickrExpiry(flatpickr);
    // Calendar.attachFlatpickrDueDate(flatpickr);
    if (window.location.pathname == "/dashboard") {
        // Dashboard.create_sentiment_chart(Chart);
    };

    if (window.location.pathname == "/rsvp" || window.location.pathname.split("/")[1] == "user") {

        let sportegic_socket = socket.connect_socket();
        User.verify_mobile(sportegic_socket)
    };
    if (window.location.pathname.split("/")[1] == "tasks" || window.location.pathname.split("/")[3] == "tasks") {
        let sportegic_socket = socket.connect_socket();
        Tasks.realtime_user_search(sportegic_socket);
        Tasks.people_search(sportegic_socket);
    };
    if (window.location.pathname == "/person" && window.channel) {
        let sportegic_socket = socket.connect_socket();
        People.realtime_search(sportegic_socket)
    };

    if (window.location.pathname.split("/")[1] == "squads")
    {
        let sportegic_socket = socket.connect_socket();
        Squads.people_search(sportegic_socket);
    }

    if (window.location.pathname.split("/")[1] == "notes" || window.location.pathname.split("/")[3] == "notes") {
        let sportegic_socket = socket.connect_socket();
        Notes.tags_search(sportegic_socket);
        Notes.people_search(sportegic_socket);
        Notes.notes_search(Vue, sportegic_socket);
    };

    if (window.location.pathname.split("/")[3] == "profile" && document.getElementById('p'))
    {
        let sportegic_socket = socket.connect_socket();
        Profile.load_positions(sportegic_socket);
    }

    // Check if there are flash messages via global variables and init a toast
    if (window.toast) {
        var toastHTML = '<div class="msg">' + window.toast + '</div>'
        switch (window.status) {
            case "info":
                M.toast({ html: toastHTML, displayLength: 4000, classes: "blue lighten-3" })
                break;
            case "danger":
                M.toast({ html: toastHTML, displayLength: 4000, classes: "red lighten-3" })
                break;
            case "success":
                M.toast({ html: toastHTML, displayLength: 4000, classes: "green lighten-3" })
                break;
            default:
                break;
        }

    }

    M.updateTextFields();
});
