(* One application of F* is to verify security properties of programs. 

   This very simple example shows how refinement types can be used to 
   verify access control policies on files in a decentralized way.  *)

(* This module defines an API exposed by the file system to client programs. *)
module FileSystem
  (* The file system has some abstract type of files *)
  type file       

  (* a notion of user names *)
  type user =
    | U : string -> user
    | Admin : user

  (* and an abstract type of credentials for users.
     cred u is the type of a credentialfor the user u. *)
  type cred :: user => *

  (* A user can try to authenticate itself to get a credential *)
  val login : u:user -> pw:string -> option (cred u)

  (* And a user can call fwrite to write a string to a file. 
     But, the type of fwrite contains a refinement that says that
     the user "u" must have the "CanWrite" privilege in order to 
     write to "f" *)
  type CanWrite :: user => file => P
  val fwrite: u:user -> cred u -> f:file{CanWrite u f} -> string -> unit 
end

(*
  Note: FileSystem itself does not contain any runtime checks to protect access to files. 

   We can use the file system with different client programs 
   by specifying suitable security policies, and implementing reference monitors 
   suited to those security policies. 
   
   We can, of course, verify that the reference monitors implement the policy correctly. 
*)

module ClientReferenceMonitor
open FileSystem

(* A policy for this client: 
   Can only write to a file if it has an Admin credential *)
assume forall (u:user) (f:file). (CanWrite u f) <=> u=Admin

(* This is a good implementation of the reference monitor.
   It checks to make sure that it has an Admin credential *)
val checked_fwrite: u:user -> cred u -> f:file -> unit
let checked_fwrite u cred_u f = match u with
  | Admin -> fwrite u cred_u f "Hello" 
  | _ -> ()

(* the next two lines give a bad implementation. 
      --- any user u can use it to write to any file.
   Uncomment it to see if F* complains *)

(* val bad_fwrite: u:user -> cred u -> f:file -> unit *)
(* let bad_fwrite u cred_u f = fwrite u cred_u f "Hello" *)
end