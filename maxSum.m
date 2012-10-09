function [argmx, edges, argmx2] = maxSum(factors,edges,minNorm, ...
   maxIterations, IDOffset)
% MAXSUM Calculate the argmax for a factor graph
% Usage [argmx edges argmx2] = maxSum(factors,edges,minNorm,maxIterations,IDOffset) 
%  where factors is a cell array of msfun objects
%  and edges is a noFactors x noStates logical matrix representing the edges in
%  the factor graph. This argument is optional.
%
%  If only the first argument is given, the rest will be inferred
%  variable dependencies of the factors.
%
%  IDOffset is id before id of first action variable (i.e. the no of states
%  variables).
%
%  Outputs are:
%  argmx : the arg max values
%  edges : the edges index array (same as input or inferred if not supplied)
% argmx2 : the 2nd best actions (as required by VPI algorithm)
%
% The elements of argmx2 satisfy mx >= mx2 >= everything else.
%

%******************************************************************************
%  Set defaults for the stopping conditions
%******************************************************************************
if 5 > nargin || isempty(IDOffset)
   IDOffset = 0;
end

if 4 > nargin || isempty(maxIterations)
   maxIterations = 50;
end

if 3 > nargin || isempty(minNorm)
   minNorm = 0.0000001;
end

%******************************************************************************
%  If the graph edges have not been supplied, we infer them from the factor
%  variable dependencies
%******************************************************************************
if 2 > nargin || isempty(edges)
   edges = inferGraph(factors,IDOffset);
end

%******************************************************************************
%  Allocate space for storing messages
%******************************************************************************
%   noFactors = size(edges,1);
% noVariables = size(edges,2);
var2facMsgs = cell(size(edges));
fac2varMsgs = cell(size(edges));
 facMsgDiff = cell(size(edges)); % used later for calculating max norms

% for iteration purposes, find region and variable indices for each edge
[facIndices, varIndices] = find(edges);

%******************************************************************************
%  Repeatedly update the messages until they converge, or we reach the
%  maximum allowed number of iterations. Convergence is measured calculating
%  the maxnorm on the difference between the last two sets of messages.
%******************************************************************************
maxIterationsReached = true;
for it=1:maxIterations 

   %***************************************************************************
   % store the current set of messages for calculating the max-sum norm
   % since variable messages are just summations its sufficient to focus
   % only on the factor messages. 
   %***************************************************************************
   facMsgDiff(edges) = fac2varMsgs(edges);

   %***************************************************************************
   %  Update the messages
   %***************************************************************************
   calMsgFactor2Var;
   calMsgVar2Factor;

   %***************************************************************************
   %  Calculate the max-norm for the difference between the new and old
   %  factor messages
   %***************************************************************************
   facMsgDiff(edges) = facMsgDiff(edges) - fac2varMsgs(edges);

   %***************************************************************************
   %  Stop if the max norm reaches a certain value
   %***************************************************************************
   %disp(['maxnorm: ' num2str(maxnorm(facMsgDiff))]);
   if minNorm > maxnorm(facMsgDiff)
      maxIterationsReached = false;
      break;
   end

end

% warn if the maximum number of iterations was reached
if maxIterationsReached
   warning('maxsum:iter','Maximum number of max-sum iterations was reached.');
end

%******************************************************************************
%  Return the argmx and (if required) argmx2 - the 2nd best actions
%******************************************************************************
if nargout > 2
   [argmx, argmx2] = cellfun(@argmax,sumFun(fac2varMsgs,1));
else
   argmx = cellfun(@argmax,sumFun(fac2varMsgs,1));
end

%******************************************************************************
%******************************************************************************
%              Calculate the Variable to Factor messages
%******************************************************************************
%******************************************************************************
   function calMsgVar2Factor
      
      % calculate the sum of input messages for each variable
      msgSum = sumFun(fac2varMsgs,1);

      % calculate outgoing message for each edge
      for i=1:numel(facIndices)
         facInd = facIndices(i);
         varInd = varIndices(i);
         var2facMsgs{facInd,varInd} = ...
            msgSum{varInd} - fac2varMsgs{facInd,varInd};
            %normalise(msgSum{varInd} - fac2varMsgs{facInd,varInd});
      end

   end

%******************************************************************************
%******************************************************************************
%              Calculate the Factor to Variable messages
%******************************************************************************
%******************************************************************************
   function calMsgFactor2Var
      
      % calculate the sum of input messages for each factor
      msgSum = sumFun(var2facMsgs,2);

      % calculate outgoing message for each edge
      for i=1:numel(facIndices)
         facInd = facIndices(i);
         varInd = varIndices(i);
         
         % add the input messages to this factor
         outMsg = msgSum{facInd}-var2facMsgs{facInd,varInd}+factors{facInd};

         % max marginalise all but the target variable
% old code: outMsg = maxMarginal(outMsg,setdiff(outMsg.dims,varInd+IDOffset));
         diffDims = outMsg.ldims;
         diffDims(varInd+IDOffset)=false;
         outMsg = maxMarginal(outMsg,diffDims);

         % normalise the message and store
         fac2varMsgs{facInd,varInd} = normalise(outMsg);
      end
   end

end
