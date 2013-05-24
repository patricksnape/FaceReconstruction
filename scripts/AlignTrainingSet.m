%% Assumes I_model exists

for i=1:199
    I_model{i} = AlignMorphableModel(I_model{i});
end

clear i