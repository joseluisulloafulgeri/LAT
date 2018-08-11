
first_point  = 56469.442;
lengthTotal = 63025 + 87400 + 401;
backbone = 0:1/25:lengthTotal/25 - 1/25;
newBigTime = bsxfun(@plus, backbone, first_point);
newBigTime = newBigTime';
Values = [data_804_A(:,2); NaN(401,1); data_804_B(:,2)];
BreathingfullData = [newBigTime Values];

%%
data_804_A = ECGfullData;
data_804_B = ECGfullData;
first_point  = 56469.442;
lengthTotal = 630250 + 874000 + 4010;
backbone = 0:1/250:lengthTotal/250 - 1/250;
newBigTime = bsxfun(@plus, backbone, first_point);
newBigTime = newBigTime';
Values = [data_804_A(:,2); NaN(4010,1); data_804_B(:,2)];
ECGfullData = [newBigTime Values];

%%
70721.447 - 70693.407;
28.0400*25/1000;

data_804_A = BreathingfullData;
data_804_B = BreathingfullData;
first_point  = 68157.447;
lengthTotal = 63400 + 96550 + 701;
backbone = 0:1/25:lengthTotal/25 - 1/25;
newBigTime = bsxfun(@plus, backbone, first_point);
newBigTime = newBigTime';
Values = [data_804_A(:,2); NaN(701,1); data_804_B(:,2)];
BreathingfullData = [newBigTime Values];

%%
data_804_A = ECGfullData;
data_804_B = ECGfullData;
first_point  = 68157.447;
lengthTotal = 634000 + 965500 + 7010;
backbone = 0:1/250:lengthTotal/250 - 1/250;
newBigTime = bsxfun(@plus, backbone, first_point);
newBigTime = newBigTime';
Values = [data_804_A(:,2); NaN(7010,1); data_804_B(:,2)];
ECGfullData = [newBigTime Values];

