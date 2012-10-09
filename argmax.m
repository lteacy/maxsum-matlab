function [argmx1 argmx2] = argmax(data)
% ARGMAX returns the linear indices of the first and second highest values in
% an array.
%
% Usage: argmx = argmax(data); - returns the index of the highest value only.
%
% [argmx1 argmx2] = argmax(data); - also returns the 2nd highest value index.
%

%******************************************************************************
%  If the input is an msfun object, extract the data first.
%******************************************************************************
if isobject(data)
   data = data.data;
end

%******************************************************************************
%  Use max to find the argmax
%******************************************************************************
[~, argmx1] = max(data(:));

%******************************************************************************
%  If required, do the same for the second highest value
%  Works using nanmax, which treates nans as missing values.
%******************************************************************************
if nargout>1
   
   data(argmx1)=nan;
   [~, argmx2] = nanmax(data(:));
   
end