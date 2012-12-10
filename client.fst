module CLIENT
open PROTOCOL

(*
- Protocol events
- Add assumtions
- Add asserts
  *)

val client: sp:prin -> req:request -> user:string -> password:string -> unit
let client sp req user password = 
    let _ = send sp req in(*1*)
      let res = recieve sp in(*2*)
        match res with
        | SamlAuthnRequestRedirect (uri, idp, authnRequest, sigSP, relayState) -> 
          let samlAuthnReq = SamlAuthnRequest uri idp authnRequest sigSP relayState in
            send idp samlAuthnReq (*3*)
            let chal = recieve idp in (*4*)
              let authUserReq = AutnenticateUser idp user password chal (*6*)


        | _ -> ()
        


(*let client sp req user password = 
    let _ = send sp req in(*1*)
      let (idp, authnRequest, sigSP, relayState) = recievehttpRedirect sp in(*2*)
        sendAuthnRequest idp authnRequest sigSP relayState;(*3*)
        let challenge = recieveAutenticationRequestChallenge idp in(*4*)
          sendAutenticationRequest idp user password challenge; (*5*)
          let (sp', samlResponse, sigIDP, relayState') = recievehttpRedirect idp in(*6*)
            sendAuthentication sp' samlResponse relayState'; (*7*)
            let res = recieveHttpResponse sp' in (*8*)
            ()
end CLIENT*)