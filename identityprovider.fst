module Identityprovider
open Protocol

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val identityprovider: me:prin -> client:prin -> sp:prin -> unit
let identityprovider me client serviceprovider =
	let authRequest = recieve client in (*3*)
	match authRequest with
	| SamlProtocolMessage (idp, message, sigSP, relay)-> 
    (*assert (Log serviceprovider message);*)
    let challenge = CreateChallenge client in
    let challengeMessage = Challenge challenge in
    send client challengeMessage; (*4*)
    let credentials = recieve client in (*5*)
      match credentials with
      | Credentials(user, password, challenge') -> 
        (*Check credentials and challenge*)
        let (samlresponse, sigIDP) = CreateSamlResponse me serviceprovider Success in
        let response = SamlProtocolMessage serviceprovider samlresponse sigIDP relay in
        send client response(*6*)
      | _ -> send client (Failed (400))(*6.3*)
	| _ -> 
    let (samlresponse, sigIDP) = CreateSamlResponse me serviceprovider Requester in
    let response = SamlProtocolMessage serviceprovider samlresponse sigIDP relay in
    send client response(*4.1*)
  ()

end (*Identityprovider*)
