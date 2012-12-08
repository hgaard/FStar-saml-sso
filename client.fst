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