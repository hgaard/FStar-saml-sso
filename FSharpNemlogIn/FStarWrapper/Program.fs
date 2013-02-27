open System


open System
open Saml
[<EntryPoint>]
let main argv = 
    
    //X.CreateAndSend "sp" "idp"

    let msg = X.GetReq "sp" "idP"
    printfn "%s" msg
    ignore <| Console.Read()  //removing this just so that test runs to completion without kb input
    0 //integer exit code
