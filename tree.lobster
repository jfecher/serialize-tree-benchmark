
// Definition for a binary tree node.
class Tree:
  val: int
  left: Tree?
  right: Tree?

// Tree(5, lhs, rhs) -> "(5 lhs rhs)"
def serialize(node: Tree?) -> string:
    if node:
        let l = serialize(node.left)
        let r = serialize(node.right)
        return "({node.val} {l} {r})"
    else:
        return "()"

def deserialize(data: string) -> Tree?:
    if length(data) == 2:
        return nil
    else:
        let int_end = find_item_end(data, 1) // skip '('
        let val_item = substring(data, 1, int_end - 1)
        let val, _ = string_to_int(val_item)

        let left_start = int_end + 1
        let left_end = find_item_end(data, left_start)
        let left_item = substring(data, left_start, left_end - left_start)
        let left = deserialize(left_item)

        let right_start = left_end + 1
        let right_end = length(data) - 1
        let right_item = substring(data, right_start, right_end - right_start)
        let right = deserialize(right_item)
        return Tree { val, left, right }

def find_item_end(s1: string, start: int) -> int:
    var nesting = 0

    let s = substring(s1, start, length(s1) - start)
    for(s) byte, i:
        if byte == '(':
            nesting += 1
        elif byte == ')':
            if nesting == 0:
                return i + start
            else:
                nesting -= 1

        elif byte == ' ' and nesting == 0:
            return i + start

    return -1

def make_tree(i: int) -> Tree?:
    if i == 0:
        return nil
    else:
        let node = make_tree(i - 1)
        return Tree { i, node, node }

// 138.94s user, 2:19 total
for(25) i:
    let tree1 = make_tree(i)

    let s = serialize(tree1)

    let tree2 = deserialize(s)

    assert(equal(tree1, tree2))
