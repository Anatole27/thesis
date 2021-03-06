%Missile structure and aerodynamic
%% n-rodes
n = 10;

%% Mass
dart_mass = 140;
dart_length = 2.7;
booster_mass = 210;
booster_length = 2.2;
mass = booster_mass+dart_mass;
total_length = dart_length + booster_length;
dm = zeros(n,1);
dl = total_length/n;
dm_dart = dart_mass/dart_length*dl;
dm_booster = booster_mass/booster_length*dl;

% Apply dm regarding the part of the rocket
for i = 1:n
    if (i-1/2)*dl < booster_length
        dm(i) = dm_booster; % booster mass
    else
        dm(i) = dm_dart; % dart mass
    end
end

dm = dm/sum(dm)*mass; % Adjust mass to total mass
%dm = ones(length(dm),1)*mean(dm);

%% Moment of inertia /z-axis

dI = 1/12*dm*dl^2;

%% Stiffness

D_booster = 0.36;
d_booster = 0.34;
D_dart = 0.18;
d_dart = 0.16;
E = 70*10^9; % Aluminium

I_booster = pi*(D_booster^4-d_booster^4)/64;
I_dart = pi*(D_dart^4-d_dart^4)/64;

I_struct = zeros(n-1,1);
% Apply I_struct regarding the part of the rocket
for i = 1:n-1
    if i*dl < booster_length
        I_struct(i) = I_booster; % booster mass
    else
        I_struct(i) = I_dart; % dart mass
    end
end

k = E*I_struct/dl;
%k = ones(length(k),1)*mean(k);

%% Lift (check excel file)

Hp = 0; %pressure alt, feet
rho = 1.21; % Altitude 0
M = 2; %Mach
r = 287;
T = 15 + 273.15 - 2*Hp/1000; % ISA
gamma = 1.4;
Vx = M*sqrt(gamma*r*T);
q = 1/2*rho*Vx^2;
chord_booster = 0.55;
chord_fins = 0.16;
chord_dart = 0.95;
wingspan_booster = 0.93;
wingspan_fins = 0.62;
wingspan_dart = 0.49;
lambda_booster = wingspan_booster/chord_booster;
lambda_fins = wingspan_fins/chord_fins;
lambda_dart = wingspan_dart/chord_dart;
qSCLa_booster = q*pi*wingspan_booster^2/2*dl/chord_booster;
qSCLa_fins = q*pi*wingspan_fins^2/2*dl/chord_fins;
qSCLa_dart = q*pi*wingspan_dart^2/2*dl/chord_dart;

qSCLa = zeros(n,1);
for i = 1:n
    if (i-1/2)*dl > 0.15 && (i-1/2)*dl < 0.15+chord_booster
        qSCLa(i) = qSCLa_booster;
    end
    if (i-1/2)*dl > 1.9 && (i-1/2)*dl < 1.9+chord_fins
        qSCLa(i) = qSCLa_fins;
    end
    if (i-1/2)*dl > 2.4 && (i-1/2)*dl < 2.4+chord_dart
        qSCLa(i) = qSCLa_dart;
    end
end
