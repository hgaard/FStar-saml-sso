module Saml

open Protocol
open Network

type Assertion = string
type AuthnRequest = string
type Response = string

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus

type Samlmessage = 
  | SamlAuthnRequestMessage: AuthnRequest -> dsig -> Samlmessage
  | SamlResponseMessage: Response -> Samlmessage
  | SamlStatusResponseMessage: SamlStatus -> Samlmessage


(*Abstract saml methods*)
val CreateAuthnRequest: issuer:prin -> destination:prin -> AuthnRequest
val IssueSamlAssertion: idp:prin -> privkey idp -> AuthnRequest-> Subject ->  sp:prin -> pubkey sp ->  Assertion
val CreateSamlResponse: prin -> AuthnRequest -> Assertion -> Samlmessage
val CreateSamlFailedResponse: issuer:prin -> destination:prin -> SamlStatus -> Samlmessage

(*Helper functions*)
val IsAuthnRequest: list (string*string) -> bool
val GetSamlMessage: list (string*string) -> (AuthnRequest * dsig)
val CreateChallengeMessage: prin -> nonce -> Response

val CreateRedirectResponse: prin -> Samlmessage -> HttpMessage
let CreateRedirectResponse prin msg =
      (*Base64 encode all params*)
      match msg with 
      | SamlAuthnRequestMessage (authReq, sig) ->
      let params = [("samlmessage",authReq); ("signature",sig)] in
      let cookies = [] in
      let resp = Redirect prin prin params cookies in 
      resp



(*Saml functions
extern reference Saml {language="F#";
            dll="Saml";
            namespace="";
            classname="Saml"}

extern Saml val CreateAuthnRequest: issuer:prin -> destination:prin -> samlmessage
extern Saml val CreateSamlAssertion: user:string -> issuer:prin -> destination:prin -> assertion
extern Saml val CreateSamlResponse: issuer:prin -> destination:prin -> assertion -> samlmessage
extern Saml val CreateSamlFailedResponse: issuer:prin -> destination:prin -> SamlStatus -> samlmessage
*)