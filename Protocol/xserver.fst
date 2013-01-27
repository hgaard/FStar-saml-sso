module Serviceprovider

open Lib
open ContentServer
open Protocol
open Saml
open Crypto
open Network

val hasValidSession: list string -> bool
let hasValidSession cookies = 
  (* Find AuthenticationKey cookie and validate *)
  let ak = getStrInList cookies "AuthenticationKey" in
  if isEmptyStr ak then false 
  else true (*Should be validated somehow*)

val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      browser:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk browser idp pubkidp = 
  let reqRes = Recieve browser in (*1*) (*7*)
  match reqRes with
  | Get (prin,uri,params,cookies) -> 

    (*Check for valid session*)
    if hasValidSession cookies then
      let resp = Response 200 (getContent uri) [] in
      Send resp (*8*)
    else (*Create AuthnRequest and send (via client) to idp*)
      (let authnReq = CreateAuthnRequest me idp in 
      assume(Log me authnReq) (*Protocol event*);
      let sigSP = Sign me privk authnReq in
      let resp = CreateRedirectResponse idp authnReq sigSP uri in 
      Send resp (*2*))

  | Post (sp, params, cookies) -> 
      let msg = getStrInList params "SamlMessage" in
      let sigIDP = getStrInList params "Signature" in
      if VerifySignature idp pubkidp msg sigIDP
      then
        (assert(Log idp msg);
          let ak = Concatkv "AuthenticationKey" (GenerateNonce sp) in
          let resp = Response 200 (getContent "Loggedin") [ak] in
          Send resp) (*8*)
      else Send (Response 403 (getErrorPage 403) [])(*8.1*)
  
  | _ -> Send (Response 400 (getErrorPage 400) [])
