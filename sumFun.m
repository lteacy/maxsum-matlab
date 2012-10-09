function f = sumFun(varargin)
% SUMFUN sums a variable number of msfun objects together.
% Usage f = sumFun(A,B,C,...)
% Usage f = sumFun(A) where A is cell array.
% Usage f = sumFun(A,dim) where A is cell array.
% The latter use aggregates over the first non-singleton dimension
% Any parameters that equal [] are ignored.
%

%******************************************************************************
%  First, deal with cell array arguments
%  Here, we aggregate over the specified dimension of a given cell array
%  or the first non-singleton
%******************************************************************************
if iscell(varargin{1})

   %**************************************************************************
   % if dimension not specified, use first non-singleton
   %**************************************************************************
   if isequal(nargin,1)

      %***********************************************************************
      % Use shiftdim to remove leading singletons
      %***********************************************************************
      funArray = shiftdim(varargin{1});
      dim = 1;

   %**************************************************************************
   %  Otherwise, get the specified cell array and dimension from the
   %  argument list
   %**************************************************************************
   elseif isequal(nargin,2) && isscalar(varargin{2})

      funArray = varargin{1};
      dim = varargin{2};

   %**************************************************************************
   %  Any other types of arguments are an error
   %**************************************************************************
   else
      error('Invalid arguments.');
   end

   %**************************************************************************
   % put the aggregate dimension first to make things easier
   %**************************************************************************
   funArray = permute(funArray,[dim 1:(dim-1) (dim+1):ndims(funArray)]);

   %**************************************************************************
   % get the size of the array
   %**************************************************************************
   funSize = size(funArray);

   %**************************************************************************
   % get the size of the first dimension (which we will aggregate over)
   %**************************************************************************
   size1 = funSize(1);

   %**************************************************************************
   % get combined size for the rest
   %**************************************************************************
   size2 = prod(funSize(2:end));

   %**************************************************************************
   % allocate space for result
   %**************************************************************************
   f = cell([1 funSize(2:end)]);

   %**************************************************************************
   % iterate over remain dimensions
   %**************************************************************************
   for i=1:size2

      %***********************************************************************
      % iterate over aggregate dimension
      %***********************************************************************
      for j=1:size1

         %********************************************************************
         % sum all functions over the aggregate dimension
         %********************************************************************
         f{i} = f{i}+funArray{j,i};

      end
   end

   %**************************************************************************
   % re-order result so that dimensions occur in original order
   %**************************************************************************
   f = ipermute(f,[dim 1:(dim-1) (dim+1):ndims(f)]);

%******************************************************************************
% Otherwise, sum up the parameters
%******************************************************************************
else
   f = [];
   for i=1:nargin
      f = f+varargin{i};
   end
end
