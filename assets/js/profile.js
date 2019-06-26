let Profile = {

    load_positions(socket){

        let channel = socket.channel("profile:", { token: window.token })
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("get_positions", { token: window.token, org: window.org });

        let positions = document.querySelector('.positions');
        let p = document.getElementById('p');
        
        channel.on(`profile:${window.token}`, results => {
            console.log(results.payload);
            
            let i = M.Chips.init(positions, {
                placeholder: '+Add a position',
                secondaryPlaceholder: '+Another postions',
                data: [],
                autocompleteOptions: {
                    data: results.payload,
                    limit: Infinity,
                    minLength: 1
                },
                onChipAdd: function (e, chip) {
                    channel.push("update_positions", { token: window.token, org: window.org, person_id: p.value, positions: i.chipsData });
                    

                },
                onChipDelete: function (e, chip) {
                    console.log(p.value);
                }
            });
            console.log(i);

        });

        
    },
    position_search(socket) {

        let channel = socket.channel("profile:", { token: window.token })
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("get_positions", { token: window.token, org: window.org });

        let positions = document.querySelector('.positions');

        channel.on(`profile:${window.token}`, results => {
            let i = M.Chips.init(tags, {
                placeholder: 'Enter a tag',
                secondaryPlaceholder: '+Tag',
                data: Notes.load_initial_tags(),
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
                    tag.setAttribute("name", 'note[types][]');
                    tag.setAttribute("hidden", "true");
                    tag.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                    tags_list.appendChild(tag);
                },
                onChipDelete: function (e, chip) {
                    let tag = document.querySelectorAll('input[value="' + chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")) + '"]');
                    tags_list.removeChild(tag[0]);
                    if (i.chipsData.length == 0) {
                        let t = document.getElementById("note_tag");
                        t.classList += " invalid"
                        let input = document.getElementsByClassName('chips tags');
                        input[0].classList += " invalid"
                    }
                }
            });

        });

    }

}

export default Profile