function [x_out,y_out,z_out] = my_scale_diagram(x_in,y_in, z_in)

x_in =x_in/100; y_in= y_in/100; z_in=z_in/100; % Converting the input to meters 
x_scale = 1.6/0.1385; y_scale= 0.115/0.01; z_scale = y_scale; % Defining the scale 
x_out=x_scale*x_in; y_out=y_scale*y_in; z_out=z_scale*z_in; % Scaling

end
