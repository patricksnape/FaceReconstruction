#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <iostream>

using namespace std;

template <class T> 
T min (T *a, int num_elements) {
  int i;
  T min = a[0];
  for (i=0; i<num_elements; i++) {
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
  for (i=0; i<num_elements; i++) {
    if (a[i]>max) {
	    max=a[i];
    }
  }
  return max;
}

static int round(double number) {
    return (number >= 0) ? (int)(number + 0.5) : (int)(number - 0.5);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  
  //------------------------------- GATEWAY -------------------------------
  
  //declare variables
  mxArray *a_in_m, *b_in_m, *c_in_m, *d_in_m, *e_in_m, *f_in_m, *g_in_v, *h_in_m, *i_in_m, *j_in_m, *k_in_s, *l_in_s, *m_in_m, *n_in_m, *o_in_v, *p_in_v, *q_in_s, *r_out_m;
  double *triangle_list, *vertices, *color, *color_m, *l_amb, *l_dir, *light, *view_m, *reflect_m, *normal_m, *ks, *vu, *resolution, *sb_resolution, *projection_type, *frame_buffer, *shadow_buffer, *light_vertices;
  int dimx, dimy, numdims;
  
  //associate inputs
  a_in_m = mxDuplicateArray(prhs[0]);
  b_in_m = mxDuplicateArray(prhs[1]);
  c_in_m = mxDuplicateArray(prhs[2]);
  d_in_m = mxDuplicateArray(prhs[3]);
  e_in_m = mxDuplicateArray(prhs[4]);
  f_in_m = mxDuplicateArray(prhs[5]);
  g_in_v = mxDuplicateArray(prhs[6]);
  h_in_m = mxDuplicateArray(prhs[7]);
  i_in_m = mxDuplicateArray(prhs[8]);
  j_in_m = mxDuplicateArray(prhs[9]);
  k_in_s = mxDuplicateArray(prhs[10]);
  l_in_s = mxDuplicateArray(prhs[11]);
  m_in_m = mxDuplicateArray(prhs[12]);
  n_in_m = mxDuplicateArray(prhs[13]);
  o_in_v = mxDuplicateArray(prhs[14]);
  p_in_v = mxDuplicateArray(prhs[15]);
  q_in_s = mxDuplicateArray(prhs[16]);
  
  //associate pointers to the data in the input mxArray
  triangle_list = mxGetPr(a_in_m);
  vertices = mxGetPr(b_in_m);
  color = mxGetPr(c_in_m);
  color_m = mxGetPr(d_in_m);
  l_amb = mxGetPr(e_in_m);
  l_dir = mxGetPr(f_in_m);
  light = mxGetPr(g_in_v);
  view_m = mxGetPr(h_in_m);
  reflect_m = mxGetPr(i_in_m);
  normal_m = mxGetPr(j_in_m);
  ks = mxGetPr(k_in_s);
  vu = mxGetPr(l_in_s);
  shadow_buffer = mxGetPr(m_in_m);
  light_vertices = mxGetPr(n_in_m);
  resolution = mxGetPr(o_in_v);
  sb_resolution = mxGetPr(p_in_v);
  projection_type = mxGetPr(q_in_s);
  
  //associate outputs
  mwSize dims1[3] = {(int)resolution[0],(int)resolution[1], 3};
  r_out_m = plhs[0] = mxCreateNumericArray(3, dims1, mxDOUBLE_CLASS, mxREAL);
  
  //associate pointers to the data in the output mxArray
  frame_buffer = mxGetPr(r_out_m);
  
  //-----------------------------------------------------------------------
  
  
  //-------------------------------- CODE ---------------------------------
  
  //declare variables
  mxArray *o_temp_m;
  double *z_buffer;
  int width, height, sb_width, sb_height, n_triangles, n_vertices, n, sb_n;
  double w_step, h_step, sb_w_step, sb_h_step, n_shadow_buffers, tolerance, ratio;
  const mwSize *dims2, *dims3, *dims4;
  
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
  
  sb_width = (int) sb_resolution[1];
  sb_height = (int) sb_resolution[0];

  sb_h_step = 2.0 / sb_height; 
  sb_w_step = 2.0 / sb_width;
      
  dims2 = mxGetDimensions(prhs[0]);
  numdims = mxGetNumberOfDimensions(prhs[0]);
  n_triangles = (int) dims2[1];
  
  dims3 = mxGetDimensions(prhs[1]);
  numdims = mxGetNumberOfDimensions(prhs[1]);
  n_vertices = (int) dims3[1];
  
  dims4 = mxGetDimensions(prhs[12]);
  numdims = mxGetNumberOfDimensions(prhs[12]);
  n_shadow_buffers = dims4[2];
  
  o_temp_m = mxCreateDoubleMatrix(width,height,mxREAL);
  z_buffer = mxGetPr(o_temp_m);
  
  n = height*width;
  sb_n = sb_height*sb_width;
  
  for (int i=0; i<n; i++) {
    z_buffer[i] = mxGetInf();
  }
  
  if (projection_type[0] == 0) {
    tolerance = 0.003;
  } else {
    tolerance = 0.02;
  }
  
  //declare variables
  int i0, i1, i2, m, l;
  int n2 = 2*n;
  double v0[4], v1[4], v2[4], z;
  double alpha_1, alpha_2, alpha_3, beta_1, beta_2, beta_3, alpha_q, beta_q, alpha23, beta23, alpha, beta, gamma; 
  double u[3], v[3], u_max, u_min, v_max, v_min, x_start, x_end, y_start, y_end, p_x, p_y;
  double shape[3], shape0[3], shape1[3], shape2[3];
  double c[3], c0[3], c1[3], c2[3];
  double view[3], view0[3], view1[3], view2[3];
  double reflect[3], reflect0[3], reflect1[3], reflect2[3];
  double normal[3], normal0[3], normal1[3], normal2[3];
  double ambient[3], diffuse[3], specular[3];
  double n_l_dot, r_v_dot, s;
  double i_color[4], c_color[3];
  
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
         
          z = alpha * v0[2] + beta * v1[2] + gamma * v2[2];
          
          if(x>=width || x<0 || y>=height || y<0) continue;

          if (z_buffer[y+x*height] > z) {
            
            shape0[0] = light_vertices[0+i0*4];
            shape0[1] = light_vertices[1+i0*4];
            shape0[2] = light_vertices[2+i0*4];
            
            shape1[0] = light_vertices[0+i1*4];
            shape1[1] = light_vertices[1+i1*4];
            shape1[2] = light_vertices[2+i1*4];
            
            shape2[0] = light_vertices[0+i2*4];
            shape2[1] = light_vertices[1+i2*4];
            shape2[2] = light_vertices[2+i2*4];
            
            shape[0] = alpha * shape0[0] + beta * shape1[0] + gamma * shape2[0];
            shape[1] = alpha * shape0[1] + beta * shape1[1] + gamma * shape2[1];
            shape[2] = alpha * shape0[2] + beta * shape1[2] + gamma * shape2[2];
            
            m = round((shape[1] + 1) / sb_h_step) - 1;
            l = round((shape[0] + 1) / sb_w_step) - 1;
            
            s = 0;
            
            for (int j=0; j<n_shadow_buffers; j++) {
              if ((abs(shadow_buffer[m+l*sb_height+j*sb_n] - shape[2])) < tolerance) {
                s=s+1;
              }
            }

            s = s/n_shadow_buffers;
            
            c0[0] = color[0+i0*4];
            c0[1] = color[1+i0*4];
            c0[2] = color[2+i0*4];

            c1[0] = color[0+i1*4];
            c1[1] = color[1+i1*4];
            c1[2] = color[2+i1*4];

            c2[0] = color[0+i2*4];
            c2[1] = color[1+i2*4];
            c2[2] = color[2+i2*4];
            
            c[0] = alpha * c0[0] + beta * c1[0] + gamma * c2[0];
            c[1] = alpha * c0[1] + beta * c1[1] + gamma * c2[1];
            c[2] = alpha * c0[2] + beta * c1[2] + gamma * c2[2];
            
            view0[0] = view_m[0+i0*4];
            view0[1] = view_m[1+i0*4];
            view0[2] = view_m[2+i0*4];
            
            view1[0] = view_m[0+i1*4];
            view1[1] = view_m[1+i1*4];
            view1[2] = view_m[2+i1*4];
            
            view2[0] = view_m[0+i2*4];
            view2[1] = view_m[1+i2*4];
            view2[2] = view_m[2+i2*4];
            
            view[0] = alpha * view0[0] + beta * view1[0] + gamma * view2[0];
            view[1] = alpha * view0[1] + beta * view1[1] + gamma * view2[1];
            view[2] = alpha * view0[2] + beta * view1[2] + gamma * view2[2];
            
            reflect0[0] = reflect_m[0+i0*4];
            reflect0[1] = reflect_m[1+i0*4];
            reflect0[2] = reflect_m[2+i0*4];
            
            reflect1[0] = reflect_m[0+i1*4];
            reflect1[1] = reflect_m[1+i1*4];
            reflect1[2] = reflect_m[2+i1*4];
            
            reflect2[0] = reflect_m[0+i2*4];
            reflect2[1] = reflect_m[1+i2*4];
            reflect2[2] = reflect_m[2+i2*4];
            
            reflect[0] = alpha * reflect0[0] + beta * reflect1[0] + gamma * reflect2[0];
            reflect[1] = alpha * reflect0[1] + beta * reflect1[1] + gamma * reflect2[1];
            reflect[2] = alpha * reflect0[2] + beta * reflect1[2] + gamma * reflect2[2];
            
            normal0[0] = normal_m[0+i0*4];
            normal0[1] = normal_m[1+i0*4];
            normal0[2] = normal_m[2+i0*4];
            
            normal1[0] = normal_m[0+i1*4];
            normal1[1] = normal_m[1+i1*4];
            normal1[2] = normal_m[2+i1*4];
            
            normal2[0] = normal_m[0+i2*4];
            normal2[1] = normal_m[1+i2*4];
            normal2[2] = normal_m[2+i2*4];
            
            normal[0] = alpha * normal0[0] + beta * normal1[0] + gamma * normal2[0];
            normal[1] = alpha * normal0[1] + beta * normal1[1] + gamma * normal2[1];
            normal[2] = alpha * normal0[2] + beta * normal1[2] + gamma * normal2[2];
            
            ambient[0] = l_amb[0] * c[0];
            ambient[1] = l_amb[5] * c[1];
            ambient[2] = l_amb[10] * c[2];
            
            n_l_dot = normal[0] * light[0] + normal[1] * light[1] + normal[2] * light[2];
            
            i_color[0] = ambient[0]; 
            i_color[1] = ambient[1];
            i_color[2] = ambient[2];
            i_color[3] = 1;
            
            if (n_l_dot > 0) {

              diffuse[0] = l_dir[0] * n_l_dot * c[0];
              diffuse[1] = l_dir[5] * n_l_dot * c[1];
              diffuse[2] = l_dir[10] * n_l_dot * c[2];

              r_v_dot = reflect[0] * view[0] + reflect[1] * view[1] + reflect[2] * view[2];
              
              i_color[0] = i_color[0] + s * diffuse[0];
              i_color[1] = i_color[1] + s * diffuse[1];
              i_color[2] = i_color[2] + s * diffuse[2];
              
              if (r_v_dot > 0) {
              
                specular[0] = (1.0 - l_dir[0]) * ks[0] * pow(r_v_dot, vu[0]);
                specular[1] = (1.0 - l_dir[5]) * ks[0] * pow(r_v_dot, vu[0]);
                specular[2] = (1.0 - l_dir[10]) * ks[0] * pow(r_v_dot, vu[0]);

                i_color[0] = i_color[0] + s * specular[0];
                i_color[1] = i_color[1] + s * specular[1];
                i_color[2] = i_color[2] + s * specular[2];
              }
            }
            
            c_color[0] = color_m[0] * i_color[0] + color_m[4] * i_color[1] + color_m[8] * i_color[2] + color_m[12] * i_color[3];
            c_color[1] = color_m[1] * i_color[0] + color_m[5] * i_color[1] + color_m[9] * i_color[2] + color_m[13] * i_color[3];
            c_color[2] = color_m[2] * i_color[0] + color_m[6] * i_color[1] + color_m[10] * i_color[2] + color_m[14] * i_color[3];
            
            frame_buffer[y+x*height] = c_color[0];
            frame_buffer[y+x*height+n] = c_color[1];
            frame_buffer[y+x*height+n2] = c_color[2];

            z_buffer[y+x*height] = z;
          } 
        }
      }
    }
  }
}