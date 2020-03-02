%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% ASTE 421 Trade Study Script %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [total_price_min, number_sat, mass_sat] = sizeCraft(D)
t = 0.0127;         %Thickness of spacecraft wall [m]
Ra = 2700;          %Density of Aluminum [kg/m^3]
mh = 0.66;          %Mass of Hard drive [kg]
pkg = 50;           %Watts per kg of solar cell (taken from JPL)
p = 5.2;            %Power requirement per hard drive [w]
V = 12;             %Voltage requirement of hard drive
xh = 101.6/1000;    %x dimension of hard drive [m]
yh = 147/1000;      %y dimension of hard drive [m]
zh = 26.1/1000;     %z dimension of hard drive [m]
%D = 1e6;        %Total amount of data being stored [TB]
nH = D/14;          %Total number of hardrives in system (14 TB per drive)
beg = 1;            %lowest number of satellites in system
last = 10000;         %highest number of satellites in system
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
P = p * nh + sizeComm(i);          %Total power requirement per sat[w]


%Solar Cell
ms(i+1-beg) = (P)/pkg; %Mass of solar array per Satellite 


%%%%%%%%%%%%%%%%%%%%%%%%%% Radiator Sizing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mR(i + 1 - beg) = sizeRadiator(nH/i);

%%%%%%%%%%%%%%%%%%%%%% Propulsion System Sizing %%%%%%%%%%%%%%%%%%%%%%%%%%%
if (i>1)
mP(i + 1 - beg) = (1.25) * sizePropulsion(m(i+1-beg-1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Totals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mH = nH*mh;              %Total mass of all hard drives in system [kg]

%M(i+1-beg) = mH + mS(i+1-beg) + mA(i+1-beg) + mS(i+1-beg);
m(i+1-beg) = ms(i+1-beg) + mS(i+1-beg) + mR(i + 1-beg) + mP(i + 1-beg) + ma + mH/i;   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mP(1) = mP(2);
%% convertToCost
cost = zeros(size(m));
for i = 1:length(m)
    power_draw(i) = 10 * (nH/i)  +  sizeComm(i);
    cost(i) = 504 * (nH/i) + 89.59 * mP(i) ...
        + 400 * power_draw(i)^1.1 + 2 * 209 + 1e5 * m(i)/(m(i)^.8);
    cost_real(i) = 504 * (nH/i) + 400 * power_draw(i)^1.1 + 2 * 209 + 1e5 * m(i);
end
total_price = zeros(size(cost));
for i = 1:length(cost)
    total_price(i) = (i) * cost(i) + i * 1.3511e3 * m(i);
    total_price_real(i) = i * cost_real(i) + i * 1.3511e3 * m(i);
end
[minima,m_in] = min(total_price_real(10:end));
number_sat = m_in+10;
total_price_min = total_price_real(m_in);
mass_sat = m(m_in);
end
