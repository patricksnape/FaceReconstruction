for k=var
    [Un_aep, ~] = normal_pca_from_model(I_model, k, 'AEP');
    [Un_aep_corrupt, ~] = normal_pca_from_model(I_model_corrupt, k, 'AEP');

%     [Un_azi, ~] = normal_pca_from_model(I_model, k, 'AZI');
%     [Un_azi_corrupt, ~] = normal_pca_from_model(I_model_corrupt, k, 'AZI');
% 
%     [Un_ele, ~] = normal_pca_from_model(I_model, k, 'ELE');
%     [Un_ele_corrupt, ~] = normal_pca_from_model(I_model_corrupt, k, 'ELE');

    [Un_ip, ~] = normal_pca_from_model(I_model, k, 'IP');
    [Un_ip_corrupt, ~] = normal_pca_from_model(I_model_corrupt, k, 'IP');

    [Un_ls, ~] = normal_pca_from_model(I_model, k, 'LS');
    [Un_ls_corrupt, ~] = normal_pca_from_model(I_model_corrupt, k, 'LS');

    if exist('D', 'var')
        [Un_pga, ~] = normal_pca_from_model(D, k, 'PGA');
        [Un_pga_corrupt, ~] = normal_pca_from_model(D_corrupt, k, 'PGA');
    end

    [Un_spher, ~] = normal_pca_from_model(I_model, k, 'SPHER');
    [Un_spher_corrupt, ~] = normal_pca_from_model(I_model_corrupt, k, 'SPHER');

    for i=1:k
        for j=1:k

            aep(p, k) = aep(p, k) + (dot(Un_aep(:, i), Un_aep_corrupt(:, j)) ^ 2);
%             azi(p, k) = azi(p, k) + (dot(Un_azi(:, i), Un_azi_corrupt(:, j)) ^ 2);
%             ele(p, k) = ele(p, k) + (dot(Un_ele(:, i), Un_ele_corrupt(:, j)) ^ 2);
            ip(p, k) = ip(p, k) + (dot(Un_ip(:, i), Un_ip_corrupt(:, j)) ^ 2);
            ls(p, k) = ls(p, k) + (dot(Un_ls(:, i), Un_ls_corrupt(:, j)) ^ 2);
            if exist('D', 'var')
                pga(p, k) = pga(p, k) + (dot(Un_pga(:, i), Un_pga_corrupt(:, j)) ^ 2);
            end
            spher(p, k) = spher(p, k) + (dot(Un_spher(:, i), Un_spher_corrupt(:, j)) ^ 2);
        end
    end
end