let Document = {

    setupDocumentForm(M, flatpickr) {
        let type_dropdown = document.getElementById('type-select');
        M.FormSelect.init(type_dropdown, {});

        const expiry_date = flatpickr('#document_expiry_date', {
            altInput: true,
            altFormat: "F j, Y",
            dateFormat: "Y-m-d"
        });

    }

}

export default Document