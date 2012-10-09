function [a indexArray dataSize] = condition(b,vars,vals)
% MSFUN/CONDITION conditions a function on uncertain variable values.
%
% Usage: a = condition(b,vars,vals)
% vars - vector of variable names
% vals - corresponding values for named variables
% b same as a, but with vars removed, conditioned on specified values
%
% alternatively: a = condition(b,argmx) where argmx is structure output from 
% maxMarginalisation function
%

%******************************************************************************
%  If there is nothing to condition on, return function as is.
%******************************************************************************
if (nargin > 1) && isempty(vars)
   a=b;
   return;
end   

if islogical(vars) && isequal(nnz(vars),0)
   a=b;
   return;
end

%******************************************************************************
%  Deal two argument case: vars with fixed values
%******************************************************************************
if isequal(nargin,3)

   %***************************************************************************
   %  Convert to logical representation if necessary
   %***************************************************************************
   if ~islogical(vars)
      lvars = sparse(1,vars,true,1,b.MAX_DIM);
   else
      lvars = vars;
   end
   if ~isequal(numel(vals),numel(lvars))
      lvals = spalloc(1,b.MAX_DIM,numel(vals));
      lvals(lvars) = vals;
   else
      lvals = vals;
   end

   %***************************************************************************
   %  Ignore variables that this function doesn't depend on, and find
   %  the position of the variables in the data dimensions
   %***************************************************************************
   lvars = lvars & b.ldims;
   dimIndex = lvars(b.ldims);

   %***************************************************************************
   %  Construct an index cell array, by setting all conditioned dimensions
   %  to their specified value, and all others to ':'
   %***************************************************************************
   indexArray = cell(1,ndims(b.data));
   indexArray(~dimIndex) = {':'};
   indexArray(dimIndex) = num2cell(lvals(lvars));

   %***************************************************************************
   %  Select the appropriate parts of the data and dimensions
   %***************************************************************************
   selectedData = b.data(indexArray{:});
   selectedDims = b.ldims & ~lvars;
   selectedIndex = selectedDims(b.ldims);

   %***************************************************************************
   %  Reshape the data to remove the redundant dimensions
   %***************************************************************************
   dataSize = size(selectedData);
   dataSize = [dataSize(selectedIndex) 1]; % trailing one deals with vectors
   selectedData = reshape(selectedData,[dataSize 1]);

   %***************************************************************************
   %  Construct and return the new function
   %***************************************************************************
   a = msfun(selectedDims,selectedData);


%******************************************************************************
%  Deal with one argument case: argmx type structure with values set for
%  specific conditions
%******************************************************************************
elseif isequal(nargin,2) && isstruct(vars)

   %***************************************************************************
   % Ensure the function has all required conditional and marginal variables
   % (expand if necessary)
   %***************************************************************************
   allDims = vars.margDims | vars.condDims;
   allSize = [vars.margSize vars.condSize];
   b = expand(b,allDims,allSize);

   %***************************************************************************
   %  Find the position of the marginal and conditional dimensions.
   %  Also find the any additional variables and there positions.
   %***************************************************************************
   margPos = find(vars.margDims(b.ldims));
   condPos = find(vars.condDims(b.ldims));
    addPos = find(~allDims(b.ldims));

   laddDims = b.ldims & ~allDims;
   dimOrder = [margPos condPos addPos];

   %***************************************************************************
   %  Permute the data so that the marginal dimensions occur first, the
   %  conditional dimensions 2nd, followed by anything else.
   %***************************************************************************
   if ~isequal(1,nnz(b.ldims))
      data = permute(b.data,dimOrder);
   else
      data = b.data;
   end

   %***************************************************************************
   %  Reshape the data so that both the marginal and conditional dimensions
   %  are given first, followed by any additional dimensions
   %***************************************************************************
   dataSize = size(data);
   allDimSize = prod(dataSize(1:nnz(allDims)));
   data = reshape(data,[allDimSize numel(data)./allDimSize]);

   %***************************************************************************
   %  Now we can calculate the linear indices need to condition on the
   %  marginals - and use these to select the correct data.
   %***************************************************************************
   ind = sub2ind([prod(vars.margSize) vars.condSize],...
                  vars.values(:)',1:numel(vars.values(:)));

   %***************************************************************************
   %  Finally, we select the data and output the resulting function
   %***************************************************************************
   data = reshape(data(ind,:),[dataSize((1+nnz(vars.margDims)):end) 1 1]);
   finalDims = laddDims | vars.condDims;
   finalOrder = [find(vars.condDims(finalDims)) find(laddDims(finalDims))];
   if ~isvector(data)
      data = ipermute(data,finalOrder);
   end
   a = msfun(finalDims,data);

%******************************************************************************
%  Otherwise fail
%******************************************************************************
else
   error('Invalid arguments');
end
