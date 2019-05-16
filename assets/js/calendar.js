let Calendar = {

    attachFlatpickrDOB(flatpickr) {
        const dob = flatpickr('.flatpickr-dob', {
            altInput: true,
            altFormat: "j F , Y",
            dateFormat: "Y-m-d",
            wrap: true,
            allowInput: true,
            onChange: function (selectedDates, dateStr, instance) {
                if (instance) {
                    let dob = document.getElementById("person_dob");
                    dob.nextElementSibling.classList.remove("invalid");
                    dob.nextElementSibling.classList.remove("validate");
                }
            }
        });

        if (document.getElementById("person_dob")) {
            let input = document.getElementById("person_dob").nextElementSibling;
            input.setAttribute("readonly", "true");
            input.setAttribute("required", "true");
            input.classList += " grey-text lighten-2 validate";
        }
    },
    attachFlatpickrExpiryDate(flatpickr, path) {
        let id = path + "_expiry_date"
        const dob = flatpickr('.flatpickr-expiry-date', {
            altInput: true,
            altFormat: "j F , Y",
            dateFormat: "Y-m-d",
            wrap: true,
            allowInput: true,
            onChange: function (selectedDates, dateStr, instance) {
                if (instance) {
                    let ed = document.getElementById(id);
                    ed.nextElementSibling.classList.remove("invalid");
                    ed.nextElementSibling.classList.remove("validate");
                }
            }
        });

        if (document.getElementById(id)) {
            let input = document.getElementById(id).nextElementSibling;
            input.setAttribute("readonly", "true");
            input.setAttribute("required", "true");
            input.classList += " grey-text lighten-2 validate";
        }
    },
    attachFlatpickrIssuedDate(flatpickr) {
        const dob = flatpickr('.flatpickr-issued-date', {
            altInput: true,
            altFormat: "j F , Y",
            dateFormat: "Y-m-d",
            wrap: true,
            allowInput: true,
            onChange: function (selectedDates, dateStr, instance) {
                if (instance) {
                    let id = document.getElementById("visa_issued_date");
                    id.nextElementSibling.classList.remove("invalid");
                    id.nextElementSibling.classList.remove("validate");
                }
            }
        });

        if (document.getElementById("visa_issued_date")) {
            let input = document.getElementById("visa_issued_date").nextElementSibling;
            input.setAttribute("readonly", "true");
            input.setAttribute("required", "true");
            input.classList += " grey-text lighten-2 validate";
        }
    },
    attachFlatpickrDueDate(flatpickr) {
        const expiry_date = flatpickr('#dueDate', {
            altInput: true,
            altFormat: "F j, Y",
            dateFormat: "Y-m-d",
            minDate: "today",
            maxDate: new Date().fp_incr(365)
        });
    }
}

export default Calendar