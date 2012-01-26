function [eVec_pos , eval_pos, eVec_neg, eval_neg ]=F_EigenSys_f(M);
%
% Syntax: [eVec_pos , eVal_pos, eVec_neg, eVal_neg]=F_EigenSys(M);
% - Eigen values and vectors of M, sorted by decreasing eigen values.
%
% Stefanos Zafeiriou
%

e = 10^-12;

[eVec,eVal]=eig(M);
eVal=diag(eVal)';

[eVal,Index]=sort(eVal);
eVal=fliplr(eVal);
eVec=fliplr(eVec(:,Index));

%%%%%%%%%find positive and negative eigenvalues eigenvectors%%%%%

index_neg = find(eVal<0);
index_pos = find(eVal>0);

eVec_pos = eVec(:,index_pos);
eval_pos = eVal(index_pos);

eval_neg = eVal(index_neg);
eVec_neg = eVec(:,index_neg);

max_eval_limit = max([max(eval_pos)*e max(abs(eval_neg))*e]); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%find the non-zero positive eigevalues-eigenvectors%%%%%%
%max_eval_pos_limit = max(eval_pos)*e; 
index              = find(eval_pos>max_eval_limit); %look if the correct eigenvectors
eval_pos           = eval_pos(index);
eVec_pos           = eVec_pos(:,index);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%find the non-zero negative eigevalues-eigenvectors%%%%%%%%%%
%max_eval_neg_limit = max(abs(eval_neg))*e; 
index              = find(abs(eval_neg)>max_eval_limit); %look if the correct eigenvectors
eval_neg           = eval_neg(index);
eVec_neg           = eVec_neg(:,index);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%sort them again %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[e1      ,index]   = sort(abs(eval_neg));
eval_neg           = eval_neg(index);
eVec_neg           = eVec_neg(:,index);
eval_neg           =fliplr(eval_neg);
eVec_neg           =fliplr(eVec_neg);
i=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
