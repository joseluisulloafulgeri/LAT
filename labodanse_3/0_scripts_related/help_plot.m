
plotStart = 216240;
plotEnd = 271685;

targetSec1 = 210;
points1 = targetSec1*25;

targetSec2 = 210.5;
points2 = targetSec2*25;

targetSec3 = 230;
points3 = targetSec3*25;

figure, plot(FileStruct.data(216240:225000, 1:3))
hold on
plot([points1 points1], get(gca,'ylim'), 'Color', [0.5 0.5 0.5]);  hold on % horizontal line around zero
hold on
plot([points2 points2], get(gca,'ylim'), 'Color', [0.5 0.5 0.5]);  hold on % horizontal line around zero
hold on
plot([points3 points3], get(gca,'ylim'), 'Color', [0.5 0.5 0.5]);  hold on % horizontal line around zero
