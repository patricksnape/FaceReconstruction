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
  mxArray *a_in_m, *b_in_m, *c_in_m, *d_in_v, *e_out_m;
  double *triangle_list, *vertices, *color, *resolution, *frame_buffer;
  int dimx, dimy, numdims;
  
  //associate inputs
  a_in_m = mxDuplicateArray(prhs[0]);
  b_in_m = mxDuplicateArray(prhs[1]);
  c_in_m = mxDuplicateArray(prhs[2]);
  d_in_v = mxDuplicateArray(prhs[3]);
  
  //associate pointers to the data in the input mxArray
  triangle_list = mxGetPr(a_in_m);
  vertices = mxGetPr(b_in_m);
  color = mxGetPr(c_in_m);
  resolution = mxGetPr(d_in_v);
  
  //associate outputs
  mwSize dims1[3] = {(int)resolution[0],(int)resolution[1], 3};
  e_out_m = plhs[0] = mxCreateNumericArray(3, dims1, mxDOUBLE_CLASS, mxREAL);
  //e_out_m = plhs[0] = mxCreateDoubleMatrix((int)resolution[0],(int)resolution[1],mxREAL);
  
  //associate pointers to the data in the output mxArray
  frame_buffer = mxGetPr(e_out_m);
  
  //-----------------------------------------------------------------------
  
  
  //-------------------------------- CODE ---------------------------------
  
  //declare variables
  mxArray *f_temp_m;
  double *z_buffer;
  int width, height, n_triangles, n_vertices;
  double w_step, h_step;
  const mwSize *dims2, *dims3;
  
  width = (int) resolution[1];
  height = (int) resolution[0];
  
  w_step = 2.0/width;
  h_step = 2.0/height;
  
  dims2 = mxGetDimensions(prhs[0]);
  numdims = mxGetNumberOfDimensions(prhs[0]);
  n_triangles = (int) dims2[1];
  
  dims3 = mxGetDimensions(prhs[1]);
  numdims = mxGetNumberOfDimensions(prhs[1]);
  n_vertices = (int) dims3[1];
  
  f_temp_m = mxCreateDoubleMatrix(width,height,mxREAL);
  z_buffer = mxGetPr(f_temp_m);
  
  for (int i=0; i<width*height; i++) {
    z_buffer[i] = mxGetInf();
  }

  int i0,i1,i2;
  double v0[4],v1[4],v2[4], c0[4],c1[4],c2[4];
  int n = height*width, n2 = 2*n;
  
  //declare variables
  double alpha_1, alpha_2, alpha_3, beta_1, beta_2, beta_3, alpha_q, beta_q, u[3], v[3], u_max, u_min, v_max, v_min, x_start, x_end, y_start, y_end, p_x, p_y, alpha, beta, gamma, z;
  
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
    
     mexPrintf("Vertices: %d, %d, %d\n",i0,i1,i2);
     
     mexPrintf("v0: %f, %f, %f, %f\n",v0[0],v0[1],v0[2],v0[3]);
     mexPrintf("v1: %f, %f, %f, %f\n",v1[0],v1[1],v1[2],v1[3]);
     mexPrintf("v2: %f, %f, %f, %f\n",v2[0],v2[1],v2[2],v2[3]);
    
    
    alpha_1 = v1[1] - v2[1];
    alpha_2 = v2[0] - v1[0];
    alpha_3 = v1[0] * v2[1] - v2[0] * v1[1];
    
     mexPrintf("alphas: %f, %f, %f\n",alpha_1,alpha_2,alpha_3);
    
    beta_1 = v0[1] - v2[1];
    beta_2 = v2[0] - v0[0];
    beta_3 = v0[0] * v2[1] - v2[0] * v0[1];
    
     mexPrintf("betas: %f, %f, %f\n",beta_1,beta_2,beta_3);
    
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
    
     mexPrintf("us and vs: %f, %f, %f, %f\n", u_max, u_min, v_max, v_min);

    x_start = floor((u_min + 1) / w_step);
    x_end = ceil((u_max + 1) / w_step);
    y_start = floor((v_min + 1) / h_step);
    y_end = ceil((v_max + 1) / h_step);
    
     mexPrintf("x and y: %f, %f, %f, %f\n", x_start, x_end, y_start, y_end);
     
    p_y = -1 + y_start * h_step;
     
    for (int y=(int)y_start; y<= y_end; y++) {
    
      p_y = p_y + h_step;
      
      mexPrintf("%f, %d\n", p_y, y);
      
      p_x = -1 + x_start * w_step;
       
      for (int x=(int)x_start; x<= x_end; x++) {
      
        p_x = p_x + w_step;
         
        alpha = (alpha_1 * p_x + alpha_2 * p_y + alpha_3) / alpha_q;
        beta = (beta_1 * p_x + beta_2 * p_y + beta_3) / beta_q;
        gamma = 1 - alpha - beta;

        if ((0 <= alpha) && (alpha <= 1) && (0 <= beta) && (beta <= 1) && (0 <= gamma) && (gamma <= 1)) {
           
           mexPrintf("HELLO!\n");
          
          z = alpha * v0[2] + beta  * v1[2] + gamma * v2[2];

          if (z_buffer[y+x*height] > z) {
            
            mexPrintf("HELLO!\n");
            
            c0[0] = color[0+i0*4];
            c0[1] = color[1+i0*4];
            c0[2] = color[2+i0*4];
            c0[3] = color[3+i0*4];

            c1[0] = color[0+i1*4];
            c1[1] = color[1+i1*4];
            c1[2] = color[2+i1*4];
            c1[3] = color[3+i1*4];

            c2[0] = color[0+i2*4];
            c2[1] = color[1+i2*4];
            c2[2] = color[2+i2*4];
            c2[3] = color[3+i2*4];

            frame_buffer[y+x*height] = alpha * c0[0] + beta * c1[0] + gamma * c2[0];
            frame_buffer[y+x*height+n] = alpha * c0[1] + beta * c1[1] + gamma * c2[1];
            frame_buffer[y+x*height+n2] = alpha * c0[2] + beta * c1[2] + gamma * c2[2];
             
            z_buffer[y+x*height] = z;
          } 
        }
      }
    }
  }
     



  
//   int i =1;
//   mexPrintf("%d, %d, %f, %f\n", n_triangles, n_vertices, vertices[0+((int)triangle_list[0+i*n_triangles]-1)*n_vertices], triangle_list[0+i*n_triangles]);
  
}