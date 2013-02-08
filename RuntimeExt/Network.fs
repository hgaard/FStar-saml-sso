module Network

let Send (prin:string) (msg:string) = 
    printfn "Message: %s recieved from: %s" msg prin
    true

let Recieve (prin:string) : Prims.DepTuple<string,string> =
    let msg = "a message sent to " + prin
    let status = "ok"
    printfn "Message: %s recieved. Status %s" msg status
    Microsoft.FStar.Runtime.Pickler.mkDTuple msg status
