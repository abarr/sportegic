let Notes = {

    tags_search(socket) {

        let channel = socket.channel("tags:", { token: window.token })
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("get_tags", { token: window.token, org: window.org });

        let tag_ids = ""
        let tags = document.querySelector('.tags');

        channel.on(`tags:${window.token}`, results => {
            M.Chips.init(tags, {
                placeholder: 'Enter a tag',
                secondaryPlaceholder: '+Tag',
                autocompleteOptions: {
                    data: results.payload,
                    limit: Infinity,
                    minLength: 1
                },
                onChipAdd: function (e, chip) {
                    let tags_list = document.getElementById('tags_list');
                    console.log(tags_list)
                    let tag = document.createElement("input");
                    tag.setAttribute("name", "note[types][]");
                    tag.setAttribute("hidden", "true");
                    console.log(chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                    tag.setAttribute("value", chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                    tags_list.appendChild(tag);
                },
                onChipDelete: function (e, chip) {
                    let tag = document.querySelectorAll("input[value=" + chip.innerHTML.substr(0, chip.innerHTML.indexOf("<i")));
                    console.log(tag)
                }
            });
        });

    }
}

export default Notes