open System


open System
[<EntryPoint>]
let main argv = 
    X.test "me"
    printfn "Done" 
    ignore <| Console.Read()  //removing this just so that test runs to completion without kb input
    0 //integer exit code
