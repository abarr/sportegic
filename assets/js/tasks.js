let Tasks = {

    realtime_user_search(socket) {

        let channel = socket.channel("user_search:", { token: window.token })
        let el = document.querySelector('#autocompleteInput');
        let user_list = document.getElementById("user_list")

        let search = M.Autocomplete.init(el, {
            onAutocomplete: function (event) {
                let user = document.createElement("input");
                user.setAttribute("name", "task[user]");
                user.setAttribute("hidden", "true");
                user.setAttribute("value", event);
                user_list.appendChild(user);
            },
            data: {}
        });

        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        el.addEventListener("keyup", event => {
            channel.push("search", { token: window.token, org: window.org });
        });

        channel.on(`users:${window.token}`, results => {
            search.updateData(results.payload)
        });

    },
    load_initial_people() {
        let people_elements = document.getElementsByName("task[people][]");
        let data = []
        for (var p of people_elements.values()) {
            data.push({ tag: p.value })
        }
        return data;
    },
    people_search(socket) {

        let channel = socket.channel("people_search:", { token: window.token })
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        let el = document.querySelector('.players');

        let search = M.Chips.init(el, {
            placeholder: 'Enter a name',
            secondaryPlaceholder: '+Person',
            data: Tasks.load_initial_people(),
            autocompleteOptions: {
                limit: Infinity
            },
            onChipAdd: function (e, chip) {
                let people_list = document.getElementById('people_list');

                let tag = document.createElement("input");
                tag.setAttribute("name", "task[people][]");
                tag.setAttribute("hidden", "true");
                tag.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                people_list.appendChild(tag);
            },
            onChipDelete: function (e, chip) {
                let tag = document.querySelectorAll('input[value="' + chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")) + '"]');
                people_list.removeChild(tag[0]);
            }
        });
        let input = ""
        if (el) {
            input = el.getElementsByTagName("INPUT")[0];
            el.addEventListener("keyup", e => {
                channel.push("search", { search_value: input.value, token: window.token, org: window.org });
            });
        }

        channel.on(`search:${window.token}`, results => {
            console.log(results.payload)
            console.log(el)
            el.M_Chips.autocomplete.updateData(results.payload);
        });

    }
}

export default Tasks