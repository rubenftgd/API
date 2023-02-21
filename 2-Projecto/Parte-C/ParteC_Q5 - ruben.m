%% Run for full D
load D.mat
Pre = D;
Pre(Pre>0) = 0;
Post = D;
Post(Post<0) = 0;
M0 = zeros(1,29);
M0(1) = 1;
M0(16) = 1;
M0(18:29) = 1;
% M0 = M0';
[t, M, yout, linesSav, qk]= PN_sim(Pre, Post, M0, [0 10],'');

figure(201), clf;
        subplot(221); PN_device_kb_IO; % show input data
        subplot(222)
            plot_z(t, qk,'-');ylabel('Transitions fired'); xlabel('time [sec]');
            ylim([0 28]);
        subplot(223); plot_z(t,M,'-'); ylabel('place number'); xlabel('time [sec]');
        subplot(224); plot_z(t,yout,'-'); ylabel('key number'); xlabel('time [sec]');
            yticks([1 2:2:10 11:12]);
            aux = yticks;
            ytick_legends = {'0','1','3','5','7','9','*','#'};
            yticklabels(ytick_legends);
            ylim([0 12.6]);
            
%% Split Dc and Dp
Pre = Dp;
Pre(Pre>0) = 0;
Post = Dp;
Post(Post<0) = 0;