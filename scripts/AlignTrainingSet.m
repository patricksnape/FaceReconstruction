%% Assumes I_model exists

I_model = cell(199, 1);

for i=1:199
    I_model{i} = AlignMorphableModel(I_model{i});
end

clear i