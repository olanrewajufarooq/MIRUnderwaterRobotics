function ma = my_added_mass_fincyl(a, b, x1, x2, rho)

a22 = rho .* pi * a^2;
a33 = rho .* pi * b^2 * ( 1 - (a/b)^2 + (a/b)^4 );

f = @(k) 2*k^2 - k*sin(4*k) + 0.5*( sin(2*k) )^2;
csc = @(k) 1/sin(k);
alpha = pi/2 + asin( (2*a*b)/(a^2+b^2));

a44 = rho*a^4*( (csc(alpha))^4 * f(alpha) - pi^2 ) / (2*pi);

ma22 = integral(@(x) a22+0*x, x1, x2); 
ma26 = integral(@(x) a22*x, x1, x2);
ma33 = integral(@(x) a33+0*x, x1, x2); 
ma35 = -integral(@(x) a33*x, x1, x2);
ma44 = integral(@(x) a44+0*x, x1, x2);
ma55 = integral(@(x) a33*x.^2, x1, x2);
ma66 = integral(@(x) a22*x.^2, x1, x2);

ma = [0, 0, 0, 0, 0, 0;
    0, ma22, 0, 0, 0, ma26;
    0, 0, ma33, 0, ma35, 0;
    0, 0, 0, ma44, 0, 0;
    0, 0, ma35, 0, ma55, 0;
    0, ma26, 0, 0, 0, ma66];

end

