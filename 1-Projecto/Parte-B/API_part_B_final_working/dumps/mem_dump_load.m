function x= mem_dump_load( fname, options )
% Show two memory dumps created with Unity
% Oct2014, JG

if nargin<2
    options= [];
end

fid= fopen(fname, 'rb');

% tipo de dados
% x= fread(fid, inf, 'uint16');
x= fread(fid, inf, 'uint16');
fclose(fid);

x= select_data(x, options);

return


function x= select_data(x, options)

% find how to read data
if ~isfield(options, 'iniWord') && ~isfield(options, 'endWord') && ...
        ~isfield(options, 'noAutoSearch')
    x= find_data_location_and_size( x );
else
    iniWord= 1; if isfield(options, 'iniWord'); iniWord= options.iniWord; end
    endWord= inf; if isfield(options, 'endWord'); endWord= options.endWord; end
    x= truncate_data( x, iniWord, endWord )
end

return


function x= truncate_data( x, iniWord, endWord )

% truncate data if needed
if iniWord~=1 || ~isinf(endWord)
    if isinf(endWord) || endWord>length(x);
        endWord= length(x);
    end
    if iniWord<1 || iniWord>length(x)
        endWord= 1;
    end
    x= x(iniWord:endWord);
end


function x= find_data_location_and_size( x )
% find 12345 two times
ind= find(x==12345);
if isempty(ind)
    warning('data init flag not found');
    return
end

ind2= find(diff(ind)==1);
if isempty(ind2)
    warning('data init flag not found');
    return
elseif length(ind2)>1
    warning('data init flag found multiple times')
end
ind3= ind(ind2(1));

% header has the form [12345 12345 nnmmm]  nn=numLines  mmm=numColumns
header= x(ind3:ind3+2);

sz= header(3);
sz= [max(1,round(sz/1000)) rem(sz,1000)];

x= x(ind3+3:ind3+3+prod(sz)-1);
x= reshape(x, sz);

return
