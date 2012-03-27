data_path = './Joan_AAM/02_data';

load([data_path '/03_3DMM/01_morphable_model']);

fid = fopen('C:\Research\Database\BaselFaceModel\PublicMM1\11_feature_points\MPEG4_FDP_face05.fp');

C = textscan(fid, '%s %s %s\n', 2);

C = textscan(fid, '%s %s %s %s %s %s\n', 1);

Data = textscan(fid, '%f %f %f %f %f %f %s\n', 70);

shape = double(reshape(shapeMU,3,[]));

fp1 = shape(:, Data{1}+1);

fid = fopen('C:\Research\Database\BaselFaceModel\PublicMM1\11_feature_points\Farkas_face05.fp');

C = textscan(fid, '%s %s %s\n', 2);

C = textscan(fid, '%s %s %s %s %s %s\n', 1);

Data = textscan(fid, '%f %f %f %f %f %f %s\n', 70);

shape = double(reshape(shapeMU,3,[]));

fp2 = shape(:, Data{1}+1);

%fp1 = fp1(:,[2:3, 5, 7:10, 13:20, 26:27, 29, 31, 33:35, 38:39, 45, 48:53]);
%fp2 = fp2(:,[9:13, 15, 21, 27, 37, 50:52, 57, 67]);

fp3_ind = [31993,...
           23484,...
           47411,...
           48904,...
           46126,...
           50252]';
         
fp3 = shape(:, fp3_ind);

fp = [fp1, fp2, fp3];

triangulation = delaunay(fp(1,:), fp(2,:));


figure(2);
clf;
hold on
plot3(shape(1,:), shape(2,:), shape(3,:), '*', 'MarkerSize', 0.1);
plot3(fp1(1,:), fp1(2,:), 1:length(fp1), 'square', 'MarkerFaceColor', 'red', 'Color', 'red', 'MarkerSize', 10);
%plot3(fp2(1,:), fp2(2,:), 1:length(fp2), 'square', 'MarkerFaceColor', 'green', 'Color', 'green', 'MarkerSize', 10);
%plot3(fp3(1,:), fp3(2,:), 1:length(fp3), 'square', 'MarkerFaceColor', 'yellow', 'Color', 'yellow', 'MarkerSize', 10);
hold off

figure(4);
clf;
hold on
trimesh(triangulation, fp(1,:), fp(2,:), fp(3,:)); 
hold off