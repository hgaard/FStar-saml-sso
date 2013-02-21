module Identityprovider

open SamlProtocol
open Crypto

val identityprovider: me:prin -> pubkey me -> privkey me 
                      -> client:prin -> sp:prin -> pubkey sp
                      -> unit
let identityprovider me pubk privk client serviceprovider pubksp =
	let req = ReceiveSaml client in (*3 & 11*)
	match req with
	| AuthnRequest (issuer, destination, message, sigSP) ->
    if (VerifySignature serviceprovider pubksp message sigSP) then
      (assert (Log serviceprovider message);
      let challenge = GenerateNonce me in
      let resp = UserCredRequest challenge in
      SendSaml client resp;
      identityprovider me pubk privk client serviceprovider pubksp (*Start over*))
    else
      SendSaml client (Failed 400)(*8.1*)
  | _ -> SendSaml client (Failed 400);(*8.1*)
        identityprovider me pubk privk client serviceprovider pubksp (*Start over*)

