[n1, xout1] = hist(y1,x1);
bar(xout1,n1,'r'); grid; hold
[n2, xout2] = hist(y2,x2);
bar(xout2,n2,'g');

    for i_plot = 2:length(indivData)
        stringPlot = sprintf('hist(indivIBIintervData{%d}, 100);', i_plot);
        eval(stringPlot)
        hold on
    end
    
    h = findobj(gca,'Type','patch');
    display(h)
    
    for i_plot = 1:length(indivData)
        stringPlot = sprintf('set(h(%s),\''FaceColor\'',colors(%s,:),\''EdgeColor\'',\''k\'')', i_plot, i_plot);
    end
   
%     stringPlot2 = sprintf('histplot_%d = findobj(gca,\''Type\'',\''patch\'');', i_plot);
%     eval(stringPlot2)
% 
%     stringPlot3 = sprintf('set(histplot_%d,\''FaceColor\'',colors(i_plot,:))', i_plot);
%     eval(stringPlot3)