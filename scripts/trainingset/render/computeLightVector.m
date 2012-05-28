function  [lightVector] = computeLightVector(iotaArray)

    %   UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    lightVector = zeros(4, 1);
    lightVector(1) = cos(iotaArray(15)) * sin(iotaArray(14));
    lightVector(2) = sin(iotaArray(15));
    lightVector(3) = cos(iotaArray(15)) * cos(iotaArray(14));
    
    lightVector = normc(lightVector);

end

