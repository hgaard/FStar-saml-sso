// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.
open SamlProtocol

[<EntryPoint>]
let main argv = 
    let sp = new serviceProvider()
    let req = sp.Get "resource"
    printfn "Authn request recieved with ID:%s" req.id
    
    let idp = new identityProvider()
    let challenge = idp.Authenticate req
    printfn "Request for user credentials recieved fron IDP:%s" challenge

    let authResponse = idp.Authenticate("User","pass",challenge)
    printfn "AuthResponse recieved fron IDP with id:%s" authResponse.id

    let res = sp.Post(authResponse,"rs")
    printfn "resource from service provider:%s" res

    0 // return an integer exit code
     