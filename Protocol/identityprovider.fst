module Identityprovider
open Protocol

val identityprovider: me:prin -> pubkey me -> privkey me ->
                      client:prin -> sp:prin -> pubkey sp -> unit
let identityprovider me pubk privk client serviceprovider pubksp =
	
  let authRequest = recieve client in (*3*)
	match authRequest with
	| SamlProtocolMessage (idp, message, sigSP, relay)->  

    if verify serviceprovider pubksp message sigSP
    then
     ( (*assert (Log serviceprovider message);*)
        let challenge = createChallenge client in
    
        let challengeMessage = ChallengeMessage challenge in
        send client challengeMessage; (*4*)
        let credentials = recieve client in (*5*)
        match credentials with
          | Credentials(user, password, challenge') -> 
  
          (*Check credentials and challenge*)
  
          let samlresponse = createSamlResponse me serviceprovider Success in
          assume(Log me samlresponse);
          let sigIDP = sign me privk samlresponse in 
          let response = SamlProtocolMessage serviceprovider samlresponse sigIDP relay in
          send client response(*6*)
  
        | _ -> send client (Failed (400)))(*6.3*)
    else send client (Failed (400))
  | _ -> 
     let samlresponse = createSamlResponse me serviceprovider Requester in
     assume(Log me samlresponse);
     let sigIDP = sign me privk samlresponse in
     let response = SamlProtocolMessage serviceprovider samlresponse sigIDP "" in
     send client response (*4.1*)
