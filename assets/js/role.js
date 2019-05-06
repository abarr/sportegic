let Role = {

    setupRoleForm() {
        let all_checkboxes = document.querySelectorAll("input[type=checkbox]");

        [].forEach.call(all_checkboxes, function (el) {

            if (el.closest("div").parentElement.id == "row_all_people_permissions" && el.dataset.field == "View") {
                el.checked = true;
                el.disabled = true;
            }

            el.addEventListener("click", event => {
                if (el.hasAttribute("data-all")) {
                    let parent = document.getElementById("row_" + el.id)
                    let cb_children = parent.querySelectorAll("input[type=checkbox]");
                    if (!el.checked) {
                        [].forEach.call(cb_children, function (cb) {
                            if (!cb.disabled) { cb.checked = false; }
                        });
                    } else {
                        [].forEach.call(cb_children, function (cb) {
                            cb.checked = true;
                        });
                    }
                } else {
                    if (!el.checked) {
                        let parent = el.closest('.col').parentElement
                        let all = parent.querySelectorAll('input[data-all]')

                        if (el.dataset.field == "View") {
                            [].forEach.call(parent.querySelectorAll("input[type=checkbox]"), function (cb) {
                                cb.checked = false;
                            })
                        }

                        el.checked = false;
                        all[0].checked = false;

                    } else {
                        let parent = el.closest("div").parentElement;
                        let view = parent.querySelectorAll("input[data-field=View]");
                        view[0].checked = true;
                        el.checked = true;
                    }
                }
            });
        });
    }

}

export default Role