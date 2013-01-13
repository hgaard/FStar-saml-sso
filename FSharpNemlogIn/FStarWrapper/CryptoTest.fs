module CryptoTest

open System.Security.Cryptography
open Network
open Crypto

let TestCrypto = 
    let spid = "https://saml.serviceprovicer.org"
    let idpid = "https://saml.identityprovicer.org"
    let (privk, pubk) = KeyGen spid
    
    let msg = X.GetReq spid idpid
    printfn "Message to sign %s" msg

    let signature = SignMessage spid privk msg
    printfn "Message signature: %s" signature
    
    printfn "Verifying signature"
    let isValid = ValidateMessage "me" pubk msg signature
    if isValid then
        printfn "Signature: %s is valid" signature
    else
        printfn "Invalid Signature: %s" signature

