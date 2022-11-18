function [De_without_NCF,ncf_ratio,De_with_NCF] = find_NCF_De_direct(data,NCF_Test_dose,D_rate,lamda,cal_date,exp_date)
%UNTITLED Summary of this function goes here

cal_da=str2num(cal_date(1:2));
cal_mo=str2num(cal_date(4:5));
cal_ye=str2num(cal_date(7:10));
% formatIn = 'dd-mmm-yyyy';
formatOut = 'dd-MM-yyyy';
t1=datetime(cal_ye,cal_mo,cal_da);
t1.Format=formatOut;

% DateString1=exp_date;
expp_da=str2num(exp_date(1:2));
expp_mo=str2num(exp_date(4:5));
expp_ye=str2num(exp_date(7:10));
% t2=datenum(DateString1,formatIn);

t2=datetime(expp_ye,expp_mo,expp_da);
t2.Format=formatOut;
num_days =days(t2-t1)

% NumDays_way2 = daysact(t1,  t2);
% num_days = between(calibration_date1,NCF_experiment_date1,{'days'});
% num_days = caldays(num_days);

%% Extract column of ED data 
EDsar_s=data(:,2);
EDsar_error=data(:,3);


EDSar_s_without_NCF=(EDsar_s-NCF_Test_dose);
EDSar_s_without_NCF_error=EDsar_error.*((EDsar_s-NCF_Test_dose)./EDsar_s);

%% Converting second to Gy unit
EDSar_Gy_without_NCF=((EDSar_s_without_NCF)/60).*(D_rate*(exp(-lamda*num_days)));
EDSar_Gy_without_NCF_error=((EDSar_s_without_NCF_error)/60).*(D_rate*(exp(-lamda*num_days)));
%%
% Integrated TL Peaks 
ncf_peak_TL_1=data(:,4);
ncf_peak_TL_2=data(:,5);
ncf_peak_TL_1_error=sqrt(ncf_peak_TL_1);
ncf_peak_TL_2_error=sqrt(ncf_peak_TL_2);

ncf_ratio=(ncf_peak_TL_2./ncf_peak_TL_1); %% NCF ratio that will be used for correction factor
%%
LxTx=data(:,6);
LxTx_error=data(:,7);

% NCF corrected step
NCF_corrected_LxTx=LxTx.*ncf_ratio;
NCF_corrected_LxTx_error=sqrt(((LxTx_error./LxTx).^2)+((ncf_peak_TL_1_error./ncf_peak_TL_1).^2)...
+((ncf_peak_TL_2_error./ncf_peak_TL_2).^2)).*NCF_corrected_LxTx; % Error Propagation



%%
% Parameters to be used for calculating Corrected EDs.
y=NCF_corrected_LxTx;
ye=NCF_corrected_LxTx_error;
a=data(:,8);
ae=data(:,9);
b=data(:,10);
be=data(:,11);
c=data(:,12);
ce=data(:,13);
% saving to these variable because i used them earlier for simplicity.


%% Correcting EDs %% Now no need of this as we are uisng Monte carlo method for  
x1ED_s1=log(1-NCF_corrected_LxTx./a).*(-b)-c;

x1ED_s_error1=(((log(1-((NCF_corrected_LxTx+NCF_corrected_LxTx_error)./a)).*(-b))-c)...
    -((log(1-((NCF_corrected_LxTx-NCF_corrected_LxTx_error)./a)).*(-b))-c))/2;

x1ED_s=x1ED_s1;
x1ED_s_error=x1ED_s_error1;
%% Do minus of given NCF dose from NCF corrected doses just above uisng MC method. 


NCF_TD_corrected_s=x1ED_s-NCF_Test_dose; % In second unit
NCF_TD_corrected_s_error=x1ED_s_error.*(x1ED_s-NCF_Test_dose)./x1ED_s; % In second unit

%%
%Finally We calculate   ED_with NCF in Gy units
ED_with_NCF_Gy=((NCF_TD_corrected_s)/60).*(D_rate*(exp(-lamda*num_days)));
ED_with_NCF_Gy_error=((NCF_TD_corrected_s_error)/60).*(D_rate*(exp(-lamda*num_days)));
%%
ED_NCF(:,1)=ED_with_NCF_Gy;
ED_NCF(:,2)=ED_with_NCF_Gy_error;
De_with_NCF=ED_NCF;

%%
ED(:,1)=EDSar_Gy_without_NCF;
ED(:,2)=EDSar_Gy_without_NCF_error;
De_without_NCF=ED;
%%

end
