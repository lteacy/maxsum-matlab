function meanfun = meanMarginal(a,dims)
% MSFUN/MAXMARGINAL mean-marginalises a function over named variables.
% Usage: meanfun = meanMarginal(a,dims)
% where c = a with the named dimensions averaged out.
% All values receive equal weight, so essentially this assumes a uniform
% distribution over marginalised variables.

%******************************************************************************
%  First ensure that dims is not empty
%******************************************************************************
if isequal(nnz(dims),0) || isequal(nnz(a.ldims),0)
   meanfun = a;
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

if isequal(nnz(lmargDims),0) % stop if nothing more to do.
    meanfun = a;
    return;
end

lcondDims = a.ldims & ~lmargDims;

%******************************************************************************
%  Order the dimensions of the input so that the dimensions to be marginalised
%  are to the left of those that will stay.
%******************************************************************************
if ~isvector(a.data)
    adata = permute(a.data,[find(lmargDims(a.ldims)) find(lcondDims(a.ldims))]);
else
    adata = a.data;
end

%******************************************************************************
%  We then reshape the data, so that the marginalised dimensions are treated
%  as one, for the purpose of marginalisation.
%******************************************************************************
dataSize = size(adata);
noMargDims = nnz(lmargDims); % number of marginalised dimensions
reshapeSize = [prod(dataSize(1:noMargDims)) dataSize((1+noMargDims):end) 1 1];
ReshapedData = reshape(adata,reshapeSize);

%******************************************************************************
%  Now we do the marginalisation
%******************************************************************************
meanData = mean(ReshapedData);
meanfun = msfun(lcondDims,shiftdim(meanData,1));


