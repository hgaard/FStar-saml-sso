open System
open System.Security.Cryptography
open Network
open CryptoTest

let rec StartListen() =
    xServer.server "sp" "idp"
    let key = Console.ReadKey ()
    match key.KeyChar with
    | 'x' -> ()
    | _ -> StartListen()


[<EntryPoint>]
let main argv = 
  
  let x = X.GenKeys("some important principal")
  let key = Console.Read ()
  0 // return an integer exit code
