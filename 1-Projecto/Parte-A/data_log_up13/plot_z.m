function plot_z(t, z, options)
% Show various time signals, collected as columns z(:,i)
%
% t : Nx1 : time range
% z : Nxm : signals to show
%
% cstr: string : (facultative) plot modifier

% Nov2013, Nov2015 (data as columns), Nov2016 (patches), Jose Gaspar
% Nov2017 (zoh), Jose Gaspar

if nargin<1
    plot_z_demo;
    return
end

if nargin<3
    options= [];
end

if isempty(t)
    x= (1:size(z,2))';
else
    x= t(:);
end

if size(z,1)~=length(x)
    error('nrows of z not matching t length')
end

if isfield(options, 'zoh')
    [x, z]= apply_zero_order_hold( x, z );
end

washold= ishold;
hold on

if isfield(options, 'plot3')
    % plot3 based display
    plot_as_plot3( x, z, options )

elseif isfield(options, 'patch')
    % patch based display
    plot_as_patches( x, z, options )

else
    % points based display
    plot_as_points( x, z, options )
end

if ~washold
    hold off
end

return; % end of main function


% -----------------------------------------------------------

function [x2, z2]= apply_zero_order_hold( x, z )
x2= []; z2= [];
for i=1:length(x)
    x2(2*i-1,1)= x(i);
    if i<length(x)
        x2(2*i,1)= x(i+1);
    else
        % 
        x2(2*i,1)= x(i);
    end
    z2(2*i-1,:)= z(i,:);
    z2(2*i,:)= z(i,:);
end


% -----------------------------------------------------------

function plot_as_points( x, y, options )
cstr= mk_cstr( options );
dy= mk_dy( y, options );

if isfield(options, 'multicolor')
    for i=1:size(y,2)
        yoffset= i+x*0;
        dy(:,i)= dy(:,i)+yoffset;
    end
    plot(x, dy, cstr);
    return
end

for i=1:size(y,2)
    yoffset= i+x*0;
    plot(x, dy(:,i)+yoffset, cstr);
end


function plot_as_plot3( x, z, options )
cstr= mk_cstr( options );

for i=1:size(z,2)
    y= i+x*0;
    plot3(x, y, z(:,i), cstr)
end

if isfield(options, 'view')
    view( options.view );
else
    view( [-17, 82] );
end


function plot_as_patches( x, y, options )
cstr= mk_cstr( options );
dy= mk_dy( y, options );

for i=1:size(dy,2)
    yoffset(i)= i;
    dy(:,i)= dy(:,i) +yoffset(i);
end

x2= [x(1); x(:); x(end)];

for i=1:size(dy,2)
    y2= [yoffset(i); dy(:,i); yoffset(i)];
    patch(x2, y2, .5*ones(1,3));
end


% -----------------------------------------------------------

function dy= mk_dy( z, options )
dy= 0.5*z/max(max(abs( z ))); % used for plot2
if isfield(options, 'kdy')
    dy= options.kdy * dy/0.5;
end


function cstr= mk_cstr( options )
if ischar( options )
    cstr= options;
elseif isfield(options, 'cstr')
    cstr= options.cstr;
else
    cstr= '.-';
end


% -----------------------------------------------------------

function plot_z_demo
% direct plot of smoothed random data
[t, y]= mk_data1;
figure(201); clf
plot_z( t, y );


function [t, y]= mk_data1
% Create random digital data (1000 points)
t= (1:1000)';
%y= (rand(5,length(t))>0.5)';
y= (conv2(rand(5,length(t)),ones(1,30)/30,'same')>0.5)'; % digital smoothed
