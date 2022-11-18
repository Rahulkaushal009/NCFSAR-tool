function [De_st,De_with_NCF_st] = short_De(De_without_NCF,De_with_NCF)
% For similicity changes same earlier name of variables.

%UNTITLED Summary of this function goes here
[~,idx] = sort(De_with_NCF(:,1)); % sort just the first column
De_with_NCF_st = De_with_NCF(idx,:);   % sort the whole matrix using the sort indices

[~,idx1] = sort(De_without_NCF(:,1)); % sort just the first column

De_st = De_without_NCF(idx1,:);   % sort the whole matrix using the sort indices
end

