module Browser
open Protocol

val browser: sp:prin -> res:uri -> user:string -> password:string -> unit
let browser sp resource user password = 
    print_string "Entering Client (sending request)";
    let req = HttpGet resource in
    let _ = Send sp req in(*1*)
      let res = Recieve sp in(*2*)
        match res with
        | SamlProtocolMessage (idp, authnRequest, sigSP) -> 
          let samlAuthnReq = SamlProtocolMessage idp authnRequest sigSP in
          Send idp samlAuthnReq;
          let chal = Recieve idp in (*4*)
          match chal with
          | ChallengeMessage (challenge) -> 
            let authUserReq = Credentials user password challenge in (*5*)
            Send idp authUserReq; (*5*)
            let idpResp = Recieve idp in
            match idpResp with
            | SamlProtocolMessage (sp', samlResponse, sigIDP) -> 
              let samlResponseRequest =  SamlProtocolMessage sp' samlResponse sigIDP in (*7*)
              Send sp' samlResponseRequest;
              Recieve sp'; () (*8*)
            | _ -> idpResp; () (*Report response back to caller*)
          | _ -> chal; () (*Report response back to caller*)
        | _ -> res; () (*Report response back to caller*)