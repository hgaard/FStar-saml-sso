// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.
open System
[<EntryPoint>]
let main argv = 
    X.test "me"
    printfn "Done" 
    (* ignore <| Console.Read() *) //removing this just so that test runs to completion without kb input
    0 //integer exit code

