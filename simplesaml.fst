module PROTOCOL

type prin = string
type samlmessage = string
type response
type dsig
type resource

type Says :: prin => bytes => E

val requestResource: prin -> unit (* http GET *)
val recievehttpRedirect: prin -> prin


end (*PROTOCOL*)

module CLIENT
open PROTOCOL

val client: prin -> user:string -> password:string -> unit
let client sp user password = 
    
    let idp = recievehttpRedirect sp in requestResource sp
    (*sendAuthnRequest idp authnRequest sigSP relayState (*3*)
    let challenge = retrieveAutenticationRequestChallenge idp (*4*)
    sendAutenticationRequest idp user password challenge (*5*)
    let (sp, samlResponse, sigIDP, relayState') = recievehttpRedirect idp (*6*)
    sendAuthentication sp, samlResponse, relayState' (*7*)
    let res = revcievehttpResponse sp
    ()*)
end (*CLIENT*)


module SERVICEPROVIDER
open PROTOCOL
open CLIENT
end (* SERVICEPROVIDER *)

module IDENTITYPROVIDER
open PROTOCOL


end