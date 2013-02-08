module Crypto

open Protocol


val Keygen:  p:prin
          -> (pubkey p * privkey p)
(*let Keygen prin =
    let (pk,sk) = KeyGenExt prin in
    (PublicKey pk,privkey sk)*)

val Sign:  p:prin
        -> privkey p
        -> msg:string{Log p msg}
        -> dsig

val VerifySignature: p:prin
        -> pubkey p 
        -> msg:string
        -> dsig
        -> b:bool{b=true ==> Log p msg}

val AuthenticateUser: user:string
        -> password:string
        -> challenge:SessionKey 
        -> b:bool{b=true ==> Log2 user password challenge}

val GenerateNonce: prin -> nonce (*Add refinement to ensure unqueness*)
(*val Encrypt: ...

val Decrypt: ...*)

(*Crypto functions*)
extern reference Crypto {language="F#";
            dll="Crypto";
            namespace="";
            classname="Crypto"}

extern Crypto val KeyGenExt: p:prin
          -> (string * string)

