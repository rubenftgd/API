function [qk,linesSav]= PN_tfire(act, t, linesSav)

% plot signals
% if nargin<=1
%     if nargin==0, act= [0 3]; end
%     qk = demo(act)
%     return
% % end
% else
% initialize qk vector
qk = zeros(1,27);

qk(1) = sin(2*pi*1*(t-1))>0.8;
qk(2) = sin(2*pi*1*(t-1-0.3))>0.8;
qk(3) = sin(2*pi*1*(t-1-0.6))>0.8;

% keyboard inputs at each instant
lines = PN_device_kb_IO(act,t);
if t == 0
    linesSav = [lines];
else
    linesSav = vertcat(linesSav,[lines]);
end
% if more than one in lines-->error
% else
if act == [1 0 0]
    qk(4:7) = double(lines);
    qk(16:19) = double(not(lines));
elseif act == [0 1 0]
    qk(8:11) = double(lines);
    qk(20:23) = double(not(lines));
elseif act == [0 0 1]
    qk(12:15) = double(lines);
    qk(24:27) = double(not(lines));    
end



function qk = demo(act)
t= linspace(act(1),act(2))';
qk= PN_tfire([], t);
plot_z(t, qk);
xlabel('time [sec]')
ylabel('trans input')
