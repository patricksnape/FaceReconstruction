data_path = './Joan_AAM/02_data';

load([data_path '/03_3DMM/01_morphable_model']);

fid = fopen([data_path '/03_3DMM/MPEG4_FDP.fp']);

C = textscan(fid, '%s %s %s\n', 2);

C = textscan(fid, '%s %s %s %s %s %s\n', 1);

Data = textscan(fid, '%f %f %f %f %f %f %s\n', 70);

shape = double(reshape(shapeMU,3,[]));

fp1 = shape(:, Data{1}+1);

index1 = [2:4,6:10, 13:17, 18:20, 26:27, 29:30, 32:35, 38:39, 48:49, 50:53];

fp1 = fp1(:,index1);

fp1_ind = Data{1}(index1);



fid = fopen([data_path '/03_3DMM/Farkas.fp']);

C = textscan(fid, '%s %s %s\n', 2);

C = textscan(fid, '%s %s %s %s %s %s\n', 1);

Data = textscan(fid, '%f %f %f %f %f %f %s\n', 70);

shape = double(reshape(shapeMU,3,[]));

fp2 = shape(:, Data{1}+1);

index2 = [9, 12:13, 18, 26:27, 50:51, 56:57];

fp2 = fp2(:,index2);

fp2_ind = Data{1}(index2);



fp3_ind = [31993,...
           23484,...
           47411,...
           48904,...
           46126,...
           50252,...
           25071,...
           30230]';
         
fp3 = shape(:, fp3_ind);



fp = [fp1, fp2, fp3];
fp_ind = [fp1_ind; fp2_ind; fp3_ind];

triangulation = delaunay(fp(1,:), fp(2,:));
triangulation = triangulation([1:13, 15:59, 61:end],:);


figure(2);
clf;
hold on
plot3(shape(1,:), shape(2,:), shape(3,:), '*', 'MarkerSize', 0.1);
plot3(fp1(1,:), fp1(2,:), fp1(3,:), 'square', 'MarkerFaceColor', 'red', 'Color', 'red', 'MarkerSize', 10);
plot3(fp2(1,:), fp2(2,:), fp2(3,:), 'square', 'MarkerFaceColor', 'green', 'Color', 'green', 'MarkerSize', 10);
plot3(fp3(1,:), fp3(2,:), fp3(3,:), 'square', 'MarkerFaceColor', 'yellow', 'Color', 'yellow', 'MarkerSize', 10);
hold off

figure(3);
clf;
hold on
trimesh(triangulation, fp(1,:), fp(2,:), fp(3,:)); 
hold off



fp = fp_ind;



save([data_path '/03_3DMM/fp.mat'], 'fp');
save([data_path '/01_training/02_synthetic/02_triangulations/t1.mat'], 'triangulation');


