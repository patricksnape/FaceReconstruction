%% Assumes I_model exists

for i=1:199
    shape = I_model{i}.shape;
    I_model{i}.aligned = AlignFace(I_model{i}.normBuffer, ...
                                   shape(1,2), ... % Nose Y
                                   shape(2,2), ... % Left Eye Y
                                   shape(3,2), ... % Right Eye Y
                                   shape(4,2), ... % Chin Y
                                   shape(1,1), ... % Nose X
                                   shape(2,1), ... % Left Eye X
                                   shape(3,1), ... % Right Eye X
                                   shape(4,1));    % Chin X
end