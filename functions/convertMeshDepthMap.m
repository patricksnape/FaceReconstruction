function [grid2z] = convertMeshDepthMap(coords, gSize)
  
  maxX = max(coords(1, :));
  minX = min(coords(1, :));
  
  maxY = max(coords(2, :));
  minY = min(coords(2, :));
      
  ncoords = size(coords, 2);
  
  for i=1:ncoords
    coords(1, i) = rescale_mine(coords(1, i), maxX, minX, gSize);
    coords(2, i) = rescale_mine(coords(2, i), maxY, minY, gSize);
  end

  Fz = TriScatteredInterp(coords(1:2, :)', coords(3, :)');
  
  div = 1;
  ti = 1:div:gSize;
  [qx, qy] = meshgrid(ti);
  grid2z = Fz(qx, qy);

  clear Fz
  
  grid_size = size(grid2z, 1);
  
  minZ = min(min(grid2z));
  
  for i=1:grid_size
    grid2z(i, isnan(grid2z(i, :))) = minZ;
  end