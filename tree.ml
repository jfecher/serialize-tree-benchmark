
type tree = {
  value: int;
  left: tree option;
  right: tree option;
}

(* tree(5, lhs, rhs) -> "(5 lhs rhs)" *)
let rec serialize (node: tree option): string =
    match node with
    | Some(node) ->
        let l = serialize node.left in
        let r = serialize node.right in
        "(" ^ string_of_int node.value ^ " " ^ l ^ " " ^ r ^ ")"
    | None -> "()"

(* We need a tail-recursive helper for the loop in find_item_end in ocaml
 * since ocaml doesn't support early return nor breaking out of loops  *)
let rec find_item_end_helper (s: string) (i: int) (nesting: int ref) =
    if i < String.length s then begin
        let byte = String.get s i in

        if byte = '(' then begin
            nesting := !nesting + 1;
            find_item_end_helper s (i + 1) nesting
        end else if byte = ')' then
            begin
            if !nesting = 0 then
                i
            else begin
                nesting := !nesting - 1;
                find_item_end_helper s (i + 1) nesting
            end end
        else if byte = ' ' && !nesting = 0 then
            i
        else
            find_item_end_helper s (i + 1) nesting
    end else
        0

let find_item_end (s1: string) (start: int): int =
    let nesting = ref 0 in
    let s = String.sub s1 start (String.length s1 - start) in
    start + find_item_end_helper s 0 nesting

let rec deserialize (data: string): tree option =
    if String.length data = 2 then
        None
    else begin
        let int_end = find_item_end data 1 in (* skip '(' *)
        let val_item = String.sub data 1 (int_end - 1) in
        let value = int_of_string val_item in

        let left_start = int_end + 1 in
        let left_end = find_item_end data left_start in
        let left_item = String.sub data left_start (left_end - left_start) in
        let left = deserialize left_item in

        let right_start = left_end + 1 in
        let right_end = String.length data - 1 in
        let right_item = String.sub data right_start (right_end - right_start) in
        let right = deserialize right_item in
        Some({ value; left; right })
    end

let rec make_tree (i: int): tree option =
    if i = 0 then
        None
    else
        let node = make_tree (i - 1) in
        Some({ value = i; left = node; right = node })

(* 47.99s user, 52.85s total *)
let () =
    for i = 0 to 25 do
        let tree1 = make_tree i in
        let s = serialize tree1 in
        let tree2 = deserialize s in
        assert(tree1 = tree2);
    done
