let Tasks = {
    load_assignee() {
        let assignee_name = document.getElementsByName("task[assignee_name]")[0];
        console.log(assignee_name.value)
        let assignee = [];
        if(assignee_name.value){assignee.push({ tag: assignee_name.value })}
        console.log(assignee)
        return assignee;
    },
    realtime_user_search(socket) {

        let channel = socket.channel("user_search:", { token: window.token })
        let el = document.querySelector('.assignee_input');
        let user_list = document.getElementById("user_list")

        let current_results = "";

        let search = M.Chips.init(el, {
            placeholder: 'Assign task',
            secondaryPlaceholder: '',
            limit: 1,
            data: Tasks.load_assignee(),
            autocompleteOptions: {
                limit: 1
            },
            onChipAdd: function (e, chip) {
                if (Object.entries(current_results).length === 0 && current_results.constructor === Object){
                    let instance = M.Chips.getInstance(el);
                    let len = instance.chipsData.length;
                    instance.deleteChip(len - 1);
                 }else{
                    let assignee = document.getElementById('task_assignee_name')
                    assignee.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                 }                
            },
            onChipDelete: function (e, chip) {
                let assignee = document.getElementById('task_assignee_name')
                assignee.setAttribute("value", "");
            }
        });

        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        if (el) {
            el.addEventListener("keyup", event => {
                channel.push("search", { token: window.token, org: window.org });
            });

        }

        channel.on(`users:${window.token}`, results => {
            el.M_Chips.autocomplete.updateData(results.payload)
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
        let current_results = "";

        let search = M.Chips.init(el, {
            placeholder: '+Person',
            secondaryPlaceholder: '+Person',
            data: Tasks.load_initial_people(),
            autocompleteOptions: {
                limit: Infinity
            },
            onChipAdd: function (e, chip) {

                if (Object.entries(current_results).length === 0 && current_results.constructor === Object){
                    let instance = M.Chips.getInstance(el);
                    let len = instance.chipsData.length;
                    instance.deleteChip(len - 1);
                 }else{
                    let people_list = document.getElementById('people_list');
                    let tag = document.createElement("input");
                    tag.setAttribute("name", "task[people][]");
                    tag.setAttribute("hidden", "true");
                    tag.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                    people_list.appendChild(tag);
                 }                
            },
            onChipDelete: function (e, chip) {
                
                if(document.querySelectorAll('input[value="'+chip.firstChild.data+'"').length > 0)
                {
                    let elem = document.querySelectorAll('input[value="' + chip.firstChild.data + '"')[0];
                    document.getElementById("people_list").removeChild(elem);
                }
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
            el.M_Chips.autocomplete.updateData(results.payload);
            current_results = results.payload;
        });

    }
}

export default Tasks