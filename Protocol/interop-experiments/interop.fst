module Interop

open Protocol

(*Crypto functions*)
extern reference Crypto {language="F#";
            dll="RuntimeExtention";
            namespace="";
            classname="Crypto"}

extern Crypto val KeyGenExt: p:prin
          -> (pubkey p * privkey p)


(*Saml functions*)
extern reference Saml {language="F#";
            dll="RuntimeExtention";
            namespace="";
            classname="Saml"}

extern Saml val CreateAuthnRequest: issuer:prin -> destination:prin -> samlmessage
extern Saml val CreateChallenge: prin -> nonce
extern Saml val CreateSamlAssertion: user:string -> issuer:prin -> destination:prin -> assertion
extern Saml val CreateSamlResponse: issuer:prin -> destination:prin -> assertion -> samlmessage
extern Saml val CreateSamlFailedResponse: issuer:prin -> destination:prin -> SamlStatus -> samlmessage

type method = string
type queryparams = string
type cookies = string
type messagebody = string

extern reference Network {language="F#";
            dll="RuntimeExtention";
            namespace="";
            classname="Network"}
extern Network val SendX: prin -> message -> bool
extern Network val RecieveX: prin -> message