let Document = {

    setupDocumentForm(M, flatpickr) {
        let type_dropdown = document.getElementById('type-select');
        M.FormSelect.init(type_dropdown, {});

        let type_dropdown_input = document.getElementsByClassName("select-dropdown");
        [].forEach.call(type_dropdown_input, function (el) {
            el.classList += " grey-text lighten-2"
        });

        const expiry_date = flatpickr('#expiry_date', {
            altInput: true,
            altFormat: "F j, Y",
            dateFormat: "Y-m-d"
        });

    }

}

export default Document