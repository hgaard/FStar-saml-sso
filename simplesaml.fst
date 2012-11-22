module PROTOCOL

type prin = string
type samlmessage = 
    | request : samlmessage
    | response : samlmessage

type dsig
type status =
    | Success : status
    | Respoder : status
    | Requester : status

type Says :: prin => bytes => E

val requestResource: prin ->  unit (* http GET *)
val recievehttpRedirect: prin -> prin
val retrieveAutenticationRequestChallenge: prin -> string


end (*PROTOCOL*)

module CLIENT
open PROTOCOL

val client: prin -> user:string -> password:string -> unit
let client sp user password  = 
    requestResource sp resource in assume(sp = sp)
    let (idp, authnRequest, sigSP, relayState) = recievehttpRedirect sp 

    
end (*CLIENT*)

