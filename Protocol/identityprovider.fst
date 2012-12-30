module Identityprovider
open Protocol

val identityprovider: me:prin -> pubkey me -> privkey me 
                      -> browser:prin -> sp:prin -> pubkey sp
                      -> unit
let identityprovider me pubk privk browser serviceprovider pubksp =
	
  let samlreq = recieve browser in (*3*)
	match samlreq with
	| SamlProtocolMessage (idp, msg, sigSP)->  

    if verify serviceprovider pubksp msg sigSP
    then
     (assert (Log serviceprovider msg);
        let challenge = createChallenge browser in
    
        let challengeMessage = ChallengeMessage challenge in
        send browser challengeMessage; (*4*)
        let credentials = recieve browser in (*5*)
        match credentials with
          | Credentials(user, password, challenge') -> 
  
          (*Check credentials and challenge*)
  
          let samlresponse = createSamlResponse me serviceprovider Success in
          assume(Log me samlresponse);
          let sigIDP = sign me privk samlresponse in 
          let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
          send browser response(*6*)
  
        | _ -> send browser (Failed (400)))(*6.3*)
    else send browser (Failed (400))
  | _ -> 
     let samlresponse = createSamlResponse me serviceprovider Requester in
     assume(Log me samlresponse);
     let sigIDP = sign me privk samlresponse in
     let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
     send browser response (*4.1*)
