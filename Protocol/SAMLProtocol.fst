module Protocol

type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig = string
type resource = bytes
type uri = string
type nonce = string (*How to secure uniqueness? P-kind?*)
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

(*Verification*)
type Log :: prin => samlmessage => E
type Log2 :: string => string => nonce => E

(*Crypto functions*)
val Keygen:  p:prin
          -> (pubkey p * privkey p)


val Sign:  p:prin
        -> privkey p
        -> msg:samlmessage{Log p msg}
        -> dsig

val VerifySignature: p:prin
        -> pubkey p 
        -> msg:samlmessage
        -> dsig
        -> b:bool{b=true ==> Log p msg}

val AuthenticateUser: user:string
        -> password:string
        -> challenge:nonce
        -> b:bool{b=true ==> Log2 user password challenge}

val Send: prin -> message -> unit
val Recieve: prin -> message 

(*Crypto functions*)
extern reference Crypto {language="F#";
            dll="Crypto";
            namespace="";
            classname="Crypto"}

extern Crypto val KeyGenExt: p:prin
          -> (string * string)


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

