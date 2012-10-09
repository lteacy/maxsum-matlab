function [c i] = max(varargin)
% MSFUN/MAX maximises over msfunctions
% Works in same way as standard max, but any removed dimensions have their
% dimension ids (variable names) removed.

%******************************************************************************
%  Figure out which kind of arguments we have an delegate to appropriate
%  subfunctions
%******************************************************************************
if isequal(1,nargin)
   [c i] = maxMarginal(varargin{1},funDims(varargin{1},[],1));

elseif isequal(2,nargin)
   c = maxFunction(varargin{1},varargin{2});

elseif isequal(3,nargin) && isequal([],varargin{2})
   [c i] = maxMarginal(varargin{1},funDims(varargin{1},[],varargin{3}));

end
