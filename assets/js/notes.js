let Notes = {

    tags_search(socket) {

        let channel = socket.channel("tags:", { token: window.token })
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("get_tags", { token: window.token, org: window.org });

        let tag_ids = ""
        let tags = document.querySelectorAll('.tags');

        channel.on(`tags:${window.token}`, results => {
            tag_ids = results.ids;
            M.Chips.init(tags, {
                placeholder: 'Enter a tag',
                secondaryPlaceholder: '+Tag',
                autocompleteOptions: {
                    data: results.payload,
                    limit: Infinity,
                    minLength: 1
                }
            });
        });

    }
}

export default Notes