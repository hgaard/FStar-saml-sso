module Identityprovider
open Protocol

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val identityprovider: me:prin -> client:prin -> sp:prin -> pubkey sp -> unit
let identityprovider me client serviceprovider pubksp =
  (* Generate keypair *)
  let pubk, privk = keygen me in
  
  let authRequest = recieve client in (*3*)
  
  match authRequest with
  | SamlProtocolMessage (idp, message, sigSP, relay)->   

    if verify serviceprovider pubksp message sigSP
    then ()
     ( (*assert (Log serviceprovider message);*)
        let challenge = createChallenge client in
    
        let challengeMessage = ChallengeMessage challenge in
        send client challengeMessage; (*4*)
        let credentials = recieve client in (*5*)
        match credentials with
          | Credentials(user, password, challenge') -> 
  
          (*Check credentials and challenge*)
  
          let samlresponse = createSamlResponse me serviceprovider Success in
          let sigIDP = sign me privk samlresponse in 
          let response = SamlProtocolMessage serviceprovider samlresponse sigIDP relay in
          send client response(*6*)
  
        | _ -> send client (Failed (400)))(*6.3*)
    else send client (Failed (400))
  
   | _ -> 
     let samlresponse = createSamlResponse me serviceprovider Requester in
     let sigIDP = sign me privk samlresponse in
     let response = SamlProtocolMessage serviceprovider samlresponse sigIDP "" in
     send client response (*4.1*)
    

end (*Identityprovider*)
