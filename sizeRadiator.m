function [mR] = sizeRadiator(i)   
qSolar = 1450; % W/m^2, heat flux of the sun at our distance (hot case)
    qIR = 375; %W/m^2, IR heat flux in our orbit
    qAlb = 368; %W/m^2, Heat flux from albedo/reflected radiation from earth
    %Verified values
    rho = 5; %kg/m^2 (average weight of deployable radiators)
    epsilon = .9; %based on magnesium oxide alumin oxide paint
    alphaBOL = 0.08;
    alphaEOL = 0.09;
    sigma = 5.6703e-8; %steffan-boltzmann constant
    qextBOL = alphaBOL*(qSolar + qIR + qAlb); %cold case
    qextEOL = alphaEOL*(qSolar + qIR + qAlb); %hot case
    QintMax1 = 7 * i; %W, low estimate
    QintMax2 = 10* i; %W, high estimate
    %Operational temperatures
    TOpMin = 5 + 273.15; %K
    TOpMax = 60 + 273.15; %K
    TNonopMin = -40 + 273.15; %K
    TNonopMax = 70 + 273.15; %K
   
    TAFTmin = TNonopMin + 10; %cold case
    TAFTmax = TOpMax - 10; %hot case
    
    %Sizing calculations (hot case)
    Arad1 = QintMax1/(epsilon*sigma*TAFTmax^4 - qextEOL); %low estimate
    Arad2 = QintMax2/(epsilon*sigma*TAFTmax^4 - qextEOL); %high estimate
   
    M1 = Arad1*rho;
    M2 = Arad2*rho;
    mR = (M1 + M2)/2;
    
end