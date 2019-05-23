// LIBRARIES
import "@fortawesome/fontawesome-pro/js/all";
import css from "../css/app.css"
import "phoenix_html"
import M from "./materialize";
import flatpickr from 'flatpickr'

// CUSTOM
import Elements from "./elements"
import User from "./user"
import People from "./people"
import Role from "./role";
import Calendar from "./calendar"
import Document from "./document"
import Visa from "./visa"
import Notes from "./notes"

// SOCKETS
import socket from "./socket"

document.addEventListener('DOMContentLoaded', function () {

    Elements.initLayoutTemplate(M);
    Role.setupRoleForm();
    Calendar.attachFlatpickrDOB(flatpickr);
    Calendar.attachFlatpickrExpiryDate(flatpickr, window.location.pathname.split("/")[3])
    Calendar.attachFlatpickrIssuedDate(flatpickr)
    Calendar.attachFlatpickrEventDate(flatpickr)
    Document.setupDocumentForm(M);
    Visa.setupVisaForm(M);
    User.setupUserForm(M)
    // Calendar.attachFlatpickrExpiry(flatpickr);
    // Calendar.attachFlatpickrDueDate(flatpickr);


    if (window.location.pathname == "/rsvp" || window.location.pathname == "/user/new") {
        let sportegic_socket = socket.connect_socket();
        User.verify_mobile(sportegic_socket)
    };
    if (window.location.pathname == "/person" && window.channel) {
        let sportegic_socket = socket.connect_socket();
        People.realtime_search(sportegic_socket)
    };

    if (window.location.pathname.split("/")[1] == "notes" && window.channel) {
        let sportegic_socket = socket.connect_socket();
        Notes.tags_search(sportegic_socket);
        Notes.people_search(sportegic_socket)
    };
    // Check if there are flash messages via global variables and init a toast
    if (window.toast) {
        var toastHTML = '<div class="msg">' + window.toast + '</div>'
        console
        switch (window.status) {
            case "info":
                M.toast({ html: toastHTML, displayLength: 54000, classes: "blue lighten-3" })
                break;
            case "danger":
                M.toast({ html: toastHTML, displayLength: 54000, classes: "red lighten-3" })
                break;
            case "success":
                M.toast({ html: toastHTML, displayLength: 54000, classes: "green lighten-3" })
                break;
            default:
                break;
        }

    }

    M.updateTextFields();
});
