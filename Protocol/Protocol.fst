module Protocol

type prin = string
type uri = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig = string
type samlmessage = string
type nonce = string (*How to secure uniqueness? P-kind?*)
type assertion = string (*Shhould be ecrypted*)

(*Verification*)
type Log :: prin => samlmessage => E
type Log2 :: string => string => nonce => E