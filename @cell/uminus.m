function p = uminus(a)
% CELL/UMINUS elementwise substraction for cell arrays
% NOTE: this is not part of the standard suite. This is a custom function
% for overloading the - operator

p = cell(size(a));
for i=1:numel(a)
   p{i} = -a{i};
end

