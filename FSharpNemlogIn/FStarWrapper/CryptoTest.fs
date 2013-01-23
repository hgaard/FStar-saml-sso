module CryptoTest

open System.Security.Cryptography
open Network
open Crypto

//let TestCrypto = 
//    let spid = "https://saml.serviceprovicer.org"
//    let idpid = "https://saml.identityprovicer.org"
//    let (privk, pubk) = KeyGenExt spid
//    
//    let msg = X.GetReq spid idpid
//    printfn "Message to sign %s" msg
//
//    let signature = SignMessage spid privk.y_0_342 msg
//    printfn "Message signature: %s" signature
//    
//    printfn "Verifying signature"
//    let isValid = ValidateMessage "me" pubk.y_0_343 msg signature
//    if isValid then
//        printfn "Signature: %s is valid" signature
//    else
//        printfn "Invalid Signature: %s" signature

