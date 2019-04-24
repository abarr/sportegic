let Navigation = {

    init_page_elements() {

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
            constrainWidth: false,
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
                if (["role"].includes(page)) {
                    document.getElementById("administration").click();
                }
            }
        });

        // This ensures lable are moved when fields are pre-filed (e.g. forms with errors)
        M.updateTextFields();

        let fabs = document.querySelectorAll('.fixed-action-btn');
        M.FloatingActionButton.init(fabs, {
            direction: 'left'
        });

        let brand = document.getElementById("fourteen");
        M.CharacterCounter.init(brand);


    }
}
export default Navigation