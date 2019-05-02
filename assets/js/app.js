import "@fortawesome/fontawesome-pro/js/all";
import css from "../css/app.css"
import "phoenix_html"
import M from "./materialize";
import flatpickr from 'flatpickr'

import Navigation from "./navigation"
import User from "./user"
import People from "./people"
import Organisation from "./organisation"
import Role from "./role";
import Calendar from "./calendar.js"

import socket from "./socket"



document.addEventListener('DOMContentLoaded', function () {

    let sportegic_socket = socket.connect_socket();

    // Javascript to enable a close icon on any flash messages
    if(document.getElementById("alert_close")){
        let close = document.getElementById("alert_close");
        close.addEventListener("click", e => {
            let card = document.getElementsByClassName("scale-transition")
            card[0].classList += " scale-out";
            card[0].parentElement.removeChild(card[0]);
        });
    }

    //prevent the browser from showing default error bubble/ hint
    document.addEventListener('invalid', (function () {
        return function (e) {
            e.preventDefault();
        };
    })(), true);

    Navigation.init_page_elements();
    Role.setup_role_form();

    // Attach Flatpickr to form inputs
    Calendar.attachFlatpickrDOB(flatpickr);
    // Calendar.attachFlatpickrExpiry(flatpickr);
    // Calendar.attachFlatpickrDueDate(flatpickr);

    
    if (window.location.pathname == "/rsvp" || window.location.pathname == "/user/new") { User.verify_mobile(sportegic_socket) };
    if (window.location.pathname == "/person") { People.realtime_search(sportegic_socket) };

});
