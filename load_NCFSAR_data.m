function load_NCFSAR_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Written by Rahul Kaushal,PRL - Updated : 019/03/22 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description
%     This tool enables calculation of NCF-SAR protcol to obtain
%     sensitivity corrected equivalent dose.
%     Note that this tool is still beta and quite rudimentary.

clc;
clear all; close all;
cd 

[fileName, pathName,indx] = uigetfile('*.csv','select the files you want to process','multiselect','on');

if isequal(fileName,0)
   disp('User selected Cancel');
else
   disp(['Please Note that User selected:- ',strcat(pathName,fileName)]);
end

% %------------------------------------------------------------------------
% To make the folder with Name of Results where output files will be
% stored.
str=strcat('Results');
[status, msg, msgID] = mkdir(pathName,str);
foldername=strcat(pathName,'\',str);

if ischar(fileName) 
len=size(fileName,1);
m=1;
elseif ~ischar(fileName)
   len=size(fileName,2);
   m=0;
end
% %------------------------------------------------------------------------
% This section is to load single or multiple files .csv files to processes.

for i=1:len
%     [data, text, raw]=xlsread(([pathName,'\',list(i).name]));
if m==0
[data, text, raw]=xlsread(([pathName,'\',fileName{1,i}]));
    fileName1=fileName{1,i};
elseif m==1
    [data, text, raw]=xlsread(([pathName,'\',fileName]));
    fileName1=fileName;
end

    date_only = raw(2,18:19);
    
    % s=datetime(data_only ,'dd-mm-yyyy');
    %     cal_date=datestr(date_only(1,1),'dd-mm-yyyy')
    %     exp_date=datestr(date_only(1,2),'dd-mm-yyyy');
    cal_date=date_only{1,1};
    exp_date=date_only{1,2};
    
    lamda=0.693/(28.8*365);
    NCF_Test_dose=data(1,14); %% NCF test dose
    D_rate=data(1,15); % machine dose rate
    
    
    
    %% Here, User can select any method to process the DE Vlues. 
    
    P=input('Do you want to use MCM method to calcultae De value, Enter a (Y/N)>','s');      
    
    if P=='Y'
        %% This function is used to calculate the NCF test dose.
        %     [ED,ncf_ratio,ED_NCF] = find_NCF_ED(data,NCF_Test_dose,D_rate,lamda,cal_date,exp_date);
        [De_without_NCF,ncf_ratio,De_with_NCF] = find_NCF_De_MCM(data,NCF_Test_dose,D_rate,lamda,cal_date,exp_date);
        
    else
        [De_without_NCF,ncf_ratio,De_with_NCF] = find_NCF_De_direct(data,NCF_Test_dose,D_rate,lamda,cal_date,exp_date);
        
    end
        
    
    
    %% This function is to sort the NCF test dose.
%     [ED_st,ED_NCF_st] = short_ED(ED,ED_NCF);
    [De_st,De_with_NCF_st] = short_De(De_without_NCF,De_with_NCF);
    
    %% This function is to obtain weighted mean values of NCF test dose.
    [De_weighted_mean_with_NCF,De_weighted_mean_with_NCF_Ten_Percent] = weighted_mean_De_NCF(De_with_NCF_st);
    
%     [ED_weighted_mean_val,ED_weighted_mean_ten_percent_val] = weighted_mean_De_Non_NCF(De_st);  
    [De_weighted_mean_without_NCF,De_weighted_mean_without_NCF_Ten_Percent] = weighted_mean_De_Non_NCF(De_st);
    
    %% This function is to plot histogram for withNCF and without NCF    
    
% format short g
    plot_De_hist(De_without_NCF,De_with_NCF,De_weighted_mean_with_NCF,De_weighted_mean_without_NCF,fileName,pathName)
    
    
    output=NaN(size(data,1),9);
    output=data(:,1);
    output(:,2:3)=De_without_NCF;
    output(:,4:5)=De_with_NCF;
    output(1,6:7)=De_weighted_mean_with_NCF;
    output(1,8:9)=De_weighted_mean_without_NCF;
    output(2:end,6:9)=NaN;
    output=round(output,2); %% To keep data upto 2 decimal places.
    
    
    %% Corrected data of NCF-SAR equivalent dose estimates
    data_cells=num2cell(output);% Convert data to cell array
    col_header={'Disc number','De_without NCF','De_error without NCF','De with NCF','De_error with NCF',...
        'Weighted mean_De with NCF','Weighted mean_De error with NCF','Weighted mean_De without NCF','Weighted mean_De error without NCF'}; %Row cell array (for column labels)
    %
    output_matrix=[col_header; data_cells];     %Join cell arrays
    %% Making result folder to save outputs


outputname=fileName1; 
% outputname = outputname(1:end-4)% data specific
outputname(find(outputname=='.',1,'last'):end) = [];

xlswrite(([foldername,'\', outputname,'_result_NCF_SAR.xlsx']),output_matrix,'sheet1')

% writecell(output_matrix,([foldername,'\', outputname,'_result_NCF_SAR.xlsx']),'WriteMode','overwritesheet')

% %------------------------------------------------------------------------------------% % %
% This is to setup the figure for print on A4 size paper.
x0=50;y0=10;% figure position on the A4 paper
% width=5500;height=4500; % width and height can be set here of the figure.
width=7000; height=5000; % width and height can be set here of the figure.
set(gcf,'PaperOrientation','landscape');
r = 600; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition',[x0,y0,width,height]/r);
%% This is to save figure output
% qq=([pathName,outputname,'_NCF_SAR.pdf'])
saveas(gcf,([foldername,'\',outputname,'_NCF_SAR.pdf']))    
%     close all
%     clc
 % Minimizes the figure window for the figure with handle F  % to minimize the figure
end
disp(['>>>>>>>>>> NCFSAR analysis is completed for-the', '\' outputname,'_Sample','\' 'Please check your result folder <<<<<<<<<<'])
end

