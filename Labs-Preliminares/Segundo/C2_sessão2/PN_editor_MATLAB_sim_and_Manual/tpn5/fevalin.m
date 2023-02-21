function varargout = fevalin(path, varargin)
oldfolder = cd(path);
[varargout{:}] = feval(varargin{:});
cd(oldfolder);
