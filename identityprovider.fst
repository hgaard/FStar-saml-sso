module IDENTITYPROVIDER
open PROTOCOL

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val identityprovider: me:prin -> client:prin -> sp:prin -> unit
let identityprovider me client serviceprovider =
  let (authnReq, sigSP, relay) = recieveAutenticationRequest client in (*3*)
    let challenge = createChallenge client in
      sendAutenticationChallenge client challenge; (*4*)
      let (user,password, challenge') = recieveAutenticationCredentials client in (*5*)
        let (samlResponse, sigIDP) = createSamlResponse me serviceprovider in 
          sendhttpRedirect client serviceprovider samlResponse sigIDP; (*6*)
          ()

end (*IDENTITYPROVIDER*)
