function c = maxFunction(a,b)
% MSFUN/MAXFUNCTION returns the maximum of two functions.

%******************************************************************************
%  If both a & b are max-sum functions then we first expand to ensure they
%  have matching domains, and then operate their contents
%******************************************************************************
if isa(a,'msfun') && isa(b,'msfun')
   a = expand(a,b.ldims,size(b.data));
   b = expand(b,a.ldims,size(a.data));

   c.ldims = a.ldims; % b.ldims would do just as well
   c.data = max(a.data,b.data);

   c = msfun(c);

%******************************************************************************
%  Otherwise, we assume that either a or b is a scalar or compatible array
%  type, and attempt to operate on the array/scalar to the function data.
%******************************************************************************
elseif isa(a,'msfun')
   c.ldims = a.ldims;
   c.data = max(a.data,b);
   c = msfun(c);

elseif isa(b,'msfun')
   c.ldims = b.ldims;
   c.data = max(b.data,a);
   c = msfun(c);

else
   error('Seems that neither operand is an msfun.');
end

