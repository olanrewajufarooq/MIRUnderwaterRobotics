function ma = my_added_mass_cyl(r, x1, x2, rho, orientation)

if strcmp(orientation, 'horizontal')
    a11 = rho .* pi * r^2;
    a22 = a11;
    % a44 = 0;
    
    ma22 = integral(@(x) a11+0*x, x1, x2); 
    ma26 = integral(@(x) a11*x, x1, x2);
    ma33 = integral(@(x) a22+0*x, x1, x2); 
    ma35 = -integral(@(x) a22*x, x1, x2);
    ma44 = 0;
    ma55 = integral(@(x) a22*x.^2, x1, x2);
    ma66 = integral(@(x) a11*x.^2, x1, x2);
    
    ma = [0, 0, 0, 0, 0, 0;
    0, ma22, 0, 0, 0, ma26;
    0, 0, ma33, 0, ma35, 0;
    0, 0, 0, ma44, 0, 0;
    0, 0, ma35, 0, ma55, 0;
    0, ma26, 0, 0, 0, ma66];

elseif strcmp(orientation, 'vertical')
    a11 = rho .* pi * r^2;
    a22 = a11;
    % a44 = 0;
    
    ma11 = integral(@(x) a11+0*x, x1, x2); 
    ma15 = integral(@(x) a11*x, x1, x2);
    ma22 = integral(@(x) a22+0*x, x1, x2); 
    ma24 = -integral(@(x) a22*x, x1, x2);
    ma66 = 0;
    ma44 = integral(@(x) a22*x.^2, x1, x2);
    ma55 = integral(@(x) a11*x.^2, x1, x2);
    
    ma = [ma11, 0, 0, 0, ma15, 0;
    0, ma22, 0, ma24, 0, 0;
    0, 0, 0, 0, 0, 0;
    0, ma24, 0, ma44, 0, 0;
    ma15, 0, 0, 0, ma55, 0;
    0, 0, 0, 0, 0, ma66];
end

end


