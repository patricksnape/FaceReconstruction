function [model msz] = load_model(model_path)
  global model;
  if isempty(model);
    model = load(model_path);
  end
  msz.n_shape_dim = size(model.shapePC, 2);
  msz.n_tex_dim   = size(model.texPC,   2);
  msz.n_seg       = size(model.segbin,  2); 
end  