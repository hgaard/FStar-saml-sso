module Identityprovider

open Lib
open SessionManager
open Protocol
open Saml
open Crypto
open Network

val identityprovider: me:prin -> pubkey me -> privkey me 
                      -> browser:prin -> sp:prin -> pubkey sp
                      -> unit
let identityprovider me pubk privk browser serviceprovider pubksp =
	let req = Recieve browser in (*3 & 11*)
	match req with
	| Get (prin,uri,params,cookies) ->
    (*Verify sp signature*)
    let (msg, sigSP) = GetSamlMessage params in 
    if VerifySignature serviceprovider pubksp msg sigSP then
      (assert (Log serviceprovider msg);
      (*Check for valid session*) 

      if hasValidSession cookies then
        let token = GetSamlToken cookies in
        let resp = CreateSamlResponse me privk serviceprovider pubksp token in
        Send browser resp

      else
        (let challenge = CreateChallenge browser in
        let challengeMessage = ChallengeMessage challenge in
        Send browser challengeMessage (*4*)))
     
     else Send(ErrorResponse 403 (getErrorPage 403) [])(*4.1*) (*TODO*)

  | Post (sp, params, cookies) -> 
    (*Check credentials and challenge*)
    if AuthenticateUser user password challenge'
    then
      (assert (Log2 user password challenge');

      let samlresponse = CreateSamlResponse me serviceprovider Success in
      assume(Log me samlresponse);
      let sigIDP = Sign me privk samlresponse in 
      let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
      Send browser response(*6*))
    else Send browser (Failed (400))(*6.3*)

  | _ -> Send (ErrorResponse 400 (getErrorPage 400) [])

  | _ -> 
     let samlresponse = CreateSamlResponse me serviceprovider Requester in
     assume(Log me samlresponse);
     let sigIDP = Sign me privk samlresponse in
     let response = SamlProtocolMessage serviceprovider samlresponse sigIDP in
     Send browser response (*4.1*)
