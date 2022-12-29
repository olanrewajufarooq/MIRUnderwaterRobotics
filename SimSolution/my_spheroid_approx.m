function ma = my_spheroid_approx(a, b, rho)
    mdf = 4/3 * rho * a * b^2;
    e = sqrt( 1 - (b^2/a^2) );
    alpha0 = 2*(1 - e^2)/e^3 * ( 1/2 * log((1+e)/(1-e)) - e );
    k1 = alpha0 / (2 - alpha0);
    
    ma = k1 * mdf;
end

