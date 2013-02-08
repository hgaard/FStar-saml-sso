module SamlProtocol

(*open Network*)

type assertiontoken = string (*Add refinements*)
type signedtoken = string (*Add refinements*)
type id = string
type endpoint = string

type Assertion =
  | UnsignedAssertion: assertiontoken -> Assertion

type SamlMessage =
  | Login: uri -> SamlMessage
  | AuthnRequest: issuer:prin -> id -> destination:endpoint -> dsig -> SamlMessage
  | ResponseMessage: issuer:prin -> id -> inresto:id -> destination:endpoint -> Assertion -> SamlMessage
  | LoginResponse: string -> SamlMessage
  | Failed: int -> SamlMessage

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus

(*Verification*)
type Log :: prin => samlmessage => E
type Log2 :: string => string => nonce => E

val SendSaml: prin -> SamlMessage -> unit
val RecieveSaml: prin -> SamlMessage 

val IssuerAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:id -> assertiontoken
val AddSignatureToAssertion: assertiontoken -> dsig -> signedtoken