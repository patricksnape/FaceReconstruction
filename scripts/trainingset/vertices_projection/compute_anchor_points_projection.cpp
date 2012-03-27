#include <math.h>
#include <matrix.h>
#include <mex.h>

static int myround(double number) {
    return (number >= 0) ? (int)(number + 0.5) : (int)(number - 0.5);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  
  //------------------------------- GATEWAY -------------------------------
  
  //declare variables
  mxArray *a_in_m, *b_in_v, *c_out_m;
  double  *vertices, *resolution, *xy;
  int numdims;

  //associate inputs
  a_in_m = mxDuplicateArray(prhs[0]);
  b_in_v = mxDuplicateArray(prhs[1]);
  
  //associate pointers to the data in the input mxArray
  vertices = mxGetPr(a_in_m);
  resolution = mxGetPr(b_in_v);
  
  const mwSize *dims;
  int n_vertices;
  
  dims = mxGetDimensions(prhs[0]);
  n_vertices = (int) dims[1];
  
  //associate outputs
  c_out_m = plhs[0] = mxCreateDoubleMatrix(3,n_vertices,mxREAL);
  
  //associate pointers to the data in the output mxArray
  xy = mxGetPr(c_out_m);
  
  //-----------------------------------------------------------------------
  
  
  //-------------------------------- CODE ---------------------------------
  
  //declare variables
  mxArray *f_temp_m, *g_temp_m;
  double *z_buffer, *p_buffer;
  int width, height;
  double w_step, h_step, ratio;
  
  width = (int) resolution[1];
  height = (int) resolution[0];
  
  if (height >= width) {
    ratio=(double)width/(double)height;
    h_step = 2.0 / height; 
    w_step = 2.0 / height;
  }
  else{
    ratio=(double)height/(double)width;
    w_step = 2.0 / width;
    h_step = 2.0 / width;
  } 

  f_temp_m = mxCreateDoubleMatrix(width,height,mxREAL);
  z_buffer = mxGetPr(f_temp_m);
  
  g_temp_m = mxCreateDoubleMatrix(width,height,mxREAL);
  p_buffer = mxGetPr(g_temp_m);
  
  for (int i=0; i<width*height; i++) {
    z_buffer[i] = mxGetInf();
  }
  
  //declare variables
  int x, y;
  double v[4];
  
  for (int i=0; i<n_vertices; i++) {
      
    v[0] = vertices[0+i*4];
    v[1] = vertices[1+i*4];
    v[2] = vertices[2+i*4];
    v[3] = vertices[3+i*4];
    
    if (height >= width) {
      y = (int) myround((v[1] + 1) / h_step);
      x = (int) myround((v[0] + ratio) / w_step);
    }
    else{
      y = (int) myround((v[1] + ratio) / h_step);
      x = (int) myround((v[0] + 1) / w_step);
    }        

    if(x>=width || x<0 || y>=height || y<0) continue;
    
    if (z_buffer[y+x*height] > v[2]) {
      
      z_buffer[y+x*height] = v[2];

      xy[0+i*3] = x+1;
      xy[1+i*3] = y+1;
      xy[2+i*3] = v[2];
    }
  }
}
