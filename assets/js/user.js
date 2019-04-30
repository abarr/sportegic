let User = {

    verify_mobile(socket) {

        let channel = socket.channel('mobile:', {});

        let verify = document.getElementById("verify");
        let send = document.getElementById("send");
        let valid = document.getElementById("valid");
        let country = document.getElementById("rsvp_country");
        let mobile_no = document.getElementById("rsvp_mobile_no");
        let code = document.getElementById("code");
        let code_input = document.getElementById("rsvp_code");
        let check = document.getElementById("check");
        let mobile = document.getElementById("mobile");
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
            if (payload.status == "pending" && payload.response == 201) {
                mobile.value = payload.mobile;
                code.removeAttribute("hidden");
                check.removeAttribute("hidden");
                verify.innerHTML = "Resend";
                send.removeAttribute("disabled");

                check.addEventListener("click", e => {
                    if (code_input.reportValidity()) {
                        channel.push("check_code", {
                            code: code_input.value,
                            country: country.value,
                            mobile: mobile_no.value
                        });
                        check.value = "Sent ...";
                        check.setAttribute("disbaled", "true");
                    }
                });
            }
        });

        channel.on("check_code", payload => {
            if (payload.status == "ok") {
                code.setAttribute("hidden", "true");
                check.setAttribute("hidden", "true");

                send.setAttribute("hidden", "true");
                valid.removeAttribute("hidden");
                submit.removeAttribute("disbaled");



            }
        });

        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

    }

}

export default User