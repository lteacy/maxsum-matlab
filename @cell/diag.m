% CELL/DIAG Replaces functionality lost in 2009 release of Matlab
function y = diag(x)

s = size(x);

if ~isequal(numel(s),2)
   error('cell array must be 2-D');
end

% put vector along diagonal
if isequal(s(1),1) || isequal(s(2),1)
   n = numel(x);
   ind = [0:(n-1)]*n + [1:n];
   y = cell(n);
   y(ind) = x;
   return;
end

% otherwise cell array must be square
if ~isequal(s(1),s(2))
   error('cell array must be square');
end

% now extract diagonal
n = s(1);
ind = [0:(n-1)]*n + [1:n];
y = x(ind)';





