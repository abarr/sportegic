import moment from 'moment';

let Notes = {

    notes_search(Vue, socket) {
        if(document.querySelector('#vue-search-results')){
            new Vue({
                el: '#vue-search-results',
                mounted: function () {
                    this.channel = socket.channel("notes:", { token: window.token })
                    this.channel.on(`search:${window.token}`, results => {
                        this.notes = results.results;
                        this.heading = "Search Results"
                    });
                    this.channel.on(`recent:${window.token}`, results => {
                        this.notes = results.results;
                    });
                    this.channel.join()
                        .receive("ok", resp => { console.log("Joined successfully to notes", resp) })
                        .receive("error", resp => { console.log("Unable to join", resp) })

                    this.channel.push("recent", { token: window.token, org: window.org });    
                },
                data: {
                    notes: [],
                    search: '',
                    channel: null,
                    heading: "Most Recent (5)"
                },
                methods: {
                    searchNotes() {
                        this.channel.push("search", { search_value: this.search, token: window.token, org: window.org });
                    },
                    go(id){
                       window.location = "/notes/" + id;          
                    }
                },
                filters: {
                    moment: function (date) {
                        return moment(date).format('DD/MM/YYYY');
                    }
                }
    
            });
        }
    },

    load_initial_tags() {

        let tag_elements = document.getElementsByName("note[types][]");
        let data = []
        for (var v of tag_elements.values()) {
            data.push({ tag: v.value })
        }
        return data;
    },
    load_initial_people() {

        let people_elements = document.getElementsByName("note[people][]");
        let data = []
        for (var p of people_elements.values()) {
            data.push({ tag: p.value })
        }
        return data;
    },
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
            data: Notes.load_initial_people(),
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
        let input = ""
        if (el) {
            input = el.getElementsByTagName("INPUT")[0];
            el.addEventListener("keyup", e => {
                channel.push("search", { search_value: input.value, token: window.token, org: window.org });
            });
        }

        channel.on(`search:${window.token}`, results => {
            el.M_Chips.autocomplete.updateData(results.payload);
        });

    }
}

export default Notes