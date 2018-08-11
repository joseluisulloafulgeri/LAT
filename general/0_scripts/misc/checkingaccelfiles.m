
%  checkingaccelfiles.m
%  to visualize the accelerometer bioharness files

Accel = importaccelfile('');

figure
subplot(3,1,1)
plot (cell2mat(Accel(2:end, 2)))
subplot(3,1,2)
plot (cell2mat(Accel(2:end, 3)))
subplot(3,1,3)
plot (cell2mat(Accel(2:end, 4)))
tightfig