function[tPower] = sizeComm(num_sats)
    
    bc = 1.3086e-23;
    bw = 15e9;
    r_o = 5.6e9 * 3;
    b_temp = 2.73;
    n0 = b_temp * bc;
    R = (r_o * 2)/num_sats;
    E_b = (n0 * bw/R)*((2^(R/(.9 * bw))) - 1);
    Ll = 0.8;
    eta = 0.9;
    antenna_d = 5;
    lambda = 1/bw;
    d = sqrt((6378 + 750)^2 + 42164^2) * 1000;
    antenna_gain = (pi * antenna_d/lambda)^2;
    L_s = 1.54332e-38;
    tPower = (E_b * R/n0)/(Ll*eta*antenna_gain^2*L_s);
end