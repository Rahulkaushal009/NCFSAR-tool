function [De_without_NCF,ncf_ratio,De_with_NCF] = find_NCF_De_MCM(data,NCF_Test_dose,D_rate,lamda,cal_date,exp_date)
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

%%
% Now apply MC to incormorate the errors in a,b,c as well and calculate the x and xe. 
%----% let's do it for one sample first. 
% Generate MC simulations. 

M = 10000; % Number of samples in the MonteCarlo sampling
% M = 1000000; % Number of samples in the MonteCarlo sampling
%%
gmac_y = zeros(M, 1); % To store data
gmac_a = zeros(M, 1); % To store data
gmac_b = zeros(M, 1); % To store data
gmac_c = zeros(M, 1); % To store data
gmac_x=zeros(M, 1);   % To store  data

% mu and delta to genrate the MC
mu_y=y;
delta_y=ye;

mu_a=a;
delta_a=ae;

mu_b=b;
delta_b=be;

mu_c=c;
delta_c=ce;

for i=1:length(y)
gmac_y(:,i)= normrnd(mu_y(i,1), delta_y(i,1), [M, 1]);
gmac_a(:,i)= normrnd(mu_a(i,1), delta_a(i,1), [M, 1]);
gmac_b(:,i)= normrnd(mu_b(i,1), delta_b(i,1), [M, 1]);
gmac_c(:,i)= normrnd(mu_c(i,1), delta_c(i,1), [M, 1]);

% disp(gmac_a)
% % figure(1)
% % subplot(2,2,1)
% % histogram(gmac_y(:,i), 50)
% % title('Subplot 1: y')
% % subplot(2,2,2)
% % histogram(gmac_a(:,i), 50)
% % title('Subplot 2: a')
% % subplot(2,2,3)
% % histogram(gmac_b(:,i), 50)
% % title('Subplot 3: b')
% % subplot(2,2,4)
% % histogram(gmac_c(:,i), 50)
% % title('Subplot 4: c')

gmac_x(:,i)=log(1-gmac_y(:,i)./gmac_a(:,i)).*(-gmac_b(:,i))-gmac_c(:,i);



mean_gmac_x(:,i)=mean(gmac_x(:,i));  % % compute Mean

std_gmac_x(:,i)=std(gmac_x(:,i));   % compute Standard deviation

end


mean_gmac_x=mean_gmac_x';
std_gmac_x=std_gmac_x';
% saving to these variable because i used them earlier for simplicity.
x1ED_s=mean_gmac_x;
x1ED_s_error=std_gmac_x;

%% Correcting EDs %% Now no need of this as we are uisng Monte carlo method for  
x1ED_s1=log(1-NCF_corrected_LxTx./a).*(-b)-c;

x1ED_s_error1=(((log(1-((NCF_corrected_LxTx+NCF_corrected_LxTx_error)./a)).*(-b))-c)...
    -((log(1-((NCF_corrected_LxTx-NCF_corrected_LxTx_error)./a)).*(-b))-c))/2;

%% In case, error becomes complex double due to log of negative data of MCM process. 
if isreal(gmac_x)==0
  x1ED_s= x1ED_s1;
  x1ED_s_error=x1ED_s_error1;
else
   x1ED_s= x1ED_s;
  x1ED_s_error=x1ED_s_error;     
    
end

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
