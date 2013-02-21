module Serviceprovider

open SamlProtocol
open Crypto

val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      client:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk client idp pubkidp = 
 let req = ReceiveSaml client in
 match req with
  | Login (url) -> (*Create AuthnRequest and send back*)
    let authnReq = CreateAuthnRequestMessage me idp in
    assume(Log me authnReq) (*Protocol event*);
    let sigSP = Sign me privk authnReq in
    let resp = AuthnRequest me idp authnReq sigSP in 
    SendSaml client resp; (*2*)
    serviceprovider me pubk privk client idp pubkidp (*Start over*)

  | AuthResponseMessage (issuer, destination, assertion) -> 
    match assertion with
    | SignedAssertion (token,sigIDP) ->
      if VerifySignature idp pubkidp token sigIDP
      then
        (assert(Log idp token);
        let resp = LoginResponse "You are now logged in" in
        SendSaml client resp) (*8*)
      else SendSaml client (Failed 403);(*8.1*)
      serviceprovider me pubk privk client idp pubkidp (*Start over*)
  | _ -> SendSaml client (Failed 400);(*8.1*)
        serviceprovider me pubk privk client idp pubkidp (*Start over*)