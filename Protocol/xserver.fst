module Serviceprovider

open Lib
open SessionManager
open ContentServer
open Protocol
open Saml
open Crypto
open Network

val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      browser:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk browser idp pubkidp = 
  let req = Recieve browser in (*1*) (*7*)
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
