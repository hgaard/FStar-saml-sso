module Identityprovider
open Protocol

val identityprovider: me:prin -> pubkey me -> privkey me 
                      -> browser:prin -> sp:prin -> pubkey sp
                      -> unit
let identityprovider me pubk privk browser serviceprovider pubksp =
	
  let samlreq = Recieve browser in (*3*)
	match samlreq with
	| SamlProtocolMessage (idp, msg, sigSP)->  

    if VerifySignature serviceprovider pubksp msg sigSP
    then
     (assert (Log serviceprovider msg);
      let challenge = CreateChallenge browser in
  
      let challengeMessage = ChallengeMessage challenge in
      Send browser challengeMessage (*4*))
     else Send browser (Failed (400))(*4.1*)
     
  | Credentials(user, password, challenge') -> 

    (*Check credentials and challenge*)
    if AuthenticateUser user password challenge'
    then
      (assert (Log2 user password challenge');

      let samlresponse = CreateSamlResponse me serviceprovider Success in
      assume(Log me samlresponse);
      let sigIDP = Sign me privk samlresponse in 
      let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
      Send browser response(*6*))
    else Send browser (Failed (400))(*6.3*)

  | _ -> 
     let samlresponse = CreateSamlResponse me serviceprovider Requester in
     assume(Log me samlresponse);
     let sigIDP = Sign me privk samlresponse in
     let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
     Send browser response (*4.1*)
