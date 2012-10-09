function p = msfun(varargin)

MAX_DIM = 500; % maximum dimension id of any function.
MAX_DEP = 20;  % maximum number od dimensions any one function can depend on.

checkorder = true;

switch nargin
case 0

   % logical dimensions. p.dims no returns find(p.ldims) for backward compatibility.
   p.ldims = spalloc(1,MAX_DIM,0);

   p.MAX_DIM = MAX_DIM;
   
   % the data
   p.data = 0;

   % the object
   p = class(p,'msfun');

case 1

   inS = varargin{1};

   if isfield(inS,'ldims')
      s.ldims = inS.ldims;

   elseif isfield(inS,'dims')

      % ensure dimensions are sorted in correct order
      [sortedDims order] = sort(inS.dims);
      if ~isequal(sortedDims,pdims)
         p.data = permute(p.data,order);
      end

      s.ldims = sparse(1,sortedDims,true,1,MAX_DIM);

   else
      error('dims not specified in structure');
   end

   s.MAX_DIM = MAX_DIM;
   s.data = inS.data;
   p = class(s,'msfun');

case 2
   
   pdims = varargin{1};
   pdata = varargin{2};

   if islogical(varargin{1})
      p.ldims = varargin{1};
   else

      % ensure dimensions are sorted in correct order
      [sortedDims order] = sort(pdims);
      if ~isequal(sortedDims,pdims)
         pdata = permute(pdata,order);
      end

      p.ldims = sparse(1,pdims,true,1,MAX_DIM);

   end
   p.MAX_DIM = MAX_DIM;
   p.data = pdata;
   p = class(p,'msfun');

case 3
   
   pdims = varargin{1};
   pdata = varargin{2};
   
   if islogical(varargin{1})
      p.ldims = varargin{1};
   else

      % ensure dimensions are sorted in correct order
      pdims = varargin{1};
      if varargin{3}
         [sortedDims order] = sort(pdims);
         if ~isequal(sortedDims,pdims)
            pdata = permute(pdata,order);
         end
      end

      p.ldims = sparse(1,pdims,true,1,MAX_DIM);

   end

   p.MAX_DIM = MAX_DIM;
   p.data = pdata;
   p = class(p,'msfun');

otherwise
   error('wrong number of arguments');
end

% Unless the data is a vector, the no. dimensions must match
if ~isvector(p.data) && ~isequal(ndims(p.data),nnz(p.ldims))
   error('number of dimensions must match.');

elseif isvector(p.data)
   % Otherwise the number of dimensions can be 1 or 2.
   if nnz(p.ldims)>2
      error('number of dimensions must match.');
   end

   % if only one dimension is significant, make it the first.
   if isequal(nnz(p.ldims),1)
      p.data =  reshape(p.data,[numel(p.data) 1]);
   end
end


