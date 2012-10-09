function [f n] = normalise(fun,vars)
% MSFUN/NORMALISE Normalises the specified function
% [f n] = normalise(fun);
% [f n] = normalise(fun,vars); for specified vars
% f is the normalised function, n is the normaliser

%*****************************************************************************
%  Normalise over all variables if none specified
%*****************************************************************************
if isequal(nargin,1)
   data = fun.data;
   n = mean(data(:));
   f = fun - n;

%*****************************************************************************
%  Otherwise, we normalise for the specified vars, holding all others
%  constant
%*****************************************************************************
else

   %**************************************************************************
   %  Make vars sparse logical if they are not already
   %**************************************************************************
   if ~islogical(vars)
      vars = sparse(1,vars,true,1,fun.MAX_DIM);
   end

   %**************************************************************************
   %  Identify conditioned variables that this function depends on
   %**************************************************************************
   vars = vars & fun.ldims;
   
   %**************************************************************************
   %  The result works without this special condition, but returning
   %  an empty array rather than lots of zeros allows us to speed up later
   %  operations on the result.
   %**************************************************************************
   if isequal(nnz(vars),0)
      f = [];
      n = [];
      return;
   end

   %**************************************************************************
   %  Identify the position of each dimension in the data array
   %**************************************************************************
   dimPos = double(fun.ldims);
   dimPos(fun.ldims) = [1:nnz(fun.ldims)];
   varInd = nonzeros(dimPos(vars))';

   %**************************************************************************
   %  Take the mean across all named variables
   %**************************************************************************
   n = fun.data;
   for it=1:numel(varInd)
      n = mean(n,varInd(it));
   end

   %**************************************************************************
   %  Finally, replicate to find the norm and normalise the function
   %**************************************************************************
   n = repmat(n,size(fun)./[size(n) ones(1,ndims(fun.data)-ndims(n))]);
   f = fun - n;

end

