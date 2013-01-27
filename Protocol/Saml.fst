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
extern Saml val CreateSamlAssertion: user:string -> issuer:prin -> destination:prin -> assertion
extern Saml val CreateSamlResponse: issuer:prin -> destination:prin -> assertion -> samlmessage
extern Saml val CreateSamlFailedResponse: issuer:prin -> destination:prin -> SamlStatus -> samlmessage

val CreateRedirectResponse: prin -> samlmessage -> dsig -> HttpMessage
let CreateRedirectResponse prin msg sig =
      (*Base64 encode all params*)
      let params = [("samlmessage",msg); ("signature",sig)] in
      let cookies = [] in
      let resp = Redirect prin prin params cookies in 
      resp