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
    let challenge = createChallenge client in
    let challengeMessage = Challenge challenge in
    send client challengeMessage; (*4*)
    let credentials = recieve client in (*5*)
      match credentials with
      | Credentials(user, password, challenge') -> 
        let (samlresponse, sigIDP) = createSamlResponse me serviceprovider in
        let response = SamlProtocolMessage serviceprovider samlresponse sigIDP relay in
        send client response(*6*)
      | _ -> ()
	| _ -> ()
()

end (*Identityprovider*)
