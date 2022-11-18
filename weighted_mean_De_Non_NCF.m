function [De_weighted_mean_without_NCF,De_weighted_mean_without_NCF_Ten_Percent] = weighted_mean_De_Non_NCF(De_st)
%UNTITLED7 Summary of this function goes here
%% Without NCF:- This is to calculate without NCF or Non-NCF ED value
ED_st=De_st;

wj=1./((ED_st(:,2)./ED_st(:,1)).^2);
wjxj=wj.*ED_st(:,1);
wj_sum=sum(wj);
wjxj_sum=sum(wjxj);

ED_weighted_mean_without_NCF=wjxj_sum/wj_sum;
ED_weighted_mean_without_NCF_error=sqrt(1/wj_sum)*ED_weighted_mean_without_NCF;

ED_weighted_mean_val(:,1)=ED_weighted_mean_without_NCF;
ED_weighted_mean_val(:,2)=ED_weighted_mean_without_NCF_error;
De_weighted_mean_without_NCF=ED_weighted_mean_val;

%%
min_ten_percent_discs=floor(size(ED_st,1)*(10/100));
% if we take 10% disc of total ED data
ED_ten_percent=sum(wjxj(1:min_ten_percent_discs))/sum(wj(1:min_ten_percent_discs));
ED_ten_percent_error=sqrt(1/sum(wj(1:min_ten_percent_discs)))*ED_ten_percent;

ED_weighted_mean_ten_percent_val(:,1)=ED_ten_percent;
ED_weighted_mean_ten_percent_val(:,2)=ED_ten_percent_error;

De_weighted_mean_without_NCF_Ten_Percent=ED_weighted_mean_ten_percent_val;


end

