k = size(I_model, 1);
[Un_ls, Xn_avg] = normal_pca_from_model(I_model, k, 'LS');
[Un_ip, ~] = normal_pca_from_model(I_model, k, 'IP');
[Un_aep, ~] = normal_pca_from_model(I_model, k, 'AEP');
[Un_azi, ~] = normal_pca_from_model(I_model, k, 'AZI');
[Un_ele, ~] = normal_pca_from_model(I_model, k, 'ELE');
[Un_spher, ~] = normal_pca_from_model(I_model, k, 'SPHER');
[Un_pga, ~] = normal_pca_from_model(D, k, 'PGA');