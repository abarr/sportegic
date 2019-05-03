let People = {

    realtime_search(socket) {

        let channel = socket.channel("people_search:", { token: window.token })
        let el = document.querySelector('#autocompleteInput');
        let people_ids = ""
        let search = M.Autocomplete.init(el, {
            onAutocomplete: function (event) {
                window.location.href = people_ids[event]
            },
            data: {}
        });

        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        el.addEventListener("keyup", event => {
            channel.push("search", { search_value: el.value, token: window.token, org: window.org });
        });

        channel.on(`search:${window.token}`, results => {
            people_ids = results.ids;
            search.updateData(results.payload)
        });

    }
}

export default People