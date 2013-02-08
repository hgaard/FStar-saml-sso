module Identityprovider

open Lib
open SessionManager
open Protocol
open Saml
open Crypto
open Network
open ContentServer

(*TODO: 
  - Make it compile
  - Encrypt/decrypt
  - Ensure it follows model*)

let CheckSessionAndBuildResponse me privk authReq browser serviceprovider pubksp cookies = 
        if hasValidSession cookies then
          let subject = GetSessionSubject cookies in
          let assertion = IssueSamlAssertion me privk authReq subject serviceprovider pubksp in
          let resp = CreateSamlResponse me authReq assertion in
          resp

        else
          let challenge = GenerateNonce me in
          let challengeMessage = CreateChallengeMessage me challenge in
          challengeMessage (*4*)

let HandleGetResponse msg me privk browser serviceprovider pubksp cookies =
match msg with 
    | SamlAuthnRequestMessage (authReq, sigSP) ->
      if (VerifySignature serviceprovider pubksp authReq sigSP) then
        (assert (Log serviceprovider authReq);
        CheckSessionAndBuildResponse me privk authReq browser serviceprovider pubksp cookies)
       
      else ErrorResponse 403 (getErrorPage 403) [] (*4.1*) (*TODO*)
    | _ -> ErrorResponse 403 (getErrorPage 403) [] (*4.1*) (*TODO*)

let HandlePostResponse = ()
    (*Check credentials and challenge
    if AuthenticateUser user password challenge'
    then
      (assert (Log2 user password challenge');

      let samlresponse = CreateSamlResponse me serviceprovider Success in
      assume(Log me samlresponse);
      let sigIDP = Sign me privk samlresponse in 
      let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
      Send browser response(*6*))
    else Send browser (Failed (400))(*6.3*)*)


val identityprovider: me:prin -> pubkey me -> privkey me 
                      -> browser:prin -> sp:prin -> pubkey sp
                      -> unit
let identityprovider me pubk privk browser serviceprovider pubksp =
	let req = Recieve browser in (*3 & 11*)
	match req with
	| Get (uri, params, cookies) ->
    let msg = GetSamlMessage params in
    let resp = HandleGetResponse msg me pubk privk browser serviceprovider pubksp in
    Send browser resp

  | Post (uri, qparams, fparams, cookies) -> 
    let params = append qparams fparams in
    let msg = GetSamlMessage params in
    let resp = HandlePostResponse msg in
    Send browser resp    

  | _ -> Send (ErrorResponse 400 (getErrorPage 400) [])

