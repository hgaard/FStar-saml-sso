namespace SamlProtocol
open System

type authnRequest(destination) =
    member this.id : string = Guid.NewGuid().ToString()
    member this.destination : string = destination

type response(inResponse:string, destination:string, status:string) =
   member this.id : string = Guid.NewGuid().ToString()
   member this.inResponseTo : string = inResponse
   member this.destination : string = destination
   member this.status : string = status

type identityProvider(name) =
    member this.Name = name
    
    member this.Authenticate( authnRequest : authnRequest) = 
        "C"
    member this.Authenticate(user : string, password:string, challenge:string) =
        new response(Guid.NewGuid().ToString(), this.Name, "Success")

type serviceProvider(name) =
    member this.Name = name
    member this.idp = "idp"
    member this.Get resource = 
        new authnRequest(this.idp)
    member this.Post (message : response, relayState : string) = 
        let status = message.status
        match status with
            | "Success" -> "Hello"
            | _ -> "fail"

type client() =
    member this.Login(sp:string) =
       let sp = new serviceProvider(sp)
       let resp = sp.Get "myPage"
       printfn "Authn request recieved with ID:%s" resp.id

       let idp = new identityProvider(resp.destination)
       let challenge = idp.Authenticate resp
       printfn "Request for user credentials recieved fron IDP:%s" challenge

       let authResponse = idp.Authenticate("User","pass",challenge)
       printfn "AuthResponse recieved fron IDP with id:%s" authResponse.id

       sp.Post(authResponse,"rs")