open System
open Network

[<EntryPoint>]
let main argv = 
//    print.printf_fst (Array.get argv 0)
    //Main.main "thesp" "theuri" "me" "myPassword"
    let msg = X.GetReq "sp" "idp"
    printfn "%s" msg

    let _ = X.CreateSendAndRecieve "sp" "idp"
   
    let key = Console.Read ()
    0 // return an integer exit code
