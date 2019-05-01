import "@fortawesome/fontawesome-pro/js/all";
import css from "../css/app.css"
import "phoenix_html"
import M from "./materialize";
import Navigation from "./navigation"
import User from "./user"
import Organisation from "./organisation"
import Role from "./role";
import socket from "./socket"



document.addEventListener('DOMContentLoaded', function () {

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

    let sportegic_socket = socket.connect_socket();
    if (window.location.pathname == "/rsvp" || window.location.pathname == "/user/new") { User.verify_mobile(sportegic_socket) };

});
