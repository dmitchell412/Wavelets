% Slice display function

function [] = slicedisp(x)

map=gray;%(90);
idxImages=1:round(size(x,3)/9):size(x,3);
%figure('DefaultAxesXTick',[],'DefaultAxesYTick',[],'DefaultAxesFontSize',8,'Color','w')
colormap(map)
for k=1:9
    j=idxImages(k);
    subplot(3,3,k);
    image(x(:,:,j));
    xlabel(['Z = ' int2str(j)]);
    if k==2
        title('Some slices along the Z-orientation of the reconstructed brain data');
    end
end
