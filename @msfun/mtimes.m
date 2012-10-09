function c = times(a,b)
% MSFUN/TIMES matrix multiplication for max-sum functions
% This will only work for functions of 2 or less variables in total.

%******************************************************************************
%  If both a & b are max-sum functions then we first expand to ensure they
%  have matching domains, and then multiply their contents
%  WHAT DOES THIS ACTUALLY MEAN? Lets not supported it for now.
%******************************************************************************
if isa(a,'msfun') && isa(b,'msfun')

   error('matrix multiplication of msfun objects not currently supported');
   a = expand(a,b.ldims,size(b.data));
   b = expand(b,a.ldims,size(a.data));

   c.ldims = a.ldims; % b.ldims would do just as well
   c.data = a.data * b.data;

   c = msfun(c);

%******************************************************************************
%  Otherwise, we assume that either a or b is a scalar or compatible array
%  type, and attempt to multiply the array/scalar to the function data.
%******************************************************************************
elseif isa(a,'msfun')
   c.ldims = a.ldims;
   c.data = a.data * b;
   c = msfun(c);

elseif isa(b,'msfun')
   c.ldims = b.ldims;
   c.data = a * b.data;
   c = msfun(c);

else
   error('Seems that neither operand is an msfun.');
end

