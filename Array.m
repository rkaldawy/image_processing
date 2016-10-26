classdef Array
    properties
        value
    end
    methods
        function obj = add(obj, elt)
            newdata = [obj.value, elt];
            obj = Array;
            obj.value = newdata;
        end
        function result = includes(obj, elt)
           check = false;
           for i = 1:size(obj.value, 2)
               if (obj.value(1, i) == elt)
                   check = true;
               end
           end
           result = check;    
        end
        function obj = combine(objA, objB)
           newValue = [objA.value, objB.value];
           obj = Array;
           obj.value = newValue;
        end
        function elt = get_first(obj)
            elt = obj.value(1);
        end
    end
end