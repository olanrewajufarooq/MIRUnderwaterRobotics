function [AccG] = RovModel(Thrust,PosE,VitB)

global Para




%% Attitudes in earth frame
% z=PosE(3,1);
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
    
%% Force d'Archimède

Fa_F = [Para.B * sin(theta) ;
        -Para.B * cos(theta)*sin(phi) ;
        -Para.B * cos(theta)*cos(phi) ;
        ];
%  Expressed in b


Fa_M = S_(Para.rb-Para.rg) * Fa_F ; % Computed in G

Fa = [ Fa_F ; Fa_M ] ;
%  Expressed in b and computed in G

%% Force de Coriolis

r_gb =  Para.S(0).Rb - Para.DVL
Vg = my_H(r_gb) * VitB;

p = VitB(4,1)   ;   %Body fixed velocity roll (rad*s^(-1))
q = VitB(5,1)   ;   %Body fixed velocity pitch (rad*s^(-1))
r = VitB(6,1)   ;   %Body fixed velocity yaw (rad*s^(-1))
W_ = [p;q;r]     ;  %General vector

% Wb :
Wb = [  S_(W_)       zeros(3,3) ;
        zeros(3,3)      S_(W_)       ];

% General coriolis matrix :
C_all = Wb * Para.Mg ;

%coriolis Force :
Fc = C_all * VitB ;

%% Friction forces


r = r_bi - r_D;
Vit_0=H(r)*VitB;
Ff_0_b =  Para.S0.Kq * abs(Vit_0).*Vit_0 ;
Ff_0_g = H' * Ff_0_b;

Vit_1=VitB;
Ff_1 =  Para.S1.Kq * abs(Vit_1).*Vit_1 ;

Vit_2=VitB;
Ff_2 =  Para.S0.Kq * abs(Vit_2).*Vit_2 ;

%% Propulsions Forces
Fp = Para.Eb * Thrust ;

%% Accelearion computation :
AccG = Para.Mg\ (Ffriction +Fa + Fg+ Fp- Fc) ; % Mg\ = Mg^-1 computed at the gravity center of the Sparus
