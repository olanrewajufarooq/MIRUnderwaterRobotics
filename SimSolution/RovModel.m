function [AccG] = RovModel(Thrust,PosE,VitB)

global Para

%% Attitudes in earth frame
%z=PosE(3,1);
phi     = PosE(4,1)	;
theta   = PosE(5,1)	;

%% Gravity Force

Fg = 1* [-Para.P * sin(theta) ;
        Para.P * cos(theta)*sin(phi) ;
        Para.P * cos(theta)*cos(phi) ;
        0 ;
        0 ;
        0 ];
    
% Expressed in b and computed in G
    
%% Force d'Archim�de

Fa_F = [Para.B * sin(theta) ;
        -Para.B * cos(theta)*sin(phi) ;
        -Para.B * cos(theta)*cos(phi) ;
        ];
%  Expressed in b


Fa_M = S_(Para.rb-Para.rg) * Fa_F ; % Computed in G

Fa = [ Fa_F ; Fa_M ] ;
%  Expressed in b and computed in G

%% Force de Coriolis

r_gd = Para.S(1).Rb - Para.DVL;
Vg = my_H(r_gd) * VitB;


M11 = Para.Mg(1:3, 1:3); 
M21 = Para.Mg(4:6, 1:3);
M12 = Para.Mg(1:3, 4:6);
M22 = Para.Mg(4:6, 4:6); 

V1 = Vg(1:3);
V2 = Vg(4:6);

C = [zeros(3, 3), -S_(M11*V1 + M12*V2); 
    -S_(M11*V1 + M12*V2), -S_(M21*V1 + M22*V2)];

%coriolis Force :
Fc = C * Vg ;

%Fc = zeros(6, 1);

%% Friction forces


Fk = zeros(6, 1);
for i = 1:length(Para.S)
    r = Para.S(i).Rb - Para.DVL; %  not  the DVL pqrt,  has to be created
    VelB = my_H(r) * Vg;
    Fkb= -Para.S(i).K * abs(VelB).*VelB;

    Fkg = my_H(Para.S(i).Rb)' * Fkb;

    Fk = Fk + Fkg;
    
end; clear i r VelB Fkb Fkg

%% Propulsions Forces
Fp = Para.Eb * Thrust ;

%% Accelearion computation (Testing the Simulator):
AccG = Para.Mg\ ( Fk +Fa + Fg+ Fp + Fc) ; % Mg\ = Mg^-1 computed at the gravity center of the Sparus

%% Imposing Linear Acceleration.
%AccG = Para.Mg \ Fp;


%% Imposing Linear Speed (Not Solved Yet)
%{
AccG = Para.Mg \ Fp;
%}

