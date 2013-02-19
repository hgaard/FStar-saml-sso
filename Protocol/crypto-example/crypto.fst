module Crypto
type principal = string

extern reference Crypto { language = "F#";
                          dll="FSCrypto";
                          namespace="Microsoft.FStar";
                          classname="Crypto"}

extern Crypto val rsa_sign_impl: msg:string -> pk:string -> bytes
extern Crypto val rsa_verify_impl: msg:string -> ds:bytes-> sk:string -> bool
extern Crypto val ASSUME: 'P::E -> unit -> (u:bool{'P})

type Repr:: 'a::* => 'a => string => E
assume forall (s:string). Repr s s 

type dsig = bytes

type pubkey :: 'a::* => ('a => E) => principal => * = 
   | MkPubKey: 'a::* -> 'P::('a => E) -> p:principal -> string -> pubkey 'a 'P p
type privkey :: 'a::* => ('a => E) => principal => * = 
   | MkPrivKey: 'a::* -> 'P::('a => E) -> p:principal -> string -> privkey 'a 'P p

val rsa_sign:  'a::* -> 'P::('a => E)
             -> p:principal
             -> privkey 'a 'P p
             -> x:'a 
             -> b:string{Repr x b && 'P x}
             -> dsig
let rsa_sign p sk x b = match sk with
  | MkPrivKey p skb -> rsa_sign_impl b skb 

val rsa_verify:  'a::* -> 'P::('a => E) 
             -> p:principal
             -> pubkey 'a 'P p
             -> x:'a 
             -> b:string{Repr x b}
             -> s:dsig 
             -> r:bool{r=true => 'P x}
let rsa_verify p pk x b s =
  match pk with
    | MkPubKey p pkb ->
        let res = rsa_verify_impl b s pkb in
          if res
          then let _ = ASSUME<'P x> () in res
          else res

val rsa_keyleak:  'a::* -> 'P::('a => E) 
             -> p:principal
             -> x:privkey 'a 'P p{forall (x:'a). 'P x}
             -> bytes
let rsa_keyleak p x = match (x:privkey 'a 'P p) with 
  | MkPrivKey _ b -> FromUnicodeString b


type AliceSays :: string => E
let alice = "Alice"
assume (AliceSays "hello")

;; 


let pk = "<RSAKeyValue><Modulus>kUWXmVPrxaQBAE+hxwzlzo/+hOTL60RIa2O+Ud0vnUUTB0OO+znVakY2dXnW/hqMa7cx49GCUFUx7iTv4cFYHPtAzFecyrbIzwLBdhbcATj2qpRVsrSoBtVRxEAqiktil5IhtCk7usy85HYDxNbVw/HWHvQRTd6cuYnKb4KNU1E=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>" in
let sk = "<RSAKeyValue><Modulus>kUWXmVPrxaQBAE+hxwzlzo/+hOTL60RIa2O+Ud0vnUUTB0OO+znVakY2dXnW/hqMa7cx49GCUFUx7iTv4cFYHPtAzFecyrbIzwLBdhbcATj2qpRVsrSoBtVRxEAqiktil5IhtCk7usy85HYDxNbVw/HWHvQRTd6cuYnKb4KNU1E=</Modulus><Exponent>AQAB</Exponent><P>xq4lK+sSdwEB1fCcyW5wQKfx74TWx+uxXjHunyXDKZhgkNiZ685VWr1kuiCfil2jOp8Hc/9WnlxcdH1nGvQXiQ==</P><Q>uy7hr+TXGQDNXyrje4MOIR9ZAlN1Oz5henc5IKBn+ddqlUQKH9rIqI/PQgBvT44bnnybBr2DiStafB9Hbs0jiQ==</Q><DP>xMnelZabznWX7OELWtThqJjwoM5Rsul34BXTBZ1wpjWAiFeSdacEkgD/0P/ZJkLDF6BG0JU7pVVUWimPw3m8CQ==</DP><DQ>hGb8AuQ29huoKXn34QTpuKoo1slb8iUE5JBym057XbFvVdgD5VZnezwGGaSfF8HobWmsas8gvKUq4wNpDsoSKQ==</DQ><InverseQ>nRitOmPpVe1vKg3Qq1+2SpCOlKxbfEED22CkRJxLVj8ElX0foB38RNJhHxnPvCAEvGdXVRLdeA4N5/nqU/pNyA==</InverseQ><D>N06ue+KWdeWNuAeZSQYhC/aIaSIOfOC/TZto3xP9x7t/lhlje0Q2e0KGA03Cy3ViFrRlWx3tphX5b3hCl8mbeMJLeOk8RFAWHVe3IpKr3Op+D8P2SD20/UopC4RaMlwsNSW++7a2ldifHCobZTwIAK68eR1cSL3gUt/sqnZOhcE=</D></RSAKeyValue>" in
let pkey : pubkey string AliceSays alice = MkPubKey alice pk in
let skey : privkey string AliceSays alice = MkPrivKey alice sk in
let msg = "hello" in
let dsig = rsa_sign alice skey msg msg in
let _ =  (if rsa_verify alice pkey msg msg dsig
          then print_string "message verified"
          else print_string "message not verified") in
  ()


