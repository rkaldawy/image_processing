%functions to operate on a row vector as if it was a queue
classdef Queue
    properties
        Array
    end
    methods
        function obj = addElt(queue, elt)
            queue.Array = [(queue.Array), elt];
            obj = queue;
        end
        function newQueue = removeElt(queue)
            shortArray = queue.Array;
            newQueue = Queue;
            newQueue.Array = shortArray(:, (2:size(queue.Array, 2))) ;
        end
        function obj = makeQueue(array)
            obj.Array = array;
        end
    end
end


%add element to back of queue


%remove element from front of queue



