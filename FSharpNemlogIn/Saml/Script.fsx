// Learn more about F# at http://fsharp.net. See the 'F# Tutorial' project
// for more guidance on F# programming.

#load "Saml.fs"
open Saml

let authnReq = CreateAuthnRequest "mSp" "someIdp"
printfn "%s"authnReq

let challenge = CreateChallenge "prin"
printfn "%s" challenge

let resp = CreateSamlResponse "idp" "sp" "Success"
printfn "%s" resp

// Define your library scripting code here

