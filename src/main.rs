use std::rc::Rc;

// Definition for a binary tree node.
#[derive(Debug, PartialEq, Eq)]
pub struct TreeNode {
  pub val: i32,
  pub left: Tree,
  pub right: Tree,
}

type Tree = Option<Rc<TreeNode>>;

// Tree(5, lhs, rhs) -> "(5 {lhs} {rhs})"
fn serialize(root: &Tree) -> String {
    match root {
        Some(node) => {
            let left = serialize(&node.left);
            let right = serialize(&node.right);
            format!("({} {left} {right})", node.val)
        }
        None => "()".to_string(),
    }
}

fn deserialize(data: &str) -> Tree {
    if data.len() == 2 {
        None
    } else {
        let int_end = find_item_end(data, 1); // skip '('
        let val = data[1..int_end].parse::<i32>().unwrap();

        let left_start = int_end + 1;
        let left_end = find_item_end(data, left_start);
        let left = deserialize(&data[left_start..left_end]);

        let right_start = left_end + 1;
        let right_end = data.len() - 1;
        let right = deserialize(&data[right_start..right_end]);
        Some(Rc::new(TreeNode {
            val, left, right
        }))
    }
}

fn find_item_end(s: &str, start: usize) -> usize {
    let mut nesting = 0;
    for (i, byte) in s.bytes().enumerate().skip(start) {
        if byte == '(' as u8 {
            nesting += 1;
        } else if byte == ')' as u8 {
            if nesting == 0 {
                return i;
            } else {
                nesting -= 1;
            }
        } else if byte == ' ' as u8 && nesting == 0 {
            return i;
        }
    }
    panic!("Bad input")
}

// 6.8s user, 7.187s total
fn main() {
    for i in 0 .. 25 {
        let tree1 = make_tree(i);
        let s = serialize(&tree1);
        let tree2 = deserialize(&s);

        assert_eq!(tree1, tree2);
    }
}

fn make_tree(i: usize) -> Tree {
    if i == 0 {
        None
    } else {
        let node = make_tree(i - 1);
        Some(Rc::new(TreeNode {
            val: i as i32,
            left: node.clone(),
            right: node,
        }))
    }
}
