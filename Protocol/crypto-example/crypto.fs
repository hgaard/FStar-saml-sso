#light "off"

module Microsoft.FStar.Crypto
open System
open System.Security.Cryptography

let sha1_instance = SHA1.Create ()
let sha1 (x:byte []) : byte [] = sha1_instance.ComputeHash x

let ASSUME (x:unit) = false

let rsa_sign_impl (v:string) (skey:string) = 
  let v = System.Text.Encoding.UTF8.GetBytes (v) in
  let rsa = new RSACryptoServiceProvider() in
  let _ = rsa.FromXmlString(skey) in
  let oid = CryptoConfig.MapNameToOID "sha1" in
    rsa.SignHash(sha1 v, oid)

let rsa_verify_impl (v:string) (x:byte[]) (pkey:string) =
  let v = System.Text.Encoding.UTF8.GetBytes (v) in
  let rsa = new RSACryptoServiceProvider() in
  let _ = rsa.FromXmlString(pkey) in
  let oid = CryptoConfig.MapNameToOID "sha1" in
    rsa.VerifyHash(sha1 v, oid, x)        
