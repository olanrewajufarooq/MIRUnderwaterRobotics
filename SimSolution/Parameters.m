function Para=Parameters()

global Para

%% Initial Speed and position in Earth-fixed frame

Para.ICPos = [0 0 2 0 0 0];
Para.ICSpeed = [0 0 0 0 0 0];

%% General parameters
Para.rho_water = 1000 ;                     % Masse volumique de l'eau (kg/m^3)
Para.R = 0.115 ;                             % Sparus Radius (m)
Para.L = 1.6;  	                            % Sparus length (m)
Para.m = 52 ; 	                            % Sparus mass (kg)
Para.mb = 52.1;                           	% Sparus buoyancy mass  (kg) 
Para.g = 9.81 ;                             % Earth Gravity (m*s^(-2))
Para.P = Para.m * Para.g;	                % Sparus weight (N)
Para.B = Para.mb * Para.g;	                % Buoyancy (N)

%% Center of gravity and Buoyancy position in body-fied frame

Para.xg = 0 ;    %x-positon of Center of gravity
Para.yg = 0 ;    %y-positon of Center of gravity
Para.zg = 0 ;    %z-positon of Center of gravity

Para.rg = [Para.xg Para.yg Para.zg]' ;

Para.xb = 0      ;    % x-positon of Center of Buoyancy
Para.yb = 0      ;    % y-positon of Center of Buoyancy
Para.zb = -0.02  ;    % z-positon of Center of Buoyancy

Para.rb = [Para.xb Para.yb Para.zb]' ;

%% Body positions

% Measured Lengths from Ruler (in centimeters)

% Main Body
x8 = 10.85; y8 = 2.0; z8 = y8;
x9 = 2.2; y9 = 2.0; z9 = y9;
x10 = 0.8; y10 = 2.0; z10 = y10;

% The thrusters
x1 = 0.5; y1 = x1; z1 = 0.2;
x2 = 0.5; y2 = x2; z2 = 0.5;
x3 = 1.6; y3 = 0.5; z3 = y3;

% The Antennas
x5 = 0.45; y5 = 0.9; z5 = y5;
x7 = 0.7; y7 = 0.4; z7 = 2.2; 


% Scaling the measurements (inputs in cm, outputs in m)

% The Main Body
[x8, y8, z8] = my_scale_diagram(x8, y8, z8);
[x9, y9, z9] = my_scale_diagram(x9, y9, z9);
[x10, y10, z10] = my_scale_diagram(x10, y10, z10);

% The Thrusters
[x1, y1, z1] = my_scale_diagram(x1, y1, z1);
[x2, y2, z2] = my_scale_diagram(x2, y2, z2);
[x3, y3, z3] = my_scale_diagram(x3, y3, z3);
x4 = x3; y4 = y3; z4 = z3;
   
% The Antennas
[x5, y5, z5] = my_scale_diagram(x5, y5, z5);
x6 = x5; y6 = y5; z6 = z5;
[x7, y7, z7] = my_scale_diagram(x7, y7, z7);


%% Body Mass matrices


% Calculating VOlume of Each Shape
Para.V = 0      ;           % The total volume of the sparus.

% Main Body
Para.s(8).V = pi * (y8/2)^2 * x8; % Cylinder
Para.s(9).V = 1/3 * pi * (y9/2)^2 * x9; % Cone
Para.s(10).V = 2/3 * pi * (y10/2)^2 * x10; % Hemi-ellipsoid

% The Thrusters
Para.s(1).V = pi * (x1/2)^2 * z1; % Cylinder
Para.s(2).V = pi * (x2/2)^2 * z2; % Cylinder
Para.s(3).V = pi * (y3/2)^2 * x3; % Cylinder
Para.s(4).V = Para.s(3).V; % Cylinder

% The Antennas
Para.s(5).V = pi * (y5/2)^2 * x5; % Cylinder
Para.s(6).V = Para.s(5).V; % Cylinder
Para.s(7).V = x7 * y7 * z7; % Cuboid

for i=1:length(Para.s)
    Para.V = Para.V + Para.s(i).V;
end; clear i

Para.rho = Para.m / Para.V;            % Estimated Density of the Sparus



% Mass of Each Body
for i = 1:length(Para.s)
    Para.s(i).m = Para.rho * Para.s(i).V;
end; clear i


Para.S(1).m = Para.s(8).m + Para.s(9).m + Para.s(10).m;
Para.S(2).m = Para.s(3).m +Para.s(5).m;
Para.S(3).m = Para.s(4).m +Para.s(6).m;
Para.S(4).m = Para.s(7).m;
Para.S(5).m = Para.s(2).m;
Para.S(6).m = Para.s(1).m;



% Distances to the Body Centre of the Sparus

% The Main Body
Para.s(8).Rb = [0; 0; 0];
Para.s(9).Rb = [-(x8/2); 0; 0] + [-(x9/4); 0; 0];
Para.s(10).Rb = [(x8/2); 0; 0] + [(3/8*x10); 0; 0];

Para.S(1).Rb = Para.s(8).Rb;

% The Thrusters
Para.s(3).Rb = [-(x8/2 - x1); (y8/2 + y1); 0] + [-(x3/2); y3/2; 0];
Para.s(5).Rb = Para.s(3).Rb + [-(x3/2 + x5/2); 0; 0];

Para.S(2).Rb = (Para.s(3).m * Para.s(3).Rb + Para.s(5).m * Para.s(5).Rb) / (Para.s(3).m + Para.s(5).m);

Para.s(4).Rb = [-(x8/2 - x1); -(y8/2 + y1); 0] + [-(x3/2); -y3/2; 0];
Para.s(6).Rb = Para.s(4).Rb + [-(x3/2 + x5/2); 0; 0];

Para.S(3).Rb = (Para.s(4).m * Para.s(4).Rb + Para.s(6).m * Para.s(6).Rb) / (Para.s(4).m + Para.s(6).m);

% The Antennas
Para.s(1).Rb = [(x8/2 - 0.3/13.85*1.6); 0; -(z8/2)] + [-(x1/2); 0; -(z1/2)];
Para.s(2).Rb = [(x8/2 - 2.6/13.85*1.6); 0; -(z8/2)] + [-(x2/2); 0; -(z2/2)];
Para.s(7).Rb = [-(x8/2 - 0.1040); 0; -(z8/2)] + [0; 0; -(z7/2)];

Para.S(4).Rb = Para.s(7).Rb;
Para.S(5).Rb = Para.s(2).Rb;
Para.S(6).Rb = Para.s(1).Rb;


% Inertia of Each Shape

% The Main Body
Para.s(8).I = [Para.s(8).m*((y8/2)^2/2), 0, 0;
    0, Para.s(8).m*( (y8/2)^2/4 + x8^2/12), 0;
    0, 0, Para.s(8).m*( (z8/2)^2/4 + x8^2/12)]; % Cylinder

Para.s(9).I = Para.s(9).m*[3/10 * (y9/2)^2, 0, 0;
    0, 3/20 * (y9/2)^2 + 3/80 * x9^2, 0;
    0, 0, 3/20 * (z9/2)^2 + 3/80 *x9^2]; % Cone
% Check the formula for cone inertia sensor here: 
% https://www.12000.org/my_courses/univ_wisconsin_madison/fall_2015/mechanics_311/HWs/HW9/HW9.pdf

Para.s(10).I = Para.s(10).m * [1/5 * (y10/2) * (z10/2), 0, 0;
    0, 83/320 * (x10/2) * (z10/2), 0;
    0, 0, 83/320 * (x10/2) * (y10/2)]; % Hemi-ellipsoid
% Check the formula for the hemisphere inertia sensor here:
% https://physics.stackexchange.com/questions/93561/tensor-of-inertia
% The formula is adapted to the semi-ellipsoid

Para.S(1).I = Para.s(8).I + my_parallel_axis(Para.s(9).I, Para.s(9).Rb, Para.s(9).m) + my_parallel_axis(Para.s(10).I, Para.s(10).Rb, Para.s(10).m);


% The Thrusters
Para.s(3).I = [Para.s(3).m*( (y3/2)^2/2), 0, 0;
    0, Para.s(3).m*( (y3/2)^2/4 + x3^2/12), 0;
    0, 0, Para.s(3).m*( (z3/2)^2/4 + x3^2/12)]; % Cylinder

Para.s(4).I = Para.s(3).I; % Cylinder

Para.s(5).I = [Para.s(5).m*( (y5/2)^2/2), 0, 0;
    0, Para.s(5).m*( (y5/2)^2/4 + x5^2/12), 0;
    0, 0, Para.s(5).m*( (z5/2)^2/4 + x5^2/12)]; % Cylinder

Para.s(6).I = Para.s(5).I; % Cylinder

Para.S(2).I = my_parallel_axis(Para.s(3).I, Para.s(3).Rb - Para.S(2).Rb, Para.s(3).m) + my_parallel_axis(Para.s(5).I, Para.s(5).Rb - Para.S(2).Rb, Para.s(5).m);
Para.S(3).I = my_parallel_axis(Para.s(4).I, Para.s(4).Rb - Para.S(3).Rb, Para.s(4).m) + my_parallel_axis(Para.s(6).I, Para.s(6).Rb - Para.S(3).Rb, Para.s(6).m);


% The Antennas
Para.s(1).I = [Para.s(1).m*( (x1/2)^2/4 + z1^2/12), 0, 0;
    0, Para.s(1).m*( (x1/2)^2/4 + z1^2/12), 0;
    0, 0, Para.s(1).m*( (x1/2)^2/2)]; % Cylinder

Para.s(2).I = [Para.s(2).m*( (x1/2)^2/4 + z1^2/12), 0, 0;
    0, Para.s(2).m*( (x1/2)^2/4 + z1^2/12), 0;
    0, 0, Para.s(2).m*( (x1/2)^2/2)]; % Cylinder

Para.s(7).I = Para.s(7).m/12 * [(y7^2 + z7^2), 0, 0;
    0, (x7^2 + z7^2), 0;
    0, 0, (x7^2 + y7^2)]; % Cuboid

Para.S(4).I = Para.s(7).I;
Para.S(5).I = Para.s(2).I;
Para.S(6).I = Para.s(1).I;


% Mass Matrix of Each Body
for i = 1:length(Para.S)
    Para.S(i).Mbb = -[Para.S(i).m*eye(3), zeros(3);
            zeros(3), Para.S(i).I];

    Para.S(i).Mb = my_H(Para.S(i).Rb)' * Para.S(i).Mbb * my_H(Para.S(i).Rb);

end; clear i

%% Body added Mass matrices

% Main Body S0;
m = y8/(2*x9);
k = y9/4*(x8/x9 + 2);
A = -my_added_mass_varcyl([m, k], -x8/2-x9, -x8/2, Para.rho_water); clear m k

B = -my_added_mass_fincyl(y8/2, y8/2+y3, -x8/2, -x8/2+x3, Para.rho_water);
C = -my_added_mass_cyl(y8/2, -x8/2+x3, x8/2, Para.rho_water, 'horizontal');

a = -7*y8/(20*(x10)^2);
b = y8*(14*x8 + 3*x10)/(40*(x10)^2);
c = -y8*(7*x8^2 + 3*x8*x10 - 40*x10^2)/(80*x10^2);
D = -my_added_mass_varcyl([a, b, c], x8/2, x8/2+x10, Para.rho_water); clear a b c

Para.S(1).Maa = A + B + C + D; clear A B C D
Para.S(1).Maa(1, 1) = -my_spheroid_approx((x8+x9+x10)/2, y8/2, Para.rho_water); 
Para.S(1).Ma = Para.S(1).Maa;

Para.S(2).Maa = zeros(6); Para.S(2).Maa(1, 1) = -my_spheroid_approx((x3+x5)/2, y5/2, Para.rho_water);
Para.S(2).Ma = my_H(Para.S(2).Rb)' * Para.S(2).Maa * my_H(Para.S(2).Rb);

Para.S(3).Maa = zeros(6); Para.S(3).Maa(1, 1) = -my_spheroid_approx((x4+x6)/2, y6/2, Para.rho_water);
Para.S(3).Ma = my_H(Para.S(3).Rb)' * Para.S(3).Maa * my_H(Para.S(3).Rb);

Para.S(4).Maa = -my_added_mass_cuboid(y7, x7, "vertical", -z7/2, z7/2, Para.rho_water);
Para.S(4).Maa(3, 3) = -my_spheroid_approx(z7/2, x7/2, Para.rho_water);
Para.S(4).Ma = my_H(Para.S(4).Rb)' * Para.S(4).Maa * my_H(Para.S(4).Rb);
Para.S(5).Maa = -my_added_mass_cyl(y2/2, -z8/2-z2/2, z2, Para.rho_water, 'vertical');
Para.S(5).Maa(3, 3) = -real(my_spheroid_approx(z1/2, x1/2, Para.rho_water));
Para.S(5).Ma = my_H(Para.S(5).Rb)' * Para.S(5).Maa * my_H(Para.S(5).Rb);
Para.S(6).Maa = -my_added_mass_cyl(y1/2, -z8/2-z1/2, z1, Para.rho_water, 'vertical');
Para.S(6).Maa(3, 3) = -real(my_spheroid_approx(z2/2, x2/2, Para.rho_water));
Para.S(6).Ma = my_H(Para.S(6).Rb)' * Para.S(6).Maa * my_H(Para.S(6).Rb);
Para = rmfield(Para, "s");

    
%% Generalized mass matrix

Para.Mg = zeros(6, 6);

for i = 1:length(Para.S)
    Para.S(i).Mg = Para.S(i).Mb + Para.S(i).Ma;
    Para.Mg = Para.Mg + Para.S(i).Mg;
end; clear i

%% Generalized coriolis matrix

% Computed in RovModel.m

%% Friction matrices

% Main Body S0;
Para.S(1).K = zeros(6);
L1 = x8 + x9 + x10;
CD11 = 0.2; Sx = pi * (y8/2)^2;  % Sphere
Para.S(1).K(1,1) = 0.5 * Para.rho_water * Sx * CD11;
CD22 = 0.3; % Circle
Para.S(1).K(2, 2) = 0.5 * Para.rho_water * CD22 * y8 *L1;
CD33 = CD22; 
Para.S(1).K(3, 3) = 0.5 * Para.rho_water * CD33 * z8 *L1;
Para.S(1).K(5, 5) = 1/64 * Para.rho_water * L1^4 * CD33 * z8;
Para.S(1).K(6, 6) = 1/64 * Para.rho_water * L1^4 * CD22 * y8; clear CD11 CD22 CD33 L1 Sx

%Para.S0.Kq = -diag([Para.S0.kuu Para.S0.kvv Para.S0.kww Para.S0.kpp Para.S0.kqq Para.S0.krr]) ;    %Quadratic friction matrix

% First Body S1;
Para.S(2).K = zeros(6);
L2 = x3 + x5;
CD11 = 0.4; Sx = pi * (y3/2)^2; % Hemisphere
Para.S(2).K(1, 1) = 0.5 * Para.rho_water * Sx * CD11;
CD22 = 0.3; % Circle
Para.S(2).K(2, 2) = 0.5 * Para.rho_water * CD22 * y3 *L2;
CD33 = CD22; 
Para.S(2).K(3, 3) = 0.5 * Para.rho_water * CD33 * z3 *L2;
Para.S(2).K(5, 5) = 1/64 * Para.rho_water * L2^4 * CD33 * z3;
Para.S(2).K(6, 6) = 1/64 * Para.rho_water * L2^4 * CD22 * y3; clear CD11 CD22 CD33 L2 Sx

% Second Body S1;
Para.S(3).K = Para.S(2).K;

% First Body S1;
Para.S(4).K = zeros(6);
L4 = z7;
CD11 = 1.2; 
Para.S(4).K(1, 1) = 0.5 * Para.rho_water * CD11 * y7 *L4;
CD22 = 1.2; 
Para.S(4).K(2, 2) = 0.5 * Para.rho_water * CD22 * x7 *L4;
CD33 = 1.05; Sz = x7 * y7; 
Para.S(4).K(3, 3) = 0.5 * Para.rho_water * Sz * CD33;
Para.S(4).K(4, 4) = 1/64 * Para.rho_water * L4^4 * CD33 * x5;
Para.S(4).K(5, 5) = 1/64 * Para.rho_water * L4^4 * CD22 * y5; clear CD11 CD22 CD33 L4 Sz


%Para.S1.Kq = -diag([Para.S1.kuu Para.S1.kvv Para.S1.kww Para.S1.kpp Para.S1.kqq Para.S1.krr]) ;    %Quadratic friction matrix

% First Body S1;
Para.S(5).K = zeros(6);
L11 = z1;
CD11 = 0.3; 
Para.S(5).K(1, 1) = 0.5 * Para.rho_water * CD11 * y1 *L11;
CD22 = 0.3; 
Para.S(5).K(2, 2) = 0.5 * Para.rho_water * CD22 * x1 *L11;
%ratio = z1 / x1
CD33 = 1.1; Sz = pi * x1/2 * y1/2; 
Para.S(5).K(3, 3) = 0.5 * Para.rho_water * Sz * CD33;
Para.S(5).K(4, 4) = 1/64 * Para.rho_water * L11^4 * CD33 * x1;
Para.S(5).K(5, 5) = 1/64 * Para.rho_water * L11^4 * CD22 * y1; clear CD11 CD22 CD33 ratio L11 Sz

%Para.S1.Kq = -diag([Para.S1.kuu Para.S1.kvv Para.S1.kww Para.S1.kpp Para.S1.kqq Para.S1.krr]) ;    %Quadratic friction matrix% First Body S1;

% First Body S1;
Para.S(6).K = zeros(6);
L6 = z2;
CD11 = 0.3; 
Para.S(6).K(1, 1) = 0.5 * Para.rho_water * CD11 * y2 *L6;
CD22 = 0.3; 
Para.S(6).K(2, 2) = 0.5 * Para.rho_water * CD22 * x2 *L6;
CD33 = 1.1; Sz = pi * x2/2 * y2/2; 
Para.S(6).K(3, 3) = 0.5 * Para.rho_water * Sz * CD33;
Para.S(6).K(4, 4) = 1/64 * Para.rho_water * L6^4 * CD33 * x2;
Para.S(6).K(5, 5) = 1/64 * Para.rho_water * L6^4 * CD22 * y2; clear CD11 CD22 CD33 ratio L6 Sz

clear x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
clear y1 y2 y3 y4 y5 y6 y7 y8 y9 y10
clear z1 z2 z3 z4 z5 z6 z7 z8 z9 z10

%Para.S1.Kq = -diag([Para.S1.kuu Para.S1.kvv Para.S1.kww Para.S1.kpp Para.S1.kqq Para.S1.krr]) ;    %Quadratic friction matrix


%% Thruster modelling

%Thruster positions in body-fixed frame

Para.d1x = 0        ; 
Para.d1y = 0        ;
Para.d1z = 0.08     ;
Para.d2x = -0.59    ; 
Para.d2y = 0.17     ;
Para.d2z = 0        ;
Para.d3x = -0.59    ;
Para.d3y = -0.17    ;
Para.d3z = 0        ;


Para.rt1 = [Para.d1x, Para.d1y, Para.d1z]' ;
Para.rt2 = [Para.d2x, Para.d2y, Para.d2z]' ;
Para.rt3 = [Para.d3x, Para.d3y, Para.d3z]' ;


Para.rt = [Para.rt1 Para.rt2 Para.rt3] ;

%Thruster gains

Para.kt1 = 28.5    ;
Para.kt2 = 30    ;
Para.kt3 = 30    ;


%Thruster gain vectors

Para.Kt=[Para.kt1;Para.kt2;Para.kt3];

%Thruster time constants

Para.Tau1 = 0.4 ;
Para.Tau2 = 0.8 ;
Para.Tau3 = 0.8 ;


%Thruster time constant vectors

Para.Tau = [Para.Tau1;Para.Tau2;Para.Tau3] ;

% Mapping of thruster

Para.Eb_F = [0 1 1; 0 0 0; 1 0 0];
    
Para.Eb_M = [0 0 0; 0 0 0; 0 Para.d2y Para.d3y] ;

Para.Eb = [ Para.Eb_F ; Para.Eb_M ] ;

% Inverse Mapping of thruster
Para.Ebinv = pinv(Para.Eb) ;

end





 
           

