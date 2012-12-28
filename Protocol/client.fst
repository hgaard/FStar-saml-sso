module Client
open Protocol

(*
- Protocol events
- Add assumtions
- Add asserts
  *)

val client: sp:prin -> req:message -> user:string -> password:string -> message
let client sp req user password = 
    print_string "Entering Client (sending request)";
    let _ = send sp req in(*1*)
      let res = recieve sp in(*2*)
        match res with
        | SamlProtocolMessage (idp, authnRequest, sigSP, relayState) -> 
          let samlAuthnReq = SamlProtocolMessage idp authnRequest sigSP relayState in
          send idp samlAuthnReq;
          let chal = recieve idp in (*4*)
          match chal with
          | ChallengeMessage (challenge) -> 
            let authUserReq = Credentials user password challenge in (*5*)
            send idp authUserReq; (*5*)
            let idpResp = recieve idp in
            match idpResp with
            | SamlProtocolMessage (sp', samlResponse, sigIDP, relayState') -> 
              let samlResponseRequest =  SamlProtocolMessage sp' samlResponse sigIDP relayState' in (*7*)
              send sp' samlResponseRequest;
              recieve sp' (*8*)
            | _ -> idpResp (*Report response back to caller*)
          | _ -> chal (*Report response back to caller*)
        | _ -> res (*Report response back to caller*)

end (*Client*)