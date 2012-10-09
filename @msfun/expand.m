function out = expand(in,dims,dimSize)

%******************************************************************************
%  First, convert the input dimensions to logical and sparse, if required
%******************************************************************************
if ~islogical(dims)
   dimSize = sparse(1,dims,dimSize(1:nnz(dims)),1,in.MAX_DIM);
   dims = sparse(1,dims,true,1,in.MAX_DIM);

elseif ~isequal(numel(dimSize),numel(dims))
   dimSize = sparse(1,find(dims),dimSize(1:nnz(dims)),1,in.MAX_DIM);
end

%******************************************************************************
%  In the simple case where in is a constant (i.e. scalar data depending on
%  no variables) we just replicate the constant for specified variables.
%******************************************************************************
if isequal(nnz(in.ldims),0) && isscalar(in.data)
   out = msfun(dims,repmat(in.data,[nonzeros(dimSize)' 1]));
   return;
end

%******************************************************************************
%  Figure out which dimensions need to be added, and how many times the
%  data will need to be replicated. If nothing needs to be added, we just
%  return the input (more efficient because, in this case, Matlab just
%  sets a pointer internally).
%******************************************************************************
newDims = dims & ~in.ldims;

% return original if nothing needs to change
if isequal(nnz(newDims),0)
   out = in;
   return;
end

newSizes = dimSize(newDims);
totalSize = prod(newSizes);

if isequal(nnz(in.ldims),1)
   allSizes = [numel(in.data) newSizes 1];
else
   allSizes = [size(in.data) newSizes 1];
end

%******************************************************************************
%  Construct the new vector of dimension ids by appending the new dimensions
%******************************************************************************
out.ldims = in.ldims | newDims;

%******************************************************************************
%  Replicate the old function along the new dimensions
%******************************************************************************
replicatedData = repmat(in.data(:),[1 totalSize]);
out.data = reshape(replicatedData,allSizes);

%******************************************************************************
% don't try to permute if we've got a vector
% its not required and will only result in an error
% instead, just ensure its a column vector
%******************************************************************************
if isvector(out.data)
   out.data = reshape(out.data,[numel(out.data) 1]);
else
   order = double(out.ldims);
   order(out.ldims) = 1:nnz(order);
   order = [order(in.ldims) order(newDims)];
   out.data = ipermute(out.data,order);
end
out = msfun(out.ldims,out.data);
