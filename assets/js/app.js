import "@fortawesome/fontawesome-pro/js/all";
import css from "../css/app.css"
import "phoenix_html"
import M from "./materialize";
import User from "./user"
import Organisation from "./organisation"
// import socket from "./socket"

switch (window.location.pathname.split("/")[1]) {
    case "user":
        User.load_register_js();
        break;
    case "/organisation/new":
        Organisation.loadjs();
        break;
    default:
        break;
}

document.addEventListener('DOMContentLoaded', function () {
    document.addEventListener('invalid', (function () {
        return function (e) {
            //prevent the browser from showing default error bubble/ hint
            e.preventDefault();
        };
    })(), true);

    setup_navigation();
});

function setup_navigation() {
    let elem1 = document.getElementById("enDropdown");
    let elem2 = document.getElementById("profile");
    M.Dropdown.init(elem1, {
        coverTrigger: false
    });
    M.Dropdown.init(elem2, {
        coverTrigger: false
    });

    let elems = document.querySelectorAll('.collapsible');
    M.Collapsible.init(elems, {});

}


