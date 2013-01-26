module Crypto

open Protocol

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

(*val Encrypt: ...

val Decrypt: ...*)

(*Crypto functions*)
extern reference Crypto {language="F#";
            dll="Crypto";
            namespace="";
            classname="Crypto"}

extern Crypto val KeyGenExt: p:prin
          -> (pubkey p * privkey p)