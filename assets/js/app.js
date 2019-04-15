import "@fortawesome/fontawesome-pro/js/all";
import css from "../css/app.css"
import "phoenix_html"
import M from "./materialize";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"


// COMPONENT INITIALIZATION
document.addEventListener('DOMContentLoaded', function () {
    var elem = document.getElementById("enDropdown");
    M.Dropdown.init(elem, {
        coverTrigger: false
    });

    var elems = document.querySelectorAll('.collapsible');
    var instances = M.Collapsible.init(elems, {});


});
