% MSFUN/FUNDIMS get or set the variables that this function depends on.
% This is a wrapper function for backward compatibility with old code.
function a = funDims(obj,val,ind)

switch nargin
   case 1
      a = find(obj.ldims);
   case 2
      a = obj;
      a.ldims = sparse(1,val,true,1,obj.MAX_DIM);
   case 3
      if isempty(val)
         a = find(obj.ldims);
         a = a(ind);
      else
         a = obj;
         dims = find(obj.ldims);
         dims(ind) = val;
         a.ldims = sparse(1,dims,true,1,obj.MAX_DIM);
      end
   otherwise
      error('MSFUN/DIMS Incorrect number of arguments.');
end
