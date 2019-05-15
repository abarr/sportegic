let Calendar = {

    attachFlatpickrDOB(flatpickr) {
        const dob = flatpickr('#person_dob', {
            altInput: true,
            altFormat: "j F , Y",
            dateFormat: "Y-m-d",
            onChange: function(selectedDates, dateStr, instance) {
                instance.element.nextSibling.classList.remove("invalid");
                instance.element.setCustomValidity("");
            }
        });
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