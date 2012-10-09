function n = maxnorm(varargin)
% MAXNORM returns the maxnorm for the specified array

%******************************************************************************
%  If we have no arguments, there is most likely an error.
%******************************************************************************
if isequal(nargin,0)
   error('No arguments found for maxnorm');
end

%******************************************************************************
%  If we have more than one argument, recursively call and aggregate as we
%  do for a single cell array argument
%******************************************************************************
if ~isequal(nargin,1)
   n = 0;
   for i=1:nargin
      n = max(n,maxnorm(varargin{i}));
   end
   return;
end

%******************************************************************************
%  Anything that is empty has a max norm of zero.
%******************************************************************************
if isempty(varargin{1})
   n = 0;
   return;
end

%******************************************************************************
%  If we have an msfun calculate based on its data array
%******************************************************************************
if isa(varargin{1},'msfun')
   n = maxnorm(varargin{1}.data);
   return;
end

%******************************************************************************
%  If we have a cell array, recursively call for each element, and
%  return the maxnorm calculated over the results
%******************************************************************************
if iscell(varargin{1})
   n = 0;
   for i=1:numel(varargin{1})
      n = max(n,maxnorm(varargin{1}{i}));
   end
   return;
end

%******************************************************************************
%  If we have a standard array of numbers, calculate and return the maxnorm
%******************************************************************************
if isnumeric(varargin{1})
   n = max(abs(varargin{1}(:)));
   return;
end

%******************************************************************************
%  In another case, give up.
%******************************************************************************
error('Do not know how to calculate maxnorm for argument type');



