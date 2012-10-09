function c = plus(a,b)

%******************************************************************************
%  If both a & b are max-sum functions then we first expand to ensure they
%  have matching domains, and then add their contents
%******************************************************************************
if isa(a,'msfun') && isa(b,'msfun')
   a = expand(a,b.ldims,size(b.data));
   b = expand(b,a.ldims,size(a.data));

   c.ldims = a.ldims; % b.dims would do just as well
   c.data = a.data + b.data;

   c = msfun(c.ldims,c.data);

%******************************************************************************
%  Otherwise, we assume that either a or b is a scalar or compatible array
%  type, and attempt to add the array/scalar to the function data.
%******************************************************************************
elseif isa(a,'msfun')
   c.ldims = a.ldims;
   if isempty(b)
      c.data = a.data;
   else
      c.data = a.data + b;
   end
   c = msfun(c.ldims,c.data);

elseif isa(b,'msfun')
   c.ldims = b.ldims;
   if isempty(a) % ignore empty arrays
      c.data = b.data;
   else
      c.data = b.data + a;
   end
   c = msfun(c.ldims,c.data);

else
   error('Seems that neither operand is an msfun.');
end

