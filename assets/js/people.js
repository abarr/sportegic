let People = {

    realtime_search(socket){
        console.log(socket)
        let channel = socket.channel("people_search:", {token: window.token})
        channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

        channel.push("ping", {test: "value returned"});

        channel.on(`ping:${socket.assigns.user_id}`, payload => {
            alert("WORKS")
        } )

        
    }
}

export default People