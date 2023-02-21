function mem_dump_load
% Show two memory dumps created with Unity
% Oct2014, JG

fid= fopen('mem_dump.dat', 'rb');
x= fread(fid, inf, 'uint16');
fclose(fid);
figure(201); clf
plot(x,'.-')

fid= fopen('mem_dump.dtx', 'rb');
y= fread(fid, inf, 'uint16');
fclose(fid);
figure(202); clf
plot(y,'.-')

figure(203); clf;
plot((x-y(1:length(x))),'.-')
figure(201)

return
