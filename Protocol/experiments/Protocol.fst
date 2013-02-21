module Protocol

type prin = string
type uri = string
type pubkey :: prin => *
type privkey :: prin => *

(*type pubkey :: * => * =
	| PublicKey :  prin -> pubkey prin
*)

type dsig = string
type nonce = string
type SessionKey = nonce (*How to secure uniqueness? P-kind?*)
type Subject = string(*For now this is alias for user certificate*)
(*type assertion = string Shhould be ecrypted*)

(*Verification*)
type Log :: prin => string => E
type Log2 :: string => string => SessionKey => E