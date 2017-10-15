(*
   Inspect the first command-line argument (Sys.argv.(1))
   and determine which subcommand to execute, calling
   a function from our library accordingly.
*)

open Printf

(* Run your test suite here. *)
let test argv_offset =
  print_endline "OK"

(*
   You can do anything you want.
   You may want to use Arg.parse_argv to read the remaining
   command-line arguments.
*)
let run argv_offset =
  Sample_module3.do_something ()

(* Add your own subcommands as needed. *)
let subcommands = [
  "test", test;
  "run", run;
]

let help () =
  let subcommand_names =
    String.concat "\n" (List.map (fun (name, f) -> "  " ^ name) subcommands)
  in
  let usage_msg = sprintf "\
Usage: %s SUBCOMMAND [ARGS]
where SUBCOMMAND is one of:
%s

For help on a specific subcommand, try:
  %s SUBCOMMAND --help
"
    Sys.argv.(0) subcommand_names Sys.argv.(0)
  in
  eprintf "%s%!" usage_msg

let dispatch_subcommand () =
  assert (Array.length Sys.argv > 1);
  match Sys.argv.(1) with
  | "help"
  | "-h"
  | "-help"
  | "--help" ->
      help ()
  | subcmd ->
      let argv_offset = 1 in
      let action =
        try List.assoc subcmd subcommands
        with Not_found ->
          eprintf "Invalid subcommand: %s\n" subcmd;
          help ();
          exit 1
      in
      action argv_offset

let main () =
  let len = Array.length Sys.argv in
  if len <= 1 then (
    help ();
    exit 1
  )
  else
    dispatch_subcommand ()

(* Run now. *)
let () = main ()
