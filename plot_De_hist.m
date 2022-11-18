function [] = plot_De_hist(De_without_NCF,De_with_NCF,De_weighted_mean_with_NCF,De_weighted_mean_without_NCF,fileName,pathName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
outputname=fileName;
ED=De_without_NCF;
ED_NCF=De_with_NCF;

outputname='Final Plot comparison';
figure('Name',outputname,'units','normalized','outerposition',[0 0 1 1]);
% figure('units','normalized','outerposition',[0 0 1 1]) 
set(gca, 'Units','normalized');
set(gcf, 'color', [1 1 1]);
hold on;
%histogram(ED_NCF_st(:,1))
%Plot-1
%%
%% Calculating optimal number of bins in a histogram
% The Freedman-Diaconis rule is very robust and works well in practice. 
% The bin-width is set to h=2×IQR×n−1/3. So the number of bins is (max−min)/h, 
% where n is the number of observations, max is the maximum value and min is the minimum value.
% Calculation details
x =ED(:,1);
   
h = diff(prctile(x, [25; 75])); %inter-quartile range
if h == 0
    h = 2*median(abs(x-median(x))); % twice median absolute deviation
end
if h > 0
    nbins = ceil((max(x)-min(x))/(2*h*length(x)^(-1/3)));
else
    nbins = 1;
end
%% 

% nBins=14;
nBins=nbins
edges=(linspace(min(ED(:,1)),max(ED(:,1)),nBins));
title('Without NCF')
xlabel('Equivalent Dose [Gy]','FontWeight','bold','FontName','Helvetica','color',[0 0 0]);
ylabel({'Number of Aliquots'},'FontWeight','bold','FontName','Helvetica','color','black') % label left y-axis
set(gca,'FontSize',16);

% min_x1=min((ED(:,1)))
min_x1=0;
max_x1=ceil(max((ED(:,1)))+10);

% interval=
set(gca,'XLim',[min_x1 max_x1])
% set(gca,'XLim',min_x1:10:max_x1);
title('With NCF')
xlabel('Equivalent Dose [Gy]','FontWeight','bold','FontName','Helvetica','color',[0 0 0]);
ylabel({'Number of Aliquots'},'FontWeight','bold','FontName','Helvetica','color','black') % label left y-axis
set(gca,'FontSize',16);

set(gca,'XLim',[min_x1 max_x1]) 

%% Plot
% Plot-3
subplot(2,2,1); % Right subplot
yyaxis left
h3=histogram(ED(:,1),edges);
title('Without NCF')
ylabel({'Number of Aliquots'},'FontWeight','bold','FontName','Helvetica') % label left y-axis
set(gca,'FontSize',16);
ax = gca; % Get handle to current axes.
set(gca,'XLim',[min_x1 max_x1]) 
yyaxis right
plot((ED(:,1)),(ED(:,2)),'o','color',[0.85,0.33,0.10]);
ax = gca; % Get handle to current axes.
% ax.XColor = 'k'; % black
% ax.YColor = 'k'; % black
xlabel('Equivalent Dose [Gy]','FontWeight','bold','FontName','Helvetica','color',[0 0 0]);
% ylabel({'Standard Error'},'FontWeight','bold','FontName','Helvetica','color','red') % label left y-axis
ylabel({'Standard Error'},'FontWeight','bold','FontName','Helvetica') % label left y-axis
set(gca,'FontSize',16);

%% Set limit of Y axis for the ED_NCF plot
min_yy=0;
max_yy_ED=ceil(max(ED(:,2)));
set(gca,'YLim',[min_yy max_yy_ED]); 
a='±';
format short g
De_weighted_mean_without_NCF=round (De_weighted_mean_without_NCF,2);% Two decimal display
De_weighted_mean_with_NCF=round(De_weighted_mean_with_NCF,2);
annotation('textbox', [0.13, 0.44, 0, 0], 'string', {['De weighted mean',' without NCF=',[num2str(De_weighted_mean_without_NCF(1,1))],a,[num2str(De_weighted_mean_without_NCF(1,2))]]},'FontSize',16,'FitBoxToText','on');
annotation('textbox', [0.587, 0.44, 0, 0], 'string', {['De weighted mean',' with NCF=',[num2str(De_weighted_mean_with_NCF(1,1))],a,[num2str(De_weighted_mean_with_NCF(1,2))]]},'FontSize',16,'FitBoxToText','on');

%%
% Plot-4
subplot(2,2,2); % Right subplot
yyaxis left

h4=histogram(ED_NCF(:,1),edges);
title('Without NCF')
% ylabel({'Number of Aliquots'},'FontWeight','bold','FontName','Helvetica','color','red') % label left y-axis
ylabel({'Number of Aliquots'},'FontWeight','bold','FontName','Helvetica') % label left y-axis
set(gca,'FontSize',16);
set(gca,'XLim',[min_x1 max_x1]) 

yyaxis right
plot((ED_NCF(:,1)),(ED_NCF(:,2)),'o','color',[0.85,0.33,0.10]);
title('With NCF')
ax = gca; % Get handle to current axes.
xlabel('Equivalent Dose [Gy]','FontWeight','bold','FontName','Helvetica','color',[0 0 0]);
ylabel({'Standard Error'},'FontWeight','bold','FontName','Helvetica') % label left y-axis
set(gca,'FontSize',16);

%% Set limit of Y axis for the ED_NCF plot
min_yy=0;
max_yy_ED_NCF=ceil(max(ED_NCF(:,2)));
set(gca,'YLim',[min_yy max_yy_ED_NCF]);
set(gca,'YLim',[min_yy max_yy_ED_NCF]); 
end

