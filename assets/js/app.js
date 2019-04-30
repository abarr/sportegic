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




    //prevent the browser from showing default error bubble/ hint
    document.addEventListener('invalid', (function () {
        return function (e) {
            e.preventDefault();
        };
    })(), true);

    Navigation.init_page_elements();
    Role.setup_role_form();

    let sportegic_socket = socket.connect_socket();
    if (window.location.pathname == "/rsvp") { User.verify_mobile(sportegic_socket) };

});
