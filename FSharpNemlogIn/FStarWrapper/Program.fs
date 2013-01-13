open System
open System.Security.Cryptography
open Network
open CryptoTest

[<EntryPoint>]
let main argv = 
    let _ = TestCrypto  
        
    //    let _ = X.CreateSendAndRecieve "sp" "idp"
   
    let key = Console.Read ()
    0 // return an integer exit code
