function output = rescale_mine(input,maxi,mini,newmax)
 
    output = (input - mini)*newmax/(maxi - mini);
