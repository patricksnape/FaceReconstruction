rob1 = imread('data/images/rob1.ppm');
robaligned1 = AlignFace(rob1, 307, 254, 256, 422, 390, 310, 444, 387);
rob2 = imread('data/images/rob2.ppm');
robaligned2 = AlignFace(rob2, 307, 254, 256, 422, 390, 310, 444, 387);
rob3 = imread('data/images/rob3.ppm');
robaligned3 = AlignFace(rob3, 307, 254, 256, 422, 390, 310, 444, 387);
rob4 = imread('data/images/rob4.ppm');
robaligned4 = AlignFace(rob4, 307, 254, 256, 422, 390, 310, 444, 387);

rob(:, :, :, 1) = robaligned1;
rob(:, :, :, 2) = robaligned2;
rob(:, :, :, 3) = robaligned3;
rob(:, :, :, 4) = robaligned4;