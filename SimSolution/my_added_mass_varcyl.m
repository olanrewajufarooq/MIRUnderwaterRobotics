function ma = my_added_mass_varcyl(r_params, x1, x2, rho)

if length(r_params) == 2
    m = r_params(1);
    c = r_params(2);
    a22 = @(x) rho .* pi*(m.*x + c).^2;
    a26 = @(x) rho .* pi*(m.*x + c).^2 .* x;
    a33 = @(x) rho .* pi*(m.*x + c).^2;
    a35 = @(x) rho .* pi*(m.*x + c).^2 .* x;
    a44 = @(x) 0*x;
    a55 = @(x) rho .* pi*(m.*x + c).^2 .* x.^2;
    a66 = @(x) rho .* pi*(m.*x + c).^2 .* x.^2;
    
elseif length(r_params) == 3
    a = r_params(1);
    b = r_params(2);
    c = r_params(3);
    a22 = @(x) rho .* pi*(a.*x.^2 + b.*x + c).^2;
    a26 = @(x) rho .* pi*(a.*x.^2 + b.*x + c).^2 .* x;
    a33 = @(x) rho .* pi*(a.*x.^2 + b.*x + c).^2;
    a35 = @(x) rho .* pi*(a.*x.^2 + b.*x + c).^2 .* x;
    a44 = @(x) 0*x;
    a55 = @(x) rho .* pi*(a.*x.^2 + b.*x + c).^2 .* x.^2;
    a66 = @(x) rho .* pi*(a.*x.^2 + b.*x + c).^2 .* x.^2;
    
end

ma22 = integral(a22, x1, x2); 
ma26 = integral(a26, x1, x2);
ma33 = integral(a33, x1, x2); 
ma35 = -integral(a35, x1, x2);
ma44 = integral(a44, x1, x2);
ma55 = integral(a55, x1, x2);
ma66 = integral(a66, x1, x2);

ma = [0, 0, 0, 0, 0, 0;
    0, ma22, 0, 0, 0, ma26;
    0, 0, ma33, 0, ma35, 0;
    0, 0, 0, ma44, 0, 0;
    0, 0, ma35, 0, ma55, 0;
    0, ma26, 0, 0, 0, ma66];

end

