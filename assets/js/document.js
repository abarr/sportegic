let Document = {

    setupDocumentForm(M, flatpickr) {
        let type_dropdown = document.getElementById('type-select');
        M.FormSelect.init(type_dropdown, {});

        if (document.getElementsByClassName("select-wrapper").length > 0) {
            let wrappers = document.getElementsByClassName("select-wrapper");
            wrappers[0].addEventListener("change", event => {
                wrappers[0].classList.remove("invalid");
            });
        }
    }

}

export default Document