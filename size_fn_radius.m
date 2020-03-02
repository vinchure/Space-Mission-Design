%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% ASTE 421 Trade Study Script %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [num_sats] = size_fn_radius(h)
%%%%%%%%%%%%%%%% Initial Conditions and Constants %%%%%%%%%%%%%%%%%%%%%%%%%
t = 0.0127;         %Thickness of spacecraft wall [m]
Ra = 2700;          %Density of Aluminum [kg/m^3]
mh = 0.66;          %Mass of Hard drive [kg]
pkg = 50;           %Watts per kg of solar cell (taken from JPL)
p = 8.4;            %Power requirement per hard drive [w]
V = 12;             %Voltage requirement of hard drive
xh = 101.6/1000;    %x dimension of hard drive [m]
yh = 147/1000;      %y dimension of hard drive [m]
zh = 26.1/1000;     %z dimension of hard drive [m]
D = 1000000;        %Total amount of data being stored [TB]
nH = D/14;          %Total number of hardrives in system (14 TB per drive)
beg = 1;            %lowest number of satellites in system
last = 100000;         %highest number of satellites in system
vh = (xh*yh*zh);    %Total volume of one hard drive [m^3]
ma = 15;            %Antenna mass (constant) [kg]
mP(1) = 0;                                       
for i = beg:last
%%%%%%%%%%%%%%%%%%%%%%%% Structural Sizing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nh = nH/i;                  %Total number of hard drives per satellite
V = vh*nh;                  %Total volume of hard drives per satellite
S = V^(1/3);%Side length of satellite bus required
mS(i+1-beg) = Ra*4*(S^2*t); %Mass of satellite bus [kg]
     

%%%%%%%%%%%%%%%%%%%%%%%% Power System Sizing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = p*i;          %Total power requirement for all hard drives on board [w]


%Solar Cell
ms(i+1-beg) = (nh*p+25)/pkg; %Mass of solar array per Satellite 


%%%%%%%%%%%%%%%%%%%%%%%%%% Radiator Sizing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mR(i + 1 - beg) = sizeRadiator(nH/i);

%%%%%%%%%%%%%%%%%%%%%% Propulsion System Sizing %%%%%%%%%%%%%%%%%%%%%%%%%%%
if (i>1)
mP(i + 1 - beg) = (1.25) * sizePropulsion(m(i+1-beg));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Totals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mH = nH*mh;                  %Total mass of all hard drives in system [kg]
mS(i+1-beg) = ms(i+1-beg)*i; %Mass of all the satellites
mA(i+1-beg) = ma*i;          %Mass of all the Antennas 
mS(i+1-beg) = mS(i+1-beg);   %Mass of all solar arrays in system
M(i+1-beg) = mH + mS(i+1-beg) + mA(i+1-beg) + mS(i+1-beg);
m(i+1-beg) = M(i+1-beg)/i + mR(i + 1-beg) + mP(i + 1-beg) + ma;   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% convertToCost
cost = zeros(size(m));
for i = 1:length(m)
    cost(i) = 504 * (nH/i) + 60000 * 3 + 250.6382 * ms(i) + 11000 + 15000 + ...
       70000 + 400 * 10 * (nH/i) * sizeComm(i)  + 2 * 209 + 1e5;
   power_draw(i) = 10 * (nH/i) * sizeComm(i);
end
total_price = zeros(size(cost));
for i = 1:length(cost)
    total_price(i) = (i) * cost(i) + i * 2.3511e3 * m(i);
end

final_price = total_price(end);
cut_off_price = 0.95 * final_price;
final_sats = 0;
for i = 1:length(total_price)
    if abs(total_price(i) - cut_off_price) < 1e2
        final_sats = i;
        break
    end
end
