function kb_tst(tstId)
if nargin<1
    tstId= 2;
end

switch tstId
    case 2
        if ~exist('KB_READ.RDP', 'file')
		    error('please create your Petri net and save it as file "KB_READ.RDP"');
		end
		[Pre, Post, M0] = rdp('KB_READ.RDP');
        [t, M, yout]= PN_sim(Pre, Post, M0, [0 10]);

        figure(201), clf;
        subplot(221); PN_device_kb_IO; % show input data
        subplot(223); plot_z(t,M,'-'); ylabel('place number'); xlabel('time [sec]');
        subplot(224); plot_z(t,yout,'-'); ylabel('key number'); xlabel('time [sec]');

    otherwise
        error('invalid tstId')
end

return
