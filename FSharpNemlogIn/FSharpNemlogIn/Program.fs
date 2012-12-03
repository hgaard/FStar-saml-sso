// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.
open SamlProtocol

[<EntryPoint>]
let main argv = 
    let client = new client()
    let res = client.Login("sp1")
    printfn "Resource recieved from sp %s" res
    0 // return an integer exit code
     