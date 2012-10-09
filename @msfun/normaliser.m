function n = normaliser(fun)
% MSFUN/NORMALISER returns the value that, when subtracted from the input function, will normalise it.

data = fun.data;
n = mean(data(:));

