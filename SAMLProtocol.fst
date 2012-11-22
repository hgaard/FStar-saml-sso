module PROTOCOL

type prin = string
type samlmessage = string
type response
type dsig
type resource

val requestResource: prin -> unit (* http GET *)
val revcievehttpResponse: prin -> resource
val sendhttpRedirect: prin -> bytes -> dsig -> string -> unit
val recievehttpRedirect: prin -> (prin * samlmessage * dsig * string)
val sendAuthnRequest: prin -> samlmessage -> dsig -> samlmessage -> unit
val retrieveAutenticationRequestChallenge: prin -> string
val sendAutenticationRequest: prin -> string -> string -> string -> unit
val sendAuthentication: prin -> samlmessage -> string -> unit

end (*PROTOCOL*)

module CLIENT
open PROTOCOL

val client: prin -> user:string -> password:string -> unit
let client sp user password = 
    let sp = sp in requestResource sp (*1*)
    (*Insert protocol event*)
    let (idp, authnRequest, sigSP, relayState) = recievehttpRedirect sp (*2*)
    sendAuthnRequest idp authnRequest sigSP relayState (*3*)
    let challenge = retrieveAutenticationRequestChallenge idp (*4*)
    sendAutenticationRequest idp user password challenge (*5*)
    let (sp, samlResponse, sigIDP, relayState') = recievehttpRedirect idp (*6*)
    sendAuthentication sp, samlResponse, relayState' (*7*)
    let res = revcievehttpResponse sp
    ()
end (*CLIENT*)


module SERVICEPROVIDER
open PROTOCOL
open CLIENT

(*  val id : string
  val issueInstant : string
  val destination : string
  val issuer : string
  val condition : string 
  *)
end (* SERVICEPROVIDER *)

module IDENTITYPROVIDER
open PROTOCOL


end