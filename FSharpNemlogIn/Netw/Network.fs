module Network

let SendX (prin:string) (msg:Protocol.message) = 
    match msg with
    | :? Protocol.SamlProtocolMessage -> 
        let samlmsg = (msg :?> Protocol.SamlProtocolMessage).field_2
        printfn "Message %s\nrecieved from %s" samlmsg prin
    | _ -> printfn "Message from: %s not valid" prin 
    
    Protocol.Success() :> Protocol.SamlStatus

let RecieveX (prin:string) : (Protocol.message) =
    match prin with
    | "sp" ->  Protocol.HttpGet "This is a sp reply" :> Protocol.message
    | "idp" -> Protocol.HttpGet "This is a idp reply" :> Protocol.message
    | "browser" -> Protocol.HttpGet "This is a browserreply" :> Protocol.message
    | _ -> Protocol.Failed 400 :> Protocol.message