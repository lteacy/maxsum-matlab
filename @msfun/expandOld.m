function out = expand(in,dims,dimSize)

if islogical(dims)
   dims = find(dims);
end
indims = find(in.ldims);

%******************************************************************************
%  In the simple case where in is a constant (i.e. scalar data depending on
%  no variables) we just replicate the constant for specified variables.
%******************************************************************************
if nnz(in.ldims) && isscalar(in.data)
   out = msfun(dims,repmat(in.data,[dimSize 1]));
   return;
end

%******************************************************************************
%  Figure out which dimensions need to be added, and how many times the
%  data will need to be replicated. If nothing needs to be added, we just
%  return the input (more efficient because, in this case, Matlab just
%  sets a pointer internally).
%******************************************************************************
[newDims newDimIndices] = setdiff(dims,indims);

% return original if nothing needs to change
if isempty(newDims)
   out = in;
   return;
end

newSizes = dimSize(newDimIndices);
totalSize = prod(newSizes);

if isequal(numel(indims),1)
   allSizes = [numel(in.data) newSizes 1];
else
   allSizes = [size(in.data) newSizes 1];
end

%******************************************************************************
%  Construct the new vector of dimension ids by appending the new dimensions
%******************************************************************************
out.dims = [indims newDims];

%******************************************************************************
%  Replicate the old function along the new dimensions
%******************************************************************************
replicatedData = repmat(in.data(:),[1 totalSize]);
out.data = reshape(replicatedData,allSizes);

%******************************************************************************
%  Sort the dimensions into the correct order
%******************************************************************************
[out.dims sortOrder] = sort(out.dims);

% don't try to permute if we've got a vector
% its not required and will only result in an error
% instead, just ensure its a column vector
if isvector(out.data)
   out.data = reshape(out.data,[numel(out.data) 1]);
else
   out.data = permute(out.data,sortOrder);
end
out = msfun(out.dims,out.data,false);
