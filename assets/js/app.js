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

// SOCKETS
import socket from "./socket"

document.addEventListener('DOMContentLoaded', function () {

    Elements.initLayoutTemplate(M);
    Role.setupRoleForm();
    Calendar.attachFlatpickrDOB(flatpickr);
    Document.setupDocumentForm(M, flatpickr);
    User.setupUserForm(M)
    // Calendar.attachFlatpickrExpiry(flatpickr);
    // Calendar.attachFlatpickrDueDate(flatpickr);


    if (window.location.pathname == "/rsvp" || window.location.pathname == "/user/new") {
        let sportegic_socket = socket.connect_socket();
        User.verify_mobile(sportegic_socket)
    };
    if (window.location.pathname == "/person") {
        let sportegic_socket = socket.connect_socket();
        People.realtime_search(sportegic_socket)
    };

    M.updateTextFields();
});
