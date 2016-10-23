%functions to operate on a row vector as if it was a queue
classdef Tree
    properties
        value
        left_tree
        right_tree
    end
    methods
        function obj = createNewTree(elt)
            new_tree = TREE;
            new_tree.value = elt;
            new_tree.left = 0;
            new_tree.right = 0;
            obj = new_tree; 
        end
        function obj = addNewPair(tree, eltA, eltB)
            if (checkVal(eltA) && checkVal(eltB))
                obj = tree;
            elseif (checkVal(eltA) && ~checkVal(eltB))
                obj = 
        end
        function obj = makeQueue(array)
            obj.Array = array;
        end
    end
end