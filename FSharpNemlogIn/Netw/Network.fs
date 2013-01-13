module Network
open System.Diagnostics.Contracts

let fo param = 
    param |> List.fold (fun r s -> r+ ";" + s) ""
    

let SendX (prin:string) (methodId:string)  (query:string) (cookies:string) (msg:string) = 
//    let q = fo query
//    let c = fo cookies
    printfn "Message sent to: %s on %s with payload: %s and query:%s and Cookies:%s" prin methodId msg query cookies
    Protocol.Success() :> Protocol.SamlStatus

let RecieveX (prin:string) : (string*string)=
    ("Sending response:" + "I have recieved your request and this is my response" + " to: " +  prin, "cookie")
    

