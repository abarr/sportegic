let Profile = {

    load_positions(socket){

        let channel = socket.channel("profile:", { token: window.token })
        let positions = document.querySelector('.positions');
        let p = document.getElementById('p');
        let player_positions = []
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("get_positions", { token: window.token, org: window.org, person_id: p.value});
        
        channel.on(`profile:${window.token}`, results => {
            let i = M.Chips.init(positions, {
                placeholder: '+Add a position',
                secondaryPlaceholder: '+More',
                data: results.player_positions,
                autocompleteOptions: {
                    data: results.all_positions,
                    limit: Infinity,
                    minLength: 1
                },
                onChipAdd: function (e, chip) {
                    // if( validChipsValues.indexOf(chip.tag) !== -1) return;
                    let validList = i.options.autocompleteOptions.data;
                    let len = i.chipsData.length
                    if(!validList.hasOwnProperty(i.chipsData[len - 1].tag))
                    {
                        i.deleteChip(len - 1);
                    }else{
                        channel.push("update_positions", { token: window.token, org: window.org, person_id: p.value, positions: i.chipsData });
                    }
                    
                },
                onChipDelete: function (e, chip) {
                    channel.push("update_positions", { token: window.token, org: window.org, person_id: p.value, positions: i.chipsData });
                }
            });
            

        });

        channel.on(`profile_update:${window.token}`, results => {
            var toastHTML = '<div class="msg">' + results.payload + '</div>'
            switch (results.type) {
                case "success":
                    M.toast({ html: toastHTML, displayLength: 4000, classes: "blue lighten-3" })
                    break;
                default:
                    M.toast({ html: toastHTML, displayLength: 4000, classes: "red lighten-3" })
                    break;
            }
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