namespace SamlProtocol
open System

type authnRequest() =
    member this.id : string = Guid.NewGuid().ToString()
//  val issueInstant : string
//  val destination : string
//  val issuer : string
//  val condition : string 

type response(inResponse:string, status:string) =
   member this.id : string = Guid.NewGuid().ToString()
//   val issueInstant : string
   member this.inResponseTo : string = inResponse
//   val destination : string
//   val issuer : string
   member this.status : string = status

type identityProvider() =
    member this.Authenticate( authnRequest : authnRequest) = 
        "C"
    member this.Authenticate(user : string, password:string, challenge:string) =
        new response(Guid.NewGuid().ToString(),"Success")

type serviceProvider() =
    member this.Get resource = 
        new authnRequest()
    member this.Post (message : response, relayState : string) = 
        let status = message.status
        match status with
            | "Success" -> "Hello"
            | _ -> "fail"

type client() =
    member this.Login(sp:serviceProvider) =
       sp.Get "myPage"
