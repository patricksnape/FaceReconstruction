#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <iostream>

using namespace std;

template <class T> 
T min (T *a, int num_elements) {
  int i;
  T min = a[0];
  for (i=1; i<num_elements; i++) {
    if (a[i]<min) {
	    min=a[i];
    }
  }
  return min;
}

template <class T> 
T max (T *a, int num_elements) {
  int i;
  T max = a[0];
  for (i=1; i<num_elements; i++) {
    if (a[i]>max) {
	    max=a[i];
    }
  }
  return max;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  
  //------------------------------- GATEWAY -------------------------------
  
  //declare variables
  mxArray *a_in_m, *b_in_m, *c_in_v, *d_out_m;
  double *triangle_list, *vertices, *resolution, *z_buffer;
  int dimx, dimy, numdims;
  
  //associate inputs
  a_in_m = mxDuplicateArray(prhs[0]);
  b_in_m = mxDuplicateArray(prhs[1]);
  c_in_v = mxDuplicateArray(prhs[2]);
  
  //associate pointers to the data in the input mxArray
  triangle_list = mxGetPr(a_in_m);
  vertices = mxGetPr(b_in_m);
  resolution = mxGetPr(c_in_v);
  
  //associate outputs
  d_out_m = plhs[0] = mxCreateDoubleMatrix((int)resolution[0],(int)resolution[1],mxREAL);
  
  //associate pointers to the data in the output mxArray
  z_buffer = mxGetPr(d_out_m);
  
  //-----------------------------------------------------------------------
  
  
  //-------------------------------- CODE ---------------------------------
  
  //declare variables
  mxArray *g_temp_m;
  int width, height, n_triangles, n_vertices;
  double w_step, h_step, ratio;
  const mwSize *dims2, *dims3;
  
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
  
  dims2 = mxGetDimensions(prhs[0]);
  numdims = mxGetNumberOfDimensions(prhs[0]);
  n_triangles = (int) dims2[1];
  
  dims3 = mxGetDimensions(prhs[1]);
  numdims = mxGetNumberOfDimensions(prhs[1]);
  n_vertices = (int) dims3[1];
  
  for (int i=0; i<width*height; i++) {
    z_buffer[i] = mxGetInf();
  }

  int i0,i1,i2;
  double v0[4],v1[4],v2[4], c0[4],c1[4],c2[4];
  int n = height*width, n2 = 2*n;
  
  //declare variables
  double alpha_1, alpha_2, alpha_3, beta_1, beta_2, beta_3, alpha_q, beta_q, u[3], v[3], u_max, u_min, v_max, v_min, x_start, x_end, y_start, y_end, p_x, p_y, alpha23, beta23, alpha, beta, gamma, z;
  
  for (int i=0; i<n_triangles; i++) {
   
    i0 = (int)(triangle_list[0+i*3]-1);
    i1 = (int)(triangle_list[1+i*3]-1);
    i2 = (int)(triangle_list[2+i*3]-1);
      
    v0[0] = vertices[0+i0*4];
    v0[1] = vertices[1+i0*4];
    v0[2] = vertices[2+i0*4];
    v0[3] = vertices[3+i0*4];
      
    v1[0] = vertices[0+i1*4];
    v1[1] = vertices[1+i1*4];
    v1[2] = vertices[2+i1*4];
    v1[3] = vertices[3+i1*4];
      
    v2[0] = vertices[0+i2*4];
    v2[1] = vertices[1+i2*4];
    v2[2] = vertices[2+i2*4];
    v2[3] = vertices[3+i2*4];
    
    alpha_1 = v1[1] - v2[1];
    alpha_2 = v2[0] - v1[0];
    alpha_3 = v1[0] * v2[1] - v2[0] * v1[1];

    beta_1 = v0[1] - v2[1];
    beta_2 = v2[0] - v0[0];
    beta_3 = v0[0] * v2[1] - v2[0] * v0[1];
 
    alpha_q = alpha_1 * v0[0] + alpha_2 * v0[1] + alpha_3;
    beta_q = beta_1 * v1[0] + beta_2 * v1[1] + beta_3;
      
    u[0] = v0[0];
    u[1] = v1[0];
    u[2] = v2[0];
    
    v[0] = v0[1];
    v[1] = v1[1];
    v[2] = v2[1];
            
    u_max = max(u,3);
    u_min = min(u,3);
    v_max = max(v,3);
    v_min = min(v,3);
    
    if (height >= width) {
      x_start = floor((u_min + ratio) / w_step);
      x_end = ceil((u_max + ratio) / w_step);
      y_start = floor((v_min + 1) / h_step);
      y_end = ceil((v_max + 1) / h_step);
      p_y = -1 + y_start * h_step;
    }
    else{
      x_start = floor((u_min + 1) / w_step);
      x_end = ceil((u_max + 1) / w_step);
      y_start = floor((v_min + ratio) / h_step);
      y_end = ceil((v_max + ratio) / h_step);
      p_y = -ratio + y_start * h_step;
    }        
     
    for (int y=(int)y_start; y<= y_end; y++) {
    
      p_y = p_y + h_step;
    
      if (height >= width) {
          p_x = -ratio + x_start * w_step;
      }
      else{
          p_x = -1 + x_start * w_step;
      }        
      
      alpha23 =  alpha_2 * p_y + alpha_3;
      beta23 =  beta_2 * p_y + beta_3;
       
      for (int x=(int)x_start; x<= x_end; x++) {
      
        p_x = p_x + w_step;
         
        alpha = (alpha_1 * p_x + alpha23) / alpha_q;
        beta = (beta_1 * p_x + beta23) / beta_q;
        gamma = 1 - alpha - beta;

        if ((0 <= alpha) && (alpha <= 1) && (0 <= beta) && (beta <= 1) && (0 <= gamma) && (gamma <= 1)) {
         
          z = alpha * v0[2] + beta  * v1[2] + gamma * v2[2];
          
          if(x>=width || x<0 || y>=height || y<0) continue;

          if (z_buffer[y+x*height] > z) {
             
            z_buffer[y+x*height] = z;

          } 
        }
      }
    }
  }
}