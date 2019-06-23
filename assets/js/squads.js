let Squads = {
    people_search(socket) {

        let channel = socket.channel("people_search:", {
            token: window.token
        })
        channel.join()
            .receive("ok", resp => {
                console.log("Joined successfully", resp)
            })
            .receive("error", resp => {
                console.log("Unable to join", resp)
            })

        let el = document.querySelector('.players');
        let current_results = "";
        let people_ids = "";

        let search = M.Chips.init(el, {
            placeholder: 'Enter a name',
            secondaryPlaceholder: '+Person',
            data: [],
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
                    let person = document.createElement("input");
                    person.setAttribute("name", "squad_members[]");
                    person.setAttribute("hidden", "true");
                    person.setAttribute("value", people_ids[chip.firstChild.data]);
                    person.setAttribute("id", people_ids[chip.firstChild.data]);
                    people_list.appendChild(person);
                }
            },
            onChipDelete: function (e, chip) {
                if(document.querySelectorAll('input[value="'+chip.firstChild.data+'"').length > 0)
                {
                    let elem = document.getElementById(document.querySelectorAll('input[value="' + chip.firstChild.data + '"')[0].id);
                    document.getElementById("people_list").removeChild(elem);
                }
            
            }
        });
        let input = ""
        if (el) {
            input = el.getElementsByTagName("INPUT")[0];
            el.addEventListener("keyup", e => {
                channel.push("search", {
                    search_value: input.value,
                    token: window.token,
                    org: window.org
                });
            });
        }

        channel.on(`search:${window.token}`, results => {
            el.M_Chips.autocomplete.updateData(results.payload);
            people_ids = results.ids;
            current_results = results.payload;
        });

    }

}

export default Squads