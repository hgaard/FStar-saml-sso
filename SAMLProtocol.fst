module PROTOCOL

type uri = string
type samlmessage = string
type response
type dsig
type resource

val requestResource: uri -> unit (* http GET *)
val revcievehttpResponse: uri -> resource
val sendhttpRedirect: uri -> bytes -> dsig -> string -> unit
val recievehttpRedirect: uri -> (uri * samlmessage * dsig * string)
val sendAuthnRequest: uri -> samlmessage -> dsig -> samlmessage -> unit
val retrieveAutenticationRequestChallenge: uri -> string
val sendAutenticationRequest: uri -> string -> string -> string -> unit
val sendAuthentication: uri -> samlmessage -> string -> unit

end (*PROTOCOL*)

module CLIENT
open PROTOCOL

val client: user:string -> password:string -> unit
let client user password = 
    requestResource "serviceproviderUrl" (*1*)
    let (idp, authnRequest, sigSP, relayState) = recievehttpRedirect "serviceproviderUrl" (*2*)
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