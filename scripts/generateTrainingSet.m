clear all
close all
clc

disp('Generating Training Set...');

%% Load Morphable Model

load('morphable_model.mat');

%% Generate face shapes

training_set = [];

training_set.shapes = generateRandomShapes(model);

%% Generate normals

training_set.normals = generateShapeNormals(training_set.shapes, model.triangleArray);
training_set.mean_surface_norm = mean_surface_norm(training_set.normals);

disp('Training Set Successfully Created');

