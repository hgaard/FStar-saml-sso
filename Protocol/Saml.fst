module Saml

open Protocol
open Network


type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus

(*Saml functions*)
extern reference Saml {language="F#";
            dll="Saml";
            namespace="";
            classname="Saml"}

extern Saml val CreateAuthnRequest: issuer:prin -> destination:prin -> samlmessage
extern Saml val CreateChallenge: prin -> nonce
extern Saml val CreateSamlAssertion: user:string -> issuer:prin -> destination:prin -> assertion
extern Saml val CreateSamlResponse: issuer:prin -> destination:prin -> assertion -> samlmessage
extern Saml val CreateSamlFailedResponse: issuer:prin -> destination:prin -> SamlStatus -> samlmessage

val CreateRedirectResponse: prin -> samlmessage -> dsig -> string -> HttpMessage
let CreateRedirectResponse prin msg sig relay =
      (*Base64 encode all params*)
      let params = [msg; sig; relay] in
      let cookies = [relay] in
      let resp = Redirect prin prin params cookies in 
      resp