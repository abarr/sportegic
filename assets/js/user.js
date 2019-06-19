let User = {

    setupUserForm(M) {
        let role_dropdown = document.getElementById('invite-role-select');
        M.FormSelect.init(role_dropdown, {});

        let role_dropdown_input = document.getElementsByClassName("select-dropdown");
        [].forEach.call(role_dropdown_input, function (el) {
            el.classList += " grey-text lighten-2"
        });

    },
    verify_mobile(socket) {
        
        let channel = socket.channel('mobile:', {});

        var country, code_input, mobile_no
        if (document.getElementById("rsvp_country_code") || document.getElementById("user_country_code")) {
           
            if (document.getElementById("rsvp_country_code")) {
                country = document.getElementById("rsvp_country_code");
                mobile_no = document.getElementById("rsvp_mobile_no");
                code_input = document.getElementById("rsvp_code");
            } else if (document.getElementById("user_country_code")) {
                country = document.getElementById("user_country_code");
                mobile_no = document.getElementById("user_mobile_no");
                code_input = document.getElementById("user_code");
            }

            let verify = document.getElementById("verify");
            let send = document.getElementById("send");
            let valid = document.getElementById("valid");

            let code = document.getElementById("code");
            let check = document.getElementById("check");
            let submit = document.getElementById("submit");

            verify.addEventListener("click", e => {

                if (!country.reportValidity()) {
                    country.classList += " invalid"
                } else if (!mobile_no.reportValidity()) {
                    mobile_no.classList += " invalid"
                } else {
                    channel.push("send_verification", {
                        country: country.value,
                        mobile: mobile_no.value
                    });
                    verify.innerHTML = "Sent...";
                    verify.setAttribute("disabled", "true");
                    code.removeAttribute("hidden");
                    check.removeAttribute("hidden");
                }
            });

            channel.on("send_verification", payload => {
                if (payload.status == "ok") {
                    code.removeAttribute("hidden");
                    check.removeAttribute("hidden");
                    verify.innerHTML = "Resend";
                    verify.removeAttribute("disabled");
                    send.removeAttribute("disabled");

                    check.addEventListener("click", e => {
                        if (code_input.reportValidity()) {
                            channel.push("check_code", {
                                code: code_input.value,
                                country: country.value,
                                mobile: mobile_no.value
                            });
                            check.value = "Sent ...";
                            check.setAttribute("disabled", "true");
                        }
                    });
                } else {
                    country.classList += " invalid"
                    mobile_no.classList += " invalid"
                    verify.innerHTML = "Send";
                    verify.removeAttribute("disabled");
                    code.setAttribute("hidden", "true");
                    check.setAttribute("hidden", "true");
                }
            });

            channel.on("check_code", payload => {
                if (payload.status == "ok") {
                    code.setAttribute("hidden", "true");
                    check.setAttribute("hidden", "true");

                    country.setAttribute("readonly", "true")
                    mobile_no.setAttribute("readonly", "true")

                    send.setAttribute("hidden", "true");
                    valid.removeAttribute("hidden");
                    submit.removeAttribute("disabled");
                } else {
                    code_input.classList += " invalid"
                }
            });

            channel.join()
                .receive("ok", resp => { console.log("Joined successfully", resp) })
                .receive("error", resp => { console.log("Unable to join", resp) })

        }

    }

}

export default User