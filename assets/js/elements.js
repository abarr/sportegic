let Elements = {

    initLayoutTemplate(M) {
        // Javascript to enable a close icon on any flash messages
        if (document.getElementById("alert_close")) {
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

        let lang_dropdown = document.getElementById("enDropdown");
        let profile_dropdown = document.getElementById("profile");
        let profile_dropdown_large = document.getElementById("profile-large");

        M.Dropdown.init(lang_dropdown, { coverTrigger: false });
        M.Dropdown.init(profile_dropdown, {
            coverTrigger: false,
            hover: false,
            constrainWidth: false,
            alignment: 'right',
            closeOnClick: false

        });
        M.Dropdown.init(profile_dropdown_large, {
            coverTrigger: false,
            hover: false,
            constrainWidth: true,
            alignment: 'right'


        });
        // Init all collapsible menu items
        let elems = document.querySelectorAll('.collapsible');
        M.Collapsible.init(elems, {});

        let tooltips = document.querySelectorAll('.tooltipped')
        M.Tooltip.init(tooltips, {});

        var sidenav = document.querySelectorAll('.sidenav');
        M.Sidenav.init(sidenav, {});

        // Set menu active state
        let page = window.location.pathname.split('/')[1];
        let active = document.getElementsByClassName("active");
        let menuItems = document.getElementsByClassName("menu");

        [].forEach.call(active, function (el) {
            el.classList.remove("active");
        });

        [].forEach.call(menuItems, el => {
            if (el.id == page) {
                el.classList += " active";
                if (["role", "user", "my_profile", "lookup"].includes(page)) {
                    document.getElementById("administration").click();
                }
            }
        });

        let fabs = document.querySelectorAll('.fixed-action-btn');
        M.FloatingActionButton.init(fabs, {
            direction: 'left',
            hoverEnabled: false

        });

        let brand = document.getElementById("fourteen");
        M.CharacterCounter.init(brand);

        let tabs = document.querySelector(".tabs");
        let instances = M.Tabs.init(tabs, {});

        
        

        
    }
}

export default Elements