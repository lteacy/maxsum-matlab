function p = plus(a,b)
% CELL/PLUS elementwise addition for cell arrays
% NOTE: this is not part of the standard suite. This is a custom function
% for overloading the + operator

%******************************************************************************
%  If one operand is not a cell array, add its value to all elements of the 
%  other operand.
%******************************************************************************
if ~iscell(b)
   p = cell(size(a));
   for i=1:numel(a)
      p{i} = a{i}+b;
   end
   return;
end

if ~iscell(a)
   p = cell(size(b));
   for i=1:numel(b)
      p{i} = a+b{i};
   end
   return;
end

%******************************************************************************
%  If one of the cell arrays has only one element, then add it to all the
%  elements of the other
%******************************************************************************
if isequal(numel(a),1)
   p = cell(size(b));
   for i=1:numel(p)
      p{i} = a{1}+b{i};
   end
   return;

elseif isequal(numel(b),1)
   p = cell(size(a));
   for i=1:numel(p)
      p{i} = a{i}+b{1};
   end
   return;

end

%******************************************************************************
%  Otherwise, the only remaining case we can deal with is cell arrays of
%  equal size.
%******************************************************************************
if ~isequal(size(a),size(b))
   error('A and B must be cell arrays of the same size');
end

p = cell(size(a));
for i=1:numel(a)
   p{i} = a{i}+b{i};
end


