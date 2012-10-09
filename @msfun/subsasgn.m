function a = subasgn(a,s,b)

switch s.type
case '()'
   a.data(s.subs{:}) = b;
case '.'
   switch s.subs
   case 'data'
       a.data = b;
   case 'ldims'
       a.ldims = b;
   case 'dims'
       a.ldims = sparse(1,b,true,1,a.MAX_DIM);
   case 'variables'
       a.dims = b;
   otherwise
      error('Invalid field name');
   end
case '{}'
   error('cell array subscript not supported');
otherwise
   error('Invalid subscript type');
end
