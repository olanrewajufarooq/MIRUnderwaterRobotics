function Para=Parameters()
global Para

%% Initial Speed and position in Earth-fixed frame

Para.ICPos = [0 0 2 0 0 0];
Para.ICSpeed = [0 0 0 0 0 0] ;

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



% Distances to the Body Centre of the Sparus

% The Main Body
Para.s(8).Rb = [0; 0; 0];
Para.s(9).Rb = [-(x8/2); 0; 0] + [-(x9/4); 0; 0];
Para.s(10).Rb = [(x8/2); 0; 0] + [(3/8*x10); 0; 0];

Para.S(0) = Para.s(8).Rb;

% The Thrusters
Para.S(1).Rb = [(x8/2 - 0.3/13.85*1.6); 0; -(z8/2)] + [-(x1/2); 0; -(z1/2)];
Para.S(2).Rb = [(x8/2 - 2.6/13.85*1.6); 0; -(z8/2)] + [-(x2/2); 0; -(z2/2)];
Para.S(3).Rb = [-(x8/2 - x1); (y8/2 + y1); 0] + [-(x3/2); y3/2; 0];
Para.S(4).Rb = [-(x8/2 - x1); -(y8/2 + y1); 0] + [-(x3/2); -y3/2; 0];

% The Antennas
Para.S(5).Rb = s(3).Rb + [-(x3/2 + x5/2); 0; 0];
Para.S(6).Rb = s(4).Rb + [-(x3/2 + x5/2); 0; 0];
Para.S(7).Rb = [-(x8/2 - 0.1040); 0; -(z8/2)] + [0; 0; -(z7/2)];

%% Body Mass matrices

% Calculating VOlume of Each Shape
Para.V = 0      ;           % The total volume of the sparus.

% Main Body
Para.S(8).V = pi * (y8/2)^2 * x8; % Cylinder
Para.S(9).V = 1/3 * pi * (y9/2)^2 * x9; % Cone
Para.S(10).V = 2/3 * pi * (y10/2)^2 * x10; % Hemi-ellipsoid

% The Thrusters
Para.S(1).V = pi * (x1/2)^2 * z1; % Cylinder
Para.S(2).V = pi * (x2/2)^2 * z2; % Cylinder
Para.S(3).V = pi * (y3/2)^2 * x3; % Cylinder
Para.S(4).V = s(3).V; % Cylinder

% The Antennas
Para.S(5).V = pi * (y5/2)^2 * x5; % Cylinder
Para.S(6).V = s(5).V; % Cylinder
Para.S(7).V = x7 * y7 * z7; % Cuboid

for i=1:length(s)
    Para.V = Para.V + Para.S(i).V;
end

Para.rho = Para.m / Para.V;            % Estimated Density of the Sparus

% Mass of Each Body
for i = 1:length(Para.S)
    Para.S(i).m = rho * Para.S(i).V;
end



% Inertia of Each Shape

% The Main Body
Para.S(8).I = [s(8).m*((y8/2)^2/2), 0, 0;
    0, s(8).m*( (y8/2)^2/4 + x8^2/12), 0;
    0, 0, s(8).m*( (z8/2)^2/4 + x8^2/12)]; % Cylinder

Para.S(9).I = s(9).m*[3/10 * (y9/2)^2, 0, 0;
    0, 3/20 * (y9/2)^2 + 3/80 * x9^2, 0;
    0, 0, 3/20 * (z9/2)^2 + 3/80 *x9^2]; % Cone
% Check the formula for cone inertia sensor here: 
% https://www.12000.org/my_courses/univ_wisconsin_madison/fall_2015/mechanics_311/HWs/HW9/HW9.pdf

Para.S(10).I = s(10).m * [1/5 * (y10/2) * (z10/2), 0, 0;
    0, 83/320 * (x10/2) * (z10/2), 0;
    0, 0, 83/320 * (x10/2) * (y10/2)]; % Hemi-ellipsoid
% Check the formula for the hemisphere inertia sensor here:
% https://physics.stackexchange.com/questions/93561/tensor-of-inertia
% The formula is adapted to the semi-ellipsoid

% The Thrusters
Para.S(1).I = [s(1).m*( (x1/2)^2/4 + z1^2/12), 0, 0;
    0, s(1).m*( (x1/2)^2/4 + z1^2/12), 0;
    0, 0, s(1).m*( (x1/2)^2/2)]; % Cylinder

Para.S(2).I = [s(2).m*( (x1/2)^2/4 + z1^2/12), 0, 0;
    0, s(2).m*( (x1/2)^2/4 + z1^2/12), 0;
    0, 0, s(2).m*( (x1/2)^2/2)]; % Cylinder

Para.S(3).I = [s(3).m*( (y3/2)^2/2), 0, 0;
    0, s(3).m*( (y3/2)^2/4 + x3^2/12), 0;
    0, 0, s(3).m*( (z3/2)^2/4 + x3^2/12)]; % Cylinder

Para.S(4).I = s(3).I; % Cylinder

% The Antennas
Para.S(5).I = [s(5).m*( (y5/2)^2/2), 0, 0;
    0, s(5).m*( (y5/2)^2/4 + x5^2/12), 0;
    0, 0, s(5).m*( (z5/2)^2/4 + x5^2/12)]; % Cylinder

Para.S(6).I = s(5).I; % Cylinder

Para.S(7).I = s(7).m/12 * [(y7^2 + z7^2), 0, 0;
    0, (x7^2 + z7^2), 0;
    0, 0, (x7^2 + y7^2)]; % Cuboid


% Mass Matrix of Each Body
for i = 1:length(Para.S)

    Para.S(i).Mb = -[Para.S(i).m*eye(3), zeros(3);
            zeros(3), Para.S(i).I];
end

%% Body added Mass matrices

% Main Body S0;
Para.S0.ma_u = 0;    % surge
Para.S0.ma_v = 0;    % sway
Para.S0.ma_w = 0;    % heave
Para.S0.ma_p = 0;    % roll
Para.S0.ma_q = 0;    % pitch
Para.S0.ma_r = 0;    % yaw

Para.S0.Ma = -diag([Para.S0.ma_u Para.S0.ma_v Para.S0.ma_w Para.S0.ma_p Para.S0.ma_q Para.S0.ma_r]) ; 

% First Body S1;
Para.S1.ma_u = 0;    % surge
Para.S1.ma_v = 0;    % sway
Para.S1.ma_w = 0;    % heave
Para.S1.ma_p = 0;    % roll
Para.S1.ma_q = 0;    % pitch
Para.S1.ma_r = 0;    % yaw

Para.S1.Ma = -diag([Para.S1.ma_u Para.S1.ma_v Para.S1.ma_w Para.S1.ma_p Para.S1.ma_q Para.S1.ma_r]) ; 

% Second Body S2;
Para.S2.ma_u = 0;    % surge
Para.S2.ma_v = 0;    % sway
Para.S2.ma_w = 0;    % heave
Para.S2.ma_p = 0;    % roll
Para.S2.ma_q = 0;    % pitch
Para.S2.ma_r = 0;    % yaw

Para.S2.Ma = -diag([Para.S2.ma_u Para.S2.ma_v Para.S2.ma_w Para.S2.ma_p Para.S2.ma_q Para.S2.ma_r]) ; 

%% Generalized mass matrix

Para.S0.Mg = Para.S0.Mb + Para.S0.Ma ; 
Para.S1.Mg = Para.S1.Mb + Para.S1.Ma ;
Para.S2.Mg = Para.S2.Mb + Para.S2.Ma ;

Para.Mg = Para.S0.Mg + Para.S1.Mg + Para.S2.Mg ;


%% Generalized coriolis matrix

% Computed in RovModel.m

%% Friction matrices

% Main Body S0;
Para.S0.kuu = 0;    % surge
Para.S0.kvv = 0;    % sway
Para.S0.kww = 0;    % heave
Para.S0.kpp = 0;    % roll
Para.S0.kqq = 0;    % pitch
Para.S0.krr = 0;    % yaw

Para.S0.Kq = -diag([Para.S0.kuu Para.S0.kvv Para.S0.kww Para.S0.kpp Para.S0.kqq Para.S0.krr]) ;    %Quadratic friction matrix

% First Body S1;
Para.S1.kuu = 0;    % surge
Para.S1.kvv = 0;    % sway
Para.S1.kww = 0;    % heave
Para.S1.kpp = 0;    % roll
Para.S1.kqq = 0;    % pitch
Para.S1.krr = 0;    % yaw

Para.S1.Kq = -diag([Para.S1.kuu Para.S1.kvv Para.S1.kww Para.S1.kpp Para.S1.kqq Para.S1.krr]) ;    %Quadratic friction matrix


% Second Body S1;
Para.S2.kuu = 0;    % surge
Para.S2.kvv = 0;    % sway
Para.S2.kww = 0;    % heave
Para.S2.kpp = 0;    % roll
Para.S2.kqq = 0;    % pitch
Para.S2.krr = 0;    % yaw

Para.S2.Kq = -diag([Para.S2.kuu Para.S2.kvv Para.S2.kww Para.S2.kpp Para.S2.kqq Para.S2.krr]) ;    %Quadratic friction matrix


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

Para.Eb_F = zeros(3,3);
    
Para.Eb_M = zeros(3,3)  ;

Para.Eb = [ Para.Eb_F ; Para.Eb_M ] ;

% Inverse Mapping of thruster
Para.Ebinv = pinv(Para.Eb) ;

end





 
           

