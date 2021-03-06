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
            input.classList += " validate";
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
            input.classList += " validate";
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
            input.classList += " validate";
        }
    },
    attachFlatpickrEventDate(flatpickr) {
        const event = flatpickr('.flatpickr-event-date', {
            defaultDate: 'today',
            altInput: true,
            altFormat: "j F , Y",
            dateFormat: "Z",
            wrap: true,
            maxDate: "today",
            allowInput: true,
            onChange: function (selectedDates, dateStr, instance) {
                if (instance) {
                    let id = document.getElementById("note_event_date");
                    id.nextElementSibling.classList.remove("invalid");
                    id.nextElementSibling.classList.remove("validate");
                }
            }
        });

        if (document.getElementById("note_event_date")) {
            let input = document.getElementById("note_event_date").nextElementSibling;
            input.setAttribute("readonly", "true");
            input.setAttribute("required", "true");
            input.classList += " validate";
        }
    },
    attachFlatpickrPerformanceDate(flatpickr) {
        const event = flatpickr('.flatpickr-performance-date', {
            defaultDate: 'today',
            altInput: true,
            altFormat: "j F , Y",
            dateFormat: "Z",
            wrap: true,
            maxDate: "today",
            allowInput: true,
            onChange: function (selectedDates, dateStr, instance) {
                if (instance) {
                    let id = document.getElementById("performance_date");
                    id.nextElementSibling.classList.remove("invalid");
                    id.nextElementSibling.classList.remove("validate");
                }
            }
        });

        if (document.getElementById("note_event_date")) {
            let input = document.getElementById("note_event_date").nextElementSibling;
            input.setAttribute("readonly", "true");
            input.setAttribute("required", "true");
            input.classList += " validate";
        }
    },
    attachFlatpickrDueDate(flatpickr) {
        const expiry_date = flatpickr('.flatpickr-due-date', {
            altInput: true,
            altFormat: "F j, Y",
            dateFormat: "Z",
            maxDate: new Date().fp_incr(365),
            wrap: true,
            allowInput: true,
            onChange: function (selectedDates, dateStr, instance) {
                if (instance) {
                    let id = document.getElementById("task_due_date");
                    id.nextElementSibling.classList.remove("invalid");
                    id.nextElementSibling.classList.remove("validate");
                }
            }
        });

        if (document.getElementById("task_due_date")) {
            let input = document.getElementById("task_due_date");
            input.classList += " validate";
            let input_next = input.nextElementSibling;
            input_next.setAttribute("readonly", "true");
            input_next.setAttribute("required", "true");
            input_next.classList += " validate";
        }
    }
}

export default Calendar