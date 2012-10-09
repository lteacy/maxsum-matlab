function p = minus(a,b)
% CELL/MINUS elementwise substraction for cell arrays
% NOTE: this is not part of the standard suite. This is a custom function
% for overloading the - operator

% ensure a & b are cell arrays of the same size
% if ~iscell(b)
%    error('A and B must be cell arrays');
% end
% 
% if ~isequal(size(a),size(b))
%    error('A and B must be cell arrays of the same size');
% end

p = cellfun(@minus,a,b,'UniformOutput',false);

% p = cell(size(a));
% for i=1:numel(a)
%    p{i} = a{i}-b{i};
% end

