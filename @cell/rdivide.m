function p = rdivide(a,b)
% MSFUN/RDIVIDE right elementwise division cell arrays
% NOTE: this is not part of the standard suite. This is a custom function
% for overloading the ./ operator

%*****************************************************************************
%  Deal with the scalar case first.
%*****************************************************************************
if isscalar(b)

   p = cell(size(a));

   for i=1:numel(a)
      p{i} = a{i} ./ b;
   end

   return;

end

%*****************************************************************************
%  Otherwise, both operands should be cell arrays of equal size
%*****************************************************************************
if ~iscell(b)
   error('divisor must be a cell array or scalar');
end

if ~isequal(size(a),size(b))
   error('A and B must be cell arrays of the same size');
end

%*****************************************************************************
%  Do elementwise divison
%*****************************************************************************
p = cell(size(a));
for i=1:numel(a)
   p{i} = a{i} ./ b{i};
end

