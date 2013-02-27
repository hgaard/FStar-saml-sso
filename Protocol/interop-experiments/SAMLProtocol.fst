module Protocol

type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig = string
type resource = bytes
type uri = string
type nonce = string 
type samlmessage = string
type assertion = string

type message =
  | HttpGet: uri -> message
  | SamlProtocolMessage: prin -> samlmessage -> dsig -> message
  | Credentials: string -> string -> nonce -> message
  | ChallengeMessage: nonce -> message
  | Resource: uri -> message
  | Failed: int -> message

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus

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

