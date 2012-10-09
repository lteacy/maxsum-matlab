function [mxfun argmx] = maxMarginal(a,dims)
% MSFUN/MAXMARGINAL max-marginalises a function over named variables.
% Usage: [mx argmx] = maxMarginal(a,dims)
% where c = a with the named dimensions max-marginalised

%******************************************************************************
%  First, ensure that dims is not empty
%******************************************************************************
if isequal(nnz(dims),0) || isequal(nnz(a.ldims),0)
   mxfun = a;
   argmx = [];
   return;
end

%******************************************************************************
%  Convert to logical dimensions if necessary
%******************************************************************************
if ~islogical(dims)
   dims = sparse(1,dims,true,1,a.MAX_DIM);
end

%******************************************************************************
%  For maximisation, we only need to worry about named dimensions that
%  this function actually depends on
%******************************************************************************
lmargDims = a.ldims & dims;

if isequal(nnz(lmargDims),0) % stop if nothing more to do
   mxfun = a;
   argmx = [];
   return;
end

lmargInd = lmargDims(a.ldims);

%******************************************************************************
%  The conditional dimensions (thoses that remain) are any dimensions
%  not being marginalised.
%******************************************************************************
lcondDims = a.ldims & ~lmargDims;
 lcondInd = lcondDims(a.ldims);

%******************************************************************************
%  Order the dimensions of the input so that the dimensions to be marginalised
%  are to the left of those that will stay.
%******************************************************************************
if nnz(a.ldims) > 1
   a.data = permute(a.data,[find(lmargInd) find(lcondInd)]);
end

%******************************************************************************
%  We then reshape the data, so that the marginalised dimensions are treated
%  as one, for the purpose of maximisation.
%******************************************************************************
dataSize = size(a.data);
noMargDims = nnz(lmargDims); % number of marginalised dimensions
reshapeSize = [prod(dataSize(1:noMargDims)) dataSize((1+noMargDims):end)];
ReshapedData = reshape(a.data,[reshapeSize 1]);

%******************************************************************************
%  Now we do the maximisation
%******************************************************************************
[mx mxInd] = max(ReshapedData);
mxfun = msfun(lcondDims,shiftdim(mx,1));

%******************************************************************************
%  If the argmax is required, pack the argmx structure with the identity
%  of the marginalised and conditional dimensions, and the argmax vectors
%  in an array (argmax in left-most dimension, conditions to the right).
%******************************************************************************
if isequal(nargout,2)
   
  argmx.margDims = lmargDims;
  argmx.condDims = lcondDims;
   argmx.margSize = dataSize(1:noMargDims);
   argmx.condSize = size(mxfun);
   argmx.values = shiftdim(mxInd,1);

end


