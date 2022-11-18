function [De_weighted_mean_with_NCF,De_weighted_mean_with_NCF_Ten_Percent] = weighted_mean_De_NCF(De_with_NCF_st)
%UNTITLED7 Summary of this function goes here
%% calculate Weighted Mean of EDs with NCF and without NCF [SEE if required or not]
ED_NCF_st=De_with_NCF_st;

% if using CAM/MAM model then there is no need to get this. 
wi=1./((ED_NCF_st(:,2)./ED_NCF_st(:,1)).^2);
wixi=wi.*ED_NCF_st(:,1);
% Weighted Mean for ED with NCF
wi_sum=sum(wi);
wixi_sum=sum(wixi);
%% Results of Weighted Means
ED_weighted_mean_NCF=(wixi_sum/wi_sum);

ED_weighted_mean_NCF_error=sqrt(1/wi_sum)*ED_weighted_mean_NCF;


ED_weighted_mean_NCF_val(:,1)=ED_weighted_mean_NCF;
ED_weighted_mean_NCF_val(:,2)=ED_weighted_mean_NCF_error;
% To display in Command Window for user.
De_weighted_mean_with_NCF=ED_weighted_mean_NCF_val;

%%
min_ten_percent_discs=floor(size(ED_NCF_st,1)*(10/100));

wi_ten_percent=sum(wi(1:min_ten_percent_discs));
wixi_ten_percent=sum(wixi(1:min_ten_percent_discs));
% if we take 10% disc of total ED data
ED_weighted_mean_ten_percent=wixi_ten_percent/wi_ten_percent;
ED_weighted_mean_ten_percent_error=sqrt(1/wi_ten_percent)*ED_weighted_mean_ten_percent;

ED_weighted_mean_NCF_ten_percent_val(:,1)=ED_weighted_mean_ten_percent;
ED_weighted_mean_NCF_ten_percent_val(:,2)=ED_weighted_mean_ten_percent_error;

De_weighted_mean_with_NCF_Ten_Percent=ED_weighted_mean_NCF_ten_percent_val;
% % figure(2)
% % varargout={ED_weighted_mean_NCF_val};
% % xlabel('MC generated X data');
% % ylabel('Frequency');
% % title( sprintf( 'weighted_mean_NCF = %g, weighted_mean_without_NCF = %g,', varargout{:} ) );




end

