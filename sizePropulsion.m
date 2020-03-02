function [Mp] = sizePropulsion(mass)
Cd=1.28;            %Assume that the frontal area is a flat plate
A=1;                %Cross sectional area [m^2]
h = 750;
Re=6378;            %Radius of Earth [km]
muearth=398600.440; %Gravitational Parameter [km^3/s^2]
Rorb = Re + h;
T=-131.21+0.00299*h*1000;
p=2.488*[(T+273.1)/216.6].^(-11.388);
rho=p./(.2869.*(T+273.1));

%Station Keeping
v=sqrt(muearth./(Rorb)) * 1000;
deltaV_drag=((Cd*A)/(2*mass)).*rho.*(v.^2).*788400000;

Pe=10132.5;       %Exhaust Pressure [Pa]
Pc=2.533e6;    %Chamber Static Pressure [Pa]
Tc=3180;        %Adiabatic Flame Temperature [K]
Mc=0.1;         %Chamber Mach Number
MR=1.75;        %Mixture Ratio
gamma=1.229;   %Ratio of Specific Heats
R=8314/21.01;   %Gas Molecular Weight
ge=9.81;        %Acceleration due to gravity
Astar=0.01^2*pi;    %Throat Area

To=Tc*[1+(gamma-1)/2*Mc^2];
Po=Pc*[1+(gamma-1)/2*Mc^2]^(gamma/(gamma-1));
Me=sqrt(((Po/Pe)^((gamma-1)/gamma)-1)*(2/(gamma-1)));
Arat=(1/Me)*[(2/(gamma+1))*(1+((gamma-1)/2)*Me^2)]^((gamma+1)/(2*(gamma-1)));

cstar=sqrt((1/gamma)*((gamma+1)/2)^((gamma+1)/(gamma-1))*R*To);
Cf=sqrt(((2*gamma^2)/(gamma-1))*(2/(gamma+1))^((gamma+1)/(gamma-1))*(1-(Pe/Po)^((gamma-1)/gamma)))+(Pe/Po)*(Arat);

Isp=(cstar*Cf)/ge;
mdot=Astar*((sqrt(gamma)*Po)/(sqrt(R)*To))*(1/([1+((gamma-1)/2)]^((gamma+1)/(2*(gamma-1)))));
Fth=mdot*cstar*Cf;

delta_V_tot = deltaV_drag + 25 * 10;
k=(1-exp(-delta_V_tot/(Isp*ge)));
Mp=(mass.*k)./(1-k);


end