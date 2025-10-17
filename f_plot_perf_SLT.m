function res=f_plot_perf_SLT(filename)
% plot the results of Sylvia's data of all trials of one day. 
% 0 is correct
% 6 is error
% 2 is break fixation
% author: Shihpi
% date: 05/21/2012
%load the data
rr=[];
if ischar(filename)
r_1=[];
r_2=[];
load(filename);
if isempty(r_1)
    rr=r_2;
else 
    rr=r_1;
end
clear r_1 r_2
else 
    rr=filename;
end
    
[x]=unique(rr(:,2))
z={};
y=[];
for i=1:length(x)
    z{i}=find(rr(:,2)==x(i));
    y(i)=length(find(rr(:,2)==x(i)));
end

figure
colo=[1 0 0;...
    0 1 0;...
    0 0 1;...
    1 1 0;...
    1 0 1;...
    0 1 1;...
    0.25 0.75 1;...
    1 0.75 0.35;...
    0.5 1 0.5;...
    0.375 0.5 0.75;...
    0.15 0.5 0.9;
    0.9 0.7 0.5];
x
for i=1:length(z)
    plot(z{i},rr(z{i},3),'-*','Color',colo(i,:));
    hold on
    x(i)
    %pause
end

a=find(rr(:,14));

axis([a(1) size(rr,1) -1 7])

res.rr=rr;
res.x=x;
res.y=y;