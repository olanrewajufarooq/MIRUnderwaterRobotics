function ma = my_added_mass_cuboid(x, y, orientation, z1, z2, rho)

if strcmp(orientation, "vertical")
    a1 = x/2; b1 = y/2; a2 = y/2; b2 = x/2; a6 = x/2; b6 = y/2; 
elseif strcmp(orientation, "horizontal")
    a1 = y/2; b1 = x/2; a2 = x/2; b2 = y/2; a6 = y/2; b6 = x/2;
end

CA11 = CA(a1/b1); CA22 = CA(a2/b2); beta = beta2(a6/b6);

a11 = rho * CA11 * pi * a1^2;
a22 = rho * CA22 * pi * a2^2;
a66 = beta * rho * pi * b6^4;

ma11 = integral(@(z) a11+0*z, z1, z2); 
ma15 = integral(@(z) a11*z, z1, z2);
ma22 = integral(@(z) a22+0*z, z1, z2); 
ma24 = -integral(@(z) a22*z, z1, z2);
ma33 = integral(@(z) 0*z, z1, z2);
ma44 = integral(@(z) a22*z.^2, z1, z2);
ma55 = integral(@(z) a11*z.^2, z1, z2);
ma66 = integral(@(z) a66+0*z, z1, z2);

ma = [ma11, 0, 0, 0, ma15, 0;
    0, ma22, 0, ma24, 0, 0;
    0, 0, ma33, 0, 0, 0;
    0, ma24, 0, ma44, 0, 0;
    ma15, 0, 0, 0, ma55, 0;
    0, 0, 0, 0, 0, ma66];

end

function k = CA(ab_ratio)
    if ab_ratio <= 0.15; k = 2.23; elseif ab_ratio <= 0.35; k = 1.98;
    elseif ab_ratio <= 0.75; k = 1.70; elseif ab_ratio <= 1.5; k = 1.51;
    elseif ab_ratio <= 3.5; k = 1.36; elseif ab_ratio <= 7.5; k = 1.21;
    elseif ab_ratio <= 12.5; k = 1.14; else; k = 1.0;
    end
end

function k = beta1(ab_ratio)
    if ab_ratio <= 0.15; k = []; elseif ab_ratio <= 0.35; k = [];
    elseif ab_ratio <= 0.75; k = []; elseif ab_ratio <= 1.5; k = 0.234;
    elseif ab_ratio <= 3.5; k = 0.15; elseif ab_ratio <= 7.5; k = 0.15;
    else; k = 0.125;
    end
end

function k = beta2(ab_ratio)
    if ab_ratio <= 0.15; k = 0.147; elseif ab_ratio <= 0.35; k = 0.15;
    elseif ab_ratio <= 0.75; k = 0.15; elseif ab_ratio <= 1.5; k = 0.234;
    elseif ab_ratio <= 3.5; k = []; elseif ab_ratio <= 7.5; k = [];
    else; k = [];
    end
end

