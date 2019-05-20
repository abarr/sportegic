let Notes = {

    tags_search(socket) {

        let channel = socket.channel("tags:", { token: window.token })
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("get_tags", { token: window.token, org: window.org });

        let tags = document.querySelector('.tags');

        channel.on(`tags:${window.token}`, results => {
            let i = M.Chips.init(tags, {
                placeholder: 'Enter a tag',
                secondaryPlaceholder: '+Tag',
                autocompleteOptions: {
                    data: results.payload,
                    limit: Infinity,
                    minLength: 1
                },
                onChipAdd: function (e, chip) {
                    let t = document.getElementById("note_tag");
                    t.classList.remove("invalid");
                    let input = document.getElementsByClassName('chips tags');
                    input[0].classList.remove("invalid");
                    let tags_list = document.getElementById('tags_list');
                    let tag = document.createElement("input");
                    tag.setAttribute("name", "note[types][]");
                    tag.setAttribute("hidden", "true");
                    tag.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                    tags_list.appendChild(tag);
                },
                onChipDelete: function (e, chip) {
                    let tag = document.querySelectorAll('input[value="' + chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")) + '"]');
                    tags_list.removeChild(tag[0]);
                    if(i.chipsData.length == 0){
                        let t = document.getElementById("note_tag");
                        t.classList += " invalid"
                        let input = document.getElementsByClassName('chips tags');
                        input[0].classList += " invalid"
                    }
                }
            });
            
        });

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
            autocompleteOptions: {
                limit: Infinity
            },
            onChipAdd: function (e, chip) {
                let people_list = document.getElementById('people_list');
                
                let tag = document.createElement("input");
                tag.setAttribute("name", "note[people][]");
                tag.setAttribute("hidden", "true");
                tag.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                people_list.appendChild(tag);
            },
            onChipDelete: function (e, chip) {
                let tag = document.querySelectorAll('input[value="' + chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")) + '"]');
                people_list.removeChild(tag[0]);
            }
        });
        let input = el.getElementsByTagName("INPUT")[0];

        el.addEventListener("keyup", e => {
            channel.push("search", { search_value: input.value, token: window.token, org: window.org });
        });

        channel.on(`search:${window.token}`, results => {
            console.log(results.payload)
            el.M_Chips.autocomplete.updateData(results.payload);
        });

    }
}

export default Notes