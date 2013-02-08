module Serviceprovider

open SamlProtocol
open Crypto



val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      client:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk client idp pubkidp = 
 let req = RecieveSaml client in
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





(*  let req = Recieve client in (*1*) (*7*)
  match req with
  | Get (uri,params,cookies) -> 

    (*Check for valid session*)
    if hasValidSession cookies then
      let resp = Response (getContent uri) [] in
      Send resp (*8*)
    else (*Create AuthnRequest and send (via client) to idp*)
      (let authnReq = CreateAuthnRequest me idp in 
      assume(Log me authnReq) (*Protocol event*);
      let sigSP = Sign me privk authnReq in
      let resp = CreateRedirectResponse idp authnReq sigSP in 
      Send resp (*2*))

  | Post (uri, qparams, fparams, cookies) -> 
      let msg = getStrInTupleList fparams "SamlMessage" in
      let sigIDP = getStrInTupleList fparams "Signature" in
      if VerifySignature idp pubkidp msg sigIDP
      then
        (assert(Log idp msg);
          let ak =  GenerateNonce me in
          let resp = Response (getContent "Logged-in") [("AuthenticationKey", ak)] in
          Send resp) (*8*)
      else Send (ErrorResponse 403 (getErrorPage 403) [])(*8.1*)
  
  | _ -> Send (ErrorResponse 400 (getErrorPage 400) [])
*)