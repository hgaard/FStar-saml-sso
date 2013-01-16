open System
open System.Security.Cryptography
open Network
open CryptoTest

[<EntryPoint>]
let main argv = 
    
//    let keys = Protocol.KeyGenExt "me"
//    let priv = keys.__tag
    
    //let _ = TestCrypto  
    let req = X.GetSamlMessages "sp" "idp"
            
    let _ = X.CreateSendAndRecieve "sp" "idp"
   
    let key = Console.Read ()
    0 // return an integer exit code
