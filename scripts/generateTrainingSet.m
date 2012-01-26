clear all
close all
clc

disp('Generating Training Set...');

%% Load Morphable Model

base_morphable_model = load_model('morphable_model.mat');

%% Generate face shapes

training_set = [];

training_set.shapes = generateRandomShapes(base_morphable_model);

%% Generate normals

training_set.normals = generateShapeNormals(training_set.shapes, base_morphable_model.tl);
training_set.mean_surface_norm = mean_surface_norm(training_set.normals);

disp('Training Set Successfully Created');

