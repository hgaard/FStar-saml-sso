module SessionManager

open Lib
open Protocol

val hasValidSession: list (string*string) -> bool
let hasValidSession cookies = 
  (* Find AuthenticationKey cookie and validate *)
  let ak = getStrInTupleList cookies "AuthenticationKey" in
  if isEmptyStr ak then false 
  else true (*Should be validated somehow*)

val GetSessionSubject: list (string*string) -> Subject