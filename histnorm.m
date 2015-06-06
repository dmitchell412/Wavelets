%The function make normalized histogram, i.e. the estimatino of the
%probability density function. The area of the histogram is equal one, such
%as the area bellow the theoretical PDF functin.
%You can you the output of this script to comparison of empirical data with
%the theoretical PDF for certain distribution.
%
%INPUTs:
%data - empirical data
%bins - number of the histogram bins
%view (optional) - 1 = plot the histogram to the figure, 0 = get only
%values (0 is default)
%
%OUTPUTs:
%h - the normallized "height" of the histogram bars
%x - centers of bins

function [h, x]=histnorm(data,bins,view)
    if nargin < 3
        view = 0;
    end
    [h, x] = hist(data,bins);
    step = abs(x(2) - x(1));
    area = sum(step*h);
    h = h/area;
    if view
        bar(x,h,'histc');
    end
    