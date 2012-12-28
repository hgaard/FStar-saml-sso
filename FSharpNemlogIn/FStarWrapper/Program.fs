// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.
open System
[<EntryPoint>]
let main argv = 
//    print.printf_fst (Array.get argv 0)
    Main.main "thesp" "theuri" "me" "myPassword"
    let key = Console.Read ()
    0 // return an integer exit code
