module Serviceprovider

open SamlProtocol
open Crypto

val serviceprovider:  me:prin -> client:prin -> idp:prin -> unit 
let rec serviceprovider me client idp = 
 let req = ReceiveSaml client in
 match req with
  | Login (url) -> (*Create AuthnRequest and send back*)
    let authnReq = CreateAuthnRequestMessage me idp in
    assume(Log me authnReq) (*Protocol event*);
    let myprivk = CertStore.GetPrivateKey me in
    let sigSP = Sign me myprivk authnReq in
    let resp = AuthnRequestMessage me idp authnReq sigSP in 
    SendSaml client resp; (*2*)
    serviceprovider me client idp (*Start over*)

  | AuthResponseMessage (issuer, destination, encassertion) -> 
    let myprivk = CertStore.GetPrivateKey me in
    let assertion = DecryptAssertion me myprivk encassertion in
    match assertion with
    | SignedAssertion (token,sigIDP) ->
      let pubkissuer = CertStore.GetPublicKey idp in
      if VerifySignature idp pubkissuer token sigIDP
      then
        (assert(Log idp token);
        let resp = LoginResponse "You are now logged in" in
        SendSaml client resp) (*12*)
      else SendSaml client (DisplayError 403);(*12.1*)
      serviceprovider me client idp (*Start over*)
  
  | _ -> SendSaml client (DisplayError 400);(*2.1*)
        serviceprovider me client idp (*Start over*)