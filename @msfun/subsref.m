function b = subsref(a,s)

switch s(1).type
case '()'
   b = a.data(s.subs{:});
case '.'
   switch s(1).subs
   case 'data'
      b = a.data;
   case 'dims'
      b = find(a.ldims);
   case 'ldims'
      b = a.ldims;
   case 'MAX_DIM'
      b = a.MAX_DIM;
   case 'variables'
      b = find(a.ldims);
   otherwise
      error('Invalid field name');
   end
case '{}'
   error('cell array subscript not supported');
otherwise
   error('Invalid subscript type');
end

% recursive call if there are more subscripts
if ~isequal(numel(s),1)
   b = subsref(b,s(2:end));
end

