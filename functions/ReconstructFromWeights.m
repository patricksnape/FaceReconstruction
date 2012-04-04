function [ nestimate, testimate ] = ReconstructFromWeights( XNavg, XTavg, Un, Ut, c, a )
%RECONSTRUCTFROMWEIGHTS Summary of this function goes here
%   Detailed explanation goes here

nestimate = XNavg + (Un * c);
nestimate = reshape2colvector(nestimate);
nestimate = bsxfun(@rdivide,nestimate, colnorm(nestimate));
nestimate = ColVectorToImage3(nestimate, 170, 150);

testimate = XTavg + (Ut * a);
testimate = ColVectorToImage(testimate, 170, 150);
testimate = testimate + abs(min(min(testimate)));
testimate = testimate / max(max(testimate));

end

