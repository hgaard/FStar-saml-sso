module PROTOCOL

type prin
type samlmessage
type response
type dsig
type resource
type uri

val createAuthnRequest: prin -> prin -> (samlmessage * dsig)
val createChallenge: prin -> string
val createSamlResponse: prin -> prin -> (samlmessage * dsig)

val recieveHttpRequest: prin -> uri
val recieveHttpResponse: prin -> resource
val recieveAutenticationRequestChallenge: prin -> string
val recieveAutenticationRequest: prin -> (string * string * string)
val recieveAutenticationCredentials: prin -> (samlmessage * dsig * string)
val recievehttpRedirect: prin -> (prin * samlmessage * dsig * string)

val sendRequestResource: prin -> unit
val sendhttpRedirect: prin -> prin -> samlmessage -> dsig -> string -> unit
val sendAuthnRequest: prin -> samlmessage -> dsig -> string -> unit
val sendAutenticationRequest: prin -> string -> string -> string -> unit
val sendAutenticationChallenge: prin -> string -> unit
val sendAuthentication: prin -> samlmessage -> string -> unit
val sendResource: prin -> resource

end (*PROTOCOL*)

module CLIENT
open PROTOCOL

(*
- Protocol events
- Add assumtions
- Add asserts
  *)

val client: me:prin -> user:string -> password:string -> unit
let client sp user password = 
    let _ = sendRequestResource sp in(*1*)
      let (idp, authnRequest, sigSP, relayState) = recievehttpRedirect sp in(*2*)
        sendAuthnRequest idp authnRequest sigSP relayState;(*3*)
        let challenge = recieveAutenticationRequestChallenge idp in(*4*)
          sendAutenticationRequest idp user password challenge; (*5*)
          let (sp', samlResponse, sigIDP, relayState') = recievehttpRedirect idp in(*6*)
            sendAuthentication sp' samlResponse relayState'; (*7*)
            let res = recieveHttpResponse sp' in (*8*)
            ()
end (*CLIENT*)


module SERVICEPROVIDER
open PROTOCOL

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val serviceprovider: me:prin -> client:prin -> idp:prin -> unit 
let serviceprovider me client idp = 
  let reqUri = recieveHttpRequest client in (*1*)
    let (authnReq, sigSP)  = createAuthnRequest me idp in 
      sendAuthnRequest client authnReq sigSP "relay"; (*2*)
      let (sp, samlResponse, sigIDP, relay) = recievehttpRedirect client in (*7*)
        sendResource client; (*8*)
        ()

end (* SERVICEPROVIDER *)

module IDENTITYPROVIDER
open PROTOCOL

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val identityprovider: me:prin -> client:prin -> sp:prin -> unit
let identityprovider me client serviceprovider =
  let (authnReq, sigSP, relay) = recieveAutenticationRequest client in (*3*)
    let challenge = createChallenge client in
      sendAutenticationChallenge client challenge; (*4*)
      let (user,password, challenge') = recieveAutenticationCredentials client in (*5*)
        let (samlResponse, sigIDP) = createSamlResponse me serviceprovider in 
          sendhttpRedirect client serviceprovider samlResponse sigIDP; (*6*)
          ()

end (*IDENTITYPROVIDER*)