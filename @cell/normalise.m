function [f n] = normalise(data)
% NORMALISE Normalises each element of a cell array
% [f n] = normalise(data);
% f is the normalised cell array, n is the array of normalisers

f = cell(size(data));

if 2>nargout

   for i=1:numel(f)
      f{i} = normalise(data{i});
   end

else

   n = zeros(size(data));
   for i=1:numel(f)
      [f{i} n(i)] = normalise(data{i});
   end

end

