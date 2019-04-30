import { Socket } from "phoenix";

let socket = {

    connect_socket() {
        let socket = new Socket("/socket", { params: { token: window.userToken } })
        socket.connect()
        return socket
    }

}

export default socket