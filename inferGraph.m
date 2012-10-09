function edges = inferGraph(factors,IDOffset)
% INFERGRAPH infer factor graph from cell array of factors
% Usage: graph = inferGraph(factors,IDOffset)
% where graph is a noVariables x noFactors sparse logical array indicating
% which variables are related to which factors.

if nargin < 2 || isempty(IDOffset)
   IDOffset = 0;
end

%******************************************************************************
%  First, collect all factor variable dependencies in a cell array
%******************************************************************************
facInd = cell(1,numel(factors));
varInd = cell(1,numel(factors));

for i=1:numel(factors)
   varInd{i} = factors{i}.dims-IDOffset;
   facInd{i} = repmat(i,size(factors{i}.dims));
end

%******************************************************************************
%  Now, concatenate these cell arrays into numerical index vectors
%  The maximum value of the variable array also indicates the total number
%  of variables we may expect to have.
%******************************************************************************
varInd = [varInd{:}];
facInd = [facInd{:}];
noVars = max(varInd);
noFacs = numel(factors);

%******************************************************************************
%  Finally, we return a logical sparse array with true values at the
%  points where a relation exists.
%******************************************************************************
edges = sparse(facInd,varInd,true,noFacs,noVars,numel(varInd));




